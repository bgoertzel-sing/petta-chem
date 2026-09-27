# Neutral calibration v2 batch integrity review (2026-09-27)

Status: reviewed; supervisor replaced; fresh attempts launched for the 13
seeds inside the delegated scope; 10 seeds held for Ben's decision
(see docs/neutral_calibration_v2_decision_memo_20260927.md).

Reviewer: OpenClaw persistent batch-owner subagent (session 0825d5c2),
authority Ben Goertzel, Telegram msg 7019, 2026-09-27 10:45 PDT: "fix the
watchdog and replace it with an actually working persistent subagent for
getting these runs completed".

Method: metadata only — manifests, ATTEMPT/receipt/FAILED/SKIP JSON fields,
file names, sizes, mtimes, SHA-256 digests, git history, process tables and
runner lifecycle logs. No raw stdout/stderr or endpoint content was opened,
parsed, or summarized.

## Findings

F1. **Runner path "…" is a display artifact, not corruption.** Every file
(orchestrator, watchdog, launch plan, all ATTEMPT.json) contains the byte-exact
path /home/openclaw/research-agent/projects/omegaclaw/repos/PeTTa/run.sh
(verified in Python by string equality and absence of U+2026; the path exists
and hashes to the frozen b0ee9930…). The OpenClaw tool-output layer abbreviates
that long path when displaying it. ATTEMPT.json identities were not altered.

F2. **The frozen v2 runner was replaced without review.** The launch plan
freezes scripts/run_neutral_calibration_shard_v2.py at SHA-256 423e2862….
Commits 470e36e (2026-09-11), e660be4 (09-20) and f1a8a39 (09-21) changed it
to 4d0a1753…: 6 h subprocess timeout; timeout **and nonzero exit write
raw/*.SKIP.json and continue** instead of FAILED.json; stale raw stdout/stderr
are unlink()ed on re-run; RUN_MANIFEST lists skipped_rows yet reports
raw-complete-unanalysed. No identity review exists. The modified runner
**fails the frozen durable-v2 synthetic gate** (AssertionError at
test_run_neutral_calibration_shard_v2.py:91). Restored to 423e2862 on
2026-09-27; gate passes. The replaced file is kept at
experiments/neutral_calibration_v2/_superseded_runner/run_neutral_calibration_shard_v2.py.4d0a1753.

F3. **Hand-written and runner-written SKIP files in every g1010–g1032
attempt** (6–159 per attempt; reasons include "manually skipped", "V200
hang", exit_code=137/143/-9/-15, "raw-files-lost-in-crash"). Row skipping
violates the preregistered graph-seed-complete sampling unit
(recovery policy rule 4; launch plan).

F4. **Uncommitted runtime edit.** The shared PeTTa checkout
(projects/omegaclaw/repos/PeTTa, HEAD 4ce1d0ea) has a tracked modification to
src/metta.pl since 2026-09-08 19:01 PDT (one added get-state/3 clause).
main.pl ensure_loads metta.pl, so the runtime differed from the frozen one
for every row executed after that time, although run.sh/main.pl hashes (the
only runtime hashes in the identity string) still match. The neutral SSA/RAF
sources and queries do not call get-state, so the edit is probably inert, but
it is unreviewed. All 9 valid shards finished before the edit (latest valid
receipt 2026-09-07T16:31Z).

F5. **Resource abuse caused the "hangs".** The ad hoc watchdog ran up to
MAX_SLOTS=7 (amendment cap: 4) on a 15 GiB host where each swipl has an 8 GiB
stack limit, and a "resource guard" SIGSTOPped excess workers
(resource-guard-paused.pids), which also counts against a wall-clock timeout.
In the 9 valid shards (concurrency <= 4, no timeout) the slowest single row
took 5.25 h; the heavy rows 200–275 took 46–83 h per shard; all completed.
The exit-143 rows (g1015 r241, g1016 r264, g1022 r251, g1023 r249) and 137
kills are therefore not evidence of a deterministic row limit.

F6. **Other integrity items.** g1003 attempt-001's tracked FAILED.json and
row-242 raw pair are deleted in the working tree and attempt-001 was later
extended with 18 SKIP files and a 258/276 RUN_MANIFEST (recoverable from
git HEAD; g1003 is still valid through attempt-002). The g1010 resume review
(2026-09-09) described raw stderr/stdout content, breaching outcome-blindness.
The tracked stdout files shown as modified for g1004/g1005/g1006 row 6/7
match their receipts (the committed copies were mid-row snapshots); no
integrity problem. The 2 h cron f28e1331 was disabled since 2026-09-14.

## Validation (orchestrator metadata validation, 2026-09-27)

PASS (9 seeds): g1001-a001, g1002-a001, g1003-a002, g1004–g1009-a001.
FAIL: every g1010–g1032 attempt (receipt counts 0–272, SKIP files, nonzero
receipts, or missing ATTEMPT.json). All 32 prepared v1 manifests and query
files regenerate byte-identically from the frozen prepare path and agree with
every ATTEMPT.json source_manifest_sha256.

## Prefix-resume audit (2026-09-25 rename of 23 partial RUN_MANIFESTs)

After the rename at ~11:47 PDT, the watchdog relaunched the modified runner.
Within an hour it wrote new RUN_MANIFEST.json files for g1010, g1011-a003,
g1012-a001, g1013, g1014, g1017–g1021 **without executing a single row**:
zero receipts and zero SKIP files are newer than 2026-09-25 11:40 in any
g1010–g1032 attempt; the runner simply stepped over pre-existing SKIP files.
None of these "completions" passes validation (200–266 receipts). The
daily-overview claim "done: g1001–g1014, g1017–g1021" is wrong: only
g1001–g1009 are done. The rename bypassed amendment rule 3 (dead runner →
review action) — flagged to Ben. Nothing was invalidated, moved or deleted by
this review.

## Identity review R1: pinned clean PeTTa runtime path

To restore the exact frozen runtime without touching the omegaclaw checkout,
a clean clone was made at
projects/petta-chem/repos/PeTTa-pinned-4ce1d0ea, detached at
4ce1d0ea58855abb772b911278312c8846e5cc08, tracked tree clean, no mork_ffi.
run.sh b0ee9930…, src/main.pl cc381df2…, src/metta.pl 95b10adc… (= git HEAD
blob; the omegaclaw copy differs). swipl 9.3.36 unchanged. The runtime
identity string, source commit, manifests and runner hash are unchanged;
only ATTEMPT.json runner_path changes for new attempts. This is strictly
closer to the frozen runtime used by the 9 valid shards than the shared
checkout.

Gates on 2026-09-27 against this runtime: durable-v2 synthetic gate PASS
(frozen runner), 9/9 independent RAF-oracle unit tests PASS (run as
PYTHONPATH=. python3 tests/test_raf_oracle.py; python -m unittest resolves a
foreign tests package from petta-memory), neutral SSA tests PASS, neutral RAF
fixtures PASS, orchestrator v3 synthetic tests PASS.

## Actions

1. Frozen runner restored (423e2862).
2. Orchestrator v3 (scripts/neutral_calibration_orchestrator.py) replaces the
   watchdog: identity preflight before any launch; SKIP/nonzero/missing
   ATTEMPT → INVALID; head-of-line safe; transition alerts in ALERTS.jsonl
   with runner-log error line; 6 h stall alert; max 3 slots, MemAvailable
   >= 2 GiB, nice 10, CPU0 excluded; fresh attempts only by recorded one-shot
   authorization; --review-resume implements the documented review action.
3. Old orchestrator_state.json archived by rename to
   orchestrator_state.json.pre-v3-20260927.
4. Fresh attempts (row zero, unchanged manifest/identities, next unused
   attempt number) authorized for g1015, g1016, g1022, g1023, g1024, g1025,
   g1026, g1027, g1028, g1029, g1030, g1031, g1032 — the g1003-a002
   procedure. A fresh attempt that fails writes FAILED.json and freezes; no
   auto-retry.
5. Held for Ben: g1010–g1014, g1017–g1021 (reported-complete, invalid).
