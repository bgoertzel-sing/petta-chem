#!/usr/bin/env python3
"""Execute every prepared PeTTa query in one frozen calibration shard."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_shard(shard_dir: Path, runner: Path) -> dict:
    manifest_path = shard_dir / "MANIFEST.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest.get("schema") != "neutral-calibration-query-shard-v1":
        raise ValueError("unsupported shard manifest schema")
    if manifest.get("status") != "prepared-unrun":
        raise ValueError("shard must have prepared-unrun status")
    if manifest.get("endpoint_results_present") is not False:
        raise ValueError("prepared manifest must not contain endpoint results")
    if manifest.get("run_count") != len(manifest.get("rows", [])):
        raise ValueError("manifest run_count does not match rows")

    results_dir = shard_dir / "raw"
    results_dir.mkdir(exist_ok=False)
    completed = []
    started = datetime.now(timezone.utc).isoformat()
    for row in manifest["rows"]:
        query = shard_dir / row["query"]
        output = results_dir / f"{row['index']:03d}-{row['id']}.stdout"
        error = results_dir / f"{row['index']:03d}-{row['id']}.stderr"
        with output.open("wb") as stdout, error.open("wb") as stderr:
            proc = subprocess.run(
                ["sh", str(runner), str(query)],
                stdout=stdout,
                stderr=stderr,
                check=False,
            )
        completed.append(
            {
                "index": row["index"],
                "id": row["id"],
                "query_sha256": sha256(query),
                "stdout": str(output.relative_to(shard_dir)),
                "stdout_sha256": sha256(output),
                "stderr": str(error.relative_to(shard_dir)),
                "stderr_sha256": sha256(error),
                "exit_code": proc.returncode,
            }
        )
        if proc.returncode != 0:
            break

    failed = next((row for row in completed if row["exit_code"] != 0), None)
    run_manifest = {
        "schema": "neutral-calibration-raw-shard-v1",
        "source_manifest_sha256": sha256(manifest_path),
        "graph_seed": manifest["graph_seed"],
        "selection_policy": manifest["selection_policy"],
        "started_utc": started,
        "finished_utc": datetime.now(timezone.utc).isoformat(),
        "runner": str(runner.resolve()),
        "planned_run_count": manifest["run_count"],
        "completed_run_count": len(completed),
        "status": "failed" if failed else "raw-complete-unanalysed",
        "failed_row": None if failed is None else failed["id"],
        "rows": completed,
    }
    (shard_dir / "RUN_MANIFEST.json").write_text(
        json.dumps(run_manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    return run_manifest


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shard-dir", required=True, type=Path)
    parser.add_argument("--runner", required=True, type=Path)
    args = parser.parse_args()
    result = run_shard(args.shard_dir, args.runner)
    print(
        f"{result['status']}: {result['completed_run_count']}/"
        f"{result['planned_run_count']} raw rows"
    )
    raise SystemExit(1 if result["status"] == "failed" else 0)


if __name__ == "__main__":
    main()
