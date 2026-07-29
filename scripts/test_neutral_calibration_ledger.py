#!/usr/bin/env python3
"""Validate the frozen neutral calibration matrix without running chemistry."""

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / "artifacts" / "neutral_calibration_ledger_v1.json"


def main() -> None:
    ledger = json.loads(LEDGER.read_text(encoding="utf-8"))
    assert ledger["schema"] == "neutral-calibration-ledger-v1"
    assert ledger["status"] == "frozen-unrun"
    assert ledger["provenance"]["calibration_endpoints_inspected"] is False

    graph_seeds = range(
        ledger["streams"]["graph_seeds"]["first"],
        ledger["streams"]["graph_seeds"]["last"] + 1,
    )
    dynamics_seeds = ledger["streams"]["dynamics_seeds"]
    assert list(graph_seeds) == list(range(1001, 1033))
    assert dynamics_seeds == [2001, 2002, 2003, 2004]

    runs = set()
    for cohort in ledger["cohorts"]:
        cohort_runs = {
            (length, f_twice, volume, graph_seed, dynamics_seed)
            for length in cohort["polymer_max_lengths"]
            for f_twice in cohort["f_twice"]
            for volume in cohort["volumes"]
            for graph_seed in graph_seeds
            for dynamics_seed in dynamics_seeds
        }
        assert len(cohort_runs) == cohort["run_count"]
        assert runs.isdisjoint(cohort_runs)
        runs.update(cohort_runs)

    assert len(runs) == ledger["total_unique_runs"] == 8832
    assert ledger["fixed_model"]["food"] == ["0", "1", "00", "01", "10", "11"]
    assert ledger["fixed_model"]["persistence_bins"] == {
        "count": 40,
        "width": 10,
        "first": 100,
        "last_exclusive": 500,
    }
    assert ledger["endpoints"] == [
        "structural-raf-existence",
        "dynamic-reachability",
        "active-persistent-raf",
        "causal-productive-effect",
    ]
    print("neutral calibration ledger: 8832 fixed unique runs; endpoints uninspected")


if __name__ == "__main__":
    main()
