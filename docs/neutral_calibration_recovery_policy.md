# Neutral calibration whole-shard recovery policy

Status: frozen before recovery execution on 2026-08-02.

This policy applies to an interrupted `neutral-calibration-query-shard-v1`
attempt that did not emit a `neutral-calibration-raw-shard-v1` run manifest.
It preserves the preregistered graph-seed-complete sampling unit and prevents
runtime interruptions from becoming an outcome-dependent selection rule.

## Binding recovery rule

1. Do not parse, display, summarize, or otherwise inspect any raw stdout or
   stderr from the interrupted attempt.
2. Rename the complete `raw/` directory atomically to a unique
   `raw-interrupted-*` directory. Never copy individual rows, delete a partial
   row, or overwrite an earlier attempt.
3. Record only filesystem metadata (relative name and byte count), the frozen
   source-manifest hash, and the archive directory in an outcome-blind
   `RECOVERY_PLAN.json`. The recovery preflight does not open raw files.
4. Restart the entire 276-row graph-seed shard in original manifest order,
   including rows that appeared to finish before the interruption. Do not
   resume a prefix, reuse prior stdout, retry selected rows, omit rows, extend
   the ledger, or change graph/dynamics seeds.
5. The next attempt must use the unchanged prepared manifest and pinned
   compatible PeTTa/SWI-Prolog runtime. The runner fails closed if an archived
   interrupted attempt exists without a matching whole-shard recovery plan.
6. Do not parse any calibration endpoint until one fresh attempt emits a
   complete `raw-complete-unanalysed` run manifest for all planned rows.
   Interrupted attempts remain provenance artifacts and are never substituted
   into the accepted shard.

The choice to restart rather than reuse cryptographically checked rows is
deliberately conservative: the interrupted attempt has no run manifest, so it
has no recorded exit status or runner-issued hashes establishing which rows
completed. Runtime cost alone is not grounds to weaken the sampling unit.

## Recovery interface

Run `scripts/archive_interrupted_neutral_calibration_shard.py` with the shard
directory and a unique archive name. It accepts only a prepared, endpoint-free
manifest; refuses an existing run manifest or archive target; inventories
regular files and symbolic links without following or reading them; renames
the entire directory; and writes `RECOVERY_PLAN.json` last. A subsequent raw
runner validates that plan against the current source-manifest hash.
