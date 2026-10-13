#!/usr/bin/env bash
# Batch-path test for the v3 empty-RAF reachability guard (commit 6a5c0c1c,
# Ben Goertzel option A, Telegram msg 7897, 2026-10-13).
# Runs the real f=0 row g1001 index 0 (L5 f2-0 V100 d2001; empty maximal RAF)
# through the batch prepare path + pinned PeTTa run.sh (via
# test_neutral_v3_batch_path_regression.sh, which also requires the production
# validator to PASS), then asserts that BOTH baseline and ablated reachability
# are exactly (raf-reachability-summary reachable false first-time censored).
# Before the guard this row reported "reachable true first-time 0.34029...".
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
PETTA=${PETTA:-/home/openclaw/research-agent/projects/petta-chem/repos/PeTTa-pinned-4ce1d0ea}
SWIPL_BIN=${SWIPL_BIN:-/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin}
INDEX=0 bash "$ROOT/scripts/test_neutral_v3_batch_path_regression.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
(cd "$ROOT/scripts" && python3 prepare_neutral_calibration_queries.py --graph-seed 1001 --output-root "$tmp" >/dev/null)
q="$tmp/graph-seed-1001/queries/000-primary-transition-L5-f2-0-V100-g1001-d2001.metta"
env PATH="$SWIPL_BIN:/usr/bin:/bin" sh "$PETTA/run.sh" "$q" >"$tmp/out" 2>"$tmp/err"
row=$(grep '^(neutral-calibration-row' "$tmp/out")
grep -q 'maximal-raf-rule-ids ()' <<<"$row" || { echo "FAIL: RAF not empty"; exit 1; }
n=$(grep -o 'reachability (raf-reachability-summary reachable false first-time censored)' <<<"$row" | wc -l)
[ "$n" -eq 2 ] || { echo "FAIL: expected baseline+ablated reachable false/censored, got $n"; exit 1; }
if grep -q 'reachable true' <<<"$row"; then echo "FAIL: vacuous reachable true"; exit 1; fi
echo "empty-RAF guard: PASS (f=0 row: empty RAF, baseline and ablated reachable false / censored)"
