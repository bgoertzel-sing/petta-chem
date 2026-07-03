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
  exp02-seed-41-rules-8-random
  exp02-seed-41-rules-8-shuffled
  exp02-seed-41-rules-8-no-catalysis
  exp02-seed-43-rules-8-random
  exp02-seed-43-rules-8-shuffled
  exp02-seed-43-rules-8-no-catalysis
  exp02-seed-47-rules-8-random
  exp02-seed-47-rules-8-shuffled
  exp02-seed-47-rules-8-no-catalysis
  exp02-seed-53-rules-8-random
  exp02-seed-53-rules-8-shuffled
  exp02-seed-53-rules-8-no-catalysis
  exp02-seed-59-rules-8-random
  exp02-seed-59-rules-8-shuffled
  exp02-seed-59-rules-8-no-catalysis
  exp02-seed-61-rules-8-random
  exp02-seed-61-rules-8-shuffled
  exp02-seed-61-rules-8-no-catalysis
  exp02-seed-67-rules-8-random
  exp02-seed-67-rules-8-shuffled
  exp02-seed-67-rules-8-no-catalysis
  exp02-seed-71-rules-8-random
  exp02-seed-71-rules-8-shuffled
  exp02-seed-71-rules-8-no-catalysis
  exp02-seed-73-rules-8-random
  exp02-seed-73-rules-8-shuffled
  exp02-seed-73-rules-8-no-catalysis
  exp02-seed-79-rules-8-random
  exp02-seed-79-rules-8-shuffled
  exp02-seed-79-rules-8-no-catalysis
  exp02-seed-83-rules-8-random
  exp02-seed-83-rules-8-shuffled
  exp02-seed-83-rules-8-no-catalysis
  exp02-seed-89-rules-8-random
  exp02-seed-89-rules-8-shuffled
  exp02-seed-89-rules-8-no-catalysis
  exp02-seed-97-rules-8-random
  exp02-seed-97-rules-8-shuffled
  exp02-seed-97-rules-8-no-catalysis
  exp02-seed-101-rules-8-random
  exp02-seed-101-rules-8-shuffled
  exp02-seed-101-rules-8-no-catalysis
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

grep -Fq '(metric generation-seam exp02-seed-41-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-41-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-41-rules-8-random 0)'   "$TMP_DIR/exp02-seed-41-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 Y0 Y1 Y01 Y6) (rule rr1 Y2 Y3 Y23 Y8)) (Y01 Y23) (Y6 Y8) rejected)'   "$TMP_DIR/exp02-seed-41-rules-8-random/ACS.metta"

grep -Fq '(metric generation-seam exp02-seed-43-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-43-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-43-rules-8-random 0)'   "$TMP_DIR/exp02-seed-43-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 Z0 Z1 Z01 Z6) (rule rr1 Z2 Z3 Z23 Z8)) (Z01 Z23) (Z6 Z8) rejected)'   "$TMP_DIR/exp02-seed-43-rules-8-random/ACS.metta"

grep -Fq '(metric generation-seam exp02-seed-47-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-47-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-47-rules-8-random 0)'   "$TMP_DIR/exp02-seed-47-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZA0 ZA1 ZA01 ZA6) (rule rr1 ZA2 ZA3 ZA23 ZA8)) (ZA01 ZA23) (ZA6 ZA8) rejected)'   "$TMP_DIR/exp02-seed-47-rules-8-random/ACS.metta"


grep -Fq '(metric generation-seam exp02-seed-53-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-53-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-53-rules-8-random 0)'   "$TMP_DIR/exp02-seed-53-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZB0 ZB1 ZB01 ZB6) (rule rr1 ZB2 ZB3 ZB23 ZB8)) (ZB01 ZB23) (ZB6 ZB8) rejected)'   "$TMP_DIR/exp02-seed-53-rules-8-random/ACS.metta"

grep -Fq '(metric generation-seam exp02-seed-59-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-59-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-59-rules-8-random 0)'   "$TMP_DIR/exp02-seed-59-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZC0 ZC1 ZC01 ZC6) (rule rr1 ZC2 ZC3 ZC23 ZC8)) (ZC01 ZC23) (ZC6 ZC8) rejected)'   "$TMP_DIR/exp02-seed-59-rules-8-random/ACS.metta"


grep -Fq '(metric generation-seam exp02-seed-61-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-61-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-61-rules-8-random 0)'   "$TMP_DIR/exp02-seed-61-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZD0 ZD1 ZD01 ZD6) (rule rr1 ZD2 ZD3 ZD23 ZD8)) (ZD01 ZD23) (ZD6 ZD8) rejected)'   "$TMP_DIR/exp02-seed-61-rules-8-random/ACS.metta"

grep -Fq '(metric generation-seam exp02-seed-67-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-67-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-67-rules-8-random 0)'   "$TMP_DIR/exp02-seed-67-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZE0 ZE1 ZE01 ZE6) (rule rr1 ZE2 ZE3 ZE23 ZE8)) (ZE01 ZE23) (ZE6 ZE8) rejected)'   "$TMP_DIR/exp02-seed-67-rules-8-random/ACS.metta"


grep -Fq '(metric generation-seam exp02-seed-71-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-71-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-71-rules-8-random 0)'   "$TMP_DIR/exp02-seed-71-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZF0 ZF1 ZF01 ZF6) (rule rr1 ZF2 ZF3 ZF23 ZF8)) (ZF01 ZF23) (ZF6 ZF8) rejected)'   "$TMP_DIR/exp02-seed-71-rules-8-random/ACS.metta"


grep -Fq '(metric generation-seam exp02-seed-73-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-73-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-73-rules-8-random 0)'   "$TMP_DIR/exp02-seed-73-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZG0 ZG1 ZG01 ZG6) (rule rr1 ZG2 ZG3 ZG23 ZG8)) (ZG01 ZG23) (ZG6 ZG8) rejected)'   "$TMP_DIR/exp02-seed-73-rules-8-random/ACS.metta"


grep -Fq '(metric generation-seam exp02-seed-79-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-79-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-79-rules-8-random 0)'   "$TMP_DIR/exp02-seed-79-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZH0 ZH1 ZH01 ZH6) (rule rr1 ZH2 ZH3 ZH23 ZH8)) (ZH01 ZH23) (ZH6 ZH8) rejected)'   "$TMP_DIR/exp02-seed-79-rules-8-random/ACS.metta"

grep -Fq '(metric generation-seam exp02-seed-83-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-83-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-83-rules-8-random 0)'   "$TMP_DIR/exp02-seed-83-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZI0 ZI1 ZI01 ZI6) (rule rr1 ZI2 ZI3 ZI23 ZI8)) (ZI01 ZI23) (ZI6 ZI8) rejected)'   "$TMP_DIR/exp02-seed-83-rules-8-random/ACS.metta"

grep -Fq '(metric generation-seam exp02-seed-89-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-89-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-89-rules-8-random 0)'   "$TMP_DIR/exp02-seed-89-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZJ0 ZJ1 ZJ01 ZJ6) (rule rr1 ZJ2 ZJ3 ZJ23 ZJ8)) (ZJ01 ZJ23) (ZJ6 ZJ8) rejected)'   "$TMP_DIR/exp02-seed-89-rules-8-random/ACS.metta"

grep -Fq '(metric generation-seam exp02-seed-97-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-97-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-97-rules-8-random 0)'   "$TMP_DIR/exp02-seed-97-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZK0 ZK1 ZK01 ZK6) (rule rr1 ZK2 ZK3 ZK23 ZK8)) (ZK01 ZK23) (ZK6 ZK8) rejected)'   "$TMP_DIR/exp02-seed-97-rules-8-random/ACS.metta"

 grep -Fq '(metric generation-seam exp02-seed-101-rules-8-random factored-seed-template)'   "$TMP_DIR/exp02-seed-101-rules-8-random/METRICS.metta"
grep -Fq '(metric active-acs-count exp02-seed-101-rules-8-random 0)'   "$TMP_DIR/exp02-seed-101-rules-8-random/METRICS.metta"
grep -Fq '(acs-candidate pair-0-1 ((rule rr0 ZL0 ZL1 ZL01 ZL6) (rule rr1 ZL2 ZL3 ZL23 ZL8)) (ZL01 ZL23) (ZL6 ZL8) rejected)'   "$TMP_DIR/exp02-seed-101-rules-8-random/ACS.metta"
