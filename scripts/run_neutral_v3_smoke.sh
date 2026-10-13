#!/usr/bin/env bash
# Neutral v3 pre-launch smoke gate: run selected REAL prepared v3 grid rows
# through the exact launch command (nice/taskset/PATH + sh PeTTa run.sh query),
# writing outputs OUTSIDE any batch attempt dir.
#   run_neutral_v3_smoke.sh OUTDIR QUERY...   (runs sequentially)
set -uo pipefail
ROOT=/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem
PETTA=/home/openclaw/research-agent/projects/petta-chem/repos/PeTTa-pinned-4ce1d0ea
SWIPL_BIN=/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin
out=$1; shift
mkdir -p "$out"
for q in "$@"; do
  stem=$(basename "$q" .metta)
  start=$(date +%s)
  ( cd "$ROOT" && nice -n 10 taskset -c 1-7 env PATH=$SWIPL_BIN:/usr/bin:/bin sh "$PETTA/run.sh" "$q" >"$out/$stem.stdout" 2>"$out/$stem.stderr" )
  rc=$?
  end=$(date +%s)
  printf '{"row":"%s","query":"%s","exit_code":%d,"seconds":%d,"query_sha256":"%s"}\n' "$stem" "$q" "$rc" "$((end-start))" "$(sha256sum "$q" | cut -d' ' -f1)" >>"$out/timings.jsonl"
done
