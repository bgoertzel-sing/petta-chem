#!/bin/bash
# Watch running shards, resume stalled ones when slots free
set -euo pipefail

ROOT="/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem"
SCRIPT="$ROOT/scripts/resume_stalled_shards.sh"
LOG="$ROOT/scripts/watch_and_resume.log"

while true; do
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) Running resume check..." >> "$LOG"
  bash "$SCRIPT" >> "$LOG" 2>&1 || true
  sleep 300  # 5 minutes
done
