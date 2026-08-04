# Neutral calibration repeated-interruption decision

Status: frozen recovery decision; implementation and execution not authorized
Date: 2026-08-04
Decision version: `neutral-calibration-recovery-v2-design`

## Evidence boundary

The first fresh `graph_seed=1001` whole-shard attempt stopped while writing
row 235 of 276. Its raw directory was archived outcome-blind under the v1
whole-shard policy. The second fresh attempt stopped while writing row 233.
Metadata-only inspection found 234 stdout/stderr pairs, no live runner or
child PeTTa process, a `prepared-unrun` source manifest, and no run manifest.
No raw stdout/stderr content or calibration endpoint was opened or interpreted
in reaching this decision.

Two late failures under the same all-or-nothing execution mechanism establish
that another unchanged restart is not an adequate recovery action. They do not
authorize selecting completed-looking rows, inspecting endpoints, changing
seeds, or weakening the graph-seed-complete sampling unit.

## Binding decision

1. Preserve the second interrupted `raw/` directory unchanged. It is not an
   accepted prefix and none of its rows may contribute to a calibration result.
2. Do not archive it, restart the shard, resume it, or parse it under the v1
   runner. The existing `RECOVERY_PLAN.json` was consumed by the second fresh
   attempt and must not be treated as authorization for a third attempt.
3. Before any further calibration execution, implement and review a v2 raw
   runner with durable, outcome-blind per-row receipts as specified below.
4. The first v2 attempt must start from row zero using the unchanged 276-row
   manifest, original row order, queries, graph seed, dynamics seeds, and
   pinned compatible PeTTa/SWI-Prolog runtime. The two v1 attempts remain
   provenance only.
5. A later interruption of that v2 attempt may resume only its longest
   contiguous, receipt-validated prefix. This is execution continuation of one
   graph-seed-complete attempt, not selective retry or a change in sampling.
6. No endpoint may be parsed until all 276 rows have successful receipts and
   one final `raw-complete-unanalysed` manifest has been atomically emitted.

## Required v2 receipt contract

After a row subprocess exits successfully, the runner must fsync its raw
stdout/stderr, compute query/stdout/stderr SHA-256 values without displaying
content, and atomically publish one receipt containing:

- attempt ID, source-manifest hash, runner/source commit, and runtime identity;
- row index and row ID;
- query, stdout, and stderr relative paths and hashes; and
- exit code and completion timestamp.

On restart, the runner must validate every receipt and raw-file hash from row
zero, accept only the longest exact contiguous prefix, and continue at the
next manifest row. It must fail closed on a missing interior receipt, duplicate
or out-of-order index, changed manifest/query/runtime identity, hash mismatch,
nonzero exit, unexpected raw file, or receipt from another attempt. Validation
is mechanical and must not print, parse, or summarize raw endpoint content.

A row interrupted before its receipt exists is incomplete. Its raw pair must
be preserved in an attempt-local quarantine and rerun from that row only after
the runner has established that no successful receipt exists. A nonzero PeTTa
exit invalidates the attempt; it is not eligible for selective retry.

## Acceptance tests before execution

The v2 implementation is not authorized to run calibration chemistry until a
focused synthetic test proves all of the following:

1. uninterrupted execution emits ordered receipts and one complete manifest;
2. forced termination after a successful receipt resumes at exactly the next
   row and does not re-execute the validated prefix;
3. termination before receipt publication reruns only the unreceipted row;
4. raw-file, query, receipt, manifest, runtime, gap, duplicate, and ordering
   tampering all fail closed;
5. a nonzero row exit cannot be resumed or selectively retried; and
6. the runner refuses the current v1 interrupted artifacts and consumed v1
   recovery plan as a resumable prefix.

Only runner/oracle artifact glue may implement this contract. The PeTTa-native
chemistry, frozen neutral protocol, queries, ledger, seeds, endpoints, and
protected exp08/scratch/catalysis paths remain unchanged.

## Next reviewed task

Implement only the synthetic v2 receipt/resume runner and its focused tests.
Do not touch or inventory the current raw directory beyond metadata, and do not
launch the calibration shard in the same change.
