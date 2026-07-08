#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

"$REPO_ROOT/scripts/write_exp03_productive_cap_files.sh" --output-root "$TMP_DIR" >/dev/null

expected_files=(CONFIG.metta MANIFEST.metta EVENTS.metta ABUNDANCES.metta METRICS.metta ACS.metta ABLATIONS.metta SUMMARY.metta)
expected_runs=(
  exp03-cap5-productive-seed-13-random
  exp03-cap6-rich-seed-11-random
  exp03-cap6-productive-seed-11-random
)

for run_id in "${expected_runs[@]}"; do
  for file in "${expected_files[@]}"; do
    test -f "$TMP_DIR/$run_id/$file"
  done
done

actual_count=$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
test "$actual_count" -eq "${#expected_runs[@]}"

grep -Fq '(run-config exp03-cap5-productive-seed-13-random exp03 (seed-13) 10 (candidate-cap 5 1) random-polymer)' \
  "$TMP_DIR/exp03-cap5-productive-seed-13-random/CONFIG.metta"
grep -Fq '(metric dynamic-event-count exp03-cap5-productive-seed-13-random 10)' \
  "$TMP_DIR/exp03-cap5-productive-seed-13-random/METRICS.metta"
grep -Fq '(run-summary exp03-cap6-rich-seed-11-random passed cap6-rich-seed-11-six-candidate-dynamics true)' \
  "$TMP_DIR/exp03-cap6-rich-seed-11-random/SUMMARY.metta"
grep -Fq '(event 0 rr5 Q1 Q6 Q16 Q3)' \
  "$TMP_DIR/exp03-cap6-productive-seed-11-random/EVENTS.metta"
grep -Fq '(metric dynamic-event-count exp03-cap6-productive-seed-11-random 12)' \
  "$TMP_DIR/exp03-cap6-productive-seed-11-random/METRICS.metta"
grep -Fq '(run-summary exp03-cap6-productive-seed-11-random passed cap6-productive-sixth-candidate-seed-11 true)' \
  "$TMP_DIR/exp03-cap6-productive-seed-11-random/SUMMARY.metta"
