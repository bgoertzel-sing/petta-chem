#!/usr/bin/env python3
import json
import tempfile
from pathlib import Path

from prepare_neutral_calibration_queries import prepare


with tempfile.TemporaryDirectory() as tmp:
    root = Path(tmp)
    manifest = prepare(1001, root)
    assert manifest["status"] == "prepared-unrun"
    assert manifest["run_count"] == 276
    assert manifest["endpoint_results_present"] is False
    assert {row["graph_seed"] for row in manifest["rows"]} == {1001}
    assert len({row["id"] for row in manifest["rows"]}) == 276
    assert len(list((root / "graph-seed-1001" / "queries").glob("*.metta"))) == 276

    first = (root / "graph-seed-1001" / manifest["rows"][0]["query"]).read_text()
    assert "neutral-ssa-run-calibration-row 5 1001 2001 0 1000000 500.0 100" in first
    assert first.endswith("100.0 10.0 40 32)\n")

    disk = json.loads((root / "graph-seed-1001" / "MANIFEST.json").read_text())
    assert disk == manifest

print("neutral calibration query preparation: 276 exact rows; unrun")
