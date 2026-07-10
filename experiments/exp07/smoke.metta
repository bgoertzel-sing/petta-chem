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
