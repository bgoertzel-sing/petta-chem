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

The sixth slice broadens that productive strength-1/cap-2 provenance check from two seeds to eighteen PeTTa-defined chambers. Seeds 7/9/11/13/15/17/19/21/23 exercise first-candidate phases and seeds 8/10/12/14/16/18/20/22/24 exercise second-candidate phases with varied productive catalyst contexts; all selected candidates are handed directly to ordinary exp00 chamber ticking in treatment/control arms. This is still provenance/selector-phase coverage only, not a frequency claim, ACS scan, or terminal-forcing result.

The stochastic-pilot gate calibrates a replayable four-bin categorical selector over seeds 7--10 and ticks 3--6, then audits chamber applicability before any stateful ensemble is run. The old exp05 fixtures fail that audit (productive first ticks 0/4 unguided, 3/4 weak Doob-h, 3/4 shuffled) because each contains only the molecules needed by its original deterministic choice. A shared seven-molecule PeTTa state now fixes that confound: all 24 candidates in the twelve arm/seed pools are applicable, and all twelve selected first draws produce ordinary exp00 chamber ticks. The gate is ready for a stateful outcome comparison; this is not an ACS/RAF or emergence result.

The first stateful matrix carries every arm/seed tick-3 chamber directly into tick 4. Ordinary exp00 ticking yields per-seed productive-event counts of unguided `[1,2,1,2]`, weak Doob-h `[2,2,1,1]`, and shuffled guidance `[1,2,2,1]` for seeds 7--10. All arms total six events and all 12 trajectories replay exactly, so the two-tick gate shows different seed-level paths but no aggregate productivity difference. This validates matched state carry, event accumulation, and replay only; preregistered ACS/RAF outcomes remain pending and `emergence-claim none`.

The registered N=20 path passes its preregistered pre-run pool-identity gate by
constructing one exact strength-1 affinity candidate pool per seed/tick and
sharing it across all three arms. Only categorical selection mass varies by
arm. The earlier pilot pool constructors remain unchanged as historical
evidence.

The frozen N=20 matrix is now complete. All twelve trajectories consume ticks
3--22, apply the identical replenishment schedule at ticks 8/13/18, replay
exactly, and produce eight events per seed (32 per arm). The event-derived
bounded RAF specialization finds incidence 4/4 in every arm. First-hit ticks
are unguided `[5,3,8,10]`, weak Doob-h `[3,3,8,8]`, and shuffled guidance
`[5,3,4,3]`. This triggers the preregistered all-arms-positive pivot: the
current shared two-rule pool supports RAF closure independently of guidance,
so guiding-term ablation does not collapse the controls and
`emergence-claim none` remains in force.

The resulting all-arms-positive pivot is now frozen in
`PREREG_RICH_POOL.md`. The next design uses one shared eight-rule pool with a
latent three-rule RAF and five productive food-competing distractors. The
PeTTa contract freezes seeds 11--18, cap 8, a 24-tick horizon, explicit
first-class catalysis, matched controls, pre-run gates, ablations, and
`emergence-claim none`.

All rich-pool pre-run gates now pass. PeTTa checks the initial empty event
history as RAF-negative, discriminates complete and incomplete latent-cycle
histories, exposes exactly eight catalysis facts, realizes the frozen masses
over all 88 draw bins, and connects selection to ordinary cap-8 chamber
ticking. The canonical exp04 detector controls also pass. The complete frozen
matrix has since executed over seeds 11--18 and ticks 3--26. Its rolling RAF
incidence is 5/8 unguided, 7/8 weak Doob-h, and 3/8 shuffled, while longest-run
persistence totals are 13/49/11 ticks. Terminal distinct-rule diversity totals
are 61/61/54 out of 64 possible seed-rule presences, corresponding to collapse
deficits of 3/3/10 from the full eight-rule pool. Both controls are positive;
intervention cost and causal ablations remain, and `emergence-claim none`.

Run with:

```bash
scripts/run_exp07.sh
```

The separately labelled seeded detector-invariance fixture protects the
per-tick RAF purity assumption without inspecting the registered N=20 arms. It
uses only the canonical host detector in `experiments/exp04/run_rich_raf.py`
and committed facts in `src/chem_exp04.metta`. It checks A -> unrelated B -> A
call-order invariance, identical detector inputs reached through direct versus
advanced tick histories, and committed PeTTa/host single-result and mutation
guards. The JSON artifact cross-references each check to the source functions
or PeTTa equation lines it protects. Run it with:

```bash
scripts/run_exp07_detector_invariance.sh /tmp/exp07-detector-invariance.json
```
