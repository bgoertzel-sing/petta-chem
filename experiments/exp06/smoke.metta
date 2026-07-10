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
