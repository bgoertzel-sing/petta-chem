#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

"$REPO_ROOT/scripts/write_exp02_contract_files.sh" --output-root "$TMP_DIR" >/dev/null

expected_files=(CONFIG.metta MANIFEST.metta EVENTS.metta ABUNDANCES.metta METRICS.metta ACS.metta ABLATIONS.metta SUMMARY.metta)
expected_runs=(
  exp02-small-random
  exp02-small-shuffled
  exp02-small-no-catalysis
  exp02-seed-11-rules-6-random
  exp02-seed-11-rules-6-shuffled
  exp02-seed-11-rules-6-no-catalysis
  exp02-seed-13-rules-8-random
  exp02-seed-13-rules-8-shuffled
  exp02-seed-13-rules-8-no-catalysis
  exp02-seed-17-rules-8-random
  exp02-seed-17-rules-8-shuffled
  exp02-seed-17-rules-8-no-catalysis
  exp02-seed-19-rules-8-random
  exp02-seed-19-rules-8-shuffled
  exp02-seed-19-rules-8-no-catalysis
  exp02-seed-23-rules-8-random
  exp02-seed-23-rules-8-shuffled
  exp02-seed-23-rules-8-no-catalysis
  exp02-seed-29-rules-8-random
  exp02-seed-29-rules-8-shuffled
  exp02-seed-29-rules-8-no-catalysis
  exp02-seed-31-rules-8-random
  exp02-seed-31-rules-8-shuffled
  exp02-seed-31-rules-8-no-catalysis
  exp02-seed-37-rules-8-random
  exp02-seed-37-rules-8-shuffled
  exp02-seed-37-rules-8-no-catalysis
)

for run_id in "${expected_runs[@]}"; do
  for file in "${expected_files[@]}"; do
    test -f "$TMP_DIR/$run_id/$file"
  done
done

actual_count=$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
test "$actual_count" -eq "${#expected_runs[@]}"

grep -Fq '(run-config exp02-small-random exp02 (seed-7) 1 (candidate-cap 4 1) random-polymer)' \
  "$TMP_DIR/exp02-small-random/CONFIG.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 P0 P1 P01 P10) (rule rr1 P2 P3 P10 P01)) (P01 P10) (P10 P01) active)' \
  "$TMP_DIR/exp02-small-random/ACS.metta"
grep -Fq '(metric active-acs-count exp02-small-shuffled 0)' \
  "$TMP_DIR/exp02-small-shuffled/METRICS.metta"
grep -Fq '(run-summary exp02-small-no-catalysis passed no-catalysis-control-has-zero-active-pairs True)' \
  "$TMP_DIR/exp02-small-no-catalysis/SUMMARY.metta"
grep -Fq '(run-config exp02-seed-11-rules-6-random exp02 (seed-11) 1 (candidate-cap 6 1) random-polymer)' \
  "$TMP_DIR/exp02-seed-11-rules-6-random/CONFIG.metta"
grep -Fq '(acs-candidate pair-2-3 ((rule rr2 Q4 Q5 Q45 Q54) (rule rr3 Q6 Q7 Q54 Q45)) (Q45 Q54) (Q54 Q45) active)' \
  "$TMP_DIR/exp02-seed-11-rules-6-random/ACS.metta"
grep -Fq '(metric active-acs-count exp02-seed-13-rules-8-random 2)' \
  "$TMP_DIR/exp02-seed-13-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-2-3 ((rule rr2 R4 R5 R45 R54) (rule rr3 R6 R7 R54 R45)) (R45 R54) (R54 R45) active)' \
  "$TMP_DIR/exp02-seed-13-rules-8-random/ACS.metta"
grep -Fq '(metric generation-seam exp02-seed-17-rules-8-random seed-to-components)' \
  "$TMP_DIR/exp02-seed-17-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 S0 S1 S01 S10) (rule rr1 S2 S3 S10 S01)) (S01 S10) (S10 S01) active)' \
  "$TMP_DIR/exp02-seed-17-rules-8-random/ACS.metta"
grep -Fq '(metric sweep-kind exp02-seed-19-rules-8-random generated-unplanted-control)' \
  "$TMP_DIR/exp02-seed-19-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-19-rules-8-random 0)' \
  "$TMP_DIR/exp02-seed-19-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 T0 T1 T01 T2) (rule rr1 T2 T3 T23 T4)) (T01 T23) (T2 T4) rejected)' \
  "$TMP_DIR/exp02-seed-19-rules-8-random/ACS.metta"

grep -Fq '(metric sweep-kind exp02-seed-23-rules-8-random generated-unplanted-control)'   "$TMP_DIR/exp02-seed-23-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-23-rules-8-random 0)'   "$TMP_DIR/exp02-seed-23-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 U0 U1 U01 U4) (rule rr1 U2 U3 U23 U6)) (U01 U23) (U4 U6) rejected)'   "$TMP_DIR/exp02-seed-23-rules-8-random/ACS.metta"
grep -Fq '(metric generation-seam exp02-seed-29-rules-8-random factored-seed-template)' \
  "$TMP_DIR/exp02-seed-29-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-29-rules-8-random 0)' \
  "$TMP_DIR/exp02-seed-29-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 V0 V1 V01 V6) (rule rr1 V2 V3 V23 V8)) (V01 V23) (V6 V8) rejected)' \
  "$TMP_DIR/exp02-seed-29-rules-8-random/ACS.metta"
grep -Fq '(metric generation-seam exp02-seed-31-rules-8-random factored-seed-template)' \
  "$TMP_DIR/exp02-seed-31-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-31-rules-8-random 0)' \
  "$TMP_DIR/exp02-seed-31-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 W0 W1 W01 W6) (rule rr1 W2 W3 W23 W8)) (W01 W23) (W6 W8) rejected)' \
  "$TMP_DIR/exp02-seed-31-rules-8-random/ACS.metta"

grep -Fq '(metric generation-seam exp02-seed-37-rules-8-random factored-seed-template)' \
  "$TMP_DIR/exp02-seed-37-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-37-rules-8-random 0)' \
  "$TMP_DIR/exp02-seed-37-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 X0 X1 X01 X6) (rule rr1 X2 X3 X23 X8)) (X01 X23) (X6 X8) rejected)' \
  "$TMP_DIR/exp02-seed-37-rules-8-random/ACS.metta"
