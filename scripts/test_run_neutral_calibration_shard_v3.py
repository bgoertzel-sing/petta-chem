#!/usr/bin/env python3
"""Synthetic gate for the v3 runner's per-row validator hook (no PeTTa)."""
import json
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from run_neutral_calibration_shard_v3 import SyntheticInterruption, run_shard_v3  # noqa: E402

SOURCE_COMMIT = "synthetic-source-commit"
RUNTIME = "synthetic-petta/swipl"


def atom(g, d, f, ids='("lig:0:0" "cleave:00:1")'):
    return (f"(neutral-calibration-row model neutral-crs-v1 max-length 5 graph-seed {g} "
            f"dynamics-seed {d} f-twice {f} volume 100 molecule-count 62 reaction-count 392 "
            f"maximal-raf-rule-ids {ids} endpoints (neutral-ablation-endpoints "
            "baseline-reachability (raf-reachability-summary reachable true first-time 3.5) "
            "ablated-reachability (raf-reachability-summary reachable false first-time censored) "
            "baseline-causal (neutral-causal-endpoints raf-events 5 evidence-bins 2 integrated-nonfood 10.0) "
            "ablated-causal (neutral-causal-endpoints raf-events 1 evidence-bins 1 integrated-nonfood 4.0) "
            "delta (neutral-causal-endpoint-delta raf-events 4 evidence-bins 1 integrated-nonfood 6.0)))\n")


def write_fixture(root: Path, count=3, bad_index=None):
    shard = root / "shard"
    (shard / "queries").mkdir(parents=True)
    rows = []
    for i in range(count):
        q = shard / "queries" / f"{i:03d}-row-{i}.metta"
        ids = '(neutral-raf-reaction-ids (neutral-raf-maximal-reactions ("0") () ()))' if i == bad_index else None
        q.write_text(atom(1001, 2001 + i, 16, ids) if ids else atom(1001, 2001 + i, 16), encoding="utf-8")
        rows.append({"index": i, "id": f"row-{i}", "query": f"queries/{q.name}", "L": 5, "f_twice": 16,
                     "volume": 100, "graph_seed": 1001, "dynamics_seed": 2001 + i})
    manifest = {"schema": "neutral-calibration-query-shard-v1", "status": "prepared-unrun",
                "endpoint_results_present": False, "graph_seed": 1001, "run_count": count, "rows": rows}
    (shard / "MANIFEST.json").write_text(json.dumps(manifest), encoding="utf-8")
    runner = root / "runner.sh"
    runner.write_text('cat "$1"\n', encoding="utf-8")
    return shard, runner, root / "v3" / "graph-seed-1001" / "attempt-001", root / "v3" / "ALERTS.jsonl"


def invoke(shard, runner, attempt, alerts, **kw):
    return run_shard_v3(shard, runner, attempt, "synthetic-a001", SOURCE_COMMIT, RUNTIME,
                        alerts_path=alerts, **kw)


def refuses(fn, text):
    try:
        fn()
    except (ValueError, RuntimeError) as exc:
        assert text in str(exc), str(exc)
    else:
        raise AssertionError(f"expected refusal containing {text!r}")


# 1. Good rows: receipts carry passing verdict; completion re-validates all rows.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, alerts = write_fixture(Path(tmp))
    result = invoke(shard, runner, attempt, alerts)
    assert result["status"] == "raw-complete-unanalysed" and result["completed_run_count"] == 3
    assert result["revalidated_run_count"] == 3 and len(result["validator_sha256"]) == 64
    for p in sorted((attempt / "receipts").iterdir()):
        r = json.loads(p.read_text())
        assert r["schema"] == "neutral-calibration-row-receipt-v3"
        assert r["validation"]["verdict"] == "pass" and r["validation"]["raf_size"] == 2
    assert not alerts.exists()

# 2. The v2 defect at row 1: no receipt for row 1, FAILED.json + alert, seed frozen.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, alerts = write_fixture(Path(tmp), bad_index=1)
    refuses(lambda: invoke(shard, runner, attempt, alerts), "seed frozen")
    assert [p.name for p in (attempt / "receipts").iterdir()] == ["000-row-0.json"]
    failed = json.loads((attempt / "FAILED.json").read_text())
    assert failed["row_index"] == 1 and failed["validation"]["verdict"] == "fail"
    assert any("neutral-raf-" in s for s in failed["validation"]["reasons"])
    alert = json.loads(alerts.read_text().splitlines()[-1])
    assert alert["kind"] == "row-validation-failed" and alert["row_index"] == 1
    refuses(lambda: invoke(shard, runner, attempt, alerts), "failed attempt cannot be resumed")
    assert not (attempt / "RUN_MANIFEST.json").exists()

# 3. Nonzero exit also fails closed with an alert.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, alerts = write_fixture(Path(tmp))
    runner.write_text('cat "$1"; exit 3\n', encoding="utf-8")
    refuses(lambda: invoke(shard, runner, attempt, alerts), "seed frozen")
    assert json.loads(alerts.read_text().splitlines()[-1])["kind"] == "failed"

# 4. Resume at a receipt boundary works; a receipt without a passing verdict blocks resume.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, alerts = write_fixture(Path(tmp))
    try:
        invoke(shard, runner, attempt, alerts, interrupt_after_receipt=0)
    except SyntheticInterruption:
        pass
    receipt_path = attempt / "receipts" / "000-row-0.json"
    good = receipt_path.read_text()
    tampered = json.loads(good)
    tampered["validation"]["verdict"] = "fail"
    receipt_path.write_text(json.dumps(tampered))
    refuses(lambda: invoke(shard, runner, attempt, alerts), "passing verdict")
    receipt_path.write_text(good)
    assert invoke(shard, runner, attempt, alerts)["completed_run_count"] == 3

# 5. Interrupted before receipt: the unreceipted pair is quarantined and the row re-run.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, alerts = write_fixture(Path(tmp))
    try:
        invoke(shard, runner, attempt, alerts, interrupt_before_receipt=1)
    except SyntheticInterruption:
        pass
    assert invoke(shard, runner, attempt, alerts)["completed_run_count"] == 3
    assert any((attempt / "quarantine").iterdir())

print("neutral calibration v3 runner: validator hook gates receipts; failures freeze the seed")
