# Neutral binary-polymer CRS and exhaustive RAF-oracle protocol

Status: frozen design, no calibration outcomes inspected
Date: 2026-07-27
Protocol version: `neutral-crs-v1`

## Scope and stop rule

This document freezes the next scientific gate after exp00--exp07. It does not
authorize a sampled emergence run. Implementation must stop after the
small-system oracle gate until every required fixture and generated tiny
system agrees exactly with exhaustive truth.

The unresolved untracked `experiments/exp08/`,
`experiments/scratch_cat.metta`, and `src/chem_catalysis.metta` are not inputs
to this protocol and must not be executed or changed. No pathway, terminal
state, target RAF, guidance score, candidate cap, or source-list milestone may
affect system generation or event selection.

Chemistry generation, catalysis sampling, propensities, event selection,
state transitions, event records, and PeTTa RAF detection must be PeTTa-native.
Python is limited to the independent exhaustive oracle, command orchestration,
comparison, and artifact serialization.

## 1. Neutral reaction-system distribution

### 1.1 Molecules and food

- Alphabet: `A = {0, 1}`.
- Molecules: every nonempty binary string of length at most `L`.
- Food set: `F = {0, 1, 00, 01, 10, 11}` (all molecules of length at most
  two).
- Primary finite system: `L = 5`.
- Finite-size check after the primary gate: `L in {4, 5, 6}`, with the same
  model and control-parameter definition.

Molecule identity is the literal binary string. No name-derived affinity or
pathway annotation exists.

### 1.2 Reactions

For every ordered pair of polymers `(x, y)` with `len(x) + len(y) <= L`,
include the directed ligation

`lig:x:y: x + y -> xy`.

For every polymer `z` and every nontrivial split `z = xy`, include the
directed cleavage

`cleave:z:i: z -> x + y`,

where `i = len(x)`. Ligation and cleavage are distinct reactions. Ordered
ligation is intentional: `x+y` and `y+x` have different products when
`x != y`. Reaction IDs are canonical and lexicographically ordered by
`(kind, reactants, products)`.

### 1.3 Catalysis distribution and control parameter

Each molecule-reaction pair `(m, r)` is an independent Bernoulli edge:

`C(m, r) ~ Bernoulli(p),  p = min(1, f / |R_L|)`.

Here `f` is the expected number of reactions catalyzed by one molecule. It is
the sole primary transition-control parameter. The distribution is sampled
without conditioning on RAF presence, reachability, products, molecule
length, or any desired pathway.

Primary structural sweep:

`f in {0, 0.5, 1.0, ..., 8.0}` at `L = 5`.

Finite-size check:

`L in {4, 5, 6}` and `f in {0, 1, 2, ..., 8}`.

No graph may be rejected or resampled because of its RAF status.

## 2. PeTTa-native stochastic resource dynamics

The dynamics are a continuous-time direct stochastic simulation algorithm
(SSA). PeTTa enumerates all currently enabled influx, dilution, ligation, and
cleavage events, computes their propensities, draws the next waiting time and
event from the seeded random stream, applies the exact integer state update,
and emits the event atom.

### 2.1 State and fixed constants

- Chamber volume: `V = 100` in the primary calibration.
- Initial counts: `n_m(0) = 20` for `m in F`, and zero otherwise.
- Food influx: each `m in F` has propensity `delta * 20`.
- Dilution/decay: every molecule instance has propensity `delta * n_m`.
- `delta = 0.01`.
- Ligation rate constant: `k_lig = 1`.
- Cleavage rate constant: `k_cleave = 1`.
- Basal multiplier: `epsilon = 1e-4`.
- Catalytic multiplier: `eta = 10`.

For reaction `r`, let

`g_r(n) = epsilon + eta * sum(C(m,r) * n_m / V over m)`.

The uncatalyzed mass-action terms are:

- distinct-reactant ligation: `h_r(n) = n_x * n_y / V`;
- identical-reactant ligation: `h_r(n) = n_x * (n_x - 1) / (2V)`;
- cleavage: `h_r(n) = n_z`.

The reaction propensity is `a_r(n) = k_kind * h_r(n) * g_r(n)`. A reaction
with insufficient reactants has zero propensity. Influx and dilution are not
catalyzed. There is no food reset, candidate cap, pathway-aware weighting, or
terminal target.

### 2.2 Time, volume control, and replay

- Stop at simulated time `T = 500` or `1,000,000` events, whichever occurs
  first.
- Burn-in boundary: `T_burn = 100`.
- Persistence bins: 40 half-open bins of width 10 over `[100, 500)`.
- Population-scaling control, run only after oracle passage:
  `V in {50, 100, 200}`, with initial food counts and food influx scaled
  linearly with `V`; bimolecular propensities retain the `1/V` factor.

The PeTTa manifest must record model version, `L`, `f`, `p`, `V`, all rate
constants, graph seed, dynamics seed, runtime commit, and source commit.
Replaying the same manifest must reproduce the exact ordered event stream and
final counts.

## 3. Frozen seeds and outcome embargo

Graph seeds for calibration are integers `1001` through `1032`, inclusive.
Dynamics seeds are `2001`, `2002`, `2003`, and `2004`. Every declared
`(L, f, graph_seed)` graph is paired with all four dynamics seeds. Graph and
dynamics random streams are separate.

Implementation calibration may inspect only:

- molecule, reaction, and catalysis-edge counts;
- canonical ordering and hashes;
- propensity arithmetic on hand-computed states;
- RNG replay equality;
- mass-balance and nonnegative-count invariants; and
- oracle comparison results on the tiny gate.

No structural incidence, transition curve, reachability, persistence,
productivity, or ablation outcome from the calibration matrix may be queried
or inspected before the oracle gate in section 5 passes and its manifest is
committed.

## 4. Structural RAF definition

For reaction subset `R'`, define `cl_F(R')` by starting from `F` and repeatedly
adding every product of a reaction in `R'` whose reactants are already in the
closure.

A nonempty `R'` is a RAF exactly when:

1. every reactant of every reaction in `R'` is in `cl_F(R')`; and
2. for every reaction `r in R'`, at least one catalyst `m` with `C(m,r)` is in
   `cl_F(R')`.

Food molecules may therefore be catalysts. A catalyst need not also occur in
the product set of `R'`. This is the standard closure condition and is a
deliberate semantic gate: the legacy exp04 host reference additionally
requires the catalyst to be a generated product and must not be treated as
the neutral-model oracle.

The maximal RAF is the union of all RAF subsets (or empty if none exists).
For tiny systems the oracle also reports every RAF subset and every
inclusion-minimal irreducible RAF (irrRAF). A greedy, order-dependent “core”
is not exhaustive truth and is not an oracle endpoint.

## 5. Independent exhaustive oracle gate

### 5.1 Independence boundary

The Python oracle receives only a serialized reaction system: food molecules,
reaction IDs with complete reactant and product lists, and explicit binary
catalysis edges. It must not import PeTTa detector code, parse molecule names
to infer chemistry, call the legacy exp04 pruning functions, or implement
dynamics.

For at most 12 reactions it enumerates all `2^|R| - 1` nonempty subsets,
computes closure directly, applies the two RAF predicates above, and derives
the complete RAF set, unique maximal RAF, and all irrRAFs.

### 5.2 Required hand fixtures

The gate must include separate named fixtures for:

1. **Food closure chain:** a multi-step ligation whose later reactants enter
   closure only through earlier reactions.
2. **Multiple products and catalysts:** at least one cleavage with two
   products and a reaction with two catalyst edges; existential catalyst
   semantics and complete product insertion must agree.
3. **Food catalyst:** a food molecule catalyzes a food-generated reaction;
   this must pass without a generated-product requirement.
4. **Degenerate self-catalysis:** a food-enabled reaction produces its own
   initially absent catalyst; closure makes the singleton a RAF.
5. **Unreachable cycle:** catalysts and reactants form a static cycle outside
   food closure; the subset must be rejected.
6. **Edge-addition monotonicity:** for `C subset C+`, every RAF under `C`
   remains a RAF under `C+`, and maximal-RAF size cannot decrease.
7. **Deletion sensitivity:** deleting a critical catalysis edge and,
   separately, a critical reaction destroys the declared positive RAF.

Fixtures must include both positive and negative subsets and at least one
system with more than one irrRAF.

### 5.3 Generated tiny systems

After hand fixtures pass, generate 100 systems at `L = 3`, using graph seeds
`1` through `100`, with exactly 8 reactions selected by a seed-determined
uniform sample from canonical `R_3`. Test catalysis values
`f in {0, 1, 2, 4}`. Selection and catalysis sampling occur in PeTTa; the
oracle only consumes the resulting serialized facts. Every subset truth value
and the derived maximal RAF/irrRAF sets must match.

### 5.4 PeTTa/oracle interface

PeTTa input facts use these logical fields:

```text
(raf-system SYSTEM-ID model neutral-crs-v1 food (MOLECULES...))
(raf-reaction SYSTEM-ID RULE-ID reactants (MOLECULES...)
                                  products (MOLECULES...))
(raf-catalysis SYSTEM-ID CATALYST RULE-ID)
```

PeTTa output uses:

```text
(raf-result SYSTEM-ID subset (RULE-IDS...) is-raf BOOL)
(raf-maximal SYSTEM-ID rules (RULE-IDS...))
(raf-irredundant SYSTEM-ID rules (RULE-IDS...))
```

Lists are canonical lexicographic lists with no duplicates. The harness
serializes the same logical data to JSON for Python, invokes both
implementations independently, and compares exact sets rather than output
order or proof multiplicity.

### 5.5 Pass/fail rule

The oracle gate passes only if:

- all seven required fixture classes pass;
- all generated tiny-system subset classifications match;
- maximal RAF and complete irrRAF sets match exactly;
- permuting reaction and catalysis-fact order changes no logical output;
- duplicate PeTTa proofs are collapsed by canonical set comparison; and
- adding edges and applying registered deletions satisfy their invariants.

Any mismatch freezes calibration. The mismatch, minimized fixture, PeTTa
output, oracle output, and source/runtime hashes must be committed before a
semantic fix is attempted. Thresholds, fixtures, and the RAF definition may
not be adapted to make an observed mismatch pass.

## 6. Post-oracle calibration endpoints

These endpoints are frozen now but are not authorized for inspection until
section 5 passes:

1. **Structural RAF existence:** maximal RAF is nonempty; also report maximal
   RAF size and irrRAF count where exhaustive enumeration is feasible.
2. **Dynamic reachability:** before `T`, every molecule in the selected
   maximal RAF closure has simultaneously had positive abundance and every
   RAF reaction has fired at least once. Report first time, or censored.
3. **Active/persistent RAF:** after burn-in, report RAF-catalyzed event count
   and the fraction of persistence bins containing both positive abundance
   for every RAF reactant/catalyst and at least one RAF reaction event.
   “Persistent” means at least 32 of 40 bins; the raw fraction is primary.
4. **Causal/productive effect:** replay a matched dynamics seed after deleting
   all catalysis edges into the selected maximal RAF. Report paired changes in
   post-burn-in RAF reaction events, time-integrated nonfood molecule count,
   and persistence fraction. Deleting rules or molecules is a separate
   sensitivity analysis, not the catalysis ablation.

Structural, reachable, active/persistent, and causal/productive labels must be
reported separately. No result satisfying only an earlier endpoint may be
described with a later label. Estimates must report graph-level incidence and
95% cluster-bootstrap intervals over graph seeds; four dynamics replicates
are nested observations, not 128 independent graphs.

## 7. Required artifacts and implementation order

1. Implement and test canonical neutral CRS facts and the section 5 interface
   in new, reviewed files.
2. Implement the exhaustive Python oracle without importing chemistry code.
3. Add the seven hand-fixture families and exact expected truth.
4. Run and commit the 100 generated tiny-system comparison manifest.
5. Only after that commit, implement the neutral PeTTa SSA and its arithmetic,
   replay, and resource-invariant tests.
6. Freeze a calibration run ledger containing the exact matrix above.
7. Run the sampled matrix once, without adaptive extension.

Guidance, Doob transforms, exp08, pathway construction, and new generator
arity/source-list work remain deferred throughout these steps.
