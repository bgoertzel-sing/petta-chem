#!/usr/bin/env bash
# Neutral v3 speedup validation (Ben msg 7901): run REAL prepared v3 batch
# queries through the exact batch command (same as run_neutral_v3_smoke.sh:
# nice -n 10 taskset -c 1-7 env PATH=<swipl 9.3.36>:/usr/bin:/bin sh PeTTa run.sh)
# with a selectable source tree.
#   run_neutral_v3_speedup_validation.sh SIDE(old|new) OUTDIR QUERY...
# old: the prepared query file unchanged (imports /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem/src = 6a5c0c1c).
# new: identical query text except the two import paths point at the speedup
#      worktree src/ (the ONLY harness difference; recorded per row).
set -uo pipefail
MAIN=/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem
WT=/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem-v3-speedup
PETTA=/home/openclaw/research-agent/projects/petta-chem/repos/PeTTa-pinned-4ce1d0ea
SWIPL_BIN=/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin
side=$1; out=$2; shift 2
mkdir -p "$out/queries"
for q in "$@"; do
  stem=$(basename "$q" .metta)
  if [ "$side" = new ]; then
    nq="$out/queries/$stem.metta"
    sed "s#$MAIN/src/#$WT/src/#g" "$q" >"$nq"
    root=$WT
  else
    nq="$q"; root=$MAIN
  fi
  ssa=$(grep -o '/[^ )]*chem_neutral_ssa.metta' "$nq")
  start=$(date +%s)
  ( cd "$root" && nice -n 10 taskset -c 1-7 env PATH=$SWIPL_BIN:/usr/bin:/bin sh "$PETTA/run.sh" "$nq" >"$out/$stem.stdout" 2>"$out/$stem.stderr" )
  rc=$?
  end=$(date +%s)
  printf '{"side":"%s","row":"%s","query":"%s","exit_code":%d,"seconds":%d,"start":%d,"query_sha256":"%s","ssa_path":"%s","ssa_sha256":"%s"}\n' "$side" "$stem" "$nq" "$rc" "$((end-start))" "$start" "$(sha256sum "$nq" | cut -d' ' -f1)" "$ssa" "$(sha256sum "$ssa" | cut -d' ' -f1)" >>"$out/timings.jsonl"
done
