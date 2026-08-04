# Neutral calibration v2 first-attempt launch plan

Status: frozen and reviewed; launch not yet executed

Date: 2026-08-04

Plan version: `neutral-calibration-v2-g1001-attempt-001`

## Authorization boundary

This plan authorizes only a later, separately observed launch of the first v2
raw attempt for `graph_seed=1001`. It does not launch chemistry, inspect an
endpoint, parse a v1 raw file, or accept either v1 partial attempt as a prefix.
The existing v1 shard directory, its current `raw/`, its interruption archives,
and its consumed `RECOVERY_PLAN.json` remain unchanged provenance.

The v2 attempt must start at row zero and execute the unchanged 276-row
prepared manifest in its original order. It must stop at one
`raw-complete-unanalysed` manifest; endpoint parsing remains a separate gate.

## Frozen identities

- Source implementation commit: `4b7c6de4ec8eb71502588d2714579c7d55d4bd50`.
- Source manifest:
  `experiments/neutral_calibration_v1/graph-seed-1001/MANIFEST.json`, SHA-256
  `c92912f250ec9ecb44df160e3fc13d7480acfdf97eea7b791989a496326a441b`.
- Manifest contract: `prepared-unrun`, `endpoint_results_present=false`,
  `graph_seed=1001`, and 276 unique contiguous rows numbered 0 through 275.
- PeTTa SSA source SHA-256:
  `ebdcf0449bd783cab6c924f1c455d51141d1d74ff59251237a5e7596908f2ca3`.
- PeTTa RAF source SHA-256:
  `0ed75203fff2b9d31c0dac054290aeb5c29fac890ddcda13be6af528c0b26073`.
- v2 runner SHA-256:
  `423e2862d650389057bd4f7fdd0821d6666fa75fcc57a2a9a13dc0080fe8d09d`.
- PeTTa runtime commit: `4ce1d0ea58855abb772b911278312c8846e5cc08`.
- PeTTa `run.sh` SHA-256:
  `b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae`.
- PeTTa `src/main.pl` SHA-256:
  `cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c`.
- SWI-Prolog executable:
  `/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin/swipl`,
  reporting `SWI-Prolog version 9.3.36 for x86_64-linux`.
- Optional MORK FFI state: absent. It must remain absent for launch and resume.
- Runtime identity argument:
  `petta=4ce1d0ea58855abb772b911278312c8846e5cc08;run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;swipl=9.3.36-x86_64-linux;mork_ffi=absent`.

The launch operator must recompute these values and abort on any mismatch.
Tracked changes to either neutral source, the runner, or the runtime require a
new reviewed plan. The plan-only commit containing this document does not
change the frozen source implementation commit.

## Attempt separation and durability boundary

- Attempt ID: `neutral-v2-g1001-a001`.
- Attempt directory:
  `experiments/neutral_calibration_v2/graph-seed-1001/attempt-001`.
- Lifecycle log (outside the attempt directory):
  `experiments/neutral_calibration_v2/graph-seed-1001/attempt-001.runner.log`.
- tmux session: `petta-neutral-v2-g1001-a001`.

The v2 root and attempt directory were absent during review. The runner alone
creates `attempt-001`, its `ATTEMPT.json`, `raw/`, and `receipts/`. No v1 path
is passed as `--attempt-dir`. After each successful subprocess, the runner
fsyncs stdout and stderr and the raw directory before atomically publishing and
directory-fsyncing the hash-bound receipt. A restart accepts only the exact
receipt-validated prefix in this v2 attempt.

## Exact detached launch

Run from the repository root only after the identity checks and focused
synthetic test pass:

```bash
mkdir -p experiments/neutral_calibration_v2/graph-seed-1001
tmux new-session -d -s petta-neutral-v2-g1001-a001 -- bash -lc \
  'cd /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem && exec env PATH=/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin:/usr/bin:/bin python3 scripts/run_neutral_calibration_shard_v2.py --shard-dir experiments/neutral_calibration_v1/graph-seed-1001 --runner /home/openclaw/research-agent/projects/omegaclaw/repos/PeTTa/run.sh --attempt-dir experiments/neutral_calibration_v2/graph-seed-1001/attempt-001 --attempt-id neutral-v2-g1001-a001 --source-commit 4b7c6de4ec8eb71502588d2714579c7d55d4bd50 --runtime-identity "petta=4ce1d0ea58855abb772b911278312c8846e5cc08;run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;swipl=9.3.36-x86_64-linux;mork_ffi=absent" >> experiments/neutral_calibration_v2/graph-seed-1001/attempt-001.runner.log 2>&1'
```

Immediately verify only lifecycle metadata: the tmux session and runner/child
process are live, `ATTEMPT.json` names the frozen identities, and the first v2
receipt count begins from zero. Do not open raw stdout/stderr or query endpoint
atoms.

## Interruption and completion rules

If the detached process stops before completion, preserve the attempt and
first establish that no runner or child PeTTa process remains. Recompute every
frozen identity, rerun the synthetic gate, and invoke the exact same command
with the same attempt ID and directory. The runner must mechanically validate
the contiguous prefix and may quarantine only the next unreceipted raw pair.
A `FAILED.json`, identity mismatch, receipt gap, hash mismatch, unexpected
artifact, or nonzero row exit freezes the attempt for review; do not retry.

Completion is recognized only from
`attempt-001/RUN_MANIFEST.json` with schema
`neutral-calibration-raw-shard-v2`, status `raw-complete-unanalysed`, and
`completed_run_count=planned_run_count=276`. That authorizes preservation and
review of the raw artifact, not endpoint interpretation.

## Review evidence

The current v1 raw directory was checked by metadata only: it remains a
directory with 468 files (234 stdout/stderr pairs), and no calibration runner,
child PeTTa process, or tmux session was live. No raw file was opened. The
focused v2 synthetic test is the required pre-launch behavioral gate.
