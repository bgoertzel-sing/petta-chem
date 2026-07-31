#!/usr/bin/env python3
import json
import stat
import tempfile
from pathlib import Path

from run_neutral_calibration_shard import run_shard


def write_shard(root: Path, count: int = 2) -> Path:
    shard = root / "graph-seed-1001"
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
    return shard


with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    runner = root / "runner"
    runner.write_text("#!/bin/sh\nprintf 'raw:%s\\n' \"$(basename \"$1\")\"\n", encoding="utf-8")
    runner.chmod(runner.stat().st_mode | stat.S_IXUSR)
    shard = write_shard(root)
    result = run_shard(shard, runner)
    assert result["status"] == "raw-complete-unanalysed"
    assert result["completed_run_count"] == 2
    assert all(row["exit_code"] == 0 for row in result["rows"])
    assert (shard / result["rows"][0]["stdout"]).read_text().startswith("raw:")

with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    runner = root / "runner"
    runner.write_text("#!/bin/sh\nexit 7\n", encoding="utf-8")
    runner.chmod(runner.stat().st_mode | stat.S_IXUSR)
    shard = write_shard(root, count=3)
    result = run_shard(shard, runner)
    assert result["status"] == "failed"
    assert result["completed_run_count"] == 1
    assert result["failed_row"] == "row-0"

print("neutral calibration raw shard runner: complete and fail-closed")
