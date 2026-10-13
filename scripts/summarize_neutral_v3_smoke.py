#!/usr/bin/env python3
"""Validate every v3 smoke-gate output and print a well-formedness table."""
import json, re, sys, hashlib
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent))
import validate_neutral_calibration_row as v

smoke = Path(sys.argv[1] if len(sys.argv) > 1 else "experiments/neutral_calibration_v3/smoke")
timings = {}
if (smoke / "timings.jsonl").exists():
    for line in (smoke / "timings.jsonl").read_text().splitlines():
        t = json.loads(line); timings[t["row"]] = t
rows = []
for out in sorted(smoke.glob("*.stdout")):
    stem = out.stem
    if stem not in timings:
        continue  # still running
    m = re.search(r"-L(\d+)-f2-(\d+)-V(\d+)-g(\d+)-d(\d+)$", stem)
    exp = dict(L=int(m[1]), f_twice=int(m[2]), volume=int(m[3]), graph_seed=int(m[4]), dynamics_seed=int(m[5]))
    r = v.validate_files(out, out.with_suffix(".stderr"), exp, timings[stem]["exit_code"])
    text = out.read_text()
    atom_line = next((l for l in text.splitlines() if l.startswith("(neutral-calibration-row")), "")
    rows.append({"row": stem, "seconds": timings[stem]["seconds"], "exit": timings[stem]["exit_code"],
                 "verdict": r["verdict"], "reasons": r["reasons"], "raf_size": r["summary"].get("raf_size"),
                 "fn_symbols_in_atom": sorted(set(re.findall(r"\b(neutral-(?:raf|ssa)-[\w?-]+)", atom_line))),
                 "baseline_reachable": r["summary"].get("baseline_reachable"),
                 "stdout_sha256": hashlib.sha256(out.read_bytes()).hexdigest(),
                 "query_sha256": timings[stem]["query_sha256"], "validator_sha256": r["validator_sha256"]})
print(json.dumps(rows, indent=1))
