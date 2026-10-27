#!/bin/bash
# Resume g1010 when a slot frees (g1011 completes)
# Checks if g1011 is done, then launches g1010 resume
set -euo pipefail

ROOT="/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem"
SWIPL_BIN="/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin"
RUNNER="/home/openclaw/research-agent/projects/omegaclaw/repos/PeTTa/run.sh"
SOURCE_COMMIT="4b7c6de4ec8eb71502588d2714579c7d55d4bd50"
RUNTIME_IDENTITY="petta=4ce1d0ea58855abb772b911278312c8846e5cc08;run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;swipl=9.3.36-x86_64-linux;mork_ffi=absent"
ATTEMPT_DIR="$ROOT/experiments/neutral_calibration_v2/graph-seed-1010/attempt-001"

# Check if g1011 is done (RUN_MANIFEST.json exists)
G1011_DONE="$ROOT/experiments/neutral_calibration_v2/graph-seed-1011/attempt-001/RUN_MANIFEST.json"
if [ ! -f "$G1011_DONE" ]; then
  echo "g1011 not done yet. Aborting."
  exit 1
fi

# Check g1010 not already running
if tmux has-session -t petta-neutral-v2-g1010-a001 2>/dev/null; then
  echo "g1010 already running. Aborting."
  exit 0
fi

# Count running shards
RUNNING=$(for s in $(seq 1001 1032); do tmux has-session -t "petta-neutral-v2-g${s}-a001" 2>/dev/null && echo 1; done | wc -l)
if [ "$RUNNING" -ge 4 ]; then
  echo "Still $RUNNING shards running (MAX_SLOTS=4). Aborting."
  exit 1
fi

echo "Slot free ($RUNNING running). Launching g1010 resume..."
tmux new-session -d -s petta-neutral-v2-g1010-a001 -- bash -lc \
  "cd $ROOT && exec env PATH=$SWIPL_BIN:/usr/bin:/bin \
   python3 scripts/run_neutral_calibration_shard_v2.py \
     --shard-dir experiments/neutral_calibration_v1/graph-seed-1010 \
     --runner $RUNNER \
     --attempt-dir experiments/neutral_calibration_v2/graph-seed-1010/attempt-001 \
     --attempt-id neutral-v2-g1010-a001 \
     --source-commit $SOURCE_COMMIT \
     --runtime-identity \"$RUNTIME_IDENTITY\" \
     >> experiments/neutral_calibration_v2/graph-seed-1010/attempt-001.runner.log 2>&1"

echo "g1010 resume launched in tmux session petta-neutral-v2-g1010-a001"
