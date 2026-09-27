# Neutral calibration v2 — batch worker ledger

Owner: persistent batch-owner subagent (OpenClaw session 0825d5c2, spawned
2026-09-27 from telegram group -5437945421). Parent can pause by
`tmux kill-session -t petta-neutral-v2-orchestrator` + disabling cron
f28e1331; running shards are unaffected by stopping the supervisor.

## Objective and acceptance

All 32 graph seeds (g1001–g1032) have a RUN_MANIFEST
`raw-complete-unanalysed` 276/276 that passes orchestrator metadata
validation, under the frozen protocol; then halt at BATCH_DONE with no
analysis. Acceptance: `python3 scripts/neutral_calibration_orchestrator.py
--dry-run` reports `complete: 32/32` and BATCH_DONE; ledger and project
records updated; supervisor + event-only scheduled check in place.

## Authority (durable, ongoing)

- Ben Goertzel, Telegram msg 7019, 2026-09-27 10:45 PDT: "fix the watchdog
  and replace it with an actually working persistent subagent for getting
  these runs completed". Scope as delegated by parent: replace watchdog,
  review actions, fresh attempts per the g1003-a002 procedure, persistence and
  automations. Excludes: paid/remote compute, analysis, GitHub pushes,
  identity changes without committed review, new timeout/skip policy,
  invalidating/moving the reported-complete attempts.
- Earlier standing approvals still binding: plan amendment 2026-09-02 (queue
  drain, <=4 slots), concurrency directive 2026-08-30.
- Consumed one-shot authorizations are recorded in
  orchestrator_state.json `consumed`.

## Protocol references

docs/neutral_calibration_v2_launch_plan.md; docs/neutral_calibration_orchestrator_plan_amendment.md;
docs/neutral_calibration_recovery_policy.md; docs/neutral_calibration_g1003_oom_review.md;
docs/neutral_calibration_g1003_restart_review.md; docs/neutral_calibration_g1010_resume_review.md;
**docs/neutral_calibration_v2_batch_integrity_review_20260927.md** (this worker's review, identity review R1);
**docs/neutral_calibration_v2_decision_memo_20260927.md** (open decisions for Ben).

## Frozen identities (verified 2026-09-27 by `--preflight-only`: PASS)

source 4b7c6de; v2 runner script 423e2862 (restored); PeTTa 4ce1d0ea at
projects/petta-chem/repos/PeTTa-pinned-4ce1d0ea (clean clone; run.sh
b0ee9930, main.pl cc381df2); swipl 9.3.36; mork_ffi absent; SSA ebdcf044,
RAF 0ed75203. All 32 v1 manifests regenerate byte-identically.

## Supervisor

- tmux `petta-neutral-v2-orchestrator` → scripts/neutral_v2_supervisor.sh loop
  (flock single instance; tick every 10 min; exits at BATCH_DONE).
  Idempotent start: `scripts/neutral_v2_supervisor.sh ensure`.
- Cron f28e1331 (every 2h, enabled 2026-09-27) runs
  scripts/neutral_v2_health_check.sh; posts to telegram -5437945421 only on
  events (ALERTS.jsonl since ALERTS.cursor).
- Daily overview 6fb7b7bc (07:00) wording fixed 2026-09-27.
- Logs: supervisor.log, orchestrator.log, ALERTS.jsonl, reviews/.

## State (2026-09-27 11:10 PDT)

| group | seeds | status |
|---|---|---|
| valid complete | g1001–g1009 (g1003 via a002) | complete-validated |
| running (fresh, row 0) | g1015-a003, g1016-a002, g1022-a002 | launched 11:03 PDT |
| queued fresh (authorized) | g1023-a002, g1024-a002, g1025-a004, g1026-a002, g1027-a004, g1028-a004, g1029-a002, g1030-a002, g1031-a002, g1032-a002 | wait for slot |
| held for Ben (D1) | g1010–g1014, g1017–g1021 | invalid; no action |

## Next action

Supervisor launches queued seeds as slots free (~3.5–4.5 days per shard).
Await Ben on D1–D4. On FAILED.json: seed freezes; write review, alert Ben;
no retry. On interruption: `--review-resume SEED`.

## Tick log (events only)

- 2026-09-27 11:03 PDT: v3 supervisor started; 3 fresh attempts launched; initial 96 transition alerts (dry-runs + first tick) acknowledged by owner, cursor set to 96.
