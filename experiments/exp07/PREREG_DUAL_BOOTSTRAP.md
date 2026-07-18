# exp07 Preregistration: Dual-Bootstrap, Order-Invariant Bounded Pool

**Status:** Design only; no seed support, generator, selector, trajectory, or
outcome has been implemented or evaluated.
**Predecessor:** `PREREG_ORDERED_REPLICATION.md`, closed as two negative gates.
**Claim boundary:** bounded guided causal RAF uplift only; spontaneous
emergence claim none.

## Rationale fixed before outcomes

The exact-form cohort failed its primary treatment-control threshold, while
the order/hash cohort had excessive unguided RAF incidence and failed its
guiding-term-removal gate. The successor therefore makes two prespecified
changes rather than extending either completed cohort:

1. replace the single bootstrap and three-rule RAF with a dual bootstrap and
   four-rule RAF, increasing the ordered frontier from four to six steps; and
2. generate an order-invariant cap-8 pool from a twelve-rule source by rule
   identity, so source-list position cannot decide which rules survive the cap.

These changes are prospective. Neither predecessor cohort is reinterpreted.

## Frozen chemistry

The twelve source rules are six pathway rules and six food-competing
distractors. All catalysis relations are explicit `(catalyzes Molecule RuleId)`
atoms; names do not imply catalysis.

| Rule | Reaction | Catalyst | Role |
|---|---|---|---|
| `db0` | `A + B -> AB` | `X` | non-RAF bootstrap 1 |
| `db1` | `C + D -> CD` | `AB` | non-RAF bootstrap 2 |
| `dp1` | `A + C -> AC` | `CD` | RAF frontier 1 |
| `dp2` | `B + D -> BD` | `AC` | RAF frontier 2 |
| `dp3` | `C + E -> CE` | `BD` | RAF frontier 3 |
| `dp0` | `C + D -> CD` | `CE` | RAF frontier 4 |
| `dd0` | `A + D -> W0` | `X` | distractor |
| `dd1` | `B + C -> W1` | `X` | distractor |
| `dd2` | `A + E -> W2` | `X` | distractor |
| `dd3` | `B + E -> W3` | `X` | distractor |
| `dd4` | `A + C -> W4` | `X` | distractor |
| `dd5` | `D + E -> W5` | `X` | distractor |

Initial food abundances are `A=3, B=2, C=3, D=2, E=2`; `X=1`; and
`AB=CD=AC=BD=CE=W0=...=W5=0`. Food is reset to those fixed abundances before
ticks 11, 19, and 27 while products and event history are preserved. The RAF
detector considers exactly `dp1/dp2/dp3/dp0`; `db0/db1` are excluded.

## Bounded candidate generation

At every tick, PeTTa must generate from the full twelve-rule chamber source.
The bounded cap-8 identity set contains all six pathway rules plus exactly one
of `(dd0 dd1)`, `(dd2 dd3)`, or `(dd4 dd5)`, selected by
`(seed-number + tick) mod 3`. The same identity set must result from the
canonical source order and the fixed permutation
`(dd4 dp2 db0 dd1 dp0 dd5 db1 dp3 dd2 dp1 dd0 dd3)`.
The matched distractor used by both guided policies is the first identity in
the selected pair (`dd0`, `dd2`, or `dd4`); its partner retains mass 12.

All arms receive the identical generated cap at a seed/tick. Selection is by
rule identity and the selected candidate is handed directly to ordinary
chamber ticking. No host code may generate, score, select, or fire chemistry.

## Frozen ensemble and selector

- Seeds: 201--232, fixed and disjoint from all predecessor seeds.
- Ticks: 3--34 inclusive; no extension.
- Draw index: `((71 * seed-number) + (67 * tick) + 19) mod 96`.
- Unguided: mass 12 on each of the eight exposed identities.
- Weak Doob-h: mass 20 on the first absent identity in
  `db0 -> db1 -> dp1 -> dp2 -> dp3 -> dp0`, mass 4 on the matched exposed
  distractor, and mass 12 on each other identity.
- Shuffled-frontier: reverse the frontier and matched-distractor masses.

Both guided arms shift eight mass units per draw relative to unguided. If the
six-step frontier is complete, the frontier identity is `dp0`; this sustains
the cycle without terminal forcing.

## Fail-closed implementation gates

Before constructing a seed-201--232 trajectory:

1. the exp00 and exp07 smoke suites and detector-invariance control pass;
2. the twelve-rule source and all explicit catalysis facts are queryable;
3. initial applicability is `db0` plus the applicable distractors, and the
   initial event history is RAF-negative;
4. canonical and permuted source orders generate the same cap-8 identity set
   for all three distractor phases;
5. complete 96-bin calibration realizes the declared masses in every frontier
   and distractor phase, with matched guided cost;
6. all arms have identical candidate pools at every tested seed/tick; and
7. a nonregistered synthetic seed connects generated cap, identity-addressed
   selection, and ordinary chamber ticking directly.

Any failure stops the run. Gate implementation may not inspect a registered
trajectory or endpoint.

## Frozen endpoints and decision rule

The primary endpoint is rolling last-twelve-productive-event four-rule RAF
incidence by arm. Secondary endpoints are first-hit tick, longest consecutive
positive persistence, productive-event count, terminal rule diversity, exact
replay, and matched intervention cost.

The result supports bounded guided causal RAF uplift only if weak Doob-h has
at least ten more RAF-positive seeds than each control, all 96 trajectories
replay, guided cost matches, and each of guiding-term, either bootstrap,
all-cycle-catalyst, and individual `dp1/dp2/dp3/dp0` ablations leaves at most
four positives. Otherwise the registered result is negative. No seed, tick,
pool, threshold, or endpoint may be extended or replaced after outcomes are
visible.
