#!/usr/bin/env bash
# Restart-safe single-instance supervisor for the neutral-calibration v3 batch (pilot-gated).
#   neutral_v2_supervisor.sh ensure  -> start tmux session if absent (idempotent)
#   neutral_v2_supervisor.sh loop    -> (inside tmux) tick orchestrator every 10 min
# The orchestrator holds an flock per tick; the loop holds its own flock so at
# most one loop exists.  Stops by itself after BATCH_DONE.
set -uo pipefail
ROOT=/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem
V2="$ROOT/experiments/neutral_calibration_v3"  # v3 root
SESSION=petta-neutral-v3-orchestrator
LOG="$V2/supervisor.log"
INTERVAL=${NEUTRAL_V3_TICK_SECONDS:-600}

case "${1:-ensure}" in
  ensure)
    if tmux has-session -t "=$SESSION" 2>/dev/null; then
      echo "supervisor: tmux $SESSION already running"; exit 0
    fi
    if grep -qE '"(batch_done|pilot_done)": true' "$V2/orchestrator_state.json" 2>/dev/null; then
      echo "supervisor: BATCH_DONE recorded; not restarting"; exit 0
    fi
    tmux new-session -d -s "$SESSION" -- bash -lc "exec $ROOT/scripts/neutral_v3_supervisor.sh loop"
    echo "supervisor: started tmux $SESSION"
    ;;
  loop)
    exec 9>"$V2/.supervisor.lock"
    if ! flock -n 9; then echo "$(date -u +%FT%TZ) another supervisor loop holds the lock; exiting" >>"$LOG"; exit 0; fi
    echo "$(date -u +%FT%TZ) supervisor loop start pid=$$ interval=${INTERVAL}s" >>"$LOG"
    while true; do
      out=$(cd "$ROOT" && python3 scripts/neutral_calibration_orchestrator_v3.py 2>&1); rc=$?
      { echo "$(date -u +%FT%TZ) tick rc=$rc"; echo "$out" | grep -vE ': complete-validated|held for review' ; } >>"$LOG"
      if [ $rc -ne 0 ]; then
        printf '{"utc":"%s","kind":"orchestrator-error","rc":%d}\n' "$(date -u +%FT%TZ)" "$rc" >>"$V2/ALERTS.jsonl"
      fi
      if echo "$out" | grep -qE '^(BATCH_DONE|PILOT_DONE)'; then echo "$(date -u +%FT%TZ) BATCH_DONE or PILOT_DONE; supervisor exiting" >>"$LOG"; exit 0; fi
      sleep "$INTERVAL"
    done
    ;;
  *) echo "usage: $0 ensure|loop" >&2; exit 2 ;;
esac
