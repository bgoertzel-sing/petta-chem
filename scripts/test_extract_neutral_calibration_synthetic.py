#!/usr/bin/env python3
"""Exact nested-row and 32-shard synthetic extractor gate."""

import copy
import hashlib

from extract_neutral_calibration_synthetic import ValidationError, extract

IDENTITY = {"source_manifest_sha256": "a", "neutral_source_sha256": "b", "runner_sha256": "c",
            "petta_commit": "d", "petta_entrypoint_sha256": "e", "swipl_identity": "9.3.36", "mork_state": "absent"}


def atom(graph, dynamics, f2):
    return (f"(neutral-calibration-row model neutral-crs-v1 max-length 5 graph-seed {graph} "
            f"dynamics-seed {dynamics} f-twice {f2} volume 100 molecule-count 62 reaction-count 392 "
            "maximal-raf-rule-ids (r1 r2) endpoints (neutral-ablation-endpoints "
            "baseline-reachability (raf-reachability-summary reachable True first-time 12) "
            "ablated-reachability (raf-reachability-summary reachable False first-time censored) "
            "baseline-causal (neutral-causal-endpoints raf-events 9 evidence-bins 32 integrated-nonfood 20) "
            "ablated-causal (neutral-causal-endpoints raf-events 1 evidence-bins 4 integrated-nonfood 3) "
            "delta (neutral-causal-endpoint-delta raf-events 8 evidence-bins 28 integrated-nonfood 17)))")


def fixture():
    shards, records = [], []
    for graph in range(1001, 1033):
        receipts = []
        for index in range(276):
            dynamics, f2 = 2001 + index % 4, index // 4
            key = ["primary-transition", 5, f2, 100, graph, dynamics]
            receipts.append({"index": index, "exit_code": 0, "row_key": key})
            text = atom(graph, dynamics, f2)
            records.append({"graph_seed": graph, "index": index, "row_key": key,
                            "text": text, "sha256": hashlib.sha256(text.encode()).hexdigest()})
        shards.append({"schema": "neutral-calibration-raw-shard-v2", "status": "raw-complete-unanalysed",
                       "graph_seed": graph, "planned_count": 276, "completed_count": 276,
                       "receipts": receipts, **IDENTITY})
    return {"schema": "neutral-calibration-nested-synthetic-v2", "synthetic": True,
            "shards": shards, "records": records}


def rejects(case, label):
    try:
        extract(case)
    except ValidationError as exc:
        assert label in str(exc), (label, str(exc))
    else:
        raise AssertionError(f"expected {label} refusal")


def main():
    base = fixture()
    result = extract(base)
    assert result == {"schema": "neutral-calibration-nested-synthetic-summary-v2", "row_count": 8832,
                      "shard_count": 32, "irraf_count": "unavailable"}
    case = copy.deepcopy(base); case["shards"].pop(); rejects(case, "missing/duplicate shards")
    case = copy.deepcopy(base); case["shards"][1]["graph_seed"] = 1001; rejects(case, "missing/duplicate shards")
    case = copy.deepcopy(base); case["shards"][0]["receipts"].pop(); rejects(case, "receipt gaps")
    case = copy.deepcopy(base); case["shards"][0]["runner_sha256"] = "changed"; rejects(case, "identity disagreement")
    case = copy.deepcopy(base); case["records"].pop(); rejects(case, "row coverage disagreement")
    case = copy.deepcopy(base); case["records"][0]["text"] = case["records"][0]["text"].replace("endpoints (", "endpoints ") ; case["records"][0]["sha256"] = hashlib.sha256(case["records"][0]["text"].encode()).hexdigest(); rejects(case, "malformed nesting")
    case = copy.deepcopy(base); case["irraf_count"] = 2; rejects(case, "irrRAF count is unavailable")
    case = copy.deepcopy(base); case["synthetic"] = False; rejects(case, "authorized synthetic")
    print("neutral nested synthetic extractor: 32-shard contract and 8 refusals passed")


if __name__ == "__main__":
    main()
