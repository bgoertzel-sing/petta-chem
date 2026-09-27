# Decision memo for Ben: neutral calibration v2 batch (2026-09-27)

Evidence: docs/neutral_calibration_v2_batch_integrity_review_20260927.md.
Only 9/32 shards (g1001–g1009) are valid raw-complete-unanalysed. The other
23 were run since 2026-09-11 with an unreviewed row-skipping runner, up to 7
concurrent shards with SIGSTOP pausing, and a dirty PeTTa runtime. None can
be completed inside its existing attempts under the frozen protocol.

## Already done (within msg 7019 scope; reversible)

- Frozen runner restored; clean pinned PeTTa clone (hash-identical);
  orchestrator v3 supervising at 3 slots.
- Fresh attempts queued for the 13 seeds you delegated (g1015, g1016,
  g1022–g1032). No timeout/skip policy exists or was invented: a fresh attempt
  runs every row; a nonzero row writes FAILED.json and freezes that seed for
  review. Valid shards' slowest row was 5.25 h, so the old 6 h exit-143
  kills look environmental, not deterministic.

## Decision D1 — the 10 held seeds (reported complete or resumed, all invalid)
(g1010, g1011, g1012, g1013, g1014, g1017, g1018, g1019, g1020, g1021 —
g1011/g1012 newest a003/a001; all 166–266 receipts plus SKIP files)

- A (recommended): authorize fresh attempts for them too (row zero, frozen
  runner). Cost ≈ 3.5–4.5 days per shard at 3 slots; with the 13 already
  queued, whole batch ≈ 30 days wall-clock. Sampling unit preserved.
- B: accept skipped rows. Requires a new analysis-plan rule for missing rows;
  missingness is concentrated in V200/V50 population-scaling rows and in
  high-concurrency periods, so it is outcome-correlated and non-ignorable.
  Not recommended.
- C: shrink the batch to fewer graph seeds (e.g. stop at 22 = 9 valid + 13
  queued). Cheaper; lowers power; must be decided before any endpoint is
  opened to stay outcome-blind.

## Decision D2 — dirty src/metta.pl in the shared omegaclaw PeTTa checkout
Nothing is needed for this batch (the pinned clone is used). Decide whether
OmegaClaw should commit or revert its get-state/3 edit.

## Decision D3 — concurrency 4
Raising to 4 saves ≈ 25% wall time. MemAvailable is only ≈ 6 GiB with no
shards running (other workloads hold ≈ 7 GiB); each swipl may grow to its
8 GiB stack limit on V200 rows. Recommend keeping 3 unless those other
workloads are stopped.

## Decision D4 — acknowledge protocol deviations
The 2026-09-25 RUN_MANIFEST renames, the manual SKIP files, the g1003-a001
FAILED.json deletion and the g1010 review's raw-content quotes are recorded.
None of the affected attempts is used. No action is proposed beyond keeping
them as provenance.

One-word replies are enough: e.g. "D1 A".
