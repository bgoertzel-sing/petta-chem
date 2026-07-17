# exp07 Preregistration: Ordered Bootstrap Frontier

**Status:** Complete 2026-07-17 16:30 PDT. The frozen primary matrix was
executed once at 14:30 after all fail-closed gates passed; a post-run audit
found that its reporting function called the historical rich-pool detector.
The corrected ordered `op1/op2/op0` detector, secondary endpoints, and all
prespecified causal ablations are now smoke-tested without changing the frozen
seeds, horizon, draws, pool, or schedule.
**Predecessor:** `PREREG_RICH_POOL.md`, whose frozen matrix reached rolling
three-rule RAF closure in 5/8 unguided, 7/8 weak-Doob-h, and 3/8 shuffled
trajectories.
**Result boundary:** guided causal RAF uplift supported; spontaneous emergence
claim none.

## Why the rich-pool result is a null

The rich-pool catalyst and single-rule ablations establish that its
`rp0/rp1/rp2` cycle is structurally necessary: removing all three latent
catalyst edges, or any one cycle rule, reduces RAF incidence to 0/8 in every
arm. Guidance is not necessary, however, because unguided and shuffled
controls remain RAF-positive. The initial `CD=1` catalyst made `rp0`
immediately available, so the shared planted pool was already a productive
bootstrap mechanism. This is pool-composition evidence, not guidance-caused
emergence, and the frozen seeds and horizon must not be extended.

## Frozen chemistry design

The next shared pool has eight rules in this exact order:

| Rule | Rewrite | First-class catalyst | Role |
|---|---|---|---|
| `ob0` | `A + B -> AB` | `X` | non-RAF bootstrap |
| `op1` | `A + C -> AC` | `AB` | frontier step 1 |
| `op2` | `C + D -> CD` | `AC` | frontier step 2 |
| `op0` | `A + B -> AB` | `CD` | closes/maintains RAF |
| `od0` | `A + C -> W0` | `X` | distractor |
| `od1` | `B + C -> W1` | `X` | distractor |
| `od2` | `C + D -> W2` | `X` | distractor |
| `od3` | `A + D -> W3` | `X` | distractor |

The initial chamber is `A=4, B=3, C=4, D=3, AB=0, AC=0, CD=0, X=1`,
with `W0`--`W3=0`. Thus none of `op1/op2/op0` is initially applicable and
the event-derived RAF is negative. `ob0` is explicitly excluded from the RAF:
it can create the first `AB`, after which the only productive catalytic
frontier is `op1`, then `op2`, then `op0`. The primary RAF condition is that
`op1`, `op2`, and `op0` all occur in the last eight productive events.

Food is reset to the stated `A/B/C/D` abundances immediately before ticks 11
and 19. Products, catalysts, rules, and event history are preserved. The
bootstrap rule and distractors remain in the diversity and productivity
endpoints but not in the RAF membership test.

## Frozen ensemble and selectors

- Arms: unguided, state-aware weak Doob-h, shuffled-frontier guidance.
- Held-out seeds: 19--26. No seed from the rich-pool design is reused.
- Horizon: ticks 3--26 inclusive (24 ticks), with no adaptive extension.
- Candidate cap: 8; bounded PeTTa generation must expose the exact shared
  ordered pool before selection.
- Denominator: 96. Unguided mass is `(12 12 12 12 12 12 12 12)`.
- The state-aware frontier is `ob0` while `AB=0`, `op1` while `AC=0`, `op2`
  while `CD=0`, and `op0` thereafter. Weak Doob-h moves eight mass units from
  that phase's paired distractor to the frontier, giving one mass 20, one mass
  4, and six masses 12.
- Shuffled-frontier guidance swaps those high/low positions: the paired
  distractor receives mass 20 and the true frontier receives mass 4. It has
  the exact same per-draw mass multiset and total-variation cost as weak
  Doob-h.
- Phase pairs are `(ob0,od0)`, `(op1,od1)`, `(op2,od2)`, and `(op0,od3)`.
- The draw index is `((17 * seed-number) + (31 * tick)) mod 96`.

All selector weights are computed from the current PeTTa chamber state before
the draw. The selector may read only whether `AB`, `AC`, and `CD` are present;
it may not read future draws, terminal status, or detector output.

## Fail-closed pre-run gates

Before constructing any registered trajectory:

1. The exp04 positive/no-catalysis detector controls still pass.
2. The ordered initial event history is RAF-negative and `op1/op2/op0` are
   inapplicable while `ob0` is applicable.
3. All arms receive the identical eight-candidate pool at every state; only
   categorical masses differ.
4. Exactly eight first-class catalysis facts exist and the detector reads
   those facts rather than names.
5. All four frontier phases are unit-tested, including boundary masses and
   the full 96-bin count for unguided, weak, and shuffled policies.
6. Selection feeds the ordinary bounded cap-8 chamber-tick path directly.
7. Weak and shuffled cost is exactly eight shifted mass units per draw; no
   chemistry outcome is used to calculate cost.

Any failed gate stops the registered run. Calibration may not inspect a
seed-19--26 trajectory or RAF endpoint.

## Endpoints and interpretation

The primary endpoint is per-arm rolling RAF incidence. Secondary endpoints
are first-hit tick, longest positive persistence, productive-event count,
rule diversity/collapse, exact replay, and intervention cost. Prespecified
causal tests remove the state-aware guiding term, `ob0`, all three RAF
catalyst edges, and each of `op1/op2/op0` separately while preserving seeds,
ticks, pool, selector draw function, and food schedule.

`emergence-claim none` may change only if weak Doob-h is RAF-positive while
both unguided and shuffled controls are RAF-null, replay passes, removal of
the guiding term collapses the weak result, and the catalyst/rule ablations
confirm dependence on the three-rule cycle. Otherwise the result is reported
as a null or pool-composition/control result without adding seeds or ticks.

## Frozen result

The corrected ordered detector reports RAF incidence 0/8 unguided, 6/8 weak
Doob-h, and 0/8 shuffled-frontier guidance. Weak first hits are
`[99,12,15,14,99,19,19,18]`; persistence totals are 0/41/0 and terminal
distinct-rule totals are 42/59/39 out of 64. All 24 trajectories replay.
Guiding-term removal gives 0/8; bootstrap removal, removal of all three RAF
catalyst edges, and each individual `op1/op2/op0` removal also give 0/8.
These outcomes meet the preregistered guided causal-uplift condition. They do
not establish spontaneous emergence, and no seeds or ticks were added.
