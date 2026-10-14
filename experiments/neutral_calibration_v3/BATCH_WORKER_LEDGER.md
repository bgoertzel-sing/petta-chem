# Neutral calibration v3 - batch worker ledger

| UTC / local | actor | action | evidence |
|---|---|---|---|
| 2026-10-13 13:28 PDT | subagent b221a8f2 (authority Ben msg 7878) | task accepted: fix + per-row validator + relaunch | this file |
| 13:30 PDT | subagent | fix commit 10a8ed88 (queries import RAF then SSA) | git show 10a8ed88 |
| 13:31 PDT | subagent | 32 shards prepared under prepared/ (276 rows each) | prepared/graph-seed-*/MANIFEST.json |
| 13:31 PDT | subagent | smoke rows started (tmux petta-neutral-v3-smoke-a/b/c) | SMOKE_GATE.md |
| ~13:40 PDT | subagent | worktree snapshot + restore of tracked v2/script files | LAUNCH_REVIEW.md s8 |
| ~13:40 PDT | subagent | stopped tmux petta-neutral-v2-orchestrator (idle); f28e1331 already disabled | supervisor.log (v2) |
| 13:43 PDT | subagent | batch-path regression test PASS (L4 f=8, 136 rule IDs) | smoke/regression_test.log |
| 13:59 PDT | subagent | f=0 smoke row g1002 FAILS validator (vacuous reachable with empty RAF) | smoke/early/ |
| 14:03 PDT | subagent | f=8 smoke rows g1001/g1002 PASS (RAF 204/216); f=0 g1001 FAILS (same reason) | SMOKE_GATE.md |
| 14:05 PDT | subagent | infra commit 7342654d; preflight PASS; dry-run g1001+g1002 queued, 30 outside pilot | dry_run_20261013.txt |
| 14:10 PDT | subagent | **pilot NOT launched**: awaiting Ben's decision on empty-RAF reachability (LAUNCH_REVIEW s6) | LAUNCH_REVIEW.md |
| 14:10 PDT | subagent | 7 AM job 6fb7b7bc scratch updated for v3 | openclaw automations scratch 6fb7b7bc |

| 15:39 PDT | subagent 916d9232 | Ben msg 7897: option A approved (empty-RAF guard; no speedup, no grid/seed/T/bin/threshold change) | this file |
| 15:40 PDT | subagent | guard commit 6a5c0c1c (chem_neutral_ssa.metta sha256 c868f88a...); smoke.metta 125/125 PASS incl. 2 new empty-RAF tests (discriminating vs old source) | guard/unit_tests.log |
| 15:41 PDT | subagent | prepared g1001/g1002 regenerated via frozen prepare path: byte-identical (no source hash embedded) -> not regenerated | - |
| 15:41 PDT | subagent | post-guard smoke started (tmux petta-neutral-v3-guard-a/b/c) | smoke_guard/ |
| 15:42-15:49 PDT | subagent | f=0 g1001/g1002 PASS (empty RAF, reachable false/censored); L4 regression row atom byte-identical; batch-path INDEX=0 + new empty-RAF guard test PASS | SMOKE_GATE.md, guard/ |
| 15:50 PDT | subagent | infra commit 4d8174a4: orchestrator pins SOURCE_COMMIT 6a5c0c1c + new ssa hash; preflight PASS | git show 4d8174a4 |
| ~15:30-16:10 PDT | (pre-guard smoke) | L6 row 5535 s PASS (RAF 166); V200 row 4072 s PASS (RAF 204); sessions exited on their own | smoke/timings.jsonl |
| 16:11 PDT | subagent | f=8 L5 V100 g1001/g1002 PASS (RAF 204/216, 1760/1820 s), row atoms byte-identical to pre-guard -> **smoke gate PASS** | SMOKE_GATE.md |
| 16:12 PDT | subagent | preflight PASS; dry-run queues only g1001, g1002 (source-commit 6a5c0c1c), 30 outside pilot | dry_run_20261013_guard.txt |
| 16:12 PDT | subagent | **pilot launched**: scripts/neutral_v3_supervisor.sh ensure -> tmux petta-neutral-v3-orchestrator, petta-neutral-v3-g1001-a001 (runner pid 1899351), petta-neutral-v3-g1002-a001 (runner pid 1899359) | supervisor.log, orchestrator.log |
| 16:14 PDT | subagent | first receipts: 5 per seed (rows 000-004), all validator verdict pass, ATTEMPT source_commit 6a5c0c1c, validator 9db9d368; ALERTS.jsonl empty | graph-seed-100{1,2}/attempt-001/receipts |

Running at hand-off: pilot only (g1001, g1002 attempt-001) under supervisor
tmux petta-neutral-v3-orchestrator (10-min ticks; exits at PILOT_DONE).  Seeds
1003-1032 NOT authorized.  No smoke sessions remain.

| 17:47 PDT | subagent 92aecb84 | Ben msg 7901: speed up without changing results; reachability known-answer canary | this file |
| 17:49 PDT | subagent | worktree repos/petta-chem-v3-speedup, branch neutral-v3-raf-once (from d40d4db); main tree src untouched because the pilot imports it live | git worktree list |
| 17:52 PDT | subagent | RAF-only L5 f2-16 probe on new source: 947 s -> 5 s (same 204 reactions); unit tests ssa 125/125, raf 43/43, raf oracle 9/9 | speedup branch: experiments/neutral_calibration_v3/speedup_validation/ |
| 17:53 PDT | subagent | **reachability canary FAILS** (positive canary reachable false on old AND new source); summary function itself passes a direct known-answer test; cause: SSA event/waiting-time draws are arithmetic progressions in the event index (non-random sweep) | speedup branch: experiments/neutral_calibration_v3/REACHABILITY_CANARY.md |
| 17:52-20:09 PDT | subagent | byte-identity validation, 9 rows (f=0 x2, f=4, f=8 x2 L5 V100; L4 f=8; L6 f=8; V50 f=8; V200 f=8): ALL byte-identical; all new rows validator PASS; wall s old->new: 1760->288, 1820->349, 1201->143 (f=4), 5535->1190 (L6), 2424->202 (V50), 184->93 (L4), 4072->4133 (V200, SSA-dominated) | speedup branch SPEEDUP_VALIDATION.md (commit 9077894) |
| 18:59 PDT | subagent | harness incident: stale wait loop tmux-killed the first new-source V200 validation run at ~51 min (validation-only process; pilot untouched); rerun 19:00 | speedup branch speedup_validation/aborted_v200_killed_by_harness/ |
| 19:03 PDT | subagent | diagnostic: same positive canary with ONLY the two draw functions replaced by a nonlinear mix -> reachable true @2.20, ablated false | REACHABILITY_CANARY.md |
| 18:51 PDT | subagent | speedup source commit 322cafc3 on branch neutral-v3-raf-once (not pushed, not merged) | git show 322cafc3 |
| (end) | subagent | **pilot NOT relaunched / NOT stopped** (canary failed -> brief says do not relaunch); attempt-001 on 6a5c0c1c keeps running; orchestrator pins unchanged; Ben decision needed on the SSA sampler | LAUNCH_REVIEW.md top |
