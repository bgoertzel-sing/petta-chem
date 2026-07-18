# exp07 Preregistration: Ordered-Bootstrap Replication and Robustness

**Status:** Cohort A complete; cohort B unevaluated.
**Predecessor:** `PREREG_ORDERED_BOOTSTRAP.md`, whose corrected frozen result
was 0/8 unguided, 6/8 weak Doob-h, and 0/8 shuffled-frontier guidance.
**Claim boundary:** independent replication of bounded guided causal RAF uplift;
spontaneous emergence claim none.

## Purpose

The seed-19--26 result is complete and must not be extended. This protocol
tests whether its treatment-control separation reproduces on fresh draws and
whether it survives a fixed candidate-order perturbation. It does not tune the
chemistry or selector from the completed outcomes.

## Frozen chemistry and endpoints

Both cohorts retain the exact ordered-bootstrap molecules, initial abundances,
eight reaction identities, eight explicit `(catalyzes Molecule RuleId)` facts,
food resets before ticks 11 and 19, cap 8, ticks 3--26, rolling last-eight-event
`op1/op2/op0` RAF detector, and unguided / weak Doob-h / matched
shuffled-frontier arms. The non-RAF `ob0` bootstrap remains excluded from RAF
membership.

The primary endpoint is per-arm RAF incidence. Secondary endpoints remain
first-hit tick, longest positive persistence, productive-event count, terminal
rule diversity, exact replay, and intervention cost. The causal gate repeats
guiding-term, `ob0`, all-cycle-catalyst, and individual `op1`, `op2`, and `op0`
ablations without changing draws, horizon, pool, or food schedule.

## Cohort A: exact-form replication

- Seeds: 101--116, fixed before implementation.
- Pool order: `(ob0 op1 op2 op0 od0 od1 od2 od3)`.
- Draw index: `((29 * seed-number) + (43 * tick) + 7) mod 96`.
- Selector masses and state-read boundary are identical to the predecessor:
  unguided is eight masses of 12; weak and shuffled each use one mass 20, one
  mass 4, and six masses 12, with the high/low frontier pair reversed.

The primary result replicates only if weak Doob-h has at least six more
RAF-positive seeds than each matched control, every trajectory replays, both
guided arms retain equal cost, guiding-term removal leaves at most two
RAF-positive seeds, and every structural ablation leaves at most two. These
thresholds are fixed before any cohort-A trajectory exists.

## Cohort B: order/hash robustness

- Seeds: 117--132, disjoint from cohort A and all predecessor seeds.
- Pool order: `(od2 op0 ob0 od1 op2 od3 op1 od0)`.
- Draw index: `((47 * seed-number) + (53 * tick) + 11) mod 96`.
- Selection weights attach to rule identities, not list positions. Candidate
  generation must expose the exact permuted pool and the selector must recover
  the same phase-specific frontier/distractor semantics.

Robustness is supported only if weak Doob-h has at least four more
RAF-positive seeds than each matched control, all replay and matched-cost gates
pass, and all prespecified causal ablations leave at most two positives. Cohort
B cannot rescue a failed cohort-A primary replication.

## Fail-closed implementation gates

Before constructing either registered cohort:

1. The canonical exp04 detector-invariance checks and corrected ordered
   `op1/op2/op0` detector tests pass.
2. Seed-number support and both draw functions pass complete 96-bin calibration
   without constructing a chemistry trajectory.
3. Initial applicability and RAF negativity are unchanged from the predecessor.
4. Every arm receives the identical cohort-specific bounded cap-8 pool.
5. Cohort B selection is verified by rule identity across all four frontier
   phases, not by inherited list position.
6. Weak and shuffled guidance have equal eight-unit shifted mass per draw.
7. A synthetic nonregistered chamber connects selection directly to ordinary
   PeTTa chamber ticking.

Any failure stops the registered run. Calibration may not inspect a seed
101--132 trajectory or RAF endpoint. Cohort A is executed and reported in full
before cohort B is executed; neither cohort may be extended or replaced after
outcomes are visible.

## Interpretation

Passing cohort A supports independent replication of the bounded guided causal
RAF uplift. Passing both cohorts additionally supports robustness to the fixed
candidate-order and draw-hash perturbation. Neither result establishes
spontaneous emergence because the chemistry, catalytic frontier, bootstrap,
and guidance target remain designed.

## Frozen cohort-A result (2026-07-17 22:30 PDT)

Cohort A was executed over exactly seeds 101--116 and ticks 3--26 after all
fail-closed gates passed. RAF incidence was 1/16 unguided, 4/16 weak Doob-h,
and 0/16 shuffled-frontier guidance. The weak advantage was therefore only
three over unguided and four over shuffled, below both preregistered six-seed
thresholds. The primary replication is not supported and cohort B cannot
rescue it.

All 48 trajectories replayed. First hits were tick 26 for unguided seed 105
and ticks 24/22/23/24 for weak seeds 105/108/113/115. Persistence totals were
1/15/0, productive-event totals 259/263/250, and terminal distinct-rule totals
112/116/85 of 128. Guidance costs matched at 3,072 shifted mass units per
guided arm. Bootstrap, three-cycle-catalyst, and each individual cycle-rule
ablation left weak incidence at 0/16; guiding-term removal was the unchanged
unguided 1/16. No seed or horizon was extended. Spontaneous-emergence claim
remains none; cohort B remains unconstructed.
