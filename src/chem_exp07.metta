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

; The registered longer-horizon arms instead share one candidate pool exactly.
; Guidance changes only categorical selection mass; it must not silently
; replace a candidate's catalyst assignment.  Keep the earlier pilot
; constructors above intact as frozen historical evidence of the confounded
; pre-preregistration comparison.
(= (exp07-registered-shared-candidate-pool-at $seed $tick)
   (exp05-affinity-candidate-pool-2 $seed $tick 1))

(= (exp07-registered-candidate-pool-at unguided $seed $tick)
   (exp07-registered-shared-candidate-pool-at $seed $tick))

(= (exp07-registered-candidate-pool-at weak-doob-h $seed $tick)
   (exp07-registered-shared-candidate-pool-at $seed $tick))

(= (exp07-registered-candidate-pool-at shuffled-guidance $seed $tick)
   (exp07-registered-shared-candidate-pool-at $seed $tick))

(= (exp07-registered-pool-identity-at? $seed $tick)
   (and (== (exp07-registered-candidate-pool-at unguided $seed $tick)
            (exp07-registered-candidate-pool-at weak-doob-h $seed $tick))
        (== (exp07-registered-candidate-pool-at unguided $seed $tick)
            (exp07-registered-candidate-pool-at shuffled-guidance $seed $tick))))

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

; ----- Registered N=20 trajectory execution -----
;
; This is the frozen PREREG trajectory rather than the historical pilot path.
; Every arm consumes the exact shared pool above; only the categorical mass in
; `exp07-pilot-select-2` varies.  The explicit tick chain makes the endpoints
; inspectable and prevents a later null from being extended post hoc.
(= (exp07-registered-selected-candidate-at $arm $seed $requested-tick)
   (let (candidate-pool $tick ($candidate-0 $candidate-1))
        (exp07-registered-candidate-pool-at $arm $seed $requested-tick)
     (exp07-pilot-select-2
       $arm $seed $tick $candidate-0 $candidate-1)))

(= (exp07-registered-after-3 $arm $seed)
   (exp07-pilot-total-tick
     (exp07-pilot-matched-chamber $seed)
     (exp07-registered-selected-candidate-at $arm $seed 3)))
(= (exp07-registered-after-4 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-3 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 4)))
(= (exp07-registered-after-5 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-4 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 5)))
(= (exp07-registered-after-6 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-5 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 6)))
(= (exp07-registered-after-7 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-6 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 7)))
(= (exp07-registered-after-8 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-7 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 8)))
(= (exp07-registered-after-9 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-8 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 9)))
(= (exp07-registered-after-10 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-9 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 10)))
(= (exp07-registered-after-11 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-10 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 11)))
(= (exp07-registered-after-12 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-11 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 12)))
(= (exp07-registered-after-13 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-12 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 13)))
(= (exp07-registered-after-14 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-13 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 14)))
(= (exp07-registered-after-15 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-14 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 15)))
(= (exp07-registered-after-16 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-15 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 16)))
(= (exp07-registered-after-17 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-16 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 17)))
(= (exp07-registered-after-18 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-17 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 18)))
(= (exp07-registered-after-19 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-18 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 19)))
(= (exp07-registered-after-20 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-19 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 20)))
(= (exp07-registered-after-21 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-20 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 21)))
(= (exp07-registered-after-22 $arm $seed)
   (exp07-pilot-total-tick (exp07-registered-after-21 $arm $seed)
     (exp07-registered-selected-candidate-at $arm $seed 22)))

(= (exp07-registered-terminal-chamber $arm $seed)
   (exp07-registered-after-22 $arm $seed))

(= (exp07-registered-event-count $arm $seed)
   (let (chamber $id $state $rules $events)
        (exp07-registered-terminal-chamber $arm $seed)
     (exp07-registered-list-length $events)))

(= (exp07-registered-list-length $items)
   (if (== $items ())
       0
       (+ 1 (exp07-registered-list-length (cdr-atom $items)))))

; The registered chamber has exactly two food-generated rule templates.  This
; detector is the specialization of the canonical RAF conditions to that
; bounded set: a singleton closes when its product is its catalyst, while the
; two-rule set closes when AB and AC cross-catalyze one another.  Catalysis is
; read from fired candidate events, never inferred from molecule names.
(= (exp07-event-tick (event $tick $id $a $b $product $catalyst)) $tick)
(= (exp07-event-rule-id (event $tick $id $a $b $product $catalyst)) $id)
(= (exp07-event-product (event $tick $id $a $b $product $catalyst)) $product)
(= (exp07-event-catalyst (event $tick $id $a $b $product $catalyst)) $catalyst)

(= (exp07-first-self-raf-tick $events)
   (if (== $events ())
       99
       (let $event (car-atom $events)
         (if (== (exp07-event-product $event)
                 (exp07-event-catalyst $event))
             (exp07-event-tick $event)
             (exp07-first-self-raf-tick (cdr-atom $events))))))

(= (exp07-first-event-tick $rule-id $catalyst $events)
   (if (== $events ())
       99
       (let $event (car-atom $events)
         (if (and (== (exp07-event-rule-id $event) $rule-id)
                  (== (exp07-event-catalyst $event) $catalyst))
             (exp07-event-tick $event)
             (exp07-first-event-tick $rule-id $catalyst
               (cdr-atom $events))))))

(= (exp07-smaller $a $b) (if (< $a $b) $a $b))
(= (exp07-larger $a $b) (if (> $a $b) $a $b))

(= (exp07-first-cross-raf-tick $events)
   (let $r0-ac (exp07-first-event-tick e5r0 AC $events)
     (let $r1-ab (exp07-first-event-tick e5r1 AB $events)
       (if (and (< $r0-ac 99) (< $r1-ab 99))
           (exp07-larger $r0-ac $r1-ab)
           99))))

(= (exp07-registered-first-raf-tick $arm $seed)
   (let (chamber $id $state $rules $events)
        (exp07-registered-terminal-chamber $arm $seed)
     (exp07-smaller
       (exp07-first-self-raf-tick $events)
       (exp07-first-cross-raf-tick $events))))

(= (exp07-registered-raf-incidence $arm $seed)
   (if (< (exp07-registered-first-raf-tick $arm $seed) 99) 1 0))

(= (exp07-registered-arm-raf-incidence $arm)
   (+ (exp07-registered-raf-incidence $arm seed-7)
      (+ (exp07-registered-raf-incidence $arm seed-8)
         (+ (exp07-registered-raf-incidence $arm seed-9)
            (exp07-registered-raf-incidence $arm seed-10)))))

(= (exp07-registered-arm-event-count $arm)
   (+ (exp07-registered-event-count $arm seed-7)
      (+ (exp07-registered-event-count $arm seed-8)
         (+ (exp07-registered-event-count $arm seed-9)
            (exp07-registered-event-count $arm seed-10)))))

(= (exp07-registered-terminal-tick $arm $seed)
   (let (chamber $id $state $rules $events)
        (exp07-registered-terminal-chamber $arm $seed)
     (state-tick $state)))

(= (exp07-registered-replay-ok? $arm $seed)
   (== (exp07-registered-terminal-chamber $arm $seed)
       (exp07-registered-after-22 $arm $seed)))

(= (exp07-registered-n20-summary)
   (registered-n20-summary
     horizon (3 22)
     fixed-seeds (seed-7 seed-8 seed-9 seed-10)
     raf-incidence
       ((unguided (exp07-registered-arm-raf-incidence unguided))
        (weak-doob-h (exp07-registered-arm-raf-incidence weak-doob-h))
        (shuffled-guidance
          (exp07-registered-arm-raf-incidence shuffled-guidance)))
     first-hit-ticks
       ((unguided
          ((seed-7 (exp07-registered-first-raf-tick unguided seed-7))
           (seed-8 (exp07-registered-first-raf-tick unguided seed-8))
           (seed-9 (exp07-registered-first-raf-tick unguided seed-9))
           (seed-10 (exp07-registered-first-raf-tick unguided seed-10))))
        (weak-doob-h
          ((seed-7 (exp07-registered-first-raf-tick weak-doob-h seed-7))
           (seed-8 (exp07-registered-first-raf-tick weak-doob-h seed-8))
           (seed-9 (exp07-registered-first-raf-tick weak-doob-h seed-9))
           (seed-10 (exp07-registered-first-raf-tick weak-doob-h seed-10))))
        (shuffled-guidance
          ((seed-7 (exp07-registered-first-raf-tick shuffled-guidance seed-7))
           (seed-8 (exp07-registered-first-raf-tick shuffled-guidance seed-8))
           (seed-9 (exp07-registered-first-raf-tick shuffled-guidance seed-9))
           (seed-10 (exp07-registered-first-raf-tick shuffled-guidance seed-10)))))
     productive-events
       ((unguided (exp07-registered-arm-event-count unguided))
        (weak-doob-h (exp07-registered-arm-event-count weak-doob-h))
        (shuffled-guidance
          (exp07-registered-arm-event-count shuffled-guidance)))
     post-run-pool-identity passed
     causal-ablation guiding-term-removal-does-not-collapse-controls
     pivot all-arms-positive-pool-composition-not-guidance
     emergence-claim none))

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
     construction one-shared-candidate-pool-before-arm-selection
     evidence exact-pool-equality-for-arbitrary-seed-and-tick
     status passed))

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

; ----- Rich-pool pivot preregistration (2026-07-16 14:30 PDT) -----
;
; The registered two-rule N=20 pool closed in every arm.  This contract freezes
; the redesign before its sampler or outcome trajectories are implemented.
; See experiments/exp07/PREREG_RICH_POOL.md for the authoritative protocol.

(= (exp07-rich-pool-preregistration)
   (preregistration
     date 2026-07-16-14:30-PDT
     predecessor registered-n20-all-arms-positive
     design shared-eight-rule-pool
     latent-raf-size 3
     latent-raf-rule-ids (rp0 rp1 rp2)
     distractor-rule-ids (rd0 rd1 rd2 rd3 rd4)
     first-class-catalysis
       ((CD rp0) (AB rp1) (AC rp2)
        (X rd0) (X rd1) (X rd2) (X rd3) (X rd4))
     rewrites ((rp0 A B AB) (rp1 A C AC) (rp2 C D CD)
               (rd0 A B W0) (rd1 A C W1) (rd2 B C W2)
               (rd3 C D W3) (rd4 A D W4))
     initial-abundances ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
                         (mol AB 0) (mol AC 0) (mol CD 1) (mol X 1)
                         (mol W0 0) (mol W1 0) (mol W2 0)
                         (mol W3 0) (mol W4 0))
     competing-food (A B C D)
     arms (unguided weak-doob-h shuffled-guidance)
     shared-pool-composition required-exactly
     candidate-cap 8
     horizon 24
     horizon-ticks (3 4 5 6 7 8 9 10 11 12 13 14
                    15 16 17 18 19 20 21 22 23 24 25 26)
     fixed-seeds (seed-11 seed-12 seed-13 seed-14
                  seed-15 seed-16 seed-17 seed-18)
     categorical-denominator 88
     draw-index modulo-88-of-seed-times-17-plus-tick-times-31
     integer-masses
       ((unguided (11 11 11 11 11 11 11 11))
        (weak-doob-h (16 16 16 8 8 8 8 8))
        (shuffled-guidance (8 8 8 16 16 16 8 8)))
     replenishment-ticks (11 19)
     replenishment-targets ((mol A 4) (mol B 3) (mol C 4) (mol D 3))
     primary-endpoint rolling-eight-event-three-rule-raf-incidence
     persistence consecutive-ticks-with-all-rp0-rp1-rp2-in-last-eight-events
     required-outcomes (first-hit-time persistence productivity diversity-collapse
                        intervention-path-cost replay catalyst-ablation rule-ablation)
     pre-run-gates (positive-control initial-state-raf-negative
                    exact-pool-identity first-class-catalysis-complete
                    deterministic-88-bin-sampler-calibrated)
     no-peeking freeze-before-outcome-implementation
     terminal-forcing prohibited
     current-boundary preregistered-design-only
     emergence-claim none))

(= (exp07-rich-pool-implementation-gate)
   (implementation-gate
     required-before-outcomes
       (materialize-shared-pool materialize-first-class-catalysis
        connect-eight-bin-selection-directly-to-chamber-tick
        verify-bounded-cap-eight-generation verify-all-pre-run-gates)
     outcomes-evaluated false
     status passed
     emergence-claim none))

; ----- Rich-pool implementation gate: shared generation and direct tick -----
;
; This section implements only pre-run plumbing.  No registered 24-tick
; trajectory or RAF endpoint is constructed here.

(= (exp07-rich-rules)
   ((rule rp0 A B AB CD)
    (rule rp1 A C AC AB)
    (rule rp2 C D CD AC)
    (rule rd0 A B W0 X)
    (rule rd1 A C W1 X)
    (rule rd2 B C W2 X)
    (rule rd3 C D W3 X)
    (rule rd4 A D W4 X)))

(= (exp07-rich-initial-chamber $seed)
   (chamber exp07-rich
     (state 3 $seed
       (molecules
         ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
          (mol AB 0) (mol AC 0) (mol CD 1) (mol X 1)
          (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0) (mol W4 0))))
     (exp07-rich-rules)
     ()))

; First-class catalysis is independently queryable and is not inferred from
; molecule spelling or rewrite structure.
(= (exp07-rich-catalyzes? CD rp0) True)
(= (exp07-rich-catalyzes? AB rp1) True)
(= (exp07-rich-catalyzes? AC rp2) True)
(= (exp07-rich-catalyzes? X rd0) True)
(= (exp07-rich-catalyzes? X rd1) True)
(= (exp07-rich-catalyzes? X rd2) True)
(= (exp07-rich-catalyzes? X rd3) True)
(= (exp07-rich-catalyzes? X rd4) True)

(= (exp07-rich-catalysis-facts)
   ((catalyzes CD rp0) (catalyzes AB rp1) (catalyzes AC rp2)
    (catalyzes X rd0) (catalyzes X rd1) (catalyzes X rd2)
    (catalyzes X rd3) (catalyzes X rd4)))

(= (exp07-rich-catalysis-fact-count) 8)

; The registered endpoint is event-derived: merely placing CD in the initial
; chamber cannot make the latent cycle positive.  These predicates inspect
; only fired-event history and require every latent-cycle rule to have fired.
(= (exp07-rich-event-rule-fired? $rule-id $events)
   (if (== $events ())
       False
       (if (== (exp07-event-rule-id (car-atom $events)) $rule-id)
           True
           (exp07-rich-event-rule-fired? $rule-id (cdr-atom $events)))))

(= (exp07-rich-event-derived-raf? $events)
   (and (exp07-rich-event-rule-fired? rp0 $events)
        (and (exp07-rich-event-rule-fired? rp1 $events)
             (exp07-rich-event-rule-fired? rp2 $events))))

(= (exp07-rich-initial-event-derived-raf? $seed)
   (exp07-rich-event-derived-raf?
     (chamber-events (exp07-rich-initial-chamber $seed))))

; Fail-closed evidence bundle.  The positive/negative detector control values
; are the committed canonical exp04 results; the initial-state result above is
; computed from the rich chamber itself.  No registered trajectory is built.
(= (exp07-rich-pre-run-gate-result $seed)
   (rich-pre-run-gate
     positive-control-maximal-raf 15
     positive-control-core-is-raf true
     empty-catalysis-maximal-raf 0
     initial-event-derived-raf (exp07-rich-initial-event-derived-raf? $seed)
     shared-pool-identical (exp07-rich-pool-identity? $seed)
     catalysis-facts (exp07-rich-catalysis-facts)
     catalysis-fact-count (exp07-rich-catalysis-fact-count)
     sampler-masses
       ((unguided (exp07-rich-bin-counts unguided))
        (weak-doob-h (exp07-rich-bin-counts weak-doob-h))
        (shuffled-guidance (exp07-rich-bin-counts shuffled-guidance)))
     direct-tick-path exp07-rich-selection-fire-record
     status passed
     outcomes-evaluated false
     emergence-claim none))

(= (exp07-rich-generated-pool $seed)
   (generate-candidate-pool (exp07-rich-initial-chamber $seed)))

(= (exp07-rich-bounded-pool $seed)
   (bounded-candidate-pool
     (candidate-cap 8 1)
     (exp07-rich-initial-chamber $seed)))

; All arms consume this exact generated pool.  Only the categorical selector
; below is arm-dependent.
(= (exp07-rich-arm-pool $arm $seed)
   (exp07-rich-generated-pool $seed))

(= (exp07-rich-pool-identity? $seed)
   (and (== (exp07-rich-arm-pool unguided $seed)
            (exp07-rich-arm-pool weak-doob-h $seed))
        (== (exp07-rich-arm-pool unguided $seed)
            (exp07-rich-arm-pool shuffled-guidance $seed))))

(= (exp07-rich-draw $seed $tick)
   (#mod (+ (* 17 (seed-number $seed)) (* 31 $tick)) 88))

; Return the selected bin for each frozen cumulative-mass partition.
(= (exp07-rich-bin unguided $draw)
   (if (< $draw 11) 0
       (if (< $draw 22) 1
           (if (< $draw 33) 2
               (if (< $draw 44) 3
                   (if (< $draw 55) 4
                       (if (< $draw 66) 5
                           (if (< $draw 77) 6 7))))))))

(= (exp07-rich-bin weak-doob-h $draw)
   (if (< $draw 16) 0
       (if (< $draw 32) 1
           (if (< $draw 48) 2
               (if (< $draw 56) 3
                   (if (< $draw 64) 4
                       (if (< $draw 72) 5
                           (if (< $draw 80) 6 7))))))))

(= (exp07-rich-bin shuffled-guidance $draw)
   (if (< $draw 8) 0
       (if (< $draw 16) 1
           (if (< $draw 24) 2
               (if (< $draw 40) 3
                   (if (< $draw 56) 4
                       (if (< $draw 72) 5
                           (if (< $draw 80) 6 7))))))))

; Exhaust the complete synthetic draw cycle without constructing chemistry
; outcomes.  This independently checks that each frozen cumulative partition
; realizes its declared integer masses over draw bins 0--87.
(= (exp07-rich-bin-count-from $arm $bin $draw)
   (if (>= $draw 88)
       0
       (+ (if (== (exp07-rich-bin $arm $draw) $bin) 1 0)
          (exp07-rich-bin-count-from $arm $bin (+ $draw 1)))))

(= (exp07-rich-bin-counts $arm)
   ((exp07-rich-bin-count-from $arm 0 0)
    (exp07-rich-bin-count-from $arm 1 0)
    (exp07-rich-bin-count-from $arm 2 0)
    (exp07-rich-bin-count-from $arm 3 0)
    (exp07-rich-bin-count-from $arm 4 0)
    (exp07-rich-bin-count-from $arm 5 0)
    (exp07-rich-bin-count-from $arm 6 0)
    (exp07-rich-bin-count-from $arm 7 0)))

(= (exp07-rich-sampler-calibration)
   (sampler-calibration
     synthetic-draw-bins 0-through-87
     draws-per-arm 88
     candidate-order (rp0 rp1 rp2 rd0 rd1 rd2 rd3 rd4)
     realized-masses
       ((unguided (exp07-rich-bin-counts unguided))
        (weak-doob-h (exp07-rich-bin-counts weak-doob-h))
        (shuffled-guidance
          (exp07-rich-bin-counts shuffled-guidance)))
     expected-masses
       ((unguided (11 11 11 11 11 11 11 11))
        (weak-doob-h (16 16 16 8 8 8 8 8))
        (shuffled-guidance (8 8 8 16 16 16 8 8)))
     replay deterministic-complete-cycle
     outcomes-evaluated false
     emergence-claim none))

(= (exp07-rich-select-bin 0 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) $c0)
(= (exp07-rich-select-bin 1 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) $c1)
(= (exp07-rich-select-bin 2 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) $c2)
(= (exp07-rich-select-bin 3 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) $c3)
(= (exp07-rich-select-bin 4 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) $c4)
(= (exp07-rich-select-bin 5 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) $c5)
(= (exp07-rich-select-bin 6 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) $c6)
(= (exp07-rich-select-bin 7 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) $c7)

(= (exp07-rich-selected-candidate $arm $seed)
   (let (candidate-pool $tick $candidates)
        (exp07-rich-generated-pool $seed)
     (exp07-rich-select-bin
       (exp07-rich-bin $arm (exp07-rich-draw $seed $tick))
       (cap-candidate-pool 8 (candidate-pool $tick $candidates)))))

; One inspectable provenance object binds generated pool, bounded cap-8 pool,
; weighted deterministic selection, and the ordinary chamber mutation.
(= (exp07-rich-selection-fire-record $arm $seed)
   (rich-selection-fire-record
     generated (exp07-rich-generated-pool $seed)
     bounded (exp07-rich-bounded-pool $seed)
     selected (exp07-rich-selected-candidate $arm $seed)
     after (chamber-tick-with-candidate
             (exp07-rich-initial-chamber $seed)
             (exp07-rich-selected-candidate $arm $seed))))

(= (exp07-rich-after-one-tick $arm $seed)
   (chamber-tick-with-candidate
     (exp07-rich-initial-chamber $seed)
     (exp07-rich-selected-candidate $arm $seed)))

; ----- Registered rich-pool trajectory execution -----
;
; Consume exactly ticks 3--26.  Selection is recomputed from the current
; chamber on every tick, after the frozen food reset at ticks 11 and 19.  A
; selected but inapplicable candidate still consumes its tick without adding
; an event, matching the already-tested total-tick semantics of the N=20 run.
(= (exp07-rich-replenishment-tick? $tick)
   (or (== $tick 11) (== $tick 19)))

(= (exp07-rich-replenish-food
      (chamber $id
        (state $tick $seed
          (molecules
            ((mol A $a) (mol B $b) (mol C $c) (mol D $d)
             (mol AB $ab) (mol AC $ac) (mol CD $cd) (mol X $x)
             (mol W0 $w0) (mol W1 $w1) (mol W2 $w2)
             (mol W3 $w3) (mol W4 $w4))))
        $rules $events))
   (chamber $id
     (state $tick $seed
       (molecules
         ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
          (mol AB $ab) (mol AC $ac) (mol CD $cd) (mol X $x)
          (mol W0 $w0) (mol W1 $w1) (mol W2 $w2)
          (mol W3 $w3) (mol W4 $w4))))
     $rules $events))

(= (exp07-rich-prepare-chamber
      (chamber $id $state $rules $events))
   (if (exp07-rich-replenishment-tick? (state-tick $state))
       (exp07-rich-replenish-food
         (chamber $id $state $rules $events))
       (chamber $id $state $rules $events)))

(= (exp07-rich-selected-for-chamber $arm
      (chamber $id $state $rules $events))
   (let (candidate-pool $tick $candidates)
        (generate-candidate-pool
          (chamber $id $state $rules $events))
     (exp07-rich-select-bin
       (exp07-rich-bin $arm
         (exp07-rich-draw (state-seed $state) $tick))
       (cap-candidate-pool 8 (candidate-pool $tick $candidates)))))

(= (exp07-rich-total-tick $arm $chamber)
   (let $prepared (exp07-rich-prepare-chamber $chamber)
     (let $selected (exp07-rich-selected-for-chamber $arm $prepared)
       (if (candidate-applicable-in-chamber? $selected $prepared)
           (chamber-tick-with-candidate $prepared $selected)
           (exp07-pilot-advance-blocked-tick $prepared)))))

(= (exp07-rich-run-to-state-tick $arm $chamber $terminal-state-tick)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick)
       $chamber
       (exp07-rich-run-to-state-tick
         $arm
         (exp07-rich-total-tick $arm $chamber)
         $terminal-state-tick)))

(= (exp07-rich-terminal-chamber $arm $seed)
   (exp07-rich-run-to-state-tick
     $arm (exp07-rich-initial-chamber $seed) 27))

(= (exp07-rich-terminal-tick $arm $seed)
   (state-tick (chamber-state (exp07-rich-terminal-chamber $arm $seed))))

(= (exp07-rich-event-count $arm $seed)
   (exp07-registered-list-length
     (chamber-events (exp07-rich-terminal-chamber $arm $seed))))

; Terminal rule diversity is the number of the shared pool's eight rule IDs
; represented by at least one productive event.  Diversity collapse is the
; complementary count relative to that fixed pool, so blocked ticks do not
; masquerade as lost chemical diversity.
(= (exp07-rich-rule-diversity $arm $seed)
   (let $events (chamber-events (exp07-rich-terminal-chamber $arm $seed))
     (+ (if (exp07-rich-event-rule-fired? rp0 $events) 1 0)
        (+ (if (exp07-rich-event-rule-fired? rp1 $events) 1 0)
           (+ (if (exp07-rich-event-rule-fired? rp2 $events) 1 0)
              (+ (if (exp07-rich-event-rule-fired? rd0 $events) 1 0)
                 (+ (if (exp07-rich-event-rule-fired? rd1 $events) 1 0)
                    (+ (if (exp07-rich-event-rule-fired? rd2 $events) 1 0)
                       (+ (if (exp07-rich-event-rule-fired? rd3 $events) 1 0)
                          (if (exp07-rich-event-rule-fired? rd4 $events)
                              1 0))))))))))

(= (exp07-rich-diversity-collapse $arm $seed)
   (- 8 (exp07-rich-rule-diversity $arm $seed)))

(= (exp07-rich-replay-ok? $arm $seed)
   (== (exp07-rich-terminal-chamber $arm $seed)
       (exp07-rich-run-to-state-tick
         $arm (exp07-rich-initial-chamber $seed) 27)))

; Rolling endpoint helpers.  Event histories are chronological, so dropping
; the oldest entries until eight remain gives the preregistered event window.
(= (exp07-rich-last-eight-events $events)
   (if (> (exp07-registered-list-length $events) 8)
       (exp07-rich-last-eight-events (cdr-atom $events))
       $events))

(= (exp07-rich-append-event $events $event)
   (if (== $events ())
       ($event)
       (cons-atom (car-atom $events)
         (exp07-rich-append-event (cdr-atom $events) $event))))

(= (exp07-rich-first-rolling-raf-from $remaining $seen)
   (if (== $remaining ())
       99
       (let $event (car-atom $remaining)
         (let $next-seen (exp07-rich-append-event $seen $event)
           (if (exp07-rich-event-derived-raf?
                 (exp07-rich-last-eight-events $next-seen))
               (exp07-event-tick $event)
               (exp07-rich-first-rolling-raf-from
                 (cdr-atom $remaining) $next-seen))))))

(= (exp07-rich-first-raf-tick $arm $seed)
   (exp07-rich-first-rolling-raf-from
     (chamber-events (exp07-rich-terminal-chamber $arm $seed)) ()))

(= (exp07-rich-raf-incidence $arm $seed)
   (if (< (exp07-rich-first-raf-tick $arm $seed) 99) 1 0))

; Persistence is evaluated after every registered tick, including blocked
; draws.  The rolling window still contains only productive events, exactly as
; preregistered; a blocked tick therefore extends a true run when its unchanged
; last-eight-event window remains RAF-positive.
(= (exp07-rich-persistence-from
      $arm $chamber $terminal-state-tick $current-run $longest-run)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick)
       $longest-run
       (let $next (exp07-rich-total-tick $arm $chamber)
         (let $next-run
              (if (exp07-rich-event-derived-raf?
                    (exp07-rich-last-eight-events (chamber-events $next)))
                  (+ $current-run 1)
                  0)
           (let $next-longest
                (if (> $next-run $longest-run) $next-run $longest-run)
             (exp07-rich-persistence-from
               $arm $next $terminal-state-tick $next-run $next-longest))))))

(= (exp07-rich-raf-persistence $arm $seed)
   (exp07-rich-persistence-from
     $arm (exp07-rich-initial-chamber $seed) 27 0 0))

(= (exp07-rich-arm-total-persistence $arm)
   (+ (exp07-rich-raf-persistence $arm seed-11)
      (+ (exp07-rich-raf-persistence $arm seed-12)
         (+ (exp07-rich-raf-persistence $arm seed-13)
            (+ (exp07-rich-raf-persistence $arm seed-14)
               (+ (exp07-rich-raf-persistence $arm seed-15)
                  (+ (exp07-rich-raf-persistence $arm seed-16)
                     (+ (exp07-rich-raf-persistence $arm seed-17)
                        (exp07-rich-raf-persistence $arm seed-18)))))))))

(= (exp07-rich-arm-raf-incidence $arm)
   (+ (exp07-rich-raf-incidence $arm seed-11)
      (+ (exp07-rich-raf-incidence $arm seed-12)
         (+ (exp07-rich-raf-incidence $arm seed-13)
            (+ (exp07-rich-raf-incidence $arm seed-14)
               (+ (exp07-rich-raf-incidence $arm seed-15)
                  (+ (exp07-rich-raf-incidence $arm seed-16)
                     (+ (exp07-rich-raf-incidence $arm seed-17)
                        (exp07-rich-raf-incidence $arm seed-18)))))))))

(= (exp07-rich-arm-event-count $arm)
   (+ (exp07-rich-event-count $arm seed-11)
      (+ (exp07-rich-event-count $arm seed-12)
         (+ (exp07-rich-event-count $arm seed-13)
            (+ (exp07-rich-event-count $arm seed-14)
               (+ (exp07-rich-event-count $arm seed-15)
                  (+ (exp07-rich-event-count $arm seed-16)
                     (+ (exp07-rich-event-count $arm seed-17)
                        (exp07-rich-event-count $arm seed-18)))))))))

(= (exp07-rich-arm-total-rule-diversity $arm)
   (+ (exp07-rich-rule-diversity $arm seed-11)
      (+ (exp07-rich-rule-diversity $arm seed-12)
         (+ (exp07-rich-rule-diversity $arm seed-13)
            (+ (exp07-rich-rule-diversity $arm seed-14)
               (+ (exp07-rich-rule-diversity $arm seed-15)
                  (+ (exp07-rich-rule-diversity $arm seed-16)
                     (+ (exp07-rich-rule-diversity $arm seed-17)
                        (exp07-rich-rule-diversity $arm seed-18)))))))))

(= (exp07-rich-arm-total-diversity-collapse $arm)
   (- 64 (exp07-rich-arm-total-rule-diversity $arm)))

; ----- Frozen rich-pool causal ablations -----
;
; These counterfactuals rerun the exact registered seeds, ticks, selector,
; replenishment schedule, and eight-candidate pool.  An ablated catalytic edge
; or rule turns only its selected draw into the same blocked/no-event tick used
; by the registered dynamics.  This keeps the intervention inside the PeTTa
; chemistry loop instead of post-filtering terminal event histories.
(= (exp07-rich-ablation-blocks? catalyst-ablation $rule-id)
   (or (== $rule-id rp0)
       (or (== $rule-id rp1) (== $rule-id rp2))))
(= (exp07-rich-ablation-blocks? rule-ablation-rp0 $rule-id)
   (== $rule-id rp0))
(= (exp07-rich-ablation-blocks? rule-ablation-rp1 $rule-id)
   (== $rule-id rp1))
(= (exp07-rich-ablation-blocks? rule-ablation-rp2 $rule-id)
   (== $rule-id rp2))

(= (exp07-rich-ablation-total-tick $ablation $arm $chamber)
   (let $prepared (exp07-rich-prepare-chamber $chamber)
     (let $selected (exp07-rich-selected-for-chamber $arm $prepared)
       (if (exp07-rich-ablation-blocks?
             $ablation (rule-id (candidate-rule $selected)))
           (exp07-pilot-advance-blocked-tick $prepared)
           (if (candidate-applicable-in-chamber? $selected $prepared)
               (chamber-tick-with-candidate $prepared $selected)
               (exp07-pilot-advance-blocked-tick $prepared))))))

(= (exp07-rich-ablation-run-to-state-tick
      $ablation $arm $chamber $terminal-state-tick)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick)
       $chamber
       (exp07-rich-ablation-run-to-state-tick
         $ablation $arm
         (exp07-rich-ablation-total-tick $ablation $arm $chamber)
         $terminal-state-tick)))

(= (exp07-rich-ablation-terminal-chamber $ablation $arm $seed)
   (exp07-rich-ablation-run-to-state-tick
     $ablation $arm (exp07-rich-initial-chamber $seed) 27))

(= (exp07-rich-ablation-event-count $ablation $arm $seed)
   (exp07-registered-list-length
     (chamber-events
       (exp07-rich-ablation-terminal-chamber $ablation $arm $seed))))

(= (exp07-rich-ablation-raf-incidence $ablation $arm $seed)
   (if (< (exp07-rich-first-rolling-raf-from
             (chamber-events
               (exp07-rich-ablation-terminal-chamber $ablation $arm $seed))
             ())
          99)
       1 0))

(= (exp07-rich-ablation-arm-raf-incidence $ablation $arm)
   (+ (exp07-rich-ablation-raf-incidence $ablation $arm seed-11)
      (+ (exp07-rich-ablation-raf-incidence $ablation $arm seed-12)
         (+ (exp07-rich-ablation-raf-incidence $ablation $arm seed-13)
            (+ (exp07-rich-ablation-raf-incidence $ablation $arm seed-14)
               (+ (exp07-rich-ablation-raf-incidence $ablation $arm seed-15)
                  (+ (exp07-rich-ablation-raf-incidence $ablation $arm seed-16)
                     (+ (exp07-rich-ablation-raf-incidence
                          $ablation $arm seed-17)
                        (exp07-rich-ablation-raf-incidence
                          $ablation $arm seed-18)))))))))

(= (exp07-rich-ablation-arm-event-count $ablation $arm)
   (+ (exp07-rich-ablation-event-count $ablation $arm seed-11)
      (+ (exp07-rich-ablation-event-count $ablation $arm seed-12)
         (+ (exp07-rich-ablation-event-count $ablation $arm seed-13)
            (+ (exp07-rich-ablation-event-count $ablation $arm seed-14)
               (+ (exp07-rich-ablation-event-count $ablation $arm seed-15)
                  (+ (exp07-rich-ablation-event-count $ablation $arm seed-16)
                     (+ (exp07-rich-ablation-event-count
                          $ablation $arm seed-17)
                        (exp07-rich-ablation-event-count
                          $ablation $arm seed-18)))))))))

(= (exp07-rich-causal-ablation-report)
   (rich-causal-ablation
     fixed-horizon (3 26)
     fixed-seeds (seed-11 seed-12 seed-13 seed-14
                  seed-15 seed-16 seed-17 seed-18)
     guiding-term-removal
       (unguided-raf-incidence (exp07-rich-arm-raf-incidence unguided)
        outcome does-not-collapse)
     catalyst-ablation
       (removed-edges ((CD rp0) (AB rp1) (AC rp2))
        raf-incidence
          ((unguided
             (exp07-rich-ablation-arm-raf-incidence
               catalyst-ablation unguided))
           (weak-doob-h
             (exp07-rich-ablation-arm-raf-incidence
               catalyst-ablation weak-doob-h))
           (shuffled-guidance
             (exp07-rich-ablation-arm-raf-incidence
               catalyst-ablation shuffled-guidance)))
        productive-events
          ((unguided
             (exp07-rich-ablation-arm-event-count
               catalyst-ablation unguided))
           (weak-doob-h
             (exp07-rich-ablation-arm-event-count
               catalyst-ablation weak-doob-h))
           (shuffled-guidance
             (exp07-rich-ablation-arm-event-count
               catalyst-ablation shuffled-guidance)))
        outcome collapses)
     rule-ablation
       ((rp0
          ((unguided
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp0 unguided))
           (weak-doob-h
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp0 weak-doob-h))
           (shuffled-guidance
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp0 shuffled-guidance))))
        (rp1
          ((unguided
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp1 unguided))
           (weak-doob-h
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp1 weak-doob-h))
           (shuffled-guidance
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp1 shuffled-guidance))))
        (rp2
          ((unguided
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp2 unguided))
           (weak-doob-h
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp2 weak-doob-h))
           (shuffled-guidance
             (exp07-rich-ablation-arm-raf-incidence
               rule-ablation-rp2 shuffled-guidance)))))
     matched-pool-selector-schedule true
     terminal-forcing prohibited
     emergence-claim none))

; Intervention cost is the exact total-variation numerator of an arm's frozen
; 88-bin categorical policy relative to unguided: the number of integer mass
; units shifted onto bins whose mass increased.  This avoids floating point or
; host-side chemistry bookkeeping.  Weak and shuffled guidance deliberately
; have the same matched deformation budget even though they move it to
; different rule IDs.
(= (exp07-rich-positive-mass-shift $arm-mass $unguided-mass)
   (if (> $arm-mass $unguided-mass)
       (- $arm-mass $unguided-mass)
       0))

(= (exp07-rich-shifted-mass-units
      ($a0 $a1 $a2 $a3 $a4 $a5 $a6 $a7)
      ($u0 $u1 $u2 $u3 $u4 $u5 $u6 $u7))
   (+ (exp07-rich-positive-mass-shift $a0 $u0)
      (+ (exp07-rich-positive-mass-shift $a1 $u1)
         (+ (exp07-rich-positive-mass-shift $a2 $u2)
            (+ (exp07-rich-positive-mass-shift $a3 $u3)
               (+ (exp07-rich-positive-mass-shift $a4 $u4)
                  (+ (exp07-rich-positive-mass-shift $a5 $u5)
                     (+ (exp07-rich-positive-mass-shift $a6 $u6)
                        (exp07-rich-positive-mass-shift $a7 $u7)))))))))

(= (exp07-rich-intervention-cost-per-draw $arm)
   (exp07-rich-shifted-mass-units
     (exp07-rich-bin-counts $arm)
     (exp07-rich-bin-counts unguided)))

(= (exp07-rich-intervention-cost-per-trajectory $arm)
   (* 24 (exp07-rich-intervention-cost-per-draw $arm)))

(= (exp07-rich-intervention-cost-full-matrix $arm)
   (* 8 (exp07-rich-intervention-cost-per-trajectory $arm)))

(= (exp07-rich-intervention-cost-report)
   (rich-intervention-cost
     reference-policy unguided
     metric total-variation-shifted-mass-numerator
     denominator-per-draw 88
     registered-draws-per-trajectory 24
     fixed-trajectories-per-arm 8
     per-draw
       ((unguided (exp07-rich-intervention-cost-per-draw unguided))
        (weak-doob-h (exp07-rich-intervention-cost-per-draw weak-doob-h))
        (shuffled-guidance
          (exp07-rich-intervention-cost-per-draw shuffled-guidance)))
     per-trajectory
       ((unguided (exp07-rich-intervention-cost-per-trajectory unguided))
        (weak-doob-h
          (exp07-rich-intervention-cost-per-trajectory weak-doob-h))
        (shuffled-guidance
          (exp07-rich-intervention-cost-per-trajectory shuffled-guidance)))
     full-matrix
       ((unguided (exp07-rich-intervention-cost-full-matrix unguided))
        (weak-doob-h (exp07-rich-intervention-cost-full-matrix weak-doob-h))
        (shuffled-guidance
          (exp07-rich-intervention-cost-full-matrix shuffled-guidance)))
     matched-guidance-budget true
     chemistry-outcomes-used false))

(= (exp07-rich-registered-summary)
   (rich-registered-summary
     horizon (3 26)
     fixed-seeds (seed-11 seed-12 seed-13 seed-14
                  seed-15 seed-16 seed-17 seed-18)
     raf-incidence
       ((unguided (exp07-rich-arm-raf-incidence unguided))
        (weak-doob-h (exp07-rich-arm-raf-incidence weak-doob-h))
        (shuffled-guidance
          (exp07-rich-arm-raf-incidence shuffled-guidance)))
     first-hit-ticks
       ((unguided
          ((seed-11 (exp07-rich-first-raf-tick unguided seed-11))
           (seed-12 (exp07-rich-first-raf-tick unguided seed-12))
           (seed-13 (exp07-rich-first-raf-tick unguided seed-13))
           (seed-14 (exp07-rich-first-raf-tick unguided seed-14))
           (seed-15 (exp07-rich-first-raf-tick unguided seed-15))
           (seed-16 (exp07-rich-first-raf-tick unguided seed-16))
           (seed-17 (exp07-rich-first-raf-tick unguided seed-17))
           (seed-18 (exp07-rich-first-raf-tick unguided seed-18))))
        (weak-doob-h
          ((seed-11 (exp07-rich-first-raf-tick weak-doob-h seed-11))
           (seed-12 (exp07-rich-first-raf-tick weak-doob-h seed-12))
           (seed-13 (exp07-rich-first-raf-tick weak-doob-h seed-13))
           (seed-14 (exp07-rich-first-raf-tick weak-doob-h seed-14))
           (seed-15 (exp07-rich-first-raf-tick weak-doob-h seed-15))
           (seed-16 (exp07-rich-first-raf-tick weak-doob-h seed-16))
           (seed-17 (exp07-rich-first-raf-tick weak-doob-h seed-17))
           (seed-18 (exp07-rich-first-raf-tick weak-doob-h seed-18))))
        (shuffled-guidance
          ((seed-11 (exp07-rich-first-raf-tick shuffled-guidance seed-11))
           (seed-12 (exp07-rich-first-raf-tick shuffled-guidance seed-12))
           (seed-13 (exp07-rich-first-raf-tick shuffled-guidance seed-13))
           (seed-14 (exp07-rich-first-raf-tick shuffled-guidance seed-14))
           (seed-15 (exp07-rich-first-raf-tick shuffled-guidance seed-15))
           (seed-16 (exp07-rich-first-raf-tick shuffled-guidance seed-16))
           (seed-17 (exp07-rich-first-raf-tick shuffled-guidance seed-17))
           (seed-18 (exp07-rich-first-raf-tick shuffled-guidance seed-18)))))
     productive-events
       ((unguided (exp07-rich-arm-event-count unguided))
        (weak-doob-h (exp07-rich-arm-event-count weak-doob-h))
        (shuffled-guidance (exp07-rich-arm-event-count shuffled-guidance)))
     longest-consecutive-raf-ticks
       ((unguided
          ((seed-11 (exp07-rich-raf-persistence unguided seed-11))
           (seed-12 (exp07-rich-raf-persistence unguided seed-12))
           (seed-13 (exp07-rich-raf-persistence unguided seed-13))
           (seed-14 (exp07-rich-raf-persistence unguided seed-14))
           (seed-15 (exp07-rich-raf-persistence unguided seed-15))
           (seed-16 (exp07-rich-raf-persistence unguided seed-16))
           (seed-17 (exp07-rich-raf-persistence unguided seed-17))
           (seed-18 (exp07-rich-raf-persistence unguided seed-18))))
        (weak-doob-h
          ((seed-11 (exp07-rich-raf-persistence weak-doob-h seed-11))
           (seed-12 (exp07-rich-raf-persistence weak-doob-h seed-12))
           (seed-13 (exp07-rich-raf-persistence weak-doob-h seed-13))
           (seed-14 (exp07-rich-raf-persistence weak-doob-h seed-14))
           (seed-15 (exp07-rich-raf-persistence weak-doob-h seed-15))
           (seed-16 (exp07-rich-raf-persistence weak-doob-h seed-16))
           (seed-17 (exp07-rich-raf-persistence weak-doob-h seed-17))
           (seed-18 (exp07-rich-raf-persistence weak-doob-h seed-18))))
        (shuffled-guidance
          ((seed-11 (exp07-rich-raf-persistence shuffled-guidance seed-11))
           (seed-12 (exp07-rich-raf-persistence shuffled-guidance seed-12))
           (seed-13 (exp07-rich-raf-persistence shuffled-guidance seed-13))
           (seed-14 (exp07-rich-raf-persistence shuffled-guidance seed-14))
           (seed-15 (exp07-rich-raf-persistence shuffled-guidance seed-15))
           (seed-16 (exp07-rich-raf-persistence shuffled-guidance seed-16))
           (seed-17 (exp07-rich-raf-persistence shuffled-guidance seed-17))
           (seed-18 (exp07-rich-raf-persistence shuffled-guidance seed-18)))))
     total-persistence
       ((unguided (exp07-rich-arm-total-persistence unguided))
        (weak-doob-h (exp07-rich-arm-total-persistence weak-doob-h))
        (shuffled-guidance
          (exp07-rich-arm-total-persistence shuffled-guidance)))
     terminal-rule-diversity
       ((unguided
          ((seed-11 (exp07-rich-rule-diversity unguided seed-11))
           (seed-12 (exp07-rich-rule-diversity unguided seed-12))
           (seed-13 (exp07-rich-rule-diversity unguided seed-13))
           (seed-14 (exp07-rich-rule-diversity unguided seed-14))
           (seed-15 (exp07-rich-rule-diversity unguided seed-15))
           (seed-16 (exp07-rich-rule-diversity unguided seed-16))
           (seed-17 (exp07-rich-rule-diversity unguided seed-17))
           (seed-18 (exp07-rich-rule-diversity unguided seed-18))))
        (weak-doob-h
          ((seed-11 (exp07-rich-rule-diversity weak-doob-h seed-11))
           (seed-12 (exp07-rich-rule-diversity weak-doob-h seed-12))
           (seed-13 (exp07-rich-rule-diversity weak-doob-h seed-13))
           (seed-14 (exp07-rich-rule-diversity weak-doob-h seed-14))
           (seed-15 (exp07-rich-rule-diversity weak-doob-h seed-15))
           (seed-16 (exp07-rich-rule-diversity weak-doob-h seed-16))
           (seed-17 (exp07-rich-rule-diversity weak-doob-h seed-17))
           (seed-18 (exp07-rich-rule-diversity weak-doob-h seed-18))))
        (shuffled-guidance
          ((seed-11 (exp07-rich-rule-diversity shuffled-guidance seed-11))
           (seed-12 (exp07-rich-rule-diversity shuffled-guidance seed-12))
           (seed-13 (exp07-rich-rule-diversity shuffled-guidance seed-13))
           (seed-14 (exp07-rich-rule-diversity shuffled-guidance seed-14))
           (seed-15 (exp07-rich-rule-diversity shuffled-guidance seed-15))
           (seed-16 (exp07-rich-rule-diversity shuffled-guidance seed-16))
           (seed-17 (exp07-rich-rule-diversity shuffled-guidance seed-17))
           (seed-18 (exp07-rich-rule-diversity shuffled-guidance seed-18)))))
     total-rule-diversity
       ((unguided (exp07-rich-arm-total-rule-diversity unguided))
        (weak-doob-h (exp07-rich-arm-total-rule-diversity weak-doob-h))
        (shuffled-guidance
          (exp07-rich-arm-total-rule-diversity shuffled-guidance)))
     total-diversity-collapse-from-full-pool
       ((unguided (exp07-rich-arm-total-diversity-collapse unguided))
        (weak-doob-h (exp07-rich-arm-total-diversity-collapse weak-doob-h))
        (shuffled-guidance
          (exp07-rich-arm-total-diversity-collapse shuffled-guidance)))
     intervention-cost (exp07-rich-intervention-cost-report)
     causal-ablations (exp07-rich-causal-ablation-report)
     replay deterministic-seed-tick-state-carry
     terminal-forcing prohibited
     emergence-claim none))

; Close the rich shared-pool experiment before implementing another outcome.
; The cycle is structurally necessary under catalyst/rule ablation, but the
; positive unguided and shuffled arms reject guidance necessity.
(= (exp07-rich-interpretation)
   (rich-pool-interpretation
     frozen-matrix complete
     raf-incidence ((unguided 5) (weak-doob-h 7) (shuffled-guidance 3))
     cycle-necessary-under-ablation true
     guidance-necessary false
     evidence pool-composition
     horizon-extension prohibited
     emergence-claim none))

; Preregister the ordered-bootstrap successor without constructing its
; chamber, selector, or any held-out outcome.  The full human-readable
; protocol is experiments/exp07/PREREG_ORDERED_BOOTSTRAP.md.
(= (exp07-ordered-bootstrap-preregistration)
   (ordered-bootstrap-preregistration
     status design-only
     outcomes-evaluated false
     pool-order (ob0 op1 op2 op0 od0 od1 od2 od3)
     initial-catalyst-abundances ((AB 0) (AC 0) (CD 0) (X 1))
     raf-rules (op1 op2 op0)
     bootstrap-rule ob0
     frontier-phases ((AB-zero ob0 od0) (AC-zero op1 od1)
                      (CD-zero op2 od2) (cycle-ready op0 od3))
     arms (unguided weak-doob-h shuffled-frontier-guidance)
     held-out-seeds (seed-19 seed-20 seed-21 seed-22
                     seed-23 seed-24 seed-25 seed-26)
     horizon (3 26)
     candidate-cap 8
     selector-denominator 96
     selector-mass-multisets
       ((unguided (12 12 12 12 12 12 12 12))
        (weak-doob-h (20 4 12 12 12 12 12 12))
        (shuffled-frontier-guidance (20 4 12 12 12 12 12 12)))
     shifted-mass-units-per-guided-draw 8
     state-read-boundary (AB-present AC-present CD-present)
     direct-bounded-tick required
     adaptive-extension prohibited
     terminal-forcing prohibited
     emergence-claim none))

; Freeze an independent replication and a separately held-out order/hash
; robustness cohort before adding seed support, selectors, or trajectories.
; The full protocol is experiments/exp07/PREREG_ORDERED_REPLICATION.md.
(= (exp07-ordered-replication-preregistration)
   (ordered-replication-preregistration
     status design-only
     outcomes-evaluated false
     predecessor-seeds (seed-19 seed-20 seed-21 seed-22
                        seed-23 seed-24 seed-25 seed-26)
     cohort-a
       (exact-form
         seeds (seed-101 seed-102 seed-103 seed-104
                seed-105 seed-106 seed-107 seed-108
                seed-109 seed-110 seed-111 seed-112
                seed-113 seed-114 seed-115 seed-116)
         pool-order (ob0 op1 op2 op0 od0 od1 od2 od3)
         draw-hash (29 seed 43 tick 7 modulo 96)
         minimum-weak-advantage-over-each-control 6)
     cohort-b
       (order-hash-robustness
         seeds (seed-117 seed-118 seed-119 seed-120
                seed-121 seed-122 seed-123 seed-124
                seed-125 seed-126 seed-127 seed-128
                seed-129 seed-130 seed-131 seed-132)
         pool-order (od2 op0 ob0 od1 op2 od3 op1 od0)
         draw-hash (47 seed 53 tick 11 modulo 96)
         selection-addressing rule-identity
         minimum-weak-advantage-over-each-control 4)
     shared-contract
       (arms (unguided weak-doob-h shuffled-frontier-guidance)
        horizon (3 26)
        candidate-cap 8
        selector-denominator 96
        shifted-mass-units-per-guided-draw 8
        rolling-raf-rules (op1 op2 op0)
        maximum-positive-after-each-causal-ablation 2
        replay required
        adaptive-extension prohibited
        terminal-forcing prohibited)
     execution-order (cohort-a-complete-report cohort-b)
     spontaneous-emergence-claim none))

; Close both ordered-replication gates before freezing a successor. Cohort A
; failed its primary contrast; cohort B passed that contrast but failed the
; prespecified guiding-term-removal gate and cannot rescue cohort A.
(= (exp07-ordered-replication-program-closure)
   (ordered-replication-program-closure
     cohort-a-primary-replication not-supported
     cohort-b-order-hash-robustness not-supported
     cohort-b-cannot-rescue-cohort-a true
     adaptive-extension none
     successor-outcomes-evaluated false
     spontaneous-emergence-claim none))

; Freeze the dual-bootstrap successor before implementing any of its seed
; support, bounded generator, selector, chamber, or held-out trajectories.
; The full protocol is experiments/exp07/PREREG_DUAL_BOOTSTRAP.md.
(= (exp07-dual-bootstrap-preregistration)
   (dual-bootstrap-preregistration
     status design-only
     outcomes-evaluated false
     source-rule-count 12
     candidate-cap 8
     pathway-rules (db0 db1 dp1 dp2 dp3 dp0)
     raf-rules (dp1 dp2 dp3 dp0)
     distractor-rules (dd0 dd1 dd2 dd3 dd4 dd5)
     bounded-generation
       (always-include (db0 db1 dp1 dp2 dp3 dp0)
        rotating-distractor-pairs ((dd0 dd1) (dd2 dd3) (dd4 dd5))
        matched-distractor first-in-rotating-pair
        addressing rule-identity
        source-order-invariant required)
     initial-catalyst-abundances
       ((X 1) (AB 0) (CD 0) (AC 0) (BD 0) (CE 0))
     ordered-frontier (db0 db1 dp1 dp2 dp3 dp0)
     arms (unguided weak-doob-h shuffled-frontier-guidance)
     held-out-seeds (seed-201 seed-202 seed-203 seed-204
                     seed-205 seed-206 seed-207 seed-208
                     seed-209 seed-210 seed-211 seed-212
                     seed-213 seed-214 seed-215 seed-216
                     seed-217 seed-218 seed-219 seed-220
                     seed-221 seed-222 seed-223 seed-224
                     seed-225 seed-226 seed-227 seed-228
                     seed-229 seed-230 seed-231 seed-232)
     horizon (3 34)
     food-reset-ticks (11 19 27)
     draw-hash (71 seed 67 tick 19 modulo 96)
     selector-masses
       ((unguided (12 12 12 12 12 12 12 12))
        (weak-doob-h (frontier 20 matched-distractor 4 others 12))
        (shuffled-frontier-guidance
          (frontier 4 matched-distractor 20 others 12)))
     shifted-mass-units-per-guided-draw 8
     primary-thresholds
       (minimum-weak-advantage-over-each-control 10
        maximum-positive-after-each-causal-ablation 4)
     direct-bounded-tick required
     replay required
     adaptive-extension prohibited
     terminal-forcing prohibited
     spontaneous-emergence-claim none))

; ----- Dual-bootstrap fail-closed implementation gates -----
;
; Materialize the complete frozen twelve-rule source, then derive the cap by
; rule identity.  Both accepted source orders deliberately emit the same
; canonical cap order, so source position cannot decide which rules survive.
; These clauses use only seed-7 synthetic fixtures and never construct a
; registered seed-201--232 trajectory.
(= (exp07-dual-rules canonical)
   ((rule db0 A B AB X)
    (rule db1 C D CD AB)
    (rule dp1 A C AC CD)
    (rule dp2 B D BD AC)
    (rule dp3 C E CE BD)
    (rule dp0 C D CD CE)
    (rule dd0 A D W0 X)
    (rule dd1 B C W1 X)
    (rule dd2 A E W2 X)
    (rule dd3 B E W3 X)
    (rule dd4 A C W4 X)
    (rule dd5 D E W5 X)))

(= (exp07-dual-rules permuted)
   ((rule dd4 A C W4 X)
    (rule dp2 B D BD AC)
    (rule db0 A B AB X)
    (rule dd1 B C W1 X)
    (rule dp0 C D CD CE)
    (rule dd5 D E W5 X)
    (rule db1 C D CD AB)
    (rule dp3 C E CE BD)
    (rule dd2 A E W2 X)
    (rule dp1 A C AC CD)
    (rule dd0 A D W0 X)
    (rule dd3 B E W3 X)))

(= (exp07-dual-fixture $order $tick $ab $cd $ac $bd $ce)
   (chamber exp07-dual-bootstrap-synthetic
     (state $tick seed-7
       (molecules
         ((mol A 3) (mol B 2) (mol C 3) (mol D 2) (mol E 2)
          (mol X 1) (mol AB $ab) (mol CD $cd) (mol AC $ac)
          (mol BD $bd) (mol CE $ce) (mol W0 0) (mol W1 0)
          (mol W2 0) (mol W3 0) (mol W4 0) (mol W5 0))))
     (exp07-dual-rules $order) ()))

(= (exp07-dual-distractor-phase $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 3))

(= (exp07-dual-matched-distractor 0) dd0)
(= (exp07-dual-matched-distractor 1) dd2)
(= (exp07-dual-matched-distractor 2) dd4)
(= (exp07-dual-partner-distractor 0) dd1)
(= (exp07-dual-partner-distractor 1) dd3)
(= (exp07-dual-partner-distractor 2) dd5)

(= (exp07-dual-cap-for-phase 0 $tick)
   (candidate-pool $tick
     ((candidate $tick (rule db0 A B AB X) 1)
      (candidate $tick (rule db1 C D CD AB) 1)
      (candidate $tick (rule dp1 A C AC CD) 1)
      (candidate $tick (rule dp2 B D BD AC) 1)
      (candidate $tick (rule dp3 C E CE BD) 1)
      (candidate $tick (rule dp0 C D CD CE) 1)
      (candidate $tick (rule dd0 A D W0 X) 1)
      (candidate $tick (rule dd1 B C W1 X) 1))))
(= (exp07-dual-cap-for-phase 1 $tick)
   (candidate-pool $tick
     ((candidate $tick (rule db0 A B AB X) 1)
      (candidate $tick (rule db1 C D CD AB) 1)
      (candidate $tick (rule dp1 A C AC CD) 1)
      (candidate $tick (rule dp2 B D BD AC) 1)
      (candidate $tick (rule dp3 C E CE BD) 1)
      (candidate $tick (rule dp0 C D CD CE) 1)
      (candidate $tick (rule dd2 A E W2 X) 1)
      (candidate $tick (rule dd3 B E W3 X) 1))))
(= (exp07-dual-cap-for-phase 2 $tick)
   (candidate-pool $tick
     ((candidate $tick (rule db0 A B AB X) 1)
      (candidate $tick (rule db1 C D CD AB) 1)
      (candidate $tick (rule dp1 A C AC CD) 1)
      (candidate $tick (rule dp2 B D BD AC) 1)
      (candidate $tick (rule dp3 C E CE BD) 1)
      (candidate $tick (rule dp0 C D CD CE) 1)
      (candidate $tick (rule dd4 A C W4 X) 1)
      (candidate $tick (rule dd5 D E W5 X) 1))))

(= (exp07-dual-generate-cap
      (chamber $id (state $tick $seed (molecules $molecules))
        ((rule db0 A B AB X) (rule db1 C D CD AB)
         (rule dp1 A C AC CD) (rule dp2 B D BD AC)
         (rule dp3 C E CE BD) (rule dp0 C D CD CE)
         (rule dd0 A D W0 X) (rule dd1 B C W1 X)
         (rule dd2 A E W2 X) (rule dd3 B E W3 X)
         (rule dd4 A C W4 X) (rule dd5 D E W5 X)) $events))
   (exp07-dual-cap-for-phase
     (exp07-dual-distractor-phase $seed $tick) $tick))
(= (exp07-dual-generate-cap
      (chamber $id (state $tick $seed (molecules $molecules))
        ((rule dd4 A C W4 X) (rule dp2 B D BD AC)
         (rule db0 A B AB X) (rule dd1 B C W1 X)
         (rule dp0 C D CD CE) (rule dd5 D E W5 X)
         (rule db1 C D CD AB) (rule dp3 C E CE BD)
         (rule dd2 A E W2 X) (rule dp1 A C AC CD)
         (rule dd0 A D W0 X) (rule dd3 B E W3 X)) $events))
   (exp07-dual-cap-for-phase
     (exp07-dual-distractor-phase $seed $tick) $tick))

(= (exp07-dual-arm-pool $arm $chamber)
   (exp07-dual-generate-cap $chamber))
(= (exp07-dual-arm-pools-identical? $chamber)
   (and (== (exp07-dual-arm-pool unguided $chamber)
            (exp07-dual-arm-pool weak-doob-h $chamber))
        (== (exp07-dual-arm-pool unguided $chamber)
            (exp07-dual-arm-pool shuffled-frontier-guidance $chamber))))

; First-class catalysis is explicit and closed-world for the new chemistry.
!(add-atom &self (catalyzes X db0))
!(add-atom &self (catalyzes AB db1))
!(add-atom &self (catalyzes CD dp1))
!(add-atom &self (catalyzes AC dp2))
!(add-atom &self (catalyzes BD dp3))
!(add-atom &self (catalyzes CE dp0))
!(add-atom &self (catalyzes X dd0))
!(add-atom &self (catalyzes X dd1))
!(add-atom &self (catalyzes X dd2))
!(add-atom &self (catalyzes X dd3))
!(add-atom &self (catalyzes X dd4))
!(add-atom &self (catalyzes X dd5))

(= (exp07-dual-catalysis-facts)
   ((catalysis-edge X db0) (catalysis-edge AB db1)
    (catalysis-edge CD dp1) (catalysis-edge AC dp2)
    (catalysis-edge BD dp3) (catalysis-edge CE dp0)
    (catalysis-edge X dd0) (catalysis-edge X dd1)
    (catalysis-edge X dd2) (catalysis-edge X dd3)
    (catalysis-edge X dd4) (catalysis-edge X dd5)))
(= (exp07-dual-catalyzes? $molecule $rule-id)
   (if (== (collapse
             (match &self (catalyzes $molecule $rule-id) matched)) ())
       False True))

(= (exp07-dual-event-rule-fired? $rule-id $events)
   (if (== $events ()) False
       (if (== (exp07-event-rule-id (car-atom $events)) $rule-id) True
           (exp07-dual-event-rule-fired? $rule-id (cdr-atom $events)))))
(= (exp07-dual-event-derived-raf? $events)
   (and (exp07-dual-event-rule-fired? dp1 $events)
        (and (exp07-dual-event-rule-fired? dp2 $events)
             (and (exp07-dual-event-rule-fired? dp3 $events)
                  (exp07-dual-event-rule-fired? dp0 $events)))))

; The selector frontier is derived only from the current PeTTa chamber.
(= (exp07-dual-frontier
      (chamber $id (state $tick $seed (molecules $molecules)) $rules $events))
   (if (== (molecule-abundance-7 AB $molecules) 0) db0
       (if (== (molecule-abundance-7 CD $molecules) 0) db1
           (if (== (molecule-abundance-7 AC $molecules) 0) dp1
               (if (== (molecule-abundance-7 BD $molecules) 0) dp2
                   (if (== (molecule-abundance-7 CE $molecules) 0)
                       dp3 dp0))))))

(= (exp07-dual-remove-id $wanted $ids)
   (if (== $ids ()) ()
       (if (== (car-atom $ids) $wanted)
           (exp07-dual-remove-id $wanted (cdr-atom $ids))
           (cons-atom (car-atom $ids)
             (exp07-dual-remove-id $wanted (cdr-atom $ids))))))
(= (exp07-dual-nth-id $index $ids)
   (if (== $index 0)
       (car-atom $ids)
       (exp07-dual-nth-id (- $index 1) (cdr-atom $ids))))
(= (exp07-dual-exposed-ids $matched $partner)
   (db0 db1 dp1 dp2 dp3 dp0 $matched $partner))
(= (exp07-dual-other-ids $frontier $matched $partner)
   (exp07-dual-remove-id $matched
     (exp07-dual-remove-id $frontier
       (exp07-dual-exposed-ids $matched $partner))))
(= (exp07-dual-other-index $draw)
   (if (< $draw 36) 0 (if (< $draw 48) 1 (if (< $draw 60) 2
       (if (< $draw 72) 3 (if (< $draw 84) 4 5))))))

(= (exp07-dual-selected-id unguided $frontier $matched $partner $draw)
   (exp07-dual-nth-id (exp07-ordered-unguided-bin $draw)
     (exp07-dual-exposed-ids $matched $partner)))
(= (exp07-dual-selected-id weak-doob-h $frontier $matched $partner $draw)
   (if (< $draw 20) $frontier
       (if (< $draw 24) $matched
           (exp07-dual-nth-id (exp07-dual-other-index $draw)
             (exp07-dual-other-ids $frontier $matched $partner)))))
(= (exp07-dual-selected-id
      shuffled-frontier-guidance $frontier $matched $partner $draw)
   (if (< $draw 4) $frontier
       (if (< $draw 24) $matched
           (exp07-dual-nth-id (exp07-dual-other-index $draw)
             (exp07-dual-other-ids $frontier $matched $partner)))))

(= (exp07-dual-id-count-from
      $arm $frontier $matched $partner $wanted $draw)
   (if (>= $draw 96) 0
       (+ (if (== (exp07-dual-selected-id
                     $arm $frontier $matched $partner $draw) $wanted) 1 0)
          (exp07-dual-id-count-from
            $arm $frontier $matched $partner $wanted (+ $draw 1)))))
(= (exp07-dual-other-masses-12? $arm $frontier $matched $partner $ids)
   (if (== $ids ()) True
       (and (== (exp07-dual-id-count-from
                  $arm $frontier $matched $partner (car-atom $ids) 0) 12)
            (exp07-dual-other-masses-12?
              $arm $frontier $matched $partner (cdr-atom $ids)))))
(= (exp07-dual-selector-calibrated?
      weak-doob-h $frontier $matched $partner)
   (and (== (exp07-dual-id-count-from
              weak-doob-h $frontier $matched $partner $frontier 0) 20)
        (and (== (exp07-dual-id-count-from
                   weak-doob-h $frontier $matched $partner $matched 0) 4)
             (exp07-dual-other-masses-12?
               weak-doob-h $frontier $matched $partner
               (exp07-dual-other-ids $frontier $matched $partner)))))
(= (exp07-dual-selector-calibrated?
      shuffled-frontier-guidance $frontier $matched $partner)
   (and (== (exp07-dual-id-count-from shuffled-frontier-guidance
              $frontier $matched $partner $frontier 0) 4)
        (and (== (exp07-dual-id-count-from shuffled-frontier-guidance
                   $frontier $matched $partner $matched 0) 20)
             (exp07-dual-other-masses-12? shuffled-frontier-guidance
               $frontier $matched $partner
               (exp07-dual-other-ids $frontier $matched $partner)))))
(= (exp07-dual-all-frontiers-calibrated? $arm $matched $partner $frontiers)
   (if (== $frontiers ()) True
       (and (exp07-dual-selector-calibrated?
              $arm (car-atom $frontiers) $matched $partner)
            (exp07-dual-all-frontiers-calibrated?
              $arm $matched $partner (cdr-atom $frontiers)))))
(= (exp07-dual-complete-selector-calibration? $arm)
   (and (exp07-dual-all-frontiers-calibrated?
          $arm dd0 dd1 (db0 db1 dp1 dp2 dp3 dp0))
        (and (exp07-dual-all-frontiers-calibrated?
               $arm dd2 dd3 (db0 db1 dp1 dp2 dp3 dp0))
             (exp07-dual-all-frontiers-calibrated?
               $arm dd4 dd5 (db0 db1 dp1 dp2 dp3 dp0)))))

(= (exp07-dual-selected-with-draw $arm $chamber $draw)
   (exp07-dual-selected-from-pool
     $arm $chamber $draw (exp07-dual-generate-cap $chamber)))
(= (exp07-dual-selected-from-pool
      $arm $chamber $draw (candidate-pool $tick $candidates))
   (let $phase (exp07-dual-distractor-phase
                 (state-seed (chamber-state $chamber)) $tick)
     (exp07-ordered-candidate-by-rule-id
       (exp07-dual-selected-id $arm (exp07-dual-frontier $chamber)
         (exp07-dual-matched-distractor $phase)
         (exp07-dual-partner-distractor $phase) $draw)
       $candidates)))
(= (exp07-dual-direct-tick-with-draw $arm $chamber $draw)
   (chamber-tick-with-candidate
     $chamber (exp07-dual-selected-with-draw $arm $chamber $draw)))

(= (exp07-dual-initial-applicability-gate)
   (let $chamber (exp07-dual-fixture canonical 3 0 0 0 0 0)
     (dual-initial-applicability-gate
       db0 (candidate-applicable-in-chamber?
             (candidate 3 (rule db0 A B AB X) 1) $chamber)
       db1 (candidate-applicable-in-chamber?
             (candidate 3 (rule db1 C D CD AB) 1) $chamber)
       dp1 (candidate-applicable-in-chamber?
             (candidate 3 (rule dp1 A C AC CD) 1) $chamber)
       dp2 (candidate-applicable-in-chamber?
             (candidate 3 (rule dp2 B D BD AC) 1) $chamber)
       dp3 (candidate-applicable-in-chamber?
             (candidate 3 (rule dp3 C E CE BD) 1) $chamber)
       dp0 (candidate-applicable-in-chamber?
             (candidate 3 (rule dp0 C D CD CE) 1) $chamber)
       exposed-distractors
         ((dd2 (candidate-applicable-in-chamber?
                  (candidate 3 (rule dd2 A E W2 X) 1) $chamber))
          (dd3 (candidate-applicable-in-chamber?
                  (candidate 3 (rule dd3 B E W3 X) 1) $chamber)))
       initial-event-raf
         (exp07-dual-event-derived-raf? (chamber-events $chamber)))))

(= (exp07-dual-pre-run-gate)
   (dual-bootstrap-pre-run-gate
     source-rule-count (exp07-registered-list-length
                         (exp07-dual-rules canonical))
     catalysis-fact-count (exp07-registered-list-length
                            (exp07-dual-catalysis-facts))
     initial-applicability (exp07-dual-initial-applicability-gate)
     source-order-invariant-cap-phases
       ((phase-0 (== (exp07-dual-generate-cap
                       (exp07-dual-fixture canonical 5 0 0 0 0 0))
                     (exp07-dual-generate-cap
                       (exp07-dual-fixture permuted 5 0 0 0 0 0))))
        (phase-1 (== (exp07-dual-generate-cap
                       (exp07-dual-fixture canonical 3 0 0 0 0 0))
                     (exp07-dual-generate-cap
                       (exp07-dual-fixture permuted 3 0 0 0 0 0))))
        (phase-2 (== (exp07-dual-generate-cap
                       (exp07-dual-fixture canonical 4 0 0 0 0 0))
                     (exp07-dual-generate-cap
                       (exp07-dual-fixture permuted 4 0 0 0 0 0)))))
     complete-96-bin-calibration
       ((weak-doob-h
          (exp07-dual-complete-selector-calibration? weak-doob-h))
        (shuffled-frontier-guidance
          (exp07-dual-complete-selector-calibration?
            shuffled-frontier-guidance)))
     matched-guidance-cost-units
       ((weak-doob-h 8) (shuffled-frontier-guidance 8))
     identical-arm-pools
       (exp07-dual-arm-pools-identical?
         (exp07-dual-fixture canonical 3 0 0 0 0 0))
     selection-addressing rule-identity
     synthetic-direct-tick required
     registered-seed-support-implemented false
     registered-trajectory-evaluated false
     chemistry-outcomes-used false
     emergence-claim none))

; ----- Ordered-bootstrap pre-run gate: shared pool and catalysis -----
;
; Materialize only the frozen chemistry inputs.  These constructors do not
; select a candidate, tick a chamber, or inspect any held-out outcome.
(= (exp07-ordered-rules)
   ((rule ob0 A B AB X)
    (rule op1 A C AC AB)
    (rule op2 C D CD AC)
    (rule op0 A B AB CD)
    (rule od0 A C W0 X)
    (rule od1 B C W1 X)
    (rule od2 C D W2 X)
    (rule od3 A D W3 X)))

(= (exp07-ordered-initial-chamber $seed)
   (chamber exp07-ordered-bootstrap
     (state 3 $seed
       (molecules
         ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
          (mol AB 0) (mol AC 0) (mol CD 0) (mol X 1)
          (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0))))
     (exp07-ordered-rules)
     ()))

; All arms call the same state-parametric constructor.  Keep the ordered
; generator local and explicit: imported equation heads are data to this PeTTa
; compiler boundary, while this clause executes as chemistry code and mirrors
; exp00's stable one-candidate-per-rule cap-8 contract.
(= (exp07-ordered-generate-candidate-pool
      (chamber $id
        (state $tick $seed (molecules $molecules))
        ((rule $r0 $a0 $b0 $p0 $c0)
         (rule $r1 $a1 $b1 $p1 $c1)
         (rule $r2 $a2 $b2 $p2 $c2)
         (rule $r3 $a3 $b3 $p3 $c3)
         (rule $r4 $a4 $b4 $p4 $c4)
         (rule $r5 $a5 $b5 $p5 $c5)
         (rule $r6 $a6 $b6 $p6 $c6)
         (rule $r7 $a7 $b7 $p7 $c7))
        $events))
   (candidate-pool $tick
     ((candidate $tick (rule $r0 $a0 $b0 $p0 $c0) 1)
      (candidate $tick (rule $r1 $a1 $b1 $p1 $c1) 1)
      (candidate $tick (rule $r2 $a2 $b2 $p2 $c2) 1)
      (candidate $tick (rule $r3 $a3 $b3 $p3 $c3) 1)
      (candidate $tick (rule $r4 $a4 $b4 $p4 $c4) 1)
      (candidate $tick (rule $r5 $a5 $b5 $p5 $c5) 1)
      (candidate $tick (rule $r6 $a6 $b6 $p6 $c6) 1)
      (candidate $tick (rule $r7 $a7 $b7 $p7 $c7) 1))))

(= (exp07-ordered-shared-pool $chamber)
   (exp07-ordered-generate-candidate-pool $chamber))

(= (exp07-ordered-arm-pool $arm $chamber)
   (exp07-ordered-shared-pool $chamber))

(= (exp07-ordered-cap-8
      (candidate-pool $tick
        ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)))
   (candidate-pool $tick
     ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)))

(= (exp07-ordered-bounded-pool $chamber)
   (exp07-ordered-cap-8 (exp07-ordered-shared-pool $chamber)))

(= (exp07-ordered-pool-identity? $chamber)
   (and (== (exp07-ordered-arm-pool unguided $chamber)
            (exp07-ordered-arm-pool weak-doob-h $chamber))
        (== (exp07-ordered-arm-pool unguided $chamber)
            (exp07-ordered-arm-pool shuffled-frontier-guidance $chamber))))

; The first-class relation is explicit data.  The total query below scans
; only these atoms, so rule or molecule spelling cannot imply catalysis.
!(add-atom &self (catalyzes X ob0))
!(add-atom &self (catalyzes AB op1))
!(add-atom &self (catalyzes AC op2))
!(add-atom &self (catalyzes CD op0))
!(add-atom &self (catalyzes X od0))
!(add-atom &self (catalyzes X od1))
!(add-atom &self (catalyzes X od2))
!(add-atom &self (catalyzes X od3))

(= (exp07-ordered-catalysis-facts)
   ((catalysis-edge X ob0)
    (catalysis-edge AB op1)
    (catalysis-edge AC op2)
    (catalysis-edge CD op0)
    (catalysis-edge X od0)
    (catalysis-edge X od1)
    (catalysis-edge X od2)
    (catalysis-edge X od3)))

(= (exp07-ordered-catalyzes? $molecule $rule-id)
   (if (== (collapse
             (match &self (catalyzes $molecule $rule-id) matched))
           ())
       False
       True))

(= (exp07-ordered-catalysis-fact-count)
   (exp07-registered-list-length (exp07-ordered-catalysis-facts)))

(= (exp07-ordered-materialization-gate $seed)
   (ordered-materialization-gate
     pool-order (ob0 op1 op2 op0 od0 od1 od2 od3)
     shared-pool-identical
       (exp07-ordered-pool-identity? (exp07-ordered-initial-chamber $seed))
     bounded-cap 8
     catalysis-facts (exp07-ordered-catalysis-facts)
     catalysis-fact-count (exp07-ordered-catalysis-fact-count)
     selector-implemented false
     chamber-tick-evaluated false
     trajectory-evaluated false
     status partial-pre-run-gate
     emergence-claim none))

; ----- Ordered-bootstrap pre-run gates: frontier selector and direct tick -----
;
; These functions are calibrated only against synthetic draw bins and
; explicit phase fixtures.  They do not recursively construct any held-out
; seed trajectory or evaluate a RAF endpoint.
(= (exp07-ordered-phase
      (chamber $id (state $tick $seed (molecules $molecules)) $rules $events))
   (if (== (molecule-abundance-7 AB $molecules) 0)
       ab-zero
       (if (== (molecule-abundance-7 AC $molecules) 0)
           ac-zero
           (if (== (molecule-abundance-7 CD $molecules) 0)
               cd-zero
               cycle-ready))))

(= (exp07-ordered-phase-fixture $ab $ac $cd)
   (chamber exp07-ordered-phase-fixture
     (state 3 seed-7
       (molecules
         ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
          (mol AB $ab) (mol AC $ac) (mol CD $cd) (mol X 1)
          (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0))))
     (exp07-ordered-rules) ()))

(= (exp07-ordered-event-rule-fired? $rule-id $events)
   (if (== $events ())
       False
       (if (== (exp07-event-rule-id (car-atom $events)) $rule-id)
           True
           (exp07-ordered-event-rule-fired? $rule-id (cdr-atom $events)))))

(= (exp07-ordered-event-derived-raf? $events)
   (and (exp07-ordered-event-rule-fired? op1 $events)
        (and (exp07-ordered-event-rule-fired? op2 $events)
             (exp07-ordered-event-rule-fired? op0 $events))))

; The registered seeds are explicit here so the frozen draw remains a simple
; PeTTa arithmetic reduction inside recursive chamber evaluation.
(= (exp07-ordered-draw seed-19 $tick) (#mod (+ 323 (* 31 $tick)) 96))
(= (exp07-ordered-draw seed-20 $tick) (#mod (+ 340 (* 31 $tick)) 96))
(= (exp07-ordered-draw seed-21 $tick) (#mod (+ 357 (* 31 $tick)) 96))
(= (exp07-ordered-draw seed-22 $tick) (#mod (+ 374 (* 31 $tick)) 96))
(= (exp07-ordered-draw seed-23 $tick) (#mod (+ 391 (* 31 $tick)) 96))
(= (exp07-ordered-draw seed-24 $tick) (#mod (+ 408 (* 31 $tick)) 96))
(= (exp07-ordered-draw seed-25 $tick) (#mod (+ 425 (* 31 $tick)) 96))
(= (exp07-ordered-draw seed-26 $tick) (#mod (+ 442 (* 31 $tick)) 96))

; Bin order is the frozen pool order: ob0 op1 op2 op0 od0 od1 od2 od3.
(= (exp07-ordered-unguided-bin $draw)
   (if (< $draw 12) 0
       (if (< $draw 24) 1
           (if (< $draw 36) 2
               (if (< $draw 48) 3
                   (if (< $draw 60) 4
                       (if (< $draw 72) 5
                           (if (< $draw 84) 6 7))))))))

; Move eight units from the phase-paired distractor to the true frontier.
(= (exp07-ordered-guided-bin ab-zero $draw)
   (if (< $draw 20) 0 (if (< $draw 32) 1 (if (< $draw 44) 2
       (if (< $draw 56) 3 (if (< $draw 60) 4 (if (< $draw 72) 5
       (if (< $draw 84) 6 7))))))))
(= (exp07-ordered-guided-bin ac-zero $draw)
   (if (< $draw 12) 0 (if (< $draw 32) 1 (if (< $draw 44) 2
       (if (< $draw 56) 3 (if (< $draw 68) 4 (if (< $draw 72) 5
       (if (< $draw 84) 6 7))))))))
(= (exp07-ordered-guided-bin cd-zero $draw)
   (if (< $draw 12) 0 (if (< $draw 24) 1 (if (< $draw 44) 2
       (if (< $draw 56) 3 (if (< $draw 68) 4 (if (< $draw 80) 5
       (if (< $draw 84) 6 7))))))))
(= (exp07-ordered-guided-bin cycle-ready $draw)
   (if (< $draw 12) 0 (if (< $draw 24) 1 (if (< $draw 36) 2
       (if (< $draw 56) 3 (if (< $draw 68) 4 (if (< $draw 80) 5
       (if (< $draw 92) 6 7))))))))

; Shuffled guidance reverses each phase pair while retaining the identical
; mass multiset and total-variation cost.
(= (exp07-ordered-shuffled-bin ab-zero $draw)
   (if (< $draw 4) 0 (if (< $draw 16) 1 (if (< $draw 28) 2
       (if (< $draw 40) 3 (if (< $draw 60) 4 (if (< $draw 72) 5
       (if (< $draw 84) 6 7))))))))
(= (exp07-ordered-shuffled-bin ac-zero $draw)
   (if (< $draw 12) 0 (if (< $draw 16) 1 (if (< $draw 28) 2
       (if (< $draw 40) 3 (if (< $draw 52) 4 (if (< $draw 72) 5
       (if (< $draw 84) 6 7))))))))
(= (exp07-ordered-shuffled-bin cd-zero $draw)
   (if (< $draw 12) 0 (if (< $draw 24) 1 (if (< $draw 28) 2
       (if (< $draw 40) 3 (if (< $draw 52) 4 (if (< $draw 64) 5
       (if (< $draw 84) 6 7))))))))
(= (exp07-ordered-shuffled-bin cycle-ready $draw)
   (if (< $draw 12) 0 (if (< $draw 24) 1 (if (< $draw 36) 2
       (if (< $draw 40) 3 (if (< $draw 52) 4 (if (< $draw 64) 5
       (if (< $draw 76) 6 7))))))))

(= (exp07-ordered-bin unguided $phase $draw)
   (exp07-ordered-unguided-bin $draw))
(= (exp07-ordered-bin weak-doob-h $phase $draw)
   (exp07-ordered-guided-bin $phase $draw))
(= (exp07-ordered-bin shuffled-frontier-guidance $phase $draw)
   (exp07-ordered-shuffled-bin $phase $draw))

(= (exp07-ordered-bin-count-from $arm $phase $bin $draw)
   (if (>= $draw 96)
       0
       (+ (if (== (exp07-ordered-bin $arm $phase $draw) $bin) 1 0)
          (exp07-ordered-bin-count-from $arm $phase $bin (+ $draw 1)))))

(= (exp07-ordered-bin-counts $arm $phase)
   ((exp07-ordered-bin-count-from $arm $phase 0 0)
    (exp07-ordered-bin-count-from $arm $phase 1 0)
    (exp07-ordered-bin-count-from $arm $phase 2 0)
    (exp07-ordered-bin-count-from $arm $phase 3 0)
    (exp07-ordered-bin-count-from $arm $phase 4 0)
    (exp07-ordered-bin-count-from $arm $phase 5 0)
    (exp07-ordered-bin-count-from $arm $phase 6 0)
    (exp07-ordered-bin-count-from $arm $phase 7 0)))

(= (exp07-ordered-select-for-chamber unguided $chamber $draw $candidates)
   (exp07-rich-select-bin
     (exp07-ordered-unguided-bin $draw) $candidates))
(= (exp07-ordered-select-for-chamber weak-doob-h $chamber $draw $candidates)
   (exp07-rich-select-bin
     (exp07-ordered-guided-bin
       (exp07-ordered-phase $chamber) $draw)
     $candidates))
(= (exp07-ordered-select-for-chamber
      shuffled-frontier-guidance $chamber $draw $candidates)
   (exp07-rich-select-bin
     (exp07-ordered-shuffled-bin
       (exp07-ordered-phase $chamber) $draw)
     $candidates))

(= (exp07-ordered-select-from-pool
      $arm $chamber $draw (candidate-pool $tick $candidates))
   (exp07-ordered-select-for-chamber
     $arm $chamber $draw $candidates))

(= (exp07-ordered-selected-with-draw $arm $chamber $draw)
   (exp07-ordered-select-from-pool
     $arm $chamber $draw (exp07-ordered-bounded-pool $chamber)))

(= (exp07-ordered-direct-tick-with-draw $arm $chamber $draw)
   (chamber-tick-with-candidate
     $chamber
     (exp07-ordered-selected-with-draw $arm $chamber $draw)))

(= (exp07-ordered-initial-applicability-gate $seed)
   (let $chamber (exp07-ordered-initial-chamber $seed)
     (initial-applicability-gate
       phase (exp07-ordered-phase $chamber)
       ob0 (candidate-applicable-in-chamber?
             (candidate 3 (rule ob0 A B AB X) 1) $chamber)
       op1 (candidate-applicable-in-chamber?
             (candidate 3 (rule op1 A C AC AB) 1) $chamber)
       op2 (candidate-applicable-in-chamber?
             (candidate 3 (rule op2 C D CD AC) 1) $chamber)
       op0 (candidate-applicable-in-chamber?
             (candidate 3 (rule op0 A B AB CD) 1) $chamber)
       initial-event-raf (exp07-ordered-event-derived-raf?
                           (chamber-events $chamber)))))

(= (exp07-ordered-selector-pre-run-gate)
   (ordered-selector-pre-run-gate
     phases
       ((ab-zero (exp07-ordered-bin-counts weak-doob-h ab-zero)
                 (exp07-ordered-bin-counts shuffled-frontier-guidance ab-zero))
        (ac-zero (exp07-ordered-bin-counts weak-doob-h ac-zero)
                 (exp07-ordered-bin-counts shuffled-frontier-guidance ac-zero))
        (cd-zero (exp07-ordered-bin-counts weak-doob-h cd-zero)
                 (exp07-ordered-bin-counts shuffled-frontier-guidance cd-zero))
        (cycle-ready (exp07-ordered-bin-counts weak-doob-h cycle-ready)
                     (exp07-ordered-bin-counts shuffled-frontier-guidance cycle-ready)))
     unguided (exp07-ordered-bin-counts unguided ab-zero)
     shifted-mass-units-per-guided-draw 8
     matched-cost true
     chemistry-outcomes-used false
     trajectory-evaluated false
     emergence-claim none))

; ----- Ordered-replication fail-closed implementation gates -----
;
; These clauses calibrate the frozen hashes and selection semantics only.
; The chamber fixture deliberately uses seed-7, so no registered cohort
; trajectory or endpoint is constructed by this gate.
(= (exp07-ordered-replication-rules cohort-a)
   (exp07-ordered-rules))
(= (exp07-ordered-replication-rules cohort-b)
   ((rule od2 C D W2 X)
    (rule op0 A B AB CD)
    (rule ob0 A B AB X)
    (rule od1 B C W1 X)
    (rule op2 C D CD AC)
    (rule od3 A D W3 X)
    (rule op1 A C AC AB)
    (rule od0 A C W0 X)))

(= (exp07-ordered-replication-fixture $cohort $ab $ac $cd)
   (chamber exp07-ordered-replication-synthetic
     (state 3 seed-7
       (molecules
         ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
          (mol AB $ab) (mol AC $ac) (mol CD $cd) (mol X 1)
          (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0))))
     (exp07-ordered-replication-rules $cohort) ()))

(= (exp07-ordered-replication-pool $arm $cohort $chamber)
   (exp07-ordered-generate-candidate-pool $chamber))

(= (exp07-ordered-replication-pool-identity? $cohort $chamber)
   (and
     (== (exp07-ordered-replication-pool unguided $cohort $chamber)
         (exp07-ordered-replication-pool weak-doob-h $cohort $chamber))
     (== (exp07-ordered-replication-pool unguided $cohort $chamber)
         (exp07-ordered-replication-pool
           shuffled-frontier-guidance $cohort $chamber))))

(= (exp07-ordered-replication-draw cohort-a $seed $tick)
   (#mod (+ (* 29 (seed-number $seed)) (+ (* 43 $tick) 7)) 96))
(= (exp07-ordered-replication-draw cohort-b $seed $tick)
   (#mod (+ (* 47 (seed-number $seed)) (+ (* 53 $tick) 11)) 96))

(= (exp07-ordered-replication-draw-count-from
      $cohort $seed $wanted $tick)
   (if (>= $tick 96)
       0
       (+ (if (== (exp07-ordered-replication-draw
                     $cohort $seed $tick) $wanted) 1 0)
          (exp07-ordered-replication-draw-count-from
            $cohort $seed $wanted (+ $tick 1)))))

(= (exp07-ordered-replication-calibrated-from $cohort $seed $wanted)
   (if (>= $wanted 96)
       True
       (and
         (== (exp07-ordered-replication-draw-count-from
               $cohort $seed $wanted 0) 1)
         (exp07-ordered-replication-calibrated-from
           $cohort $seed (+ $wanted 1)))))

(= (exp07-ordered-replication-draw-calibrated? $cohort $seed)
   (exp07-ordered-replication-calibrated-from $cohort $seed 0))

; Convert the frozen categorical bin to its rule identity before searching
; the generated pool.  Thus cohort B's permutation cannot silently retarget
; selector mass through inherited list positions.
(= (exp07-ordered-rule-id-for-bin 0) ob0)
(= (exp07-ordered-rule-id-for-bin 1) op1)
(= (exp07-ordered-rule-id-for-bin 2) op2)
(= (exp07-ordered-rule-id-for-bin 3) op0)
(= (exp07-ordered-rule-id-for-bin 4) od0)
(= (exp07-ordered-rule-id-for-bin 5) od1)
(= (exp07-ordered-rule-id-for-bin 6) od2)
(= (exp07-ordered-rule-id-for-bin 7) od3)

(= (exp07-ordered-candidate-by-rule-id $wanted
      ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7))
   (if (== (rule-id (candidate-rule $c0)) $wanted) $c0
       (if (== (rule-id (candidate-rule $c1)) $wanted) $c1
           (if (== (rule-id (candidate-rule $c2)) $wanted) $c2
               (if (== (rule-id (candidate-rule $c3)) $wanted) $c3
                   (if (== (rule-id (candidate-rule $c4)) $wanted) $c4
                       (if (== (rule-id (candidate-rule $c5)) $wanted) $c5
                           (if (== (rule-id (candidate-rule $c6)) $wanted)
                               $c6 $c7))))))))

(= (exp07-ordered-replication-selected-with-draw
      $arm $cohort $chamber $draw)
   (exp07-ordered-replication-selected-from-pool
     $arm $chamber $draw
     (exp07-ordered-replication-pool $arm $cohort $chamber)))

(= (exp07-ordered-replication-selected-from-pool
      $arm $chamber $draw (candidate-pool $tick $candidates))
   (exp07-ordered-candidate-by-rule-id
     (exp07-ordered-rule-id-for-bin
       (exp07-ordered-bin $arm (exp07-ordered-phase $chamber) $draw))
     $candidates))

(= (exp07-ordered-replication-direct-tick-with-draw
      $arm $cohort $chamber $draw)
   (chamber-tick-with-candidate
     $chamber
     (exp07-ordered-replication-selected-with-draw
       $arm $cohort $chamber $draw)))

(= (exp07-ordered-replication-pre-run-gate)
   (ordered-replication-pre-run-gate
     seed-support-boundaries
       ((seed-101 (seed-number seed-101)) (seed-132 (seed-number seed-132)))
     complete-96-bin-calibration
       ((cohort-a (exp07-ordered-replication-draw-calibrated?
                    cohort-a seed-101))
        (cohort-b (exp07-ordered-replication-draw-calibrated?
                    cohort-b seed-117)))
     identical-arm-pools
       ((cohort-a (exp07-ordered-replication-pool-identity?
                    cohort-a
                    (exp07-ordered-replication-fixture cohort-a 0 0 0)))
        (cohort-b (exp07-ordered-replication-pool-identity?
                    cohort-b
                    (exp07-ordered-replication-fixture cohort-b 0 0 0))))
     cohort-b-selection-addressing rule-identity
     selector-mass-calibration
       ((unguided (exp07-ordered-bin-counts unguided ab-zero))
        (weak-doob-h (exp07-ordered-bin-counts weak-doob-h ab-zero))
        (shuffled-frontier-guidance
          (exp07-ordered-bin-counts
            shuffled-frontier-guidance ab-zero)))
     matched-guidance-cost-units ((weak-doob-h 8)
                                  (shuffled-frontier-guidance 8))
     synthetic-direct-tick required
     registered-trajectory-evaluated false
     chemistry-outcomes-used false
     emergence-claim none))

; ----- Ordered-replication cohort A: frozen trajectory matrix -----
;
; Cohort A is evaluated before cohort B, as preregistered.  These operations
; retain the ordinary ordered chamber transition and differ from the
; predecessor only in the frozen seed set and draw hash.
(= (exp07-ordered-replication-cohort-a-seeds)
   (seed-101 seed-102 seed-103 seed-104
    seed-105 seed-106 seed-107 seed-108
    seed-109 seed-110 seed-111 seed-112
    seed-113 seed-114 seed-115 seed-116))

(= (exp07-ordered-replication-cohort-b-seeds)
   (seed-117 seed-118 seed-119 seed-120
    seed-121 seed-122 seed-123 seed-124
    seed-125 seed-126 seed-127 seed-128
    seed-129 seed-130 seed-131 seed-132))

(= (exp07-ordered-replication-initial-chamber cohort-a $seed)
   (chamber exp07-ordered-replication
     (state 3 $seed
       (molecules
         ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
          (mol AB 0) (mol AC 0) (mol CD 0) (mol X 1)
          (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0))))
     ((rule ob0 A B AB X)
      (rule op1 A C AC AB)
      (rule op2 C D CD AC)
      (rule op0 A B AB CD)
      (rule od0 A C W0 X)
      (rule od1 B C W1 X)
      (rule od2 C D W2 X)
      (rule od3 A D W3 X)) ()))

(= (exp07-ordered-replication-initial-chamber cohort-b $seed)
   (chamber exp07-ordered-replication
     (state 3 $seed
       (molecules
         ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
          (mol AB 0) (mol AC 0) (mol CD 0) (mol X 1)
          (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0))))
     ((rule od2 C D W2 X)
      (rule op0 A B AB CD)
      (rule ob0 A B AB X)
      (rule od1 B C W1 X)
      (rule op2 C D CD AC)
      (rule od3 A D W3 X)
      (rule op1 A C AC AB)
      (rule od0 A C W0 X)) ()))

; Explicit cohort-A reductions avoid the same imported-equation boundary as
; the predecessor's registered seed draw clauses while preserving the frozen
; ((29 * seed) + (43 * tick) + 7) mod 96 hash exactly.
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-101 $tick)
   (#mod (+ 2936 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-102 $tick)
   (#mod (+ 2965 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-103 $tick)
   (#mod (+ 2994 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-104 $tick)
   (#mod (+ 3023 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-105 $tick)
   (#mod (+ 3052 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-106 $tick)
   (#mod (+ 3081 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-107 $tick)
   (#mod (+ 3110 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-108 $tick)
   (#mod (+ 3139 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-109 $tick)
   (#mod (+ 3168 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-110 $tick)
   (#mod (+ 3197 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-111 $tick)
   (#mod (+ 3226 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-112 $tick)
   (#mod (+ 3255 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-113 $tick)
   (#mod (+ 3284 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-114 $tick)
   (#mod (+ 3313 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-115 $tick)
   (#mod (+ 3342 (* 43 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-a seed-116 $tick)
   (#mod (+ 3371 (* 43 $tick)) 96))

; Cohort B uses the frozen ((47 * seed) + (53 * tick) + 11) mod 96 hash.
; Explicit reductions keep registered trajectories executable in the local
; PeTTa compiler, as for cohort A.
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-117 $tick)
   (#mod (+ 5510 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-118 $tick)
   (#mod (+ 5557 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-119 $tick)
   (#mod (+ 5604 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-120 $tick)
   (#mod (+ 5651 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-121 $tick)
   (#mod (+ 5698 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-122 $tick)
   (#mod (+ 5745 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-123 $tick)
   (#mod (+ 5792 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-124 $tick)
   (#mod (+ 5839 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-125 $tick)
   (#mod (+ 5886 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-126 $tick)
   (#mod (+ 5933 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-127 $tick)
   (#mod (+ 5980 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-128 $tick)
   (#mod (+ 6027 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-129 $tick)
   (#mod (+ 6074 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-130 $tick)
   (#mod (+ 6121 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-131 $tick)
   (#mod (+ 6168 (* 53 $tick)) 96))
(= (exp07-ordered-replication-trajectory-draw cohort-b seed-132 $tick)
   (#mod (+ 6215 (* 53 $tick)) 96))

(= (exp07-ordered-replication-selected-for-chamber $arm $cohort
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events))
   (exp07-ordered-replication-selected-with-draw
     $arm $cohort
     (chamber $id
       (state $tick $seed (molecules $molecules)) $rules $events)
     (exp07-ordered-replication-trajectory-draw $cohort $seed $tick)))

(= (exp07-ordered-replication-prepare-chamber
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events))
   (if (exp07-ordered-replenishment-tick? $tick)
       (exp07-ordered-replenish-food
         (chamber $id
           (state $tick $seed (molecules $molecules)) $rules $events))
       (chamber $id
         (state $tick $seed (molecules $molecules)) $rules $events)))

(= (exp07-ordered-replication-total-tick $arm $cohort $chamber)
   (let $prepared (exp07-ordered-replication-prepare-chamber $chamber)
     (let $selected
          (exp07-ordered-replication-selected-for-chamber
            $arm $cohort $prepared)
       (if (exp07-ordered-candidate-applicable? $selected $prepared)
           (exp07-ordered-fire-candidate $selected $prepared)
           (exp07-pilot-advance-blocked-tick $prepared)))))

(= (exp07-ordered-replication-run-to-state-tick
      $arm $cohort
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events)
      $terminal-state-tick)
   (if (>= $tick $terminal-state-tick)
       (chamber $id
         (state $tick $seed (molecules $molecules)) $rules $events)
       (exp07-ordered-replication-run-to-state-tick
         $arm $cohort
         (exp07-ordered-replication-total-tick
           $arm $cohort
           (chamber $id
             (state $tick $seed (molecules $molecules)) $rules $events))
         $terminal-state-tick)))

(= (exp07-ordered-replication-terminal-chamber $arm $cohort $seed)
   (exp07-ordered-replication-run-to-state-tick
     $arm $cohort
     (exp07-ordered-replication-initial-chamber $cohort $seed) 27))

(= (exp07-ordered-replication-event-count-from-terminal
      (chamber $id $state $rules $events))
   (exp07-registered-list-length $events))

(= (exp07-ordered-replication-event-count $arm $cohort $seed)
   (exp07-ordered-replication-event-count-from-terminal
     (exp07-ordered-replication-terminal-chamber $arm $cohort $seed)))

(= (exp07-ordered-replication-first-raf-tick-from-terminal
      (chamber $id $state $rules $events))
   (exp07-ordered-first-rolling-raf-from $events ()))

(= (exp07-ordered-replication-first-raf-tick $arm $cohort $seed)
   (exp07-ordered-replication-first-raf-tick-from-terminal
     (exp07-ordered-replication-terminal-chamber $arm $cohort $seed)))

(= (exp07-ordered-replication-raf-incidence $arm $cohort $seed)
   (if (< (exp07-ordered-replication-first-raf-tick
             $arm $cohort $seed) 99) 1 0))

(= (exp07-ordered-replication-replay-ok? $arm $cohort $seed)
   (== (exp07-ordered-replication-terminal-chamber $arm $cohort $seed)
       (exp07-ordered-replication-run-to-state-tick
         $arm $cohort
         (exp07-ordered-replication-initial-chamber $cohort $seed) 27)))

(= (exp07-ordered-replication-window-raf?
      (chamber $id $state $rules $events))
   (exp07-ordered-event-derived-raf?
     (exp07-rich-last-eight-events $events)))

(= (exp07-ordered-replication-persistence-from
      $arm $cohort
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events)
      $terminal-state-tick $current-run $longest-run)
   (if (>= $tick $terminal-state-tick)
       $longest-run
       (let $next
            (exp07-ordered-replication-total-tick
              $arm $cohort
              (chamber $id
                (state $tick $seed (molecules $molecules)) $rules $events))
         (let $next-run
              (if (exp07-ordered-replication-window-raf? $next)
                  (+ $current-run 1) 0)
           (let $next-longest
                (if (> $next-run $longest-run) $next-run $longest-run)
             (exp07-ordered-replication-persistence-from
               $arm $cohort $next $terminal-state-tick
               $next-run $next-longest))))))

(= (exp07-ordered-replication-raf-persistence $arm $cohort $seed)
   (exp07-ordered-replication-persistence-from
     $arm $cohort
     (exp07-ordered-replication-initial-chamber $cohort $seed) 27 0 0))

(= (exp07-ordered-replication-rule-diversity-from-terminal
      (chamber $id $state $rules $events))
   (+ (if (exp07-ordered-event-rule-fired? ob0 $events) 1 0)
        (+ (if (exp07-ordered-event-rule-fired? op1 $events) 1 0)
           (+ (if (exp07-ordered-event-rule-fired? op2 $events) 1 0)
              (+ (if (exp07-ordered-event-rule-fired? op0 $events) 1 0)
                 (+ (if (exp07-ordered-event-rule-fired? od0 $events) 1 0)
                    (+ (if (exp07-ordered-event-rule-fired? od1 $events) 1 0)
                       (+ (if (exp07-ordered-event-rule-fired? od2 $events) 1 0)
                          (if (exp07-ordered-event-rule-fired? od3 $events)
                              1 0)))))))))

(= (exp07-ordered-replication-rule-diversity $arm $cohort $seed)
   (exp07-ordered-replication-rule-diversity-from-terminal
     (exp07-ordered-replication-terminal-chamber $arm $cohort $seed)))

; Fold the fixed seed list without moving any chemistry computation to the
; host harness.  Value lists preserve preregistered per-seed provenance.
(= (exp07-ordered-replication-sum-raf $arm $cohort $seeds)
   (if (== $seeds ()) 0
       (+ (exp07-ordered-replication-raf-incidence
            $arm $cohort (car-atom $seeds))
          (exp07-ordered-replication-sum-raf
            $arm $cohort (cdr-atom $seeds)))))

(= (exp07-ordered-replication-sum-events $arm $cohort $seeds)
   (if (== $seeds ()) 0
       (+ (exp07-ordered-replication-event-count
            $arm $cohort (car-atom $seeds))
          (exp07-ordered-replication-sum-events
            $arm $cohort (cdr-atom $seeds)))))

(= (exp07-ordered-replication-sum-replays $arm $cohort $seeds)
   (if (== $seeds ()) 0
       (+ (if (exp07-ordered-replication-replay-ok?
                 $arm $cohort (car-atom $seeds)) 1 0)
          (exp07-ordered-replication-sum-replays
            $arm $cohort (cdr-atom $seeds)))))

(= (exp07-ordered-replication-sum-persistence $arm $cohort $seeds)
   (if (== $seeds ()) 0
       (+ (exp07-ordered-replication-raf-persistence
            $arm $cohort (car-atom $seeds))
          (exp07-ordered-replication-sum-persistence
            $arm $cohort (cdr-atom $seeds)))))

(= (exp07-ordered-replication-sum-diversity $arm $cohort $seeds)
   (if (== $seeds ()) 0
       (+ (exp07-ordered-replication-rule-diversity
            $arm $cohort (car-atom $seeds))
          (exp07-ordered-replication-sum-diversity
            $arm $cohort (cdr-atom $seeds)))))

(= (exp07-ordered-replication-first-hit-values $arm $cohort $seeds)
   (if (== $seeds ()) ()
       (cons-atom
         (exp07-ordered-replication-first-raf-tick
           $arm $cohort (car-atom $seeds))
         (exp07-ordered-replication-first-hit-values
           $arm $cohort (cdr-atom $seeds)))))

(= (exp07-ordered-replication-persistence-values $arm $cohort $seeds)
   (if (== $seeds ()) ()
       (cons-atom
         (exp07-ordered-replication-raf-persistence
           $arm $cohort (car-atom $seeds))
         (exp07-ordered-replication-persistence-values
           $arm $cohort (cdr-atom $seeds)))))

(= (exp07-ordered-replication-diversity-values $arm $cohort $seeds)
   (if (== $seeds ()) ()
       (cons-atom
         (exp07-ordered-replication-rule-diversity
           $arm $cohort (car-atom $seeds))
         (exp07-ordered-replication-diversity-values
           $arm $cohort (cdr-atom $seeds)))))

; Prespecified interventions keep the cohort-A hash, cap, schedule, and
; horizon.  Targeted selections become the ordinary blocked/no-event tick.
(= (exp07-ordered-replication-ablation-blocks-candidate?
      $ablation
      (candidate $tick (rule $rule-id $a $b $product $catalyst) $priority))
   (exp07-ordered-ablation-blocks? $ablation $rule-id))

(= (exp07-ordered-replication-ablation-total-tick
      $ablation $arm $cohort $chamber)
   (let $prepared (exp07-ordered-replication-prepare-chamber $chamber)
     (let $selected
          (exp07-ordered-replication-selected-for-chamber
            $arm $cohort $prepared)
       (if (exp07-ordered-replication-ablation-blocks-candidate?
             $ablation $selected)
           (exp07-pilot-advance-blocked-tick $prepared)
           (if (exp07-ordered-candidate-applicable? $selected $prepared)
               (exp07-ordered-fire-candidate $selected $prepared)
               (exp07-pilot-advance-blocked-tick $prepared))))))

(= (exp07-ordered-replication-ablation-run-to-state-tick
      $ablation $arm $cohort
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events)
      $terminal-state-tick)
   (if (>= $tick $terminal-state-tick)
       (chamber $id
         (state $tick $seed (molecules $molecules)) $rules $events)
       (exp07-ordered-replication-ablation-run-to-state-tick
         $ablation $arm $cohort
         (exp07-ordered-replication-ablation-total-tick
           $ablation $arm $cohort
           (chamber $id
             (state $tick $seed (molecules $molecules)) $rules $events))
         $terminal-state-tick)))

(= (exp07-ordered-replication-ablation-first-raf-from-terminal
      (chamber $id $state $rules $events))
   (exp07-ordered-first-rolling-raf-from $events ()))

(= (exp07-ordered-replication-ablation-raf-incidence
      $ablation $arm $cohort $seed)
   (if (<
         (exp07-ordered-replication-ablation-first-raf-from-terminal
           (exp07-ordered-replication-ablation-run-to-state-tick
             $ablation $arm $cohort
             (exp07-ordered-replication-initial-chamber $cohort $seed) 27))
         99) 1 0))

(= (exp07-ordered-replication-sum-ablation-raf
      $ablation $arm $cohort $seeds)
   (if (== $seeds ()) 0
       (+ (exp07-ordered-replication-ablation-raf-incidence
            $ablation $arm $cohort (car-atom $seeds))
          (exp07-ordered-replication-sum-ablation-raf
            $ablation $arm $cohort (cdr-atom $seeds)))))

(= (exp07-ordered-replication-cohort-a-primary-supported?)
   (let $seeds (exp07-ordered-replication-cohort-a-seeds)
     (let $weak
          (exp07-ordered-replication-sum-raf weak-doob-h cohort-a $seeds)
       (and
         (>= (- $weak
                (exp07-ordered-replication-sum-raf
                  unguided cohort-a $seeds)) 6)
         (and
           (>= (- $weak
                  (exp07-ordered-replication-sum-raf
                    shuffled-frontier-guidance cohort-a $seeds)) 6)
           (and
             (== (exp07-ordered-replication-sum-replays
                   unguided cohort-a $seeds) 16)
             (and
               (== (exp07-ordered-replication-sum-replays
                     weak-doob-h cohort-a $seeds) 16)
               (and
                 (== (exp07-ordered-replication-sum-replays
                       shuffled-frontier-guidance cohort-a $seeds) 16)
                 (and
                   (<= (exp07-ordered-replication-sum-ablation-raf
                         bootstrap-ablation weak-doob-h cohort-a $seeds) 2)
                   (and
                     (<= (exp07-ordered-replication-sum-ablation-raf
                           catalyst-ablation weak-doob-h cohort-a $seeds) 2)
                     (and
                       (<= (exp07-ordered-replication-sum-ablation-raf
                             rule-ablation-op1 weak-doob-h cohort-a $seeds) 2)
                       (and
                         (<= (exp07-ordered-replication-sum-ablation-raf
                               rule-ablation-op2 weak-doob-h cohort-a $seeds) 2)
                         (<= (exp07-ordered-replication-sum-ablation-raf
                               rule-ablation-op0 weak-doob-h
                               cohort-a $seeds) 2)))))))))))))

(= (exp07-ordered-replication-cohort-a-report)
   (let $seeds (exp07-ordered-replication-cohort-a-seeds)
     (ordered-replication-cohort-a-report
       arms (unguided weak-doob-h shuffled-frontier-guidance)
       seeds $seeds ticks (3 26) candidate-cap 8
       raf-incidence
         ((unguided (exp07-ordered-replication-sum-raf
                      unguided cohort-a $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-raf
                         weak-doob-h cohort-a $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-raf
              shuffled-frontier-guidance cohort-a $seeds)))
       first-hit-ticks
         ((unguided (exp07-ordered-replication-first-hit-values
                      unguided cohort-a $seeds))
          (weak-doob-h (exp07-ordered-replication-first-hit-values
                         weak-doob-h cohort-a $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-first-hit-values
              shuffled-frontier-guidance cohort-a $seeds)))
       longest-consecutive-raf-ticks
         ((unguided (exp07-ordered-replication-persistence-values
                      unguided cohort-a $seeds))
          (weak-doob-h (exp07-ordered-replication-persistence-values
                         weak-doob-h cohort-a $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-persistence-values
              shuffled-frontier-guidance cohort-a $seeds)))
       total-persistence
         ((unguided (exp07-ordered-replication-sum-persistence
                      unguided cohort-a $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-persistence
                         weak-doob-h cohort-a $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-persistence
              shuffled-frontier-guidance cohort-a $seeds)))
       productive-event-totals
         ((unguided (exp07-ordered-replication-sum-events
                      unguided cohort-a $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-events
                         weak-doob-h cohort-a $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-events
              shuffled-frontier-guidance cohort-a $seeds)))
       terminal-rule-diversity
         ((unguided (exp07-ordered-replication-diversity-values
                      unguided cohort-a $seeds))
          (weak-doob-h (exp07-ordered-replication-diversity-values
                         weak-doob-h cohort-a $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-diversity-values
              shuffled-frontier-guidance cohort-a $seeds)))
       total-rule-diversity
         ((unguided (exp07-ordered-replication-sum-diversity
                      unguided cohort-a $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-diversity
                         weak-doob-h cohort-a $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-diversity
              shuffled-frontier-guidance cohort-a $seeds)))
       exact-replays
         ((unguided (exp07-ordered-replication-sum-replays
                      unguided cohort-a $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-replays
                         weak-doob-h cohort-a $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-replays
              shuffled-frontier-guidance cohort-a $seeds)))
       intervention-cost
         (denominator-per-draw 96 draws-per-trajectory 24
          trajectories-per-arm 16
          full-matrix ((unguided 0) (weak-doob-h 3072)
                       (shuffled-frontier-guidance 3072))
          matched-guidance-budget true)
       causal-ablations
         (guiding-term-removal
            (weak-policy-replaced-by unguided raf-incidence
              (exp07-ordered-replication-sum-raf
                unguided cohort-a $seeds))
          bootstrap-ablation
            ((unguided (exp07-ordered-replication-sum-ablation-raf
                         bootstrap-ablation unguided cohort-a $seeds))
             (weak-doob-h (exp07-ordered-replication-sum-ablation-raf
                            bootstrap-ablation weak-doob-h cohort-a $seeds))
             (shuffled-frontier-guidance
               (exp07-ordered-replication-sum-ablation-raf
                 bootstrap-ablation shuffled-frontier-guidance
                 cohort-a $seeds)))
          catalyst-ablation
            ((unguided (exp07-ordered-replication-sum-ablation-raf
                         catalyst-ablation unguided cohort-a $seeds))
             (weak-doob-h (exp07-ordered-replication-sum-ablation-raf
                            catalyst-ablation weak-doob-h cohort-a $seeds))
             (shuffled-frontier-guidance
               (exp07-ordered-replication-sum-ablation-raf
                 catalyst-ablation shuffled-frontier-guidance
                 cohort-a $seeds)))
          rule-ablation
            ((op1 (exp07-ordered-replication-sum-ablation-raf
                    rule-ablation-op1 weak-doob-h cohort-a $seeds))
             (op2 (exp07-ordered-replication-sum-ablation-raf
                    rule-ablation-op2 weak-doob-h cohort-a $seeds))
             (op0 (exp07-ordered-replication-sum-ablation-raf
                    rule-ablation-op0 weak-doob-h cohort-a $seeds))))
       rolling-detector ordered-op1-op2-op0
       primary-replication
         (if (exp07-ordered-replication-cohort-a-primary-supported?)
             supported not-supported)
       adaptive-extension none
       cohort-b-evaluated false
       spontaneous-emergence-claim none)))

; Cohort B is a separately interpreted order/hash robustness characterization.
; It cannot rescue cohort A's failed primary replication.
(= (exp07-ordered-replication-cohort-b-robustness-supported?)
   (let $seeds (exp07-ordered-replication-cohort-b-seeds)
     (let $weak
          (exp07-ordered-replication-sum-raf weak-doob-h cohort-b $seeds)
       (and
         (>= (- $weak
                (exp07-ordered-replication-sum-raf
                  unguided cohort-b $seeds)) 4)
         (and
           (>= (- $weak
                  (exp07-ordered-replication-sum-raf
                    shuffled-frontier-guidance cohort-b $seeds)) 4)
           (and
             (== (exp07-ordered-replication-sum-replays
                   unguided cohort-b $seeds) 16)
             (and
               (== (exp07-ordered-replication-sum-replays
                     weak-doob-h cohort-b $seeds) 16)
               (and
                 (== (exp07-ordered-replication-sum-replays
                       shuffled-frontier-guidance cohort-b $seeds) 16)
                 (and
                   (<= (exp07-ordered-replication-sum-ablation-raf
                         bootstrap-ablation weak-doob-h cohort-b $seeds) 2)
                   (and
                     (<= (exp07-ordered-replication-sum-raf
                           unguided cohort-b $seeds) 2)
                     (and
                       (<= (exp07-ordered-replication-sum-ablation-raf
                             catalyst-ablation weak-doob-h cohort-b $seeds) 2)
                       (and
                         (<= (exp07-ordered-replication-sum-ablation-raf
                               rule-ablation-op1 weak-doob-h cohort-b $seeds) 2)
                         (and
                           (<= (exp07-ordered-replication-sum-ablation-raf
                                 rule-ablation-op2 weak-doob-h cohort-b $seeds) 2)
                           (<= (exp07-ordered-replication-sum-ablation-raf
                                 rule-ablation-op0 weak-doob-h
                                 cohort-b $seeds) 2))))))))))))))

(= (exp07-ordered-replication-cohort-b-report)
   (let $seeds (exp07-ordered-replication-cohort-b-seeds)
     (ordered-replication-cohort-b-report
       arms (unguided weak-doob-h shuffled-frontier-guidance)
       seeds $seeds ticks (3 26) candidate-cap 8
       raf-incidence
         ((unguided (exp07-ordered-replication-sum-raf
                      unguided cohort-b $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-raf
                         weak-doob-h cohort-b $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-raf
              shuffled-frontier-guidance cohort-b $seeds)))
       first-hit-ticks
         ((unguided (exp07-ordered-replication-first-hit-values
                      unguided cohort-b $seeds))
          (weak-doob-h (exp07-ordered-replication-first-hit-values
                         weak-doob-h cohort-b $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-first-hit-values
              shuffled-frontier-guidance cohort-b $seeds)))
       longest-consecutive-raf-ticks
         ((unguided (exp07-ordered-replication-persistence-values
                      unguided cohort-b $seeds))
          (weak-doob-h (exp07-ordered-replication-persistence-values
                         weak-doob-h cohort-b $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-persistence-values
              shuffled-frontier-guidance cohort-b $seeds)))
       total-persistence
         ((unguided (exp07-ordered-replication-sum-persistence
                      unguided cohort-b $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-persistence
                         weak-doob-h cohort-b $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-persistence
              shuffled-frontier-guidance cohort-b $seeds)))
       productive-event-totals
         ((unguided (exp07-ordered-replication-sum-events
                      unguided cohort-b $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-events
                         weak-doob-h cohort-b $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-events
              shuffled-frontier-guidance cohort-b $seeds)))
       terminal-rule-diversity
         ((unguided (exp07-ordered-replication-diversity-values
                      unguided cohort-b $seeds))
          (weak-doob-h (exp07-ordered-replication-diversity-values
                         weak-doob-h cohort-b $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-diversity-values
              shuffled-frontier-guidance cohort-b $seeds)))
       total-rule-diversity
         ((unguided (exp07-ordered-replication-sum-diversity
                      unguided cohort-b $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-diversity
                         weak-doob-h cohort-b $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-diversity
              shuffled-frontier-guidance cohort-b $seeds)))
       exact-replays
         ((unguided (exp07-ordered-replication-sum-replays
                      unguided cohort-b $seeds))
          (weak-doob-h (exp07-ordered-replication-sum-replays
                         weak-doob-h cohort-b $seeds))
          (shuffled-frontier-guidance
            (exp07-ordered-replication-sum-replays
              shuffled-frontier-guidance cohort-b $seeds)))
       intervention-cost
         (denominator-per-draw 96 draws-per-trajectory 24
          trajectories-per-arm 16
          full-matrix ((unguided 0) (weak-doob-h 3072)
                       (shuffled-frontier-guidance 3072))
          matched-guidance-budget true)
       causal-ablations
         (guiding-term-removal
            (weak-policy-replaced-by unguided raf-incidence
              (exp07-ordered-replication-sum-raf
                unguided cohort-b $seeds))
          bootstrap-ablation
            ((unguided (exp07-ordered-replication-sum-ablation-raf
                         bootstrap-ablation unguided cohort-b $seeds))
             (weak-doob-h (exp07-ordered-replication-sum-ablation-raf
                            bootstrap-ablation weak-doob-h cohort-b $seeds))
             (shuffled-frontier-guidance
               (exp07-ordered-replication-sum-ablation-raf
                 bootstrap-ablation shuffled-frontier-guidance
                 cohort-b $seeds)))
          catalyst-ablation
            ((unguided (exp07-ordered-replication-sum-ablation-raf
                         catalyst-ablation unguided cohort-b $seeds))
             (weak-doob-h (exp07-ordered-replication-sum-ablation-raf
                            catalyst-ablation weak-doob-h cohort-b $seeds))
             (shuffled-frontier-guidance
               (exp07-ordered-replication-sum-ablation-raf
                 catalyst-ablation shuffled-frontier-guidance
                 cohort-b $seeds)))
          rule-ablation
            ((op1 (exp07-ordered-replication-sum-ablation-raf
                    rule-ablation-op1 weak-doob-h cohort-b $seeds))
             (op2 (exp07-ordered-replication-sum-ablation-raf
                    rule-ablation-op2 weak-doob-h cohort-b $seeds))
             (op0 (exp07-ordered-replication-sum-ablation-raf
                    rule-ablation-op0 weak-doob-h cohort-b $seeds))))
       rolling-detector ordered-op1-op2-op0
       order-hash-robustness
         (if (exp07-ordered-replication-cohort-b-robustness-supported?)
             supported not-supported)
       cohort-a-primary-replication not-supported
       cohort-b-cannot-rescue-cohort-a true
       adaptive-extension none
       spontaneous-emergence-claim none)))

; ----- Frozen ordered-bootstrap trajectory matrix -----
;
; Consume exactly ticks 3--26 for held-out seeds 19--26.  The chamber is
; replenished immediately before ticks 11 and 19, selection reads only the
; current AB/AC/CD frontier phase, and every draw comes from the regenerated
; bounded cap-8 pool.  Inapplicable selections advance time without events.
(= (exp07-ordered-replenishment-tick? $tick)
   (or (== $tick 11) (== $tick 19)))

(= (exp07-ordered-replenish-food
      (chamber $id
        (state $tick $seed
          (molecules
            ((mol A $a) (mol B $b) (mol C $c) (mol D $d)
             (mol AB $ab) (mol AC $ac) (mol CD $cd) (mol X $x)
             (mol W0 $w0) (mol W1 $w1) (mol W2 $w2) (mol W3 $w3))))
        $rules $events))
   (chamber $id
     (state $tick $seed
       (molecules
         ((mol A 4) (mol B 3) (mol C 4) (mol D 3)
          (mol AB $ab) (mol AC $ac) (mol CD $cd) (mol X $x)
          (mol W0 $w0) (mol W1 $w1) (mol W2 $w2) (mol W3 $w3))))
     $rules $events))

(= (exp07-ordered-prepare-chamber
      (chamber $id $state $rules $events))
   (if (exp07-ordered-replenishment-tick? (state-tick $state))
       (exp07-ordered-replenish-food
         (chamber $id $state $rules $events))
       (chamber $id $state $rules $events)))

(= (exp07-ordered-selected-for-chamber $arm
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events))
   (exp07-ordered-selected-with-draw
     $arm
     (chamber $id
       (state $tick $seed (molecules $molecules)) $rules $events)
     (exp07-ordered-draw $seed $tick)))

(= (exp07-ordered-abundance $name
      ((mol $n0 $v0) (mol $n1 $v1) (mol $n2 $v2) (mol $n3 $v3)
       (mol $n4 $v4) (mol $n5 $v5) (mol $n6 $v6) (mol $n7 $v7)
       (mol $n8 $v8) (mol $n9 $v9) (mol $n10 $v10) (mol $n11 $v11)))
   (if (== $name $n0) $v0 (if (== $name $n1) $v1
     (if (== $name $n2) $v2 (if (== $name $n3) $v3
       (if (== $name $n4) $v4 (if (== $name $n5) $v5
         (if (== $name $n6) $v6 (if (== $name $n7) $v7
           (if (== $name $n8) $v8 (if (== $name $n9) $v9
             (if (== $name $n10) $v10
               (if (== $name $n11) $v11 0)))))))))))))

(= (exp07-ordered-candidate-applicable?
      (candidate $tick (rule $rid $a $b $product $catalyst) $priority)
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events))
   (and (> (exp07-ordered-abundance $a $molecules) 0)
        (and (> (exp07-ordered-abundance $b $molecules) 0)
             (> (exp07-ordered-abundance $catalyst $molecules) 0))))

(= (exp07-ordered-reaction-delta $name $a $b $product)
   (if (== $name $a) -1
       (if (== $name $b) -1
           (if (== $name $product) 1 0))))

(= (exp07-ordered-update-molecule
      (mol $name $abundance) $a $b $product)
   (mol $name
     (+ $abundance
        (exp07-ordered-reaction-delta $name $a $b $product))))

(= (exp07-ordered-fire-candidate
      (candidate $tick (rule $rid $a $b $product $catalyst) $priority)
      (chamber $id
        (state $tick $seed
          (molecules
            ($m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11)))
        $rules $events))
   (chamber $id
     (state (+ $tick 1) $seed
       (molecules
         ((exp07-ordered-update-molecule $m0 $a $b $product)
          (exp07-ordered-update-molecule $m1 $a $b $product)
          (exp07-ordered-update-molecule $m2 $a $b $product)
          (exp07-ordered-update-molecule $m3 $a $b $product)
          (exp07-ordered-update-molecule $m4 $a $b $product)
          (exp07-ordered-update-molecule $m5 $a $b $product)
          (exp07-ordered-update-molecule $m6 $a $b $product)
          (exp07-ordered-update-molecule $m7 $a $b $product)
          (exp07-ordered-update-molecule $m8 $a $b $product)
          (exp07-ordered-update-molecule $m9 $a $b $product)
          (exp07-ordered-update-molecule $m10 $a $b $product)
          (exp07-ordered-update-molecule $m11 $a $b $product))))
     $rules
     (exp07-rich-append-event
       $events (event $tick $rid $a $b $product $catalyst))))

(= (exp07-ordered-total-tick $arm $chamber)
   (let $prepared (exp07-ordered-prepare-chamber $chamber)
     (let $selected (exp07-ordered-selected-for-chamber $arm $prepared)
       (if (exp07-ordered-candidate-applicable? $selected $prepared)
           (exp07-ordered-fire-candidate $selected $prepared)
           (exp07-pilot-advance-blocked-tick $prepared)))))

(= (exp07-ordered-run-to-state-tick $arm
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events)
      $terminal-state-tick)
   (if (>= $tick $terminal-state-tick)
       (chamber $id
         (state $tick $seed (molecules $molecules)) $rules $events)
       (exp07-ordered-run-to-state-tick
         $arm
         (exp07-ordered-total-tick
           $arm
           (chamber $id
             (state $tick $seed (molecules $molecules)) $rules $events))
         $terminal-state-tick)))

(= (exp07-ordered-terminal-chamber $arm $seed)
   (exp07-ordered-run-to-state-tick
     $arm (exp07-ordered-initial-chamber $seed) 27))

(= (exp07-ordered-event-count-from-terminal
      (chamber $id $state $rules $events))
   (exp07-registered-list-length $events))

(= (exp07-ordered-event-count $arm $seed)
   (exp07-ordered-event-count-from-terminal
     (exp07-ordered-terminal-chamber $arm $seed)))

(= (exp07-ordered-first-raf-tick-from-terminal
      (chamber $id $state $rules $events))
   (exp07-ordered-first-rolling-raf-from
     $events ()))

; Keep the ordered successor's rolling detector local to its registered
; op1/op2/op0 rule IDs.  Reusing the rich-pool recursion here would silently
; test the historical rp0/rp1/rp2 cycle instead.
(= (exp07-ordered-first-rolling-raf-from $remaining $seen)
   (if (== $remaining ())
       99
       (let $event (car-atom $remaining)
         (let $next-seen (exp07-rich-append-event $seen $event)
           (if (exp07-ordered-event-derived-raf?
                 (exp07-rich-last-eight-events $next-seen))
               (exp07-event-tick $event)
               (exp07-ordered-first-rolling-raf-from
                 (cdr-atom $remaining) $next-seen))))))

(= (exp07-ordered-first-raf-tick $arm $seed)
   (exp07-ordered-first-raf-tick-from-terminal
     (exp07-ordered-terminal-chamber $arm $seed)))

(= (exp07-ordered-raf-incidence $arm $seed)
   (if (< (exp07-ordered-first-raf-tick $arm $seed) 99) 1 0))

(= (exp07-ordered-replay-ok? $arm $seed)
   (== (exp07-ordered-terminal-chamber $arm $seed)
       (exp07-ordered-run-to-state-tick
         $arm (exp07-ordered-initial-chamber $seed) 27)))

; Secondary endpoints consume only the already-frozen trajectories.  The
; persistence recursion evaluates the ordered rolling condition after every
; registered tick, including blocked ticks, while diversity counts distinct
; productive rule IDs from the exact shared cap-8 pool.
(= (exp07-ordered-persistence-from
      $arm $chamber $terminal-state-tick $current-run $longest-run)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick)
       $longest-run
       (let $next (exp07-ordered-total-tick $arm $chamber)
         (let $next-run
              (if (exp07-ordered-event-derived-raf?
                    (exp07-rich-last-eight-events (chamber-events $next)))
                  (+ $current-run 1)
                  0)
           (let $next-longest
                (if (> $next-run $longest-run) $next-run $longest-run)
             (exp07-ordered-persistence-from
               $arm $next $terminal-state-tick $next-run $next-longest))))))

(= (exp07-ordered-raf-persistence $arm $seed)
   (exp07-ordered-persistence-from
     $arm (exp07-ordered-initial-chamber $seed) 27 0 0))

(= (exp07-ordered-rule-diversity $arm $seed)
   (let $events (chamber-events (exp07-ordered-terminal-chamber $arm $seed))
     (+ (if (exp07-ordered-event-rule-fired? ob0 $events) 1 0)
        (+ (if (exp07-ordered-event-rule-fired? op1 $events) 1 0)
           (+ (if (exp07-ordered-event-rule-fired? op2 $events) 1 0)
              (+ (if (exp07-ordered-event-rule-fired? op0 $events) 1 0)
                 (+ (if (exp07-ordered-event-rule-fired? od0 $events) 1 0)
                    (+ (if (exp07-ordered-event-rule-fired? od1 $events) 1 0)
                       (+ (if (exp07-ordered-event-rule-fired? od2 $events) 1 0)
                          (if (exp07-ordered-event-rule-fired? od3 $events)
                              1 0))))))))))

(= (exp07-ordered-diversity-collapse $arm $seed)
   (- 8 (exp07-ordered-rule-diversity $arm $seed)))

(= (exp07-ordered-arm-total-persistence $arm)
   (+ (exp07-ordered-raf-persistence $arm seed-19)
      (+ (exp07-ordered-raf-persistence $arm seed-20)
         (+ (exp07-ordered-raf-persistence $arm seed-21)
            (+ (exp07-ordered-raf-persistence $arm seed-22)
               (+ (exp07-ordered-raf-persistence $arm seed-23)
                  (+ (exp07-ordered-raf-persistence $arm seed-24)
                     (+ (exp07-ordered-raf-persistence $arm seed-25)
                        (exp07-ordered-raf-persistence
                          $arm seed-26)))))))))

(= (exp07-ordered-arm-total-rule-diversity $arm)
   (+ (exp07-ordered-rule-diversity $arm seed-19)
      (+ (exp07-ordered-rule-diversity $arm seed-20)
         (+ (exp07-ordered-rule-diversity $arm seed-21)
            (+ (exp07-ordered-rule-diversity $arm seed-22)
               (+ (exp07-ordered-rule-diversity $arm seed-23)
                  (+ (exp07-ordered-rule-diversity $arm seed-24)
                     (+ (exp07-ordered-rule-diversity $arm seed-25)
                        (exp07-ordered-rule-diversity
                          $arm seed-26)))))))))

(= (exp07-ordered-arm-total-diversity-collapse $arm)
   (- 64 (exp07-ordered-arm-total-rule-diversity $arm)))

; Prespecified causal interventions preserve the frozen draw function, cap-8
; pool, food schedule, and horizon.  A targeted selection becomes the same
; blocked/no-event tick used by the registered dynamics.
(= (exp07-ordered-ablation-blocks? bootstrap-ablation $rule-id)
   (== $rule-id ob0))
(= (exp07-ordered-ablation-blocks? catalyst-ablation $rule-id)
   (or (== $rule-id op1)
       (or (== $rule-id op2) (== $rule-id op0))))
(= (exp07-ordered-ablation-blocks? rule-ablation-op1 $rule-id)
   (== $rule-id op1))
(= (exp07-ordered-ablation-blocks? rule-ablation-op2 $rule-id)
   (== $rule-id op2))
(= (exp07-ordered-ablation-blocks? rule-ablation-op0 $rule-id)
   (== $rule-id op0))

(= (exp07-ordered-ablation-total-tick $ablation $arm $chamber)
   (let $prepared (exp07-ordered-prepare-chamber $chamber)
     (let $selected (exp07-ordered-selected-for-chamber $arm $prepared)
       (if (exp07-ordered-ablation-blocks?
             $ablation (rule-id (candidate-rule $selected)))
           (exp07-pilot-advance-blocked-tick $prepared)
           (if (exp07-ordered-candidate-applicable? $selected $prepared)
               (exp07-ordered-fire-candidate $selected $prepared)
               (exp07-pilot-advance-blocked-tick $prepared))))))

(= (exp07-ordered-ablation-run-to-state-tick
      $ablation $arm $chamber $terminal-state-tick)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick)
       $chamber
       (exp07-ordered-ablation-run-to-state-tick
         $ablation $arm
         (exp07-ordered-ablation-total-tick $ablation $arm $chamber)
         $terminal-state-tick)))

(= (exp07-ordered-ablation-terminal-chamber $ablation $arm $seed)
   (exp07-ordered-ablation-run-to-state-tick
     $ablation $arm (exp07-ordered-initial-chamber $seed) 27))

(= (exp07-ordered-ablation-raf-incidence $ablation $arm $seed)
   (if (< (exp07-ordered-first-rolling-raf-from
             (chamber-events
               (exp07-ordered-ablation-terminal-chamber
                 $ablation $arm $seed))
             ())
          99)
       1 0))

(= (exp07-ordered-ablation-arm-raf-incidence $ablation $arm)
   (+ (exp07-ordered-ablation-raf-incidence $ablation $arm seed-19)
      (+ (exp07-ordered-ablation-raf-incidence $ablation $arm seed-20)
         (+ (exp07-ordered-ablation-raf-incidence $ablation $arm seed-21)
            (+ (exp07-ordered-ablation-raf-incidence $ablation $arm seed-22)
               (+ (exp07-ordered-ablation-raf-incidence
                    $ablation $arm seed-23)
                  (+ (exp07-ordered-ablation-raf-incidence
                       $ablation $arm seed-24)
                     (+ (exp07-ordered-ablation-raf-incidence
                          $ablation $arm seed-25)
                        (exp07-ordered-ablation-raf-incidence
                          $ablation $arm seed-26)))))))))

(= (exp07-ordered-causal-ablation-summary)
   (ordered-bootstrap-causal-ablation
     guiding-term-removal
       (weak-policy-replaced-by unguided
        raf-incidence (exp07-ordered-arm-raf-incidence unguided))
     bootstrap-ablation
       ((unguided (exp07-ordered-ablation-arm-raf-incidence
                    bootstrap-ablation unguided))
        (weak-doob-h (exp07-ordered-ablation-arm-raf-incidence
                       bootstrap-ablation weak-doob-h))
        (shuffled-frontier-guidance
          (exp07-ordered-ablation-arm-raf-incidence
            bootstrap-ablation shuffled-frontier-guidance)))
     catalyst-ablation
       (removed-edges ((AB op1) (AC op2) (CD op0))
        raf-incidence
          ((unguided (exp07-ordered-ablation-arm-raf-incidence
                       catalyst-ablation unguided))
           (weak-doob-h (exp07-ordered-ablation-arm-raf-incidence
                          catalyst-ablation weak-doob-h))
           (shuffled-frontier-guidance
             (exp07-ordered-ablation-arm-raf-incidence
               catalyst-ablation shuffled-frontier-guidance))))
     rule-ablation
       ((op1 (exp07-ordered-ablation-arm-raf-incidence
               rule-ablation-op1 weak-doob-h))
        (op2 (exp07-ordered-ablation-arm-raf-incidence
               rule-ablation-op2 weak-doob-h))
        (op0 (exp07-ordered-ablation-arm-raf-incidence
               rule-ablation-op0 weak-doob-h)))
     fixed-seeds-pool-draws-schedule true
     terminal-forcing prohibited
     guided-causal-raf-uplift supported
     spontaneous-emergence-claim none))

(= (exp07-ordered-secondary-summary)
   (ordered-bootstrap-secondary-summary
     longest-consecutive-raf-ticks
       ((unguided
          ((exp07-ordered-raf-persistence unguided seed-19)
           (exp07-ordered-raf-persistence unguided seed-20)
           (exp07-ordered-raf-persistence unguided seed-21)
           (exp07-ordered-raf-persistence unguided seed-22)
           (exp07-ordered-raf-persistence unguided seed-23)
           (exp07-ordered-raf-persistence unguided seed-24)
           (exp07-ordered-raf-persistence unguided seed-25)
           (exp07-ordered-raf-persistence unguided seed-26)))
        (weak-doob-h
          ((exp07-ordered-raf-persistence weak-doob-h seed-19)
           (exp07-ordered-raf-persistence weak-doob-h seed-20)
           (exp07-ordered-raf-persistence weak-doob-h seed-21)
           (exp07-ordered-raf-persistence weak-doob-h seed-22)
           (exp07-ordered-raf-persistence weak-doob-h seed-23)
           (exp07-ordered-raf-persistence weak-doob-h seed-24)
           (exp07-ordered-raf-persistence weak-doob-h seed-25)
           (exp07-ordered-raf-persistence weak-doob-h seed-26)))
        (shuffled-frontier-guidance
          ((exp07-ordered-raf-persistence shuffled-frontier-guidance seed-19)
           (exp07-ordered-raf-persistence shuffled-frontier-guidance seed-20)
           (exp07-ordered-raf-persistence shuffled-frontier-guidance seed-21)
           (exp07-ordered-raf-persistence shuffled-frontier-guidance seed-22)
           (exp07-ordered-raf-persistence shuffled-frontier-guidance seed-23)
           (exp07-ordered-raf-persistence shuffled-frontier-guidance seed-24)
           (exp07-ordered-raf-persistence shuffled-frontier-guidance seed-25)
           (exp07-ordered-raf-persistence shuffled-frontier-guidance seed-26))))
     total-persistence
       ((unguided (exp07-ordered-arm-total-persistence unguided))
        (weak-doob-h (exp07-ordered-arm-total-persistence weak-doob-h))
        (shuffled-frontier-guidance
          (exp07-ordered-arm-total-persistence
            shuffled-frontier-guidance)))
     terminal-rule-diversity
       ((unguided
          ((exp07-ordered-rule-diversity unguided seed-19)
           (exp07-ordered-rule-diversity unguided seed-20)
           (exp07-ordered-rule-diversity unguided seed-21)
           (exp07-ordered-rule-diversity unguided seed-22)
           (exp07-ordered-rule-diversity unguided seed-23)
           (exp07-ordered-rule-diversity unguided seed-24)
           (exp07-ordered-rule-diversity unguided seed-25)
           (exp07-ordered-rule-diversity unguided seed-26)))
        (weak-doob-h
          ((exp07-ordered-rule-diversity weak-doob-h seed-19)
           (exp07-ordered-rule-diversity weak-doob-h seed-20)
           (exp07-ordered-rule-diversity weak-doob-h seed-21)
           (exp07-ordered-rule-diversity weak-doob-h seed-22)
           (exp07-ordered-rule-diversity weak-doob-h seed-23)
           (exp07-ordered-rule-diversity weak-doob-h seed-24)
           (exp07-ordered-rule-diversity weak-doob-h seed-25)
           (exp07-ordered-rule-diversity weak-doob-h seed-26)))
        (shuffled-frontier-guidance
          ((exp07-ordered-rule-diversity shuffled-frontier-guidance seed-19)
           (exp07-ordered-rule-diversity shuffled-frontier-guidance seed-20)
           (exp07-ordered-rule-diversity shuffled-frontier-guidance seed-21)
           (exp07-ordered-rule-diversity shuffled-frontier-guidance seed-22)
           (exp07-ordered-rule-diversity shuffled-frontier-guidance seed-23)
           (exp07-ordered-rule-diversity shuffled-frontier-guidance seed-24)
           (exp07-ordered-rule-diversity shuffled-frontier-guidance seed-25)
           (exp07-ordered-rule-diversity shuffled-frontier-guidance seed-26))))
     total-rule-diversity
       ((unguided (exp07-ordered-arm-total-rule-diversity unguided))
        (weak-doob-h (exp07-ordered-arm-total-rule-diversity weak-doob-h))
        (shuffled-frontier-guidance
          (exp07-ordered-arm-total-rule-diversity
            shuffled-frontier-guidance)))
     total-diversity-collapse-from-full-pool
       ((unguided (exp07-ordered-arm-total-diversity-collapse unguided))
        (weak-doob-h
          (exp07-ordered-arm-total-diversity-collapse weak-doob-h))
        (shuffled-frontier-guidance
          (exp07-ordered-arm-total-diversity-collapse
            shuffled-frontier-guidance)))
     fixed-seeds-and-horizon true
     guided-causal-raf-uplift supported
     spontaneous-emergence-claim none))

(= (exp07-ordered-arm-raf-incidence $arm)
   (+ (exp07-ordered-raf-incidence $arm seed-19)
      (+ (exp07-ordered-raf-incidence $arm seed-20)
         (+ (exp07-ordered-raf-incidence $arm seed-21)
            (+ (exp07-ordered-raf-incidence $arm seed-22)
               (+ (exp07-ordered-raf-incidence $arm seed-23)
                  (+ (exp07-ordered-raf-incidence $arm seed-24)
                     (+ (exp07-ordered-raf-incidence $arm seed-25)
                        (exp07-ordered-raf-incidence $arm seed-26)))))))))

(= (exp07-ordered-arm-event-count $arm)
   (+ (exp07-ordered-event-count $arm seed-19)
      (+ (exp07-ordered-event-count $arm seed-20)
         (+ (exp07-ordered-event-count $arm seed-21)
            (+ (exp07-ordered-event-count $arm seed-22)
               (+ (exp07-ordered-event-count $arm seed-23)
                  (+ (exp07-ordered-event-count $arm seed-24)
                     (+ (exp07-ordered-event-count $arm seed-25)
                        (exp07-ordered-event-count $arm seed-26)))))))))

(= (exp07-ordered-arm-replay-count $arm)
   (+ (if (exp07-ordered-replay-ok? $arm seed-19) 1 0)
      (+ (if (exp07-ordered-replay-ok? $arm seed-20) 1 0)
         (+ (if (exp07-ordered-replay-ok? $arm seed-21) 1 0)
            (+ (if (exp07-ordered-replay-ok? $arm seed-22) 1 0)
               (+ (if (exp07-ordered-replay-ok? $arm seed-23) 1 0)
                  (+ (if (exp07-ordered-replay-ok? $arm seed-24) 1 0)
                     (+ (if (exp07-ordered-replay-ok? $arm seed-25) 1 0)
                        (if (exp07-ordered-replay-ok? $arm seed-26)
                            1 0)))))))))

(= (exp07-ordered-matrix-summary)
   (ordered-bootstrap-matrix-summary
     arms (unguided weak-doob-h shuffled-frontier-guidance)
     seeds (seed-19 seed-20 seed-21 seed-22
            seed-23 seed-24 seed-25 seed-26)
     ticks (3 26)
     raf-incidence
       ((unguided (exp07-ordered-arm-raf-incidence unguided))
        (weak-doob-h (exp07-ordered-arm-raf-incidence weak-doob-h))
        (shuffled-frontier-guidance
          (exp07-ordered-arm-raf-incidence shuffled-frontier-guidance)))
     first-hit-ticks
       ((unguided
          ((exp07-ordered-first-raf-tick unguided seed-19)
           (exp07-ordered-first-raf-tick unguided seed-20)
           (exp07-ordered-first-raf-tick unguided seed-21)
           (exp07-ordered-first-raf-tick unguided seed-22)
           (exp07-ordered-first-raf-tick unguided seed-23)
           (exp07-ordered-first-raf-tick unguided seed-24)
           (exp07-ordered-first-raf-tick unguided seed-25)
           (exp07-ordered-first-raf-tick unguided seed-26)))
        (weak-doob-h
          ((exp07-ordered-first-raf-tick weak-doob-h seed-19)
           (exp07-ordered-first-raf-tick weak-doob-h seed-20)
           (exp07-ordered-first-raf-tick weak-doob-h seed-21)
           (exp07-ordered-first-raf-tick weak-doob-h seed-22)
           (exp07-ordered-first-raf-tick weak-doob-h seed-23)
           (exp07-ordered-first-raf-tick weak-doob-h seed-24)
           (exp07-ordered-first-raf-tick weak-doob-h seed-25)
           (exp07-ordered-first-raf-tick weak-doob-h seed-26)))
        (shuffled-frontier-guidance
          ((exp07-ordered-first-raf-tick shuffled-frontier-guidance seed-19)
           (exp07-ordered-first-raf-tick shuffled-frontier-guidance seed-20)
           (exp07-ordered-first-raf-tick shuffled-frontier-guidance seed-21)
           (exp07-ordered-first-raf-tick shuffled-frontier-guidance seed-22)
           (exp07-ordered-first-raf-tick shuffled-frontier-guidance seed-23)
           (exp07-ordered-first-raf-tick shuffled-frontier-guidance seed-24)
           (exp07-ordered-first-raf-tick shuffled-frontier-guidance seed-25)
           (exp07-ordered-first-raf-tick shuffled-frontier-guidance seed-26))))
     productive-event-totals
       ((unguided (exp07-ordered-arm-event-count unguided))
        (weak-doob-h (exp07-ordered-arm-event-count weak-doob-h))
        (shuffled-frontier-guidance
          (exp07-ordered-arm-event-count shuffled-frontier-guidance)))
     exact-replays
       ((unguided (exp07-ordered-arm-replay-count unguided))
        (weak-doob-h (exp07-ordered-arm-replay-count weak-doob-h))
        (shuffled-frontier-guidance
          (exp07-ordered-arm-replay-count shuffled-frontier-guidance)))
     rolling-detector ordered-op1-op2-op0
     secondary-endpoints (exp07-ordered-secondary-summary)
     causal-ablations (exp07-ordered-causal-ablation-summary)
     adaptive-extension none
     guided-causal-raf-uplift supported
     spontaneous-emergence-claim none))

; ----- Frozen dual-bootstrap trajectory matrix -----
;
; Consume exactly ticks 3--34 for seeds 201--232.  Candidate generation,
; identity-addressed selection, applicability, firing, abundance updates, and
; event logging remain in PeTTa; the host runner only executes this file.
(= (exp07-dual-seeds)
   (seed-201 seed-202 seed-203 seed-204 seed-205 seed-206 seed-207 seed-208
    seed-209 seed-210 seed-211 seed-212 seed-213 seed-214 seed-215 seed-216
    seed-217 seed-218 seed-219 seed-220 seed-221 seed-222 seed-223 seed-224
    seed-225 seed-226 seed-227 seed-228 seed-229 seed-230 seed-231 seed-232))

(= (exp07-dual-initial-chamber $seed)
   (chamber exp07-dual-bootstrap
     (state 3 $seed
       (molecules
         ((mol A 3) (mol B 2) (mol C 3) (mol D 2) (mol E 2)
          (mol X 1) (mol AB 0) (mol CD 0) (mol AC 0) (mol BD 0) (mol CE 0)
          (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0) (mol W4 0) (mol W5 0))))
     (exp07-dual-rules canonical) ()))

(= (exp07-dual-replenishment-tick? $tick)
   (or (== $tick 11) (or (== $tick 19) (== $tick 27))))

(= (exp07-dual-replenish-food
      (chamber $id
        (state $tick $seed
          (molecules
            ((mol A $a) (mol B $b) (mol C $c) (mol D $d) (mol E $e)
             (mol X $x) (mol AB $ab) (mol CD $cd) (mol AC $ac)
             (mol BD $bd) (mol CE $ce) (mol W0 $w0) (mol W1 $w1)
             (mol W2 $w2) (mol W3 $w3) (mol W4 $w4) (mol W5 $w5))))
        $rules $events))
   (chamber $id
     (state $tick $seed
       (molecules
         ((mol A 3) (mol B 2) (mol C 3) (mol D 2) (mol E 2)
          (mol X $x) (mol AB $ab) (mol CD $cd) (mol AC $ac)
          (mol BD $bd) (mol CE $ce) (mol W0 $w0) (mol W1 $w1)
          (mol W2 $w2) (mol W3 $w3) (mol W4 $w4) (mol W5 $w5))))
     $rules $events))

(= (exp07-dual-prepare-chamber (chamber $id $state $rules $events))
   (if (exp07-dual-replenishment-tick? (state-tick $state))
       (exp07-dual-replenish-food (chamber $id $state $rules $events))
       (chamber $id $state $rules $events)))

(= (exp07-dual-draw $seed $tick)
   (#mod (+ (* 71 (seed-number $seed)) (+ (* 67 $tick) 19)) 96))

(= (exp07-dual-candidate-applicable?
      (candidate $tick (rule $rid $a $b $product $catalyst) $priority)
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events))
   (and (> (molecule-abundance-7 $a $molecules) 0)
        (and (> (molecule-abundance-7 $b $molecules) 0)
             (> (molecule-abundance-7 $catalyst $molecules) 0))))

(= (exp07-dual-reaction-delta $name $a $b $product)
   (if (== $name $a) -1
       (if (== $name $b) -1
           (if (== $name $product) 1 0))))
(= (exp07-dual-update-molecule (mol $name $abundance) $a $b $product)
   (mol $name
     (+ $abundance (exp07-dual-reaction-delta $name $a $b $product))))

(= (exp07-dual-fire-candidate
      (candidate $tick (rule $rid $a $b $product $catalyst) $priority)
      (chamber $id
        (state $tick $seed
          (molecules
            ($m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11
             $m12 $m13 $m14 $m15 $m16)))
        $rules $events))
   (chamber $id
     (state (+ $tick 1) $seed
       (molecules
         ((exp07-dual-update-molecule $m0 $a $b $product)
          (exp07-dual-update-molecule $m1 $a $b $product)
          (exp07-dual-update-molecule $m2 $a $b $product)
          (exp07-dual-update-molecule $m3 $a $b $product)
          (exp07-dual-update-molecule $m4 $a $b $product)
          (exp07-dual-update-molecule $m5 $a $b $product)
          (exp07-dual-update-molecule $m6 $a $b $product)
          (exp07-dual-update-molecule $m7 $a $b $product)
          (exp07-dual-update-molecule $m8 $a $b $product)
          (exp07-dual-update-molecule $m9 $a $b $product)
          (exp07-dual-update-molecule $m10 $a $b $product)
          (exp07-dual-update-molecule $m11 $a $b $product)
          (exp07-dual-update-molecule $m12 $a $b $product)
          (exp07-dual-update-molecule $m13 $a $b $product)
          (exp07-dual-update-molecule $m14 $a $b $product)
          (exp07-dual-update-molecule $m15 $a $b $product)
          (exp07-dual-update-molecule $m16 $a $b $product))))
     $rules
     (exp07-rich-append-event
       $events (event $tick $rid $a $b $product $catalyst))))

(= (exp07-dual-total-tick $arm $chamber)
   (let $prepared (exp07-dual-prepare-chamber $chamber)
     (let $selected (exp07-dual-selected-with-draw
          $arm $prepared
          (exp07-dual-draw
            (state-seed (chamber-state $prepared))
            (state-tick (chamber-state $prepared))))
       (if (exp07-dual-candidate-applicable? $selected $prepared)
           (exp07-dual-fire-candidate $selected $prepared)
           (exp07-pilot-advance-blocked-tick $prepared)))))

(= (exp07-dual-run-to-state-tick $arm $chamber $terminal-state-tick)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick)
       $chamber
       (exp07-dual-run-to-state-tick
         $arm (exp07-dual-total-tick $arm $chamber) $terminal-state-tick)))

(= (exp07-dual-terminal-chamber $arm $seed)
   (exp07-dual-run-to-state-tick
     $arm (exp07-dual-initial-chamber $seed) 35))

; ----- Frozen dual-bootstrap mechanism-audit trace gate -----
;
; Trace the already completed matrix without changing its chamber path.  Each
; row is constructed from the prepared pre-fire chamber and the exact selected
; candidate used by `exp07-dual-total-tick`.  The six product bits follow the
; frozen pathway identity order; db1 and dp0 deliberately both report CD.
(= (exp07-dual-present-bit $name $molecules)
   (if (> (molecule-abundance-7 $name $molecules) 0) 1 0))

(= (exp07-dual-trace-row-from-prepared
      $arm $seed
      (chamber $id
        (state $tick $seed (molecules $molecules)) $rules $events)
      (candidate $tick (rule $rid $a $b $product $catalyst) $priority))
   (let $applicable
        (exp07-dual-candidate-applicable?
          (candidate $tick (rule $rid $a $b $product $catalyst) $priority)
          (chamber $id
            (state $tick $seed (molecules $molecules)) $rules $events))
     (dual-mechanism-trace-row
       key ($arm $seed $tick)
       selected-rule $rid
       applicable $applicable
       event-fired $applicable
       first-absent-pathway
         (exp07-dual-frontier
           (chamber $id
             (state $tick $seed (molecules $molecules)) $rules $events))
       pathway-product-presence
         ((db0 (exp07-dual-present-bit AB $molecules))
          (db1 (exp07-dual-present-bit CD $molecules))
          (dp1 (exp07-dual-present-bit AC $molecules))
          (dp2 (exp07-dual-present-bit BD $molecules))
          (dp3 (exp07-dual-present-bit CE $molecules))
          (dp0 (exp07-dual-present-bit CD $molecules)))
       post-reset-pre-fire-food
         ((A (molecule-abundance-7 A $molecules))
          (B (molecule-abundance-7 B $molecules))
          (C (molecule-abundance-7 C $molecules))
          (D (molecule-abundance-7 D $molecules))
          (E (molecule-abundance-7 E $molecules))))))

(= (exp07-dual-trace-row $arm $chamber)
   (let $prepared (exp07-dual-prepare-chamber $chamber)
     (let $selected (exp07-dual-selected-with-draw
          $arm $prepared
          (exp07-dual-draw
            (state-seed (chamber-state $prepared))
            (state-tick (chamber-state $prepared))))
       (exp07-dual-trace-row-from-prepared $arm
         (state-seed (chamber-state $prepared)) $prepared $selected))))

(= (exp07-dual-trajectory-trace-from $arm $chamber $terminal-state-tick)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick) ()
       (cons-atom (exp07-dual-trace-row $arm $chamber)
         (exp07-dual-trajectory-trace-from $arm
           (exp07-dual-total-tick $arm $chamber) $terminal-state-tick))))
(= (exp07-dual-trajectory-trace $arm $seed)
   (exp07-dual-trajectory-trace-from
     $arm (exp07-dual-initial-chamber $seed) 35))

; Sequential validation proves both exact cardinality and uniqueness of
; (arm, seed, tick) keys: every expected tick 3--34 occurs exactly once.
(= (exp07-dual-trace-key
      (dual-mechanism-trace-row
        key $key selected-rule $rid applicable $applicable
        event-fired $fired first-absent-pathway $frontier
        pathway-product-presence $presence
        post-reset-pre-fire-food $food))
   $key)
(= (exp07-dual-trace-keys-sequential? $arm $seed $tick $rows)
   (if (== $rows ()) (== $tick 35)
       (and (== (exp07-dual-trace-key (car-atom $rows))
                 ($arm $seed $tick))
            (exp07-dual-trace-keys-sequential?
              $arm $seed (+ $tick 1) (cdr-atom $rows)))))
(= (exp07-dual-trajectory-trace-valid? $arm $seed)
   (let $rows (exp07-dual-trajectory-trace $arm $seed)
     (and (== (exp07-registered-list-length $rows) 32)
          (exp07-dual-trace-keys-sequential? $arm $seed 3 $rows))))
(= (exp07-dual-arm-traces-valid? $arm $seeds)
   (if (== $seeds ()) True
       (and (exp07-dual-trajectory-trace-valid? $arm (car-atom $seeds))
            (exp07-dual-arm-traces-valid? $arm (cdr-atom $seeds)))))

(= (exp07-dual-mechanism-trace-integrity-gate)
   (let $seeds (exp07-dual-seeds)
     (and (exp07-dual-arm-traces-valid? unguided $seeds)
      (and (exp07-dual-arm-traces-valid? weak-doob-h $seeds)
       (and (exp07-dual-arm-traces-valid?
              shuffled-frontier-guidance $seeds)
        (and (== (exp07-dual-sum raf unguided $seeds) 13)
         (and (== (exp07-dual-sum raf weak-doob-h $seeds) 9)
          (and (== (exp07-dual-sum raf
                    shuffled-frontier-guidance $seeds) 0)
           (and (== (exp07-dual-sum events unguided $seeds) 549)
            (and (== (exp07-dual-sum events weak-doob-h $seeds) 523)
             (and (== (exp07-dual-sum events
                       shuffled-frontier-guidance $seeds) 396)
              (and (== (exp07-dual-sum persistence unguided $seeds) 95)
               (and (== (exp07-dual-sum persistence weak-doob-h $seeds) 51)
                (and (== (exp07-dual-sum persistence
                          shuffled-frontier-guidance $seeds) 0)
                 (and (== (exp07-dual-sum diversity unguided $seeds) 336)
                  (and (== (exp07-dual-sum diversity weak-doob-h $seeds) 278)
                   (and (== (exp07-dual-sum diversity
                             shuffled-frontier-guidance $seeds) 219)
                    (and (== (exp07-dual-sum replay unguided $seeds) 32)
                     (and (== (exp07-dual-sum replay weak-doob-h $seeds) 32)
                          (== (exp07-dual-sum replay
                                shuffled-frontier-guidance $seeds)
                              32))))))))))))))))))))

; ----- Frozen dual-bootstrap mechanism diagnostics -----
;
; These folds consume only the validated trace rows above.  Keeping the
; classification in PeTTa prevents the reporting harness from silently
; reclassifying selections or applicability.
(= (exp07-dual-trace-selected-id
      (dual-mechanism-trace-row key $key selected-rule $rid
        applicable $applicable event-fired $fired
        first-absent-pathway $frontier pathway-product-presence $presence
        post-reset-pre-fire-food $food)) $rid)
(= (exp07-dual-trace-applicable
      (dual-mechanism-trace-row key $key selected-rule $rid
        applicable $applicable event-fired $fired
        first-absent-pathway $frontier pathway-product-presence $presence
        post-reset-pre-fire-food $food)) $applicable)
(= (exp07-dual-trace-frontier
      (dual-mechanism-trace-row key $key selected-rule $rid
        applicable $applicable event-fired $fired
        first-absent-pathway $frontier pathway-product-presence $presence
        post-reset-pre-fire-food $food)) $frontier)

(= (exp07-dual-pathway-rule? $rid)
   (if (== $rid db0) True
    (if (== $rid db1) True
     (if (== $rid dp1) True
      (if (== $rid dp2) True
       (if (== $rid dp3) True (== $rid dp0)))))))

(= (exp07-dual-count-selected $rid $rows)
   (if (== $rows ()) 0
       (+ (if (== (exp07-dual-trace-selected-id (car-atom $rows)) $rid) 1 0)
          (exp07-dual-count-selected $rid (cdr-atom $rows)))))
(= (exp07-dual-count-fired $rid $rows)
   (if (== $rows ()) 0
       (+ (if (and (== (exp07-dual-trace-selected-id (car-atom $rows)) $rid)
                    (exp07-dual-trace-applicable (car-atom $rows))) 1 0)
          (exp07-dual-count-fired $rid (cdr-atom $rows)))))
(= (exp07-dual-count-blocked-class $pathway? $rows)
   (if (== $rows ()) 0
       (+ (if (and (== (exp07-dual-trace-applicable (car-atom $rows)) False)
                    (== (exp07-dual-pathway-rule?
                          (exp07-dual-trace-selected-id (car-atom $rows)))
                        $pathway?)) 1 0)
          (exp07-dual-count-blocked-class $pathway? (cdr-atom $rows)))))
(= (exp07-dual-count-frontier-selected $rid $rows)
   (if (== $rows ()) 0
       (+ (if (and (== (exp07-dual-trace-frontier (car-atom $rows)) $rid)
                    (== (exp07-dual-trace-selected-id (car-atom $rows)) $rid))
              1 0)
          (exp07-dual-count-frontier-selected $rid (cdr-atom $rows)))))
(= (exp07-dual-count-frontier-fired $rid $rows)
   (if (== $rows ()) 0
       (+ (if (and (== (exp07-dual-trace-frontier (car-atom $rows)) $rid)
                    (and (== (exp07-dual-trace-selected-id (car-atom $rows)) $rid)
                         (exp07-dual-trace-applicable (car-atom $rows)))) 1 0)
          (exp07-dual-count-frontier-fired $rid (cdr-atom $rows)))))

(= (exp07-dual-sum-trace-measure $measure $arm $rid $seeds)
   (if (== $seeds ()) 0
       (+ (if (== $measure selected)
              (exp07-dual-count-selected $rid
                (exp07-dual-trajectory-trace $arm (car-atom $seeds)))
            (if (== $measure fired)
                (exp07-dual-count-fired $rid
                  (exp07-dual-trajectory-trace $arm (car-atom $seeds)))
             (if (== $measure frontier-selected)
                 (exp07-dual-count-frontier-selected $rid
                   (exp07-dual-trajectory-trace $arm (car-atom $seeds)))
                 (exp07-dual-count-frontier-fired $rid
                   (exp07-dual-trajectory-trace $arm (car-atom $seeds))))))
          (exp07-dual-sum-trace-measure $measure $arm $rid
            (cdr-atom $seeds)))))
(= (exp07-dual-sum-blocked-class $pathway? $arm $seeds)
   (if (== $seeds ()) 0
       (+ (exp07-dual-count-blocked-class $pathway?
            (exp07-dual-trajectory-trace $arm (car-atom $seeds)))
          (exp07-dual-sum-blocked-class $pathway? $arm (cdr-atom $seeds)))))

(= (exp07-dual-rule-count-row $arm $rid)
   (let $seeds (exp07-dual-seeds)
     ($rid
       selected (exp07-dual-sum-trace-measure selected $arm $rid $seeds)
       fired (exp07-dual-sum-trace-measure fired $arm $rid $seeds)
       first-absent-selected
         (exp07-dual-sum-trace-measure frontier-selected $arm $rid $seeds)
       first-absent-fired
         (exp07-dual-sum-trace-measure frontier-fired $arm $rid $seeds))))
(= (exp07-dual-mechanism-count-summary $arm)
   (dual-mechanism-count-summary $arm
     rules ((exp07-dual-rule-count-row $arm db0)
            (exp07-dual-rule-count-row $arm db1)
            (exp07-dual-rule-count-row $arm dp1)
            (exp07-dual-rule-count-row $arm dp2)
            (exp07-dual-rule-count-row $arm dp3)
            (exp07-dual-rule-count-row $arm dp0)
            (exp07-dual-rule-count-row $arm dd0)
            (exp07-dual-rule-count-row $arm dd1)
            (exp07-dual-rule-count-row $arm dd2)
            (exp07-dual-rule-count-row $arm dd3)
            (exp07-dual-rule-count-row $arm dd4)
            (exp07-dual-rule-count-row $arm dd5))
     blocked-pathway
       (exp07-dual-sum-blocked-class True $arm (exp07-dual-seeds))
     blocked-distractor
       (exp07-dual-sum-blocked-class False $arm (exp07-dual-seeds))))

(= (exp07-dual-blocked-first-absent-total $arm)
   (let $seeds (exp07-dual-seeds)
     (- (+ (exp07-dual-sum-trace-measure frontier-selected $arm db0 $seeds)
           (+ (exp07-dual-sum-trace-measure frontier-selected $arm db1 $seeds)
            (+ (exp07-dual-sum-trace-measure frontier-selected $arm dp1 $seeds)
             (+ (exp07-dual-sum-trace-measure frontier-selected $arm dp2 $seeds)
              (+ (exp07-dual-sum-trace-measure frontier-selected $arm dp3 $seeds)
                 (exp07-dual-sum-trace-measure frontier-selected $arm dp0 $seeds))))))
        (+ (exp07-dual-sum-trace-measure frontier-fired $arm db0 $seeds)
           (+ (exp07-dual-sum-trace-measure frontier-fired $arm db1 $seeds)
            (+ (exp07-dual-sum-trace-measure frontier-fired $arm dp1 $seeds)
             (+ (exp07-dual-sum-trace-measure frontier-fired $arm dp2 $seeds)
              (+ (exp07-dual-sum-trace-measure frontier-fired $arm dp3 $seeds)
                 (exp07-dual-sum-trace-measure frontier-fired $arm dp0 $seeds)))))))))

; The first frozen interpretation branch is already decisive once integrity
; passes: weak has 51 blocked first-absent selections versus unguided's 38.
(= (exp07-dual-mechanism-interpretation)
   (if (== (exp07-dual-mechanism-trace-integrity-gate) False) trace-mismatch
       (if (> (exp07-dual-blocked-first-absent-total weak-doob-h)
              (exp07-dual-blocked-first-absent-total unguided))
           applicability-loss unresolved/mixed)))

(= (exp07-dual-last-twelve-events $events)
   (if (> (exp07-registered-list-length $events) 12)
       (exp07-dual-last-twelve-events (cdr-atom $events))
       $events))

(= (exp07-dual-first-rolling-raf-from $remaining $seen)
   (if (== $remaining ()) 99
       (let $event (car-atom $remaining)
         (let $next-seen (exp07-rich-append-event $seen $event)
           (if (exp07-dual-event-derived-raf?
                 (exp07-dual-last-twelve-events $next-seen))
               (exp07-event-tick $event)
               (exp07-dual-first-rolling-raf-from
                 (cdr-atom $remaining) $next-seen))))))

(= (exp07-dual-first-raf-tick $arm $seed)
   (exp07-dual-first-rolling-raf-from
     (chamber-events (exp07-dual-terminal-chamber $arm $seed)) ()))
(= (exp07-dual-raf-incidence $arm $seed)
   (if (< (exp07-dual-first-raf-tick $arm $seed) 99) 1 0))
(= (exp07-dual-event-count $arm $seed)
   (exp07-registered-list-length
     (chamber-events (exp07-dual-terminal-chamber $arm $seed))))
(= (exp07-dual-replay-ok? $arm $seed)
   (== (exp07-dual-terminal-chamber $arm $seed)
       (exp07-dual-run-to-state-tick
         $arm (exp07-dual-initial-chamber $seed) 35)))

(= (exp07-dual-persistence-from
      $arm $chamber $terminal-state-tick $current-run $longest-run)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick)
       $longest-run
       (let $next (exp07-dual-total-tick $arm $chamber)
         (let $next-run
              (if (exp07-dual-event-derived-raf?
                    (exp07-dual-last-twelve-events (chamber-events $next)))
                  (+ $current-run 1) 0)
           (exp07-dual-persistence-from
             $arm $next $terminal-state-tick $next-run
             (if (> $next-run $longest-run) $next-run $longest-run))))))
(= (exp07-dual-raf-persistence $arm $seed)
   (exp07-dual-persistence-from
     $arm (exp07-dual-initial-chamber $seed) 35 0 0))

(= (exp07-dual-rule-diversity $arm $seed)
   (let $events (chamber-events (exp07-dual-terminal-chamber $arm $seed))
     (+ (if (exp07-dual-event-rule-fired? db0 $events) 1 0)
       (+ (if (exp07-dual-event-rule-fired? db1 $events) 1 0)
        (+ (if (exp07-dual-event-rule-fired? dp1 $events) 1 0)
         (+ (if (exp07-dual-event-rule-fired? dp2 $events) 1 0)
          (+ (if (exp07-dual-event-rule-fired? dp3 $events) 1 0)
           (+ (if (exp07-dual-event-rule-fired? dp0 $events) 1 0)
            (+ (if (exp07-dual-event-rule-fired? dd0 $events) 1 0)
             (+ (if (exp07-dual-event-rule-fired? dd1 $events) 1 0)
              (+ (if (exp07-dual-event-rule-fired? dd2 $events) 1 0)
               (+ (if (exp07-dual-event-rule-fired? dd3 $events) 1 0)
                (+ (if (exp07-dual-event-rule-fired? dd4 $events) 1 0)
                   (if (exp07-dual-event-rule-fired? dd5 $events) 1 0))))))))))))))

; Fixed-seed folds keep all endpoint computation and per-seed provenance in
; PeTTa while avoiding duplicated 32-term expressions.
(= (exp07-dual-value raf $arm $seed) (exp07-dual-raf-incidence $arm $seed))
(= (exp07-dual-value events $arm $seed) (exp07-dual-event-count $arm $seed))
(= (exp07-dual-value replay $arm $seed)
   (if (exp07-dual-replay-ok? $arm $seed) 1 0))
(= (exp07-dual-value persistence $arm $seed)
   (exp07-dual-raf-persistence $arm $seed))
(= (exp07-dual-value diversity $arm $seed)
   (exp07-dual-rule-diversity $arm $seed))
(= (exp07-dual-sum $metric $arm $seeds)
   (if (== $seeds ()) 0
       (+ (exp07-dual-value $metric $arm (car-atom $seeds))
          (exp07-dual-sum $metric $arm (cdr-atom $seeds)))))
(= (exp07-dual-values first-hit $arm $seeds)
   (if (== $seeds ()) ()
       (cons-atom (exp07-dual-first-raf-tick $arm (car-atom $seeds))
         (exp07-dual-values first-hit $arm (cdr-atom $seeds)))))
(= (exp07-dual-values persistence $arm $seeds)
   (if (== $seeds ()) ()
       (cons-atom (exp07-dual-raf-persistence $arm (car-atom $seeds))
         (exp07-dual-values persistence $arm (cdr-atom $seeds)))))
(= (exp07-dual-values diversity $arm $seeds)
   (if (== $seeds ()) ()
       (cons-atom (exp07-dual-rule-diversity $arm (car-atom $seeds))
         (exp07-dual-values diversity $arm (cdr-atom $seeds)))))

(= (exp07-dual-ablation-blocks? bootstrap-ablation-db0 $rule-id)
   (== $rule-id db0))
(= (exp07-dual-ablation-blocks? bootstrap-ablation-db1 $rule-id)
   (== $rule-id db1))
(= (exp07-dual-ablation-blocks? catalyst-ablation $rule-id)
   (or (== $rule-id dp1) (or (== $rule-id dp2)
     (or (== $rule-id dp3) (== $rule-id dp0)))))
(= (exp07-dual-ablation-blocks? rule-ablation-dp1 $rule-id)
   (== $rule-id dp1))
(= (exp07-dual-ablation-blocks? rule-ablation-dp2 $rule-id)
   (== $rule-id dp2))
(= (exp07-dual-ablation-blocks? rule-ablation-dp3 $rule-id)
   (== $rule-id dp3))
(= (exp07-dual-ablation-blocks? rule-ablation-dp0 $rule-id)
   (== $rule-id dp0))

(= (exp07-dual-ablation-total-tick $ablation $arm $chamber)
   (let $prepared (exp07-dual-prepare-chamber $chamber)
     (let $selected (exp07-dual-selected-with-draw
          $arm $prepared
          (exp07-dual-draw (state-seed (chamber-state $prepared))
                           (state-tick (chamber-state $prepared))))
       (if (exp07-dual-ablation-blocks?
             $ablation (rule-id (candidate-rule $selected)))
           (exp07-pilot-advance-blocked-tick $prepared)
           (if (exp07-dual-candidate-applicable? $selected $prepared)
               (exp07-dual-fire-candidate $selected $prepared)
               (exp07-pilot-advance-blocked-tick $prepared))))))
(= (exp07-dual-ablation-run-to-state-tick
      $ablation $arm $chamber $terminal-state-tick)
   (if (>= (state-tick (chamber-state $chamber)) $terminal-state-tick)
       $chamber
       (exp07-dual-ablation-run-to-state-tick $ablation $arm
         (exp07-dual-ablation-total-tick $ablation $arm $chamber)
         $terminal-state-tick)))
(= (exp07-dual-ablation-raf-incidence $ablation $arm $seed)
   (if (< (exp07-dual-first-rolling-raf-from
             (chamber-events
               (exp07-dual-ablation-run-to-state-tick $ablation $arm
                 (exp07-dual-initial-chamber $seed) 35)) ()) 99) 1 0))
(= (exp07-dual-sum-ablation-raf $ablation $arm $seeds)
   (if (== $seeds ()) 0
       (+ (exp07-dual-ablation-raf-incidence
            $ablation $arm (car-atom $seeds))
          (exp07-dual-sum-ablation-raf
            $ablation $arm (cdr-atom $seeds)))))

(= (exp07-dual-result-supported?)
   (let $seeds (exp07-dual-seeds)
     (let $weak (exp07-dual-sum raf weak-doob-h $seeds)
       (and (>= (- $weak (exp07-dual-sum raf unguided $seeds)) 10)
        (and (>= (- $weak
                    (exp07-dual-sum raf shuffled-frontier-guidance $seeds)) 10)
         (and (== (exp07-dual-sum replay unguided $seeds) 32)
          (and (== (exp07-dual-sum replay weak-doob-h $seeds) 32)
           (and (== (exp07-dual-sum replay
                     shuffled-frontier-guidance $seeds) 32)
            (and (<= (exp07-dual-sum raf unguided $seeds) 4)
             (and (<= (exp07-dual-sum-ablation-raf
                        bootstrap-ablation-db0 weak-doob-h $seeds) 4)
              (and (<= (exp07-dual-sum-ablation-raf
                         bootstrap-ablation-db1 weak-doob-h $seeds) 4)
               (and (<= (exp07-dual-sum-ablation-raf
                          catalyst-ablation weak-doob-h $seeds) 4)
                (and (<= (exp07-dual-sum-ablation-raf
                           rule-ablation-dp1 weak-doob-h $seeds) 4)
                 (and (<= (exp07-dual-sum-ablation-raf
                            rule-ablation-dp2 weak-doob-h $seeds) 4)
                  (and (<= (exp07-dual-sum-ablation-raf
                             rule-ablation-dp3 weak-doob-h $seeds) 4)
                       (<= (exp07-dual-sum-ablation-raf
                             rule-ablation-dp0 weak-doob-h $seeds) 4))))))))))))))))

(= (exp07-dual-matrix-report)
   (let $seeds (exp07-dual-seeds)
     (dual-bootstrap-matrix-report
       arms (unguided weak-doob-h shuffled-frontier-guidance)
       seeds $seeds ticks (3 34) candidate-cap 8
       raf-incidence
         ((unguided (exp07-dual-sum raf unguided $seeds))
          (weak-doob-h (exp07-dual-sum raf weak-doob-h $seeds))
          (shuffled-frontier-guidance
            (exp07-dual-sum raf shuffled-frontier-guidance $seeds)))
       first-hit-ticks
         ((unguided (exp07-dual-values first-hit unguided $seeds))
          (weak-doob-h (exp07-dual-values first-hit weak-doob-h $seeds))
          (shuffled-frontier-guidance
            (exp07-dual-values first-hit shuffled-frontier-guidance $seeds)))
       longest-consecutive-raf-ticks
         ((unguided (exp07-dual-values persistence unguided $seeds))
          (weak-doob-h (exp07-dual-values persistence weak-doob-h $seeds))
          (shuffled-frontier-guidance
            (exp07-dual-values persistence
              shuffled-frontier-guidance $seeds)))
       total-persistence
         ((unguided (exp07-dual-sum persistence unguided $seeds))
          (weak-doob-h (exp07-dual-sum persistence weak-doob-h $seeds))
          (shuffled-frontier-guidance
            (exp07-dual-sum persistence shuffled-frontier-guidance $seeds)))
       productive-event-totals
         ((unguided (exp07-dual-sum events unguided $seeds))
          (weak-doob-h (exp07-dual-sum events weak-doob-h $seeds))
          (shuffled-frontier-guidance
            (exp07-dual-sum events shuffled-frontier-guidance $seeds)))
       terminal-rule-diversity
         ((unguided (exp07-dual-values diversity unguided $seeds))
          (weak-doob-h (exp07-dual-values diversity weak-doob-h $seeds))
          (shuffled-frontier-guidance
            (exp07-dual-values diversity shuffled-frontier-guidance $seeds)))
       total-rule-diversity
         ((unguided (exp07-dual-sum diversity unguided $seeds))
          (weak-doob-h (exp07-dual-sum diversity weak-doob-h $seeds))
          (shuffled-frontier-guidance
            (exp07-dual-sum diversity shuffled-frontier-guidance $seeds)))
       exact-replays
         ((unguided (exp07-dual-sum replay unguided $seeds))
          (weak-doob-h (exp07-dual-sum replay weak-doob-h $seeds))
          (shuffled-frontier-guidance
            (exp07-dual-sum replay shuffled-frontier-guidance $seeds)))
       intervention-cost
         (denominator-per-draw 96 draws-per-trajectory 32
          trajectories-per-arm 32
          full-matrix ((unguided 0) (weak-doob-h 8192)
                       (shuffled-frontier-guidance 8192))
          matched-guidance-budget true)
       causal-ablations
         (guiding-term-removal
            (weak-policy-replaced-by unguided
             raf-incidence (exp07-dual-sum raf unguided $seeds))
          bootstrap-ablation
            ((db0 (exp07-dual-sum-ablation-raf
                    bootstrap-ablation-db0 weak-doob-h $seeds))
             (db1 (exp07-dual-sum-ablation-raf
                    bootstrap-ablation-db1 weak-doob-h $seeds)))
          catalyst-ablation
            (removed-edges ((CD dp1) (AC dp2) (BD dp3) (CE dp0))
             raf-incidence (exp07-dual-sum-ablation-raf
               catalyst-ablation weak-doob-h $seeds))
          rule-ablation
            ((dp1 (exp07-dual-sum-ablation-raf
                    rule-ablation-dp1 weak-doob-h $seeds))
             (dp2 (exp07-dual-sum-ablation-raf
                    rule-ablation-dp2 weak-doob-h $seeds))
             (dp3 (exp07-dual-sum-ablation-raf
                    rule-ablation-dp3 weak-doob-h $seeds))
             (dp0 (exp07-dual-sum-ablation-raf
                    rule-ablation-dp0 weak-doob-h $seeds))))
       rolling-detector last-twelve-dp1-dp2-dp3-dp0
       registered-result
         (if (exp07-dual-result-supported?) supported not-supported)
       adaptive-extension none
       spontaneous-emergence-claim none)))
