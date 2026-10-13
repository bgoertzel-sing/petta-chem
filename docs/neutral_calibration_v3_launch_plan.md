# Neutral calibration v3 launch plan and protocol amendment (2026-10-13)

Authority: Ben Goertzel, Telegram Protobots msg 7878, 2026-10-13 13:27 PDT:
"start the experiment over again with the same parameters, but please add to
the process a detailed check of each experiments result file when it is
completed, to avoid further disastrous bugs of this nature."  External review
requirements (relayed by the main agent, 2026-10-13) adopted in full: batch-path
regression test, validator in the receipt-write path, PILOT FIRST (seeds 1001,
1002 only), this protocol amendment, non-destructive worktree cleanup.

Detailed record: experiments/neutral_calibration_v3/LAUNCH_REVIEW.md.

## 1. What went wrong in v1/v2

`src/chem_neutral_ssa.metta` calls `neutral-raf-maximal-reactions`,
`neutral-raf-reaction-ids`, `neutral-raf-closure` and `neutral-raf-add-unique`,
which are defined only in `src/chem_neutral_raf.metta`.  The batch query files
imported only the SSA file, so PeTTa left those calls unevaluated: every row's
`maximal-raf-rule-ids` (and the RAF-dependent endpoint inputs) were raw
`(neutral-raf-reaction-ids (neutral-raf-maximal-reactions ...))` terms.  The
unit smoke test `experiments/neutral_ssa/smoke.metta` imports BOTH files itself,
so it passed while the batch path was broken.  v1 rows carry the same defect
(487 of 491 unevaluated per the independent check); v2 rows all do.  No
process step ever looked at row content.

## 2. Fix (v3 source identity)

Commit `10a8ed88e4f6df2d4f42d0a0af32fda8ba3b1cd1`: the batch query template
(`scripts/prepare_neutral_calibration_queries.py`) imports
`chem_neutral_raf.metta` and then `chem_neutral_ssa.metta`.  Both `.metta`
sources are byte-identical to the v2 frozen source (sha256 ebdcf044... and
0ed75203...); parameters, grid, seeds, T, bins and thresholds are unchanged
(the third query line is byte-identical to v1/v2).  Rationale for fixing the
template rather than adding an import inside the SSA file is in LAUNCH_REVIEW.md
section 2.

**Empty-RAF guard (final v3 source identity).**  Commit
`6a5c0c1cb0ae01bca85aaa29998e3fd5bbd7ccbb` (authority: Ben Goertzel, Telegram
msg 7897, 2026-10-13, option A): `neutral-ssa-raf-reachability-summary` returns
`(raf-reachability-summary reachable False first-time censored)` when the
selected maximal-RAF rule list is empty, instead of the vacuous
`reachable True` at the first event.  Baseline and ablated reachability both use
this function.  src/chem_neutral_ssa.metta sha256 is now c868f88a...;
chem_neutral_raf.metta, the query template, all prepared queries, grid, seeds,
T, bins and thresholds are unchanged (prepared queries re-generated through the
frozen prepare path are byte-identical; they embed no source hash).  No speedup
(RAF computed once / cached) was applied - not approved.

## 3. Protocol amendment: content checks are required, not outcome inspection

The v1/v2 "outcome-blind" rule (never open raw stdout) prevented anyone from
seeing that every row was malformed.  It is amended as follows:

1. **Required during the run:** every completed row's stdout/stderr is parsed
   by `scripts/validate_neutral_calibration_row.py` BEFORE its receipt is
   published.  The validator checks well-formedness and internal consistency
   only: exactly one result atom; identity fields equal the planned row; no
   unevaluated function terms; structural RAF field is a flat list of
   rule-ID strings; numeric fields finite and in range; delta = baseline -
   ablated; logical implications between fields.  These checks are
   **not outcome inspection** and are mandatory.
2. A failing row gets no receipt: FAILED.json (with validator reasons) is
   written, an alert is appended to ALERTS.jsonl, and the seed is frozen for
   review.  Never skip, never auto-retry, never continue that seed.
3. Completion requires re-validation of all 276 rows (runner, before
   RUN_MANIFEST.json; orchestrator, before complete-validated).
4. **Still blind:** endpoint summaries/aggregates (transition curves, incidence
   by f, reachability/persistence/causal rates, cohort comparisons) are not
   computed or reported until the batch is complete and the frozen analysis is
   authorized.  The single exception is the pilot well-formedness report
   requested by review: per-row wall times and structural RAF sizes per f,
   reported as well-formedness evidence, not as results.
5. Every receipt carries the validator verdict, version and sha256; the
   validator hash is part of the attempt identity.

## 4. Pilot first

The v3 orchestrator (`scripts/neutral_calibration_orchestrator_v3.py`) launches
only seeds in `ALLOWED_SEEDS = (1001, 1002)`.  Seeds 1003-1032 are prepared but
neither queued nor authorized.  Widening requires Ben's go-ahead after the
pilot report and a reviewed commit changing `ALLOWED_SEEDS`.  The supervisor
exits at PILOT_DONE.  Old per-seed runtime estimates (3.5-4.5 days) came from
runs in which the RAF was never computed and are void.

## 5. Unchanged

3 slots (pilot uses 2), MemAvailable >= 2 GiB launch guard, nice 10, CPU0
excluded, pinned PeTTa 4ce1d0ea / SWI-Prolog 9.3.36 / MORK FFI absent, no
auto-retry, review-gated resume, BATCH_DONE at 32/32.
