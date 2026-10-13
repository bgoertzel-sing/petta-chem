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
