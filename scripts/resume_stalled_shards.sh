#!/bin/bash
# Resume stalled calibration v2 shards when slots free up
# Stalled shards: g1003 (242/276), g1010 (200/276), g1011 (0/276), g1012 (0/276), g1013 (208/276)
set -euo pipefail

ROOT="/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem"
RUNNER="/home/openclaw/research-agent/projects/omegaclaw/repos/PeTTa/run.sh"
SOURCE_COMMIT="4b7c6de4ec8eb71502588d2714579c7d55d4bd50"
RUNTIME_IDENTITY="petta=4ce1d0ea58855abb772b911278312c8846e5cc08;run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;swipl=9.3.36-x86_64-linux;mork_ffi=absent"

MAX_SLOTS=10

log() { echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

# Count currently running shards
count_running() {
  local count=0
  for s in $(seq 1001 1032); do
    if tmux has-session -t "petta-neutral-v2-g${s}-a001" 2>/dev/null; then
      count=$((count + 1))
    fi
  done
  echo $count
}

# Check if a shard needs resuming (has ATTEMPT.json but no RUN_MANIFEST.json, or no ATTEMPT.json at all)
needs_resume() {
  local shard=$1
  local dir="$ROOT/experiments/neutral_calibration_v2/graph-seed-${shard}/attempt-001"
  if [ -f "$dir/RUN_MANIFEST.json" ]; then
    return 1  # already complete
  fi
  if tmux has-session -t "petta-neutral-v2-g${shard}-a001" 2>/dev/null; then
    return 1  # already running
  fi
  return 0
}

resume_shard() {
  local shard=$1
  local shard_dir="$ROOT/experiments/neutral_calibration_v1/graph-seed-${shard}"
  local attempt_dir="$ROOT/experiments/neutral_calibration_v2/graph-seed-${shard}/attempt-001"
  local attempt_id="neutral-v2-g${shard}-001"
  
  mkdir -p "$attempt_dir/receipts"
  
  log "Resuming g${shard}..."
  tmux new-session -d -s "petta-neutral-v2-g${shard}-a001" \
    "cd '$ROOT' && python3 '$ROOT/scripts/run_neutral_calibration_shard_v2.py' \
      --shard-dir '$shard_dir' \
      --runner '$RUNNER' \
      --attempt-dir '$attempt_dir' \
      --attempt-id '$attempt_id' \
      --source-commit '$SOURCE_COMMIT' \
      --runtime-identity '$RUNTIME_IDENTITY' \
      2>&1 | tee -a '$ROOT/experiments/neutral_calibration_v2/graph-seed-${shard}/orch-watchdog.log'
  log "g${shard} resumed in tmux session petta-neutral-v2-g${shard}-a001"
}

# Main loop
log "Checking for stalled shards to resume..."

STALLED_SHARDS="1003 1010 1011 1012 1013"

for shard in $STALLED_SHARDS; do
  if needs_resume "$shard"; then
    running=$(count_running)
    if [ "$running" -ge "$MAX_SLOTS" ]; then
      log "MAX_SLOTS=$MAX_SLOTS reached ($running running). Waiting for next cycle."
      break
    fi
    resume_shard "$shard"
    sleep 5  # stagger starts
  else
    log "g${shard}: already complete or running, skipping."
  fi
done

log "Resume check complete. Currently running: $(count_running)"
