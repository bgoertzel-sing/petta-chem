# exp07 Preregistration: Rich Shared-Pool Pivot

**Status:** Preregistered 2026-07-16 14:30 PDT; no outcome constructor or trajectory has been evaluated.
**Predecessor:** `PREREG.md` N=20 result, in which all three arms reached event-derived two-rule RAF closure in 4/4 seeds.
**Emergence claim:** none.

## Rationale

The two-rule pool made closure routine over a sustained 20-tick horizon, so it could not distinguish guidance from shared pool composition. The pivot replaces it with an eight-rule competitive pool: one latent three-rule catalytic cycle and five productive distractors. The pool, catalyst assignments, initial chamber, food schedule, cap, seeds, and horizon will be identical across arms. Only selection masses may differ.

## Frozen chemistry design

The latent cycle is:

| Rule | Rewrite | First-class catalyst |
|---|---|---|
| `rp0` | `A + B -> AB` | `CD` |
| `rp1` | `A + C -> AC` | `AB` |
| `rp2` | `C + D -> CD` | `AC` |

The initial chamber contains `A=4, B=3, C=4, D=3, AB=0, AC=0, CD=1, X=1`, and `W0`--`W4=0`. Thus the cycle is not initially event-derived RAF-positive: productive selection must first make `AB`, then `AC`, before all three rule/catalyst edges can be realized.

Five productive `X`-catalyzed competitors consume the same food: `rd0: A+B->W0`, `rd1: A+C->W1`, `rd2: B+C->W2`, `rd3: C+D->W3`, and `rd4: A+D->W4`. Food is reset to its initial `A/B/C/D` abundances immediately before ticks 11 and 19; products, catalysts, rules, and event history are preserved.

All eight `(catalyzes Molecule RuleId)` edges are explicit PeTTa facts. The detector consumes this relation and fired-event history; it must not infer catalysis from molecule names.

## Frozen ensemble

- Arms: unguided, weak Doob-h, shuffled guidance.
- Seeds: 11--18, represented as `seed-11` through `seed-18`.
- Horizon: 24 ticks, ticks 3--26 inclusive.
- Candidate cap: 8. Bounded generation must expose exactly the shared eight-candidate pool before selection.
- All arms use denominator 88 and candidate order `(rp0 rp1 rp2 rd0 rd1 rd2 rd3 rd4)`. Unguided masses are `(11 11 11 11 11 11 11 11)`, weak Doob-h masses are `(16 16 16 8 8 8 8 8)`, and shuffled-guidance masses are `(8 8 8 16 16 16 8 8)`. Thus every candidate retains nonzero mass and shuffled guidance preserves the guided weight multiset while moving its three high-mass bins onto distractors.
- The replayable draw index is `((17 * seed-number) + (31 * tick)) mod 88`; calibration must cover all synthetic draw bins 0--87 without running chamber outcomes.
- No terminal forcing and no adaptive extension.

Calibration may inspect only selector counts, pool identity, applicability, and detector controls—not RAF outcomes from the registered arms.

## Pre-run gates

All gates must pass before trajectories are constructed:

1. The exp04 known-closing positive control still returns a non-empty RAF and its empty-catalysis ablation returns zero.
2. The rich initial state is event-derived RAF-negative.
3. Every arm receives the exact same generated pool for every seed/tick; only the selection-mass record differs.
4. The eight first-class catalysis facts are complete and unique.
5. Deterministic 88-bin selection is replayable and its declared masses are realized over a complete calibration cycle.
6. Selection is connected directly to ordinary chamber ticking through the bounded cap-8 path.

Any failed gate halts the outcome run.

## Endpoints and interpretation

Primary endpoint: per-arm incidence of a rolling event-derived three-rule RAF closure, defined as all of `rp0`, `rp1`, and `rp2` occurring among the last eight productive events. Persistence is the number of consecutive ticks for which that rolling condition remains true. Secondary endpoints: first-hit tick, productivity, diversity collapse, intervention/path cost, exact replay, catalyst ablation, and rule ablation.

`emergence-claim none` can change only if weak Doob-h has RAF incidence absent from both controls and the observed closure collapses under the prespecified guiding-term/catalyst/rule ablations. All-arms-positive again means pool composition, not guidance. All-arms-null means redesign rather than horizon extension.

## Implementation boundary

This commit freezes only the PeTTa contract and protocol. It intentionally does not implement the eight-rule chamber, sampler, trajectories, or outcomes.
