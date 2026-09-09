# g1010 Resume Review — Neutral Calibration v2

**Date:** 2026-09-09T07:04Z
**Seed:** g1010 (graph-seed-1010, attempt-001)
**Status:** INTERRUPTED at 265/276 receipts

## 1. Interruption Summary

- **Receipts present:** 265 (index 0–264), contiguous, all exit_code=0
- **Missing:** rows 265–275 (11 rows)
- **Root cause:** Row 265 process terminated (stderr='Terminated'). stdout shows incomplete Prolog output — process was killed mid-computation, likely by OOM killer or external signal.
- **Raw files for row 265:** stdout + stderr exist in raw/ directory (partial, not receipted)
- **Orchestrator state:** g1010 classified as "interrupted" — logged repeatedly since 09:03Z. Not frozen. Requires manual review action (identity re-verification + synthetic gate) before resume.

## 2. Identity Re-Verification

- **PeTTa HEAD:** `4ce1d0ea58855abb772b911278312c8846e5cc08` ✅ (matches frozen identity)
- **source_commit:** `4b7c6de4ec8eb71502588d2714579c7d55d4bd50`
- **runtime_identity (from ATTEMPT.json):** `petta=4ce1d0ea58855abb772b911278312c8846e5cc08;run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;swipl=9.3.36-x86_64-linux;mork_ffi=absent`
- **All 265 receipts:** same runtime_identity (verified contiguous, all exit_code=0)

## 3. Synthetic Gate

- `run_shard_v2.py` `validate_prefix()` handles resumption automatically:
  1. Verifies all 265 existing receipts match expected identity and hashes
  2. Detects partial raw file for row 265 (next unreceipted row)
  3. Quarantines partial raw files to `quarantine/row-265-<uuid>/`
  4. Continues execution from row 265 through row 275 (11 rows remaining)
- No `--start-row` flag needed — `validate_prefix()` auto-detects resume point

## 4. Resume Plan

**Constants (from orchestrator):**
- ROOT: `/home/openclaw/research-agent/projects/petta-chem/repos/petta-chem`
- RUNNER: `/home/openclaw/research-agent/projects/omegaclaw/repos/PeTTa/run.sh`
- SWIPL_BIN: `/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin`
- SOURCE_COMMIT: `4b7c6de4ec8eb71502588d2714579c7d55d4bd50`
- RUNTIME_IDENTITY: `petta=4ce1d0ea58855abb772b911278312c8846e5cc08;run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;swipl=9.3.36-x86_64-linux;mork_ffi=absent`

**Resume command (launch when a slot frees, MAX_SLOTS=4):**
```bash
tmux new-session -d -s petta-neutral-v2-g1010-a001 -- bash -lc \
  'cd /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem && \
   exec env PATH=/home/openclaw/research-agent/projects/omegaclaw/local/swipl-9.3.36/bin:/usr/bin:/bin \
   python3 scripts/run_neutral_calibration_shard_v2.py \
     --shard-dir experiments/neutral_calibration_v1/graph-seed-1010 \
     --runner /home/openclaw/research-agent/projects/omegaclaw/repos/PeTTa/run.sh \
     --attempt-dir experiments/neutral_calibration_v2/graph-seed-1010/attempt-001 \
     --attempt-id neutral-v2-g1010-a001 \
     --source-commit 4b7c6de4ec8eb71502588d2714579c7d55d4bd50 \
     --runtime-identity "petta=4ce1d0ea58855abb772b911278312c8846e5cc08;run_sh=b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae;main_pl=cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c;swipl=9.3.36-x86_64-linux;mork_ffi=absent" \
     >> experiments/neutral_calibration_v2/graph-seed-1010/attempt-001.runner.log 2>&1'
```

**Timing:**
- MAX_SLOTS=4 (Ben's directive), all 4 occupied (g1011, g1012, g1013, g1014)
- g1011 at 248/276 (~28 rows remaining, ~5-6h ETA at ~5 rows/hr)
- Launch g1010 resume when g1011 completes (frees a slot)

## 5. Post-Resume Verification

1. Confirm `validate_prefix()` accepts 265 existing receipts
2. Confirm partial row 265 raw files quarantined
3. Confirm receipts 265–275 appear with exit_code=0
4. Confirm total = 276 receipts
5. Confirm RUN_MANIFEST.json written (completion)

## 6. Risk Assessment

- **Low risk:** 265/276 receipts already validated, identity stable
- **Resume code path** (`validate_prefix`) designed for exactly this scenario
- **No data corruption:** all received receipts have exit_code=0, raw partial will be quarantined
- **11 rows remaining** — minimal additional runtime (~2-3h)

---
*Prepared by Iter agent, 2026-09-09T07:04Z*
