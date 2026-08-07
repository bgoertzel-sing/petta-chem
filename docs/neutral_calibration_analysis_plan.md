# Neutral calibration outcome-analysis plan

Status: frozen design; outcome inspection not authorized

Date: 2026-08-07

Plan version: `neutral-calibration-analysis-v1`

## Purpose and boundary

This plan fixes the analysis of the `neutral-crs-v1` calibration before any
raw endpoint output is opened. It does not authorize parsing the completed
`graph_seed=1001` shard. Parsing requires a separately reviewed, synthetic-
tested extractor and a complete, receipt-validated raw shard for every graph
seed included in the declared analysis batch. Partial-seed or partial-`f`
results must not be inspected, plotted, or used to change this plan.

The unresolved untracked `experiments/exp08/`,
`experiments/scratch_cat.metta`, and `src/chem_catalysis.metta` remain outside
the analysis. Python may validate and aggregate serialized PeTTa outputs; it
must not recompute chemistry, RAF membership, dynamics, or ablations.

## Analysis populations and units

- Primary transition population: `L=5`, `V=100`, graph seeds 1001--1032,
  `f in {0, 0.5, ..., 8.0}`, and dynamics seeds 2001--2004.
- Finite-size population: `L in {4,5,6}`, `V=100`, graph seeds 1001--1032,
  and integer `f in {0,...,8}`.
- Population-scaling population: `L=5`, `V in {50,100,200}`, graph seeds
  1001--1032, integer `f in {0,...,8}`, and all four dynamics seeds.
- The independent unit for structural endpoints is the sampled graph. The
  independent unit for dynamic endpoints is also the graph; the four dynamics
  seeds are repeated measurements and are summarized within graph before
  uncertainty is computed across graphs.

No dynamics-seed trajectory may be presented as an independent graph draw.
The primary transition population is confirmatory; finite-size and volume
populations are prespecified controls.

## Frozen row validation and extraction

Before reading endpoint atoms, the extractor must reject the batch unless:

1. every shard has a `raw-complete-unanalysed` v2 manifest, a contiguous
   receipt set, and matching query/stdout/stderr hashes;
2. all source, manifest, model, PeTTa, SWI-Prolog, and absent-MORK identities
   match the reviewed identities;
3. row keys are unique and exactly cover the declared Cartesian products;
4. each row contains exactly one canonical endpoint record with the expected
   `(L,f,V,graph_seed,dynamics_seed,arm)` identity; and
5. all numeric values are finite, count fields are nonnegative integers,
   fractions lie in `[0,1]`, and declared logical implications hold.

The extractor must first pass synthetic fixtures covering duplicate, missing,
mis-keyed, malformed, censored, and hash-mismatched rows. On a real-data
failure it writes only a failure receipt naming row identities and validation
classes; it must not emit partial summaries.

## Endpoints and estimands

Endpoints retain the definitions in `neutral_crs_oracle_protocol.md` and are
reported separately.

1. **Structural:** per `(L,f,graph_seed)`, RAF existence, maximal-RAF size,
   and available irrRAF count. The primary estimand is graph-level RAF
   incidence at each `f`.
2. **Reachable:** within graph, the fraction of dynamics seeds reaching the
   selected maximal RAF before `T`; time-to-reach is right-censored at `T`.
   Graph-level reachability fraction is the primary summary.
3. **Active/persistent:** within graph, mean raw persistence-bin fraction and
   fraction of dynamics seeds meeting the frozen 32/40 threshold. Catalyzed
   RAF event count is reported descriptively.
4. **Causal/productive:** for each dynamics seed, matched full-minus-catalysis-
   deletion differences in post-burn-in RAF events, time-integrated nonfood
   count, and persistence fraction. Differences are averaged within graph;
   the graph-level mean paired difference is the estimand.

Graphs without a structural RAF remain in structural denominators. Their
later endpoints are `not-applicable`, not zero. Failed or incomplete runs are
never silently converted to negative outcomes.

## Uncertainty, transition summary, and multiplicity

- At each control point, graph-level binary incidence receives a two-sided
  95% Wilson interval. Continuous graph summaries receive a percentile 95%
  bootstrap interval from 10,000 resamples of the 32 graph seeds, using fixed
  analysis seed `73020260727`.
- The primary transition is descriptive: report the incidence curve and
  define `f50` by monotone isotonic regression as the smallest interpolated
  `f` at which fitted structural incidence reaches 0.5. If it never crosses,
  report `f50` as left- or right-censored. Do not select a threshold after
  viewing the curve.
- Finite-size and volume results are reported as complete prespecified panels,
  not searched for a favorable subset. No single-point null-hypothesis test is
  a success gate; effect estimates and intervals are primary.
- Any exploratory model, alternate threshold, excluded graph, or endpoint
  transformation is labeled exploratory and cannot replace the frozen
  analysis.

## Required artifacts and interpretation rule

One successful analysis writes an immutable manifest, validation report,
canonical row table, graph-level table, transition table, control tables, and
machine-readable exclusions/censoring table. Every artifact records input
manifest hashes, extractor commit/hash, plan version, and analysis seed.

Claims use the strict ladder `structural -> reachable -> active/persistent ->
causal/productive`. Passing an earlier endpoint does not imply a later one.
The first complete batch is reported regardless of whether it shows a
transition or emergence. Guidance, Doob controls, candidate/source expansion,
and exp08 remain deferred.

## Next implementation gate

Implement only the outcome extractor and synthetic validation suite against
fabricated PeTTa-shaped records. Commit and review those tests before granting
the extractor access to any real raw stdout/stderr. Real parsing and scientific
interpretation require a distinct authorization after the declared batch is
complete.
