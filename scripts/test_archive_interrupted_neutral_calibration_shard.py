#!/usr/bin/env python3
import json
import tempfile
from pathlib import Path

from archive_interrupted_neutral_calibration_shard import archive_interrupted_shard
from run_neutral_calibration_shard import run_shard


def write_shard(root: Path, count: int = 2) -> Path:
    shard = root / "graph-seed-1001"
    queries = shard / "queries"
    queries.mkdir(parents=True)
    rows = []
    for index in range(count):
        query = queries / f"{index:03d}-row-{index}.metta"
        query.write_text(f"row {index}\n", encoding="utf-8")
        rows.append(
            {"index": index, "id": f"row-{index}", "query": f"queries/{query.name}"}
        )
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
    return shard


with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    shard = write_shard(root)
    raw = shard / "raw"
    raw.mkdir()
    first = raw / "000-row-0.stdout"
    first.write_bytes(b"opaque endpoint bytes\n")
    (raw / "000-row-0.stderr").write_bytes(b"")

    plan = archive_interrupted_shard(shard, "raw-interrupted-test")
    archive = shard / "raw-interrupted-test"
    assert plan["policy"] == "restart-entire-shard-no-prefix-reuse"
    assert plan["raw_content_opened"] is False
    assert not raw.exists()
    assert (archive / first.name).read_bytes() == b"opaque endpoint bytes\n"
    assert plan["inventory"][0]["path"] == "000-row-0.stderr"

    runner = root / "runner"
    runner.write_text("printf 'fresh:%s\\n' \"$(basename \"$1\")\"\n", encoding="utf-8")
    result = run_shard(shard, runner)
    assert result["status"] == "raw-complete-unanalysed"
    assert result["completed_run_count"] == 2

with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    shard = write_shard(root)
    (shard / "raw-interrupted-orphan").mkdir()
    runner = root / "runner"
    runner.write_text("exit 0\n", encoding="utf-8")
    try:
        run_shard(shard, runner)
    except ValueError as error:
        assert "RECOVERY_PLAN.json" in str(error)
    else:
        raise AssertionError("runner accepted interrupted attempt without recovery plan")

print("neutral calibration interrupted-shard recovery: whole-shard and fail-closed")
