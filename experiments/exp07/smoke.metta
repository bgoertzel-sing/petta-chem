!(import! &self ../../src/chem_exp00.metta)
!(import! &self ../../src/chem_exp04.metta)
!(import! &self ../../src/chem_exp05.metta)
!(import! &self ../../src/chem_exp06.metta)
!(import! &self ../../src/chem_exp07.metta)

!(test (exp07-bridge-framing)
       (bridge-framing
         source ben-substack-lets-get-chemical
         formulation (schrodinger-bridge doob-h-transform)
         role diagnostic-search-strategy
         chemistry-kernel petta-native
         emergence-claim none))
!(test (exp07-initial-state)
       (bridge-state initial
                     sources (exp02-generated-unplanted-no-catalysis-controls
                              exp04-no-catalysis-controls)
                     acs-status verified-acs-negative
                     exp02-cycle-scan active-cycles-0-through-5-rule-scans
                     exp04-maximal-raf 0))
!(test (exp07-terminal-state)
       (bridge-state terminal
                     source exp04-acs-rich-fixture
                     acs-status acs-rich-terminal-fixture
                     maximal-raf 15
                     greedy-core-size 2
                     greedy-core (lCD lBCD2)))
!(test (exp07-intervention-cost-vector)
       ((intervention-variable catalyst-assignment source exp06 cost-row catalyst-assignment)
        (intervention-variable basal-food-replenishment source exp06 cost-row basal-food-replenishment)
        (intervention-variable candidate-pool-cap source exp06 cost-row candidate-pool-cap)
        (intervention-variable catalysis-map-offset source exp06 cost-row catalysis-map-offset)
        (intervention-variable affinity-weight source exp05 cost-row affinity-weight)))
!(test (exp07-bridge-cost-table)
       ((bridge-cost catalyst-assignment
                     from none
                     to specific-template
                     cost 1
                     source exp06-intervention-cost-row
                     status shortest-raf-positive-path)
        (bridge-cost basal-food-replenishment
                     from basal-0
                     to basal-4
                     cost 1
                     source exp06-intervention-cost-row
                     status raf-negative-alone)
        (bridge-cost candidate-pool-cap
                     from unbounded-for-raf-report
                     to cap-2
                     cost 1
                     source exp06-consolidation-summary
                     status not-acs-positive)
        (bridge-cost catalysis-map-offset
                     from none
                     to shuffled-offset
                     cost 1
                     source exp06-intervention-cost-row
                     status offset-sensitive)
        (bridge-cost affinity-weight
                     from neutral
                     to token-overlap-biased
                     cost 1
                     source exp05-affinity-scaffold
                     status diagnostic-weighting-variable)))
!(test (exp07-bridge-path baseline-catalyst-assignment)
       (bridge-path baseline-catalyst-assignment
                    ordered-interventions ((bridge-cost catalyst-assignment
                                                        from none
                                                        to specific-template
                                                        cost 1
                                                        source exp06-intervention-cost-row
                                                        status shortest-raf-positive-path))
                    start (bridge-state initial
                                        sources (exp02-generated-unplanted-no-catalysis-controls
                                                 exp04-no-catalysis-controls)
                                        acs-status verified-acs-negative
                                        exp02-cycle-scan active-cycles-0-through-5-rule-scans
                                        exp04-maximal-raf 0)
                    target (bridge-state terminal
                                         source exp04-acs-rich-fixture
                                         acs-status acs-rich-terminal-fixture
                                         maximal-raf 15
                                         greedy-core-size 2
                                         greedy-core (lCD lBCD2))
                    interpretation shortest-diagnostic-terminal-fixture-path
                    emergence-claim none))
!(test (exp07-bridge-target-acs-status)
       (bridge-target-acs-status
         target (bridge-state terminal
                              source exp04-acs-rich-fixture
                              acs-status acs-rich-terminal-fixture
                              maximal-raf 15
                              greedy-core-size 2
                              greedy-core (lCD lBCD2))
         check terminal-condition-acs
         maximal-raf 15
         greedy-core-size 2
         greedy-core (lCD lBCD2)
         status acs-positive-terminal-fixture
         emergence-claim none))
!(test (exp07-scaffold-status)
       (exp07-status schrodinger-bridge-doob-h-transform-diagnostic-scaffold
                     initial-state verified-acs-negative-controls
                     terminal-state exp04-acs-rich-fixture
                     intervention-variables 5
                     bridge-paths ordered-intervention-sequences
                     chemistry-kernel petta-native
                     emergence-claim none))

!(test (exp07-doob-h-table)
       ((doob-h-row catalyst-assignment
                    bridge-action assign-specific-template-catalysts
                    cost 1
                    h-value 5
                    terminal-proximity terminal-raf-positive
                    validation exp04-acs-scanner
                    guidance-status strongest-diagnostic-bias
                    emergence-claim none)
        (doob-h-row affinity-weight
                    bridge-action increase-token-overlap-affinity
                    cost 1
                    h-value 3
                    terminal-proximity weak-guidance-variable
                    validation exp05-chamber-tick-probe
                    guidance-status weak-bias-test-candidate
                    emergence-claim none)
        (doob-h-row candidate-pool-cap
                    bridge-action expose-bounded-candidate-diversity
                    cost 1
                    h-value 2
                    terminal-proximity not-acs-positive-in-exp06
                    validation exp06-stateful-cap-boundary
                    guidance-status control-or-secondary-variable
                    emergence-claim none)
        (doob-h-row basal-food-replenishment
                    bridge-action maintain-food-floor
                    cost 1
                    h-value 1
                    terminal-proximity raf-negative-alone
                    validation exp04-no-catalysis-control
                    guidance-status necessary-context-not-sufficient
                    emergence-claim none)
        (doob-h-row catalysis-map-offset
                    bridge-action rotate-catalysis-map
                    cost 1
                    h-value 1
                    terminal-proximity offset-sensitive-artifact-risk
                    validation exp04-offset-sensitivity-report
                    guidance-status control-not-primary-bias
                    emergence-claim none)))
!(test (exp07-doob-policy-order)
       (doob-policy-order
         initial (bridge-state initial
                               sources (exp02-generated-unplanted-no-catalysis-controls
                                        exp04-no-catalysis-controls)
                               acs-status verified-acs-negative
                               exp02-cycle-scan active-cycles-0-through-5-rule-scans
                               exp04-maximal-raf 0)
         terminal (bridge-state terminal
                                source exp04-acs-rich-fixture
                                acs-status acs-rich-terminal-fixture
                                maximal-raf 15
                                greedy-core-size 2
                                greedy-core (lCD lBCD2))
         ranked-actions (catalyst-assignment affinity-weight candidate-pool-cap basal-food-replenishment catalysis-map-offset)
         top-action catalyst-assignment
         weak-guidance-actions (affinity-weight candidate-pool-cap)
         control-actions (basal-food-replenishment catalysis-map-offset)
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-weak-guidance-test-plan)
       (weak-guidance-test-plan
         purpose test-bridge-derived-bias-without-fixing-terminal-state
         candidate-policy (doob-policy-order
                            initial (bridge-state initial
                                                  sources (exp02-generated-unplanted-no-catalysis-controls
                                                           exp04-no-catalysis-controls)
                                                  acs-status verified-acs-negative
                                                  exp02-cycle-scan active-cycles-0-through-5-rule-scans
                                                  exp04-maximal-raf 0)
                            terminal (bridge-state terminal
                                                   source exp04-acs-rich-fixture
                                                   acs-status acs-rich-terminal-fixture
                                                   maximal-raf 15
                                                   greedy-core-size 2
                                                   greedy-core (lCD lBCD2))
                            ranked-actions (catalyst-assignment affinity-weight candidate-pool-cap basal-food-replenishment catalysis-map-offset)
                            top-action catalyst-assignment
                            weak-guidance-actions (affinity-weight candidate-pool-cap)
                            control-actions (basal-food-replenishment catalysis-map-offset)
                            terminal-forcing prohibited
                            emergence-claim none)
         unguided-baseline exp02-generated-unplanted-controls
         weakly-guided-variables (affinity-weight candidate-pool-cap)
         validation-scanners old-acs-scanners
         success-observable increased-acs-frequency-or-persistence-versus-controls
         current-status planned-not-run
         emergence-claim none))

!(test (exp07-weak-guidance-evidence-row affinity-weight)
       (weak-guidance-evidence-row
         variable affinity-weight
         doob-h-value 3
         dynamic-source exp05-chamber-tick-affinity-2
         treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         control-selected (candidate 3 (rule e5r0 A B AB AC) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AB)))
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AC)))
         chamber-ticking wired-through-exp00-selector
         terminal-forcing prohibited
         acs-status not-yet-scanned
         emergence-claim none))
!(test (exp07-weak-guidance-evidence-row candidate-pool-cap)
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
!(test (exp07-weak-guidance-probe-status)
       (weak-guidance-probe-status
         policy (exp07-doob-policy-order)
         evidence (exp07-weak-guidance-evidence-table)
         tested-variables (affinity-weight candidate-pool-cap)
         chamber-ticking deterministic-exp00-selector
         terminal-forcing prohibited
         current-boundary dynamic-probes-linked-but-no-acs-positive-result
         next-test unguided-versus-weakly-guided-frequency-comparison
         emergence-claim none))

!(test (exp07-weak-guidance-comparison-row affinity-weight)
       (weak-guidance-comparison-row
         variable affinity-weight
         treatment (chamber exp05-treatment
                            (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                            ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                            ((event 3 e5r0 A B AB AB)))
         control (chamber exp05-rotated-control
                          (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                          ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                          ((event 3 e5r0 A B AB AC)))
         deterministic-selector exp00-selected-candidate-from-list-2
         observed-effect catalyst-context-changed-but-both-first-tick-productive
         acs-uplift not-evaluated
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-weak-guidance-comparison-row candidate-pool-cap)
       (weak-guidance-comparison-row
         variable candidate-pool-cap
         treatment (exp06-candidate-cap-stateful-three-tick-sweep)
         boundary (exp06-stateful-cap-sweep-acs-boundary-table)
         deterministic-selector exp00-selected-candidate-from-list-1-and-2
         observed-effect cap-1-cap-2-stateful-paths-diverge-then-block
         acs-uplift rejected-by-two-rule-product-catalyst-closure
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-weak-guidance-comparison-status)
       (weak-guidance-comparison-status
         compared-variables (affinity-weight candidate-pool-cap)
         evidence (exp07-weak-guidance-comparison-table)
         deterministic-selection directly-wired-to-chamber-ticking
         bounded-caps tested-via-exp06-stateful-cap-sweep
         current-boundary deterministic-differences-without-acs-uplift
         next-test vary-affinity-strength-and-seed-before-frequency-claim
         emergence-claim none))

!(test (exp07-affinity-strength-sweep-row 0)
       (affinity-strength-sweep-row
         strength 0
         treatment-selected (candidate 3 (rule e5r0 A B AB BC) 1)
         control-selected (candidate 3 (rule e5r0 A B AB BC) 1)
         cap 2
         deterministic-selector exp00-selected-candidate-from-list-2
         first-tick-status selected-catalysts-absent-in-current-fixture
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-strength-sweep-row 1)
       (affinity-strength-sweep-row
         strength 1
         treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         control-selected (candidate 3 (rule e5r0 A B AB AC) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AB)))
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AC)))
         cap 2
         deterministic-selector exp00-selected-candidate-from-list-2
         first-tick-status treatment-and-control-productive
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-strength-sweep-row 2)
       (affinity-strength-sweep-row
         strength 2
         treatment-selected (candidate 3 (rule e5r0 A B AB BC) 3)
         control-selected (candidate 3 (rule e5r0 A B AB CD) 1)
         cap 2
         deterministic-selector exp00-selected-candidate-from-list-2
         first-tick-status selected-catalysts-absent-in-current-fixture
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-strength-sweep-status)
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

!(test (exp07-affinity-selection-to-tick-trace strength-1)
       (affinity-selection-to-tick-trace
         variable affinity-weight
         strength 1
         seed seed-7
         tick 3
         cap 2
         treatment-pool (candidate-pool 3
                           ((candidate 3 (rule e5r0 A B AB AB) 3)
                            (candidate 3 (rule e5r1 A C AC AB) 2)))
         treatment-bounded-candidates ((candidate 3 (rule e5r0 A B AB AB) 3)
                                       (candidate 3 (rule e5r1 A C AC AB) 2))
         treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AB)))
         control-pool (candidate-pool 3
                         ((candidate 3 (rule e5r0 A B AB AC) 2)
                          (candidate 3 (rule e5r1 A C AC AB) 2)))
         control-bounded-candidates ((candidate 3 (rule e5r0 A B AB AC) 2)
                                     (candidate 3 (rule e5r1 A C AC AB) 2))
         control-selected (candidate 3 (rule e5r0 A B AB AC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AC)))
         deterministic-selector exp00-selected-candidate-from-list-2
         selection-handed-to chamber-tick-with-candidate
         scientific-boundary single-fixture-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-selection-to-tick-status)
       (affinity-selection-to-tick-status
         trace (affinity-selection-to-tick-trace
                 variable affinity-weight
                 strength 1
                 seed seed-7
                 tick 3
                 cap 2
                 treatment-pool (candidate-pool 3
                                   ((candidate 3 (rule e5r0 A B AB AB) 3)
                                    (candidate 3 (rule e5r1 A C AC AB) 2)))
                 treatment-bounded-candidates ((candidate 3 (rule e5r0 A B AB AB) 3)
                                               (candidate 3 (rule e5r1 A C AC AB) 2))
                 treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
                 treatment-after-tick (chamber exp05-treatment
                                               (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                               ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                               ((event 3 e5r0 A B AB AB)))
                 control-pool (candidate-pool 3
                                 ((candidate 3 (rule e5r0 A B AB AC) 2)
                                  (candidate 3 (rule e5r1 A C AC AB) 2)))
                 control-bounded-candidates ((candidate 3 (rule e5r0 A B AB AC) 2)
                                             (candidate 3 (rule e5r1 A C AC AB) 2))
                 control-selected (candidate 3 (rule e5r0 A B AB AC) 2)
                 control-after-tick (chamber exp05-rotated-control
                                              (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                              ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                              ((event 3 e5r0 A B AB AC)))
                 deterministic-selector exp00-selected-candidate-from-list-2
                 selection-handed-to chamber-tick-with-candidate
                 scientific-boundary single-fixture-provenance-not-frequency-or-acs-uplift
                 terminal-forcing prohibited
                 emergence-claim none)
         bounded-candidate-generation exp05-affinity-candidate-pool-2
         cap cap-2
         deterministic-selection directly-handed-to-exp00-chamber-ticking
         productive-strengths (1)
         current-boundary selection-to-tick-provenance-only
         next-test vary-seed-over-productive-strength-before-acs-frequency-claim
         terminal-forcing prohibited
         emergence-claim none))

!(test (exp07-affinity-seed-variation-row seed-7)
       (affinity-seed-variation-row
         seed seed-7
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate
         treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AB)))
         control-selected (candidate 3 (rule e5r0 A B AB AC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AC)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-8)
       (affinity-seed-variation-row
         seed seed-8
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate
         treatment-selected (candidate 3 (rule e5r1 A C AC AC) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-8 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC AC)))
         control-selected (candidate 3 (rule e5r1 A C AC AC) 3)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-8 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC AC)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-9)
       (affinity-seed-variation-row
         seed seed-9
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate-repeat
         treatment-selected (candidate 3 (rule e5r0 A B AB AC) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-9 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AC)))
         control-selected (candidate 3 (rule e5r0 A B AB BC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-9 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB BC)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))

!(test (exp07-affinity-seed-variation-row seed-10)
       (affinity-seed-variation-row
         seed seed-10
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate-repeat
         treatment-selected (candidate 3 (rule e5r1 A C AC AC) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-10 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC AC)))
         control-selected (candidate 3 (rule e5r1 A C AC BC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-10 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC BC)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))

!(test (exp07-affinity-seed-variation-row seed-11)
       (affinity-seed-variation-row
         seed seed-11
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate-late-draw
         treatment-selected (candidate 3 (rule e5r0 A B AB BC) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-11 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB BC)))
         control-selected (candidate 3 (rule e5r0 A B AB CD) 1)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-11 (mol A 0) (mol B 0) (mol AB 1) (mol CD 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB CD)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-12)
       (affinity-seed-variation-row
         seed seed-12
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate-late-draw
         treatment-selected (candidate 3 (rule e5r1 A C AC BC) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-12 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC BC)))
         control-selected (candidate 3 (rule e5r1 A C AC BC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-12 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC BC)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-13)
       (affinity-seed-variation-row
         seed seed-13
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate-draw-cycle-reset
         treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-13 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AB)))
         control-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-13 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AB)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-14)
       (affinity-seed-variation-row
         seed seed-14
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate-draw-cycle-reset
         treatment-selected (candidate 3 (rule e5r1 A C AC CD) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-14 (mol A 0) (mol C 0) (mol AC 1) (mol CD 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC CD)))
         control-selected (candidate 3 (rule e5r1 A C AC CD) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-14 (mol A 0) (mol C 0) (mol AC 1) (mol CD 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC CD)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-15)
       (affinity-seed-variation-row
         seed seed-15
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate-extended-draw
         treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-15 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AB)))
         control-selected (candidate 3 (rule e5r0 A B AB AC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-15 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AC)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-16)
       (affinity-seed-variation-row
         seed seed-16
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate-extended-draw
         treatment-selected (candidate 3 (rule e5r1 A C AC AB) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-16 (mol A 0) (mol C 0) (mol AC 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC AB)))
         control-selected (candidate 3 (rule e5r1 A C AC AB) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-16 (mol A 0) (mol C 0) (mol AC 1) (mol AB 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC AB)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-17)
       (affinity-seed-variation-row
         seed seed-17
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate-later-draw
         treatment-selected (candidate 3 (rule e5r0 A B AB AC) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-17 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AC)))
         control-selected (candidate 3 (rule e5r0 A B AB BC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-17 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB BC)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-18)
       (affinity-seed-variation-row
         seed seed-18
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate-later-draw
         treatment-selected (candidate 3 (rule e5r1 A C AC AC) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-18 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC AC)))
         control-selected (candidate 3 (rule e5r1 A C AC AC) 3)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-18 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC AC)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-19)
       (affinity-seed-variation-row
         seed seed-19
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate-latest-draw
         treatment-selected (candidate 3 (rule e5r0 A B AB BC) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-19 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB BC)))
         control-selected (candidate 3 (rule e5r0 A B AB CD) 1)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-19 (mol A 0) (mol B 0) (mol AB 1) (mol CD 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB CD)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-20)
       (affinity-seed-variation-row
         seed seed-20
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate-latest-draw
         treatment-selected (candidate 3 (rule e5r1 A C AC BC) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-20 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC BC)))
         control-selected (candidate 3 (rule e5r1 A C AC BC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-20 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC BC)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-21)
       (affinity-seed-variation-row
         seed seed-21
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate-cycle-repeat
         treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-21 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AB)))
         control-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-21 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AB)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-22)
       (affinity-seed-variation-row
         seed seed-22
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate-cycle-repeat
         treatment-selected (candidate 3 (rule e5r1 A C AC CD) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-22 (mol A 0) (mol C 0) (mol AC 1) (mol CD 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC CD)))
         control-selected (candidate 3 (rule e5r1 A C AC CD) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-22 (mol A 0) (mol C 0) (mol AC 1) (mol CD 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC CD)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))

!(test (exp07-affinity-seed-variation-row seed-23)
       (affinity-seed-variation-row
         seed seed-23
         tick 3
         strength 1
         cap 2
         selector-phase first-candidate-cycle-repeat-2
         treatment-selected (candidate 3 (rule e5r0 A B AB AB) 3)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-23 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r0 A B AB AB)))
         control-selected (candidate 3 (rule e5r0 A B AB AC) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-23 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AC)))
         selected-rule e5r0
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-24)
       (affinity-seed-variation-row
         seed seed-24
         tick 3
         strength 1
         cap 2
         selector-phase second-candidate-cycle-repeat-2
         treatment-selected (candidate 3 (rule e5r1 A C AC AB) 2)
         treatment-after-tick (chamber exp05-treatment
                                       (state 4 seed-24 (mol A 0) (mol C 0) (mol AC 1) (mol AB 1))
                                       ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                       ((event 3 e5r1 A C AC AB)))
         control-selected (candidate 3 (rule e5r1 A C AC AB) 2)
         control-after-tick (chamber exp05-rotated-control
                                      (state 4 seed-24 (mol A 0) (mol C 0) (mol AC 1) (mol AB 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r1 A C AC AB)))
         selected-rule e5r1
         productivity treatment-and-control-productive
         scientific-boundary eighteen-seed-provenance-not-frequency-or-acs-uplift
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-25) (affinity-seed-variation-row seed seed-25 tick 3 strength 1 cap 2 selector-phase first-candidate-cycle-repeat-3 treatment-selected (candidate 3 (rule e5r0 A B AB AC) 2) treatment-after-tick (chamber exp05-treatment (state 4 seed-25 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1)) ((rule e5r0 A B AB None) (rule e5r1 A C AC None)) ((event 3 e5r0 A B AB AC))) control-selected (candidate 3 (rule e5r0 A B AB BC) 2) control-after-tick (chamber exp05-rotated-control (state 4 seed-25 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1)) ((rule e5r0 A B AB None) (rule e5r1 A C AC None)) ((event 3 e5r0 A B AB BC))) selected-rule e5r0 productivity treatment-and-control-productive scientific-boundary twenty-seed-provenance-not-frequency-or-acs-uplift terminal-forcing prohibited emergence-claim none))
!(test (exp07-affinity-seed-variation-row seed-26) (affinity-seed-variation-row seed seed-26 tick 3 strength 1 cap 2 selector-phase second-candidate-cycle-repeat-3 treatment-selected (candidate 3 (rule e5r1 A C AC AC) 3) treatment-after-tick (chamber exp05-treatment (state 4 seed-26 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1)) ((rule e5r0 A B AB None) (rule e5r1 A C AC None)) ((event 3 e5r1 A C AC AC))) control-selected (candidate 3 (rule e5r1 A C AC AC) 3) control-after-tick (chamber exp05-rotated-control (state 4 seed-26 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1)) ((rule e5r0 A B AB None) (rule e5r1 A C AC None)) ((event 3 e5r1 A C AC AC))) selected-rule e5r1 productivity treatment-and-control-productive scientific-boundary twenty-seed-provenance-not-frequency-or-acs-uplift terminal-forcing prohibited emergence-claim none))
!(test (exp07-affinity-seed-variation-status)
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

; Replayable weighted categorical sampling covers all four draw bins across the
; fixed pilot seeds, and the selected ordinary candidate is handed directly to
; the existing PeTTa-native chamber tick.
!(test (exp07-pilot-draw seed-7 3) 2)
!(test (exp07-pilot-draw seed-8 3) 3)
!(test (exp07-pilot-draw seed-9 3) 0)
!(test (exp07-pilot-draw seed-10 3) 1)
!(test (exp07-pilot-select-2 unguided seed-7 3 first second) second)
!(test (exp07-pilot-select-2 weak-doob-h seed-7 3 first second) first)
!(test (exp07-pilot-select-2 shuffled-guidance seed-7 3 first second) second)
!(test (exp07-pilot-after-tick weak-doob-h seed-7)
       (exp05-chamber-tick-affinity-2 seed-7 3 1))
!(test (exp07-pilot-four-tick-first-count unguided seed-7) 2)
!(test (exp07-pilot-four-tick-first-count weak-doob-h seed-7) 3)
!(test (exp07-pilot-four-tick-first-count shuffled-guidance seed-7) 1)
!(test (exp07-pilot-ensemble-first-count unguided) 8)
!(test (exp07-pilot-ensemble-first-count weak-doob-h) 12)
!(test (exp07-pilot-ensemble-first-count shuffled-guidance) 4)
!(test (exp07-pilot-sampler-calibration)
       (sampler-calibration
         fixed-seeds (seed-7 seed-8 seed-9 seed-10)
         ticks (3 4 5 6)
         draws-per-arm 16
         first-candidate-counts ((unguided 8)
                                 (weak-doob-h 12)
                                 (shuffled-guidance 4))
         expected-counts ((unguided 8) (weak-doob-h 12)
                          (shuffled-guidance 4))
         replay exact-seed-tick
         current-boundary categorical-calibration-before-stateful-ensemble
         emergence-claim none))
!(test (exp07-pilot-productive? unguided seed-7) False)
!(test (exp07-pilot-productive? unguided seed-8) False)
!(test (exp07-pilot-productive? unguided seed-9) False)
!(test (exp07-pilot-productive? unguided seed-10) False)
!(test (exp07-pilot-productive? weak-doob-h seed-7) True)
!(test (exp07-pilot-productive? weak-doob-h seed-8) True)
!(test (exp07-pilot-productive? weak-doob-h seed-9) True)
!(test (exp07-pilot-productive? weak-doob-h seed-10) False)
!(test (exp07-pilot-productive? shuffled-guidance seed-7) False)
!(test (exp07-pilot-productive? shuffled-guidance seed-8) True)
!(test (exp07-pilot-productive? shuffled-guidance seed-9) True)
!(test (exp07-pilot-productive? shuffled-guidance seed-10) True)
!(test (exp07-pilot-productive-count unguided) 0)
!(test (exp07-pilot-productive-count weak-doob-h) 3)
!(test (exp07-pilot-productive-count shuffled-guidance) 3)
!(test (exp07-pilot-fixture-applicability-audit)
       (fixture-applicability-audit
         fixed-seeds (seed-7 seed-8 seed-9 seed-10)
         draws-per-arm 4
         productive-draws ((unguided 0)
                           (weak-doob-h 3)
                           (shuffled-guidance 3))
         matched-fixture-gate failed
         reason exp05-fixtures-cover-only-their-original-deterministic-selection
         current-boundary do-not-run-stateful-ensemble-on-confounded-fixtures
         required-next matched-multi-molecule-chamber-applicability
         emergence-claim none))
!(test (exp07-pilot-matched-productive? unguided seed-7) True)
!(test (exp07-pilot-matched-productive? unguided seed-8) True)
!(test (exp07-pilot-matched-productive? unguided seed-9) True)
!(test (exp07-pilot-matched-productive? unguided seed-10) True)
!(test (exp07-pilot-matched-productive? weak-doob-h seed-7) True)
!(test (exp07-pilot-matched-productive? weak-doob-h seed-8) True)
!(test (exp07-pilot-matched-productive? weak-doob-h seed-9) True)
!(test (exp07-pilot-matched-productive? weak-doob-h seed-10) True)
!(test (exp07-pilot-matched-productive? shuffled-guidance seed-7) True)
!(test (exp07-pilot-matched-productive? shuffled-guidance seed-8) True)
!(test (exp07-pilot-matched-productive? shuffled-guidance seed-9) True)
!(test (exp07-pilot-matched-productive? shuffled-guidance seed-10) True)
!(test (exp07-pilot-matched-productive-count unguided) 4)
!(test (exp07-pilot-matched-productive-count weak-doob-h) 4)
!(test (exp07-pilot-matched-productive-count shuffled-guidance) 4)
!(test (exp07-pilot-matched-pool-applicable-count unguided) 4)
!(test (exp07-pilot-matched-pool-applicable-count weak-doob-h) 4)
!(test (exp07-pilot-matched-pool-applicable-count shuffled-guidance) 4)
!(test (exp07-pilot-matched-applicability-audit)
       (fixture-applicability-audit
         fixed-seeds (seed-7 seed-8 seed-9 seed-10)
         draws-per-arm 4
         productive-draws ((unguided 4)
                           (weak-doob-h 4)
                           (shuffled-guidance 4))
         fully-applicable-two-candidate-pools
           ((unguided 4) (weak-doob-h 4) (shuffled-guidance 4))
         matched-fixture-gate passed
         initial-chemistry shared-seven-molecule-chamber
         chamber-ticking exp00-named-molecule-state
         current-boundary ready-for-stateful-ensemble
         emergence-claim none))
!(test (exp07-pilot-matched-after-tick weak-doob-h seed-7)
       (chamber exp07-matched
         (state 4 seed-7
           (molecules ((mol A 1) (mol B 0) (mol C 1)
                       (mol AB 2) (mol AC 1) (mol BC 1) (mol CD 1))))
         ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
         ((event 3 e5r0 A B AB AB))))
!(test (exp07-pilot-matched-after-two-ticks weak-doob-h seed-7)
       (chamber exp07-matched
         (state 5 seed-7
           (molecules ((mol A 0) (mol B 0) (mol C 0)
                       (mol AB 2) (mol AC 2) (mol BC 1) (mol CD 1))))
         ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
         ((event 3 e5r0 A B AB AB)
          (event 4 e5r1 A C AC AC))))
!(test (exp07-pilot-two-tick-trajectory weak-doob-h seed-7)
       (stateful-trajectory
         arm weak-doob-h
         seed seed-7
         ticks (3 4)
         initial
           (chamber exp07-matched
             (state 3 seed-7
               (molecules ((mol A 2) (mol B 1) (mol C 1)
                           (mol AB 1) (mol AC 1) (mol BC 1) (mol CD 1))))
             ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
             ())
         selected
           ((3 (candidate 3 (rule e5r0 A B AB AB) 3))
            (4 (candidate 4 (rule e5r1 A C AC AC) 3)))
         chambers
           ((3 (chamber exp07-matched
                 (state 4 seed-7
                   (molecules ((mol A 1) (mol B 0) (mol C 1)
                               (mol AB 2) (mol AC 1) (mol BC 1) (mol CD 1))))
                 ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                 ((event 3 e5r0 A B AB AB))))
            (4 (chamber exp07-matched
                 (state 5 seed-7
                   (molecules ((mol A 0) (mol B 0) (mol C 0)
                               (mol AB 2) (mol AC 2) (mol BC 1) (mol CD 1))))
                 ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                 ((event 3 e5r0 A B AB AB)
                  (event 4 e5r1 A C AC AC)))))
         replay exact-seed-tick-state-carry
         outcome-boundary trajectory-plumbing-only
         emergence-claim none))
!(test (exp07-pilot-two-tick-event-count unguided seed-7) 1)
!(test (exp07-pilot-two-tick-event-count unguided seed-8) 2)
!(test (exp07-pilot-two-tick-event-count unguided seed-9) 1)
!(test (exp07-pilot-two-tick-event-count unguided seed-10) 2)
!(test (exp07-pilot-two-tick-event-count weak-doob-h seed-7) 2)
!(test (exp07-pilot-two-tick-event-count weak-doob-h seed-8) 2)
!(test (exp07-pilot-two-tick-event-count weak-doob-h seed-9) 1)
!(test (exp07-pilot-two-tick-event-count weak-doob-h seed-10) 1)
!(test (exp07-pilot-two-tick-event-count shuffled-guidance seed-7) 1)
!(test (exp07-pilot-two-tick-event-count shuffled-guidance seed-8) 2)
!(test (exp07-pilot-two-tick-event-count shuffled-guidance seed-9) 2)
!(test (exp07-pilot-two-tick-event-count shuffled-guidance seed-10) 1)
!(test (exp07-pilot-two-tick-replay-ok? unguided seed-7) True)
!(test (exp07-pilot-two-tick-replay-ok? unguided seed-8) True)
!(test (exp07-pilot-two-tick-replay-ok? unguided seed-9) True)
!(test (exp07-pilot-two-tick-replay-ok? unguided seed-10) True)
!(test (exp07-pilot-two-tick-replay-ok? weak-doob-h seed-7) True)
!(test (exp07-pilot-two-tick-replay-ok? weak-doob-h seed-8) True)
!(test (exp07-pilot-two-tick-replay-ok? weak-doob-h seed-9) True)
!(test (exp07-pilot-two-tick-replay-ok? weak-doob-h seed-10) True)
!(test (exp07-pilot-two-tick-replay-ok? shuffled-guidance seed-7) True)
!(test (exp07-pilot-two-tick-replay-ok? shuffled-guidance seed-8) True)
!(test (exp07-pilot-two-tick-replay-ok? shuffled-guidance seed-9) True)
!(test (exp07-pilot-two-tick-replay-ok? shuffled-guidance seed-10) True)
!(test (exp07-pilot-two-tick-ensemble-summary)
       (stateful-ensemble-summary
         arms (unguided weak-doob-h shuffled-guidance)
         fixed-seeds (seed-7 seed-8 seed-9 seed-10)
         ticks (3 4)
         productive-events-by-seed
           ((unguided ((seed-7 1) (seed-8 2) (seed-9 1) (seed-10 2)))
            (weak-doob-h ((seed-7 2) (seed-8 2) (seed-9 1) (seed-10 1)))
            (shuffled-guidance ((seed-7 1) (seed-8 2) (seed-9 2) (seed-10 1))))
         productive-event-totals
           ((unguided 6) (weak-doob-h 6) (shuffled-guidance 6))
         exact-replays
           ((unguided 4) (weak-doob-h 4) (shuffled-guidance 4))
         observed-result equal-arm-event-totals-with-different-seed-patterns
         outcome-boundary two-tick-productivity-and-replay-only
         emergence-claim none))
!(test (exp07-stochastic-pilot-contract)
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
