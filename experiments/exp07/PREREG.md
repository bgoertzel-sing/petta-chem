# exp07 Preregistration: Longer-Horizon ACS Emergence Gate

**Status:** Preregistered 2026-07-16 08:05 PDT
**Supersedes:** Two-tick matched ensemble (commit `28ddc28`), which remains the valid short-horizon null.
**Emergence claim:** none (carried forward unless stop/pivot criteria below are met)

---

## 1. Shared assertion baseline

- **Test-suite sizes are not scientific baselines.** The 154/128 assertion counts from `run_exp00.sh`/`run_exp07.sh` are test-coverage figures, not emergence denominators. They are not referenced as outcome baselines.
- **Scientific null baseline:** Under the null hypothesis ("no guidance-driven ACS emergence"), all three arms produce zero ACS/RAF closures at any tick. The expected event-count trajectory under the null is determined by reactant availability and ordinary chamber dynamics, not by guidance arm.
- **Frozen reference:** The two-tick result (commit `28ddc28`) — all arms total 6 productive events, all 12 trajectories replay exactly — is the frozen preregistration-time null. Any longer-horizon result must be compared against this, not against post-hoc re-derivations.

## 2. Positive control as gating prerequisite

**No horizon extension until the detector fires on a known-closing RAF/ACS set.**

- **Positive-control fixture:** exp04 ACS-rich terminal fixture — maximal RAF 15, greedy core `{lCD, lBCD2}`, 18 first-class binary `(catalyzes Molecule RuleId)` edges (commit `3a870c5`, gate `20260716T022154Z-first-class-catalysis-exp04`).
- **Gating check:** Run the same ACS/RAF detector that will be used for exp07 outcomes against the exp04 fixture. The detector must report maximal-raf ≥ 1 and a non-empty greedy core.
- **Stop condition:** If the detector fails to fire on this known-closing set, halt. Fix the detector before any horizon extension. Two matching nulls on a broken detector would only be a more expensive way to not know.

## 3. Horizon and stopping rule

- **Horizon:** N = 20 ticks (ticks 3–22), chosen so the two-tick reactant-exhaustion artifact (observable at tick 4–5 in the current seven-molecule chamber) cannot mask longer-range catalytic structure.
- **Replenishment:** Basal food replenishment of {A, B, C} to their initial abundances (A:2, B:1, C:1) at every 5 ticks (ticks 8, 13, 18). This prevents trivial exhaustion-without-replenishment from dominating the trajectory while keeping the chamber minimally sustained. Replenishment is identical across all arms.
- **Fixed seeds:** {seed-7, seed-8, seed-9, seed-10} (unchanged from the two-tick ensemble).
- **Three arms:** unguided, weak Doob-h, shuffled-guidance (unchanged from the two-tick ensemble).
- **Candidate cap:** 2 (unchanged).
- **No peeking-and-extending.** The horizon is fixed at N=20 before any run. If the result is null at tick 22, it stays null.

## 4. Primary endpoints (prespecified)

| Endpoint | Definition | Role |
|---|---|---|
| **ACS/RAF incidence** (primary) | Binary: does any reflexively-autocatalytic set close at any tick in [3, 22]? | **Primary endpoint.** The emergence claim hinges on this. |
| **First-hit time** | First tick at which an ACS/RAF closure appears (if any) | Secondary |
| **Persistence** | Number of consecutive ticks the closure survives | Secondary |
| **Productivity** | Productive events per tick over the full horizon | Secondary |
| **Diversity collapse** | Decline in distinct molecule count over horizon | Secondary |
| **Causal ablation** | Does removing the guiding term (catalyst-assignment / affinity-weight) collapse any observed ACS? | **Causal validation.** Required for any emergence claim. |

## 5. Stop / pivot criteria

### Emergence claim (uplift)
`emergence-claim: none` is lifted to `emergence-claim: supported` **only if all four conditions hold:**

1. The positive control passed (Section 2).
2. The guided (weak Doob-h) arm produces at least one ACS/RAF closure within [3, 22].
3. Neither the unguided nor the shuffled-guidance arm produces an ACS/RAF closure in the same horizon.
4. Causal ablation (removing the guiding term from the guided arm's policy) eliminates the closure.

If any condition fails, `emergence-claim: none` stands.

### Pivot criteria
- **Positive control fails → fix detector first.** No horizon extension until the detector correctly identifies the exp04 known-closing set.
- **Aggregate null across all arms at N=20 → chamber redesign, not rerun.** If no arm produces ACS/RAF closure at any tick in [3, 22], the current seven-molecule / two-rule chemistry likely does not support the catalytic structure needed. Pivot to a richer chamber (more rules, more molecules, or an exp04-derived catalysis map) rather than extending the horizon further on the same fixture.
- **All arms produce closures → pool contamination suspected.** If the shuffled-guidance control also produces closures, the result is attributable to pool composition rather than guidance structure. Redesign the pool or tighten the control.

## 6. Guard against engineered-pool contamination

- The shuffled-guidance arm must share the exact same candidate pool composition as the other two arms. The only difference between arms is the selection policy (unguided / weak Doob-h / shuffled weights), not the pool itself.
- **Pre-run check:** Verify that the candidate pool for each arm/seed/tick is identical in composition (same source rules, same candidates, same catalyst assignments modulo the arm's guidance policy). Record this as a PeTTa-native assertion before running.
- **Post-run check:** If any arm's pool diverges in composition (not just selection order), the result is confounded and `emergence-claim: none` stands regardless of outcome.

## Reconciliation note

Both status streams (exp07 TASKS.md and NOTES.md) now read the same commit (`28ddc28`). This prereg doc keeps the two streams commensurable: the two-tick null is the shared baseline, the positive control is the shared gate, and the stop/pivot rules prevent "two nulls, different baselines" drift.

## Provenance

- Preregistration author: ZeroBot (drafted from ProtoMegaBot's 6-point proposal, 2026-07-16 08:01 PDT)
- Active commit at preregistration: `28ddc28` (exp07 two-tick matched ensemble)
- exp04 positive-control gate: `20260716T022154Z-first-class-catalysis-exp04`
- Research Rules applied: Rule 1 (detector validation), Rule 2 (preregistered contract before coding), Rule 5 (reproducible evidence), Rule 7 (replaceable sampling/scoring seams)
