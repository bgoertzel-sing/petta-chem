!(import! &self ../../src/chem_exp00.metta)
!(import! &self ../../src/chem_exp04.metta)
!(import! &self ../../src/chem_exp05.metta)
!(import! &self ../../src/chem_exp06.metta)

; exp06 starts from a verified ACS-negative control row and points to the
; exp04 ACS-rich terminal fixture without treating the path as emergence.
!(test (exp06-initial-soup)
       (bridge-soup initial
                    source exp04-reduction-control
                    pool hand-designed
                    catalysis none
                    basal-interval 4
                    maximal-raf 0
                    core-size 0
                    acs-status verified-no-acs))
!(test (exp06-terminal-soup)
       (bridge-soup terminal
                    source exp04-rich-fixture
                    pool hand-designed
                    catalysis specific
                    basal-interval 4
                    maximal-raf 15
                    core-size 2
                    greedy-core (lCD lBCD2)
                    acs-status raf-rich))
!(test (exp06-initial-source-row)
       (reduction-row hand-designed none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
!(test (exp06-terminal-source-row)
       (reduction-row hand-designed specific basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14))

; Intervention variables cover the requested knobs and cite existing project
; seams rather than adding host-side chemistry.
!(test (exp06-intervention-variables)
       ((intervention-variable catalyst-affinity-assignment source exp05)
        (intervention-variable basal-food-replenishment source exp04)
        (intervention-variable candidate-pool-cap source exp00-exp03)
        (intervention-variable catalysis-map-offset source exp04)))
!(test (exp06-bridge-state initial)
       (bridge-state initial
                     catalyst-affinity-assignment none
                     basal-food-replenishment basal-4
                     candidate-pool-cap unbounded-for-raf-report
                     catalysis-map-offset none
                     maximal-raf 0))
!(test (exp06-bridge-state terminal)
       (bridge-state terminal
                     catalyst-affinity-assignment specific-template
                     basal-food-replenishment basal-4
                     candidate-pool-cap unbounded-for-raf-report
                     catalysis-map-offset specific
                     maximal-raf 15))

; First deterministic shortest-path witness: one variable change suffices to
; reach RAF-positive territory in the diagnostic source rows.
!(test (exp06-shortest-path-step-0)
       (bridge-path-step 0 initial
                         change catalysis-assignment none->specific-template
                         fixed basal-4
                         fixed candidate-cap unbounded-for-raf-report
                         result terminal
                         maximal-raf 15
                         core-size 2))
!(test (exp06-shortest-path)
       ((bridge-path-step 0 initial
                          change catalysis-assignment none->specific-template
                          fixed basal-4
                          fixed candidate-cap unbounded-for-raf-report
                          result terminal
                          maximal-raf 15
                          core-size 2)))
!(test (exp06-favorable-condition-candidate)
       (favorable-condition minimal-change
                            variable catalysis-assignment
                            from none
                            to specific-template
                            supporting-row (exp04-reduction-sweep-row hand-designed specific 4)
                            control-row (exp04-reduction-sweep-row hand-designed none 4)
                            suffices-for raf-positive-territory
                            emergence-claim none))

; Bounded path-search table compares multiple intervention variables using
; existing PeTTa evidence rows and explicit not-yet-evaluated dynamic seams.
!(test (exp06-intervention-cost-row catalyst-assignment none specific-template)
       (intervention-cost-row catalyst-assignment
                              from none
                              to specific-template
                              cost 1
                              source-row (reduction-row hand-designed specific basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14)
                              maximal-raf 15
                              core-size 2
                              status reaches-raf-positive-territory))
!(test (exp06-intervention-cost-row basal-food-replenishment basal-0 basal-4)
       (intervention-cost-row basal-food-replenishment
                              from basal-0
                              to basal-4
                              cost 1
                              source-row (reduction-row hand-designed none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14)
                              maximal-raf 0
                              core-size 0
                              status remains-raf-negative))
!(test (exp06-intervention-cost-row candidate-pool-cap unbounded-for-raf-report cap-2)
       (intervention-cost-row candidate-pool-cap
                              from unbounded-for-raf-report
                              to cap-2
                              cost 1
                              source-seam exp00-exp03
                              maximal-raf not-yet-evaluated
                              core-size not-yet-evaluated
                              status dynamic-test-required))
!(test (exp06-intervention-cost-row catalysis-map-offset none shuffled-1)
       (intervention-cost-row catalysis-map-offset
                              from none
                              to shuffled-1
                              cost 1
                              source-row (reduction-row hand-designed shuffled-1 basal-4 maximal-raf 0 core 0 events 38 diversity 12 catalyzed 24 basal 14)
                              maximal-raf 0
                              core-size 0
                              status remains-raf-negative))
!(test (exp06-intervention-cost-row catalysis-map-offset none shuffled-9)
       (intervention-cost-row catalysis-map-offset
                              from none
                              to shuffled-9
                              cost 1
                              source-row (reduction-row hand-designed shuffled-9 basal-4 maximal-raf 7 core 3 events 20 diversity 10 catalyzed 6 basal 14)
                              maximal-raf 7
                              core-size 3
                              status offset-sensitive-raf-like-control))
!(test (exp06-bounded-cost-table)
       ((intervention-cost-row catalyst-assignment
                               from none
                               to specific-template
                               cost 1
                               source-row (reduction-row hand-designed specific basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14)
                               maximal-raf 15
                               core-size 2
                               status reaches-raf-positive-territory)
        (intervention-cost-row catalyst-assignment
                               from none
                               to broad-template
                               cost 1
                               source-row (reduction-row hand-designed broad basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14)
                               maximal-raf 15
                               core-size 2
                               status reaches-raf-positive-territory)
        (intervention-cost-row basal-food-replenishment
                               from basal-0
                               to basal-4
                               cost 1
                               source-row (reduction-row hand-designed none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14)
                               maximal-raf 0
                               core-size 0
                               status remains-raf-negative)
        (intervention-cost-row candidate-pool-cap
                               from unbounded-for-raf-report
                               to cap-2
                               cost 1
                               source-seam exp00-exp03
                               maximal-raf not-yet-evaluated
                               core-size not-yet-evaluated
                               status dynamic-test-required)
        (intervention-cost-row catalysis-map-offset
                               from none
                               to shuffled-1
                               cost 1
                               source-row (reduction-row hand-designed shuffled-1 basal-4 maximal-raf 0 core 0 events 38 diversity 12 catalyzed 24 basal 14)
                               maximal-raf 0
                               core-size 0
                               status remains-raf-negative)
        (intervention-cost-row catalysis-map-offset
                               from none
                               to shuffled-9
                               cost 1
                               source-row (reduction-row hand-designed shuffled-9 basal-4 maximal-raf 7 core 3 events 20 diversity 10 catalyzed 6 basal 14)
                               maximal-raf 7
                               core-size 3
                               status offset-sensitive-raf-like-control)))
!(test (exp06-bounded-shortest-path-table)
       (bounded-path-search
         start initial
         terminal-class raf-positive-territory
         bound max-cost-1
         variables (catalyst-affinity-assignment
                    basal-food-replenishment
                    candidate-pool-cap
                    catalysis-map-offset)
         winning-path ((intervention-cost-row catalyst-assignment
                                              from none
                                              to specific-template
                                              cost 1
                                              source-row (reduction-row hand-designed specific basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14)
                                              maximal-raf 15
                                              core-size 2
                                              status reaches-raf-positive-territory))
         alternate-positive ((intervention-cost-row catalyst-assignment
                                                    from none
                                                    to broad-template
                                                    cost 1
                                                    source-row (reduction-row hand-designed broad basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14)
                                                    maximal-raf 15
                                                    core-size 2
                                                    status reaches-raf-positive-territory)
                             (intervention-cost-row catalysis-map-offset
                                                    from none
                                                    to shuffled-9
                                                    cost 1
                                                    source-row (reduction-row hand-designed shuffled-9 basal-4 maximal-raf 7 core 3 events 20 diversity 10 catalyzed 6 basal 14)
                                                    maximal-raf 7
                                                    core-size 3
                                                    status offset-sensitive-raf-like-control))
         negative-or-unevaluated ((intervention-cost-row basal-food-replenishment
                                                         from basal-0
                                                         to basal-4
                                                         cost 1
                                                         source-row (reduction-row hand-designed none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14)
                                                         maximal-raf 0
                                                         core-size 0
                                                         status remains-raf-negative)
                                  (intervention-cost-row catalysis-map-offset
                                                         from none
                                                         to shuffled-1
                                                         cost 1
                                                         source-row (reduction-row hand-designed shuffled-1 basal-4 maximal-raf 0 core 0 events 38 diversity 12 catalyzed 24 basal 14)
                                                         maximal-raf 0
                                                         core-size 0
                                                         status remains-raf-negative)
                                  (intervention-cost-row candidate-pool-cap
                                                         from unbounded-for-raf-report
                                                         to cap-2
                                                         cost 1
                                                         source-seam exp00-exp03
                                                         maximal-raf not-yet-evaluated
                                                         core-size not-yet-evaluated
                                                         status dynamic-test-required))
         interpretation favorable-condition-candidates-are-catalysis-map-sensitive
         emergence-claim none))
!(test (exp06-bounded-path-search-status)
       (exp06-status bounded-cost-path-table
                     rows 6
                     bound max-cost-1
                     variables 4
                     positive-rows 3
                     negative-or-unevaluated-rows 3
                     chemistry-kernel petta-native
                     host-role bookkeeping-only
                     emergence-claim none))

; Candidate-cap dynamics now have a narrow single-tick probe through exp05's
; affinity-assigned pool and exp00 chamber ticking. This starts evaluating the
; cap row without turning a one-tick productive event into a RAF claim.
!(test (exp06-candidate-cap-selected-candidate cap-1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp06-candidate-cap-selected-candidate cap-2)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp06-candidate-cap-after-tick cap-1)
       (chamber exp05-treatment
                (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp06-candidate-cap-after-tick cap-2)
       (chamber exp05-treatment
                (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp06-candidate-cap-control-selected-candidate cap-1)
       (candidate 3 (rule e5r0 A B AB AC) 2))
!(test (exp06-candidate-cap-control-selected-candidate cap-2)
       (candidate 3 (rule e5r0 A B AB AC) 2))
!(test (exp06-candidate-cap-control-after-tick cap-1)
       (chamber exp05-rotated-control
                (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AC))))
!(test (exp06-candidate-cap-control-after-tick cap-2)
       (chamber exp05-rotated-control
                (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AC))))
!(test (exp06-candidate-cap-dynamic-probe cap-1)
       (candidate-cap-dynamic-probe
         cap cap-1
         source exp05-affinity-assigned-pool
         chamber exp05-treatment
         seed seed-7
         tick 3
         selected-candidate (candidate 3 (rule e5r0 A B AB AB) 3)
         after-tick (chamber exp05-treatment
                             (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                             ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                             ((event 3 e5r0 A B AB AB)))
         first-tick-productivity productive
         raf-status not-yet-evaluated
         emergence-claim none))
!(test (exp06-candidate-cap-dynamic-probe cap-2)
       (candidate-cap-dynamic-probe
         cap cap-2
         source exp05-affinity-assigned-pool
         chamber exp05-treatment
         seed seed-7
         tick 3
         selected-candidate (candidate 3 (rule e5r0 A B AB AB) 3)
         after-tick (chamber exp05-treatment
                             (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                             ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                             ((event 3 e5r0 A B AB AB)))
         first-tick-productivity productive
         raf-status not-yet-evaluated
         emergence-claim none))
!(test (exp06-candidate-cap-dynamic-comparison)
       (candidate-cap-dynamic-comparison
         caps (cap-1 cap-2)
         source exp05-affinity-single-tick
         selected-candidates ((candidate 3 (rule e5r0 A B AB AB) 3)
                              (candidate 3 (rule e5r0 A B AB AB) 3))
         result same-first-tick-productive-event
         conclusion cap-dynamics-probed-but-raf-status-open
         next-test multi-tick-cap-sweep
         emergence-claim none))
!(test (exp06-candidate-cap-treatment-control-probe)
       (candidate-cap-treatment-control-probe
         caps (cap-1 cap-2)
         treatment-selected ((candidate 3 (rule e5r0 A B AB AB) 3)
                             (candidate 3 (rule e5r0 A B AB AB) 3))
         control-selected ((candidate 3 (rule e5r0 A B AB AC) 2)
                           (candidate 3 (rule e5r0 A B AB AC) 2))
         treatment-after-tick ((chamber exp05-treatment
                                        (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                        ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                        ((event 3 e5r0 A B AB AB)))
                               (chamber exp05-treatment
                                        (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                                        ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                        ((event 3 e5r0 A B AB AB))))
         control-after-tick ((chamber exp05-rotated-control
                                      (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AC)))
                             (chamber exp05-rotated-control
                                      (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                      ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                      ((event 3 e5r0 A B AB AC))))
         result cap-1-and-cap-2-preserve-first-tick-productivity-in-treatment-and-control
         scientific-boundary single-tick-productivity-not-raf-status
         next-test multi-tick-cap-sweep
         emergence-claim none))

; The next bounded diagnostic sweep adds a refreshed tick-4 comparison.  Cap-2
; exposes the second source rule at tick 4 through deterministic selection;
; cap-1 remains pinned to the first rule.  This is still not a RAF claim.
!(test (exp06-cap-sweep-treatment-selected tick-4 cap-1)
       (candidate 4 (rule e5r0 A B AB AC) 2))
!(test (exp06-cap-sweep-treatment-selected tick-4 cap-2)
       (candidate 4 (rule e5r1 A C AC AC) 3))
!(test (exp06-cap-sweep-control-selected tick-4 cap-1)
       (candidate 4 (rule e5r0 A B AB AC) 2))
!(test (exp06-cap-sweep-control-selected tick-4 cap-2)
       (candidate 4 (rule e5r1 A C AC AC) 3))
!(test (exp06-cap-sweep-treatment-after-tick tick-4 cap-1)
       (chamber exp06-treatment-cap1-tick4
                (state 5 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 4 e5r0 A B AB AC))))
!(test (exp06-cap-sweep-treatment-after-tick tick-4 cap-2)
       (chamber exp06-treatment-cap2-tick4
                (state 5 seed-7 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 4 e5r1 A C AC AC))))
!(test (exp06-cap-sweep-control-after-tick tick-4 cap-1)
       (chamber exp06-control-cap1-tick4
                (state 5 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 4 e5r0 A B AB AC))))
!(test (exp06-cap-sweep-control-after-tick tick-4 cap-2)
       (chamber exp06-control-cap2-tick4
                (state 5 seed-7 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 4 e5r1 A C AC AC))))
!(test (exp06-candidate-cap-two-tick-sweep)
       (candidate-cap-two-tick-sweep
         ticks (3 4)
         caps (cap-1 cap-2)
         tick-3-result same-first-tick-productive-event
         tick-4-treatment-selected ((candidate 4 (rule e5r0 A B AB AC) 2)
                                    (candidate 4 (rule e5r1 A C AC AC) 3))
         tick-4-control-selected ((candidate 4 (rule e5r0 A B AB AC) 2)
                                  (candidate 4 (rule e5r1 A C AC AC) 3))
         tick-4-treatment-after ((chamber exp06-treatment-cap1-tick4
                                          (state 5 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                          ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                          ((event 4 e5r0 A B AB AC)))
                                 (chamber exp06-treatment-cap2-tick4
                                          (state 5 seed-7 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                                          ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                          ((event 4 e5r1 A C AC AC))))
         tick-4-control-after ((chamber exp06-control-cap1-tick4
                                        (state 5 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                                        ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                        ((event 4 e5r0 A B AB AC)))
                               (chamber exp06-control-cap2-tick4
                                        (state 5 seed-7 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                                        ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                        ((event 4 e5r1 A C AC AC))))
         cap-effect cap-2-exposes-second-source-rule-at-tick-4
         treatment-control-result matched-productive-cap-divergence
         scientific-boundary refreshed-two-tick-diagnostic-not-raf-status
         next-test accumulated-multi-tick-stateful-sweep
         emergence-claim none))

; Stateful two-tick cap sweep: tick 4 starts from the tick 3 output chamber.
; Cap-1 repeats e5r0; cap-2 exposes e5r1 and accumulates a different final
; abundance/event path.  This is still a bounded diagnostic, not RAF status.
!(test (exp06-stateful-cap-sweep-selected tick-3 cap-1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp06-stateful-cap-sweep-selected tick-3 cap-2)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp06-stateful-cap-sweep-selected tick-4 cap-1)
       (candidate 4 (rule e5r0 A B AB AC) 2))
!(test (exp06-stateful-cap-sweep-selected tick-4 cap-2)
       (candidate 4 (rule e5r1 A C AC AC) 3))
!(test (exp06-stateful-cap-sweep-after tick-4 cap-1)
       (chamber exp06-stateful-cap1
                (state 5 seed-7
                       (mol A 0)
                       (mol B 0)
                       (mol C 1)
                       (mol AB 3)
                       (mol AC 1)
                       (mol BC 0))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB)
                 (event 4 e5r0 A B AB AC))))
!(test (exp06-stateful-cap-sweep-after tick-4 cap-2)
       (chamber exp06-stateful-cap2
                (state 5 seed-7
                       (mol A 0)
                       (mol B 1)
                       (mol C 0)
                       (mol AB 2)
                       (mol AC 2)
                       (mol BC 0))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB)
                 (event 4 e5r1 A C AC AC))))
!(test (exp06-candidate-cap-stateful-two-tick-sweep)
       (candidate-cap-stateful-two-tick-sweep
         ticks (3 4)
         caps (cap-1 cap-2)
         initial-chambers ((chamber exp06-stateful-cap1
                                    (state 3 seed-7
                                           (mol A 2)
                                           (mol B 2)
                                           (mol C 1)
                                           (mol AB 1)
                                           (mol AC 1)
                                           (mol BC 0))
                                    ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                    ())
                           (chamber exp06-stateful-cap2
                                    (state 3 seed-7
                                           (mol A 2)
                                           (mol B 2)
                                           (mol C 1)
                                           (mol AB 1)
                                           (mol AC 1)
                                           (mol BC 0))
                                    ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                    ()))
         selected-candidates ((candidate 3 (rule e5r0 A B AB AB) 3)
                              (candidate 3 (rule e5r0 A B AB AB) 3)
                              (candidate 4 (rule e5r0 A B AB AC) 2)
                              (candidate 4 (rule e5r1 A C AC AC) 3))
         final-chambers ((chamber exp06-stateful-cap1
                                  (state 5 seed-7
                                         (mol A 0)
                                         (mol B 0)
                                         (mol C 1)
                                         (mol AB 3)
                                         (mol AC 1)
                                         (mol BC 0))
                                  ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                  ((event 3 e5r0 A B AB AB)
                                   (event 4 e5r0 A B AB AC)))
                         (chamber exp06-stateful-cap2
                                  (state 5 seed-7
                                         (mol A 0)
                                         (mol B 1)
                                         (mol C 0)
                                         (mol AB 2)
                                         (mol AC 2)
                                         (mol BC 0))
                                  ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                                  ((event 3 e5r0 A B AB AB)
                                   (event 4 e5r1 A C AC AC))))
         cap-1-pathway repeated-first-source-rule
         cap-2-pathway first-then-second-source-rule
         cap-effect accumulated-abundance-divergence-after-stateful-two-tick-sweep
         scientific-boundary stateful-two-tick-diagnostic-not-raf-status
         next-test longer-stateful-sweep-with-acs-scan
         emergence-claim none))

; Protected-release analog is only a bias contract for future dynamics, not a
; terminal-condition clamp.
!(test (exp06-protected-release-bias-contract)
       (protected-release-bias
         value-relative anti-precedence
         penalize over-dominant-pathway-families
         protect shared-catalytic-machinery
         terminal-condition not-fixed
         evaluation compare-unguided-vs-biased-dynamics
         emergence-claim none))
!(test (exp06-scaffold-status)
       (exp06-status bridge-to-acs-favorable-conditions
                     initial-soup verified-no-acs
                     terminal-soup exp04-raf-rich
                     path-search deterministic-shortest-path-scaffold
                     host-role bookkeeping-only
                     chemistry-kernel petta-native
                     emergence-claim none))
