#!/usr/bin/env python3
"""Validate and aggregate inline synthetic neutral-calibration endpoint rows.

This gate deliberately has no raw-shard path interface.  It accepts only a
fabricated, inline JSON bundle marked synthetic and never opens PeTTa output
files.  A later reviewed gate must provide any real-artifact adapter.
"""

from __future__ import annotations

import hashlib
import json
import math
import re
import sys


SCHEMA = "neutral-calibration-synthetic-endpoints-v1"
RECORD = re.compile(
    r"^\(neutral-calibration-endpoint model neutral-crs-v1 "
    r"max-length (?P<L>\d+) f-twice (?P<f_twice>\d+) volume (?P<volume>\d+) "
    r"graph-seed (?P<graph_seed>\d+) dynamics-seed (?P<dynamics_seed>\d+) "
    r"arm matched-pair status (?P<status>[a-z-]+) "
    r"raf-exists (?P<raf>True|False) maximal-raf-size (?P<raf_size>\d+) "
    r"irraf-count (?P<irraf_count>\d+) reachable (?P<reachable>True|False) "
    r"first-reach-time (?P<first_time>censored|[-+]?\d+(?:\.\d+)?) "
    r"persistence-bins (?P<bins>\d+) persistence-fraction (?P<persistence>[-+]?\d+(?:\.\d+)?) "
    r"raf-events (?P<events>\d+) delta-raf-events (?P<delta_events>-?\d+) "
    r"delta-integrated-nonfood (?P<delta_nonfood>[-+]?\d+(?:\.\d+)?) "
    r"delta-persistence-fraction (?P<delta_persistence>[-+]?\d+(?:\.\d+)?)\)$"
)
KEYS = ("L", "f_twice", "volume", "graph_seed", "dynamics_seed", "arm")


class ValidationError(ValueError):
    """A fail-closed synthetic-bundle validation error."""


def _sha256(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def _parse(text: str) -> dict:
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    if len(lines) != 1:
        raise ValidationError("malformed: expected exactly one endpoint record")
    match = RECORD.fullmatch(lines[0])
    if not match:
        raise ValidationError("malformed: noncanonical endpoint record")
    values = match.groupdict()
    row = {name: int(values[name]) for name in (
        "L", "f_twice", "volume", "graph_seed", "dynamics_seed",
        "raf_size", "irraf_count", "bins", "events", "delta_events",
    )}
    row.update({
        "arm": "matched-pair",
        "status": values["status"],
        "raf_exists": values["raf"] == "True",
        "reachable": values["reachable"] == "True",
        "first_reach_time": values["first_time"],
        "persistence_fraction": float(values["persistence"]),
        "delta_integrated_nonfood": float(values["delta_nonfood"]),
        "delta_persistence_fraction": float(values["delta_persistence"]),
    })
    if row["status"] != "complete":
        raise ValidationError("censored: row execution status is not complete")
    numeric = (row["persistence_fraction"], row["delta_integrated_nonfood"],
               row["delta_persistence_fraction"])
    if not all(math.isfinite(value) for value in numeric):
        raise ValidationError("malformed: nonfinite numeric value")
    if not 0 <= row["persistence_fraction"] <= 1:
        raise ValidationError("malformed: persistence fraction outside [0,1]")
    if abs(row["delta_persistence_fraction"]) > 1:
        raise ValidationError("malformed: persistence delta outside [-1,1]")
    if row["bins"] > 40:
        raise ValidationError("malformed: persistence bin count exceeds 40")
    if row["raf_exists"] != (row["raf_size"] > 0):
        raise ValidationError("malformed: RAF existence/size implication failed")
    if not row["raf_exists"] and (row["reachable"] or row["bins"] or row["events"]):
        raise ValidationError("malformed: non-RAF graph has applicable dynamic endpoints")
    if row["reachable"] != (row["first_reach_time"] != "censored"):
        raise ValidationError("malformed: reachability/time implication failed")
    return row


def extract(bundle: dict) -> dict:
    if bundle.get("schema") != SCHEMA or bundle.get("synthetic") is not True:
        raise ValidationError("input is not an authorized synthetic bundle")
    expected = bundle.get("expected_rows")
    records = bundle.get("records")
    if not isinstance(expected, list) or not isinstance(records, list):
        raise ValidationError("malformed: expected_rows and records must be lists")
    expected_keys = [tuple(row.get(key) for key in KEYS) for row in expected]
    if len(set(expected_keys)) != len(expected_keys):
        raise ValidationError("duplicate: expected row key")
    parsed = []
    for item in records:
        if not isinstance(item, dict) or not isinstance(item.get("text"), str):
            raise ValidationError("malformed: inline record required")
        if item.get("sha256") != _sha256(item["text"]):
            raise ValidationError("hash-mismatched: endpoint record")
        parsed.append(_parse(item["text"]))
    actual_keys = [tuple(row[key] for key in KEYS) for row in parsed]
    if len(set(actual_keys)) != len(actual_keys):
        raise ValidationError("duplicate: endpoint row key")
    missing = sorted(set(expected_keys) - set(actual_keys))
    extra = sorted(set(actual_keys) - set(expected_keys))
    if missing or extra:
        label = "mis-keyed" if missing and extra else "missing"
        raise ValidationError(f"{label}: row coverage mismatch")

    groups: dict[tuple, list[dict]] = {}
    for row in parsed:
        key = tuple(row[name] for name in ("L", "f_twice", "volume", "graph_seed"))
        groups.setdefault(key, []).append(row)
    graph_rows = []
    for key, rows in sorted(groups.items()):
        raf_values = {(r["raf_exists"], r["raf_size"], r["irraf_count"]) for r in rows}
        if len(raf_values) != 1:
            raise ValidationError("malformed: structural endpoints vary by dynamics seed")
        raf_exists, raf_size, irraf_count = raf_values.pop()
        applicable = [r for r in rows if raf_exists]
        graph_rows.append({
            "L": key[0], "f_twice": key[1], "volume": key[2], "graph_seed": key[3],
            "raf_exists": raf_exists, "maximal_raf_size": raf_size,
            "irraf_count": irraf_count, "dynamics_seed_count": len(rows),
            "reachability_fraction": (sum(r["reachable"] for r in applicable) / len(applicable)
                                      if applicable else None),
            "mean_persistence_fraction": (sum(r["persistence_fraction"] for r in applicable) / len(applicable)
                                          if applicable else None),
            "mean_delta_raf_events": (sum(r["delta_events"] for r in applicable) / len(applicable)
                                      if applicable else None),
            "mean_delta_integrated_nonfood": (sum(r["delta_integrated_nonfood"] for r in applicable) / len(applicable)
                                              if applicable else None),
            "mean_delta_persistence_fraction": (sum(r["delta_persistence_fraction"] for r in applicable) / len(applicable)
                                                if applicable else None),
        })
    return {"schema": "neutral-calibration-synthetic-summary-v1", "row_count": len(parsed),
            "graph_count": len(graph_rows), "graph_rows": graph_rows}


def main() -> None:
    try:
        result = extract(json.load(sys.stdin))
    except (ValidationError, json.JSONDecodeError) as exc:
        print(json.dumps({"schema": "neutral-calibration-synthetic-failure-v1",
                          "status": "failed", "error": str(exc)}, sort_keys=True))
        raise SystemExit(1)
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
