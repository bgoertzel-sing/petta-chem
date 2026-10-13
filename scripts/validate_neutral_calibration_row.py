#!/usr/bin/env python3
"""Per-row content validator for neutral-calibration v3 raw rows.

Authority: Ben Goertzel, Telegram msg 7878 (2026-10-13): "add to the process a
detailed check of each experiments result file when it is completed, to avoid
further disastrous bugs of this nature".  The v2 (and v1) batches printed an
unevaluated (neutral-raf-reaction-ids (neutral-raf-maximal-reactions ...))
term in every row because chem_neutral_raf.metta was never imported by the
batch queries; nothing checked row CONTENT, only exit codes and hashes.

The v3 runner calls validate_files() right after each PeTTa row exits and
BEFORE the row receipt is published; a failing row never gets a receipt.
This is a well-formedness / structural-consistency check, not an analysis:
it never aggregates rows, compares cohorts, or estimates anything.  It fails
closed: any doubt is a failure with a recorded reason.

Checks (each failure appends a reason string):
  * exit code 0; stderr empty; stdout has no Prolog error/warning markers.
  * exactly one printed (neutral-calibration-row ...) result atom, parsed
    completely, with exactly the frozen key sequence and nothing after it.
  * every symbol in the atom is in a closed whitelist (frozen keys/heads,
    neutral-crs-v1, true/false, censored) or a number; any other symbol --
    in particular neutral-raf-*, neutral-ssa-*, raf-* or any other function
    head -- means an unevaluated call and fails the row.
  * identity: model, max-length, graph-seed, dynamics-seed, f-twice, volume
    equal the planned manifest row; molecule-count and reaction-count equal
    the exact combinatorial universe sizes for L.
  * maximal-raf-rule-ids is a FLAT list of unique rule-ID strings matching the
    frozen ID grammar (lig:<bin>:<bin> / cleave:<bin>:<k>) consistent with L;
    size <= reaction-count; f-twice 0 (no catalysis) => empty.
  * reachability: reachable is boolean; first-time is a finite float in
    [0, T] iff reachable, else censored.
  * causal arms: raf-events nonnegative int, evidence-bins int in
    0..bin_count, integrated-nonfood finite and >= 0; delta exactly equals
    baseline - ablated (ints exact, float within 1e-9 relative).
  * implications: RAF empty => raf-events 0 and evidence-bins 0 in both arms;
    evidence-bins > 0 => raf-events > 0; reachable true => RAF nonempty
    (equivalently RAF empty => reachable false), both arms.

CLI: validate_neutral_calibration_row.py --stdout F --stderr F --L 5
  --f-twice 16 --volume 100 --graph-seed 1001 --dynamics-seed 2001
Prints a JSON verdict; exit 0 on pass, 1 on fail.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
import sys
from pathlib import Path

VALIDATOR_VERSION = "neutral-calibration-row-validator-v1"
STOP_TIME = 500.0
BIN_COUNT = 40
MODEL = "neutral-crs-v1"

ROW_KEYS = ["model", "max-length", "graph-seed", "dynamics-seed", "f-twice", "volume",
            "molecule-count", "reaction-count", "maximal-raf-rule-ids", "endpoints"]
ENDPOINT_KEYS = ["baseline-reachability", "ablated-reachability", "baseline-causal",
                 "ablated-causal", "delta"]
REACH_KEYS = ["reachable", "first-time"]
CAUSAL_KEYS = ["raf-events", "evidence-bins", "integrated-nonfood"]
HEADS = ["neutral-calibration-row", "neutral-ablation-endpoints", "raf-reachability-summary",
         "neutral-causal-endpoints", "neutral-causal-endpoint-delta"]
ALLOWED_SYMBOLS = frozenset(ROW_KEYS + ENDPOINT_KEYS + REACH_KEYS + CAUSAL_KEYS + HEADS
                            + [MODEL, "true", "false", "censored"])
RULE_ID = re.compile(r"^(?:lig:([01]+):([01]+)|cleave:([01]+):([0-9]+))$")
NUMBER = re.compile(r"^-?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?$")
INT = re.compile(r"^-?\d+$")
STDOUT_MARKERS = re.compile(
    r"(?m)^(?:ERROR:|Warning:|.*existence_error|.*Unknown procedure|.*Stack limit .*exceeded"
    r"|.*Out of (?:global|local) stack)")
ROW_START = re.compile(r"(?m)^\(neutral-calibration-row(?=[\s)])")
TOK = re.compile(r'\s*(?:(\()|(\))|("(?:[^"\\]|\\.)*")|([^\s()"]+))')


class RowError(ValueError):
    pass


def validator_sha256() -> str:
    return hashlib.sha256(Path(__file__).read_bytes()).hexdigest()


def molecule_count(L: int) -> int:
    return 2 ** (L + 1) - 2


def reaction_count(L: int) -> int:
    # every polymer of length n >= 2 has n-1 split points; each split is one
    # ligation rule and one cleavage rule.
    return 2 * sum((2 ** n) * (n - 1) for n in range(2, L + 1))


def parse_sexpr(text: str, start: int):
    stack: list = []
    cur = None
    pos = start
    while True:
        m = TOK.match(text, pos)
        if not m or m.end() == pos:
            raise RowError("unterminated row atom")
        pos = m.end()
        if m.group(1):
            new: list = []
            if cur is not None:
                cur.append(new)
                stack.append(cur)
            cur = new
        elif m.group(2):
            if cur is None:
                raise RowError("unbalanced ')'")
            if not stack:
                return cur, pos
            cur = stack.pop()
        elif cur is None:
            raise RowError("token outside row atom")
        elif m.group(3):
            cur.append(("str", m.group(3)[1:-1]))
        else:
            cur.append(m.group(4))


def walk_symbols(node, out: list) -> None:
    if isinstance(node, list):
        for child in node:
            walk_symbols(child, out)
    elif isinstance(node, str):
        out.append(node)


def kv(items: list, keys: list, label: str) -> dict:
    if len(items) != 2 * len(keys):
        raise RowError(f"{label}: expected {len(keys)} key/value pairs, got {len(items)} items")
    out = {}
    for i, key in enumerate(keys):
        if items[2 * i] != key:
            raise RowError(f"{label}: expected key {key!r}, got {str(items[2 * i])[:60]!r}")
        out[key] = items[2 * i + 1]
    return out


def head(node, name: str, label: str) -> list:
    if not isinstance(node, list) or not node or node[0] != name:
        raise RowError(f"{label}: expected ({name} ...), got {str(node)[:120]!r}")
    return node[1:]


def as_int(x, label: str) -> int:
    if not isinstance(x, str) or not INT.match(x):
        raise RowError(f"{label}: not an integer: {str(x)[:80]!r}")
    return int(x)


def as_float(x, label: str) -> float:
    if not isinstance(x, str) or not NUMBER.match(x):
        raise RowError(f"{label}: not a finite number: {str(x)[:80]!r}")
    v = float(x)
    if not math.isfinite(v):
        raise RowError(f"{label}: non-finite")
    return v


def as_bool(x, label: str) -> bool:
    if x not in ("true", "false"):
        raise RowError(f"{label}: not boolean: {str(x)[:80]!r}")
    return x == "true"


def check_reach(node, label: str, reasons: list) -> dict:
    d = kv(head(node, "raf-reachability-summary", label), REACH_KEYS, label)
    reachable = as_bool(d["reachable"], f"{label}.reachable")
    if d["first-time"] == "censored":
        ft = None
    else:
        ft = as_float(d["first-time"], f"{label}.first-time")
        if not (0.0 <= ft <= STOP_TIME):
            reasons.append(f"{label}.first-time {ft} outside [0, {STOP_TIME}]")
    if reachable and ft is None:
        reasons.append(f"{label}: reachable true but first-time censored")
    if not reachable and ft is not None:
        reasons.append(f"{label}: reachable false but finite first-time {ft}")
    return {"reachable": reachable, "first_time": ft}


def check_causal(node, name: str, label: str, reasons: list, signed: bool = False) -> dict:
    d = kv(head(node, name, label), CAUSAL_KEYS, label)
    ev = as_int(d["raf-events"], f"{label}.raf-events")
    bins = as_int(d["evidence-bins"], f"{label}.evidence-bins")
    nf = as_float(d["integrated-nonfood"], f"{label}.integrated-nonfood")
    if not signed:
        if ev < 0:
            reasons.append(f"{label}.raf-events {ev} < 0")
        if not 0 <= bins <= BIN_COUNT:
            reasons.append(f"{label}.evidence-bins {bins} outside 0..{BIN_COUNT}")
        if nf < 0:
            reasons.append(f"{label}.integrated-nonfood {nf} < 0")
        if bins > 0 and ev == 0:
            reasons.append(f"{label}: evidence-bins {bins} > 0 with zero raf-events")
    elif abs(bins) > BIN_COUNT:
        reasons.append(f"{label}.evidence-bins {bins} outside +-{BIN_COUNT}")
    return {"raf_events": ev, "evidence_bins": bins, "integrated_nonfood": nf}


def validate_text(stdout: str, stderr: str, expected: dict, exit_code: int = 0) -> dict:
    """Return {"verdict": "pass"|"fail", "reasons": [...], "summary": {...}}.

    expected keys: L, f_twice, volume, graph_seed, dynamics_seed.
    """
    reasons: list = []
    summary: dict = {}
    if exit_code != 0:
        reasons.append(f"exit code {exit_code}")
    if stderr.strip():
        reasons.append(f"stderr non-empty: {stderr.strip().splitlines()[0][:160]!r}")
    m = STDOUT_MARKERS.search(stdout)
    if m:
        reasons.append(f"stdout error marker: {m.group(0).strip()[:160]!r}")

    starts = [m.start() for m in ROW_START.finditer(stdout)]
    if not starts:
        reasons.append("no (neutral-calibration-row ...) result atom")
        return {"verdict": "fail", "reasons": reasons, "summary": summary}
    if len(starts) > 1:
        reasons.append(f"{len(starts)} result atoms (exactly one required)")
        return {"verdict": "fail", "reasons": reasons, "summary": summary}
    try:
        atom, end = parse_sexpr(stdout, starts[0])
        trailing = stdout[end:].strip()
        if trailing:
            reasons.append(f"unexpected output after row atom: {trailing[:120]!r}")

        symbols: list = []
        walk_symbols(atom, symbols)
        bad = sorted({s for s in symbols if s not in ALLOWED_SYMBOLS and not NUMBER.match(s)})
        if bad:
            fn = [s for s in bad if s.startswith(("neutral-raf-", "neutral-ssa-", "raf-"))]
            reasons.append("unevaluated/unexpected symbols in row atom: " + ", ".join(bad[:12])
                           + (f" (function symbols: {', '.join(fn[:6])})" if fn else ""))

        d = kv(head(atom, "neutral-calibration-row", "row"), ROW_KEYS, "row")
        if d["model"] != MODEL:
            reasons.append(f"model {str(d['model'])[:60]!r} != {MODEL}")
        ident = {
            "L": as_int(d["max-length"], "max-length"),
            "graph_seed": as_int(d["graph-seed"], "graph-seed"),
            "dynamics_seed": as_int(d["dynamics-seed"], "dynamics-seed"),
            "f_twice": as_int(d["f-twice"], "f-twice"),
            "volume": as_int(d["volume"], "volume"),
        }
        summary.update(ident)
        for key in ("L", "f_twice", "volume", "graph_seed", "dynamics_seed"):
            if ident[key] != expected[key]:
                reasons.append(f"identity mismatch {key}: atom {ident[key]} != planned {expected[key]}")
        L = ident["L"]
        mc = as_int(d["molecule-count"], "molecule-count")
        rc = as_int(d["reaction-count"], "reaction-count")
        if mc != molecule_count(L):
            reasons.append(f"molecule-count {mc} != {molecule_count(L)} for L={L}")
        if rc != reaction_count(L):
            reasons.append(f"reaction-count {rc} != {reaction_count(L)} for L={L}")

        ids_node = d["maximal-raf-rule-ids"]
        if not isinstance(ids_node, list):
            raise RowError(f"maximal-raf-rule-ids is not a list: {str(ids_node)[:120]!r}")
        offending = [x for x in ids_node if not (isinstance(x, tuple) and x[0] == "str")]
        if offending:
            raise RowError("maximal-raf-rule-ids is not a flat list of rule-ID strings "
                           f"(first offending element {str(offending[0])[:120]!r})")
        ids = [x[1] for x in ids_node]
        for rid in ids:
            m = RULE_ID.match(rid)
            if not m:
                reasons.append(f"malformed rule id {rid!r}")
            elif m.group(1) is not None:
                if len(m.group(1)) + len(m.group(2)) > L:
                    reasons.append(f"ligation {rid!r} product longer than L={L}")
            else:
                poly, k = m.group(3), int(m.group(4))
                if len(poly) > L or not 1 <= k < len(poly):
                    reasons.append(f"cleavage {rid!r} inconsistent with L={L}")
        if len(set(ids)) != len(ids):
            reasons.append("duplicate rule ids in maximal RAF")
        if len(ids) > rc:
            reasons.append(f"maximal RAF size {len(ids)} > reaction-count {rc}")
        raf_empty = not ids
        if ident["f_twice"] == 0 and not raf_empty:
            reasons.append(f"f-twice 0 (no catalysis) but maximal RAF has {len(ids)} rules")
        summary["raf_size"] = len(ids)

        e = kv(head(d["endpoints"], "neutral-ablation-endpoints", "endpoints"), ENDPOINT_KEYS,
               "endpoints")
        br = check_reach(e["baseline-reachability"], "baseline-reachability", reasons)
        ar = check_reach(e["ablated-reachability"], "ablated-reachability", reasons)
        bc = check_causal(e["baseline-causal"], "neutral-causal-endpoints", "baseline-causal", reasons)
        ac = check_causal(e["ablated-causal"], "neutral-causal-endpoints", "ablated-causal", reasons)
        dl = check_causal(e["delta"], "neutral-causal-endpoint-delta", "delta", reasons, signed=True)
        if dl["raf_events"] != bc["raf_events"] - ac["raf_events"]:
            reasons.append("delta.raf-events != baseline - ablated")
        if dl["evidence_bins"] != bc["evidence_bins"] - ac["evidence_bins"]:
            reasons.append("delta.evidence-bins != baseline - ablated")
        want = bc["integrated_nonfood"] - ac["integrated_nonfood"]
        if abs(dl["integrated_nonfood"] - want) > 1e-9 * max(1.0, abs(bc["integrated_nonfood"]),
                                                              abs(ac["integrated_nonfood"])):
            reasons.append("delta.integrated-nonfood != baseline - ablated")
        for label, reach in (("baseline", br), ("ablated", ar)):
            if reach["reachable"] and raf_empty:
                reasons.append(f"{label} reachable true but maximal RAF is empty")
        if raf_empty:
            for label, causal in (("baseline", bc), ("ablated", ac)):
                if causal["raf_events"] != 0 or causal["evidence_bins"] != 0:
                    reasons.append(f"{label}-causal has RAF events/bins but maximal RAF is empty")
        summary.update(baseline_reachable=br["reachable"], ablated_reachable=ar["reachable"])
    except RowError as exc:
        reasons.append(str(exc))
    return {"verdict": "fail" if reasons else "pass", "reasons": reasons, "summary": summary}


def validate_files(stdout_path: Path, stderr_path: Path, expected: dict, exit_code: int = 0) -> dict:
    stdout = Path(stdout_path).read_text(encoding="utf-8", errors="replace")
    stderr = Path(stderr_path).read_text(encoding="utf-8", errors="replace")
    result = validate_text(stdout, stderr, expected, exit_code)
    result["validator_version"] = VALIDATOR_VERSION
    result["validator_sha256"] = validator_sha256()
    return result


def expected_from_manifest_row(row: dict) -> dict:
    return {"L": row["L"], "f_twice": row["f_twice"], "volume": row["volume"],
            "graph_seed": row["graph_seed"], "dynamics_seed": row["dynamics_seed"]}


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--stdout", required=True, type=Path)
    p.add_argument("--stderr", required=True, type=Path)
    p.add_argument("--L", required=True, type=int)
    p.add_argument("--f-twice", required=True, type=int)
    p.add_argument("--volume", required=True, type=int)
    p.add_argument("--graph-seed", required=True, type=int)
    p.add_argument("--dynamics-seed", required=True, type=int)
    p.add_argument("--exit-code", type=int, default=0)
    a = p.parse_args()
    expected = {"L": a.L, "f_twice": a.f_twice, "volume": a.volume,
                "graph_seed": a.graph_seed, "dynamics_seed": a.dynamics_seed}
    result = validate_files(a.stdout, a.stderr, expected, a.exit_code)
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0 if result["verdict"] == "pass" else 1


if __name__ == "__main__":
    sys.exit(main())
