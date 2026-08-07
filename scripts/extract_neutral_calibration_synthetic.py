#!/usr/bin/env python3
"""Validate fabricated nested PeTTa rows and 32-shard metadata, inline only."""

from __future__ import annotations

import hashlib
import json
import re
import sys

SCHEMA = "neutral-calibration-nested-synthetic-v2"
GRAPH_SEEDS = tuple(range(1001, 1033))
ROWS_PER_SHARD = 276
IDENTITY_FIELDS = ("source_manifest_sha256", "neutral_source_sha256", "runner_sha256",
                   "petta_commit", "petta_entrypoint_sha256", "swipl_identity", "mork_state")
TOKEN = re.compile(r"\(|\)|[^\s()]+")


class ValidationError(ValueError):
    """A fail-closed synthetic-bundle validation error."""


def _sha256(text: str) -> str:
    return hashlib.sha256(text.encode()).hexdigest()


def _sexpr(text: str):
    tokens = TOKEN.findall(text)
    pos = 0

    def parse():
        nonlocal pos
        if pos >= len(tokens) or tokens[pos] != "(":
            raise ValidationError("malformed nesting")
        pos += 1
        out = []
        while pos < len(tokens) and tokens[pos] != ")":
            if tokens[pos] == "(":
                out.append(parse())
            else:
                out.append(tokens[pos]); pos += 1
        if pos >= len(tokens):
            raise ValidationError("malformed nesting")
        pos += 1
        return out

    value = parse()
    if pos != len(tokens):
        raise ValidationError("malformed nesting")
    return value


def _pairs(items, context: str) -> dict:
    if len(items) % 2:
        raise ValidationError(f"malformed nesting: {context}")
    result = {}
    for i in range(0, len(items), 2):
        key = items[i]
        if not isinstance(key, str) or key in result:
            raise ValidationError(f"malformed nesting: {context}")
        result[key] = items[i + 1]
    return result


def _tagged(value, tag: str) -> dict:
    if not isinstance(value, list) or not value or value[0] != tag:
        raise ValidationError(f"malformed nesting: expected {tag}")
    return _pairs(value[1:], tag)


def _integer(value, name: str) -> int:
    if not isinstance(value, str) or not re.fullmatch(r"-?\d+", value):
        raise ValidationError(f"malformed nesting: {name}")
    return int(value)


def _parse_row(text: str) -> dict:
    top = _tagged(_sexpr(text), "neutral-calibration-row")
    required = {"model", "max-length", "graph-seed", "dynamics-seed", "f-twice", "volume",
                "molecule-count", "reaction-count", "maximal-raf-rule-ids", "endpoints"}
    if set(top) != required or top["model"] != "neutral-crs-v1":
        raise ValidationError("malformed nesting: calibration row fields")
    rule_ids = top["maximal-raf-rule-ids"]
    if not isinstance(rule_ids, list) or any(not isinstance(x, str) for x in rule_ids):
        raise ValidationError("malformed nesting: maximal RAF rule ids")
    endpoints = _tagged(top["endpoints"], "neutral-ablation-endpoints")
    expected = {"baseline-reachability", "ablated-reachability", "baseline-causal", "ablated-causal", "delta"}
    if set(endpoints) != expected:
        raise ValidationError("malformed nesting: ablation endpoints")
    base_reach = _tagged(endpoints["baseline-reachability"], "raf-reachability-summary")
    base_causal = _tagged(endpoints["baseline-causal"], "neutral-causal-endpoints")
    delta = _tagged(endpoints["delta"], "neutral-causal-endpoint-delta")
    _tagged(endpoints["ablated-reachability"], "raf-reachability-summary")
    _tagged(endpoints["ablated-causal"], "neutral-causal-endpoints")
    if set(base_reach) != {"reachable", "first-time"} or set(base_causal) != {"raf-events", "evidence-bins", "integrated-nonfood"} or set(delta) != {"raf-events", "evidence-bins", "integrated-nonfood"}:
        raise ValidationError("malformed nesting: endpoint fields")
    bins = _integer(base_causal["evidence-bins"], "evidence-bins")
    if not 0 <= bins <= 40 or base_reach["reachable"] not in ("True", "False"):
        raise ValidationError("malformed nesting: endpoint values")
    return {
        "L": _integer(top["max-length"], "max-length"),
        "f_twice": _integer(top["f-twice"], "f-twice"),
        "volume": _integer(top["volume"], "volume"),
        "graph_seed": _integer(top["graph-seed"], "graph-seed"),
        "dynamics_seed": _integer(top["dynamics-seed"], "dynamics-seed"),
        "molecule_count": _integer(top["molecule-count"], "molecule-count"),
        "reaction_count": _integer(top["reaction-count"], "reaction-count"),
        "raf_exists": bool(rule_ids), "maximal_raf_size": len(rule_ids),
        "reachable": base_reach["reachable"] == "True", "first_reach_time": base_reach["first-time"],
        "persistence_fraction": bins / 40,
        "raf_events": _integer(base_causal["raf-events"], "raf-events"),
        "delta_raf_events": _integer(delta["raf-events"], "delta raf-events"),
        "delta_integrated_nonfood": _integer(delta["integrated-nonfood"], "delta integrated-nonfood"),
        "irraf_count": None,
    }


def extract(bundle: dict) -> dict:
    if bundle.get("schema") != SCHEMA or bundle.get("synthetic") is not True:
        raise ValidationError("input is not an authorized synthetic bundle")
    if "irraf_count" in bundle or "irraf-count" in bundle:
        raise ValidationError("irrRAF count is unavailable and must not be invented")
    shards, records = bundle.get("shards"), bundle.get("records")
    if not isinstance(shards, list) or not isinstance(records, list):
        raise ValidationError("malformed: shards and records must be lists")
    if any(not isinstance(s, dict) for s in shards):
        raise ValidationError("malformed: shard metadata")
    seeds = [s.get("graph_seed") for s in shards]
    if len(shards) != 32 or len(set(seeds)) != len(seeds) or set(seeds) != set(GRAPH_SEEDS):
        raise ValidationError("missing/duplicate shards")
    reference = None
    expected = {}
    for shard in shards:
        if shard.get("schema") != "neutral-calibration-raw-shard-v2" or shard.get("status") != "raw-complete-unanalysed" or shard.get("planned_count") != ROWS_PER_SHARD or shard.get("completed_count") != ROWS_PER_SHARD:
            raise ValidationError("row coverage disagreement")
        identity = tuple(shard.get(k) for k in IDENTITY_FIELDS)
        if any(v is None for v in identity) or (reference is not None and identity != reference):
            raise ValidationError("identity disagreement")
        reference = identity
        receipts = shard.get("receipts")
        if not isinstance(receipts, list) or any(not isinstance(r, dict) for r in receipts):
            raise ValidationError("receipt gaps")
        if [r.get("index") for r in receipts] != list(range(ROWS_PER_SHARD)) or any(r.get("exit_code") != 0 for r in receipts):
            raise ValidationError("receipt gaps")
        for receipt in receipts:
            key = tuple(receipt.get("row_key", []))
            if len(key) != 6 or key[4] != shard["graph_seed"] or key in expected:
                raise ValidationError("row coverage disagreement")
            expected[key] = (shard["graph_seed"], receipt["index"])
    if len(expected) != 8832:
        raise ValidationError("row coverage disagreement")
    parsed = {}
    for item in records:
        if not isinstance(item, dict) or not isinstance(item.get("text"), str) or item.get("sha256") != _sha256(item.get("text", "")):
            raise ValidationError("hash-mismatched or malformed inline record")
        row = _parse_row(item["text"])
        if "irraf_count" in item or "irraf-count" in item:
            raise ValidationError("irrRAF count is unavailable and must not be invented")
        key = tuple(item.get("row_key", []))
        if expected.get(key) != (item.get("graph_seed"), item.get("index")) or key[1:] != (row["L"], row["f_twice"], row["volume"], row["graph_seed"], row["dynamics_seed"]):
            raise ValidationError("row coverage disagreement")
        if key in parsed:
            raise ValidationError("duplicate endpoint row")
        parsed[key] = row
    if set(parsed) != set(expected):
        raise ValidationError("row coverage disagreement")
    return {"schema": "neutral-calibration-nested-synthetic-summary-v2", "row_count": len(parsed),
            "shard_count": len(shards), "irraf_count": "unavailable"}


def main() -> None:
    try:
        print(json.dumps(extract(json.load(sys.stdin)), sort_keys=True))
    except (ValidationError, json.JSONDecodeError) as exc:
        print(json.dumps({"schema": "neutral-calibration-nested-synthetic-failure-v2", "status": "failed", "error": str(exc)}, sort_keys=True))
        raise SystemExit(1)


if __name__ == "__main__":
    main()
