#!/usr/bin/env python3
"""Expand the frozen calibration ledger into outcome-blind graph-seed shards."""

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / "artifacts" / "neutral_calibration_ledger_v1.json"


def expand_runs(ledger: dict) -> list[dict]:
    graph_seeds = range(
        ledger["streams"]["graph_seeds"]["first"],
        ledger["streams"]["graph_seeds"]["last"] + 1,
    )
    runs = []
    for cohort in ledger["cohorts"]:
        for graph_seed in graph_seeds:
            for length in cohort["polymer_max_lengths"]:
                for f_twice in cohort["f_twice"]:
                    for volume in cohort["volumes"]:
                        for dynamics_seed in ledger["streams"]["dynamics_seeds"]:
                            runs.append(
                                {
                                    "cohort": cohort["id"],
                                    "L": length,
                                    "f_twice": f_twice,
                                    "volume": volume,
                                    "graph_seed": graph_seed,
                                    "dynamics_seed": dynamics_seed,
                                }
                            )
    return runs


def build_plan(ledger: dict) -> dict:
    runs = expand_runs(ledger)
    shards = []
    first = ledger["streams"]["graph_seeds"]["first"]
    last = ledger["streams"]["graph_seeds"]["last"]
    for graph_seed in range(first, last + 1):
        shard_runs = [run for run in runs if run["graph_seed"] == graph_seed]
        shards.append(
            {
                "id": f"graph-seed-{graph_seed}",
                "graph_seed": graph_seed,
                "run_count": len(shard_runs),
                "runs": shard_runs,
            }
        )
    return {
        "schema": "neutral-calibration-shard-plan-v1",
        "ledger": str(LEDGER.relative_to(ROOT)),
        "status": "planned-unrun",
        "partition_key": "graph_seed",
        "selection_policy": "execute every shard exactly once; no endpoint-conditioned retry, omission, extension, or resampling",
        "endpoint_fields_present": False,
        "total_unique_runs": len(runs),
        "shards": shards,
    }


def main() -> None:
    ledger = json.loads(LEDGER.read_text(encoding="utf-8"))
    print(json.dumps(build_plan(ledger), sort_keys=True, separators=(",", ":")))


if __name__ == "__main__":
    main()
