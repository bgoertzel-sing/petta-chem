; exp07 Schrödinger-bridge / Doob-h-transform diagnostic scaffold.
;
; This file names the initial/terminal chemistry conditions and intervention
; variables for bridge-guided search.  It is PeTTa-native bookkeeping over
; existing exp02/exp04/exp05/exp06 evidence, not a host-side chemistry kernel and
; not an emergence claim.

; ----- Bridge framing -----

(= (exp07-bridge-framing)
   (bridge-framing
     source ben-substack-lets-get-chemical
     formulation (schrodinger-bridge doob-h-transform)
     role diagnostic-search-strategy
     chemistry-kernel petta-native
     emergence-claim none))

; ----- Initial and terminal states -----

(= (exp07-initial-state)
   (bridge-state initial
                 sources (exp02-generated-unplanted-no-catalysis-controls
                          exp04-no-catalysis-controls)
                 acs-status verified-acs-negative
                 exp02-cycle-scan active-cycles-0-through-5-rule-scans
                 exp04-maximal-raf 0))

(= (exp07-terminal-state)
   (bridge-state terminal
                 source exp04-acs-rich-fixture
                 acs-status acs-rich-terminal-fixture
                 maximal-raf 15
                 greedy-core-size 2
                 greedy-core (lCD lBCD2)))

; ----- Intervention-variable cost vector -----

(= (exp07-intervention-cost-vector)
   ((intervention-variable catalyst-assignment source exp06 cost-row catalyst-assignment)
    (intervention-variable basal-food-replenishment source exp06 cost-row basal-food-replenishment)
    (intervention-variable candidate-pool-cap source exp06 cost-row candidate-pool-cap)
    (intervention-variable catalysis-map-offset source exp06 cost-row catalysis-map-offset)
    (intervention-variable affinity-weight source exp05 cost-row affinity-weight)))

(= (exp07-bridge-cost catalyst-assignment)
   (bridge-cost catalyst-assignment
                from none
                to specific-template
                cost 1
                source exp06-intervention-cost-row
                status shortest-raf-positive-path))

(= (exp07-bridge-cost basal-food-replenishment)
   (bridge-cost basal-food-replenishment
                from basal-0
                to basal-4
                cost 1
                source exp06-intervention-cost-row
                status raf-negative-alone))

(= (exp07-bridge-cost candidate-pool-cap)
   (bridge-cost candidate-pool-cap
                from unbounded-for-raf-report
                to cap-2
                cost 1
                source exp06-consolidation-summary
                status not-acs-positive))

(= (exp07-bridge-cost catalysis-map-offset)
   (bridge-cost catalysis-map-offset
                from none
                to shuffled-offset
                cost 1
                source exp06-intervention-cost-row
                status offset-sensitive))

(= (exp07-bridge-cost affinity-weight)
   (bridge-cost affinity-weight
                from neutral
                to token-overlap-biased
                cost 1
                source exp05-affinity-scaffold
                status diagnostic-weighting-variable))

(= (exp07-bridge-cost-table)
   ((exp07-bridge-cost catalyst-assignment)
    (exp07-bridge-cost basal-food-replenishment)
    (exp07-bridge-cost candidate-pool-cap)
    (exp07-bridge-cost catalysis-map-offset)
    (exp07-bridge-cost affinity-weight)))

; A bridge path is an ordered sequence of interventions.  The first named path
; records the exp06 cost-1 terminal fixture route as a baseline for later
; Schrödinger-bridge/Doob-h-transform weighting tests.

(= (exp07-bridge-path baseline-catalyst-assignment)
   (bridge-path baseline-catalyst-assignment
                ordered-interventions ((exp07-bridge-cost catalyst-assignment))
                start (exp07-initial-state)
                target (exp07-terminal-state)
                interpretation shortest-diagnostic-terminal-fixture-path
                emergence-claim none))

(= (exp07-bridge-target-acs-status)
   (bridge-target-acs-status
     target (exp07-terminal-state)
     check terminal-condition-acs
     maximal-raf 15
     greedy-core-size 2
     greedy-core (lCD lBCD2)
     status acs-positive-terminal-fixture
     emergence-claim none))

(= (exp07-scaffold-status)
   (exp07-status schrodinger-bridge-doob-h-transform-diagnostic-scaffold
                 initial-state verified-acs-negative-controls
                 terminal-state exp04-acs-rich-fixture
                 intervention-variables 5
                 bridge-paths ordered-intervention-sequences
                 chemistry-kernel petta-native
                 emergence-claim none))

; ----- Doob-h diagnostic weighting slice -----
;
; These rows turn the bridge framing into a first PeTTa-queryable action policy.
; The h-value is a bounded diagnostic preference for interventions that move a
; soup toward the terminal ACS-rich fixture without directly imposing the
; terminal state.  It is deliberately ordinal/static in this first slice.

(= (exp07-doob-h-row catalyst-assignment)
   (doob-h-row catalyst-assignment
               bridge-action assign-specific-template-catalysts
               cost 1
               h-value 5
               terminal-proximity terminal-raf-positive
               validation exp04-acs-scanner
               guidance-status strongest-diagnostic-bias
               emergence-claim none))

(= (exp07-doob-h-row affinity-weight)
   (doob-h-row affinity-weight
               bridge-action increase-token-overlap-affinity
               cost 1
               h-value 3
               terminal-proximity weak-guidance-variable
               validation exp05-chamber-tick-probe
               guidance-status weak-bias-test-candidate
               emergence-claim none))

(= (exp07-doob-h-row candidate-pool-cap)
   (doob-h-row candidate-pool-cap
               bridge-action expose-bounded-candidate-diversity
               cost 1
               h-value 2
               terminal-proximity not-acs-positive-in-exp06
               validation exp06-stateful-cap-boundary
               guidance-status control-or-secondary-variable
               emergence-claim none))

(= (exp07-doob-h-row basal-food-replenishment)
   (doob-h-row basal-food-replenishment
               bridge-action maintain-food-floor
               cost 1
               h-value 1
               terminal-proximity raf-negative-alone
               validation exp04-no-catalysis-control
               guidance-status necessary-context-not-sufficient
               emergence-claim none))

(= (exp07-doob-h-row catalysis-map-offset)
   (doob-h-row catalysis-map-offset
               bridge-action rotate-catalysis-map
               cost 1
               h-value 1
               terminal-proximity offset-sensitive-artifact-risk
               validation exp04-offset-sensitivity-report
               guidance-status control-not-primary-bias
               emergence-claim none))

(= (exp07-doob-h-table)
   ((exp07-doob-h-row catalyst-assignment)
    (exp07-doob-h-row affinity-weight)
    (exp07-doob-h-row candidate-pool-cap)
    (exp07-doob-h-row basal-food-replenishment)
    (exp07-doob-h-row catalysis-map-offset)))

(= (exp07-doob-policy-order)
   (doob-policy-order
     initial (exp07-initial-state)
     terminal (exp07-terminal-state)
     ranked-actions (catalyst-assignment affinity-weight candidate-pool-cap basal-food-replenishment catalysis-map-offset)
     top-action catalyst-assignment
     weak-guidance-actions (affinity-weight candidate-pool-cap)
     control-actions (basal-food-replenishment catalysis-map-offset)
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-weak-guidance-test-plan)
   (weak-guidance-test-plan
     purpose test-bridge-derived-bias-without-fixing-terminal-state
     candidate-policy (exp07-doob-policy-order)
     unguided-baseline exp02-generated-unplanted-controls
     weakly-guided-variables (affinity-weight candidate-pool-cap)
     validation-scanners old-acs-scanners
     success-observable increased-acs-frequency-or-persistence-versus-controls
     current-status planned-not-run
     emergence-claim none))

; ----- Weak-guidance probe over existing PeTTa-native dynamics -----
;
; This slice connects the exp07 Doob-h policy to already-tested exp05/exp06
; chamber ticking evidence.  It does not add a host chemistry kernel, does not
; force the exp04 terminal state, and does not upgrade candidate caps to ACS
; evidence.  It simply records which weak-guidance variables have dynamic
; PeTTa-native probes available for the next unguided-vs-biased comparison.

(= (exp07-weak-guidance-evidence-row affinity-weight)
   (weak-guidance-evidence-row
     variable affinity-weight
     doob-h-value 3
     dynamic-source exp05-chamber-tick-affinity-2
     treatment-selected (exp05-affinity-selected-candidate-2 seed-7 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-7 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-7 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-7 3 1)
     chamber-ticking wired-through-exp00-selector
     terminal-forcing prohibited
     acs-status not-yet-scanned
     emergence-claim none))

(= (exp07-weak-guidance-evidence-row candidate-pool-cap)
   (weak-guidance-evidence-row
     variable candidate-pool-cap
     doob-h-value 2
     dynamic-source exp06-candidate-cap-stateful-three-tick-sweep
     stateful-sweep (exp06-candidate-cap-stateful-three-tick-sweep)
     acs-boundary (exp06-stateful-cap-sweep-acs-boundary-table)
     cap-effect divergence-persists-through-bounded-blocked-tick
     terminal-forcing prohibited
     acs-status rejected-by-two-rule-product-catalyst-closure
     emergence-claim none))

(= (exp07-weak-guidance-evidence-table)
   ((exp07-weak-guidance-evidence-row affinity-weight)
    (exp07-weak-guidance-evidence-row candidate-pool-cap)))

(= (exp07-weak-guidance-probe-status)
   (weak-guidance-probe-status
     policy (exp07-doob-policy-order)
     evidence (exp07-weak-guidance-evidence-table)
     tested-variables (affinity-weight candidate-pool-cap)
     chamber-ticking deterministic-exp00-selector
     terminal-forcing prohibited
     current-boundary dynamic-probes-linked-but-no-acs-positive-result
     next-test unguided-versus-weakly-guided-frequency-comparison
     emergence-claim none))

; ----- First deterministic weak-guidance comparison table -----
;
; This is the smallest PeTTa-native comparison slice before a broader frequency
; sweep.  It records exactly what the existing deterministic chamber ticks show:
; affinity weighting changes the selected catalyst/product context versus its
; rotated control while preserving first-tick productivity, and candidate-cap
; variation changes the stateful path without passing the conservative
; two-rule closure boundary.  The table is therefore a checked design boundary,
; not evidence for ACS emergence.

(= (exp07-weak-guidance-comparison-row affinity-weight)
   (weak-guidance-comparison-row
     variable affinity-weight
     treatment (exp05-chamber-tick-affinity-2 seed-7 3 1)
     control (exp05-chamber-tick-shuffled-affinity-2 seed-7 3 1)
     deterministic-selector exp00-selected-candidate-from-list-2
     observed-effect catalyst-context-changed-but-both-first-tick-productive
     acs-uplift not-evaluated
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-weak-guidance-comparison-row candidate-pool-cap)
   (weak-guidance-comparison-row
     variable candidate-pool-cap
     treatment (exp06-candidate-cap-stateful-three-tick-sweep)
     boundary (exp06-stateful-cap-sweep-acs-boundary-table)
     deterministic-selector exp00-selected-candidate-from-list-1-and-2
     observed-effect cap-1-cap-2-stateful-paths-diverge-then-block
     acs-uplift rejected-by-two-rule-product-catalyst-closure
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-weak-guidance-comparison-table)
   ((exp07-weak-guidance-comparison-row affinity-weight)
    (exp07-weak-guidance-comparison-row candidate-pool-cap)))

(= (exp07-weak-guidance-comparison-status)
   (weak-guidance-comparison-status
     compared-variables (affinity-weight candidate-pool-cap)
     evidence (exp07-weak-guidance-comparison-table)
     deterministic-selection directly-wired-to-chamber-ticking
     bounded-caps tested-via-exp06-stateful-cap-sweep
     current-boundary deterministic-differences-without-acs-uplift
     next-test vary-affinity-strength-and-seed-before-frequency-claim
     emergence-claim none))

; ----- Affinity-strength sweep slice -----
;
; This is the first narrow follow-up to the comparison-table next-test.  It
; varies only the exp05 affinity strength in the existing seed-7/tick-3 fixture,
; keeps candidate generation bounded at cap 2, and records the deterministic
; candidate that is handed to chamber ticking.  The result is intentionally a
; productivity filter for later seed/frequency comparisons: strength 1 is the
; only tested value whose treatment and rotated-control selected catalysts are
; present in the current fixture, so it is the only one we treat as a productive
; chamber-tick probe.  No terminal state is fixed and no ACS uplift is claimed.

(= (exp07-affinity-strength-sweep-row 0)
   (affinity-strength-sweep-row
     strength 0
     treatment-selected (exp05-affinity-selected-candidate-2 seed-7 3 0)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-7 3 0)
     cap 2
     deterministic-selector exp00-selected-candidate-from-list-2
     first-tick-status selected-catalysts-absent-in-current-fixture
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-strength-sweep-row 1)
   (affinity-strength-sweep-row
     strength 1
     treatment-selected (exp05-affinity-selected-candidate-2 seed-7 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-7 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-7 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-7 3 1)
     cap 2
     deterministic-selector exp00-selected-candidate-from-list-2
     first-tick-status treatment-and-control-productive
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-strength-sweep-row 2)
   (affinity-strength-sweep-row
     strength 2
     treatment-selected (exp05-affinity-selected-candidate-2 seed-7 3 2)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-7 3 2)
     cap 2
     deterministic-selector exp00-selected-candidate-from-list-2
     first-tick-status selected-catalysts-absent-in-current-fixture
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-strength-sweep-table)
   ((exp07-affinity-strength-sweep-row 0)
    (exp07-affinity-strength-sweep-row 1)
    (exp07-affinity-strength-sweep-row 2)))

(= (exp07-affinity-strength-sweep-status)
   (affinity-strength-sweep-status
     variable affinity-weight
     tested-strengths (0 1 2)
     seed seed-7
     tick 3
     cap 2
     evidence (exp07-affinity-strength-sweep-table)
     productive-strengths (1)
     current-boundary productivity-filter-not-frequency-claim
     next-test vary-seed-over-productive-strength-before-acs-frequency-claim
     terminal-forcing prohibited
     emergence-claim none))

; ----- Productive affinity selection-to-tick trace -----
;
; This row makes the productive strength-1 path fully inspectable as a bounded
; candidate-generation/cap/selection/tick trace.  It expands the treatment and
; rotated-control pools, the cap-2 lists, the deterministic selected candidates,
; and the resulting ordinary exp00 chamber ticks.  The trace is intentionally a
; single-fixture provenance check: it proves the weak-guidance candidate chosen
; by deterministic selection is exactly the one handed to chamber ticking, but
; it still does not run an ACS scanner or make a frequency/uplift claim.

(= (exp07-affinity-selection-to-tick-trace strength-1)
   (affinity-selection-to-tick-trace
     variable affinity-weight
     strength 1
     seed seed-7
     tick 3
     cap 2
     treatment-pool (exp05-affinity-candidate-pool-2 seed-7 3 1)
     treatment-bounded-candidates (cap-candidate-pool 2 (exp05-affinity-candidate-pool-2 seed-7 3 1))
     treatment-selected (exp05-affinity-selected-candidate-2 seed-7 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-7 3 1)
     control-pool (exp05-shuffled-affinity-candidate-pool-2 seed-7 3 1)
     control-bounded-candidates (cap-candidate-pool 2 (exp05-shuffled-affinity-candidate-pool-2 seed-7 3 1))
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-7 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-7 3 1)
     deterministic-selector exp00-selected-candidate-from-list-2
     selection-handed-to chamber-tick-with-candidate
     scientific-boundary single-fixture-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-selection-to-tick-status)
   (affinity-selection-to-tick-status
     trace (exp07-affinity-selection-to-tick-trace strength-1)
     bounded-candidate-generation exp05-affinity-candidate-pool-2
     cap cap-2
     deterministic-selection directly-handed-to-exp00-chamber-ticking
     productive-strengths (1)
     current-boundary selection-to-tick-provenance-only
     next-test vary-seed-over-productive-strength-before-acs-frequency-claim
     terminal-forcing prohibited
     emergence-claim none))

; ----- Productive-strength seed variation -----
;
; This is the first small follow-up to the seed-variation next-test.  It keeps
; strength 1 and cap 2 fixed, varies only the seed/selector phase over ten
; PeTTa-defined chambers, and records that deterministic selection is still
; handed directly to ordinary exp00 chamber ticking.  Seeds 7/9/11/13/15
; exercise first-candidate phases, and seeds 8/10/12/14/16 exercise
; second-candidate phases with varied productive catalyst contexts.  This is
; still a ten-seed provenance/control slice, not a frequency claim and not an
; ACS scan.

(= (exp07-affinity-seed-variation-row seed-7)
   (affinity-seed-variation-row
     seed seed-7
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate
     treatment-selected (exp05-affinity-selected-candidate-2 seed-7 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-7 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-7 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-7 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-8)
   (affinity-seed-variation-row
     seed seed-8
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate
     treatment-selected (exp05-affinity-selected-candidate-2 seed-8 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-8 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-8 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-8 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-9)
   (affinity-seed-variation-row
     seed seed-9
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate-repeat
     treatment-selected (exp05-affinity-selected-candidate-2 seed-9 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-9 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-9 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-9 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-10)
   (affinity-seed-variation-row
     seed seed-10
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate-repeat
     treatment-selected (exp05-affinity-selected-candidate-2 seed-10 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-10 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-10 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-10 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))


(= (exp07-affinity-seed-variation-row seed-11)
   (affinity-seed-variation-row
     seed seed-11
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate-late-draw
     treatment-selected (exp05-affinity-selected-candidate-2 seed-11 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-11 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-11 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-11 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-12)
   (affinity-seed-variation-row
     seed seed-12
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate-late-draw
     treatment-selected (exp05-affinity-selected-candidate-2 seed-12 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-12 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-12 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-12 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-13)
   (affinity-seed-variation-row
     seed seed-13
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate-draw-cycle-reset
     treatment-selected (exp05-affinity-selected-candidate-2 seed-13 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-13 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-13 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-13 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-14)
   (affinity-seed-variation-row
     seed seed-14
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate-draw-cycle-reset
     treatment-selected (exp05-affinity-selected-candidate-2 seed-14 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-14 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-14 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-14 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-15)
   (affinity-seed-variation-row
     seed seed-15
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate-extended-draw
     treatment-selected (exp05-affinity-selected-candidate-2 seed-15 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-15 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-15 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-15 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-16)
   (affinity-seed-variation-row
     seed seed-16
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate-extended-draw
     treatment-selected (exp05-affinity-selected-candidate-2 seed-16 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-16 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-16 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-16 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-17)
   (affinity-seed-variation-row
     seed seed-17
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate-later-draw
     treatment-selected (exp05-affinity-selected-candidate-2 seed-17 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-17 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-17 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-17 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-18)
   (affinity-seed-variation-row
     seed seed-18
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate-later-draw
     treatment-selected (exp05-affinity-selected-candidate-2 seed-18 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-18 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-18 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-18 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-19)
   (affinity-seed-variation-row
     seed seed-19
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate-latest-draw
     treatment-selected (exp05-affinity-selected-candidate-2 seed-19 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-19 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-19 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-19 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-20)
   (affinity-seed-variation-row
     seed seed-20
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate-latest-draw
     treatment-selected (exp05-affinity-selected-candidate-2 seed-20 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-20 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-20 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-20 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary fourteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-table)
   ((exp07-affinity-seed-variation-row seed-7)
    (exp07-affinity-seed-variation-row seed-8)
    (exp07-affinity-seed-variation-row seed-9)
    (exp07-affinity-seed-variation-row seed-10)
    (exp07-affinity-seed-variation-row seed-11)
    (exp07-affinity-seed-variation-row seed-12)
    (exp07-affinity-seed-variation-row seed-13)
    (exp07-affinity-seed-variation-row seed-14)
    (exp07-affinity-seed-variation-row seed-15)
    (exp07-affinity-seed-variation-row seed-16)
    (exp07-affinity-seed-variation-row seed-17)
    (exp07-affinity-seed-variation-row seed-18)
    (exp07-affinity-seed-variation-row seed-19)
    (exp07-affinity-seed-variation-row seed-20)))

(= (exp07-affinity-seed-variation-status)
   (affinity-seed-variation-status
     variable affinity-weight
     strength 1
     tested-seeds (seed-7 seed-8 seed-9 seed-10 seed-11 seed-12 seed-13 seed-14 seed-15 seed-16 seed-17 seed-18 seed-19 seed-20)
     tick 3
     cap 2
     evidence (exp07-affinity-seed-variation-table)
     selector-phases (first-candidate second-candidate first-candidate-repeat second-candidate-repeat first-candidate-late-draw second-candidate-late-draw first-candidate-draw-cycle-reset second-candidate-draw-cycle-reset first-candidate-extended-draw second-candidate-extended-draw first-candidate-later-draw second-candidate-later-draw first-candidate-latest-draw second-candidate-latest-draw)
     chamber-ticking directly-handed-to-exp00-chamber-ticking
     current-boundary fourteen-seed-selector-phase-provenance-only
     next-test broaden-seed-sweep-before-acs-frequency-claim
     terminal-forcing prohibited
     emergence-claim none))
