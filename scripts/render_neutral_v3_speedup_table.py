#!/usr/bin/env python3
"""Render the byte-identity table for SPEEDUP_VALIDATION.md (stdout markdown)."""
import json, subprocess, sys
from pathlib import Path
WT = Path(__file__).resolve().parents[1]
p = subprocess.run([sys.executable, str(WT / "scripts/compare_neutral_v3_speedup_rows.py")], capture_output=True, text=True)
t = p.stdout; i = t.rfind("]"); rows = json.loads(t[:i + 1]); verdict = t[i + 1:].strip()
print("| row | old source | old wall s | new wall s | speedup | row atom sha256 (old / new, 16 hex) | byte-identical |")
print("|---|---|---|---|---|---|---|")
for r in rows:
    o, n = r.get("old_seconds"), r["new_seconds"]
    sp = f"{o / n:.1f}x" if o and n else "-"
    print(f"| {r['row']} | {r.get('old_source')} | {o} | {n} | {sp} | {r.get('sha256_old')} / {r.get('sha256_new')} | **{r.get('identical')}** |")
print()
print(f"Verdict: **{verdict}** (compare exit code {p.returncode})")
