#!/usr/bin/env python3
"""Validate complete, deterministic, outcome-blind calibration partitioning."""

import json

from plan_neutral_calibration_shards import LEDGER, build_plan


def main() -> None:
    ledger = json.loads(LEDGER.read_text(encoding="utf-8"))
    plan = build_plan(ledger)

    assert plan["status"] == "planned-unrun"
    assert plan["partition_key"] == "graph_seed"
    assert plan["endpoint_fields_present"] is False
    assert len(plan["shards"]) == 32
    assert {shard["run_count"] for shard in plan["shards"]} == {276}

    runs = [run for shard in plan["shards"] for run in shard["runs"]]
    identities = {
        (
            run["L"],
            run["f_twice"],
            run["volume"],
            run["graph_seed"],
            run["dynamics_seed"],
        )
        for run in runs
    }
    assert len(runs) == len(identities) == plan["total_unique_runs"] == 8832
    assert all(
        run["graph_seed"] == shard["graph_seed"]
        for shard in plan["shards"]
        for run in shard["runs"]
    )
    assert not any(
        endpoint in run
        for endpoint in ledger["endpoints"]
        for run in runs
    )
    assert build_plan(ledger) == plan
    print("neutral calibration shards: 32 graph-complete shards; 8832 runs; unrun")


if __name__ == "__main__":
    main()
