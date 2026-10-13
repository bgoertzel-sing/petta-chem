# Neutral calibration v3 - pre-launch smoke gate

## RE-SMOKE AFTER EMPTY-RAF GUARD (2026-10-13 15:41-16:12 PDT): **PASS -> pilot launched 16:12 PDT**

Authority: Ben Goertzel, Telegram msg 7897 (option A).  Source identity
`6a5c0c1cb0ae01bca85aaa29998e3fd5bbd7ccbb` (guard on top of import fix
10a8ed88): `neutral-ssa-raf-reachability-summary` returns
`reachable False first-time censored` when the selected maximal-RAF list is
empty (baseline and ablated both use it).  src/chem_neutral_ssa.metta sha256
c868f88a0dce00ee002f3dc719d714cf51a2a0e4892618c9c0ede6e6adf4ef0c;
chem_neutral_raf.metta, prepare script, ledger, validator v1 (9db9d368...),
runner (fa05b4a8...) unchanged.  Prepared queries: regenerating g1001/g1002
through the frozen prepare path gives byte-identical directories (queries embed
no source hash), so they were not regenerated.

Same method as below: real prepared batch queries, `scripts/run_neutral_v3_smoke.sh`
(exact batch command), outputs in `smoke_guard/`, production validator via
`scripts/summarize_neutral_v3_smoke.py smoke_guard` (`smoke_guard/summary.json`).
Up to 4-5 PeTTa processes concurrent.

| row | wall s | exit | stderr | fn symbols | maximal RAF | baseline/ablated reachability | validator | row atom vs pre-guard |
|---|---|---|---|---|---|---|---|---|
| 000 L5 f2-0 V100 g1001 d2001 | 39 | 0 | empty | none | 0 | false / censored (both) | **PASS** | only reachability changed (was vacuous true @0.3403) |
| 000 L5 f2-0 V100 g1002 d2001 | 43 | 0 | empty | none | 0 | false / censored (both) | **PASS** | only reachability changed (was vacuous true @0.3403) |
| 064 L5 f2-16 (f=8) V100 g1001 d2001 | 1760 | 0 | empty | none | 204 | false / censored | **PASS** | byte-identical (sha256 402efd61...) |
| 064 L5 f2-16 (f=8) V100 g1002 d2001 | 1820 | 0 | empty | none | 216 | false / censored | **PASS** | byte-identical (sha256 9e13ff72...) |
| 100 L4 f2-16 V100 g1001 d2001 (regression row) | 184 | 0 | empty | none | 136 | false / censored | **PASS** | byte-identical (sha256 5d878390...) |

Stdout differs from pre-guard output only in PeTTa's echo of the compiled
source (the guarded function) and, for f=0 rows, the two reachability fields.

Tests (all PASS): experiments/neutral_ssa/smoke.metta 125/125 incl. 2 new
empty-RAF cases (old source returns `reachable true first-time 2.0` on the new
case - test is discriminating; guard/unit_tests.log); validator tests 24/24;
runner v3 tests; prepare-queries test; batch-path regression INDEX=0 (f=0, 0
rule IDs, PASS; guard/regression_index0.log); new
scripts/test_neutral_v3_empty_raf_guard.sh (real f=0 row through batch path:
empty RAF, baseline+ablated reachable false/censored; guard/empty_raf_guard_test.log).

Pre-guard smoke rows that finished after the first report (validator on
pre-guard source; timings remain valid for non-empty RAF since those row atoms
are unchanged by the guard):

| row | wall s | maximal RAF | validator |
|---|---|---|---|
| 032 L5 f2-8 (f=4) V100 g1001 | 734 | 141 | PASS |
| 064 L5 f2-16 V100 g1003 | 1650 | 215 | PASS |
| 100 L4 f2-16 V100 g1001 | 124 | 136 | PASS |
| 136 **L6** f2-16 V100 g1001 | **5535** | 166 | PASS |
| 272 **V200** L5 f2-16 g1001 | **4072** | 204 | PASS |
| RAF-only probe L5 f2-16 g1001 (one maximal-RAF call incl. load) | 947 | - | - |

All smoke tmux sessions (petta-neutral-v3-smoke-a/b/c, -probe, -guard-a/b/c)
had exited by 16:12; nothing left to kill.

Preflight PASS; dry-run (dry_run_20261013_guard.txt): only g1001, g1002 queued
with --source-commit 6a5c0c1c; 30 seeds "outside pilot allowlist".

---

## Original smoke gate (pre-guard, superseded verdict)


Date: 2026-10-13 (America/Vancouver).  Authority: Ben Goertzel, Telegram msg 7878.
Verdict: **FAIL -> pilot NOT launched.**  The import fix works (no unevaluated
terms; non-empty flat RAF rule-ID lists at f=8), but every f=0 row reports
`reachable true` with an EMPTY maximal RAF (vacuous reachability), which the
per-row validator rejects by specification ("RAF empty implies reachable
false").  Launching would freeze both pilot seeds at row 000.  Decision needed
(see LAUNCH_REVIEW.md section 6).

## Identity

- petta-chem source identity (v3 fix): `10a8ed88e4f6df2d4f42d0a0af32fda8ba3b1cd1`
  (query template imports chem_neutral_raf.metta then chem_neutral_ssa.metta).
  Infrastructure commit: `7342654d2e48ad863b33c891abad976f29ae8b92`.
- src/chem_neutral_ssa.metta sha256 ebdcf0449bd783cab6c924f1c455d51141d1d74ff59251237a5e7596908f2ca3 (unchanged from v2)
- src/chem_neutral_raf.metta sha256 0ed75203fff2b9d31c0dac054290aeb5c29fac890ddcda13be6af528c0b26073 (unchanged from v2)
- scripts/prepare_neutral_calibration_queries.py sha256 afb6690399c4ad5268493b19b7c42b5739dce8dc530f32d4c983c7ebc01bbd56
- validator scripts/validate_neutral_calibration_row.py v1 sha256 9db9d368aa552b48dd1bdd45d60ff181d1844b0131fe89b8d13135442cf24038
- PeTTa clone PeTTa-pinned-4ce1d0ea (HEAD 4ce1d0ea, run.sh b0ee9930..., main.pl cc381df2..., MORK FFI absent), SWI-Prolog 9.3.36.

## Method (exact batch path; no harness with its own imports)

Queries are the real prepared v3 batch files under
`experiments/neutral_calibration_v3/prepared/graph-seed-*/queries/` (generated by
`scripts/prepare_neutral_calibration_queries.py`).  Each was run by
`scripts/run_neutral_v3_smoke.sh`, which executes exactly the batch command
(`cd ROOT && nice -n 10 taskset -c 1-7 env PATH=<swipl 9.3.36>:/usr/bin:/bin sh
PeTTa-pinned-4ce1d0ea/run.sh <query>`), writing to
`experiments/neutral_calibration_v3/smoke/` (outside any batch attempt dir).
`experiments/neutral_ssa/smoke.metta` was NOT used (it imports both files itself
and therefore passed while the batch was broken).  Outputs were checked with the
production validator via `scripts/summarize_neutral_v3_smoke.py`.  Up to 5
rows ran concurrently (wall times are under that load).

Commands:

    scripts/run_neutral_v3_smoke.sh experiments/neutral_calibration_v3/smoke <query...>   # tmux petta-neutral-v3-smoke-{a,b,c}
    scripts/run_neutral_v3_smoke.sh experiments/neutral_calibration_v3/smoke/early <g1002 row 000>   # tmux petta-neutral-v3-smoke-d
    python3 scripts/summarize_neutral_v3_smoke.py experiments/neutral_calibration_v3/smoke[/early]

## Results (completed rows)

| row | wall s | exit | stderr | neutral-raf-/neutral-ssa- symbols in atom | maximal RAF size | validator |
|---|---|---|---|---|---|---|
| 064 primary L5 f2-16 (f=8) V100 g1001 d2001 | 1902 | 0 | empty | none | 204 (flat rule-ID strings) | PASS |
| 064 primary L5 f2-16 (f=8) V100 g1002 d2001 | 1944 | 0 | empty | none | 216 (flat rule-ID strings) | PASS |
| 000 primary L5 f2-0 (f=0) V100 g1001 d2001 | 23 | 0 | empty | none | 0 | FAIL: baseline & ablated reachable true but maximal RAF is empty |
| 000 primary L5 f2-0 (f=0) V100 g1002 d2001 (early/) | 37 | 0 | empty | none | 0 | FAIL: same |
| batch-path regression (g1001 row 100, finite-size L4 f2-16) | ~270 | 0 | empty | none | 136 (= all L4 reactions) | PASS |

stdout sha256 (prefix): g1001-064 c0397fd5f91d56fc, g1002-064 85cccc9e95ffb9ba,
g1001-000 921c05ae72c1c714, g1002-000 c3f5c8acc0a76199.  Query sha256 (prefix):
g1001-064 091cd1da7a14fcfa, g1002-064 1d19e99d2d5ded58, g1001-000 0c2fa96eb299569b,
g1002-000 d14dc7994cd0bdb7.  Reachability/causal fields in all rows are
numeric/censored and delta = baseline - ablated (validator).

RAF exists at f=8 for both graph seeds checked (204 / 216 rules) -> the
"all-empty RAF at f=8" stop condition is NOT triggered.  No PeTTa error, no
unevaluated terms.

RAF-only timing probe (`smoke/probe_raf_only_L4_f2-16_g1001.metta`, one call of
neutral-raf-maximal-reactions incl. load): L4 57 s.  Each calibration row
computes the maximal RAF twice (once for the row field, once inside
neutral-ssa-run-detected-raf-endpoints).

## Rows still running at report time (not batch attempts; may be killed)

- tmux petta-neutral-v3-smoke-a: 032 primary L5 f2-8 (f=4) g1001 (next, after 064 and 000)
- tmux petta-neutral-v3-smoke-b: 064 primary L5 f2-16 g1003, then 100 finite-size L4 f2-16 g1001
- tmux petta-neutral-v3-smoke-c: 136 finite-size **L6** f2-16 g1001 (started 13:31 PDT), then 272 population-scaling **V200** f2-16 g1001
- tmux petta-neutral-v3-probe: RAF-only probe for L5
Their outputs/timings append to `smoke/timings.jsonl` and `smoke/probe_timings.txt`;
re-run `summarize_neutral_v3_smoke.py` to validate them.

## Diagnosis of the f=0 failure

`neutral-ssa-raf-reachability-loop` (src/chem_neutral_ssa.metta) declares the
RAF reached at the first transition where every RAF rule has fired
(`neutral-ssa-all-members? $raf-rule-ids ...`) and every closure molecule is
positive.  For an empty RAF the first test is vacuously True and the closure is
the food set, so the row reports `reachable true first-time <time of first
event>`.  In v1/v2 this never surfaced because `$raf-rule-ids` was an
unevaluated term.  It is a pre-existing property of the frozen model, newly
exposed by the fix - not introduced by it.  The frozen protocol
(docs/neutral_crs_oracle_protocol.md section 6) defines reachability relative to
"the selected maximal RAF" and imposes a structural -> reachable ladder, so
the vacuous value would be discarded by a ladder-respecting analysis, but the raw
field contradicts the validator rule required for v3.
