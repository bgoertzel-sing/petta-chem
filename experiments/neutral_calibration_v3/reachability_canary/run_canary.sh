#!/usr/bin/env bash
# Run reachability canary queries through the exact batch command.
set -uo pipefail
PETTA=/home/openclaw/research-agent/projects/petta-chem/repos/PeTTa-pinned-4ce1d0ea
SWIPL_BIN=/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin
D=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$D/out"
for q in "$D"/queries/*.metta; do
  stem=$(basename "$q" .metta)
  start=$(date +%s)
  ( cd /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem && nice -n 10 taskset -c 1-7 env PATH=$SWIPL_BIN:/usr/bin:/bin sh "$PETTA/run.sh" "$q" >"$D/out/$stem.stdout" 2>"$D/out/$stem.stderr" )
  rc=$?
  echo "$stem rc=$rc seconds=$(( $(date +%s) - start ))" >>"$D/out/timings.txt"
done
