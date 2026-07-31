#!/usr/bin/env python3
"""Materialize outcome-blind PeTTa query files for one frozen calibration shard."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from plan_neutral_calibration_shards import LEDGER, build_plan

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "src" / "chem_neutral_ssa.metta"


def row_id(row: dict) -> str:
    return (
        f"{row['cohort']}-L{row['L']}-f2-{row['f_twice']}-V{row['volume']}"
        f"-g{row['graph_seed']}-d{row['dynamics_seed']}"
    )


def query_text(row: dict, fixed: dict) -> str:
    return (
        f"!(import! &self {SOURCE})\n"
        "!(neutral-ssa-run-calibration-row "
        f"{row['L']} {row['graph_seed']} {row['dynamics_seed']} "
        f"{row['f_twice']} {fixed['stop_event_count']} "
        f"{fixed['stop_time']}.0 {row['volume']} "
        f"{fixed['burn_in_time']}.0 {fixed['persistence_bins']['width']}.0 "
        f"{fixed['persistence_bins']['count']} "
        f"{fixed['persistent_bin_threshold']})\n"
    )


def prepare(graph_seed: int, output_root: Path) -> dict:
    ledger = json.loads(LEDGER.read_text(encoding="utf-8"))
    plan = build_plan(ledger)
    try:
        shard = next(s for s in plan["shards"] if s["graph_seed"] == graph_seed)
    except StopIteration as exc:
        raise ValueError(f"graph seed {graph_seed} is outside the frozen ledger") from exc

    shard_dir = output_root / shard["id"]
    query_dir = shard_dir / "queries"
    query_dir.mkdir(parents=True, exist_ok=False)
    rows = []
    for index, row in enumerate(shard["runs"]):
        identifier = row_id(row)
        filename = f"{index:03d}-{identifier}.metta"
        (query_dir / filename).write_text(
            query_text(row, ledger["fixed_model"]), encoding="utf-8"
        )
        rows.append({"index": index, "id": identifier, "query": f"queries/{filename}", **row})

    manifest = {
        "schema": "neutral-calibration-query-shard-v1",
        "status": "prepared-unrun",
        "ledger": str(LEDGER.relative_to(ROOT)),
        "graph_seed": graph_seed,
        "run_count": len(rows),
        "selection_policy": plan["selection_policy"],
        "endpoint_results_present": False,
        "rows": rows,
    }
    (shard_dir / "MANIFEST.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--graph-seed", required=True, type=int)
    parser.add_argument("--output-root", required=True, type=Path)
    args = parser.parse_args()
    manifest = prepare(args.graph_seed, args.output_root)
    print(
        f"prepared {manifest['run_count']} unrun PeTTa queries "
        f"for graph seed {manifest['graph_seed']}"
    )


if __name__ == "__main__":
    main()
