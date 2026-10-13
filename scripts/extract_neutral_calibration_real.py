#!/usr/bin/env python3
"""EXPLORATORY real-data extractor for the neutral-calibration v2 batch.

Authorization: Ben Goertzel, 2026-10-13 10:31 PDT ("analyze what we have"),
after decision D1=B (accept skipped rows).  This is NOT the frozen
confirmatory extractor of docs/neutral_calibration_analysis_plan.md: it
accepts partial seeds and is labelled exploratory throughout.

Selection is metadata-only (receipts + SHA-256), then hash-verified intake.
The parser reads the nested neutral-calibration-row atom documented in
docs/neutral_calibration_extractor_contract_review.md.  It fails closed: a
row whose atom is missing / does not parse / has a malformed field is
excluded or flagged with a recorded reason, never imputed and never counted
negative.  It never recomputes chemistry or RAF membership.
"""
import argparse, glob, hashlib, json, os, re, subprocess

EXTRACTOR_VERSION = "neutral-calibration-real-exploratory-v1"
V2 = "experiments/neutral_calibration_v2"
V1 = "experiments/neutral_calibration_v1"
PARTIAL_DIRS = {  # seed -> attempt dirs, newest canonical first, then stale
    1010: ["attempt-001"],
    1011: ["attempt-003"],
    1012: ["attempt-003", "attempt-001"],
    1013: ["attempt-001"],
    1014: ["attempt-002.stale-*"],
    1017: ["attempt-003"],
    1018: ["attempt-002.stale-*"],
    1019: ["attempt-002.stale-*"],
    1020: ["attempt-002.stale-*"],
    1021: ["attempt-001"],
}


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for b in iter(lambda: fh.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


TOK = re.compile(r'\s*(?:(\()|(\))|("(?:[^"\\]|\\.)*")|([^\s()"]+))')


def parse_sexpr(text, start):
    stack, cur, pos = [], None, start
    while True:
        m = TOK.match(text, pos)
        if not m or m.end() == pos:
            raise ValueError("unterminated-atom")
        pos = m.end()
        if m.group(1):
            new = []
            if cur is not None:
                cur.append(new)
                stack.append(cur)
            cur = new
        elif m.group(2):
            if cur is None:
                raise ValueError("unbalanced")
            if not stack:
                return cur
            cur = stack.pop()
        elif m.group(3):
            cur.append(("str", m.group(3)[1:-1]))
        else:
            cur.append(m.group(4))


def kv(lst, keys, label):
    if len(lst) != 2 * len(keys):
        raise ValueError(f"{label}: expected {len(keys)} fields, got {len(lst)} items")
    out = {}
    for i, k in enumerate(keys):
        if lst[2 * i] != k:
            raise ValueError(f"{label}: expected key {k}, got {str(lst[2*i])[:40]!r}")
        out[k] = lst[2 * i + 1]
    return out


def as_int(x, label):
    if not isinstance(x, str) or not re.fullmatch(r"-?\d+", x):
        raise ValueError(f"{label}: not an integer: {str(x)[:60]!r}")
    return int(x)


def as_float(x, label):
    try:
        v = float(x)
    except Exception:
        raise ValueError(f"{label}: not a number: {str(x)[:60]!r}")
    if v != v or v in (float("inf"), float("-inf")):
        raise ValueError(f"{label}: non-finite")
    return v


def head_is(node, name, label):
    if not isinstance(node, list) or not node or node[0] != name:
        raise ValueError(f"{label}: expected ({name} ...), got {str(node)[:80]!r}")
    return node[1:]


def parse_reach(node, label):
    d = kv(head_is(node, "raf-reachability-summary", label), ["reachable", "first-time"], label)
    if d["reachable"] not in ("true", "false"):
        raise ValueError(f"{label}: reachable not boolean")
    reach = d["reachable"] == "true"
    ft = None if d["first-time"] == "censored" else as_float(d["first-time"], label + ".first-time")
    if reach and ft is None:
        raise ValueError(f"{label}: reachable but censored first-time")
    if not reach and ft is not None:
        raise ValueError(f"{label}: unreachable but finite first-time")
    return {"reachable": reach, "first_time": ft}


def parse_causal(node, name, label, signed=False):
    d = kv(head_is(node, name, label), ["raf-events", "evidence-bins", "integrated-nonfood"], label)
    ev = as_int(d["raf-events"], label + ".raf-events")
    bins = as_int(d["evidence-bins"], label + ".evidence-bins")
    nf = as_float(d["integrated-nonfood"], label + ".integrated-nonfood")
    if not signed and (ev < 0 or bins < 0 or bins > 40 or nf < 0):
        raise ValueError(f"{label}: out-of-range value")
    return {"raf_events": ev, "evidence_bins": bins, "integrated_nonfood": nf}


ROW_KEYS = ["model", "max-length", "graph-seed", "dynamics-seed", "f-twice", "volume",
            "molecule-count", "reaction-count", "maximal-raf-rule-ids", "endpoints"]


def find_row_atom(text):
    """The printed result atom starts a line; echoed source/goal text does not."""
    hits = [m.start() for m in re.finditer(r"(?m)^\(neutral-calibration-row ", text)]
    if not hits:
        raise ValueError("no-row-atom")
    if len(hits) > 1:
        raise ValueError(f"multiple-row-atoms:{len(hits)}")
    return parse_sexpr(text, hits[0])


def parse_row(text, expect):
    atom = find_row_atom(text)
    d = kv(head_is(atom, "neutral-calibration-row", "row"), ROW_KEYS, "row")
    if d["model"] != "neutral-crs-v1":
        raise ValueError("model mismatch")
    row = {"L": as_int(d["max-length"], "L"), "graph_seed": as_int(d["graph-seed"], "G"),
           "dynamics_seed": as_int(d["dynamics-seed"], "D"), "f_twice": as_int(d["f-twice"], "F2"),
           "V": as_int(d["volume"], "V"), "molecule_count": as_int(d["molecule-count"], "M"),
           "reaction_count": as_int(d["reaction-count"], "R")}
    for k, e in expect.items():
        if row[k] != e:
            raise ValueError(f"identity mismatch {k}: atom {row[k]} vs manifest {e}")
    row["f"] = row["f_twice"] / 2
    ids = d["maximal-raf-rule-ids"]
    # Contract: a flat list of rule-id strings.  Anything else (e.g. an
    # unreduced function call) is a malformed structural field -> unavailable.
    if isinstance(ids, list) and all(isinstance(x, tuple) and x[0] == "str" for x in ids):
        row.update(raf_field_status="ok", maximal_raf_rule_ids=[x[1] for x in ids],
                   raf_exists=len(ids) > 0, maximal_raf_size=len(ids))
    else:
        head = ids[0] if isinstance(ids, list) and ids and isinstance(ids[0], str) else type(ids).__name__
        row.update(raf_field_status=f"unreduced:{head}", maximal_raf_rule_ids=None,
                   raf_exists=None, maximal_raf_size=None)
    e = kv(head_is(d["endpoints"], "neutral-ablation-endpoints", "endpoints"),
           ["baseline-reachability", "ablated-reachability", "baseline-causal", "ablated-causal", "delta"],
           "endpoints")
    row["baseline_reach"] = parse_reach(e["baseline-reachability"], "baseline-reachability")
    row["ablated_reach"] = parse_reach(e["ablated-reachability"], "ablated-reachability")
    row["baseline_causal"] = parse_causal(e["baseline-causal"], "neutral-causal-endpoints", "baseline-causal")
    row["ablated_causal"] = parse_causal(e["ablated-causal"], "neutral-causal-endpoints", "ablated-causal")
    row["delta"] = parse_causal(e["delta"], "neutral-causal-endpoint-delta", "delta", signed=True)
    b, a, dl = row["baseline_causal"], row["ablated_causal"], row["delta"]
    if dl["raf_events"] != b["raf_events"] - a["raf_events"] or dl["evidence_bins"] != b["evidence_bins"] - a["evidence_bins"] \
            or abs(dl["integrated_nonfood"] - (b["integrated_nonfood"] - a["integrated_nonfood"])) > 1e-6 * max(1, abs(b["integrated_nonfood"])):
        raise ValueError("delta != baseline - ablated")
    return row


def attempt_dirs(seed, validated):
    gdir = f"{V2}/graph-seed-{seed}"
    out = [(f"{gdir}/{k.split('/')[1]}", "validated-complete") for k in validated if int(k.split("/")[0][1:]) == seed]
    for pat in PARTIAL_DIRS.get(seed, []):
        for p in sorted(glob.glob(f"{gdir}/{pat}")):
            out.append((p, "partial-stale" if ".stale-" in p else "partial-canonical"))
    return out


def verify_receipt(rpath, seed):
    try:
        r = json.load(open(rpath))
    except Exception:
        return None, "receipt-unparseable"
    if r.get("exit_code") != 0:
        return r, f"exit_code={r.get('exit_code')}"
    adir = os.path.dirname(os.path.dirname(rpath))
    for p, hk, nm in ((f"{V1}/graph-seed-{seed}/{r.get('query','')}", "query_sha256", "query"),
                      (f"{adir}/{r.get('stdout','')}", "stdout_sha256", "stdout"),
                      (f"{adir}/{r.get('stderr','')}", "stderr_sha256", "stderr")):
        if not os.path.isfile(p):
            return r, f"{nm}-file-missing"
        if sha256(p) != r.get(hk):
            return r, f"{nm}-hash-mismatch"
    return r, None


def git(*a):
    return subprocess.run(["git", *a], capture_output=True, text=True).stdout.strip()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    os.makedirs(args.out, exist_ok=True)
    validated = json.load(open(f"{V2}/orchestrator_state.json"))["validated"]
    prov = {"extractor_version": EXTRACTOR_VERSION, "repo_head": git("rev-parse", "HEAD"),
            "extractor_sha256": sha256(__file__),
            "orchestrator_state_sha256": sha256(f"{V2}/orchestrator_state.json"),
            "label": "EXPLORATORY (Ben D1=B authorization 2026-10-13); not the frozen confirmatory analysis"}
    seeds = sorted({int(k.split("/")[0][1:]) for k in validated} | set(PARTIAL_DIRS))
    rows, exclusions, per_attempt, manifest_hashes, missing = [], [], [], {}, []
    for seed in seeds:
        mpath = f"{V1}/graph-seed-{seed}/MANIFEST.json"
        manifest_hashes[str(seed)] = sha256(mpath)
        plan = {r["index"]: r for r in json.load(open(mpath))["rows"]}
        chosen, reasons = {}, {}
        for adir, kind in attempt_dirs(seed, validated):
            att = os.path.basename(adir)
            st = {"seed": seed, "attempt": att, "kind": kind, "receipts": 0, "hash_verified": 0,
                  "parsed": 0, "selected": 0, "excluded": {}, "skip_files": 0}
            for sp in glob.glob(f"{adir}/raw/*.SKIP.json"):
                st["skip_files"] += 1
                try:
                    sj = json.load(open(sp))
                    reasons.setdefault(sj["row_index"], []).append(f"{att}:skipped({sj.get('reason')})")
                except Exception:
                    pass
            for rp in sorted(glob.glob(f"{adir}/receipts/*.json")):
                st["receipts"] += 1
                r, why = verify_receipt(rp, seed)
                idx = r.get("index") if isinstance(r, dict) else None

                def excl(reason):
                    cls = reason.split(":")[0]
                    st["excluded"][cls] = st["excluded"].get(cls, 0) + 1
                    exclusions.append({"seed": seed, "attempt": att, "kind": kind, "row_index": idx,
                                       "receipt": rp, "reason": reason})
                    if idx is not None:
                        reasons.setdefault(idx, []).append(f"{att}:{reason}")
                if why:
                    excl("raw-lost:" + why)
                    continue
                st["hash_verified"] += 1
                pr = plan.get(idx)
                if pr is None or pr["id"] != r.get("id"):
                    excl("receipt-row-id-not-in-manifest")
                    continue
                if idx in chosen:
                    excl("duplicate-lower-priority-copy")
                    continue
                text = open(f"{adir}/{r['stdout']}", errors="replace").read()
                try:
                    row = parse_row(text, {"L": pr["L"], "graph_seed": seed, "dynamics_seed": pr["dynamics_seed"],
                                           "f_twice": pr["f_twice"], "V": pr["volume"]})
                except Exception as ex:
                    excl(f"parse-fail:{ex}")
                    continue
                st["parsed"] += 1
                st["selected"] += 1
                row.update({"row_index": idx, "row_id": pr["id"], "cohort": pr["cohort"], "attempt": att,
                            "source_kind": kind, "receipt_file": rp, "receipt_sha256": sha256(rp),
                            "stdout_sha256": r["stdout_sha256"], "attempt_id": r.get("attempt_id"),
                            "extractor_version": EXTRACTOR_VERSION})
                chosen[idx] = row
            per_attempt.append(st)
        for i, pr in plan.items():
            if i in chosen:
                continue
            rs = reasons.get(i, [])
            cls = ("parse-fail" if any("parse-fail" in x for x in rs) else
                   "skipped" if any("skipped" in x for x in rs) else
                   "raw-lost" if any("raw-lost" in x for x in rs) else "not-run")
            missing.append({"seed": seed, "row_index": i, "row_id": pr["id"], "cohort": pr["cohort"],
                            "L": pr["L"], "V": pr["volume"], "f": pr["f_twice"] / 2,
                            "dynamics_seed": pr["dynamics_seed"], "class": cls, "evidence": rs})
        rows.extend(chosen[i] for i in sorted(chosen))
    for name, data in (("canonical_rows", rows), ("exclusions", exclusions), ("missingness", missing)):
        with open(f"{args.out}/{name}.jsonl", "w") as fh:
            for x in data:
                fh.write(json.dumps(x, sort_keys=True) + "\n")
    rafstat = {}
    for r in rows:
        rafstat[r["raf_field_status"]] = rafstat.get(r["raf_field_status"], 0) + 1
    rep = {"provenance": prov, "source_manifest_sha256": manifest_hashes, "per_attempt": per_attempt,
           "rows_selected": len(rows), "exclusions": len(exclusions), "missing_rows": len(missing),
           "maximal_raf_field_status": rafstat,
           "seeds_with_zero_rows": [s for s in seeds if not any(r["graph_seed"] == s for r in rows)]}
    json.dump(rep, open(f"{args.out}/validation_report.json", "w"), indent=1, sort_keys=True)
    print(json.dumps({k: rep[k] for k in ("rows_selected", "exclusions", "missing_rows",
                                           "maximal_raf_field_status", "seeds_with_zero_rows")}))


if __name__ == "__main__":
    main()
