# Neutral calibration v2 — EXPLORATORY analysis summary (2026-10-13)

**EXPLORATORY; not the frozen confirmatory analysis.** Authorized by Ben 2026-10-13 (D1=B).

## Headline: the batch does not contain a usable structural RAF endpoint

In **all 6,672 parsed rows (100%)**, the `maximal-raf-rule-ids` field is an
**unreduced MeTTa call**, `(neutral-raf-reaction-ids (neutral-raf-maximal-reactions FOOD REACTIONS CATALYSIS))`,
not a list of rule IDs. A prior metadata-free scan of every v2 stdout on disk (8,954 rows that have a row atom, including invalid attempts) found the same thing in every row.

Likely root cause (from source inspection, not yet confirmed by a rerun): each query file imports only
`src/chem_neutral_ssa.metta`. That file calls `neutral-raf-maximal-reactions`,
`neutral-raf-reaction-ids` and `neutral-raf-closure`, but it never imports `src/chem_neutral_raf.metta`, where those functions are defined.
PeTTa therefore left them unevaluated as data. The SSA/ablation dynamics then ran against that unreduced term.

Consequences:
- **Structural** (RAF incidence, maximal-RAF size): **unavailable for every row**. The incidence curve and Wilson CIs cannot be estimated, and **f50 cannot be estimated** (17/17 primary control points unavailable). Unavailable does not mean zero.
- **Reachable / active-persistent / causal**: they parse cleanly but are degenerate. Every row has reachable=false (censored), raf-events=0, evidence-bins=0 and all deltas = 0. These values come from the broken RAF input, so they are **diagnostic only and are not evidence** of non-reachability or non-persistence. Per the ladder, no claim is made at any rung.
- The only non-degenerate serialized quantity is integrated non-food count (same in both arms, so delta = 0). Primary panel, core 22 graphs, baseline mean (bootstrap 95% CI) by f: 0: 3.48; 0.5: 38.9 [4.0,108]; 1: 45.5 [6.5,117]; 2: 87.8 [25,173]; 3: 83.7 [28,163]; 4: 174 [68,303]; 5: 205 [94,334]; 6: 847 [262,1602]; 7: 1128 [445,1917]; 8: 1216 [476,2116] (full table in transition_curve.tsv). This is descriptive. It mixes the effect of catalysis density with the RAF defect and says nothing about RAF emergence.

## Data accounting

- Rows analyzed: 6,672 = 22 complete seeds × 276 (6,072, the core) + 600 hash-verified partial rows (sensitivity only).
- Partial rows included, matching the prior check exactly: g1011 a003 202; g1012 a003 132 + a001 136; g1017 a003 8; g1021 a001 44; stale g1014 22, g1018 22, g1019 17, g1020 17.
- Partial receipts excluded: 670, all stdout-file-missing (g1010 200, g1013 218, g1012 a001 30, g1021 a001 222). **g1010 and g1013 have zero verifiable rows and are excluded.**
- Parse failures: **0**. Duplicates: 0. Identity mismatches: 0.
- Missing rows in the 10 partial seeds: 2,160 = not-run 1,226, raw-lost 640, skipped 294. Skips are concentrated in V200 (222) and V50 (58); there are only 7 each in the primary and finite-size panels. See missingness.jsonl, one entry per (seed,row) with its reason.
- Sensitivity (core vs all rows): every endpoint is identical (all 0 / unavailable), so delta = 0.

## Recommendation (needs Ben's decision)

The v2 batch, including the 22 validated seeds, cannot answer the structural question or any later question on the ladder.
1. Add the import of chem_neutral_raf.metta, either in the source or in the query, under a reviewed source/manifest change.
2. Add a smoke gate that asserts maximal-raf-rule-ids is a reduced list in a real row at f=8.
3. Rerun.

Artifacts: canonical_rows.jsonl, validation_report.json, exclusions.jsonl, missingness.jsonl, graph_table.jsonl, transition_curve.tsv, analysis_results.json, RUN.md.
