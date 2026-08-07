#!/usr/bin/env python3
"""Synthetic-only validation gate for the neutral outcome extractor."""

import copy
import hashlib

from extract_neutral_calibration_synthetic import ValidationError, extract


def endpoint(dynamics_seed: int, *, graph_seed: int = 1001, status: str = "complete") -> str:
    return (
        "(neutral-calibration-endpoint model neutral-crs-v1 max-length 5 f-twice 4 "
        f"volume 100 graph-seed {graph_seed} dynamics-seed {dynamics_seed} "
        f"arm matched-pair status {status} raf-exists True maximal-raf-size 3 "
        "irraf-count 1 reachable True first-reach-time 12.5 persistence-bins 32 "
        "persistence-fraction 0.8 raf-events 9 delta-raf-events 4 "
        "delta-integrated-nonfood 2.5 delta-persistence-fraction 0.25)\n"
    )


def record(text: str) -> dict:
    return {"text": text, "sha256": hashlib.sha256(text.encode()).hexdigest()}


def fixture() -> dict:
    seeds = [2001, 2002, 2003, 2004]
    return {
        "schema": "neutral-calibration-synthetic-endpoints-v1", "synthetic": True,
        "expected_rows": [{"L": 5, "f_twice": 4, "volume": 100,
                           "graph_seed": 1001, "dynamics_seed": seed,
                           "arm": "matched-pair"} for seed in seeds],
        "records": [record(endpoint(seed)) for seed in seeds],
    }


def rejects(bundle: dict, label: str) -> None:
    try:
        extract(bundle)
    except ValidationError as exc:
        assert label in str(exc), (label, str(exc))
    else:
        raise AssertionError(f"expected {label} refusal")


def main() -> None:
    result = extract(fixture())
    assert result["row_count"] == 4 and result["graph_count"] == 1
    graph = result["graph_rows"][0]
    assert graph["dynamics_seed_count"] == 4
    assert graph["reachability_fraction"] == 1.0
    assert graph["mean_delta_raf_events"] == 4.0

    case = fixture(); case["records"].append(copy.deepcopy(case["records"][0])); rejects(case, "duplicate")
    case = fixture(); case["records"].pop(); rejects(case, "missing")
    case = fixture(); case["records"][0] = record(endpoint(2001, graph_seed=1002)); rejects(case, "mis-keyed")
    case = fixture(); case["records"][0] = record("not an atom\n"); rejects(case, "malformed")
    case = fixture(); case["records"][0] = record(endpoint(2001, status="censored")); rejects(case, "censored")
    case = fixture(); case["records"][0]["sha256"] = "0" * 64; rejects(case, "hash-mismatched")
    case = fixture(); case["synthetic"] = False; rejects(case, "authorized synthetic")

    # Failure is atomic: extraction raises and therefore cannot return a partial summary.
    case = fixture(); case["records"].pop()
    try:
        partial = extract(case)
    except ValidationError:
        partial = None
    assert partial is None
    print("neutral synthetic extractor: aggregation and 7 fail-closed classes passed")


if __name__ == "__main__":
    main()
