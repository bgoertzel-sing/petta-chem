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
; still an eighteen-seed provenance/control slice, not a frequency claim and not an
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
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
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))


(= (exp07-affinity-seed-variation-row seed-21)
   (affinity-seed-variation-row
     seed seed-21
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate-cycle-repeat
     treatment-selected (exp05-affinity-selected-candidate-2 seed-21 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-21 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-21 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-21 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-22)
   (affinity-seed-variation-row
     seed seed-22
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate-cycle-repeat
     treatment-selected (exp05-affinity-selected-candidate-2 seed-22 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-22 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-22 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-22 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))


(= (exp07-affinity-seed-variation-row seed-23)
   (affinity-seed-variation-row
     seed seed-23
     tick 3
     strength 1
     cap 2
     selector-phase first-candidate-cycle-repeat-2
     treatment-selected (exp05-affinity-selected-candidate-2 seed-23 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-23 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-23 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-23 3 1)
     selected-rule e5r0
     productivity treatment-and-control-productive
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-24)
   (affinity-seed-variation-row
     seed seed-24
     tick 3
     strength 1
     cap 2
     selector-phase second-candidate-cycle-repeat-2
     treatment-selected (exp05-affinity-selected-candidate-2 seed-24 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-24 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-24 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-24 3 1)
     selected-rule e5r1
     productivity treatment-and-control-productive
     scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited
     emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-25)
   (affinity-seed-variation-row
     seed seed-25 tick 3 strength 1 cap 2
     selector-phase first-candidate-cycle-repeat-3
     treatment-selected (exp05-affinity-selected-candidate-2 seed-25 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-25 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-25 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-25 3 1)
     selected-rule e5r0 productivity treatment-and-control-productive
     scientific-boundary twenty-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited emergence-claim none))

(= (exp07-affinity-seed-variation-row seed-26)
   (affinity-seed-variation-row
     seed seed-26 tick 3 strength 1 cap 2
     selector-phase second-candidate-cycle-repeat-3
     treatment-selected (exp05-affinity-selected-candidate-2 seed-26 3 1)
     treatment-after-tick (exp05-chamber-tick-affinity-2 seed-26 3 1)
     control-selected (exp05-shuffled-affinity-selected-candidate-2 seed-26 3 1)
     control-after-tick (exp05-chamber-tick-shuffled-affinity-2 seed-26 3 1)
     selected-rule e5r1 productivity treatment-and-control-productive
     scientific-boundary twenty-seed-provenance-not-frequency-or-acs-uplift
     terminal-forcing prohibited emergence-claim none))

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
    (exp07-affinity-seed-variation-row seed-20)
    (exp07-affinity-seed-variation-row seed-21)
    (exp07-affinity-seed-variation-row seed-22)
    (exp07-affinity-seed-variation-row seed-23)
    (exp07-affinity-seed-variation-row seed-24)
    (exp07-affinity-seed-variation-row seed-25)
    (exp07-affinity-seed-variation-row seed-26)))

(= (exp07-affinity-seed-variation-status)
   (affinity-seed-variation-status
     variable affinity-weight
     strength 1
     tested-seeds (seed-7 seed-8 seed-9 seed-10 seed-11 seed-12 seed-13 seed-14 seed-15 seed-16 seed-17 seed-18 seed-19 seed-20 seed-21 seed-22 seed-23 seed-24 seed-25 seed-26)
     tick 3
     cap 2
     evidence (exp07-affinity-seed-variation-table)
     selector-phases (first-candidate second-candidate first-candidate-repeat second-candidate-repeat first-candidate-late-draw second-candidate-late-draw first-candidate-draw-cycle-reset second-candidate-draw-cycle-reset first-candidate-extended-draw second-candidate-extended-draw first-candidate-later-draw second-candidate-later-draw first-candidate-latest-draw second-candidate-latest-draw first-candidate-cycle-repeat second-candidate-cycle-repeat first-candidate-cycle-repeat-2 second-candidate-cycle-repeat-2 first-candidate-cycle-repeat-3 second-candidate-cycle-repeat-3)
     chamber-ticking directly-handed-to-exp00-chamber-ticking
     current-boundary twenty-seed-selector-phase-provenance-only
     next-test broaden-seed-sweep-before-acs-frequency-claim
     terminal-forcing prohibited
     emergence-claim none))

; ----- Replayable stochastic-ensemble pilot -----
;
; A four-bin categorical draw is the smallest stochastic selection seam needed
; to compare matched arms while retaining exact replay from seed and tick.  The
; unguided arm is uniform, weak Doob-h guidance gives the first candidate 3/4
; mass, and the shuffled control gives that same candidate 1/4 mass.  Candidate
; construction and chamber mutation remain the existing PeTTa-native exp05 and
; exp00 operations; this slice changes only sampling weights.

(= (exp07-pilot-draw $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 4))

(= (exp07-pilot-first-candidate-weight unguided) 2)
(= (exp07-pilot-first-candidate-weight weak-doob-h) 3)
(= (exp07-pilot-first-candidate-weight shuffled-guidance) 1)

(= (exp07-pilot-select-2 $arm $seed $tick $candidate-0 $candidate-1)
   (if (< (exp07-pilot-draw $seed $tick)
          (exp07-pilot-first-candidate-weight $arm))
       $candidate-0
       $candidate-1))

(= (exp07-pilot-candidate-pool-at unguided $seed $tick)
   (exp05-affinity-candidate-pool-2 $seed $tick 0))

(= (exp07-pilot-candidate-pool-at weak-doob-h $seed $tick)
   (exp05-affinity-candidate-pool-2 $seed $tick 1))

(= (exp07-pilot-candidate-pool-at shuffled-guidance $seed $tick)
   (exp05-shuffled-affinity-candidate-pool-2 $seed $tick 1))

(= (exp07-pilot-candidate-pool $arm $seed)
   (exp07-pilot-candidate-pool-at $arm $seed 3))

(= (exp07-pilot-chamber unguided $seed)
   (exp05-treatment-chamber $seed 3))

(= (exp07-pilot-chamber weak-doob-h $seed)
   (exp05-treatment-chamber $seed 3))

(= (exp07-pilot-chamber shuffled-guidance $seed)
   (exp05-rotated-control-chamber $seed 3))

; All arms now share one seven-molecule chemistry containing every reactant,
; product, and catalyst reachable from either candidate pool.  Candidate
; weights and catalyst assignments still differ by arm; initial chemistry does
; not.  Mutation uses the exp00 named-molecule state clauses.
(= (exp07-pilot-matched-chamber $seed)
   (chamber exp07-matched
     (state 3 $seed
       (molecules ((mol A 2) (mol B 1) (mol C 1)
                   (mol AB 1) (mol AC 1) (mol BC 1) (mol CD 1))))
     ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
     ()))

(= (exp07-pilot-selected-candidate-at $arm $seed $requested-tick)
   (let (candidate-pool $tick ($candidate-0 $candidate-1))
        (exp07-pilot-candidate-pool-at $arm $seed $requested-tick)
     (exp07-pilot-select-2
       $arm $seed $tick $candidate-0 $candidate-1)))

(= (exp07-pilot-selected-candidate $arm $seed)
   (exp07-pilot-selected-candidate-at $arm $seed 3))

(= (exp07-pilot-after-tick $arm $seed)
   (chamber-tick-with-candidate
     (exp07-pilot-chamber $arm $seed)
     (exp07-pilot-selected-candidate $arm $seed)))

(= (exp07-pilot-matched-after-tick $arm $seed)
   (chamber-tick-with-candidate
     (exp07-pilot-matched-chamber $seed)
     (exp07-pilot-selected-candidate $arm $seed)))

; The smallest stateful outcome slice carries the mutated tick-3 chamber into
; tick 4 and samples again from the same replayable arm/seed policy.  This is
; deliberately only a two-tick trajectory: it validates state carry-forward
; and per-tick selection provenance before the complete fixed-seed ensemble is
; expanded or any ACS/RAF outcome is interpreted.
(= (exp07-pilot-matched-after-two-ticks $arm $seed)
   (chamber-tick-with-candidate
     (exp07-pilot-matched-after-tick $arm $seed)
     (exp07-pilot-selected-candidate-at $arm $seed 4)))

; Longer-horizon trajectories need two time semantics that the successful
; two-tick slice did not exercise: a blocked draw still consumes its tick, and
; the frozen basal-food schedule resets A/B/C immediately before ticks
; 8, 13, and 18.  Keep both operations PeTTa-native and independent of the
; experimental arm so the complete registered matrix can reuse one seam.
(= (exp07-pilot-advance-blocked-tick
      (chamber $id
        (state $tick $seed (molecules $molecules))
        $rules $events))
   (chamber $id
     (state (+ $tick 1) $seed (molecules $molecules))
     $rules $events))

(= (exp07-pilot-replenish-food
      (chamber $id
        (state $tick $seed
          (molecules ((mol A $a) (mol B $b) (mol C $c)
                      (mol AB $ab) (mol AC $ac) (mol BC $bc) (mol CD $cd))))
        $rules $events))
   (chamber $id
     (state $tick $seed
       (molecules ((mol A 2) (mol B 1) (mol C 1)
                   (mol AB $ab) (mol AC $ac) (mol BC $bc) (mol CD $cd))))
     $rules $events))

(= (exp07-pilot-replenishment-tick? $tick)
   (or (== $tick 8)
       (or (== $tick 13) (== $tick 18))))

(= (exp07-pilot-prepare-chamber
      (chamber $id $state $rules $events))
   (if (exp07-pilot-replenishment-tick? (state-tick $state))
       (exp07-pilot-replenish-food
         (chamber $id $state $rules $events))
       (chamber $id $state $rules $events)))

(= (exp07-pilot-total-tick $chamber $candidate)
   (let $prepared (exp07-pilot-prepare-chamber $chamber)
     (if (candidate-applicable-in-chamber? $candidate $prepared)
         (chamber-tick-with-candidate $prepared $candidate)
         (exp07-pilot-advance-blocked-tick $prepared))))

(= (exp07-pilot-two-tick-trajectory $arm $seed)
   (stateful-trajectory
     arm $arm
     seed $seed
     ticks (3 4)
     initial (exp07-pilot-matched-chamber $seed)
     selected
       ((3 (exp07-pilot-selected-candidate-at $arm $seed 3))
        (4 (exp07-pilot-selected-candidate-at $arm $seed 4)))
     chambers
       ((3 (exp07-pilot-matched-after-tick $arm $seed))
        (4 (exp07-pilot-matched-after-two-ticks $arm $seed)))
     replay exact-seed-tick-state-carry
     outcome-boundary trajectory-plumbing-only
     emergence-claim none))

; Expand the two-tick stateful gate across the complete matched pilot matrix.
; Event counts are read from the terminal chamber produced by ordinary exp00
; ticking; the replay check reconstructs both ticks from the shared initial
; chamber and the recorded seed/tick selections.
(= (exp07-pilot-event-list-count ()) 0)
(= (exp07-pilot-event-list-count ($event-0)) 1)
(= (exp07-pilot-event-list-count ($event-0 $event-1)) 2)

(= (exp07-pilot-two-tick-event-count $arm $seed)
   (let (chamber $id $state $rules $events)
        (exp07-pilot-matched-after-two-ticks $arm $seed)
     (exp07-pilot-event-list-count $events)))

(= (exp07-pilot-replayed-after-two-ticks $arm $seed)
   (chamber-tick-with-candidate
     (chamber-tick-with-candidate
       (exp07-pilot-matched-chamber $seed)
       (exp07-pilot-selected-candidate-at $arm $seed 3))
     (exp07-pilot-selected-candidate-at $arm $seed 4)))

(= (exp07-pilot-two-tick-replay-ok? $arm $seed)
   (== (exp07-pilot-matched-after-two-ticks $arm $seed)
       (exp07-pilot-replayed-after-two-ticks $arm $seed)))

(= (exp07-pilot-two-tick-arm-event-count $arm)
   (+ (exp07-pilot-two-tick-event-count $arm seed-7)
      (+ (exp07-pilot-two-tick-event-count $arm seed-8)
         (+ (exp07-pilot-two-tick-event-count $arm seed-9)
            (exp07-pilot-two-tick-event-count $arm seed-10)))))

(= (exp07-pilot-two-tick-replay-int $arm $seed)
   (if (exp07-pilot-two-tick-replay-ok? $arm $seed) 1 0))

(= (exp07-pilot-two-tick-arm-replay-count $arm)
   (+ (exp07-pilot-two-tick-replay-int $arm seed-7)
      (+ (exp07-pilot-two-tick-replay-int $arm seed-8)
         (+ (exp07-pilot-two-tick-replay-int $arm seed-9)
            (exp07-pilot-two-tick-replay-int $arm seed-10)))))

(= (exp07-pilot-two-tick-ensemble-summary)
   (stateful-ensemble-summary
     arms (unguided weak-doob-h shuffled-guidance)
     fixed-seeds (seed-7 seed-8 seed-9 seed-10)
     ticks (3 4)
     productive-events-by-seed
       ((unguided
          ((seed-7 (exp07-pilot-two-tick-event-count unguided seed-7))
           (seed-8 (exp07-pilot-two-tick-event-count unguided seed-8))
           (seed-9 (exp07-pilot-two-tick-event-count unguided seed-9))
           (seed-10 (exp07-pilot-two-tick-event-count unguided seed-10))))
        (weak-doob-h
          ((seed-7 (exp07-pilot-two-tick-event-count weak-doob-h seed-7))
           (seed-8 (exp07-pilot-two-tick-event-count weak-doob-h seed-8))
           (seed-9 (exp07-pilot-two-tick-event-count weak-doob-h seed-9))
           (seed-10 (exp07-pilot-two-tick-event-count weak-doob-h seed-10))))
        (shuffled-guidance
          ((seed-7 (exp07-pilot-two-tick-event-count shuffled-guidance seed-7))
           (seed-8 (exp07-pilot-two-tick-event-count shuffled-guidance seed-8))
           (seed-9 (exp07-pilot-two-tick-event-count shuffled-guidance seed-9))
           (seed-10 (exp07-pilot-two-tick-event-count shuffled-guidance seed-10)))))
     productive-event-totals
       ((unguided (exp07-pilot-two-tick-arm-event-count unguided))
        (weak-doob-h (exp07-pilot-two-tick-arm-event-count weak-doob-h))
        (shuffled-guidance
          (exp07-pilot-two-tick-arm-event-count shuffled-guidance)))
     exact-replays
       ((unguided (exp07-pilot-two-tick-arm-replay-count unguided))
        (weak-doob-h (exp07-pilot-two-tick-arm-replay-count weak-doob-h))
        (shuffled-guidance
          (exp07-pilot-two-tick-arm-replay-count shuffled-guidance)))
     observed-result equal-arm-event-totals-with-different-seed-patterns
     outcome-boundary two-tick-productivity-and-replay-only
     emergence-claim none))

; Before running longer chemistry trajectories, verify that the replayable
; sampler realizes its declared categorical masses over a complete four-draw
; cycle.  Each fixed seed visits every bin exactly once over ticks 3--6, so
; these counts are an exact matched-arm gate rather than a noisy estimate.
(= (exp07-pilot-first-selected? $arm $seed $tick)
   (if (< (exp07-pilot-draw $seed $tick)
          (exp07-pilot-first-candidate-weight $arm))
       1
       0))

(= (exp07-pilot-four-tick-first-count $arm $seed)
   (+ (exp07-pilot-first-selected? $arm $seed 3)
      (+ (exp07-pilot-first-selected? $arm $seed 4)
         (+ (exp07-pilot-first-selected? $arm $seed 5)
            (exp07-pilot-first-selected? $arm $seed 6)))))

(= (exp07-pilot-ensemble-first-count $arm)
   (+ (exp07-pilot-four-tick-first-count $arm seed-7)
      (+ (exp07-pilot-four-tick-first-count $arm seed-8)
         (+ (exp07-pilot-four-tick-first-count $arm seed-9)
            (exp07-pilot-four-tick-first-count $arm seed-10)))))

(= (exp07-pilot-sampler-calibration)
   (sampler-calibration
     fixed-seeds (seed-7 seed-8 seed-9 seed-10)
     ticks (3 4 5 6)
     draws-per-arm 16
     first-candidate-counts
       ((unguided (exp07-pilot-ensemble-first-count unguided))
        (weak-doob-h (exp07-pilot-ensemble-first-count weak-doob-h))
        (shuffled-guidance
          (exp07-pilot-ensemble-first-count shuffled-guidance)))
     expected-counts ((unguided 8) (weak-doob-h 12)
                      (shuffled-guidance 4))
     replay exact-seed-tick
     current-boundary categorical-calibration-before-stateful-ensemble
     emergence-claim none))

; The exp05 fixtures were built around one deterministic selected candidate per
; seed.  Before treating them as a matched stochastic ensemble, audit whether
; every candidate reachable under the new categorical policy is actually
; applicable to the corresponding four-molecule chamber.  This predicate is a
; total, diagnostic mirror of exp00's four-molecule applicability shape; actual
; mutation still goes through `chamber-tick-with-candidate` above.
(= (exp07-pilot-candidate-fits-chamber?
      (candidate $candidate-tick
                 (rule $rule-id $a $b $product $catalyst)
                 $score)
      (chamber $chamber-id
               (state $state-tick $seed
                      (mol $state-a $a-count)
                      (mol $state-b $b-count)
                      (mol $state-product $product-count)
                      (mol $state-catalyst $catalyst-count))
               $rules
               $events))
   (and (== $candidate-tick $state-tick)
        (and (== $a $state-a)
             (and (== $b $state-b)
                  (and (== $product $state-product)
                       (and (== $catalyst $state-catalyst)
                            (and (> $a-count 0)
                                 (and (> $b-count 0)
                                      (> $catalyst-count 0)))))))))

(= (exp07-pilot-productive? $arm $seed)
   (exp07-pilot-candidate-fits-chamber?
     (exp07-pilot-selected-candidate $arm $seed)
     (exp07-pilot-chamber $arm $seed)))

(= (exp07-pilot-productive-int $arm $seed)
   (if (exp07-pilot-productive? $arm $seed) 1 0))

(= (exp07-pilot-productive-count $arm)
   (+ (exp07-pilot-productive-int $arm seed-7)
      (+ (exp07-pilot-productive-int $arm seed-8)
         (+ (exp07-pilot-productive-int $arm seed-9)
            (exp07-pilot-productive-int $arm seed-10)))))

(= (exp07-pilot-matched-productive? $arm $seed)
   (candidate-applicable-in-chamber?
     (exp07-pilot-selected-candidate $arm $seed)
     (exp07-pilot-matched-chamber $seed)))

(= (exp07-pilot-matched-productive-int $arm $seed)
   (if (exp07-pilot-matched-productive? $arm $seed) 1 0))

(= (exp07-pilot-matched-productive-count $arm)
   (+ (exp07-pilot-matched-productive-int $arm seed-7)
      (+ (exp07-pilot-matched-productive-int $arm seed-8)
         (+ (exp07-pilot-matched-productive-int $arm seed-9)
            (exp07-pilot-matched-productive-int $arm seed-10)))))

(= (exp07-pilot-matched-pool-applicable? $arm $seed)
   (let (candidate-pool $tick ($candidate-0 $candidate-1))
        (exp07-pilot-candidate-pool $arm $seed)
     (and (candidate-applicable-in-chamber?
            $candidate-0 (exp07-pilot-matched-chamber $seed))
          (candidate-applicable-in-chamber?
            $candidate-1 (exp07-pilot-matched-chamber $seed)))))

(= (exp07-pilot-matched-pool-applicable-int $arm $seed)
   (if (exp07-pilot-matched-pool-applicable? $arm $seed) 1 0))

(= (exp07-pilot-matched-pool-applicable-count $arm)
   (+ (exp07-pilot-matched-pool-applicable-int $arm seed-7)
      (+ (exp07-pilot-matched-pool-applicable-int $arm seed-8)
         (+ (exp07-pilot-matched-pool-applicable-int $arm seed-9)
            (exp07-pilot-matched-pool-applicable-int $arm seed-10)))))

(= (exp07-pilot-matched-applicability-audit)
   (fixture-applicability-audit
     fixed-seeds (seed-7 seed-8 seed-9 seed-10)
     draws-per-arm 4
     productive-draws
       ((unguided (exp07-pilot-matched-productive-count unguided))
        (weak-doob-h (exp07-pilot-matched-productive-count weak-doob-h))
        (shuffled-guidance
          (exp07-pilot-matched-productive-count shuffled-guidance)))
     fully-applicable-two-candidate-pools
       ((unguided (exp07-pilot-matched-pool-applicable-count unguided))
        (weak-doob-h
          (exp07-pilot-matched-pool-applicable-count weak-doob-h))
        (shuffled-guidance
          (exp07-pilot-matched-pool-applicable-count shuffled-guidance)))
     matched-fixture-gate passed
     initial-chemistry shared-seven-molecule-chamber
     chamber-ticking exp00-named-molecule-state
     current-boundary ready-for-stateful-ensemble
     emergence-claim none))

(= (exp07-pilot-fixture-applicability-audit)
   (fixture-applicability-audit
     fixed-seeds (seed-7 seed-8 seed-9 seed-10)
     draws-per-arm 4
     productive-draws ((unguided (exp07-pilot-productive-count unguided))
                       (weak-doob-h
                         (exp07-pilot-productive-count weak-doob-h))
                       (shuffled-guidance
                         (exp07-pilot-productive-count shuffled-guidance)))
     matched-fixture-gate failed
     reason exp05-fixtures-cover-only-their-original-deterministic-selection
     current-boundary do-not-run-stateful-ensemble-on-confounded-fixtures
     required-next matched-multi-molecule-chamber-applicability
     emergence-claim none))

(= (exp07-stochastic-pilot-contract)
   (stochastic-ensemble-contract
     arms (unguided weak-doob-h shuffled-guidance)
     fixed-seeds (seed-7 seed-8 seed-9 seed-10)
     tick 3
     categorical-denominator 4
     first-candidate-weights ((unguided 2)
                              (weak-doob-h 3)
                              (shuffled-guidance 1))
     candidate-cap 2
     candidate-source exp05-affinity-assigned-pools
     chamber-ticking exp00-chamber-tick-with-candidate
     catalysis-interface first-class-binary-relation
     required-outcomes (terminal-acs-raf-hit-rate first-hit-time persistence
                        productivity diversity-collapse intervention-path-cost
                        replay catalyst-ablation rule-ablation)
     terminal-forcing prohibited
     current-boundary matched-fixture-gate-passed-before-stateful-ensemble
     emergence-claim none))

; ----- Longer-horizon preregistration (2026-07-16 08:05 PDT) -----
;
; See experiments/exp07/PREREG.md for the full preregistration document.
; This atom is the PeTTa-native pointer; the Markdown file is authoritative.

(= (exp07-prereg-longer-horizon-gate)
   (preregistration
     date 2026-07-16-08:05-PDT
     author zerobot
     source protomegaBot-6-point-proposal
     supersedes two-tick-matched-ensemble-commit-28ddc28
     positive-control exp04-acs-rich-fixture
     positive-control-gate 20260716T022154Z-first-class-catalysis-exp04
     positive-control-requirement detector-must-fire-on-known-closing-raf
     horizon 20
     horizon-ticks (3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
     replenishment-cycle every-5-ticks
     replenishment-targets ((mol A 2) (mol B 1) (mol C 1))
     replenishment-ticks (8 13 18)
     arms (unguided weak-doob-h shuffled-guidance)
     fixed-seeds (seed-7 seed-8 seed-9 seed-10)
     candidate-cap 2
     primary-endpoint terminal-acs-raf-hit-rate
     secondary-endpoints (first-hit-time persistence productivity diversity-collapse)
     causal-validation catalyst-ablation
     emergence-claim-lift-condition guided-arm-acs-positive-and-both-controls-null-and-ablation-collapses
     pivot-positive-control-fail fix-detector-first
     pivot-all-arms-null chamber-redesign-not-rerun
     pivot-all-arms-positive pool-contamination-suspected
     pool-contamination-guard shuffled-arm-shares-exact-pool-composition
     no-peeking fixed-horizon-frozen-before-run
     emergence-claim none))

; ----- Pre-run pool-identity assertion (mandated by PREREG §6) -----
;
; Before any horizon-extension run, this check must fire and pass:
; for every arm/seed/tick, the candidate pool composition (source rules,
; candidates, catalyst assignments) must be identical across arms modulo
; the arm's selection weights.  This is the PeTTa-native gate that
; prevents engineered-pool contamination from confounding results.

(= (exp07-pool-identity-check-status)
   (pool-identity-check
     requirement identical-composition-across-arms-modulo-weights
     check-scope all-arm-seed-tick-triples-in-horizon
     pre-run-required true
     post-run-required true
     fail-action emergence-claim-none-regardless-of-outcome
     status not-yet-run))

; ----- Positive-control gate result (2026-07-16 08:13 PDT) -----
;
; The detector (experiments/exp04/run_rich_raf.py) is fully deterministic:
; maximal_raf_prune is iterative fixed-point elimination, greedy_minimize
; is first-rule-out greedy.  No seed or stochasticity in the detector itself.
;
; Gate criteria (all three required):
;   1. maximal_raf_size >= 1  (non-empty RAF in the known-closing fixture)
;   2. minimal_core_is_raf    (closure is non-degenerate, not a 1-rule artifact)
;   3. no_catalysis_maximal_raf_size == 0  (detector discriminates: empty catalysis -> zero)

(= (exp07-positive-control-gate-result)
   (positive-control-gate
     fixture exp04-acs-rich-fixture
     detector experiments/exp04/run_rich_raf.py
     run-time 2026-07-16-08:13-PDT
     maximal-raf-size 15
     minimal-core-size 2
     minimal-core (lCD lBCD2)
     minimal-core-is-raf true
     no-catalysis-maximal-raf-size 0
     deterministic true
     gate-criteria (maximal-raf-size-gte-1 minimal-core-is-raf no-catalysis-maximal-raf-size-eq-0)
     result pass
     horizon-extension-licensed true
     emergence-claim none))

; Separately labelled seeded dynamic positive-control fixture for detector
; regression checks. It is disjoint from the preregistered experimental arms:
; the canonical exp04 detector/facts are evaluated A -> B -> A, through two
; tick-history projections with identical detector inputs, and under static
; single-result/mutation guards. See check_detector_invariance.py.
(= (exp07-detector-invariance-fixture)
   (detector-invariance-fixture
     id exp07-seeded-dynamic-positive-control-seed-31
     seed seed-31
     detector experiments/exp04/run_rich_raf.py
     petta-facts src/chem_exp04.metta
     checks (call-order-invariance tick-path-invariance single-result-uniqueness)
     experimental-arms-inspected false
     frozen-horizon-changed false
     frozen-seeds-changed false
     frozen-endpoints-changed false
     emergence-claim none))
