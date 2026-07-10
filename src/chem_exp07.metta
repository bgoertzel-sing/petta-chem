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
