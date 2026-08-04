#!/usr/bin/env python3
import json
import tempfile
from pathlib import Path

from run_neutral_calibration_shard_v2 import SyntheticInterruption, run_shard_v2


SOURCE_COMMIT = "synthetic-source-commit"
RUNTIME = "synthetic-petta/swipl"


def write_fixture(root: Path, count: int = 4, failing: bool = False):
    shard = root / "shard"
    queries = shard / "queries"
    queries.mkdir(parents=True)
    rows = []
    for index in range(count):
        query = queries / f"{index:03d}-row-{index}.metta"
        query.write_text(f"row {index}\n", encoding="utf-8")
        rows.append({"index": index, "id": f"row-{index}", "query": f"queries/{query.name}"})
    manifest = {
        "schema": "neutral-calibration-query-shard-v1",
        "status": "prepared-unrun",
        "endpoint_results_present": False,
        "graph_seed": 1001,
        "run_count": count,
        "selection_policy": "all rows; no selective retries",
        "rows": rows,
    }
    (shard / "MANIFEST.json").write_text(json.dumps(manifest), encoding="utf-8")
    log = root / "executions.log"
    runner = root / "runner.sh"
    body = f'printf "%s\\n" "$(basename "$1")" >> "{log}"\nprintf "raw:%s\\n" "$(basename "$1")"\n'
    if failing:
        body += "exit 7\n"
    runner.write_text(body, encoding="utf-8")
    return shard, runner, root / "attempt", log


def invoke(shard, runner, attempt, **kwargs):
    return run_shard_v2(
        shard, runner, attempt, "attempt-synthetic-001", SOURCE_COMMIT, RUNTIME, **kwargs
    )


def expect_refusal(action, text: str):
    try:
        action()
    except (ValueError, RuntimeError) as exc:
        assert text in str(exc), str(exc)
    else:
        raise AssertionError(f"expected refusal containing {text!r}")


# Uninterrupted execution publishes one ordered receipt per row and a final manifest.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, log = write_fixture(Path(tmp), count=3)
    result = invoke(shard, runner, attempt)
    assert result["status"] == "raw-complete-unanalysed"
    assert result["completed_run_count"] == 3
    assert [path.name for path in sorted((attempt / "receipts").iterdir())] == [
        "000-row-0.json", "001-row-1.json", "002-row-2.json"
    ]
    assert len(log.read_text().splitlines()) == 3


# A durable receipt is the resume boundary; its row is not re-executed.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, log = write_fixture(Path(tmp), count=3)
    try:
        invoke(shard, runner, attempt, interrupt_after_receipt=0)
    except SyntheticInterruption:
        pass
    result = invoke(shard, runner, attempt)
    assert result["completed_run_count"] == 3
    assert log.read_text().splitlines().count("000-row-0.metta") == 1


# An unreceipted pair is quarantined intact and only that row is rerun.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, log = write_fixture(Path(tmp), count=2)
    try:
        invoke(shard, runner, attempt, interrupt_before_receipt=0)
    except SyntheticInterruption:
        pass
    invoke(shard, runner, attempt)
    assert log.read_text().splitlines().count("000-row-0.metta") == 2
    assert log.read_text().splitlines().count("001-row-1.metta") == 1
    quarantines = list((attempt / "quarantine").iterdir())
    assert len(quarantines) == 1
    assert sorted(path.suffix for path in quarantines[0].iterdir()) == [".stderr", ".stdout"]


def interrupted_fixture(root: Path):
    shard, runner, attempt, log = write_fixture(root, count=4)
    try:
        invoke(shard, runner, attempt, interrupt_after_receipt=2)
    except SyntheticInterruption:
        pass
    return shard, runner, attempt, log


# Mechanical tamper refusals: raw, query, receipt, manifest, runtime, gap,
# duplicate, and receipt ordering/index.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    (attempt / "raw" / "000-row-0.stdout").write_text("changed", encoding="utf-8")
    expect_refusal(lambda: invoke(shard, runner, attempt), "stdout_sha256")

with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    (attempt / "raw" / "unexpected.stdout").write_text("opaque", encoding="utf-8")
    expect_refusal(lambda: invoke(shard, runner, attempt), "unexpected raw file")

with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    (shard / "queries" / "003-row-3.metta").write_text("changed\n", encoding="utf-8")
    expect_refusal(lambda: invoke(shard, runner, attempt), "query_sha256")

with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    receipt = attempt / "receipts" / "000-row-0.json"
    value = json.loads(receipt.read_text())
    value["id"] = "tampered"
    receipt.write_text(json.dumps(value), encoding="utf-8")
    expect_refusal(lambda: invoke(shard, runner, attempt), "receipt mismatch")

with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    manifest = shard / "MANIFEST.json"
    value = json.loads(manifest.read_text())
    value["selection_policy"] = "tampered"
    manifest.write_text(json.dumps(value), encoding="utf-8")
    expect_refusal(lambda: invoke(shard, runner, attempt), "source_manifest_sha256")

with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    expect_refusal(
        lambda: run_shard_v2(shard, runner, attempt, "attempt-synthetic-001", SOURCE_COMMIT, "changed"),
        "runtime_identity",
    )

with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    (attempt / "receipts" / "001-row-1.json").unlink()
    expect_refusal(lambda: invoke(shard, runner, attempt), "gap, duplicate, or ordering")

with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    duplicate = attempt / "receipts" / "999-duplicate.json"
    duplicate.write_bytes((attempt / "receipts" / "000-row-0.json").read_bytes())
    expect_refusal(lambda: invoke(shard, runner, attempt), "gap, duplicate, or ordering")

with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = interrupted_fixture(Path(tmp))
    receipt = attempt / "receipts" / "001-row-1.json"
    value = json.loads(receipt.read_text())
    value["index"] = 2
    receipt.write_text(json.dumps(value), encoding="utf-8")
    expect_refusal(lambda: invoke(shard, runner, attempt), "receipt mismatch: index")


# Nonzero exit permanently invalidates an attempt.
with tempfile.TemporaryDirectory() as tmp:
    shard, runner, attempt, _ = write_fixture(Path(tmp), count=2, failing=True)
    expect_refusal(lambda: invoke(shard, runner, attempt), "exited nonzero")
    expect_refusal(lambda: invoke(shard, runner, attempt), "failed attempt cannot be resumed")
    assert (attempt / "FAILED.json").is_file()


# A v1 shard/recovery directory is never interpreted as a v2 resumable attempt.
with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    shard, runner, _, _ = write_fixture(root)
    (shard / "RECOVERY_PLAN.json").write_text("{}\n", encoding="utf-8")
    expect_refusal(
        lambda: run_shard_v2(shard, runner, shard, "attempt-synthetic-001", SOURCE_COMMIT, RUNTIME),
        "v1 shard directory",
    )
    foreign = root / "foreign-attempt"
    foreign.mkdir()
    (foreign / "RECOVERY_PLAN.json").write_text("{}\n", encoding="utf-8")
    expect_refusal(lambda: invoke(shard, runner, foreign), "not a resumable v2 attempt")

print("neutral calibration v2 durable receipt runner: synthetic gate passed")
