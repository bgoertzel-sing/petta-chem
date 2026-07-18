# exp07 Analysis Plan: Dual-Bootstrap Mechanism Audit

**Status:** Frozen before implementation of any new derived diagnostic.
**Source data:** the completed `PREREG_DUAL_BOOTSTRAP.md` matrix only.
**Claim boundary:** mechanism characterization; no new treatment, replication,
guided-uplift, or spontaneous-emergence claim.

## Question

Why did the frozen unguided arm reach rolling four-rule RAF closure in 13/32
seeds while weak Doob-h guidance reached it in 9/32, despite the weak policy
placing more mass on the first absent pathway identity?

The registered outcome is already known, so this is a prospective analysis
plan for derived diagnostics, not a preregistration of that outcome. It may
explain the completed negative result but cannot rescue or reinterpret it.

## Frozen input and execution boundary

- Reuse exactly seeds 201--232, ticks 3--34, the twelve-rule chemistry, food
  resets, cap-8 generator, draw hash, and unguided/weak selectors already
  frozen and executed.
- Do not add seeds, ticks, rules, selector variants, counterfactual draws, or
  outcome thresholds.
- Reconstruct trajectories through the existing PeTTa chamber path. Derived
  classifications and counts must be computed in PeTTa. A host harness may
  only serialize or format PeTTa results.
- The shuffled arm remains a calibration reference, but the mechanism question
  is the paired seed-by-seed unguided versus weak comparison.

## Frozen diagnostics

For each arm, seed, and tick, emit one trace row containing the selected rule
identity, whether it was applicable, whether an event fired, the first absent
pathway identity before selection, the six pathway-product presence bits, and
the five food abundances after any scheduled reset but before firing.

From those rows derive, in this fixed order:

1. selected counts and fired counts for every rule identity;
2. blocked-selection counts, partitioned into pathway and distractor rules;
3. for each pathway identity, selections while it is the first absent identity
   and the fraction of those selections that fire;
4. first tick at which each prefix `db0`, `db1`, `dp1`, `dp2`, `dp3`, `dp0`
   becomes complete, using 99 when never reached;
5. ticks spent at each longest-complete-prefix depth 0--6;
6. food-exhaustion ticks for A--E and counts of scheduled resets reached while
   each seed is at prefix depths 0--5; and
7. the existing RAF hit, persistence, productive-event, and diversity values,
   reproduced unchanged as trace-integrity checks.

Aggregate only by reporting arm totals, medians for tick-valued diagnostics,
and paired per-seed weak-minus-unguided differences. Do not add significance
tests or select subgroups after inspecting the diagnostics.

## Frozen interpretation rule

Assign exactly one descriptive label from the following precedence order:

1. **trace mismatch** if any existing registered endpoint or replay result is
   not reproduced; stop without mechanism interpretation;
2. **applicability loss** if weak has more blocked first-absent selections than
   unguided in aggregate;
3. **resource diversion** if blocked first-absent selections do not increase,
   but weak reaches a lower median prefix depth before at least one food reset
   and has more pre-reset exhaustion for a food required by that next rule;
4. **maintenance loss** if prefix-depth progression through depth 6 is not
   worse by the preceding criteria, but weak fires fewer `dp1/dp2/dp3/dp0`
   events after first reaching depth 6; or
5. **unresolved/mixed** otherwise.

These labels are descriptive partitions of the frozen trajectories. None is
evidence that guidance caused or prevented closure, because selector policy is
not randomized independently of the deterministic seed/tick draw schedule.

## Implementation gates

Before accepting the audit report:

1. `scripts/run_exp00.sh`, `scripts/run_exp07.sh`, and detector invariance pass;
2. trace rows cover exactly 32 ticks for each of 96 trajectories with no
   duplicate `(arm, seed, tick)` keys;
3. event counts, first-hit ticks, persistence, diversity, and replay reproduce
   `DUAL_BOOTSTRAP_REPORT.md` exactly; and
4. `git diff --check` passes.

Any failed gate stops the audit. The report must retain the completed matrix's
negative guided-uplift result and `emergence-claim none`.
