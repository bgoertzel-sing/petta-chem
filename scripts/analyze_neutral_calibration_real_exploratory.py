#!/usr/bin/env python3
"""EXPLORATORY analysis of neutral-calibration v2 canonical rows.

Authorization: Ben Goertzel 2026-10-13 10:31 PDT (D1=B, "analyze what we
have").  Not the frozen confirmatory analysis.  Core = 22 validated complete
seeds (complete-case); partial-seed rows enter only a labelled sensitivity
analysis.  Python aggregates serialized PeTTa outputs only.

Gating rule (fail closed): structural endpoints require a reduced
maximal-raf-rule-ids list.  Rows whose field is unreduced have structural
endpoints UNAVAILABLE (not negative).  Because the dynamics/ablation
endpoints in the same row were computed from that RAF term, they are
reported only as DIAGNOSTIC descriptives, not as reachable/persistent/causal
evidence, whenever the RAF field is not reduced.
"""
import argparse, hashlib, json, math, os
import numpy as np

SEED = 73020260727
B = 10000
PANELS = {
    "primary-transition": lambda r: r["L"] == 5 and r["V"] == 100 and r["cohort"] == "primary-transition",
    "finite-size": lambda r: r["V"] == 100 and r["f_twice"] % 2 == 0 and r["L"] in (4, 5, 6),
    "population-scaling": lambda r: r["L"] == 5 and r["V"] in (50, 100, 200) and r["f_twice"] % 2 == 0,
}


def wilson(k, n, z=1.959963984540054):
    if n == 0:
        return None, None
    p = k / n
    d = 1 + z * z / n
    c = (p + z * z / (2 * n)) / d
    h = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / d
    return c - h, c + h


def pava(y, w):
    blocks = [[v, wt, 1] for v, wt in zip(y, w)]
    i = 0
    while i < len(blocks) - 1:
        if blocks[i][0] > blocks[i + 1][0]:
            a, b = blocks[i], blocks[i + 1]
            blocks[i] = [(a[0] * a[1] + b[0] * b[1]) / (a[1] + b[1]), a[1] + b[1], a[2] + b[2]]
            del blocks[i + 1]
            i = max(i - 1, 0)
        else:
            i += 1
    out = []
    for v, _, n in blocks:
        out += [v] * n
    return out


def f50(fs, inc, n):
    fit = pava(inc, n)
    if fit[0] >= 0.5:
        return "left-censored", fit
    for i in range(1, len(fs)):
        if fit[i] >= 0.5:
            f0, f1, y0, y1 = fs[i - 1], fs[i], fit[i - 1], fit[i]
            return f0 + (0.5 - y0) * (f1 - f0) / (y1 - y0), fit
    return "right-censored", fit


def graph_units(rows):
    """Collapse dynamics seeds within (panel-key, graph)."""
    g = {}
    for r in rows:
        g.setdefault((r["L"], r["V"], r["f_twice"], r["graph_seed"]), []).append(r)
    out = []
    for (L, V, f2, G), rs in sorted(g.items()):
        valid = all(x["raf_field_status"] == "ok" for x in rs)
        u = {"L": L, "V": V, "f": f2 / 2, "graph_seed": G, "n_dyn": len(rs),
             "dyn_seeds": sorted(x["dynamics_seed"] for x in rs),
             "raf_field_status": sorted({x["raf_field_status"] for x in rs}),
             "partial_source": any(x["source_kind"] != "validated-complete" for x in rs)}
        ex = {x["raf_exists"] for x in rs}
        u["raf_exists"] = ex.pop() if valid and len(ex) == 1 else None  # graph property; None = unavailable
        u["maximal_raf_size"] = rs[0]["maximal_raf_size"] if valid else None
        u["endpoint_validity"] = "valid" if valid else "diagnostic-only:raf-field-unreduced"
        u["reach_frac"] = float(np.mean([x["baseline_reach"]["reachable"] for x in rs]))
        u["persist_mean_frac"] = float(np.mean([x["baseline_causal"]["evidence_bins"] / 40 for x in rs]))
        u["persist_ge32_frac"] = float(np.mean([x["baseline_causal"]["evidence_bins"] >= 32 for x in rs]))
        u["raf_events_mean"] = float(np.mean([x["baseline_causal"]["raf_events"] for x in rs]))
        u["delta_raf_events"] = float(np.mean([x["delta"]["raf_events"] for x in rs]))
        u["delta_integrated_nonfood"] = float(np.mean([x["delta"]["integrated_nonfood"] for x in rs]))
        u["delta_persist_frac"] = float(np.mean([x["delta"]["evidence_bins"] / 40 for x in rs]))
        u["baseline_integrated_nonfood_mean"] = float(np.mean([x["baseline_causal"]["integrated_nonfood"] for x in rs]))
        out.append(u)
    return out


CONT = ["reach_frac", "persist_mean_frac", "persist_ge32_frac", "raf_events_mean", "delta_raf_events",
        "delta_integrated_nonfood", "delta_persist_frac", "baseline_integrated_nonfood_mean"]


def curve(units, rng_seed):
    keys = sorted({(u["L"], u["V"], u["f"]) for u in units})
    out = []
    for k in keys:
        us = [u for u in units if (u["L"], u["V"], u["f"]) == k]
        avail = [u for u in us if u["raf_exists"] is not None]
        kk = sum(u["raf_exists"] for u in avail)
        lo, hi = wilson(kk, len(avail))
        row = {"L": k[0], "V": k[1], "f": k[2], "n_graphs": len(us), "n_graphs_structural_available": len(avail),
               "raf_incidence": (kk / len(avail)) if avail else None, "wilson95": [lo, hi],
               "endpoint_validity": sorted({u["endpoint_validity"] for u in us})}
        rng = np.random.default_rng(rng_seed)
        n = len(us)
        idx = rng.integers(0, n, size=(B, n))
        for c in CONT:
            v = np.array([u[c] for u in us])
            bs = v[idx].mean(axis=1)
            row[c] = float(v.mean())
            row[c + "_boot95"] = [float(np.percentile(bs, 2.5)), float(np.percentile(bs, 97.5))]
        out.append(row)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", required=True)
    a = ap.parse_args()
    rows = [json.loads(l) for l in open(f"{a.dir}/canonical_rows.jsonl")]
    res = {"label": "EXPLORATORY - not the frozen confirmatory analysis", "analysis_seed": SEED,
           "bootstrap_resamples": B, "canonical_rows_sha256": hashlib.sha256(open(f"{a.dir}/canonical_rows.jsonl", "rb").read()).hexdigest(),
           "script_sha256": hashlib.sha256(open(__file__, "rb").read()).hexdigest(), "panels": {}}
    graph_rows = []
    for pname, pred in PANELS.items():
        for pop, filt in (("core", lambda r: r["source_kind"] == "validated-complete"), ("sensitivity_all", lambda r: True)):
            rs = [r for r in rows if pred(r) and filt(r)]
            units = graph_units(rs)
            for u in units:
                graph_rows.append(dict(u, panel=pname, population=pop))
            cv = curve(units, SEED)
            entry = {"n_rows": len(rs), "n_graph_units": len(units), "n_graphs": len({u["graph_seed"] for u in units}), "curve": cv}
            if pname == "primary-transition":
                avail = [c for c in cv if c["raf_incidence"] is not None]
                if len(avail) == len(cv) and cv:
                    val, fit = f50([c["f"] for c in cv], [c["raf_incidence"] for c in cv], [c["n_graphs_structural_available"] for c in cv])
                    entry["f50"] = val
                    entry["isotonic_fit"] = fit
                else:
                    entry["f50"] = "not-estimable: structural RAF field unavailable in %d/%d control points" % (len(cv) - len(avail), len(cv))
            res["panels"][f"{pname}/{pop}"] = entry
    json.dump(res, open(f"{a.dir}/analysis_results.json", "w"), indent=1)
    with open(f"{a.dir}/graph_table.jsonl", "w") as fh:
        for g in graph_rows:
            fh.write(json.dumps(g, sort_keys=True) + "\n")
    with open(f"{a.dir}/transition_curve.tsv", "w") as fh:
        cols = ["panel", "population", "L", "V", "f", "n_graphs", "n_graphs_structural_available", "raf_incidence", "wilson95"] + [x for c in CONT for x in (c, c + "_boot95")] + ["endpoint_validity"]
        fh.write("\t".join(cols) + "\n")
        for k, e in res["panels"].items():
            p, pop = k.split("/")
            for c in e["curve"]:
                d = dict(c, panel=p, population=pop)
                fh.write("\t".join(json.dumps(d[x]) if not isinstance(d[x], str) else d[x] for x in cols) + "\n")
    print(json.dumps({k: {"n_rows": v["n_rows"], "n_graphs": v["n_graphs"], "f50": v.get("f50")} for k, v in res["panels"].items()}, indent=1))


if __name__ == "__main__":
    main()
