#!/bin/bash
# Queue drain watchdog for PeTTa neutral calibration v2
# Launches next queued seed when a swipl slot frees up
set -uo pipefail

CHEM="/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem"
V2="$CHEM/experiments/neutral_calibration_v2"
RUNNER="/home/openclaw/research-agent/projects/omegaclaw/repos/PeTTa/run.sh"
SCRIPT="$CHEM/scripts/run_neutral_calibration_shard_v2.py"
SOURCE_COMMIT="4b7c6de4ec8eb71502588d2714579c7d55d4bd50"
RUNTIME_IDENTITY="petta=4ce1d0ea58855abb772b911278312c8846e5cc08;run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;swipl=9.3.36-x86_64-linux;mork_ffi=absent"
LOGICAL_CPUS=$(nproc)
DEFAULT_MAX_SLOTS=$((LOGICAL_CPUS - 1))
if [ "$DEFAULT_MAX_SLOTS" -lt 1 ]; then
  DEFAULT_MAX_SLOTS=1
fi
MAX_SLOTS=${PETTA_MAX_SLOTS:-$DEFAULT_MAX_SLOTS}
PETTA_NICE=${PETTA_NICE:-19}
PETTA_CPUSET=${PETTA_CPUSET:-1-$((LOGICAL_CPUS - 1))}
PAUSED_FILE="$V2/resource-guard-paused.pids"
LOG="$V2/queue_drain_watchdog.log"

enforce_resource_guard() {
  local pid stat active=0
  local -a runnable=()
  while read -r pid stat; do
    [ -n "$pid" ] || continue
    renice -n "$PETTA_NICE" -p "$pid" >/dev/null 2>>"$LOG" || true
    taskset -pc "$PETTA_CPUSET" "$pid" >/dev/null 2>>"$LOG" || true
    case "$stat" in T*|Z*) ;; *) runnable+=("$pid"); active=$((active + 1));; esac
  done < <(ps -eo pid=,stat=,args= | awk '/^ *[0-9]+ +[^ ]+ +swipl .*graph-seed-10/ {print $1, $2}')

  if [ "$active" -gt "$MAX_SLOTS" ]; then
    : > "$PAUSED_FILE.tmp"
    for pid in "${runnable[@]:$MAX_SLOTS}"; do
      kill -STOP "$pid" 2>/dev/null && echo "$pid" >> "$PAUSED_FILE.tmp"
    done
    mv "$PAUSED_FILE.tmp" "$PAUSED_FILE"
    echo "$(date): resource guard paused $((active - MAX_SLOTS)) excess SWI workers" >> "$LOG"
  elif [ "$active" -lt "$MAX_SLOTS" ] && [ -s "$PAUSED_FILE" ]; then
    pid=$(head -n 1 "$PAUSED_FILE")
    if kill -0 "$pid" 2>/dev/null; then
      renice -n "$PETTA_NICE" -p "$pid" >/dev/null 2>&1 || true
      taskset -pc "$PETTA_CPUSET" "$pid" >/dev/null 2>&1 || true
      kill -CONT "$pid" 2>/dev/null || true
    fi
    tail -n +2 "$PAUSED_FILE" > "$PAUSED_FILE.tmp" || true
    mv "$PAUSED_FILE.tmp" "$PAUSED_FILE"
  fi
}

# Queue: seed attempt attempt_id (priority by most existing receipts)
# Format: SEED ATTEMPT ATTEMPT_ID
QUEUE=(
  "1010 001 neutral-v2-g1010-001"
  "1011 003 neutral-v2-g1011-003"
  "1012 003 neutral-v2-g1012-003"
  "1013 001 neutral-v2-g1013-001"
  "1014 001 neutral-v2-g1014-001"
  "1017 003 neutral-v2-g1017-003"
  "1018 001 neutral-v2-g1018-001"
  "1019 001 neutral-v2-g1019-001"
  "1020 001 neutral-v2-g1020-001"
  "1021 001 neutral-v2-g1021-001"
  "1025 001 neutral-v2-g1025-001"
  "1024 001 neutral-v2-g1024-001"
  "1026 001 neutral-v2-g1026-001"
  "1027 001 neutral-v2-g1027-001"
  "1028 001 neutral-v2-g1028-001"
  "1029 001 neutral-v2-g1029-001"
  "1030 001 neutral-v2-g1030-001"
  "1031 001 neutral-v2-g1031-001"
  "1032 001 neutral-v2-g1032-001"
)

echo "$(date): Watchdog started. logical_cpus=$LOGICAL_CPUS, MAX_SLOTS=$MAX_SLOTS, PETTA_NICE=$PETTA_NICE, PETTA_CPUSET=$PETTA_CPUSET, queue=${#QUEUE[@]} seeds" >> "$LOG"

while true; do
  enforce_resource_guard
  # Count active swipl processes (graph-seed queries only)
  SWIPL_COUNT=$(ps -eo pid=,stat=,args= 2>/dev/null | awk '/^ *[0-9]+ +[^ ]+ +swipl .*graph-seed-10/ {print $1, $2}' | while read sp ss; do case "$ss" in T*|Z*) ;; *) echo x ;; esac; done | wc -l)
  
  if [ "$SWIPL_COUNT" -lt "$MAX_SLOTS" ]; then
    FREE_SLOTS=$((MAX_SLOTS - SWIPL_COUNT))
    echo "$(date): $SWIPL_COUNT/$MAX_SLOTS swipl running, $FREE_SLOTS free slot(s)" >> "$LOG"
    
    for entry in "${QUEUE[@]}"; do
      read -r SEED ATTEMPT ATT_ID <<< "$entry"
      TMUX_NAME="petta-neutral-v2-g${SEED}-a${ATTEMPT}"
      
      # Skip if already running (tmux session exists)
      if tmux has-session -t "$TMUX_NAME" 2>/dev/null; then
        continue
      fi
      
      # Skip if already DONE (has v2 RUN_MANIFEST with raw-complete-unanalysed)
      MANIFEST="$V2/graph-seed-${SEED}/attempt-${ATTEMPT}/RUN_MANIFEST.json"
      if [ -f "$MANIFEST" ]; then
        STATUS=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['status'])" 2>/dev/null || echo "")
        if [ "$STATUS" = "raw-complete-unanalysed" ]; then
          continue
        fi
      fi
      
      # Skip if already FAILED
      FAILED="$V2/graph-seed-${SEED}/attempt-${ATTEMPT}/FAILED.json"
      if [ -f "$FAILED" ]; then
        continue
      fi
      
      # We found a seed to launch
      echo "$(date): Launching g${SEED} attempt-${ATTEMPT} ($ATT_ID)" >> "$LOG"
      
      SHARD_DIR="experiments/neutral_calibration_v1/graph-seed-${SEED}"
      ATTEMPT_DIR="experiments/neutral_calibration_v2/graph-seed-${SEED}/attempt-${ATTEMPT}"
      ORCH_LOG="$V2/graph-seed-${SEED}/orch-watchdog.log"
      
      tmux new-session -d -s "$TMUX_NAME" \
        "cd '$CHEM' && exec taskset -c '$PETTA_CPUSET' nice -n '$PETTA_NICE' python3 '$SCRIPT' \
          --shard-dir '$SHARD_DIR' \
          --runner '$RUNNER' \
          --attempt-dir '$ATTEMPT_DIR' \
          --attempt-id '$ATT_ID' \
          --source-commit '$SOURCE_COMMIT' \
          --runtime-identity '$RUNTIME_IDENTITY' \
          2>&1 | tee -a '$ORCH_LOG'"
      
      echo "$(date): Launched g${SEED} attempt-${ATTEMPT} in tmux session $TMUX_NAME" >> "$LOG"
      
      # Wait a bit for the process to start and register
      sleep 15
      
      # Re-check swipl count
      SWIPL_COUNT=$(ps -eo pid=,stat=,args= 2>/dev/null | awk '/^ *[0-9]+ +[^ ]+ +swipl .*graph-seed-10/ {print $1, $2}' | while read sp ss; do case "$ss" in T*|Z*) ;; *) echo x ;; esac; done | wc -l)
      if [ "$SWIPL_COUNT" -ge "$MAX_SLOTS" ]; then
        echo "$(date): Slots full after launch ($SWIPL_COUNT/$MAX_SLOTS)" >> "$LOG"
        break
      fi
    done
  fi
  
  # Hang detection: kill swipl that haven't produced receipts in 30min
  bash "$(dirname "$0")/hang_detector.sh" "$V2" 10 2>/dev/null
  
  sleep 60
done
