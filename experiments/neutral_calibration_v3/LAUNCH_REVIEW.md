# Neutral calibration v3 - launch review

Date: 2026-10-13.  Authority: Ben Goertzel, Telegram Protobots msg 7878, 13:27 PDT:
"start the experiment over again with the same parameters, but please add to the
process a detailed check of each experiments result file when it is completed".
External-review requirements relayed by the main agent the same day (pilot first,
batch-path regression test, protocol amendment, worktree cleanup) adopted.

**Status: NOT LAUNCHED.**  Everything is built and tested, the identity
preflight and dry-run pass, but the smoke gate shows that every f=0 (empty-RAF)
row reports vacuous `reachable true`, which the required validator rule rejects.
Launching would freeze both pilot seeds at row 000.  Needs Ben's decision
(section 6).

## 1. Identity

| item | value |
|---|---|
| v3 source identity (fix commit) | 10a8ed88e4f6df2d4f42d0a0af32fda8ba3b1cd1 |
| v3 infrastructure commit | 7342654d2e48ad863b33c891abad976f29ae8b92 |
| chem_neutral_ssa.metta | ebdcf044... (byte-identical to v2 frozen source 4b7c6de) |
| chem_neutral_raf.metta | 0ed75203... (byte-identical to v2) |
| prepare_neutral_calibration_queries.py | afb66903... |
| plan_neutral_calibration_shards.py / ledger v1 | 4bb7c5c6... / 42fb6b0c... (unchanged) |
| v3 runner run_neutral_calibration_shard_v3.py | fa05b4a80ef54e6876edfc0a7d8b8a6d12c7ee8bafbbfe730d7dfc8ed8cfc59b |
| validator validate_neutral_calibration_row.py (v1) | 9db9d368aa552b48dd1bdd45d60ff181d1844b0131fe89b8d13135442cf24038 |
| PeTTa | PeTTa-pinned-4ce1d0ea, run.sh b0ee9930..., main.pl cc381df2..., MORK FFI absent |
| SWI-Prolog | 9.3.36 x86_64-linux |

Parameters: unchanged frozen ledger (artifacts/neutral_calibration_ledger_v1.json):
32 graph seeds x 276 rows, T=500, stop events 1e6, burn-in 100, 40 bins x 10,
threshold 32.  The third line of every v3 query (the calibration-row call) is
byte-identical to v1/v2.

## 2. The fix and why it is in the query template

Defect: chem_neutral_ssa.metta calls neutral-raf-maximal-reactions,
neutral-raf-reaction-ids, neutral-raf-closure, neutral-raf-add-unique (defined
only in chem_neutral_raf.metta); batch queries imported only the SSA file.

Fix (commit 10a8ed88): queries now begin

    !(import! &self <repo>/src/chem_neutral_raf.metta)
    !(import! &self <repo>/src/chem_neutral_ssa.metta)

**Deviation from the brief's preferred option** (import inside
chem_neutral_ssa.metta), for three verified reasons:
1. PeTTa `import!` (src/metta.pl importer_helper) resolves a relative path
   against the *main query file's* directory (working_dir), not the importing
   file's, so an import inside the SSA source would have to hard-code an
   absolute path.  Import failures are also swallowed (`catch(..., _, fail)`).
2. PeTTa `import!` does not deduplicate; experiments/neutral_ssa/smoke.metta and
   any other harness importing both files would double-load all RAF clauses.
3. Keeping both .metta files byte-identical makes "no semantic change" trivially
   checkable (identical hashes), and the raf-then-ssa order is exactly the order
   the existing unit tests use (PeTTa compiles at load time, so the RAF
   definitions must be loaded first).
No definitions are duplicated between the files (checked: the 67 function heads
of chem_neutral_raf.metta do not occur as definitions in chem_neutral_ssa.metta),
and no other batch path imports chem_neutral_raf.metta.

experiments/neutral_ssa/smoke.metta now carries a header stating it is a unit test,
NOT a batch-path test (it imports both files itself, which is why it passed while
the batch was broken).  Per the independent check (glicerico), v1 calibration
rows carry the same defect (487 of 491 unevaluated) and v2 rows all do; no v1/v2
row is used as a positive fixture anywhere.

## 3. Smoke gate

See SMOKE_GATE.md.  Summary: f=8 rows (g1001, g1002) PASS with maximal RAF of 204
and 216 rule IDs, exit 0, empty stderr, no neutral-raf-/neutral-ssa- symbols,
~1900-1950 s each.  f=0 rows (g1001, g1002) FAIL the validator: empty RAF but
reachable true (vacuous).  L6 and V200 smoke rows were still running at report
time (tmux petta-neutral-v3-smoke-c).

## 4. Per-row validator (Ben's "detailed check of each result file")

scripts/validate_neutral_calibration_row.py (version
neutral-calibration-row-validator-v1).  Called by the v3 runner right after each
row exits and BEFORE the receipt is written; also re-run on all 276 rows by the
runner before RUN_MANIFEST.json and by the orchestrator before
complete-validated.  Checks: exit 0; empty stderr; no Prolog error markers in
stdout; exactly one `(neutral-calibration-row ...)` atom, fully parsed, exact key
order, nothing after it; closed symbol whitelist (any neutral-raf-*,
neutral-ssa-*, raf-* or other function symbol = unevaluated call -> fail);
identity (model, L, graph seed, dynamics seed, f-twice, V) = planned row;
molecule-count = 2^(L+1)-2 and reaction-count = 2*sum_{n=2..L} 2^n(n-1);
maximal-raf-rule-ids is a flat list of unique strings matching
lig:<bin>:<bin> / cleave:<bin>:<k> consistent with L, size <= reaction-count;
f-twice 0 => empty RAF; reachable boolean, first-time finite in [0,T] iff
reachable else censored; raf-events nonnegative int, evidence-bins int in 0..40,
integrated-nonfood finite >= 0; delta = baseline - ablated (ints exact, float
1e-9 rel); evidence-bins>0 => raf-events>0; RAF empty => raf-events=0 and
evidence-bins=0 (both arms); reachable true => RAF nonempty (both arms).
On failure: FAILED.json with validator reasons, line in ALERTS.jsonl
(kind row-validation-failed / failed), seed frozen - no skip, no retry, no
continuation.  The receipt carries {verdict, reasons, validator_version,
validator_sha256, raf_size}; the validator hash is part of ATTEMPT.json identity.

Tests:
- scripts/test_validate_neutral_calibration_row.py - 24 tests, all PASS: good
  row, good empty-RAF row, universe sizes, REAL v2 stdout negative fixture
  (scripts/fixtures/neutral_row_validator/v2_unevaluated_032.stdout, a copy of
  v2 g1001 row 032), synthetic unevaluated calls (RAF field and endpoints),
  identity mismatch (each of 5 fields), missing atom, duplicate atom,
  truncated atom, out-of-range bins, negative counts, NaN/inf, first-time > T,
  reachable/censored inconsistency, delta inconsistency, empty RAF but reachable,
  empty RAF with RAF events, f=0 with non-empty RAF, malformed/duplicate/nested
  rule IDs, wrong universe counts, stderr/exit code, trailing garbage.
- scripts/test_run_neutral_calibration_shard_v3.py - PASS: receipts carry passing
  verdict; v2-defect row gets no receipt, writes FAILED.json + alert, attempt
  cannot resume; nonzero exit alerts; tampered receipt verdict blocks resume;
  quarantine-and-rerun of an unreceipted row.
- scripts/test_neutral_v3_batch_path_regression.sh - PASS: generates queries via
  the batch prepare path, runs a real L4 f=8 row through PeTTa run.sh, validator
  PASS with a flat list of 136 rule IDs.
- scripts/test_prepare_neutral_calibration_queries.sh - PASS (asserts RAF then
  SSA import).

## 5. Runner / orchestrator / supervision (how v3 differs from v2)

- Runner: scripts/run_neutral_calibration_shard_v3.py = copy of frozen v2 runner
  423e2862 + validator hook (receipt-write path), completion re-validation,
  v3 schemas, --alerts-path.  No timeout or skip behaviour.
- Orchestrator: scripts/neutral_calibration_orchestrator_v3.py (v2 orchestrator
  left untouched).  Root experiments/neutral_calibration_v3; prepared queries in
  prepared/graph-seed-N; identity preflight pins v3 runner, validator, both
  .metta files, prepare/plan scripts, ledger, PeTTa/SWI identity and checks
  every prepared query of an eligible seed for RAF-then-SSA imports;
  complete-validated requires all 276 receipts with passing pinned-validator
  verdicts and re-validation of all 276 rows from disk.  PILOT gate
  ALLOWED_SEEDS = (1001, 1002); PILOT_DONE stops the supervisor.  3 slots,
  MemAvailable >= 2 GiB, nice 10, CPU 1-7, no auto-retry, BATCH_DONE at 32/32.
- Supervisor/health: scripts/neutral_v3_supervisor.sh (tmux
  petta-neutral-v3-orchestrator), scripts/neutral_v3_health_check.sh.
- Preflight: `python3 scripts/neutral_calibration_orchestrator_v3.py --preflight-only`
  -> PASS.  Dry-run (experiments/neutral_calibration_v3/dry_run_20261013.txt): g1001
  and g1002 queued (would launch attempt-001), 30 seeds "outside pilot
  allowlist; not launched".  (The original brief's "32 queued" is superseded by
  the pilot requirement.)
- v2 supervisor tmux petta-neutral-v2-orchestrator stopped 2026-10-13 ~13:40 PDT
  (idle, 0/3 slots, 22/32 complete-validated on v2's metadata-only criteria).
  Cron f28e1331 (v2 health check) was already disabled; left disabled.  7 AM
  overview job 6fb7b7bc scratch updated to report v3 status and validator alerts.

## 6. Decision needed (blocker)

Every row whose maximal RAF is empty - all f=0 rows, and plausibly many low-f
rows - will report `reachable true` at the first event time.  Options:

A. **Model fix (recommended):** in chem_neutral_ssa.metta,
   neutral-ssa-raf-reachability-summary returns
   `(raf-reachability-summary reachable False first-time censored)` when
   `$raf-rule-ids` is `()`.  Matches the protocol text (reachability of "the
   selected maximal RAF"; strict structural -> reachable ladder).  This is a
   semantic change to a frozen endpoint, so it needs Ben's explicit approval and
   would become the v3 source identity (new commit + re-smoke).
B. Keep the frozen semantics and change the validator rule to "RAF empty =>
   reachable may be vacuously true; flagged, analysis must apply the ladder".
   This weakens a rule that Ben's brief specified, so it also needs approval.
C. Keep both as is: every pilot seed freezes at row 000 (not useful).

Nothing was launched and nothing in v2 was modified except the documented
worktree restore (section 8).

## 7. Runtime (old estimates void)

Measured (under 4-5 concurrent PeTTa processes on 7 CPUs): L5 V100 f=8 row
~1900-1950 s (v2 mean for the whole L5 V100 cohort was 173 s, with no RAF
computed); L5 f=0 row 23-37 s; L4 f=8 row ~270 s (v2 L4 mean 48 s); RAF-only L4
57 s.  Each row computes the maximal RAF twice.  L6 (1032 reactions) and V200
rows were not finished at report time.  Very rough per-seed estimate excluding L6:
primary 68 rows + V50 68 rows at ~0.3 h average + V200 68 rows at >= 1 h + L4 36
rows at ~0.07 h => roughly 5-6 days per seed, plus L6 rows (36 per seed, likely
several hours each).  With 3 slots, 32 seeds would take on the order of months.
The pilot (or the running L6/V200 smoke rows) is needed to firm this up.  A
semantics-preserving speedup (compute the maximal RAF once per row instead of
twice; or cache it per (graph seed, f, L) since it does not depend on the
dynamics seed) could cut a large fraction, but is a code change requiring
approval.

## 8. Worktree cleanup (non-destructive, before any launch)

Working copies of modified tracked files were saved under
experiments/neutral_calibration_v2/_worktree_snapshot_20261013/ (same relative
paths, plus worktree_vs_HEAD.diff for the two non-data files), then all modified
and deleted tracked files were restored from HEAD with `git checkout --`:

```
modified artifacts/neutral_raf_generated_gate_manifest.json worktree_sha256=17ffc36e0db288ab90888ebeafec2df4528ed9f8c118b25ddf95054d9d8c4573 head_sha256=b42da40ab55d0ef2eabd2aa343322741858de9133ce8109cfc3465d572c83393 diffstat=+2/-2
modified experiments/neutral_calibration_v2/graph-seed-1004/attempt-001/raw/007-primary-transition-L5-f2-1-V100-g1004-d2004.stdout worktree_sha256=adabd342accd083e947cd09a826b59c015fdd66f70ad82e4a0d12264612d6a3e head_sha256=3ae2e9e800fb60c897ced067d4855a0d1e15bfb054ee297d0046371d28ab10a9 diffstat=+2/-0
modified experiments/neutral_calibration_v2/graph-seed-1005/attempt-001/raw/006-primary-transition-L5-f2-1-V100-g1005-d2003.stdout worktree_sha256=80ec07ff06af6075464f6a323ca8dbf3be0635d03e46dcbbc17016251de7e6d6 head_sha256=1ced74e75d5de0b6ceb2c39c5a58c664d2225996772d31ed7f2c270e6e6927c4 diffstat=+2/-0
modified experiments/neutral_calibration_v2/graph-seed-1006/attempt-001/raw/006-primary-transition-L5-f2-1-V100-g1006-d2003.stdout worktree_sha256=3251c1042dac7bfc58df8a0e70801e45ef2d65cab96bae92117d5ca42af7f0c3 head_sha256=6c18c2369851357cab9cbcbb7aa05439654b34d556c12e2f5321be9f7d767fbf diffstat=+2/-0
modified scripts/resume_stalled_shards.sh worktree_sha256=8908536b74fe6840d2c25833aec866840fd64df99c47b1661e09b03c62541b03 head_sha256=734af526f868d708a634bad956a42655a9f38866105dd88f1d609df5a12fad5d diffstat=+15/-3
deleted-in-worktree experiments/neutral_calibration_v2/graph-seed-1003/attempt-001/FAILED.json restored-from-HEAD head_sha256=f901dee269d1afa9ae195b742f9bf7b5153cb7d034b8874e326e6c8315def3f2
deleted-in-worktree experiments/neutral_calibration_v2/graph-seed-1003/attempt-001/raw/242-population-scaling-control-L5-f2-12-V200-g1003-d2003.stderr restored-from-HEAD head_sha256=0089bb674406997eb0e6850cf01c46d23d8689610788516cebf2a31b9276d691
deleted-in-worktree experiments/neutral_calibration_v2/graph-seed-1003/attempt-001/raw/242-population-scaling-control-L5-f2-12-V200-g1003-d2003.stdout restored-from-HEAD head_sha256=9ca1d4404491621b21fb156dc718f916c4f6deae307df51bc1bbdc5a870e29e5
deleted-in-worktree scripts/queue_drain_watchdog_v2.sh restored-from-HEAD head_sha256=f88f1c16db53d02fbbd916c0df3b013c439729f49f0fbe31425bae19623aaa30
 .../graph-seed-1003/attempt-001/FAILED.json        |    8 -
 ...caling-control-L5-f2-12-V200-g1003-d2003.stderr |    1 -
 ...caling-control-L5-f2-12-V200-g1003-d2003.stdout | 3504 --------------------
 ...mary-transition-L5-f2-1-V100-g1004-d2004.stdout |    2 +
 ...mary-transition-L5-f2-1-V100-g1005-d2003.stdout |    2 +
 ...mary-transition-L5-f2-1-V100-g1006-d2003.stdout |    2 +
 6 files changed, 6 insertions(+), 3513 deletions(-)
```

Left in place (untracked, not touched): experiments/neutral_calibration_v1/graph-seed-1007 ...
graph-seed-1032; experiments/neutral_calibration_v2/.hang_graph-seed-*,
.orchestrator.lock, .supervisor.lock, ALERTS.cursor, ALERTS.jsonl,
STALE_CLEANUP_PLAN.txt, _quarantine_stale/, _superseded_runner/,
g1010_resume_watcher.pid, graph-seed-1003/attempt-001/RUN_MANIFEST.json and
graph-seed-1003/attempt-001/quarantine/ (note: g1003 attempt-001 now holds both
the HEAD-restored FAILED.json and an untracked RUN_MANIFEST.json - v2 provenance
only, irrelevant to v3).  No data deleted.

## 9. Protocol amendment

docs/neutral_calibration_v3_launch_plan.md section 3: per-row well-formedness /
content-structure checks are REQUIRED during the run and are not outcome
inspection; only endpoint summaries/aggregates stay blind until the batch is
complete and analysis is authorized.
