# Neutral calibration extractor contract review

Status: frozen review; real adapter and endpoint inspection not authorized

Date: 2026-08-07

Review version: `neutral-calibration-extractor-contract-review-v1`

## Finding

The synthetic extractor contract in
`scripts/extract_neutral_calibration_synthetic.py` is not the serialization
contract emitted by the frozen PeTTa calibration source.  It accepts a flat,
invented `neutral-calibration-endpoint` atom containing `status`,
`raf-exists`, `maximal-raf-size`, `irraf-count`, and normalized persistence
fractions.  The source pinned for the completed v2 shard emits one nested
`neutral-calibration-row` atom instead.

This mismatch is outcome-independent and was established from the tracked
PeTTa source and its smoke fixture, not from raw calibration stdout.  The
current synthetic gate is useful for graph-level aggregation failure modes,
but it does not authorize a real adapter.

## Exact frozen PeTTa row shape

At source commit `4b7c6de4ec8eb71502588d2714579c7d55d4bd50`,
`neutral-ssa-run-calibration-row` emits:

```text
(neutral-calibration-row
  model neutral-crs-v1
  max-length L
  graph-seed G
  dynamics-seed D
  f-twice F2
  volume V
  molecule-count M
  reaction-count R
  maximal-raf-rule-ids (...)
  endpoints
    (neutral-ablation-endpoints
      baseline-reachability (raf-reachability-summary reachable B first-time T)
      ablated-reachability (...)
      baseline-causal (neutral-causal-endpoints raf-events E evidence-bins P integrated-nonfood N)
      ablated-causal (...)
      delta (neutral-causal-endpoint-delta raf-events DE evidence-bins DP integrated-nonfood DN)))
```

The adapter must preserve this nesting and derive only serialization-level
projections.  Structural RAF existence is `maximal-raf-rule-ids != ()` and
maximal RAF size is the length of that list.  Persistence fractions may be
formed only as `evidence-bins / 40`, because 40 is the frozen ledger bin count.
The row has no execution-status field: successful receipt publication and a
zero exit code establish completion outside the atom.

## Unavailable requested field

The emitted row contains no exhaustive irrRAF enumeration or `irraf-count`.
The real adapter must not invent it, infer it from maximal RAF size, or run a
Python RAF calculation.  Analysis must record irrRAF count as unavailable
unless a separately reviewed PeTTa-native output change is made and a new raw
batch is run.  The completed shard remains valid for the endpoints it actually
serialized; it cannot retroactively acquire this field.

## Batch validation contract

Before opening any endpoint atom, a future real adapter must fail closed unless
all of the following metadata-only conditions hold:

1. Graph seeds are exactly `1001..1032`, one v2 attempt per seed, with no
   duplicate seed or attempt selected.
2. Every attempt has one `neutral-calibration-raw-shard-v2` manifest with
   status `raw-complete-unanalysed` and equal planned/completed counts of 276.
3. Each receipt directory is a contiguous, manifest-ordered 276-row prefix;
   every receipt binds the expected row ID, query, query hash, stdout hash,
   stderr hash, zero exit code, attempt ID, source-manifest hash, source
   commit, runner hash, and runtime identity.
4. All 32 source manifests independently match the frozen ledger and contain
   the exact declared 276-row Cartesian selection for their graph seed.
   Across the batch there are exactly 8,832 unique row keys
   `(cohort,L,F2,V,G,D)`.
5. All attempts share the reviewed neutral-source hashes, runner hash, PeTTa
   commit/entrypoint hashes, SWI-Prolog identity, and absent-MORK state.

Validation must complete before any raw stdout is opened.  A failure may emit
only a metadata failure receipt.  It must not emit parsed rows or partial
summaries.

## Next gate

Replace the synthetic flat atom with fabricated examples of the exact nested
PeTTa row and add synthetic batch metadata for all 32 graph seeds.  The test
must cover missing/duplicate shards, receipt gaps, identity disagreement,
row-key disagreement, malformed nested atoms, and the unavailable irrRAF
field.  Keep the adapter inline-only.  Real raw paths and outcome parsing need
a later, separate authorization after that gate passes and all 32 complete
shards exist.

