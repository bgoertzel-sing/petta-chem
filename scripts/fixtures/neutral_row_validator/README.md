# Validator fixtures

- v2_unevaluated_032.stdout: byte copy (cp, original untouched) of experiments/neutral_calibration_v2/graph-seed-1001/attempt-001/raw/032-primary-transition-L5-f2-8-V100-g1001-d2001.stdout, sha256 15fc8e2a0e94d2236908fff152f0cec833c7a010395d4e3230568200008d2b4e. Real v2 row with the unevaluated neutral-raf-* defect. NEGATIVE fixture only.
- empty.stderr: empty stderr.
- v3_smoke_good_*.stdout/.stderr: real v3 smoke-gate rows (pre-launch, outside batch dirs) that passed the validator; positive fixtures.

v1/v2 rows are never positive fixtures: 487/491 v1 rows and all v2 rows carry the defect.
