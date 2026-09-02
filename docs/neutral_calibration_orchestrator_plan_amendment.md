# Orchestrator plan amendment: automated 32-shard batch drain

Status: approved by Ben 2026-09-02 00:16 PDT ("Yes this makes sense... it will
save me needing to pay attention to telling you to resume the workers on this
over and over again.")
Date: 2026-09-02
Amends: `neutral_calibration_batch_acquisition_plan.md`

## What changes

The frozen acquisition plan required each shard launch to be "a separate
reviewed action" and originally said "run at most one shard at a time." Ben's
2026-08-30 directive already amended concurrency to 4 concurrent shards
(g1003–g1006). This amendment replaces per-shard manual launch review with a
supervised queue drain, keeping every other frozen constraint:

- Frozen identities unchanged: source `4b7c6de4ec8eb71502588d2714579c7d55d4bd50`,
  runtime identity string from the g1001 launch review (PeTTa `4ce1d0ea`,
  swipl 9.3.36 pinned, mork_ffi absent). Any identity change still requires a
  new identity review before the orchestrator's constants are updated.
- Launch mechanics unchanged: the same tmux + `run_neutral_calibration_shard_v2.py`
  command template from the reviewed launch plan, including the pinned-swipl
  PATH fix recorded in TASKS.md 2026-08-30.
- Manifests prepared through the unchanged frozen prepare path
  (`prepare_neutral_calibration_queries.py`).
- At most 4 concurrent shards.

## Orchestrator safety rules (`scripts/neutral_calibration_orchestrator.py`)

1. Completion of a shard is recognized only from `RUN_MANIFEST.json`
   (`raw-complete-unanalysed`, 276/276). The orchestrator then runs
   metadata-only validation: receipt contiguity 0..275, zero exit codes,
   SHA-256 verification of every query/stdout/stderr against receipts, and
   frozen identity match. Only a clean validation frees the slot and launches
   the next queued seed.
2. `FAILED.json` in the newest attempt freezes that seed. No auto-retry —
   the g1003 row-242 rule is preserved. The slot stays empty until a separate
   review unfreezes (by editing `orchestrator_state.json` and launching a new
   attempt manually, exactly the procedure used for g1003 attempt-002).
3. A dead runner with neither terminal manifest is reported as INTERRUPTED
   and not restarted: v2 recovery requires identity re-verification plus the
   synthetic gate, which remains a review action.
4. A seed whose newest attempt is running/complete is never blocked by older
   failed attempts — the existence of a newer attempt already implies the
   earlier failure was reviewed (as with g1003 a001→a002).
5. Launches are deferred when MemAvailable < 2 GiB.
6. No endpoint content is ever opened: only manifests, receipts, and file
   hashes. Raw stdout remains sealed until all 32 shards complete and a
   separate batch-preflight authorization passes.
7. When all 32 seeds are complete and validated the orchestrator halts with
   BATCH_DONE. It launches no analysis.

## Cadence and reporting

The orchestrator runs from the existing 2-hourly OpenClaw cron
(`f28e1331`), whose prompt is updated to invoke the orchestrator first and
then report its output plus memory headroom to the ProtoBots-updates channel.
Failures, freezes, interruptions, shard completions, and BATCH_DONE are
alert-worthy; routine healthy ticks stay short. The daily 7AM overview
(`6fb7b7bc`) is unchanged.

## Expected duration

Observed shard pace is ~2.3 days wall-clock (g1003-a002: 256/276 in ~2.1
days). 26 remaining seeds / 4 slots ≈ 7 waves ≈ 2.5 weeks, plus slack for
frozen-seed reviews. Automation saves operator attention, not compute.
