#!/usr/bin/env python3
"""Outcome-blind supervisor for the 32-shard neutral-calibration v2 batch.

History: v1 of this orchestrator (commit b3ba1aa) implemented the 2026-09-02
plan amendment (docs/neutral_calibration_orchestrator_plan_amendment.md).  It
was bypassed from 2026-09-11 by ad hoc watchdogs and an unreviewed runner
modification.  This v3 (2026-09-27, Ben Telegram msg 7019 "fix the watchdog
and replace it with an actually working persistent subagent") restores the
amendment rules and adds the guards documented in
docs/neutral_calibration_v2_batch_integrity_review_20260927.md:

- identity preflight before ANY launch: frozen v2 runner script hash
  (423e2862...), PeTTa commit / run.sh / main.pl hashes, PeTTa tracked tree
  clean, MORK FFI absent, pinned SWI-Prolog 9.3.36, neutral source hashes.
  Any mismatch blocks every launch and raises an alert.
- head-of-line safety: a frozen/failed/invalid/interrupted seed never blocks
  eligible seeds.
- failure surfacing: status transitions are appended to ALERTS.jsonl with the
  last error line of the runner lifecycle log (never raw stdout/stderr).
- non-protocol artifacts (SKIP.json, nonzero receipts, missing ATTEMPT.json)
  classify an attempt as INVALID; it is never resumed.
- fresh attempts (attempt N+1, row zero, unchanged manifest and identities)
  are launched only for seeds with a recorded, unconsumed authorization in
  orchestrator_state.json ("authorized_fresh").  Interrupted clean-prefix
  attempts are resumed only through --review-resume SEED, which performs the
  documented review action (identity re-verification + synthetic gate +
  metadata prefix check) and writes a review record first.
- at most 3 concurrent shards (amendment allows 4; raise only with memory
  evidence), MemAvailable >= 2 GiB launch guard, niced, CPU0 excluded.
- stall alert when a running shard publishes no receipt for > 6 h.
- BATCH_DONE when all 32 seeds have a validated raw-complete-unanalysed
  attempt.  No analysis is ever launched.  No endpoint content is opened.
"""

from __future__ import annotations

import argparse
import fcntl
import hashlib
import json
import os
import re
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
V1_ROOT = ROOT / "experiments" / "neutral_calibration_v1"
V2_ROOT = ROOT / "experiments" / "neutral_calibration_v2"
STATE_PATH = V2_ROOT / "orchestrator_state.json"
ORCH_LOG = V2_ROOT / "orchestrator.log"
ALERTS_PATH = V2_ROOT / "ALERTS.jsonl"
LOCK_PATH = V2_ROOT / ".orchestrator.lock"
REVIEWS_DIR = V2_ROOT / "reviews"

# Pinned clean PeTTa clone at the frozen commit (identity review R1 in
# docs/neutral_calibration_v2_batch_integrity_review_20260927.md).  run.sh and
# main.pl hashes are identical to the frozen launch review; the shared
# omegaclaw checkout has carried an uncommitted src/metta.pl edit since
# 2026-09-08 and is no longer used for this batch.
PETTA_ROOT = Path("/home/openclaw/research-agent/projects/petta-chem/repos/PeTTa-pinned-4ce1d0ea")
RUNNER = str(PETTA_ROOT / "run.sh")
SOURCE_COMMIT = "4b7c6de4ec8eb71502588d2714579c7d55d4bd50"
PETTA_COMMIT = "4ce1d0ea58855abb772b911278312c8846e5cc08"
RUN_SH_SHA256 = "b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae"
MAIN_PL_SHA256 = "cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c"
V2_RUNNER_SCRIPT = ROOT / "scripts" / "run_neutral_calibration_shard_v2.py"
V2_RUNNER_SCRIPT_SHA256 = "423e2862d650389057bd4f7fdd0821d6666fa75fcc57a2a9a13dc0080fe8d09d"
SOURCE_HASHES = {
    "src/chem_neutral_ssa.metta": "ebdcf0449bd783cab6c924f1c455d51141d1d74ff59251237a5e7596908f2ca3",
    "src/chem_neutral_raf.metta": "0ed75203fff2b9d31c0dac054290aeb5c29fac890ddcda13be6af528c0b26073",
}
RUNTIME_IDENTITY = (
    "petta=4ce1d0ea58855abb772b911278312c8846e5cc08;"
    "run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;"
    "main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;"
    "swipl=9.3.36-x86_64-linux;mork_ffi=absent"
)
SWIPL_BIN = "/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin"
SWIPL_VERSION_LINE = "SWI-Prolog version 9.3.36 for x86_64-linux"

FIRST_SEED = 1001
LAST_SEED = 1032
MAX_SLOTS = 3
PLANNED_ROWS = 276
MIN_FREE_GIB = 2.0
STALL_SECONDS = 6 * 3600
NICE = 10
CPU_LIST = "1-7"  # CPU0 excluded (keeps gateway/UI responsive)
RECEIPT_SCHEMA = "neutral-calibration-row-receipt-v2"
ATTEMPT_RE = re.compile(r"^attempt-(\d{3})$")

ALERT_KINDS = {
    "complete-validated", "validation-failed", "failed", "invalid", "interrupted",
    "stall", "identity-preflight-failed", "launch-error", "batch-done",
    "launch-deferred-low-memory", "review-resume-refused",
}


def now() -> str:
    return datetime.now(timezone.utc).isoformat()


def log(message: str) -> None:
    line = f"{now()} {message}"
    print(line)
    with ORCH_LOG.open("a", encoding="utf-8") as handle:
        handle.write(line + "\n")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


# ---------------------------------------------------------------- state

def load_state() -> dict:
    state = json.loads(STATE_PATH.read_text(encoding="utf-8")) if STATE_PATH.exists() else {}
    state.setdefault("schema", "neutral-orchestrator-state-v3")
    for key in ("validated", "last_status", "authorized_fresh", "consumed", "stall_alerted"):
        state.setdefault(key, {})
    state.setdefault("events", [])
    return state


def save_state(state: dict) -> None:
    tmp = STATE_PATH.with_name(STATE_PATH.name + ".tmp")
    tmp.write_text(json.dumps(state, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    os.replace(tmp, STATE_PATH)


def record_event(state: dict, kind: str, detail: dict) -> None:
    event = {"utc": now(), "kind": kind, **detail}
    state["events"].append(event)
    state["events"] = state["events"][-500:]
    if kind in ALERT_KINDS:
        with ALERTS_PATH.open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(event, sort_keys=True) + "\n")


# ------------------------------------------------------------ attempts

def attempts_for(seed: int) -> list[Path]:
    """Canonical attempt directories only (attempt-NNN); renamed/stale
    directories such as attempt-002.stale-* are provenance, not attempts."""
    seed_dir = V2_ROOT / f"graph-seed-{seed}"
    if not seed_dir.is_dir():
        return []
    return sorted(p for p in seed_dir.iterdir() if p.is_dir() and ATTEMPT_RE.match(p.name))


def next_attempt_no(seed: int) -> int:
    """Highest attempt number used by ANY attempt-like name (incl. stale) + 1."""
    seed_dir = V2_ROOT / f"graph-seed-{seed}"
    used = [0]
    if seed_dir.is_dir():
        for p in seed_dir.iterdir():
            m = re.match(r"^attempt-(\d{3})", p.name)
            if m:
                used.append(int(m.group(1)))
    return max(used) + 1


def attempt_no(attempt_dir: Path) -> int:
    return int(ATTEMPT_RE.match(attempt_dir.name).group(1))


def session_name(seed: int, number: int) -> str:
    return f"petta-neutral-v2-g{seed}-a{number:03d}"


def failed_summary(attempt_dir: Path) -> dict:
    try:
        failed = json.loads((attempt_dir / "FAILED.json").read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        failed = {}
    return {k: failed.get(k) for k in ("exit_code", "row_id", "row_index", "failed_utc")}


def receipt_files(attempt_dir: Path) -> list[Path]:
    receipts = attempt_dir / "receipts"
    if not receipts.is_dir():
        return []
    return sorted(p for p in receipts.iterdir() if p.suffix == ".json")


def receipt_count(attempt_dir: Path) -> int:
    return len(receipt_files(attempt_dir))


def protocol_violations(attempt_dir: Path) -> list[str]:
    """Metadata-only detection of artifacts the frozen v2 runner never writes."""
    problems: list[str] = []
    if not (attempt_dir / "ATTEMPT.json").is_file():
        problems.append("ATTEMPT.json missing")
    raw = attempt_dir / "raw"
    if raw.is_dir():
        skips = [p.name for p in raw.iterdir() if p.name.endswith(".SKIP.json")]
        if skips:
            problems.append(f"{len(skips)} SKIP.json file(s) (row skipping is not in the frozen protocol)")
    for path in receipt_files(attempt_dir):
        try:
            receipt = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            problems.append(f"receipt {path.name} unreadable")
            continue
        if receipt.get("exit_code") != 0:
            problems.append(f"nonzero receipt {path.name} exit_code={receipt.get('exit_code')}")
    if list(attempt_dir.glob("RUN_MANIFEST.json.*")):
        problems.append("renamed RUN_MANIFEST.json.* present")
    return problems


def runner_log_error(seed: int, attempt_dir: Path) -> str | None:
    """Last error-looking line of the runner lifecycle log (the runner's own
    stderr: tracebacks; PeTTa stdout/stderr go to raw/ and are never read)."""
    path = V2_ROOT / f"graph-seed-{seed}" / f"{attempt_dir.name}.runner.log"
    if not path.is_file():
        return None
    try:
        with path.open("rb") as handle:
            handle.seek(max(0, path.stat().st_size - 8192))
            tail = handle.read().decode("utf-8", "replace").splitlines()
    except OSError:
        return None
    for line in reversed(tail):
        if re.search(r"(Error|Exception|Traceback|invalidated|Killed)", line):
            return line.strip()[:240]
    return None


def process_alive_for(attempt_dir: Path) -> bool:
    """A shard runner process whose argv names this attempt dir."""
    try:
        rel = str(attempt_dir.relative_to(ROOT))
    except ValueError:
        rel = str(attempt_dir)
    result = subprocess.run(
        ["pgrep", "-f", f"run_neutral_calibration_shard_v2.py .*--attempt-dir {re.escape(rel)}( |$)"],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
    )
    return result.returncode == 0


def tmux_session_alive(name: str) -> bool:
    result = subprocess.run(["tmux", "has-session", "-t", f"={name}"],
                            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return result.returncode == 0


def is_live(seed: int, attempt_dir: Path) -> bool:
    return process_alive_for(attempt_dir) or tmux_session_alive(session_name(seed, attempt_no(attempt_dir)))


def validate_completed_attempt(attempt_dir: Path) -> list[str]:
    """Metadata-only validation of a completed attempt. Returns problems."""
    problems: list[str] = []
    try:
        run_manifest = json.loads((attempt_dir / "RUN_MANIFEST.json").read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        return [f"RUN_MANIFEST unreadable: {exc}"]
    if run_manifest.get("schema") != "neutral-calibration-raw-shard-v2":
        problems.append("RUN_MANIFEST schema mismatch")
    if run_manifest.get("status") != "raw-complete-unanalysed":
        problems.append(f"unexpected RUN_MANIFEST status {run_manifest.get('status')}")
    if run_manifest.get("skipped_rows"):
        problems.append(f"RUN_MANIFEST lists {len(run_manifest['skipped_rows'])} skipped rows")
    if (run_manifest.get("completed_run_count") != PLANNED_ROWS
            or run_manifest.get("planned_run_count") != PLANNED_ROWS):
        problems.append(f"run counts {run_manifest.get('completed_run_count')}/"
                        f"{run_manifest.get('planned_run_count')} != {PLANNED_ROWS}")
    if run_manifest.get("source_commit") != SOURCE_COMMIT:
        problems.append("source_commit mismatch")
    if run_manifest.get("runtime_identity") != RUNTIME_IDENTITY:
        problems.append("runtime_identity mismatch")
    if run_manifest.get("runner_sha256") not in (None, RUN_SH_SHA256):
        problems.append("runner_sha256 mismatch")
    problems.extend(p for p in protocol_violations(attempt_dir) if not p.startswith("nonzero"))

    receipts = receipt_files(attempt_dir)
    if len(receipts) != PLANNED_ROWS:
        problems.append(f"receipt count {len(receipts)} != {PLANNED_ROWS}")
        return problems
    if isinstance(run_manifest.get("receipt_sha256"), list):
        if run_manifest["receipt_sha256"] != [sha256(p) for p in receipts]:
            problems.append("RUN_MANIFEST receipt_sha256 list mismatch")

    indices = []
    for receipt_path in receipts:
        try:
            receipt = json.loads(receipt_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            problems.append(f"receipt {receipt_path.name} unreadable: {exc}")
            continue
        if receipt.get("schema") != RECEIPT_SCHEMA:
            problems.append(f"receipt {receipt_path.name} schema mismatch")
            continue
        if receipt.get("exit_code") != 0:
            problems.append(f"receipt {receipt_path.name} exit_code={receipt.get('exit_code')}")
        if receipt.get("source_commit") != SOURCE_COMMIT:
            problems.append(f"receipt {receipt_path.name} source_commit mismatch")
        if receipt.get("runtime_identity") != RUNTIME_IDENTITY:
            problems.append(f"receipt {receipt_path.name} runtime_identity mismatch")
        indices.append(receipt.get("index"))
        for key in ("query", "stdout", "stderr"):
            rel = receipt.get(key)
            digest = receipt.get(f"{key}_sha256")
            if not isinstance(rel, str) or not isinstance(digest, str):
                problems.append(f"receipt {receipt_path.name} missing {key} hash fields")
                continue
            target = (V1_ROOT / attempt_dir.parent.name / rel) if key == "query" else (attempt_dir / rel)
            if not target.is_file():
                problems.append(f"receipt {receipt_path.name} missing file {key}={rel}")
                continue
            if sha256(target) != digest:
                problems.append(f"receipt {receipt_path.name} {key} sha256 mismatch")
    if indices != list(range(PLANNED_ROWS)):
        problems.append("receipt indices not contiguous 0..275")
    return problems


def classify_attempt(seed: int, attempt_dir: Path, live=is_live) -> tuple[str, dict]:
    """Status of one canonical attempt from metadata only."""
    if live(seed, attempt_dir):
        return "running", {"receipts": receipt_count(attempt_dir)}
    if (attempt_dir / "FAILED.json").exists():
        return "failed", failed_summary(attempt_dir)
    if (attempt_dir / "RUN_MANIFEST.json").exists():
        problems = validate_completed_attempt(attempt_dir)
        if problems:
            return "complete-invalid", {"problems": problems[:10]}
        return "complete-validated", {}
    violations = protocol_violations(attempt_dir)
    if violations:
        return "invalid", {"problems": violations[:10], "receipts": receipt_count(attempt_dir)}
    return "interrupted", {"receipts": receipt_count(attempt_dir)}


def classify_seed(seed: int, live=is_live, validated: dict | None = None) -> tuple[str, Path | None, dict]:
    """A seed is complete if ANY canonical attempt validates (e.g. g1003
    attempt-002); otherwise its NEWEST canonical attempt governs.  Older
    failed/invalid attempts never block a seed."""
    attempts = attempts_for(seed)
    if not attempts:
        return "unstarted", None, {}
    validated = validated or {}
    for attempt_dir in attempts:
        if f"g{seed}/{attempt_dir.name}" in validated and (attempt_dir / "RUN_MANIFEST.json").exists():
            return "complete-validated", attempt_dir, {"cached": True}
    newest = attempts[-1]
    status, info = classify_attempt(seed, newest, live)
    if status != "complete-validated":
        for attempt_dir in attempts[:-1]:
            if (attempt_dir / "RUN_MANIFEST.json").exists() and not validate_completed_attempt(attempt_dir):
                return "complete-validated", attempt_dir, {}
    return status, newest, info


def last_progress_ts(attempt_dir: Path) -> float:
    stamps = [p.stat().st_mtime for p in receipt_files(attempt_dir)]
    if not stamps and (attempt_dir / "ATTEMPT.json").exists():
        stamps.append((attempt_dir / "ATTEMPT.json").stat().st_mtime)
    return max(stamps) if stamps else 0.0


# ------------------------------------------------------------ identity

def _git(*args: str, cwd: Path) -> str:
    return subprocess.run(["git", *args], cwd=cwd, capture_output=True, text=True, check=False).stdout


def identity_preflight() -> list[str]:
    """Recompute every frozen identity; any problem blocks all launches."""
    problems: list[str] = []
    try:
        if sha256(V2_RUNNER_SCRIPT) != V2_RUNNER_SCRIPT_SHA256:
            problems.append("v2 runner script sha256 != frozen 423e2862")
        for rel, digest in SOURCE_HASHES.items():
            if sha256(ROOT / rel) != digest:
                problems.append(f"{rel} sha256 mismatch")
        if sha256(Path(RUNNER)) != RUN_SH_SHA256:
            problems.append("PeTTa run.sh sha256 mismatch")
        if sha256(PETTA_ROOT / "src" / "main.pl") != MAIN_PL_SHA256:
            problems.append("PeTTa src/main.pl sha256 mismatch")
    except OSError as exc:
        problems.append(f"identity file unreadable: {exc}")
    if _git("rev-parse", "HEAD", cwd=PETTA_ROOT).strip() != PETTA_COMMIT:
        problems.append("PeTTa HEAD != 4ce1d0ea")
    if _git("status", "--porcelain", "--untracked-files=no", cwd=PETTA_ROOT).strip():
        problems.append("PeTTa tracked tree dirty")
    if (PETTA_ROOT / "mork_ffi").exists():
        problems.append("MORK FFI present (must be absent)")
    try:
        out = subprocess.run([f"{SWIPL_BIN}/swipl", "--version"], capture_output=True, text=True,
                             timeout=30).stdout.strip()
    except (OSError, subprocess.TimeoutExpired):
        out = ""
    if out != SWIPL_VERSION_LINE:
        problems.append(f"swipl version mismatch: {out!r}")
    return problems


def synthetic_gate() -> list[str]:
    """The focused durable-v2 synthetic gate (review action prerequisite)."""
    result = subprocess.run(["sh", str(ROOT / "scripts" / "test_run_neutral_calibration_shard_v2.sh")],
                            cwd=ROOT, capture_output=True, text=True, timeout=900)
    return [] if result.returncode == 0 else [f"synthetic gate rc={result.returncode}"]


def free_gib() -> float:
    meminfo = Path("/proc/meminfo").read_text(encoding="utf-8")
    kb = next(int(line.split()[1]) for line in meminfo.splitlines() if line.startswith("MemAvailable:"))
    return kb / (1024 * 1024)


# -------------------------------------------------------------- launch

def launch_command(seed: int, number: int) -> list[str]:
    rel_attempt = f"experiments/neutral_calibration_v2/graph-seed-{seed}/attempt-{number:03d}"
    inner = (
        f"cd {ROOT} && exec nice -n {NICE} taskset -c {CPU_LIST} env PATH={SWIPL_BIN}:/usr/bin:/bin "
        f"python3 scripts/run_neutral_calibration_shard_v2.py "
        f"--shard-dir experiments/neutral_calibration_v1/graph-seed-{seed} "
        f"--runner {RUNNER} "
        f"--attempt-dir {rel_attempt} "
        f"--attempt-id neutral-v2-g{seed}-a{number:03d} "
        f"--source-commit {SOURCE_COMMIT} "
        f'--runtime-identity "{RUNTIME_IDENTITY}" '
        f">> {rel_attempt}.runner.log 2>&1"
    )
    return ["tmux", "new-session", "-d", "-s", session_name(seed, number), "--", "bash", "-lc", inner]


def launch_attempt(seed: int, number: int, dry_run: bool) -> None:
    cmd = launch_command(seed, number)
    if dry_run:
        log(f"[dry-run] would launch: {' '.join(cmd)}")
        return
    (V2_ROOT / f"graph-seed-{seed}").mkdir(parents=True, exist_ok=True)
    subprocess.run(cmd, check=True, cwd=ROOT)
    log(f"launched neutral-v2-g{seed}-a{number:03d} in tmux {session_name(seed, number)}")


# ---------------------------------------------------------------- tick

def tick(state: dict, *, max_slots: int, dry_run: bool, live=is_live, preflight=identity_preflight,
         launcher=launch_attempt, mem=free_gib, clock=time.time) -> list[str]:
    report: list[str] = []
    validated = state["validated"]
    last_status = state["last_status"]
    running = 0
    complete: list[int] = []
    launchable: list[tuple[int, int, str]] = []  # (seed, attempt_no, reason)

    for seed in range(FIRST_SEED, LAST_SEED + 1):
        key = str(seed)
        status, attempt_dir, info = classify_seed(seed, live, validated)
        label = attempt_dir.name if attempt_dir else "-"
        if status != last_status.get(key):
            detail = {"seed": seed, "attempt": label, "previous": last_status.get(key),
                      **{k: v for k, v in info.items() if k != "cached"}}
            if status in ("failed", "interrupted", "invalid") and attempt_dir is not None:
                detail["runner_log_error"] = runner_log_error(seed, attempt_dir)
            record_event(state, "validation-failed" if status == "complete-invalid" else status, detail)
            last_status[key] = status
        if status == "complete-validated":
            validated.setdefault(f"g{seed}/{label}", now())
            complete.append(seed)
            report.append(f"g{seed}: complete-validated ({label})")
            continue
        if status == "running":
            running += 1
            n = receipt_count(attempt_dir)
            idle = clock() - last_progress_ts(attempt_dir)
            line = f"g{seed}: running {label} receipts={n}/{PLANNED_ROWS}"
            if idle > STALL_SECONDS:
                line += f" STALL {idle / 3600:.1f}h without a new receipt"
                marker = f"{label}:{n}"
                if state["stall_alerted"].get(key) != marker:
                    state["stall_alerted"][key] = marker
                    record_event(state, "stall", {"seed": seed, "attempt": label, "receipts": n,
                                                  "idle_hours": round(idle / 3600, 1)})
            report.append(line)
            continue
        auth = state["authorized_fresh"].get(key)
        if status == "unstarted":
            launchable.append((seed, 1, "unstarted"))
            report.append(f"g{seed}: unstarted (queued)")
        elif auth and not state["consumed"].get(f"fresh:{key}:{auth.get('attempt_no')}"):
            number = next_attempt_no(seed)
            if auth.get("attempt_no") != number:
                report.append(f"g{seed}: {status} {label}; authorization names attempt {auth.get('attempt_no')} "
                              f"but next is attempt-{number:03d} -> not launching (review)")
            else:
                launchable.append((seed, number, f"authorized fresh ({auth.get('authority')})"))
                report.append(f"g{seed}: {status} {label}; queued fresh attempt-{number:03d}")
        else:
            extra = info.get("problems") or info.get("row_id") or ""
            n = receipt_count(attempt_dir) if attempt_dir else 0
            report.append(f"g{seed}: {status.upper()} {label} receipts={n} -> held for review {str(extra)[:160]}")

    free_slots = max_slots - running
    if launchable and free_slots > 0:
        problems = preflight()
        if problems:
            if state.get("preflight_problems") != problems:
                record_event(state, "identity-preflight-failed", {"problems": problems})
            state["preflight_problems"] = problems
            report.append(f"IDENTITY PREFLIGHT FAILED -> no launches: {problems}")
            launchable = []
        else:
            state.pop("preflight_problems", None)
    for seed, number, reason in launchable:  # only eligible seeds are queued: no head-of-line blocking
        if free_slots <= 0:
            break
        available = mem()
        if available < MIN_FREE_GIB:
            if state.get("low_memory_alerted") != seed:
                record_event(state, "launch-deferred-low-memory", {"seed": seed, "free_gib": round(available, 2)})
                state["low_memory_alerted"] = seed
            report.append(f"memory {available:.1f}GiB < {MIN_FREE_GIB}GiB; deferring g{seed}")
            break
        state.pop("low_memory_alerted", None)
        try:
            launcher(seed, number, dry_run)
        except Exception as exc:  # surfaced, never swallowed
            record_event(state, "launch-error", {"seed": seed, "attempt": f"attempt-{number:03d}",
                                                 "error": str(exc)[:240]})
            report.append(f"g{seed}: LAUNCH ERROR {exc}")
            continue
        if not dry_run:
            if number > 1:
                state["consumed"][f"fresh:{seed}:{number}"] = now()
            record_event(state, "launched", {"seed": seed, "attempt": f"attempt-{number:03d}", "reason": reason})
            last_status[str(seed)] = "running"
        report.append(f"g{seed}: launched attempt-{number:03d} ({reason})")
        free_slots -= 1
        running += 1

    total = LAST_SEED - FIRST_SEED + 1
    if len(complete) == total:
        if not state.get("batch_done"):
            state["batch_done"] = True
            record_event(state, "batch-done", {})
        report.append("BATCH_DONE: all 32 shards raw-complete-unanalysed and validated; halting "
                      "(no analysis launched; stdout remains sealed)")
    report.append(f"slots in use: {running}/{max_slots}; complete: {len(complete)}/{total}; "
                  f"mem avail: {mem():.1f}GiB")
    return report


def review_resume(state: dict, seed: int, dry_run: bool, live=is_live, preflight=identity_preflight,
                  gate=synthetic_gate, launcher=launch_attempt) -> list[str]:
    """Documented v2 review action for an INTERRUPTED clean-prefix attempt:
    identity re-verification + synthetic gate, then the same command with the
    same attempt ID and directory (the runner re-validates the prefix)."""
    status, attempt_dir, _ = classify_seed(seed, live, state["validated"])
    name = attempt_dir.name if attempt_dir else None
    lines = [f"review-resume g{seed}: status={status} attempt={name}"]
    problems: list[str] = []
    if status != "interrupted":
        problems.append(f"status {status} is not a resumable interruption")
    else:
        problems += protocol_violations(attempt_dir)
        problems += preflight()
        if not problems:
            problems += gate()
    record = {
        "schema": "neutral-v2-review-resume-v1", "utc": now(), "seed": seed, "attempt": name,
        "receipts": receipt_count(attempt_dir) if attempt_dir else 0,
        "checks": ["status==interrupted (no live runner, no terminal manifest)", "no protocol violations",
                   "identity preflight", "durable-v2 synthetic gate"],
        "problems": problems, "decision": "refused" if problems else "resume",
    }
    if not dry_run:
        REVIEWS_DIR.mkdir(parents=True, exist_ok=True)
        path = REVIEWS_DIR / f"g{seed}-{name}-review-{datetime.now(timezone.utc):%Y%m%dT%H%M%SZ}.json"
        path.write_text(json.dumps(record, indent=2, sort_keys=True) + "\n", encoding="utf-8")
        lines.append(f"review record {path}")
    if problems:
        record_event(state, "review-resume-refused", {"seed": seed, "problems": problems[:10]})
        lines.append(f"REFUSED: {problems[:5]}")
        return lines
    launcher(seed, attempt_no(attempt_dir), dry_run)
    if not dry_run:
        record_event(state, "review-resumed", {"seed": seed, "attempt": name, "receipts": record["receipts"]})
        state["last_status"][str(seed)] = "running"
    lines.append(f"resumed {name} at receipt boundary {record['receipts']}")
    return lines


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--max-slots", type=int, default=MAX_SLOTS)
    parser.add_argument("--review-resume", type=int, metavar="SEED")
    parser.add_argument("--preflight-only", action="store_true")
    args = parser.parse_args()
    if args.max_slots > 4:
        parser.error("plan amendment caps concurrency at 4")
    if args.preflight_only:
        problems = identity_preflight()
        print("identity preflight:", "PASS" if not problems else problems)
        return 0 if not problems else 1

    with LOCK_PATH.open("w") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            print("another orchestrator tick holds the lock; exiting")
            return 0
        state = load_state()
        if args.review_resume:
            report = review_resume(state, args.review_resume, args.dry_run)
        else:
            report = tick(state, max_slots=args.max_slots, dry_run=args.dry_run)
        if not args.dry_run:
            state["last_tick_utc"] = now()
            save_state(state)
    for line in report:
        print(line)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
