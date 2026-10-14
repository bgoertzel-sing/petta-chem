# Neutral calibration v3 - speedup validation (RAF once per row + RAF fixed-point early exit)

Date: 2026-10-13 (America/Vancouver).  Authority: Ben Goertzel, Telegram msg 7901,
17:46 PDT: "if we can optimize the speed without messing up the results we should
do it".  Branch `neutral-v3-raf-once` (worktree `repos/petta-chem-v3-speedup`,
based on d40d4db); NOT merged into the pilot working tree, NOT pushed.

## Status

- Speedup: **byte-identical row atoms on every validation row** (table below),
  all unit/validator/regression suites pass.  Committed on the branch.
- **Not adopted for a relaunch**: the reachability known-answer canary
  (REACHABILITY_CANARY.md) FAILS on both the old and the new source because the
  SSA event sampler is not random (draws are arithmetic progressions).  Per the
  task brief the pilot was not stopped or relaunched; orchestrator pins are
  unchanged (still 6a5c0c1c).  Any relaunch must wait for Ben's decision on the
  sampler.

## Where the time went (profile)

| measurement | old (6a5c0c1c) | new |
|---|---|---|
| RAF-only probe, L5 f2-16 g1001 (one `neutral-raf-maximal-reactions` call incl. load; smoke/probe_raf_only_L5_f2-16_g1001.metta) | 947 s | **5 s** (same 204 reactions) |
| maximal-RAF computations per row | 2 (row field + inside run-detected-raf-endpoints) | 1 |
| catalysis samplings per row | 3 (row, detected-endpoints, ablation pair) | 1 |

An L5 f=8 V100 row was ~1760-1820 s, i.e. ~2 x 947 s RAF; the SSA arms are
the remainder.  The RAF cost itself came from
`neutral-raf-maximal-prune-iterations` always running |R| pruning passes and
`neutral-raf-closure-iterations` always running |R| closure passes, even after
reaching their fixed points.

## Changes (src only; model, grid, seeds, T, bins, thresholds, RNG and evaluation order unchanged)

1. `src/chem_neutral_ssa.metta`: `neutral-ssa-run-calibration-row` binds catalysis,
   maximal RAF reactions and rule ids once (as before) and passes them to the new
   `neutral-ssa-run-selected-raf-endpoints` (body = the old tail of
   `neutral-ssa-run-detected-raf-endpoints` after RAF detection), which calls new
   `-sampled` variants of the ablation endpoints/pair that take the already
   sampled catalysis.  The old public functions
   (`neutral-ssa-run-detected-raf-endpoints`, `neutral-ssa-run-catalysis-ablation-endpoints`,
   `neutral-ssa-run-catalysis-ablation-pair`) keep their signatures and now delegate
   (still exercised by the 125 unit tests).  All three reused values are pure
   functions of (L, graph-seed, f) - the catalysis "RNG" is a stateless arithmetic
   function of indices; no mutable state is involved.
2. `src/chem_neutral_raf.metta`: `neutral-raf-closure-iterations` returns as soon as
   a pass leaves the available list unchanged; `neutral-raf-maximal-prune-iterations`
   returns as soon as a pruning pass keeps every reaction.  Both passes are pure
   functions of their inputs, so every remaining pass would return the same list:
   the result is the identical value (same elements, same order).  This goes beyond
   "compute the RAF once" but is in the brief's "anything else provably identical"
   class; it is where most of the time went.
3. Not done: cross-row cache over the 4 dynamics seeds / volume rows - every row is
   a separate PeTTa process, so it would need file-based shared state; with the RAF
   now ~5 s it is not worth the risk.

Source identity (branch commit, see git log): chem_neutral_ssa.metta sha256
031646a21b3b5175cdb1ff3c8a5f1f242746d64f630e8628ca2975d889cae49d,
chem_neutral_raf.metta sha256 3cf8fa36343a255f59a5edf83ad967a7d75120a9314fad68362688a49510b2e7.

## Method

- `scripts/run_neutral_v3_speedup_validation.sh SIDE OUTDIR QUERY...`: exact batch
  command (nice -n 10, taskset -c 1-7, SWI-Prolog 9.3.36, PeTTa-pinned-4ce1d0ea
  run.sh) on the REAL prepared v3 query files.  old = query unchanged (imports the
  main-tree src = 6a5c0c1c, verified sha256 c868f88a / 0ed75203 at run time and
  recorded per row); new = identical query text except the two import paths point at
  the worktree src (the only harness difference; the pilot reads the main-tree src
  live, so the new source could not be put there while the pilot runs).
- Old side: fresh 6a5c0c1c runs for V50 f2-16 and L5 f2-8; post-guard smoke
  (smoke_guard/, 6a5c0c1c) for f2-0 x2, L5 f2-16 x2, L4; pre-guard smoke (smoke/,
  10a8ed88) for L6 and V200.  10a8ed88 -> 6a5c0c1c only adds the empty-RAF branch in
  `neutral-ssa-raf-reachability-summary` (git diff 10a8ed8 6a5c0c1 -- src/), a no-op
  for non-empty RAFs (L6 RAF 166, V200 RAF 204), and 3/3 non-empty rows were already
  shown byte-identical across that change (SMOKE_GATE.md).  The L5 f2-8 row was
  compared against BOTH the pre-guard smoke and a fresh 6a5c0c1c run.
- Comparison: `scripts/compare_neutral_v3_speedup_rows.py` (the
  `(neutral-calibration-row ...)` line must be byte-identical; all fields incl.
  RAF ids, reachability, causal, delta, integrated nonfood).  Table rendered by
  `scripts/render_neutral_v3_speedup_table.py`.  Concurrency: 3 validation PeTTa
  processes + 2 pilot processes (wall times are under that load; old smoke times
  were under 4-5 processes).
- New rows also validated with the production validator
  (`summarize_neutral_v3_smoke.py speedup_validation/new` -> new/summary.json).

## Byte-identity table

| row | old source | old wall s | new wall s | speedup | row atom sha256 (old / new, 16 hex) | byte-identical |
|---|---|---|---|---|---|---|
| 000-primary-transition-L5-f2-0-V100-g1001-d2001 | smoke_guard-6a5c0c1c | 39 | 26 | 1.5x | cdba1b639fd5b747 / cdba1b639fd5b747 | **True** |
| 000-primary-transition-L5-f2-0-V100-g1002-d2001 | smoke_guard-6a5c0c1c | 43 | 22 | 2.0x | a9be4a9367149385 / a9be4a9367149385 | **True** |
| 032-primary-transition-L5-f2-8-V100-g1001-d2001 | fresh-6a5c0c1c | 1201 | 143 | 8.4x | d9d54ce3e71c6ef3 / d9d54ce3e71c6ef3 | **True** |
| 064-primary-transition-L5-f2-16-V100-g1001-d2001 | smoke_guard-6a5c0c1c | 1760 | 288 | 6.1x | 8a11430f47dd18f6 / 8a11430f47dd18f6 | **True** |
| 064-primary-transition-L5-f2-16-V100-g1002-d2001 | smoke_guard-6a5c0c1c | 1820 | 349 | 5.2x | 8bb029ba3ba9c37d / 8bb029ba3ba9c37d | **True** |
| 100-finite-size-control-L4-f2-16-V100-g1001-d2001 | smoke_guard-6a5c0c1c | 184 | 93 | 2.0x | d552ad964f73de62 / d552ad964f73de62 | **True** |
| 136-finite-size-control-L6-f2-16-V100-g1001-d2001 | smoke-pre-guard-10a8ed88 | 5535 | 1190 | 4.7x | 63180c0021a16007 / 63180c0021a16007 | **True** |
| 268-population-scaling-control-L5-f2-16-V50-g1001-d2001 | fresh-6a5c0c1c | 2424 | 202 | 12.0x | 4f5c8901e00c90c6 / 4f5c8901e00c90c6 | **True** |
| 272-population-scaling-control-L5-f2-16-V200-g1001-d2001 | smoke-pre-guard-10a8ed88 | 4072 | 4133 | 1.0x | 984773f620da5b28 / 984773f620da5b28 | **True** |

Verdict: **ALL_IDENTICAL** (compare exit code 0)

Notes: L5 f2-8 also byte-identical to the pre-guard smoke output (three-way
sha256 d67d29de...).  "speedup" mixes load conditions (old smoke runs had 4-5
concurrent processes; fresh old runs and all new runs 5).  All new rows pass the
production validator (new/summary.json; RAF sizes 0/0/141/204/216/136/166/204/204,
no neutral-raf-/neutral-ssa- symbols).  Harness incident: the first new-source V200
run (18:08-18:59) was killed at ~51 min by a stale wait loop in this validation
harness (tmux kill-session of its lane); preserved in aborted_v200_killed_by_harness/,
rerun 19:00-20:09.  aborted_raf_once_only/ holds partial outputs of the first
lanes (RAF-once change only), stopped when the RAF fixed-point exit was added.
A fresh 6a5c0c1c V200 run was started at 19:00 for a same-load comparison
(old/ when finished).

## Tests (new source, all PASS; logs in speedup_validation/)

- experiments/neutral_ssa/smoke.metta 125/125 (unit_ssa_new.txt)
- experiments/neutral_raf/smoke.metta 43/43, same as old source (unit_raf_new.txt)
- tests/test_raf_oracle.py 9 passed
- validator tests + runner v3 + prepare-queries (pytest 24 passed; test_scripts.txt; test_validator.txt)
- batch-path regression INDEX=0 PASS (regression_index0.txt); empty-RAF guard batch test PASS (empty_raf_guard_test.txt)

## Runtime estimate (speedup source; hypothetical until the sampler question is resolved)

Measured new-source row times (under 5 concurrent PeTTa processes): L5 V100
f2-0 22-26 s, f2-8 143 s, f2-16 288-349 s; V50 f2-16 202 s; **V200 f2-16 4133 s**;
L4 f2-16 93 s; L6 f2-16 1190 s.  Assuming each cohort's row time is piecewise
linear in f between f2-0, f2-8 and f2-16 with the L5 V100 shape (cohort mean
~0.50 x its f2-16 time; L4 f2-0 assumed ~15 s):

| cohort (rows/seed) | est. hours/seed |
|---|---|
| L5 V100 (68) | 3.0 |
| L5 V50 (68) | 1.9 |
| L5 V200 (68) | **38.7** (SSA-dominated; RAF savings negligible: 4133 s new vs 4072 s old smoke) |
| L4 (36) | 0.5 |
| L6 (36) | 5.9 |
| **total** | **~50 h = ~2.1 days per seed** (old estimate ~4 days, range 3-6) |

32 seeds at 3 slots: ~22 days (old estimate 6-7 weeks); 2-seed pilot at 2
slots: ~2.1 days.  The V200 low-f row times are unmeasured, so the V200 line
(77% of the total) is the main uncertainty.  Any of this applies only after the
SSA sampler decision; a sampler change alters per-event work and invalidates
these numbers.

Further output-identical speedup candidates (not implemented): the SSA re-scans
the whole catalysis list for every reaction at every event
(`neutral-ssa-catalyst-count`); a per-rule catalyst index would cut V200/L6
cost substantially (integer sums are order-independent).  Each arm also
replays its trajectory twice (`neutral-ssa-run-timed-transitions` in the causal
endpoints and again in the reachability summary).
