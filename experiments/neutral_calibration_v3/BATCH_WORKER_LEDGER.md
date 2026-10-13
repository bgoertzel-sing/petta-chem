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

Running at hand-off (smoke only, outside batch dirs; safe to kill):
tmux petta-neutral-v3-smoke-a, -b, -c (L6 then V200), petta-neutral-v3-probe.
No v3 batch attempt directories exist.
