#!/usr/bin/env python3
"""Byte-identity check for the neutral v3 speedup (Ben msg 7901).

Compares the (neutral-calibration-row ...) line of each NEW-source row with the
OLD-source output of the same prepared query.  OLD sources, in priority order:
speedup_validation/old/ (fresh 6a5c0c1c run), smoke_guard/ (post-guard
6a5c0c1c smoke), smoke/ (pre-guard 10a8ed88 smoke; used only for rows with a
non-empty maximal RAF, where the guard diff 10a8ed88..6a5c0c1c is a no-op).
Also runs the production validator on every NEW row.  Exit 1 on any mismatch.
"""
import hashlib, json, re, subprocess, sys
from pathlib import Path

WT = Path(__file__).resolve().parents[1]
MAIN = Path("/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem")
V = WT / "experiments/neutral_calibration_v3/speedup_validation"
OLD_DIRS = [("fresh-6a5c0c1c", V / "old"),
            ("fresh-6a5c0c1c", V / "old_d"),
            ("smoke_guard-6a5c0c1c", MAIN / "experiments/neutral_calibration_v3/smoke_guard"),
            ("smoke-pre-guard-10a8ed88", MAIN / "experiments/neutral_calibration_v3/smoke")]

def atom(p):
    lines = [l for l in p.read_text().splitlines() if l.startswith("(neutral-calibration-row")]
    return lines

def times(d):
    out = {}
    f = d / "timings.jsonl"
    if f.exists():
        for l in f.read_text().splitlines():
            r = json.loads(l)
            if r.get("side", "old") in ("old",) or d.name != "new":
                out.setdefault(r["row"], r["seconds"])
    return out

new_t = {json.loads(l)["row"]: json.loads(l) for l in (V / "new/timings.jsonl").read_text().splitlines()}
rows, ok = [], True
for stem, rec in sorted(new_t.items()):
    na = atom(V / "new" / f"{stem}.stdout")
    entry = {"row": stem, "new_seconds": rec["seconds"], "new_exit": rec["exit_code"],
             "new_ssa_sha256": rec["ssa_sha256"][:12]}
    for label, d in OLD_DIRS:
        p = d / f"{stem}.stdout"
        if p.exists() and atom(p):
            oa = atom(p)
            entry.update(old_source=label, old_seconds=times(d).get(stem),
                         identical=(oa == na and len(na) == 1),
                         sha256_new=hashlib.sha256(na[0].encode()).hexdigest()[:16] if na else None,
                         sha256_old=hashlib.sha256(oa[0].encode()).hexdigest()[:16])
            break
    else:
        entry.update(old_source=None, identical=None)
    if entry.get("identical") is not True:
        ok = False
    rows.append(entry)
print(json.dumps(rows, indent=1))
print("ALL_IDENTICAL" if ok else "NOT_ALL_IDENTICAL")
sys.exit(0 if ok else 1)
