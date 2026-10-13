# RUN: neutral calibration v2 — EXPLORATORY analysis of available data

**Label: EXPLORATORY.** Not the frozen confirmatory analysis of
docs/neutral_calibration_analysis_plan.md (that plan requires 32 complete seeds;
this run uses 22 complete + hash-verified partial rows).

- Authorization: Ben Goertzel, 2026-10-13 10:31 PDT, "analyze what we have", after D1=B (accept skipped rows). Executed by OpenClaw subagent 538e9ad6 on 2026-10-13.
- Host: pop-os, Linux 7.0.11; Python 3.10.12; numpy 2.2.6.
- Repo HEAD at run time: 21e2395d2e51bd66dd475d43d6a7b6c2b1e8f036 (working tree had unrelated pre-existing modifications; untouched). Scripts are committed in the commit that adds this file.
- Frozen PeTTa source commit named by receipts: 4b7c6de4ec8eb71502588d2714579c7d55d4bd50.

## Commands (cwd = repo root)

```
python3 scripts/extract_neutral_calibration_real.py --out experiments/neutral_calibration_v2/analysis_20261013   # exit 0, 41.7 s, 44 MB RSS
python3 scripts/analyze_neutral_calibration_real_exploratory.py --dir experiments/neutral_calibration_v2/analysis_20261013   # exit 0, 1.4 s
```

## Selection

Metadata-only, then hash-verified intake. 22 validated attempts from
orchestrator_state.json "validated" (sha256 recorded in validation_report.json),
plus partial dirs g1010 a001, g1011 a003, g1012 a003+a001, g1013 a001, g1017 a003,
g1021 a001, g1014/g1018/g1019/g1020 attempt-002.stale-20260916212158. A row is usable iff
receipt parses, exit_code==0, query/stdout/stderr exist and SHA-256 match receipt.
Dedup within seed: newest canonical attempt first. Per-seed source-manifest SHA-256s
are in validation_report.json → source_manifest_sha256.

Analysis seed 73020260727; 10,000 bootstrap resamples over graphs (core = 22 validated seeds).

## Artifact SHA-256 (as produced)

- canonical_rows.jsonl 4c3fd9758218a5d6c780e28bbefe843bf9d461a1384c9972df28e9b6ee92f4bb
- validation_report.json 33c594ab0134ea6300d0bd15195ce8edb8f0525dc340b4a93d714eb46e8e7d19
- exclusions.jsonl 36970563398db6dfaa6b0a3911c670b3d98c9b39819a72859a7752f4c9dde63d
- missingness.jsonl 1d0c3ba59b787922ef5a55257f601f337d53b89dd490a9758020474ace75f090
- graph_table.jsonl ebcacc43345b6a58b86b47fd7e819e66dc381066fcc1b8afea1897292ff6cd41
- transition_curve.tsv 5bf784806ac77f7195ce1cc497d310aaa8195a8aa386977a5582afbb86aff6a2
- analysis_results.json 47a3e0bea34a9e39190749da472980a2c9e8e69d0ed3ded467d037a99f71c02e

No secrets. Nothing pushed.
