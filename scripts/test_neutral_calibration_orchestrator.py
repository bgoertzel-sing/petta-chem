#!/usr/bin/env python3
"""Synthetic tests for the v3 neutral-calibration orchestrator (no PeTTa)."""

from __future__ import annotations

import hashlib
import json
import tempfile
from pathlib import Path

import neutral_calibration_orchestrator as o

ROWS = 3


def h(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def setup(tmp: Path) -> None:
    o.ROOT = tmp
    o.V1_ROOT = tmp / "v1"
    o.V2_ROOT = tmp / "v2"
    o.STATE_PATH = o.V2_ROOT / "state.json"
    o.ALERTS_PATH = o.V2_ROOT / "ALERTS.jsonl"
    o.ORCH_LOG = o.V2_ROOT / "orch.log"
    o.REVIEWS_DIR = o.V2_ROOT / "reviews"
    o.FIRST_SEED, o.LAST_SEED, o.PLANNED_ROWS = 1, 6, ROWS
    o.V2_ROOT.mkdir(parents=True)
    for seed in range(1, 7):
        q = o.V1_ROOT / f"graph-seed-{seed}" / "queries"
        q.mkdir(parents=True)
        for i in range(ROWS):
            (q / f"{i:03d}-r{i}.metta").write_text(f"q{seed}-{i}\n")


def make_attempt(seed: int, number: int, receipts: int, *, exit_codes=None, skip=None, failed=False,
                 complete=False, attempt_json=True, log_line=None) -> Path:
    a = o.V2_ROOT / f"graph-seed-{seed}" / f"attempt-{number:03d}"
    (a / "raw").mkdir(parents=True)
    (a / "receipts").mkdir()
    if attempt_json:
        (a / "ATTEMPT.json").write_text("{}")
    exit_codes = exit_codes or {}
    for i in range(receipts):
        so, se = a / "raw" / f"{i:03d}-r{i}.stdout", a / "raw" / f"{i:03d}-r{i}.stderr"
        so.write_text("sealed")
        se.write_text("")
        query = o.V1_ROOT / f"graph-seed-{seed}" / "queries" / f"{i:03d}-r{i}.metta"
        rec = {"schema": o.RECEIPT_SCHEMA, "index": i, "exit_code": exit_codes.get(i, 0),
               "source_commit": o.SOURCE_COMMIT, "runtime_identity": o.RUNTIME_IDENTITY,
               "query": f"queries/{query.name}", "query_sha256": h(query),
               "stdout": f"raw/{so.name}", "stdout_sha256": h(so),
               "stderr": f"raw/{se.name}", "stderr_sha256": h(se), "completed_utc": "x"}
        (a / "receipts" / f"{i:03d}-r{i}.json").write_text(json.dumps(rec))
    if skip is not None:
        (a / "raw" / f"{skip:03d}-r{skip}.SKIP.json").write_text("{}")
    if failed:
        (a / "FAILED.json").write_text(json.dumps({"exit_code": 137, "row_id": "r2", "row_index": 2}))
    if complete:
        man = {"schema": "neutral-calibration-raw-shard-v2", "status": "raw-complete-unanalysed",
               "completed_run_count": receipts, "planned_run_count": ROWS, "source_commit": o.SOURCE_COMMIT,
               "runtime_identity": o.RUNTIME_IDENTITY, "runner_sha256": o.RUN_SH_SHA256}
        (a / "RUN_MANIFEST.json").write_text(json.dumps(man))
    if log_line:
        (a.parent / f"{a.name}.runner.log").write_text("start\nTraceback (most recent call last):\n" + log_line + "\n")
    return a


def alerts() -> list[dict]:
    if not o.ALERTS_PATH.exists():
        return []
    return [json.loads(line) for line in o.ALERTS_PATH.read_text().splitlines()]


class FakeLauncher:
    def __init__(self):
        self.launched = []

    def __call__(self, seed, number, dry_run):
        self.launched.append((seed, number))
        make_attempt(seed, number, 0)


def base_tick(state, launcher, live=lambda s, a: False, preflight=lambda: [], mem=lambda: 8.0, slots=2, clock=None):
    kwargs = {"clock": clock} if clock else {}
    return o.tick(state, max_slots=slots, dry_run=False, live=live, preflight=preflight,
                  launcher=launcher, mem=mem, **kwargs)


def test_head_of_line_and_failure_surfacing():
    with tempfile.TemporaryDirectory() as d:
        setup(Path(d))
        make_attempt(1, 1, 2, failed=True, log_line="RuntimeError: row 2 exited nonzero; attempt invalidated")
        make_attempt(2, 1, 1, skip=1)                         # non-protocol SKIP -> invalid
        make_attempt(3, 1, 2)                                 # clean prefix, dead -> interrupted
        make_attempt(4, 1, 2, exit_codes={1: 143})            # nonzero receipt -> invalid
        make_attempt(5, 1, ROWS, complete=True)               # valid complete
        # seed 6 unstarted
        state = o.load_state()
        state["authorized_fresh"]["4"] = {"attempt_no": 2, "authority": "test"}
        launcher = FakeLauncher()
        report = base_tick(state, launcher)
        assert sorted(launcher.launched) == [(4, 2), (6, 1)], launcher.launched
        kinds = {(a["seed"], a["kind"]) for a in alerts() if "seed" in a}
        assert (1, "failed") in kinds and (2, "invalid") in kinds and (3, "interrupted") in kinds
        assert (4, "invalid") in kinds and (5, "complete-validated") in kinds
        failed = next(a for a in alerts() if a.get("seed") == 1)
        assert "invalidated" in (failed.get("runner_log_error") or ""), failed
        assert any("g3: INTERRUPTED" in line for line in report)
        # second tick: no duplicate alerts, authorization not reused
        n = len(alerts())
        launcher2 = FakeLauncher()
        base_tick(state, launcher2)
        assert launcher2.launched == [], launcher2.launched
        new = alerts()[n:]
        assert all(a["kind"] == "interrupted" and a["seed"] in (4, 6) for a in new), new


def test_preflight_blocks_all_launches_once():
    with tempfile.TemporaryDirectory() as d:
        setup(Path(d))
        state = o.load_state()
        launcher = FakeLauncher()
        report = base_tick(state, launcher, preflight=lambda: ["PeTTa tracked tree dirty"])
        assert launcher.launched == []
        assert any("IDENTITY PREFLIGHT FAILED" in line for line in report)
        base_tick(state, launcher, preflight=lambda: ["PeTTa tracked tree dirty"])
        assert sum(a["kind"] == "identity-preflight-failed" for a in alerts()) == 1


def test_slots_memory_and_skipped_manifest():
    with tempfile.TemporaryDirectory() as d:
        setup(Path(d))
        a = make_attempt(1, 1, ROWS, complete=True)
        man = json.loads((a / "RUN_MANIFEST.json").read_text())
        man["skipped_rows"] = [{"index": 2}]
        (a / "RUN_MANIFEST.json").write_text(json.dumps(man))
        assert any("skipped" in p for p in o.validate_completed_attempt(a))
        make_attempt(2, 1, 1)
        state = o.load_state()
        launcher = FakeLauncher()
        base_tick(state, launcher, live=lambda s, att: s == 2, slots=2, mem=lambda: 1.0)
        assert launcher.launched == []
        assert any(x["kind"] == "launch-deferred-low-memory" for x in alerts())
        base_tick(state, launcher, live=lambda s, att: s == 2, slots=2)
        assert launcher.launched == [(3, 1)], launcher.launched  # one free slot only


def test_stall_alert():
    with tempfile.TemporaryDirectory() as d:
        setup(Path(d))
        make_attempt(1, 1, 1)
        state = o.load_state()
        future = lambda: __import__("time").time() + 7 * 3600
        report = base_tick(state, FakeLauncher(), live=lambda s, a: s == 1, slots=1, clock=future)
        assert any("STALL" in line for line in report)
        base_tick(state, FakeLauncher(), live=lambda s, a: s == 1, slots=1, clock=future)
        assert sum(x["kind"] == "stall" for x in alerts()) == 1


def test_review_resume():
    with tempfile.TemporaryDirectory() as d:
        setup(Path(d))
        make_attempt(1, 1, 1, skip=2)
        make_attempt(2, 1, 1)
        state = o.load_state()
        launcher = FakeLauncher.__new__(FakeLauncher)
        launcher.launched = []
        calls = []
        lines = o.review_resume(state, 1, False, live=lambda s, a: False, preflight=lambda: [],
                                gate=lambda: [], launcher=lambda s, n, dr: calls.append((s, n)))
        assert calls == [] and any("REFUSED" in x for x in lines)
        lines = o.review_resume(state, 2, False, live=lambda s, a: False, preflight=lambda: [],
                                gate=lambda: [], launcher=lambda s, n, dr: calls.append((s, n)))
        assert calls == [(2, 1)], lines
        assert len(list(o.REVIEWS_DIR.glob("*.json"))) == 2
        lines = o.review_resume(state, 2, False, live=lambda s, a: False, preflight=lambda: [],
                                gate=lambda: ["synthetic gate rc=1"], launcher=lambda s, n, dr: calls.append((s, n)))
        assert calls == [(2, 1)] and any("REFUSED" in x for x in lines)


def test_stale_dirs_not_canonical_and_next_number():
    with tempfile.TemporaryDirectory() as d:
        setup(Path(d))
        make_attempt(1, 1, 1, skip=1)
        stale = make_attempt(1, 2, 1)
        stale.rename(stale.with_name("attempt-002.stale-2026"))
        assert [p.name for p in o.attempts_for(1)] == ["attempt-001"]
        assert o.next_attempt_no(1) == 3
        make_attempt(2, 3, 0, attempt_json=False)
        assert o.classify_attempt(2, o.attempts_for(2)[-1], live=lambda s, a: False)[0] == "invalid"


if __name__ == "__main__":
    for name, fn in sorted(globals().items()):
        if name.startswith("test_") and callable(fn):
            fn()
            print("ok", name)
    print("neutral calibration orchestrator v3: synthetic tests passed")
