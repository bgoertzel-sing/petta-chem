#!/usr/bin/env python3
"""Outcome-blind supervisor for the 32-shard neutral-calibration v2 batch.

Ben directive 2026-09-02: automate the full 32-shard batch so per-shard
relaunches do not need manual attention.

Rules (amendment to neutral_calibration_batch_acquisition_plan.md, recorded in
docs/neutral_calibration_orchestrator_plan_amendment.md):

- At most 4 concurrent shards (matching Ben's 2026-08-30 concurrent directive).
- Every shard uses the frozen identities from the g1001 launch review unless a
  new identity review is committed first.
- COMPLETE (RUN_MANIFEST.json, raw-complete-unanalysed, 276/276) + metadata
  validation -> preserve, launch next queued seed into the freed slot.
- FAILED.json or identity/receipt/hash mismatch -> freeze the shard, record
  the event, do NOT retry automatically. The slot stays empty.
- Dead runner with neither terminal manifest -> report, do not restart
  (the v2 recovery rule requires identity re-verification + synthetic gate,
  which is a review action).
- No endpoint content is ever opened: only manifests, receipts, and hashes.
- When all 32 seeds are complete -> halt (BATCH_DONE). No analysis launch.

State lives in experiments/neutral_calibration_v2/orchestrator_state.json.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
V1_ROOT = ROOT / "experiments" / "neutral_calibration_v1"
V2_ROOT = ROOT / "experiments" / "neutral_calibration_v2"
STATE_PATH = V2_ROOT / "orchestrator_state.json"
ORCH_LOG = V2_ROOT / "orchestrator.log"

RUNNER = "/home/openclaw/research-agent/projects/omegaclaw/repos/PeTTa/run.sh"
SOURCE_COMMIT = "4b7c6de4ec8eb71502588d2714579c7d55d4bd50"
RUNTIME_IDENTITY = (
    "petta=4ce1d0ea58855abb772b911278312c8846e5cc08;"
    "run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;"
    "main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;"
    "swipl=9.3.36-x86_64-linux;mork_ffi=absent"
)
SWIPL_BIN = "/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin"

FIRST_SEED = 1001
LAST_SEED = 1032
MAX_SLOTS = 4
PLANNED_ROWS = 276
MIN_FREE_GIB = 2.0
RECEIPT_SCHEMA = "neutral-calibration-row-receipt-v2"


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


def load_state() -> dict:
    if STATE_PATH.exists():
        return json.loads(STATE_PATH.read_text(encoding="utf-8"))
    return {
        "schema": "neutral-orchestrator-state-v1",
        "frozen": {},
        "validated": {},
        "events": [],
    }


def save_state(state: dict) -> None:
    STATE_PATH.write_text(
        json.dumps(state, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


def record_event(state: dict, kind: str, detail: dict) -> None:
    state["events"].append({"utc": now(), "kind": kind, **detail})
    state["events"] = state["events"][-500:]


def attempts_for(seed: int) -> list[Path]:
    seed_dir = V2_ROOT / f"graph-seed-{seed}"
    if not seed_dir.is_dir():
        return []
    return sorted(p for p in seed_dir.iterdir() if p.is_dir() and p.name.startswith("attempt-"))


def failed_summary(attempt_dir: Path) -> dict:
    try:
        failed = json.loads((attempt_dir / "FAILED.json").read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        failed = {}
    return {
        "exit_code": failed.get("exit_code"),
        "row_id": failed.get("row_id") or failed.get("id"),
        "row_index": failed.get("row_index") if "row_index" in failed else failed.get("index"),
        "utc": failed.get("utc") or failed.get("failed_utc"),
    }


def classify_seed(seed: int) -> tuple[str, Path | None]:
    """Seed status from its NEWEST attempt.

    Older failed attempts do not freeze a seed when a newer attempt exists:
    the v2 recovery rule already requires a separate review to launch the
    newer attempt, so its mere existence proves the failure was reviewed.
    Returns (status, governing_attempt_dir) with status in
    {unstarted, running, complete, failed, interrupted}.
    """
    attempts = attempts_for(seed)
    if not attempts:
        return "unstarted", None
    newest = attempts[-1]
    status = attempt_status(newest)
    if status != "running":
        return status, newest
    session = f"petta-neutral-v2-g{seed}-a{int(newest.name.split('-')[1]):03d}"
    if tmux_session_alive(session):
        return "running", newest
    return "interrupted", newest


def attempt_status(attempt_dir: Path) -> str:
    """terminal state from manifests only; never opens raw content."""
    if (attempt_dir / "FAILED.json").exists():
        return "failed"
    if (attempt_dir / "RUN_MANIFEST.json").exists():
        return "complete"
    return "running"


def receipt_count(attempt_dir: Path) -> int:
    receipts = attempt_dir / "receipts"
    if not receipts.is_dir():
        return 0
    return len([p for p in receipts.iterdir() if p.suffix == ".json"])


def validate_completed_attempt(attempt_dir: Path) -> list[str]:
    """Metadata-only validation of a completed attempt. Returns problems."""
    problems: list[str] = []
    run_manifest_path = attempt_dir / "RUN_MANIFEST.json"
    try:
        run_manifest = json.loads(run_manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        return [f"RUN_MANIFEST unreadable: {exc}"]
    if run_manifest.get("schema") != "neutral-calibration-raw-shard-v2":
        problems.append("RUN_MANIFEST schema mismatch")
    if run_manifest.get("status") != "raw-complete-unanalysed":
        problems.append(f"unexpected RUN_MANIFEST status {run_manifest.get('status')}")
    if (
        run_manifest.get("completed_run_count") != PLANNED_ROWS
        or run_manifest.get("planned_run_count") != PLANNED_ROWS
    ):
        problems.append(
            f"run counts {run_manifest.get('completed_run_count')}/"
            f"{run_manifest.get('planned_run_count')} != {PLANNED_ROWS}"
        )
    if run_manifest.get("source_commit") != SOURCE_COMMIT:
        problems.append("source_commit mismatch")
    if run_manifest.get("runtime_identity") != RUNTIME_IDENTITY:
        problems.append("runtime_identity mismatch")

    receipts = sorted((attempt_dir / "receipts").glob("*.json"))
    if len(receipts) != PLANNED_ROWS:
        problems.append(f"receipt count {len(receipts)} != {PLANNED_ROWS}")
        return problems

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
            if key == "query":
                target = attempt_dir.parent.parent.parent / "neutral_calibration_v1"
                target = V1_ROOT / attempt_dir.parent.name / rel
            else:
                target = attempt_dir / rel
            if not target.is_file():
                problems.append(f"receipt {receipt_path.name} missing file {key}={rel}")
                continue
            actual = sha256(target)
            if actual != digest:
                problems.append(f"receipt {receipt_path.name} {key} sha256 mismatch")

    if indices != list(range(PLANNED_ROWS)):
        problems.append("receipt indices not contiguous 0..275")
    return problems


def tmux_session_alive(name: str) -> bool:
    result = subprocess.run(
        ["tmux", "has-session", "-t", name],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return result.returncode == 0


def free_gib() -> float:
    meminfo = Path("/proc/meminfo").read_text(encoding="utf-8")
    available_kb = next(
        int(line.split()[1]) for line in meminfo.splitlines() if line.startswith("MemAvailable:")
    )
    return available_kb / (1024 * 1024)


def prepare_shard(seed: int) -> None:
    shard_dir = V1_ROOT / f"graph-seed-{seed}"
    if shard_dir.is_dir():
        return
    log(f"preparing v1 manifest for graph-seed-{seed}")
    subprocess.run(
        [
            sys.executable,
            str(ROOT / "scripts" / "prepare_neutral_calibration_queries.py"),
            "--graph-seed",
            str(seed),
            "--output-root",
            str(V1_ROOT),
        ],
        check=True,
        cwd=ROOT,
    )


def launch_attempt(seed: int, attempt_no: int, dry_run: bool) -> str:
    attempt_id = f"neutral-v2-g{seed}-a{attempt_no:03d}"
    session = f"petta-neutral-v2-g{seed}-a{attempt_no:03d}"
    attempt_dir = V2_ROOT / f"graph-seed-{seed}" / f"attempt-{attempt_no:03d}"
    log_path = V2_ROOT / f"graph-seed-{seed}" / f"attempt-{attempt_no:03d}.runner.log"
    inner = (
        f"cd {ROOT} && exec env PATH={SWIPL_BIN}:/usr/bin:/bin "
        f"{sys.executable} scripts/run_neutral_calibration_shard_v2.py "
        f"--shard-dir experiments/neutral_calibration_v1/graph-seed-{seed} "
        f"--runner {RUNNER} "
        f"--attempt-dir experiments/neutral_calibration_v2/graph-seed-{seed}/attempt-{attempt_no:03d} "
        f"--attempt-id {attempt_id} "
        f"--source-commit {SOURCE_COMMIT} "
        f'--runtime-identity "{RUNTIME_IDENTITY}" '
        f">> experiments/neutral_calibration_v2/graph-seed-{seed}/attempt-{attempt_no:03d}.runner.log 2>&1"
    )
    cmd = ["tmux", "new-session", "-d", "-s", session, "--", "bash", "-lc", inner]
    if dry_run:
        log(f"[dry-run] would launch: {' '.join(cmd)}")
        log(f"[dry-run] attempt_dir={attempt_dir} log={log_path}")
        return session
    (V2_ROOT / f"graph-seed-{seed}").mkdir(parents=True, exist_ok=True)
    subprocess.run(cmd, check=True, cwd=ROOT)
    log(f"launched {attempt_id} in tmux session {session}")
    return session


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--max-slots", type=int, default=MAX_SLOTS)
    args = parser.parse_args()

    state = load_state()
    report: list[str] = []

    running_slots = 0
    complete_seeds: list[int] = []
    frozen = state.setdefault("frozen", {})
    validated = state.setdefault("validated", {})

    for seed in range(FIRST_SEED, LAST_SEED + 1):
        key = str(seed)
        if key in frozen:
            _fv = frozen[key]
            _reason = _fv.get("reason", "review") if isinstance(_fv, dict) else str(_fv)
            report.append(f"g{seed}: FROZEN ({_reason})")
            continue
        status, attempt_dir = classify_seed(seed)
        if status == "complete":
            assert attempt_dir is not None
            vkey = f"g{seed}/{attempt_dir.name}"
            if vkey not in validated:
                problems = validate_completed_attempt(attempt_dir)
                if problems:
                    frozen[key] = {
                        "reason": "completion-validation-failed",
                        "problems": problems[:20],
                        "utc": now(),
                    }
                    record_event(state, "validation-failed",
                                 {"seed": seed, "problems": problems[:20]})
                    report.append(f"g{seed}: VALIDATION FAILED -> frozen; first: {problems[:2]}")
                    continue
                validated[vkey] = now()
                record_event(state, "validated-complete",
                             {"seed": seed, "attempt": attempt_dir.name})
            complete_seeds.append(seed)
            report.append(f"g{seed}: complete-validated ({attempt_dir.name})")
        elif status == "failed":
            assert attempt_dir is not None
            summary = failed_summary(attempt_dir)
            frozen[key] = {
                "reason": "FAILED.json present in newest attempt; no auto-retry",
                "attempt": attempt_dir.name,
                "failed": summary,
                "utc": now(),
            }
            record_event(state, "failed", {"seed": seed, "attempt": attempt_dir.name, **summary})
            report.append(
                f"g{seed}: FAILED {attempt_dir.name} row={summary.get('row_id')} "
                f"exit={summary.get('exit_code')} -> frozen (no auto-retry)"
            )
        elif status == "running":
            assert attempt_dir is not None
            running_slots += 1
            report.append(
                f"g{seed}: running {attempt_dir.name} "
                f"receipts={receipt_count(attempt_dir)}/{PLANNED_ROWS}"
            )
        elif status == "interrupted":
            assert attempt_dir is not None
            record_event(state, "interrupted", {"seed": seed, "attempt": attempt_dir.name,
                                                 "receipts": receipt_count(attempt_dir)})
            report.append(
                f"g{seed}: INTERRUPTED {attempt_dir.name} at "
                f"{receipt_count(attempt_dir)}/{PLANNED_ROWS}; v2 recovery requires "
                "identity re-verification + synthetic gate (review action, not auto)"
            )
        # "unstarted" seeds are handled by the launch queue below.

    # Launch queued seeds into free slots.
    free_slots = args.max_slots - running_slots
    free_now = free_gib()
    for seed in range(FIRST_SEED, LAST_SEED + 1):
        if free_slots <= 0:
            break
        if str(seed) in frozen or seed in complete_seeds:
            continue
        status, _ = classify_seed(seed)
        if status != "unstarted":
            continue  # live, interrupted (needs review), failed, or complete
        if free_now < MIN_FREE_GIB:
            report.append(
                f"memory headroom {free_now:.1f}GiB < {MIN_FREE_GIB}GiB; not launching g{seed}"
            )
            record_event(state, "launch-deferred-low-memory",
                         {"seed": seed, "free_gib": round(free_now, 2)})
            break
        if not (V1_ROOT / f"graph-seed-{seed}").is_dir():
            if args.dry_run:
                log(f"[dry-run] would prepare v1 manifest for graph-seed-{seed}")
            else:
                prepare_shard(seed)
        launch_attempt(seed, 1, args.dry_run)
        record_event(state, "launched" if not args.dry_run else "dry-run-launch", {"seed": seed})
        free_slots -= 1
        running_slots += 1

    total_seeds = LAST_SEED - FIRST_SEED + 1
    if len(complete_seeds) == total_seeds and not frozen:
        if state.get("batch_done") is not True:
            state["batch_done"] = True
            record_event(state, "batch-done", {})
        report.append(
            "BATCH_DONE: all 32 shards raw-complete-unanalysed and validated; "
            "halting (no analysis launched; stdout remains sealed)"
        )

    if not args.dry_run:
        save_state(state)
    else:
        log("[dry-run] state not saved")

    for line in report:
        print(line)
    print(f"slots in use: {running_slots}/{args.max_slots}; frozen: {len(frozen)}; "
          f"complete: {len(complete_seeds)}/{total_seeds}; mem avail: {free_now:.1f}GiB")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
