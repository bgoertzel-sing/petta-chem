# exp07 — Schrödinger-bridge / Doob-h-transform diagnostics

exp07 scaffolds the next main experiment family after exp06 consolidation. It frames bridge-to-ACS search as diagnostic Schrödinger-bridge / Doob-h-transform bookkeeping, following Ben's "Let's Get Chemical" framing.

## State definitions

- Initial state: exp02/exp04 no-catalysis controls, verified ACS-negative.
- Terminal state: exp04 ACS-rich fixture, maximal RAF 15, greedy core size 2, `(lCD lBCD2)`.

## Intervention vector

The scaffold records a structured cost vector over catalyst assignment, basal-food replenishment, candidate-pool cap, catalysis-map offset, and exp05 affinity weight. The baseline bridge path is the exp06 cost-1 catalyst-assignment route to the engineered terminal fixture.

The first Doob-h diagnostic slice is PeTTa-native bookkeeping: it ranks catalyst assignment highest as the terminal-fixture diagnostic, identifies affinity weight plus candidate cap as weak-guidance variables to test without terminal forcing, and keeps basal replenishment plus catalysis-map offset as controls/context. This is not a spontaneous-emergence claim. Old ACS scanners remain validation/control infrastructure; Python may remain a harness only.

The second slice links the weak-guidance variables to existing PeTTa-native dynamic evidence: affinity weight points to exp05 treatment/control chamber ticking through exp00 deterministic selection, and candidate-pool cap points to exp06's three-tick stateful cap sweep plus ACS-boundary table. The aggregate `exp07-weak-guidance-probe-status` keeps the boundary explicit: dynamic probes are linked, but there is no terminal forcing, no ACS-positive result, and no emergence claim.

The third slice adds a first deterministic weak-guidance comparison table. It records that affinity weighting changes the catalyst/product context while both treatment and rotated control remain first-tick productive, and that cap-1/cap-2 stateful paths diverge then block without passing the two-rule ACS closure check. This prepares a later seed/affinity-strength frequency comparison without claiming ACS uplift yet.

The fourth slice starts that follow-up narrowly by varying only exp05 affinity strength `(0 1 2)` in the existing seed-7/tick-3 cap-2 fixture. It records the selected candidates handed to chamber ticking and marks strength 1 as the only tested value with both treatment and rotated-control selected catalysts present/productive in the current fixture. This is a productivity filter for later seed sweeps, not a frequency or ACS-uplift claim.

The fifth slice expands the productive strength-1 case into an explicit selection-to-tick provenance trace. It records the treatment/control candidate pools, cap-2 bounded lists, deterministic selected candidates, and resulting exp00 chamber ticks in one smoke-tested atom, proving the selected weak-guidance candidates are exactly the candidates handed to chamber ticking. This remains a single-fixture provenance check only: no seed/frequency claim, no terminal forcing, no ACS uplift, and no emergence claim.

Run with:

```bash
scripts/run_exp07.sh
```
