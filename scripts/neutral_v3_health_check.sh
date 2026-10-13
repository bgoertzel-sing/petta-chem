#!/usr/bin/env bash
# One health check for the 2-hourly OpenClaw automation (f28e1331, currently disabled; v3).
# Ensures the supervisor is alive, runs one orchestrator tick, and prints
# ONLY new alert events (since ALERTS.cursor) plus a short summary.
# First line is NO_EVENTS when nothing alert-worthy happened, else EVENTS.
set -uo pipefail
ROOT=/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem
V2="$ROOT/experiments/neutral_calibration_v3"  # v3 root
cd "$ROOT"
sup=$(scripts/neutral_v3_supervisor.sh ensure 2>&1)
tick=$(python3 scripts/neutral_calibration_orchestrator_v3.py 2>&1); rc=$?
touch "$V2/ALERTS.jsonl"
total=$(wc -l <"$V2/ALERTS.jsonl")
cursor=$(cat "$V2/ALERTS.cursor" 2>/dev/null || echo 0)
new=$(tail -n +"$((cursor + 1))" "$V2/ALERTS.jsonl")
echo "$total" >"$V2/ALERTS.cursor"
events=0
[ -n "$new" ] && events=1
[ $rc -ne 0 ] && events=1
case "$sup" in *started*) events=1 ;; esac
if [ $events -eq 0 ]; then echo NO_EVENTS; else echo EVENTS; fi
echo "supervisor: $sup"
[ $rc -ne 0 ] && echo "orchestrator tick rc=$rc: $(echo "$tick" | tail -3)"
[ -n "$new" ] && echo "$new"
echo "$tick" | grep -E ': running|STALL|launched|BATCH_DONE|PILOT_DONE|PREFLIGHT|LAUNCH ERROR|deferring' | cut -c1-200
echo "$tick" | tail -1
