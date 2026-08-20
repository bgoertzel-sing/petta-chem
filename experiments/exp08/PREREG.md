# exp08 Preregistration: Frozen 24-Permutation Paired Catalysis-Shuffle Validation

**Status:** DRAFT v11, 2026-07-24 — uncommitted, unfrozen, and unexecuted.
This draft supersedes the stale v3 bytes whose file hash began `db086aa3`.
The corrections are applied directly in the design body below: one exact
one-sided McNemar rule conditional on the discordant pairs, one conjunctive
pass gate, no registered scalar endpoint or scalar placeholder of any kind,
and no exploratory fallback in §9. There are no interpretation branches and
no route by which any result changes `emergence-claim none`. The
confidence-bound method for the paired incidence difference is explicitly
unresolved at draft time and is a §7-gate `[REPO-TBD]` item.

Sections marked `[REPO-TBD]` are not prose requests; they are executable
artifacts or validations that must be added to this repository before the §7
hash-commit gate. No result from the prior exploratory observation may be
used to fill them.

**Provenance label:** The original closure observation is exploratory. This
preregistration is confirmatory only for the frozen design below. Every
endpoint, threshold, run count, decision rule, and stopping rule must be
fixed before run 0. Anything learned after run 0 is exploratory and cannot
amend the confirmatory claim.

## 1. Question

> Is the registered closure endpoint attributable to catalytic routing — the
> specific catalyst→reaction assignment — rather than to catalytic accounting
> (how many reactions each catalyst touches) or to a lucky source ordering of
> the original seed?

The experiment answers this with one systematic perturbation sweep and one
paired null:

- **Systematic perturbation:** all 24 source-order permutations of the four
  RAF rules `dp1, dp2, dp3, dp0`. The permutation set is the entire
  prespecified systematic variation; there is no third perturbation arm.
- **Paired null:** each permutation is paired with a degree-preserving
  catalysis-shuffled null, producing 24 canonical-vs-null pairs.

## 2. Gate 0: bit-exact replay

Run 0 precedes the matrix and is not an arm. It replays the original positive
seed on the original kernel and requires bit-exact agreement with the
registered original trajectory and closure endpoint, including the full event
sequence, final chamber state, detector output, and run metadata.
`[REPO-TBD: selected original positive seed identifier, a priori selection
rule, and registered expected trace/hash artifact]`.

- **Pass:** the frozen 48-run matrix may begin.
- **Fail:** exp08 dissolves immediately. No permutation run starts, and the
  failure is reported as a replay/harness failure rather than as evidence
  about catalytic routing.

## 3. Frozen primary matrix

- **Kernel:** committed repository state `11d9598`, using the dual-bootstrap
  PeTTa chemistry already present in `src/chem_exp07.metta` at that state.
- **Rule set:** six pathway rules and six food-competing distractors:

  | Rule | Reaction | Canonical catalyst | Role |
  |---|---|---|---|
  | `db0` | `A + B -> AB` | `X` | non-RAF bootstrap |
  | `db1` | `C + D -> CD` | `AB` | non-RAF bootstrap |
  | `dp1` | `A + C -> AC` | `CD` | RAF rule 1 |
  | `dp2` | `B + D -> BD` | `AC` | RAF rule 2 |
  | `dp3` | `C + E -> CE` | `BD` | RAF rule 3 |
  | `dp0` | `C + D -> CD` | `CE` | RAF rule 4 |
  | `dd0` | `A + D -> W0` | `X` | distractor |
  | `dd1` | `B + C -> W1` | `X` | distractor |
  | `dd2` | `A + E -> W2` | `X` | distractor |
  | `dd3` | `B + E -> W3` | `X` | distractor |
  | `dd4` | `A + C -> W4` | `X` | distractor |
  | `dd5` | `D + E -> W5` | `X` | distractor |

- **Initial chamber:** `A=3, B=2, C=3, D=2, E=2, X=1`; all pathway products
  and distractor products start at zero. Food is reset to those fixed
  abundances before ticks 11, 19, and 27, preserving products and event
  history. Horizon is ticks 3–34 inclusive.
- **Registered closure pathway:** `db0 → db1 → dp1 → dp2 → dp3 → dp0`.
- **Permutation embedding:** a primary-matrix permutation permutes exactly
  the four RAF rule records `dp1, dp2, dp3, dp0` in the twelve-rule chamber
  source. Rule identity, reaction structure, catalyst assignment, candidate
  generation, and selection remain identity-addressed; source-list position
  alone cannot change the generated cap or selected rule. `[REPO-TBD:
  executable permutation constructor and fixture validation for all 24
  embedded source orders]`.
- **Permutation enumeration:** all `4! = 24` permutations of
  `(dp0, dp1, dp2, dp3)` in lexicographic order, exactly once each. This is
  the enumeration used by `SCHEDULE.csv`; the registered pathway identity
  remains `(dp1, dp2, dp3, dp0)`.
- **Selector draws and cap:** a single shared selector/random-stream
  specification and execution cap applies to both arms and is frozen
  identically across each canonical/null pair. Neither arm has its own
  selector draws, and selector randomness is distinct from the
  deterministic degree-preserving derangement used to construct the null
  operator in §4. The exact specification remains implementation-dependent:
  `[REPO-TBD: executable shared selector/random-stream and cap
  implementation, seed map, and paired-arm equality fixtures materialized
  before the §7 hash-commit gate]`. No interpolation from the known
  pathway, kernel identity, or any other already-present artifact is used
  to fill it. Canonical and null arms in a pair use identical seed, tick
  schedule, candidate-pool construction, selector random stream, execution
  cap, and draw outcomes; only the catalysis relation differs.
- **Pairing:** every permutation yields one canonical run and one matched
  null run under the null operator in §4.
- **Run count:** 24 permutations × 2 arms = **48 primary runs**, plus run 0.
- **Run order:** run 0 first. Then the 24 pairs execute in `SCHEDULE.csv`
  order with paired adjacency. Within-pair arm order is deterministic and
  balanced: odd pair indices run canonical-first; even pair indices run
  null-first, yielding exactly 12 canonical-first and 12 null-first pairs.
  No pair uses a fixed canonical-then-null order. The lexicographic pair
  enumeration above is frozen prior to this arm-order assignment, and the
  resulting 48-run schedule is committed verbatim at the §7 gate. Every run
  starts from a fresh, independent harness state.
- **Budget:** all runs use the same frozen tick budget and schedule. No
  adaptive extension, early stopping for efficacy, seed enrichment, or
  replacement of a completed run.

## 4. Degree-preserving catalysis-shuffled null

For each permutation, the null run uses the same reaction chemistry, initial
chamber, schedule, horizon, detector, source ordering, candidate-pool
construction, selector random stream, execution cap, and draw outcomes as the
canonical run, but replaces the four RAF catalyst→reaction edges with the
fixed degree-preserving derangement:

| Rule | Canonical edge | Null edge |
|---|---|---|
| `dp1` | `CD → dp1` | `CE → dp1` |
| `dp2` | `AC → dp2` | `CD → dp2` |
| `dp3` | `BD → dp3` | `AC → dp3` |
| `dp0` | `CE → dp0` | `BD → dp0` |

The operator is deterministic and has no random seed. It rotates the four RAF
catalyst assignments one step backward along the registered RAF rule order
`(dp1, dp2, dp3, dp0)`. All non-RAF catalysis facts are unchanged.

**Conserved quantities:**

1. the reaction inventory;
2. the reactant/product multiset of every reaction;
3. every reaction's arity;
4. every catalyst's catalytic degree;
5. the total catalysis-edge count.

**Destroyed quantity:** the specific catalyst→reaction assignment — which
reactions each catalyst activates — thereby changing reachable catalytic
pathways.

**Interpretation caveat:** the null does not guarantee equal realized
productive-collision rates across trajectories. Rejecting it supports
routing-dependence of closure; it does not establish equality of collision
rates, and it bounds what a positive gate can assert.

`[REPO-TBD: executable null operator plus positive/negative fixtures proving
the conserved and destroyed quantities above]`.

## 5. Endpoint

- **Primary endpoint:** binary closure incidence per run — exact four-rule
  RAF occurrence (`dp1`, `dp2`, `dp3`, and `dp0`) within ticks 3–34 under the
  rolling last-12-productive-event detector. The registered pathway identity
  is `db0 → db1 → dp1 → dp2 → dp3 → dp0`; `db0` and `db1` are bootstrap
  context, not part of the four-rule RAF detector.
- **Detector artifact:** `[REPO-TBD: exact serialized detector predicate,
  positive fixture, and negative fixture]`.

## 6. Primary decision rule

For pair `i = 1,...,24`, let `y_i^C` be canonical closure incidence and
`y_i^N` matched-null closure incidence. Define
`d_i = y_i^C - y_i^N ∈ {-1, 0, 1}`, with discordant counts:

- `b = #{i: d_i = +1}` (canonical closes, null does not);
- `c = #{i: d_i = -1}` (null closes, canonical does not);
- `m = b + c`.

The primary test is the exact **one-sided** paired McNemar test of no
canonical-minus-null effect. It conditions on the `m` discordant pairs;
concordant pairs contribute nothing. The exact p-value is

`p = P(X ≥ b)` for `X ~ Binomial(m, 1/2)`,

equivalently the binomial tail over the `2^m` directional assignments of the
discordant pairs only. It is not an enumeration over all pair flips, not a
Monte Carlo approximation, and not a fixed discordant-count heuristic.

- **Alpha:** `α = 0.05`, one-sided in the canonical>null direction.
- **Positive statistical criterion:** both
  1. exact one-sided paired McNemar `p < 0.05`; and
  2. the lower one-sided 95% confidence bound for the canonical-minus-null
     paired incidence difference, under the method resolved per the
     `[REPO-TBD]` below, is strictly greater than zero.

The confidence-bound method is explicitly unresolved at draft time. The
registered criterion requires a lower one-sided 95% confidence bound for
the canonical-minus-null paired incidence difference that is strictly
greater than zero, computed by a valid published method for paired binary
incidence differences. No `k/24` construction, invented grid inversion,
threshold ratio, or ad hoc count rule is used. `[REPO-TBD: selection of a
valid paired-incidence confidence-bound method, its implementation, and
fixture validation, all committed before the §7 hash-commit gate]`.

## 7. Hash-commit gate

Before run 0, this document and all executable frozen artifacts must be
committed together:

- this preregistration;
- the exact kernel identity (`11d9598`);
- the ordered list of all 24 permutations of `(dp1, dp2, dp3, dp0)`;
- the executable permutation constructor and fixture validation;
- the exact deterministic null operator and fixture validation;
- the detector and endpoint definitions with positive/negative fixtures;
- the selected run-0 positive seed, selection rule, and expected trace/hash;
- the materialized 48-entry run schedule and exp08 seed map, committed
  verbatim;
- the resolved paired-incidence confidence-bound method, its
  implementation, and fixture validation (method selection explicitly
  unresolved at draft time);
- the executable full four-edge RAF-catalyst deletion implementation and
  replay fixtures;
- the harness version.

**Preregistration commit hash:** `[TBD at commit time]`

No registered run may begin before this hash exists. Any post-hash edit to a
frozen artifact voids the confirmatory claim unless committed as an explicit
amendment before any affected run begins.

## 8. Conjunctive pass gate

After Gate 0 passes, exp08 has exactly one confirmatory decision rule: a
single conjunctive pass gate over the frozen primary matrix. There is no
hierarchy, branch table, fallback route, rescue analysis, or secondary path
to a positive claim.

**Pass iff all of the following hold:**

1. Gate 0 passes bit-exact replay;
2. the §6 positive statistical criterion holds against the matched nulls;
3. the §9 prespecified full four-edge RAF-catalyst deletion replay abolishes
   closure in every closure-positive canonical trace; and
4. every exact replay and frozen execution requirement passes.

**Fail iff any conjunct fails.** The failure record names the failed
conjunct(s) and the corresponding frozen artifact or replay output. That
record is descriptive only; it is not an interpretation branch and cannot be
converted into a pass by annotation, scalar analysis, secondary endpoint, or
exploratory follow-up.

`emergence-claim` remains `none` under every outcome, including pass. No
branch, annotation, annotation-like failure record, secondary analysis,
scalar summary, or exploratory result may alter it.

## 9. Mechanistic deletion

**Prespecified full RAF-catalyst-set deletion replay.** After the canonical
positives, replay each closure-positive canonical trace with the complete
four-edge canonical RAF catalyst assignment deleted:

- remove `CD → dp1`;
- remove `AC → dp2`;
- remove `BD → dp3`;
- remove `CE → dp0`.

Closure must disappear in every such replay. If closure persists in any
replayed trace, the §8 pass gate fails regardless of the §6 result.
`[REPO-TBD: executable four-edge deletion implementation bound to the kernel
rule/catalyst identifiers, with replay fixtures]`.

## 10. Failure and stopping rule

Any failure of Gate 0, the §6 statistical criterion, the §9 deletion replay,
exact replay, or a frozen execution requirement closes exp08 as failed or
negative under §8. On such failure:

- close exp08;
- pause PeTTa-Chem pending explicit human review;
- do not extend the horizon;
- do not enrich or replace seeds;
- do not add permutations or runs;
- do not redefine endpoints;
- do not reinterpret exploratory follow-ups as confirmatory evidence.

## 11. Out of scope

CAROM guardrail enforcement — approval registry, provider-side kill, and
accretion tripwire — is separately tasked infrastructure work. It is not part
of exp08's experimental design and does not alter the scientific decision
rules above, beyond ordinary fail-closed execution requirements.
