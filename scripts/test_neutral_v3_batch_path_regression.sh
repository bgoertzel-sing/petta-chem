#!/usr/bin/env bash
# Batch-path regression test for the v2 "unevaluated neutral-raf-*" defect.
# Generates queries ONLY through the batch prepare path
# (scripts/prepare_neutral_calibration_queries.py), runs one real row through
# the pinned PeTTa run.sh exactly as the batch runner does (no hand-written
# harness, no extra imports), and requires the per-row validator to pass:
# maximal-raf-rule-ids must be a flat list of rule-ID strings, with no
# neutral-raf-*/neutral-ssa-* symbols anywhere in the row atom.
# Default row: g1001 index 100 (finite-size-control L4 f2-16, ~1-3 min).
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
PETTA=${PETTA:-/home/openclaw/research-agent/projects/petta-chem/repos/PeTTa-pinned-4ce1d0ea}
SWIPL_BIN=${SWIPL_BIN:-/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin}
INDEX=${INDEX:-100}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cd "$ROOT/scripts"
python3 prepare_neutral_calibration_queries.py --graph-seed 1001 --output-root "$tmp" >/dev/null
read -r query L F V G D < <(python3 - "$tmp" "$INDEX" <<'EOF'
import json, sys
m = json.load(open(f"{sys.argv[1]}/graph-seed-1001/MANIFEST.json"))
r = m["rows"][int(sys.argv[2])]
print(f"{sys.argv[1]}/graph-seed-1001/{r['query']}", r["L"], r["f_twice"], r["volume"], r["graph_seed"], r["dynamics_seed"])
EOF
)
rc=0
env PATH="$SWIPL_BIN:/usr/bin:/bin" sh "$PETTA/run.sh" "$query" >"$tmp/out" 2>"$tmp/err" || rc=$?
python3 "$ROOT/scripts/validate_neutral_calibration_row.py" --stdout "$tmp/out" --stderr "$tmp/err" \
  --L "$L" --f-twice "$F" --volume "$V" --graph-seed "$G" --dynamics-seed "$D" --exit-code "$rc" >"$tmp/verdict.json" || {
  cat "$tmp/verdict.json"; echo "FAIL: batch-path row did not validate"; exit 1; }
python3 - "$tmp/verdict.json" <<'EOF'
import json, sys
v = json.load(open(sys.argv[1]))
assert v["verdict"] == "pass", v
print(f"batch-path regression: PASS (row L{v['summary']['L']} f2-{v['summary']['f_twice']}, "
      f"maximal-raf-rule-ids is a flat list of {v['summary']['raf_size']} rule IDs)")
EOF
