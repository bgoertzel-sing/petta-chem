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
!(test (exp07-registered-pool-identity-at? seed-7 3) True)
!(test (exp07-registered-pool-identity-at? seed-10 22) True)
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
!(test (exp07-pilot-replenishment-tick? 8) True)
!(test (exp07-pilot-replenishment-tick? 13) True)
!(test (exp07-pilot-replenishment-tick? 18) True)
!(test (exp07-pilot-replenishment-tick? 7) False)
!(test (exp07-pilot-prepare-chamber
         (chamber exp07-matched
           (state 8 seed-7
             (molecules ((mol A 0) (mol B 0) (mol C 0)
                         (mol AB 2) (mol AC 2) (mol BC 1) (mol CD 1))))
           ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
           ((event 3 e5r0 A B AB AB))))
       (chamber exp07-matched
         (state 8 seed-7
           (molecules ((mol A 2) (mol B 1) (mol C 1)
                       (mol AB 2) (mol AC 2) (mol BC 1) (mol CD 1))))
         ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
         ((event 3 e5r0 A B AB AB))))
!(test (exp07-pilot-total-tick
         (chamber exp07-matched
           (state 7 seed-7
             (molecules ((mol A 0) (mol B 0) (mol C 0)
                         (mol AB 2) (mol AC 2) (mol BC 1) (mol CD 1))))
           ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
           ((event 3 e5r0 A B AB AB)))
         (candidate 7 (rule e5r0 A B AB AB) 3))
       (chamber exp07-matched
         (state 8 seed-7
           (molecules ((mol A 0) (mol B 0) (mol C 0)
                       (mol AB 2) (mol AC 2) (mol BC 1) (mol CD 1))))
         ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
         ((event 3 e5r0 A B AB AB))))
!(test (exp07-pilot-total-tick
         (chamber exp07-matched
           (state 8 seed-7
             (molecules ((mol A 0) (mol B 0) (mol C 0)
                         (mol AB 2) (mol AC 2) (mol BC 1) (mol CD 1))))
           ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
           ((event 3 e5r0 A B AB AB)))
         (candidate 8 (rule e5r0 A B AB AB) 3))
       (chamber exp07-matched
         (state 9 seed-7
           (molecules ((mol A 1) (mol B 0) (mol C 1)
                       (mol AB 3) (mol AC 2) (mol BC 1) (mol CD 1))))
         ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
         ((event 3 e5r0 A B AB AB)
          (event 8 e5r0 A B AB AB))))
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
!(test (exp07-detector-invariance-fixture)
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
!(test (exp07-pool-identity-check-status)
       (pool-identity-check
         requirement identical-composition-across-arms-modulo-weights
         check-scope all-arm-seed-tick-triples-in-horizon
         pre-run-required true
         post-run-required true
         fail-action emergence-claim-none-regardless-of-outcome
         construction one-shared-candidate-pool-before-arm-selection
         evidence exact-pool-equality-for-arbitrary-seed-and-tick
         status passed))

; Execute the complete preregistered horizon before interpreting any endpoint.
; Terminal tick 23 means ticks 3--22 were each consumed, including blocked
; draws; event counts are derived from the terminal PeTTa chamber.
!(test (exp07-registered-terminal-tick unguided seed-7) 23)
!(test (exp07-registered-terminal-tick weak-doob-h seed-8) 23)
!(test (exp07-registered-terminal-tick shuffled-guidance seed-10) 23)
!(test (exp07-registered-replay-ok? unguided seed-7) True)
!(test (exp07-registered-replay-ok? weak-doob-h seed-8) True)
!(test (exp07-registered-replay-ok? shuffled-guidance seed-10) True)
!(test (exp07-registered-n20-summary)
       (registered-n20-summary
         horizon (3 22)
         fixed-seeds (seed-7 seed-8 seed-9 seed-10)
         raf-incidence
           ((unguided 4) (weak-doob-h 4) (shuffled-guidance 4))
         first-hit-ticks
           ((unguided ((seed-7 5) (seed-8 3) (seed-9 8) (seed-10 10)))
            (weak-doob-h ((seed-7 3) (seed-8 3) (seed-9 8) (seed-10 8)))
            (shuffled-guidance
              ((seed-7 5) (seed-8 3) (seed-9 4) (seed-10 3))))
         productive-events
           ((unguided 32) (weak-doob-h 32) (shuffled-guidance 32))
         post-run-pool-identity passed
         causal-ablation guiding-term-removal-does-not-collapse-controls
         pivot all-arms-positive-pool-composition-not-guidance
         emergence-claim none))

; The richer-pool pivot is frozen before any outcome constructor exists.
!(test (exp07-rich-pool-preregistration)
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
!(test (exp07-rich-pool-implementation-gate)
       (implementation-gate
         required-before-outcomes
           (materialize-shared-pool materialize-first-class-catalysis
            connect-eight-bin-selection-directly-to-chamber-tick
            verify-bounded-cap-eight-generation verify-all-pre-run-gates)
         outcomes-evaluated false
         status passed
         emergence-claim none))

; ----- Rich-pool pre-run implementation: no registered outcomes -----

!(test (exp07-rich-catalysis-facts)
       ((catalyzes CD rp0) (catalyzes AB rp1) (catalyzes AC rp2)
        (catalyzes X rd0) (catalyzes X rd1) (catalyzes X rd2)
        (catalyzes X rd3) (catalyzes X rd4)))
!(test (exp07-rich-catalyzes? CD rp0) True)
!(test (exp07-rich-catalyzes? X rd4) True)
!(test (exp07-rich-initial-event-derived-raf? seed-11) False)
!(test (exp07-rich-event-derived-raf?
         ((event 3 rp0 A B AB CD)
          (event 4 rp1 A C AC AB)
          (event 5 rp2 C D CD AC)))
       True)
!(test (exp07-rich-event-derived-raf?
         ((event 3 rp0 A B AB CD)
          (event 4 rp1 A C AC AB)))
       False)
!(test (exp07-rich-catalysis-fact-count) 8)

!(test (exp07-rich-draw seed-11 3) 16)
!(test (exp07-rich-bin unguided 10) 0)
!(test (exp07-rich-bin unguided 11) 1)
!(test (exp07-rich-bin weak-doob-h 47) 2)
!(test (exp07-rich-bin weak-doob-h 48) 3)
!(test (exp07-rich-bin shuffled-guidance 23) 2)
!(test (exp07-rich-bin shuffled-guidance 24) 3)
!(test (exp07-rich-bin-counts unguided) (11 11 11 11 11 11 11 11))
!(test (exp07-rich-bin-counts weak-doob-h) (16 16 16 8 8 8 8 8))
!(test (exp07-rich-bin-counts shuffled-guidance) (8 8 8 16 16 16 8 8))
!(test (exp07-rich-sampler-calibration)
       (sampler-calibration
         synthetic-draw-bins 0-through-87
         draws-per-arm 88
         candidate-order (rp0 rp1 rp2 rd0 rd1 rd2 rd3 rd4)
         realized-masses
           ((unguided (11 11 11 11 11 11 11 11))
            (weak-doob-h (16 16 16 8 8 8 8 8))
            (shuffled-guidance (8 8 8 16 16 16 8 8)))
         expected-masses
           ((unguided (11 11 11 11 11 11 11 11))
            (weak-doob-h (16 16 16 8 8 8 8 8))
            (shuffled-guidance (8 8 8 16 16 16 8 8)))
         replay deterministic-complete-cycle
         outcomes-evaluated false
         emergence-claim none))

!(test (exp07-rich-generated-pool seed-12)
       (candidate-pool 3
         ((candidate 3 (rule rp0 A B AB CD) 1)
          (candidate 3 (rule rp1 A C AC AB) 1)
          (candidate 3 (rule rp2 C D CD AC) 1)
          (candidate 3 (rule rd0 A B W0 X) 1)
          (candidate 3 (rule rd1 A C W1 X) 1)
          (candidate 3 (rule rd2 B C W2 X) 1)
          (candidate 3 (rule rd3 C D W3 X) 1)
          (candidate 3 (rule rd4 A D W4 X) 1))))
!(test (exp07-rich-bounded-pool seed-12)
       (candidate-pool 3
         ((candidate 3 (rule rp0 A B AB CD) 1)
          (candidate 3 (rule rp1 A C AC AB) 1)
          (candidate 3 (rule rp2 C D CD AC) 1)
          (candidate 3 (rule rd0 A B W0 X) 1)
          (candidate 3 (rule rd1 A C W1 X) 1)
          (candidate 3 (rule rd2 B C W2 X) 1)
          (candidate 3 (rule rd3 C D W3 X) 1)
          (candidate 3 (rule rd4 A D W4 X) 1))))
!(test (exp07-rich-pool-identity? seed-12) True)
!(test (exp07-rich-selected-candidate unguided seed-12)
       (candidate 3 (rule rd0 A B W0 X) 1))
!(test (exp07-rich-selected-candidate weak-doob-h seed-12)
       (candidate 3 (rule rp2 C D CD AC) 1))
!(test (exp07-rich-selected-candidate shuffled-guidance seed-12)
       (candidate 3 (rule rd0 A B W0 X) 1))
!(test (exp07-rich-after-one-tick unguided seed-12)
       (chamber exp07-rich
         (state 4 seed-12
           (molecules
             ((mol A 3) (mol B 2) (mol C 4) (mol D 3)
              (mol AB 0) (mol AC 0) (mol CD 1) (mol X 1)
              (mol W0 1) (mol W1 0) (mol W2 0) (mol W3 0) (mol W4 0))))
         ((rule rp0 A B AB CD) (rule rp1 A C AC AB)
          (rule rp2 C D CD AC) (rule rd0 A B W0 X)
          (rule rd1 A C W1 X) (rule rd2 B C W2 X)
          (rule rd3 C D W3 X) (rule rd4 A D W4 X))
         ((event 3 rd0 A B W0 X))))
!(test (exp07-rich-pre-run-gate-result seed-12)
       (rich-pre-run-gate
         positive-control-maximal-raf 15
         positive-control-core-is-raf true
         empty-catalysis-maximal-raf 0
         initial-event-derived-raf False
         shared-pool-identical True
         catalysis-facts
           ((catalyzes CD rp0) (catalyzes AB rp1) (catalyzes AC rp2)
            (catalyzes X rd0) (catalyzes X rd1) (catalyzes X rd2)
            (catalyzes X rd3) (catalyzes X rd4))
         catalysis-fact-count 8
         sampler-masses
           ((unguided (11 11 11 11 11 11 11 11))
            (weak-doob-h (16 16 16 8 8 8 8 8))
            (shuffled-guidance (8 8 8 16 16 16 8 8)))
         direct-tick-path exp07-rich-selection-fire-record
         status passed
         outcomes-evaluated false
         emergence-claim none))

; Execute the frozen rich-pool matrix exactly once: ticks 3--26 for all three
; arms and seeds 11--18.  Controls remain RAF-positive, so the preregistered
; emergence-claim lift condition is not met even though weak guidance has the
; largest raw incidence.
!(test (exp07-rich-terminal-tick unguided seed-11) 27)
!(test (exp07-rich-terminal-tick weak-doob-h seed-18) 27)
!(test (exp07-rich-terminal-tick shuffled-guidance seed-14) 27)
!(test (exp07-rich-replay-ok? unguided seed-11) True)
!(test (exp07-rich-replay-ok? weak-doob-h seed-18) True)
!(test (exp07-rich-replay-ok? shuffled-guidance seed-14) True)
!(test (exp07-rich-rule-diversity unguided seed-11) 6)
!(test (exp07-rich-diversity-collapse shuffled-guidance seed-13) 3)
!(test (exp07-rich-intervention-cost-per-draw unguided) 0)
!(test (exp07-rich-intervention-cost-per-draw weak-doob-h) 15)
!(test (exp07-rich-intervention-cost-per-draw shuffled-guidance) 15)
!(test (exp07-rich-ablation-arm-raf-incidence
         catalyst-ablation weak-doob-h)
       0)
!(test (exp07-rich-ablation-arm-raf-incidence
         rule-ablation-rp0 unguided)
       0)
!(test (exp07-rich-ablation-arm-raf-incidence
         rule-ablation-rp1 weak-doob-h)
       0)
!(test (exp07-rich-ablation-arm-raf-incidence
         rule-ablation-rp2 shuffled-guidance)
       0)
!(test (exp07-rich-causal-ablation-report)
       (rich-causal-ablation
         fixed-horizon (3 26)
         fixed-seeds (seed-11 seed-12 seed-13 seed-14
                      seed-15 seed-16 seed-17 seed-18)
         guiding-term-removal
           (unguided-raf-incidence 5 outcome does-not-collapse)
         catalyst-ablation
           (removed-edges ((CD rp0) (AB rp1) (AC rp2))
            raf-incidence
              ((unguided 0) (weak-doob-h 0) (shuffled-guidance 0))
            productive-events
              ((unguided 116) (weak-doob-h 83) (shuffled-guidance 117))
            outcome collapses)
         rule-ablation
           ((rp0 ((unguided 0) (weak-doob-h 0) (shuffled-guidance 0)))
            (rp1 ((unguided 0) (weak-doob-h 0) (shuffled-guidance 0)))
            (rp2 ((unguided 0) (weak-doob-h 0) (shuffled-guidance 0))))
         matched-pool-selector-schedule true
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-rich-intervention-cost-report)
       (rich-intervention-cost
         reference-policy unguided
         metric total-variation-shifted-mass-numerator
         denominator-per-draw 88
         registered-draws-per-trajectory 24
         fixed-trajectories-per-arm 8
         per-draw
           ((unguided 0) (weak-doob-h 15) (shuffled-guidance 15))
         per-trajectory
           ((unguided 0) (weak-doob-h 360) (shuffled-guidance 360))
         full-matrix
           ((unguided 0) (weak-doob-h 2880) (shuffled-guidance 2880))
         matched-guidance-budget true
         chemistry-outcomes-used false))
!(test (exp07-rich-registered-summary)
       (rich-registered-summary
         horizon (3 26)
         fixed-seeds (seed-11 seed-12 seed-13 seed-14
                      seed-15 seed-16 seed-17 seed-18)
         raf-incidence
           ((unguided 5) (weak-doob-h 7) (shuffled-guidance 3))
         first-hit-ticks
           ((unguided
              ((seed-11 99) (seed-12 14) (seed-13 22) (seed-14 13)
               (seed-15 23) (seed-16 99) (seed-17 22) (seed-18 99)))
            (weak-doob-h
              ((seed-11 15) (seed-12 20) (seed-13 99) (seed-14 19)
               (seed-15 16) (seed-16 15) (seed-17 23) (seed-18 14)))
            (shuffled-guidance
              ((seed-11 99) (seed-12 11) (seed-13 99) (seed-14 99)
               (seed-15 99) (seed-16 99) (seed-17 14) (seed-18 22))))
         productive-events
           ((unguided 130) (weak-doob-h 120) (shuffled-guidance 123))
         longest-consecutive-raf-ticks
           ((unguided
              ((seed-11 0) (seed-12 3) (seed-13 1) (seed-14 1)
               (seed-15 3) (seed-16 0) (seed-17 5) (seed-18 0)))
            (weak-doob-h
              ((seed-11 7) (seed-12 7) (seed-13 0) (seed-14 6)
               (seed-15 11) (seed-16 7) (seed-17 4) (seed-18 7)))
            (shuffled-guidance
              ((seed-11 0) (seed-12 6) (seed-13 0) (seed-14 0)
               (seed-15 0) (seed-16 0) (seed-17 3) (seed-18 2))))
         total-persistence
           ((unguided 13) (weak-doob-h 49) (shuffled-guidance 11))
         terminal-rule-diversity
           ((unguided
              ((seed-11 6) (seed-12 8) (seed-13 8) (seed-14 8)
               (seed-15 8) (seed-16 7) (seed-17 8) (seed-18 8)))
            (weak-doob-h
              ((seed-11 8) (seed-12 7) (seed-13 6) (seed-14 8)
               (seed-15 8) (seed-16 8) (seed-17 8) (seed-18 8)))
            (shuffled-guidance
              ((seed-11 7) (seed-12 7) (seed-13 5) (seed-14 5)
               (seed-15 7) (seed-16 7) (seed-17 8) (seed-18 8))))
         total-rule-diversity
           ((unguided 61) (weak-doob-h 61) (shuffled-guidance 54))
         total-diversity-collapse-from-full-pool
           ((unguided 3) (weak-doob-h 3) (shuffled-guidance 10))
         intervention-cost
           (rich-intervention-cost
             reference-policy unguided
             metric total-variation-shifted-mass-numerator
             denominator-per-draw 88
             registered-draws-per-trajectory 24
             fixed-trajectories-per-arm 8
             per-draw
               ((unguided 0) (weak-doob-h 15) (shuffled-guidance 15))
             per-trajectory
               ((unguided 0) (weak-doob-h 360) (shuffled-guidance 360))
             full-matrix
               ((unguided 0) (weak-doob-h 2880) (shuffled-guidance 2880))
             matched-guidance-budget true
             chemistry-outcomes-used false)
         causal-ablations
           (rich-causal-ablation
             fixed-horizon (3 26)
             fixed-seeds (seed-11 seed-12 seed-13 seed-14
                          seed-15 seed-16 seed-17 seed-18)
             guiding-term-removal
               (unguided-raf-incidence 5 outcome does-not-collapse)
             catalyst-ablation
               (removed-edges ((CD rp0) (AB rp1) (AC rp2))
                raf-incidence
                  ((unguided 0) (weak-doob-h 0) (shuffled-guidance 0))
                productive-events
                  ((unguided 116) (weak-doob-h 83) (shuffled-guidance 117))
                outcome collapses)
             rule-ablation
               ((rp0 ((unguided 0) (weak-doob-h 0)
                      (shuffled-guidance 0)))
                (rp1 ((unguided 0) (weak-doob-h 0)
                      (shuffled-guidance 0)))
                (rp2 ((unguided 0) (weak-doob-h 0)
                      (shuffled-guidance 0))))
             matched-pool-selector-schedule true
             terminal-forcing prohibited
             emergence-claim none)
         replay deterministic-seed-tick-state-carry
         terminal-forcing prohibited
         emergence-claim none))
!(test (exp07-rich-interpretation)
       (rich-pool-interpretation
         frozen-matrix complete
         raf-incidence ((unguided 5) (weak-doob-h 7)
                        (shuffled-guidance 3))
         cycle-necessary-under-ablation true
         guidance-necessary false
         evidence pool-composition
         horizon-extension prohibited
         emergence-claim none))
!(test (exp07-ordered-bootstrap-preregistration)
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

!(test (exp07-ordered-replication-preregistration)
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

!(test (exp07-ordered-replication-program-closure)
       (ordered-replication-program-closure
         cohort-a-primary-replication not-supported
         cohort-b-order-hash-robustness not-supported
         cohort-b-cannot-rescue-cohort-a true
         adaptive-extension none
         successor-outcomes-evaluated false
         spontaneous-emergence-claim none))

!(test (exp07-dual-bootstrap-preregistration)
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

; Ordered-bootstrap materialization gate only.  No selection, chamber tick, or
; held-out trajectory is evaluated by these assertions.
!(test (exp07-ordered-rules)
       ((rule ob0 A B AB X)
        (rule op1 A C AC AB)
        (rule op2 C D CD AC)
        (rule op0 A B AB CD)
        (rule od0 A C W0 X)
        (rule od1 B C W1 X)
        (rule od2 C D W2 X)
        (rule od3 A D W3 X)))
!(test (exp07-ordered-shared-pool
         (exp07-ordered-initial-chamber seed-19))
       (candidate-pool 3
         ((candidate 3 (rule ob0 A B AB X) 1)
          (candidate 3 (rule op1 A C AC AB) 1)
          (candidate 3 (rule op2 C D CD AC) 1)
          (candidate 3 (rule op0 A B AB CD) 1)
          (candidate 3 (rule od0 A C W0 X) 1)
          (candidate 3 (rule od1 B C W1 X) 1)
          (candidate 3 (rule od2 C D W2 X) 1)
          (candidate 3 (rule od3 A D W3 X) 1))))
!(test (exp07-ordered-bounded-pool
         (exp07-ordered-initial-chamber seed-19))
       (exp07-ordered-shared-pool
         (exp07-ordered-initial-chamber seed-19)))
!(test (exp07-ordered-pool-identity?
         (exp07-ordered-initial-chamber seed-19))
       True)
!(test (exp07-ordered-catalysis-facts)
       ((catalysis-edge X ob0) (catalysis-edge AB op1)
        (catalysis-edge AC op2) (catalysis-edge CD op0)
        (catalysis-edge X od0) (catalysis-edge X od1)
        (catalysis-edge X od2) (catalysis-edge X od3)))
!(test (exp07-ordered-catalysis-fact-count) 8)
!(test (exp07-ordered-catalyzes? AB op1) True)
!(test (exp07-ordered-catalyzes? X op1) False)
!(test (exp07-ordered-catalyzes? CD ob0) False)
!(test (exp07-ordered-materialization-gate seed-19)
       (ordered-materialization-gate
         pool-order (ob0 op1 op2 op0 od0 od1 od2 od3)
         shared-pool-identical True
         bounded-cap 8
         catalysis-facts
           ((catalysis-edge X ob0) (catalysis-edge AB op1)
            (catalysis-edge AC op2) (catalysis-edge CD op0)
            (catalysis-edge X od0) (catalysis-edge X od1)
            (catalysis-edge X od2) (catalysis-edge X od3))
         catalysis-fact-count 8
         selector-implemented false
         chamber-tick-evaluated false
         trajectory-evaluated false
         status partial-pre-run-gate
         emergence-claim none))
!(test (exp07-ordered-initial-applicability-gate seed-19)
       (initial-applicability-gate phase ab-zero ob0 True op1 False
         op2 False op0 False initial-event-raf false))
!(test (exp07-ordered-phase (exp07-ordered-phase-fixture 0 0 0)) ab-zero)
!(test (exp07-ordered-phase (exp07-ordered-phase-fixture 1 0 0)) ac-zero)
!(test (exp07-ordered-phase (exp07-ordered-phase-fixture 1 1 0)) cd-zero)
!(test (exp07-ordered-phase (exp07-ordered-phase-fixture 1 1 1)) cycle-ready)
!(test (exp07-ordered-event-derived-raf? ()) False)
!(test (exp07-ordered-event-derived-raf?
         ((event 3 op1 A C AC AB) (event 4 op2 C D CD AC))) False)
!(test (exp07-ordered-event-derived-raf?
         ((event 3 op1 A C AC AB) (event 4 op2 C D CD AC)
          (event 5 op0 A B AB CD))) True)
!(test (exp07-ordered-bin-counts unguided ab-zero)
       (12 12 12 12 12 12 12 12))
!(test (exp07-ordered-bin-counts weak-doob-h ab-zero)
       (20 12 12 12 4 12 12 12))
!(test (exp07-ordered-bin-counts weak-doob-h ac-zero)
       (12 20 12 12 12 4 12 12))
!(test (exp07-ordered-bin-counts weak-doob-h cd-zero)
       (12 12 20 12 12 12 4 12))
!(test (exp07-ordered-bin-counts weak-doob-h cycle-ready)
       (12 12 12 20 12 12 12 4))
!(test (exp07-ordered-bin-counts shuffled-frontier-guidance ab-zero)
       (4 12 12 12 20 12 12 12))
!(test (exp07-ordered-bin-counts shuffled-frontier-guidance ac-zero)
       (12 4 12 12 12 20 12 12))
!(test (exp07-ordered-bin-counts shuffled-frontier-guidance cd-zero)
       (12 12 4 12 12 12 20 12))
!(test (exp07-ordered-bin-counts shuffled-frontier-guidance cycle-ready)
       (12 12 12 4 12 12 12 20))
!(test (exp07-ordered-selected-with-draw weak-doob-h
         (exp07-ordered-initial-chamber seed-19) 0)
       (candidate 3 (rule ob0 A B AB X) 1))
!(test (exp07-ordered-direct-tick-with-draw weak-doob-h
         (exp07-ordered-initial-chamber seed-19) 0)
       (chamber exp07-ordered-bootstrap
         (state 4 seed-19
           (molecules
             ((mol A 3) (mol B 2) (mol C 4) (mol D 3)
              (mol AB 1) (mol AC 0) (mol CD 0) (mol X 1)
              (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0))))
         ((rule ob0 A B AB X) (rule op1 A C AC AB)
          (rule op2 C D CD AC) (rule op0 A B AB CD)
          (rule od0 A C W0 X) (rule od1 B C W1 X)
          (rule od2 C D W2 X) (rule od3 A D W3 X))
         ((event 3 ob0 A B AB X))))
!(test (exp07-ordered-fire-candidate
         (candidate 3 (rule ob0 A B AB X) 1)
         (exp07-ordered-initial-chamber seed-19))
       (chamber exp07-ordered-bootstrap
         (state 4 seed-19
           (molecules
             ((mol A 3) (mol B 2) (mol C 4) (mol D 3)
              (mol AB 1) (mol AC 0) (mol CD 0) (mol X 1)
              (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0))))
         ((rule ob0 A B AB X) (rule op1 A C AC AB)
          (rule op2 C D CD AC) (rule op0 A B AB CD)
          (rule od0 A C W0 X) (rule od1 B C W1 X)
          (rule od2 C D W2 X) (rule od3 A D W3 X))
         ((event 3 ob0 A B AB X))))
!(test (exp07-ordered-selector-pre-run-gate)
       (ordered-selector-pre-run-gate
         phases
           ((ab-zero (20 12 12 12 4 12 12 12)
                     (4 12 12 12 20 12 12 12))
            (ac-zero (12 20 12 12 12 4 12 12)
                     (12 4 12 12 12 20 12 12))
            (cd-zero (12 12 20 12 12 12 4 12)
                     (12 12 4 12 12 12 20 12))
            (cycle-ready (12 12 12 20 12 12 12 4)
                         (12 12 12 4 12 12 12 20)))
         unguided (12 12 12 12 12 12 12 12)
         shifted-mass-units-per-guided-draw 8
         matched-cost true chemistry-outcomes-used false
         trajectory-evaluated false emergence-claim none))

; Independent-replication implementation gates.  All chamber checks use the
; synthetic seed-7 fixture; no seed-101--132 trajectory is constructed.
!(test (seed-number seed-101) 101)
!(test (seed-number seed-132) 132)
!(test (exp07-ordered-replication-draw cohort-a seed-101 0) 56)
!(test (exp07-ordered-replication-draw cohort-a seed-116 95) 64)
!(test (exp07-ordered-replication-draw cohort-b seed-117 0) 38)
!(test (exp07-ordered-replication-draw cohort-b seed-132 95) 18)
!(test (exp07-ordered-replication-draw-calibrated? cohort-a seed-101) True)
!(test (exp07-ordered-replication-draw-calibrated? cohort-b seed-117) True)
!(test (exp07-ordered-replication-pool-identity?
         cohort-a (exp07-ordered-replication-fixture cohort-a 0 0 0))
       True)
!(test (exp07-ordered-replication-pool-identity?
         cohort-b (exp07-ordered-replication-fixture cohort-b 0 0 0))
       True)
!(test (exp07-ordered-replication-pool weak-doob-h cohort-b
         (exp07-ordered-replication-fixture cohort-b 0 0 0))
       (candidate-pool 3
         ((candidate 3 (rule od2 C D W2 X) 1)
          (candidate 3 (rule op0 A B AB CD) 1)
          (candidate 3 (rule ob0 A B AB X) 1)
          (candidate 3 (rule od1 B C W1 X) 1)
          (candidate 3 (rule op2 C D CD AC) 1)
          (candidate 3 (rule od3 A D W3 X) 1)
          (candidate 3 (rule op1 A C AC AB) 1)
          (candidate 3 (rule od0 A C W0 X) 1))))
!(test (rule-id (candidate-rule
         (exp07-ordered-replication-selected-with-draw weak-doob-h cohort-b
           (exp07-ordered-replication-fixture cohort-b 0 0 0) 0))) ob0)
!(test (rule-id (candidate-rule
         (exp07-ordered-replication-selected-with-draw weak-doob-h cohort-b
           (exp07-ordered-replication-fixture cohort-b 1 0 0) 12))) op1)
!(test (rule-id (candidate-rule
         (exp07-ordered-replication-selected-with-draw weak-doob-h cohort-b
           (exp07-ordered-replication-fixture cohort-b 1 1 0) 24))) op2)
!(test (rule-id (candidate-rule
         (exp07-ordered-replication-selected-with-draw weak-doob-h cohort-b
           (exp07-ordered-replication-fixture cohort-b 1 1 1) 36))) op0)
!(test (rule-id (candidate-rule
         (exp07-ordered-replication-selected-with-draw
           shuffled-frontier-guidance cohort-b
           (exp07-ordered-replication-fixture cohort-b 0 0 0) 40))) od0)
!(test (rule-id (candidate-rule
         (exp07-ordered-replication-selected-with-draw
           shuffled-frontier-guidance cohort-b
           (exp07-ordered-replication-fixture cohort-b 1 0 0) 52))) od1)
!(test (rule-id (candidate-rule
         (exp07-ordered-replication-selected-with-draw
           shuffled-frontier-guidance cohort-b
           (exp07-ordered-replication-fixture cohort-b 1 1 0) 64))) od2)
!(test (rule-id (candidate-rule
         (exp07-ordered-replication-selected-with-draw
           shuffled-frontier-guidance cohort-b
           (exp07-ordered-replication-fixture cohort-b 1 1 1) 76))) od3)
!(test (exp07-ordered-replication-direct-tick-with-draw weak-doob-h cohort-b
         (exp07-ordered-replication-fixture cohort-b 0 0 0) 0)
       (chamber exp07-ordered-replication-synthetic
         (state 4 seed-7
           (molecules
             ((mol A 3) (mol B 2) (mol C 4) (mol D 3)
              (mol AB 1) (mol AC 0) (mol CD 0) (mol X 1)
              (mol W0 0) (mol W1 0) (mol W2 0) (mol W3 0))))
         ((rule od2 C D W2 X) (rule op0 A B AB CD)
          (rule ob0 A B AB X) (rule od1 B C W1 X)
          (rule op2 C D CD AC) (rule od3 A D W3 X)
          (rule op1 A C AC AB) (rule od0 A C W0 X))
         ((event 3 ob0 A B AB X))))
!(test (exp07-ordered-replication-pre-run-gate)
       (ordered-replication-pre-run-gate
         seed-support-boundaries ((seed-101 101) (seed-132 132))
         complete-96-bin-calibration ((cohort-a True) (cohort-b True))
         identical-arm-pools ((cohort-a True) (cohort-b True))
         cohort-b-selection-addressing rule-identity
         selector-mass-calibration
           ((unguided (12 12 12 12 12 12 12 12))
            (weak-doob-h (20 12 12 12 4 12 12 12))
            (shuffled-frontier-guidance (4 12 12 12 20 12 12 12)))
         matched-guidance-cost-units
           ((weak-doob-h 8) (shuffled-frontier-guidance 8))
         synthetic-direct-tick required
         registered-trajectory-evaluated false
         chemistry-outcomes-used false
         emergence-claim none))

; Frozen cohort-A replication matrix.  The exact fresh seed/hash cohort is
; complete before any cohort-B trajectory is constructed.  All arms remain
; RAF-null, so the preregistered primary replication is not supported.
!(test (exp07-ordered-replication-cohort-a-primary-supported?) False)
!(test (exp07-ordered-replication-cohort-a-report)
       (ordered-replication-cohort-a-report
         arms (unguided weak-doob-h shuffled-frontier-guidance)
         seeds (seed-101 seed-102 seed-103 seed-104
                seed-105 seed-106 seed-107 seed-108
                seed-109 seed-110 seed-111 seed-112
                seed-113 seed-114 seed-115 seed-116)
         ticks (3 26) candidate-cap 8
         raf-incidence
           ((unguided 1) (weak-doob-h 4)
            (shuffled-frontier-guidance 0))
         first-hit-ticks
           ((unguided
              (99 99 99 99 26 99 99 99 99 99 99 99 99 99 99 99))
            (weak-doob-h
              (99 99 99 99 24 99 99 22 99 99 99 99 23 99 24 99))
            (shuffled-frontier-guidance
              (99 99 99 99 99 99 99 99 99 99 99 99 99 99 99 99)))
         longest-consecutive-raf-ticks
           ((unguided (0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0))
            (weak-doob-h (0 0 0 0 3 0 0 5 0 0 0 0 4 0 3 0))
            (shuffled-frontier-guidance
              (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
         total-persistence
           ((unguided 1) (weak-doob-h 15)
            (shuffled-frontier-guidance 0))
         productive-event-totals
           ((unguided 259) (weak-doob-h 263)
            (shuffled-frontier-guidance 250))
         terminal-rule-diversity
           ((unguided (7 7 6 7 8 7 7 7 7 7 7 7 7 7 7 7))
            (weak-doob-h (7 7 7 7 8 7 6 8 7 7 7 8 8 7 8 7))
            (shuffled-frontier-guidance
              (4 6 6 6 5 6 6 5 5 6 5 4 6 6 5 4)))
         total-rule-diversity
           ((unguided 112) (weak-doob-h 116)
            (shuffled-frontier-guidance 85))
         exact-replays
           ((unguided 16) (weak-doob-h 16)
            (shuffled-frontier-guidance 16))
         intervention-cost
           (denominator-per-draw 96 draws-per-trajectory 24
            trajectories-per-arm 16
            full-matrix ((unguided 0) (weak-doob-h 3072)
                         (shuffled-frontier-guidance 3072))
            matched-guidance-budget true)
         causal-ablations
           (guiding-term-removal
              (weak-policy-replaced-by unguided raf-incidence 1)
            bootstrap-ablation
              ((unguided 0) (weak-doob-h 0)
               (shuffled-frontier-guidance 0))
            catalyst-ablation
              ((unguided 0) (weak-doob-h 0)
               (shuffled-frontier-guidance 0))
            rule-ablation ((op1 0) (op2 0) (op0 0)))
         rolling-detector ordered-op1-op2-op0
         primary-replication not-supported
         adaptive-extension none
         cohort-b-evaluated false
         spontaneous-emergence-claim none))

; Frozen cohort-B order/hash robustness characterization.  The incidence
; separation passes, but robustness is not supported because guiding-term
; removal retains eight RAF-positive unguided trajectories.
!(test (exp07-ordered-replication-cohort-b-robustness-supported?) False)
!(test (exp07-ordered-replication-cohort-b-report)
       (ordered-replication-cohort-b-report
         arms (unguided weak-doob-h shuffled-frontier-guidance)
         seeds (seed-117 seed-118 seed-119 seed-120
                seed-121 seed-122 seed-123 seed-124
                seed-125 seed-126 seed-127 seed-128
                seed-129 seed-130 seed-131 seed-132)
         ticks (3 26) candidate-cap 8
         raf-incidence
           ((unguided 8) (weak-doob-h 16)
            (shuffled-frontier-guidance 0))
         first-hit-ticks
           ((unguided
              (11 99 99 21 99 21 99 99 22 99 22 99 13 23 99 23))
            (weak-doob-h
              (11 10 13 10 11 12 11 14 11 12 13 12 13 12 15 14))
            (shuffled-frontier-guidance
              (99 99 99 99 99 99 99 99 99 99 99 99 99 99 99 99)))
         longest-consecutive-raf-ticks
           ((unguided (8 0 0 4 0 4 0 0 2 0 4 0 4 3 0 4))
            (weak-doob-h (16 6 5 17 8 15 8 5 7 7 14 7 6 4 7 13))
            (shuffled-frontier-guidance
              (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
         total-persistence
           ((unguided 33) (weak-doob-h 145)
            (shuffled-frontier-guidance 0))
         productive-event-totals
           ((unguided 281) (weak-doob-h 275)
            (shuffled-frontier-guidance 260))
         terminal-rule-diversity
           ((unguided (8 8 6 7 6 8 8 8 8 8 8 8 8 8 5 8))
            (weak-doob-h (8 8 8 7 8 8 8 8 8 8 8 8 8 8 8 8))
            (shuffled-frontier-guidance
              (6 6 6 5 6 6 6 6 5 6 6 6 6 5 5 6)))
         total-rule-diversity
           ((unguided 120) (weak-doob-h 127)
            (shuffled-frontier-guidance 92))
         exact-replays
           ((unguided 16) (weak-doob-h 16)
            (shuffled-frontier-guidance 16))
         intervention-cost
           (denominator-per-draw 96 draws-per-trajectory 24
            trajectories-per-arm 16
            full-matrix ((unguided 0) (weak-doob-h 3072)
                         (shuffled-frontier-guidance 3072))
            matched-guidance-budget true)
         causal-ablations
           (guiding-term-removal
              (weak-policy-replaced-by unguided raf-incidence 8)
            bootstrap-ablation
              ((unguided 0) (weak-doob-h 0)
               (shuffled-frontier-guidance 0))
            catalyst-ablation
              ((unguided 0) (weak-doob-h 0)
               (shuffled-frontier-guidance 0))
            rule-ablation ((op1 0) (op2 0) (op0 0)))
         rolling-detector ordered-op1-op2-op0
         order-hash-robustness not-supported
         cohort-a-primary-replication not-supported
         cohort-b-cannot-rescue-cohort-a true
         adaptive-extension none
         spontaneous-emergence-claim none))

; Dual-bootstrap fail-closed implementation gate.  These fixtures use only
; seed-7 and synthetic draw bins, never the registered seed-201--232 matrix.
!(test (exp07-dual-rules canonical)
       ((rule db0 A B AB X) (rule db1 C D CD AB)
        (rule dp1 A C AC CD) (rule dp2 B D BD AC)
        (rule dp3 C E CE BD) (rule dp0 C D CD CE)
        (rule dd0 A D W0 X) (rule dd1 B C W1 X)
        (rule dd2 A E W2 X) (rule dd3 B E W3 X)
        (rule dd4 A C W4 X) (rule dd5 D E W5 X)))
!(test (exp07-dual-catalyzes? X db0) True)
!(test (exp07-dual-catalyzes? CE dp0) True)
!(test (exp07-dual-catalyzes? X dp0) False)
!(test (exp07-dual-initial-applicability-gate)
       (dual-initial-applicability-gate
         db0 True db1 False dp1 False dp2 False dp3 False dp0 False
         exposed-distractors ((dd2 True) (dd3 True))
         initial-event-raf False))
!(test (exp07-dual-generate-cap
         (exp07-dual-fixture canonical 5 0 0 0 0 0))
       (candidate-pool 5
         ((candidate 5 (rule db0 A B AB X) 1)
          (candidate 5 (rule db1 C D CD AB) 1)
          (candidate 5 (rule dp1 A C AC CD) 1)
          (candidate 5 (rule dp2 B D BD AC) 1)
          (candidate 5 (rule dp3 C E CE BD) 1)
          (candidate 5 (rule dp0 C D CD CE) 1)
          (candidate 5 (rule dd0 A D W0 X) 1)
          (candidate 5 (rule dd1 B C W1 X) 1))))
!(test (exp07-dual-generate-cap
         (exp07-dual-fixture permuted 5 0 0 0 0 0))
       (exp07-dual-generate-cap
         (exp07-dual-fixture canonical 5 0 0 0 0 0)))
!(test (exp07-dual-generate-cap
         (exp07-dual-fixture permuted 3 0 0 0 0 0))
       (exp07-dual-generate-cap
         (exp07-dual-fixture canonical 3 0 0 0 0 0)))
!(test (exp07-dual-generate-cap
         (exp07-dual-fixture permuted 4 0 0 0 0 0))
       (exp07-dual-generate-cap
         (exp07-dual-fixture canonical 4 0 0 0 0 0)))
!(test (exp07-dual-complete-selector-calibration? weak-doob-h) True)
!(test (exp07-dual-complete-selector-calibration?
         shuffled-frontier-guidance) True)
!(test (exp07-dual-id-count-from
         weak-doob-h dp3 dd4 dd5 dp3 0) 20)
!(test (exp07-dual-id-count-from
         weak-doob-h dp3 dd4 dd5 dd4 0) 4)
!(test (exp07-dual-id-count-from
         shuffled-frontier-guidance dp3 dd4 dd5 dp3 0) 4)
!(test (exp07-dual-id-count-from
         shuffled-frontier-guidance dp3 dd4 dd5 dd4 0) 20)
!(test (rule-id (candidate-rule
         (exp07-dual-selected-with-draw weak-doob-h
           (exp07-dual-fixture permuted 3 0 0 0 0 0) 0))) db0)
!(test (exp07-dual-direct-tick-with-draw weak-doob-h
         (exp07-dual-fixture permuted 3 0 0 0 0 0) 0)
       (chamber exp07-dual-bootstrap-synthetic
         (state 4 seed-7
           (molecules
             ((mol A 2) (mol B 1) (mol C 3) (mol D 2) (mol E 2)
              (mol X 1) (mol AB 1) (mol CD 0) (mol AC 0)
              (mol BD 0) (mol CE 0) (mol W0 0) (mol W1 0)
              (mol W2 0) (mol W3 0) (mol W4 0) (mol W5 0))))
         ((rule dd4 A C W4 X) (rule dp2 B D BD AC)
          (rule db0 A B AB X) (rule dd1 B C W1 X)
          (rule dp0 C D CD CE) (rule dd5 D E W5 X)
          (rule db1 C D CD AB) (rule dp3 C E CE BD)
          (rule dd2 A E W2 X) (rule dp1 A C AC CD)
          (rule dd0 A D W0 X) (rule dd3 B E W3 X))
         ((event 3 db0 A B AB X))))
!(test (exp07-dual-pre-run-gate)
       (dual-bootstrap-pre-run-gate
         source-rule-count 12 catalysis-fact-count 12
         initial-applicability
           (dual-initial-applicability-gate
             db0 True db1 False dp1 False dp2 False dp3 False dp0 False
             exposed-distractors ((dd2 True) (dd3 True))
             initial-event-raf False)
         source-order-invariant-cap-phases
           ((phase-0 True) (phase-1 True) (phase-2 True))
         complete-96-bin-calibration
           ((weak-doob-h True) (shuffled-frontier-guidance True))
         matched-guidance-cost-units
           ((weak-doob-h 8) (shuffled-frontier-guidance 8))
         identical-arm-pools True
         selection-addressing rule-identity
         synthetic-direct-tick required
         registered-seed-support-implemented false
         registered-trajectory-evaluated false
         chemistry-outcomes-used false
         emergence-claim none))

; Frozen dual-bootstrap matrix.  These are the exact seed-201--232 outcomes;
; no seeds, ticks, pool identities, or thresholds were extended after access.
!(test (seed-number seed-201) 201)
!(test (seed-number seed-232) 232)
!(test (exp07-dual-draw seed-201 3) 91)
!(test (exp07-dual-draw seed-232 34) 49)
!(test (exp07-dual-sum raf unguided (exp07-dual-seeds)) 13)
!(test (exp07-dual-sum raf weak-doob-h (exp07-dual-seeds)) 9)
!(test (exp07-dual-sum raf shuffled-frontier-guidance (exp07-dual-seeds)) 0)
!(test (exp07-dual-sum events unguided (exp07-dual-seeds)) 549)
!(test (exp07-dual-sum events weak-doob-h (exp07-dual-seeds)) 523)
!(test (exp07-dual-sum events shuffled-frontier-guidance
         (exp07-dual-seeds)) 396)
!(test (exp07-dual-sum persistence unguided (exp07-dual-seeds)) 95)
!(test (exp07-dual-sum persistence weak-doob-h (exp07-dual-seeds)) 51)
!(test (exp07-dual-sum persistence shuffled-frontier-guidance
         (exp07-dual-seeds)) 0)
!(test (exp07-dual-sum diversity unguided (exp07-dual-seeds)) 336)
!(test (exp07-dual-sum diversity weak-doob-h (exp07-dual-seeds)) 278)
!(test (exp07-dual-sum diversity shuffled-frontier-guidance
         (exp07-dual-seeds)) 219)
!(test (exp07-dual-sum replay unguided (exp07-dual-seeds)) 32)
!(test (exp07-dual-sum replay weak-doob-h (exp07-dual-seeds)) 32)
!(test (exp07-dual-sum replay shuffled-frontier-guidance
         (exp07-dual-seeds)) 32)
!(test (exp07-dual-sum-ablation-raf
         bootstrap-ablation-db0 weak-doob-h (exp07-dual-seeds)) 0)
!(test (exp07-dual-sum-ablation-raf
         bootstrap-ablation-db1 weak-doob-h (exp07-dual-seeds)) 0)
!(test (exp07-dual-sum-ablation-raf
         catalyst-ablation weak-doob-h (exp07-dual-seeds)) 0)
!(test (exp07-dual-sum-ablation-raf
         rule-ablation-dp1 weak-doob-h (exp07-dual-seeds)) 0)
!(test (exp07-dual-sum-ablation-raf
         rule-ablation-dp2 weak-doob-h (exp07-dual-seeds)) 0)
!(test (exp07-dual-sum-ablation-raf
         rule-ablation-dp3 weak-doob-h (exp07-dual-seeds)) 0)
!(test (exp07-dual-sum-ablation-raf
         rule-ablation-dp0 weak-doob-h (exp07-dual-seeds)) 0)
!(test (exp07-dual-result-supported?) False)
!(test (exp07-registered-list-length
         (exp07-dual-trajectory-trace unguided seed-201)) 32)
!(test (exp07-dual-trajectory-trace-valid? unguided seed-201) True)
!(test (exp07-dual-mechanism-trace-integrity-gate) True)

; Frozen ordered-bootstrap matrix: all three arms are RAF-null over the exact
; held-out seeds and horizon, with deterministic replay and no extension.
!(test (exp07-ordered-arm-replay-count unguided) 8)
!(test (exp07-ordered-arm-replay-count weak-doob-h) 8)
!(test (exp07-ordered-arm-replay-count shuffled-frontier-guidance) 8)
!(test (exp07-ordered-secondary-summary)
       (ordered-bootstrap-secondary-summary
         longest-consecutive-raf-ticks
           ((unguided (0 0 0 0 0 0 0 0))
            (weak-doob-h (0 9 6 7 0 4 8 7))
            (shuffled-frontier-guidance (0 0 0 0 0 0 0 0)))
         total-persistence
           ((unguided 0) (weak-doob-h 41)
            (shuffled-frontier-guidance 0))
         terminal-rule-diversity
           ((unguided (5 5 6 5 6 4 6 5))
            (weak-doob-h (7 8 8 7 6 7 8 8))
            (shuffled-frontier-guidance (4 5 6 5 5 4 5 5)))
         total-rule-diversity
           ((unguided 42) (weak-doob-h 59)
            (shuffled-frontier-guidance 39))
         total-diversity-collapse-from-full-pool
           ((unguided 22) (weak-doob-h 5)
            (shuffled-frontier-guidance 25))
         fixed-seeds-and-horizon true
         guided-causal-raf-uplift supported
         spontaneous-emergence-claim none))
!(test (exp07-ordered-causal-ablation-summary)
       (ordered-bootstrap-causal-ablation
         guiding-term-removal
           (weak-policy-replaced-by unguided raf-incidence 0)
         bootstrap-ablation
           ((unguided 0) (weak-doob-h 0)
            (shuffled-frontier-guidance 0))
         catalyst-ablation
           (removed-edges ((AB op1) (AC op2) (CD op0))
            raf-incidence
              ((unguided 0) (weak-doob-h 0)
               (shuffled-frontier-guidance 0)))
         rule-ablation ((op1 0) (op2 0) (op0 0))
         fixed-seeds-pool-draws-schedule true
         terminal-forcing prohibited
         guided-causal-raf-uplift supported
         spontaneous-emergence-claim none))
!(test (exp07-ordered-matrix-summary)
       (ordered-bootstrap-matrix-summary
         arms (unguided weak-doob-h shuffled-frontier-guidance)
         seeds (seed-19 seed-20 seed-21 seed-22
                seed-23 seed-24 seed-25 seed-26)
         ticks (3 26)
         raf-incidence
           ((unguided 0) (weak-doob-h 6)
            (shuffled-frontier-guidance 0))
         first-hit-ticks
           ((unguided (99 99 99 99 99 99 99 99))
            (weak-doob-h (99 12 15 14 99 19 19 18))
            (shuffled-frontier-guidance
              (99 99 99 99 99 99 99 99)))
         productive-event-totals
           ((unguided 103) (weak-doob-h 119)
            (shuffled-frontier-guidance 104))
         exact-replays
           ((unguided 8) (weak-doob-h 8)
            (shuffled-frontier-guidance 8))
         rolling-detector ordered-op1-op2-op0
         secondary-endpoints
           (ordered-bootstrap-secondary-summary
             longest-consecutive-raf-ticks
               ((unguided (0 0 0 0 0 0 0 0))
                (weak-doob-h (0 9 6 7 0 4 8 7))
                (shuffled-frontier-guidance (0 0 0 0 0 0 0 0)))
             total-persistence
               ((unguided 0) (weak-doob-h 41)
                (shuffled-frontier-guidance 0))
             terminal-rule-diversity
               ((unguided (5 5 6 5 6 4 6 5))
                (weak-doob-h (7 8 8 7 6 7 8 8))
                (shuffled-frontier-guidance (4 5 6 5 5 4 5 5)))
             total-rule-diversity
               ((unguided 42) (weak-doob-h 59)
                (shuffled-frontier-guidance 39))
             total-diversity-collapse-from-full-pool
               ((unguided 22) (weak-doob-h 5)
                (shuffled-frontier-guidance 25))
             fixed-seeds-and-horizon true
             guided-causal-raf-uplift supported
             spontaneous-emergence-claim none)
         causal-ablations
           (ordered-bootstrap-causal-ablation
             guiding-term-removal
               (weak-policy-replaced-by unguided raf-incidence 0)
             bootstrap-ablation
               ((unguided 0) (weak-doob-h 0)
                (shuffled-frontier-guidance 0))
             catalyst-ablation
               (removed-edges ((AB op1) (AC op2) (CD op0))
                raf-incidence
                  ((unguided 0) (weak-doob-h 0)
                   (shuffled-frontier-guidance 0)))
             rule-ablation ((op1 0) (op2 0) (op0 0))
             fixed-seeds-pool-draws-schedule true
             terminal-forcing prohibited
             guided-causal-raf-uplift supported
             spontaneous-emergence-claim none)
         adaptive-extension none
         guided-causal-raf-uplift supported
         spontaneous-emergence-claim none))
