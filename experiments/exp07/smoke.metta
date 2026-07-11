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
