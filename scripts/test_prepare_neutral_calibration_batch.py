#!/usr/bin/env python3
"""Synthetic gate for preparing the complete frozen calibration batch."""

from __future__ import annotations

import tempfile
from pathlib import Path

from prepare_neutral_calibration_queries import prepare


with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    manifests = [prepare(graph_seed, root) for graph_seed in range(1001, 1033)]

    assert [manifest["graph_seed"] for manifest in manifests] == list(range(1001, 1033))
    assert {manifest["run_count"] for manifest in manifests} == {276}
    assert all(manifest["status"] == "prepared-unrun" for manifest in manifests)
    assert all(manifest["endpoint_results_present"] is False for manifest in manifests)

    rows = [row for manifest in manifests for row in manifest["rows"]]
    keys = {
        (
            row["cohort"],
            row["L"],
            row["f_twice"],
            row["volume"],
            row["graph_seed"],
            row["dynamics_seed"],
        )
        for row in rows
    }
    assert len(rows) == len(keys) == 8832
    assert len(list(root.glob("graph-seed-*/queries/*.metta"))) == 8832

    try:
        prepare(1033, root)
    except ValueError as exc:
        assert "outside the frozen ledger" in str(exc)
    else:
        raise AssertionError("out-of-ledger graph seed was accepted")

print("neutral calibration batch preparation: 32 shards; 8832 exact rows; unrun")
