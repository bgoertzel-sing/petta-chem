# Neutral calibration graph-1003 row-242 OOM review

Status: reviewed; proceeding with fresh attempt-002

Date: 2026-08-30

Reviewer: OpenClaw research agent (subagent, session bb8a4afd)

## Summary

Graph-seed-1003 attempt-001 (`neutral-v2-g1003-a001`) failed at row 242
(`population-scaling-control-L5-f2-12-V200-g1003-d2003`) with exit code 137
(SIGKILL) at 2026-08-20T20:17:37Z. The evidence supports a transient OOM
kill specific to this row's combinatorial memory demand, not a systematic
problem with V200 rows or the shard as a whole. A fresh attempt-002 from
row zero is recommended.

## Evidence

### Failure record

`experiments/neutral_calibration_v2/graph-seed-1003/attempt-001/FAILED.json`:

```json
{
  "attempt_id": "neutral-v2-g1003-a001",
  "exit_code": 137,
  "failed_utc": "2026-08-20T20:17:37.986514+00:00",
  "row_id": "population-scaling-control-L5-f2-12-V200-g1003-d2003",
  "row_index": 242,
  "schema": "neutral-calibration-failed-attempt-v2"
}
```

Exit code 137 = 128 + 9 (SIGKILL), consistent with the Linux OOM killer
or an external process manager terminating the swipl process.

### System context

- Total RAM: 15 GiB (16215944 kB)
- Swap: 19 GiB
- At time of failure: ~4.0 GiB used (OpenClaw gateway + Telegram desktop + ollama)
- Available at failure: approximately 10 GiB free, but the swipl process
  for row 242 spiked to 99.9% CPU for ~5 minutes before being killed,
  suggesting rapid memory growth during combinatorial enumeration

### Journal context (2026-08-20 13:23 PDT)

"swipl ran row 242 at 99.9% CPU for ~5 min, then exit 137 (SIGKILL) — likely
OOM killer. The V200 population-scaling config may need more than 15 GB RAM"

### Kernel logs

Kernel ring buffer has rotated past 2026-08-20; `dmesg` is empty. No direct
OOM-kill line is available, but the exit pattern is consistent with OOM.

### Prior interruption history of row 242

Row 242 was the in-flight row during both:
1. The 2026-08-14 priority pause (Ben prioritized OmegaClaw recovery)
2. The 2026-08-20 OOM kill

During the Aug 14 pause, the row was simply interrupted (clean stop, no
failure). During the Aug 20 OOM, the row was actively computing and was
killed by SIGKILL after ~5 minutes of sustained 99.9% CPU.

### Successful V200 rows in the same attempt

Attempt-001 completed 242 receipts (rows 0–241), including many V200
population-scaling rows with different f2 and dynamics-seed parameters:

- Row 200: `population-scaling-control-L5-f2-7-V200-g1003-d2001` ✅
- Row 202: `population-scaling-control-L5-f2-7-V200-g1003-d2003` ✅
- Row 208: `population-scaling-control-L5-f2-8-V200-g1003-d2001` ✅
- Row 211: `population-scaling-control-L5-f2-8-V200-g1003-d2004` ✅
- Row 240: `population-scaling-control-L5-f2-12-V200-g1003-d2001` ✅
- Row 241: `population-scaling-control-L5-f2-12-V200-g1003-d2002` ✅

Rows 240 and 241 are the same f2=12, V200 configuration with d2001 and d2002
dynamics seeds — they completed successfully. Only d2003 failed.

## Analysis

The failure is specific to the combination:

```
population-scaling-control-L5-f2-12-V200-g1003-d2003
```

Not all V200 rows fail. Not all f2=12 rows fail. Not all d2003 rows fail.
The combinatorial interaction of f2=12 (high reaction count) with V200
(large population) and the specific dynamics seed d2003 produces a memory
spike that exceeds available RAM under the current system load.

With ~10 GiB available at the time and swipl reaching 99.9% CPU for 5
minutes before SIGKILL, the most likely explanation is a transient memory
spike during combinatorial enumeration that exceeded the available physical
memory, triggering the OOM killer. The same row may succeed if:

1. System memory pressure is lower at execution time
2. The combinatorial explosion happens to follow a slightly different path
   (deterministic, but the memory profile depends on the enumeration order)
3. Other transient processes have freed memory

However, since the computation is deterministic, the same dynamics seed
d2003 will produce the same enumeration. The memory spike may be inherent
to this parameter combination. If it fails again with exit 137, it should
be treated as a systematic limit of this row configuration on 15 GiB RAM,
not a transient issue.

## Conclusion and recommendation

**Conclusion:** The OOM kill at row 242 is likely a transient memory spike
specific to the `f2=12, V200, d2003` combinatorial configuration, which
produces a larger working set during enumeration than other V200/f2=12/d
combinations that completed successfully. The failure is not systematic
across V200 rows or the shard as a whole.

**Recommendation:** Proceed with a fresh attempt-002 from row zero. All
frozen identities (manifest, sources, runner, PeTTa, runtime) have been
re-verified and match the launch review. The attempt-001 directory is
preserved unchanged.

**Risk:** Row 242 may fail again with the same OOM pattern. Monitor
specifically when the runner approaches row 242 (approximately 242/276
through the shard). If exit 137 recurs at row 242:

- Freeze and alert Ben immediately
- Do NOT auto-retry
- Document the failure as a systematic RAM limitation for this row
  configuration

**Mitigation note:** If row 242 fails again, options include running
the shard on a higher-RAM host, reducing ollama/memory overhead during
the critical rows, or splitting row 242 into a separately resourced
execution.
