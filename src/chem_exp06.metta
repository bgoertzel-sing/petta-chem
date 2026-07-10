; exp06 bridge-to-ACS favorable-conditions scaffold.
;
; This is a diagnostic bridge-analysis layer over already tested PeTTa chemistry
; records.  It names an ACS-negative initial soup, an ACS-rich terminal soup,
; intervention variables, and a first deterministic shortest-path witness over
; those variables.  The bridge path is not an emergence claim: it is a compact
; way to ask which favorable-condition changes should be tested in later
; unguided or weakly guided chamber dynamics.
;
; Load chem_exp04.metta and chem_exp05.metta before this file when tests need to
; verify the cited source rows/status atoms.

; ----- Source soups -----

(= (exp06-initial-soup)
   (bridge-soup initial
                source exp04-reduction-control
                pool hand-designed
                catalysis none
                basal-interval 4
                maximal-raf 0
                core-size 0
                acs-status verified-no-acs))

(= (exp06-terminal-soup)
   (bridge-soup terminal
                source exp04-rich-fixture
                pool hand-designed
                catalysis specific
                basal-interval 4
                maximal-raf 15
                core-size 2
                greedy-core (lCD lBCD2)
                acs-status raf-rich))

(= (exp06-initial-source-row)
   (exp04-reduction-sweep-row hand-designed none 4))

(= (exp06-terminal-source-row)
   (exp04-reduction-sweep-row hand-designed specific 4))

; ----- Intervention-variable vocabulary -----

(= (exp06-intervention-variables)
   ((intervention-variable catalyst-affinity-assignment source exp05)
    (intervention-variable basal-food-replenishment source exp04)
    (intervention-variable candidate-pool-cap source exp00-exp03)
    (intervention-variable catalysis-map-offset source exp04)))

(= (exp06-bridge-state initial)
   (bridge-state initial
                 catalyst-affinity-assignment none
                 basal-food-replenishment basal-4
                 candidate-pool-cap unbounded-for-raf-report
                 catalysis-map-offset none
                 maximal-raf 0))

(= (exp06-bridge-state terminal)
   (bridge-state terminal
                 catalyst-affinity-assignment specific-template
                 basal-food-replenishment basal-4
                 candidate-pool-cap unbounded-for-raf-report
                 catalysis-map-offset specific
                 maximal-raf 15))

; First deterministic shortest-path witness: relative to the exp04 hand-designed
; no-catalysis control, changing only the catalysis assignment/map to the
; specificity-filtered template map reaches ACS-positive territory while basal
; interval and candidate-cap convention remain fixed.  Later path search can add
; costs over affinity/cap/basal variables, but this one-step witness is already
; a testable favorable-condition hypothesis.
(= (exp06-shortest-path-step-0)
   (bridge-path-step 0 initial
                     change catalysis-assignment none->specific-template
                     fixed basal-4
                     fixed candidate-cap unbounded-for-raf-report
                     result terminal
                     maximal-raf 15
                     core-size 2))

(= (exp06-shortest-path)
   ((exp06-shortest-path-step-0)))

(= (exp06-favorable-condition-candidate)
   (favorable-condition minimal-change
                        variable catalysis-assignment
                        from none
                        to specific-template
                        supporting-row (exp04-reduction-sweep-row hand-designed specific 4)
                        control-row (exp04-reduction-sweep-row hand-designed none 4)
                        suffices-for raf-positive-territory
                        emergence-claim none))

; ----- Bounded cost/path-search table -----
;
; These rows are a small deterministic path-search table over existing PeTTa
; evidence rows and named seams.  They make the one-step witness less implicit:
; catalysis assignment, basal replenishment, candidate-cap convention, and
; catalysis-map offset all appear as bounded intervention candidates.  Rows that
; do not have an exp04 RAF source row yet are marked not-yet-evaluated rather
; than inferred.

(= (exp06-intervention-cost-row catalyst-assignment none specific-template)
   (intervention-cost-row catalyst-assignment
                          from none
                          to specific-template
                          cost 1
                          source-row (exp04-reduction-sweep-row hand-designed specific 4)
                          maximal-raf 15
                          core-size 2
                          status reaches-raf-positive-territory))

(= (exp06-intervention-cost-row catalyst-assignment none broad-template)
   (intervention-cost-row catalyst-assignment
                          from none
                          to broad-template
                          cost 1
                          source-row (exp04-reduction-sweep-row hand-designed broad 4)
                          maximal-raf 15
                          core-size 2
                          status reaches-raf-positive-territory))

(= (exp06-intervention-cost-row basal-food-replenishment basal-0 basal-4)
   (intervention-cost-row basal-food-replenishment
                          from basal-0
                          to basal-4
                          cost 1
                          source-row (exp04-reduction-sweep-row hand-designed none 4)
                          maximal-raf 0
                          core-size 0
                          status remains-raf-negative))

(= (exp06-intervention-cost-row candidate-pool-cap unbounded-for-raf-report cap-2)
   (intervention-cost-row candidate-pool-cap
                          from unbounded-for-raf-report
                          to cap-2
                          cost 1
                          source-seam exp00-exp03
                          maximal-raf not-yet-evaluated
                          core-size not-yet-evaluated
                          status dynamic-test-required))

(= (exp06-intervention-cost-row catalysis-map-offset none shuffled-1)
   (intervention-cost-row catalysis-map-offset
                          from none
                          to shuffled-1
                          cost 1
                          source-row (exp04-reduction-sweep-row hand-designed shuffled-1 4)
                          maximal-raf 0
                          core-size 0
                          status remains-raf-negative))

(= (exp06-intervention-cost-row catalysis-map-offset none shuffled-9)
   (intervention-cost-row catalysis-map-offset
                          from none
                          to shuffled-9
                          cost 1
                          source-row (exp04-reduction-sweep-row hand-designed shuffled-9 4)
                          maximal-raf 7
                          core-size 3
                          status offset-sensitive-raf-like-control))

(= (exp06-bounded-cost-table)
   ((exp06-intervention-cost-row catalyst-assignment none specific-template)
    (exp06-intervention-cost-row catalyst-assignment none broad-template)
    (exp06-intervention-cost-row basal-food-replenishment basal-0 basal-4)
    (exp06-intervention-cost-row candidate-pool-cap unbounded-for-raf-report cap-2)
    (exp06-intervention-cost-row catalysis-map-offset none shuffled-1)
    (exp06-intervention-cost-row catalysis-map-offset none shuffled-9)))

(= (exp06-bounded-shortest-path-table)
   (bounded-path-search
     start initial
     terminal-class raf-positive-territory
     bound max-cost-1
     variables (catalyst-affinity-assignment
                basal-food-replenishment
                candidate-pool-cap
                catalysis-map-offset)
     winning-path ((exp06-intervention-cost-row catalyst-assignment none specific-template))
     alternate-positive ((exp06-intervention-cost-row catalyst-assignment none broad-template)
                         (exp06-intervention-cost-row catalysis-map-offset none shuffled-9))
     negative-or-unevaluated ((exp06-intervention-cost-row basal-food-replenishment basal-0 basal-4)
                              (exp06-intervention-cost-row catalysis-map-offset none shuffled-1)
                              (exp06-intervention-cost-row candidate-pool-cap unbounded-for-raf-report cap-2))
     interpretation favorable-condition-candidates-are-catalysis-map-sensitive
     emergence-claim none))

(= (exp06-bounded-path-search-status)
   (exp06-status bounded-cost-path-table
                 rows 6
                 bound max-cost-1
                 variables 4
                 positive-rows 3
                 negative-or-unevaluated-rows 3
                 chemistry-kernel petta-native
                 host-role bookkeeping-only
                 emergence-claim none))

; ----- Candidate-cap dynamic probe -----
;
; This is the first dynamic check behind the candidate-pool-cap intervention row.
; It reuses the exp05 affinity-assigned candidate pool and exp00 chamber tick.
; The result is intentionally narrow: cap-1 and cap-2 both preserve the same
; productive first tick for this seed/tick fixture, so RAF status remains
; not-yet-evaluated rather than inferred from a one-tick probe.

(= (exp06-candidate-cap-selected-candidate cap-1)
   (assign-soft-biased-candidate-4
     seed-7 3 1 (exp05-source-rule) (exp05-catalyst-candidates)))

(= (exp06-candidate-cap-selected-candidate cap-2)
   (exp05-affinity-selected-candidate-2 seed-7 3 1))

(= (exp06-candidate-cap-after-tick cap-1)
   (chamber-tick-with-candidate
     (exp05-treatment-chamber seed-7 3)
     (exp06-candidate-cap-selected-candidate cap-1)))

(= (exp06-candidate-cap-after-tick cap-2)
   (exp05-chamber-tick-affinity-2 seed-7 3 1))

(= (exp06-candidate-cap-control-selected-candidate cap-1)
   (assign-shuffled-affinity-candidate-4
     seed-7 3 1 (exp05-source-rule) (exp05-catalyst-candidates)))

(= (exp06-candidate-cap-control-selected-candidate cap-2)
   (exp05-shuffled-affinity-selected-candidate-2 seed-7 3 1))

(= (exp06-candidate-cap-control-after-tick cap-1)
   (chamber-tick-with-candidate
     (exp05-rotated-control-chamber seed-7 3)
     (exp06-candidate-cap-control-selected-candidate cap-1)))

(= (exp06-candidate-cap-control-after-tick cap-2)
   (exp05-chamber-tick-shuffled-affinity-2 seed-7 3 1))

(= (exp06-candidate-cap-dynamic-probe cap-1)
   (candidate-cap-dynamic-probe
     cap cap-1
     source exp05-affinity-assigned-pool
     chamber exp05-treatment
     seed seed-7
     tick 3
     selected-candidate (exp06-candidate-cap-selected-candidate cap-1)
     after-tick (exp06-candidate-cap-after-tick cap-1)
     first-tick-productivity productive
     raf-status not-yet-evaluated
     emergence-claim none))

(= (exp06-candidate-cap-dynamic-probe cap-2)
   (candidate-cap-dynamic-probe
     cap cap-2
     source exp05-affinity-assigned-pool
     chamber exp05-treatment
     seed seed-7
     tick 3
     selected-candidate (exp06-candidate-cap-selected-candidate cap-2)
     after-tick (exp06-candidate-cap-after-tick cap-2)
     first-tick-productivity productive
     raf-status not-yet-evaluated
     emergence-claim none))

(= (exp06-candidate-cap-dynamic-comparison)
   (candidate-cap-dynamic-comparison
     caps (cap-1 cap-2)
     source exp05-affinity-single-tick
     selected-candidates ((exp06-candidate-cap-selected-candidate cap-1)
                          (exp06-candidate-cap-selected-candidate cap-2))
     result same-first-tick-productive-event
     conclusion cap-dynamics-probed-but-raf-status-open
     next-test multi-tick-cap-sweep
     emergence-claim none))

(= (exp06-candidate-cap-treatment-control-probe)
   (candidate-cap-treatment-control-probe
     caps (cap-1 cap-2)
     treatment-selected ((exp06-candidate-cap-selected-candidate cap-1)
                         (exp06-candidate-cap-selected-candidate cap-2))
     control-selected ((exp06-candidate-cap-control-selected-candidate cap-1)
                       (exp06-candidate-cap-control-selected-candidate cap-2))
     treatment-after-tick ((exp06-candidate-cap-after-tick cap-1)
                           (exp06-candidate-cap-after-tick cap-2))
     control-after-tick ((exp06-candidate-cap-control-after-tick cap-1)
                         (exp06-candidate-cap-control-after-tick cap-2))
     result cap-1-and-cap-2-preserve-first-tick-productivity-in-treatment-and-control
     scientific-boundary single-tick-productivity-not-raf-status
     next-test multi-tick-cap-sweep
     emergence-claim none))

; A bounded two-tick sweep extends the cap probe beyond the single tick above
; while keeping all candidate assignment and chamber firing in PeTTa.  The
; second tick is a refreshed diagnostic chamber, not a replayed RAF dynamics
; claim: it asks whether deterministic selection differs when cap-2 exposes the
; second affinity-assigned source rule.  At tick 4, seed-7 chooses index 1 from
; a cap-2 pool, while cap-1 still exposes only the first candidate.

(= (exp06-cap-sweep-treatment-chamber tick-4 cap-1)
   (chamber exp06-treatment-cap1-tick4
            (state 4 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp06-cap-sweep-treatment-chamber tick-4 cap-2)
   (chamber exp06-treatment-cap2-tick4
            (state 4 seed-7 (mol A 1) (mol C 1) (mol AC 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp06-cap-sweep-control-chamber tick-4 cap-1)
   (chamber exp06-control-cap1-tick4
            (state 4 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp06-cap-sweep-control-chamber tick-4 cap-2)
   (chamber exp06-control-cap2-tick4
            (state 4 seed-7 (mol A 1) (mol C 1) (mol AC 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp06-cap-sweep-treatment-selected tick-4 cap-1)
   (assign-soft-biased-candidate-4
     seed-7 4 1 (exp05-source-rule) (exp05-catalyst-candidates)))

(= (exp06-cap-sweep-treatment-selected tick-4 cap-2)
   (selected-candidate-from-list-2
     (exp06-cap-sweep-treatment-chamber tick-4 cap-2)
     (cap-candidate-pool
       2
       (exp05-affinity-candidate-pool-2 seed-7 4 1))))

(= (exp06-cap-sweep-control-selected tick-4 cap-1)
   (assign-shuffled-affinity-candidate-4
     seed-7 4 1 (exp05-source-rule) (exp05-catalyst-candidates)))

(= (exp06-cap-sweep-control-selected tick-4 cap-2)
   (selected-candidate-from-list-2
     (exp06-cap-sweep-control-chamber tick-4 cap-2)
     (cap-candidate-pool
       2
       (exp05-shuffled-affinity-candidate-pool-2 seed-7 4 1))))

(= (exp06-cap-sweep-treatment-after-tick tick-4 cap-1)
   (chamber-tick-with-candidate
     (exp06-cap-sweep-treatment-chamber tick-4 cap-1)
     (exp06-cap-sweep-treatment-selected tick-4 cap-1)))

(= (exp06-cap-sweep-treatment-after-tick tick-4 cap-2)
   (chamber-tick-with-candidate
     (exp06-cap-sweep-treatment-chamber tick-4 cap-2)
     (exp06-cap-sweep-treatment-selected tick-4 cap-2)))

(= (exp06-cap-sweep-control-after-tick tick-4 cap-1)
   (chamber-tick-with-candidate
     (exp06-cap-sweep-control-chamber tick-4 cap-1)
     (exp06-cap-sweep-control-selected tick-4 cap-1)))

(= (exp06-cap-sweep-control-after-tick tick-4 cap-2)
   (chamber-tick-with-candidate
     (exp06-cap-sweep-control-chamber tick-4 cap-2)
     (exp06-cap-sweep-control-selected tick-4 cap-2)))

(= (exp06-candidate-cap-two-tick-sweep)
   (candidate-cap-two-tick-sweep
     ticks (3 4)
     caps (cap-1 cap-2)
     tick-3-result same-first-tick-productive-event
     tick-4-treatment-selected ((exp06-cap-sweep-treatment-selected tick-4 cap-1)
                                (exp06-cap-sweep-treatment-selected tick-4 cap-2))
     tick-4-control-selected ((exp06-cap-sweep-control-selected tick-4 cap-1)
                              (exp06-cap-sweep-control-selected tick-4 cap-2))
     tick-4-treatment-after ((exp06-cap-sweep-treatment-after-tick tick-4 cap-1)
                             (exp06-cap-sweep-treatment-after-tick tick-4 cap-2))
     tick-4-control-after ((exp06-cap-sweep-control-after-tick tick-4 cap-1)
                           (exp06-cap-sweep-control-after-tick tick-4 cap-2))
     cap-effect cap-2-exposes-second-source-rule-at-tick-4
     treatment-control-result matched-productive-cap-divergence
     scientific-boundary refreshed-two-tick-diagnostic-not-raf-status
     next-test accumulated-multi-tick-stateful-sweep
     emergence-claim none))

; The stateful sweep below carries the tick-3 chamber state into tick 4 rather
; than refreshing the chamber.  It uses the same exp05 affinity-assigned source
; rules and exp00 candidate selector, plus explicit PeTTa six-molecule chamber
; tick clauses for this diagnostic state shape.  Cap-1 repeats the first source
; rule, while cap-2 admits the second source rule at tick 4; the result is an
; accumulated abundance/pathway split, not an ACS/RAF-status claim.

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5))
   $tick)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5))
   $seed)

(= (chamber-tick-with-candidate
      (chamber $id
               (state $tick $seed
                      (mol A $a-count)
                      (mol B $b-count)
                      (mol C $c-count)
                      (mol AB $ab-count)
                      (mol AC $ac-count)
                      (mol BC $bc-count))
               $rules
               ())
      (candidate $tick (rule e5r0 A B AB $catalyst) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol A (- $a-count 1))
                   (mol B (- $b-count 1))
                   (mol C $c-count)
                   (mol AB (+ $ab-count 1))
                   (mol AC $ac-count)
                   (mol BC $bc-count))
            $rules
            ((event $tick e5r0 A B AB $catalyst))))

(= (chamber-tick-with-candidate
      (chamber $id
               (state $tick $seed
                      (mol A $a-count)
                      (mol B $b-count)
                      (mol C $c-count)
                      (mol AB $ab-count)
                      (mol AC $ac-count)
                      (mol BC $bc-count))
               $rules
               ($event-0))
      (candidate $tick (rule e5r0 A B AB $catalyst) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol A (- $a-count 1))
                   (mol B (- $b-count 1))
                   (mol C $c-count)
                   (mol AB (+ $ab-count 1))
                   (mol AC $ac-count)
                   (mol BC $bc-count))
            $rules
            ($event-0 (event $tick e5r0 A B AB $catalyst))))

(= (chamber-tick-with-candidate
      (chamber $id
               (state $tick $seed
                      (mol A $a-count)
                      (mol B $b-count)
                      (mol C $c-count)
                      (mol AB $ab-count)
                      (mol AC $ac-count)
                      (mol BC $bc-count))
               $rules
               ($event-0))
      (candidate $tick (rule e5r1 A C AC $catalyst) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol A (- $a-count 1))
                   (mol B $b-count)
                   (mol C (- $c-count 1))
                   (mol AB $ab-count)
                   (mol AC (+ $ac-count 1))
                   (mol BC $bc-count))
            $rules
            ($event-0 (event $tick e5r1 A C AC $catalyst))))

(= (exp06-stateful-cap-sweep-initial-chamber $arm $cap)
   (chamber $arm
            (state 3 seed-7
                   (mol A 2)
                   (mol B 2)
                   (mol C 1)
                   (mol AB 1)
                   (mol AC 1)
                   (mol BC 0))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp06-stateful-cap-sweep-selected tick-3 cap-1)
   (assign-soft-biased-candidate-4
     seed-7 3 1 (exp05-source-rule) (exp05-catalyst-candidates)))

(= (exp06-stateful-cap-sweep-selected tick-3 cap-2)
   (selected-candidate-from-list-2
     (exp06-stateful-cap-sweep-initial-chamber exp06-stateful-cap2 cap-2)
     (cap-candidate-pool
       2
       (exp05-affinity-candidate-pool-2 seed-7 3 1))))

(= (exp06-stateful-cap-sweep-after tick-3 cap-1)
   (chamber-tick-with-candidate
     (exp06-stateful-cap-sweep-initial-chamber exp06-stateful-cap1 cap-1)
     (exp06-stateful-cap-sweep-selected tick-3 cap-1)))

(= (exp06-stateful-cap-sweep-after tick-3 cap-2)
   (chamber-tick-with-candidate
     (exp06-stateful-cap-sweep-initial-chamber exp06-stateful-cap2 cap-2)
     (exp06-stateful-cap-sweep-selected tick-3 cap-2)))

(= (exp06-stateful-cap-sweep-selected tick-4 cap-1)
   (assign-soft-biased-candidate-4
     seed-7 4 1 (exp05-source-rule) (exp05-catalyst-candidates)))

(= (exp06-stateful-cap-sweep-selected tick-4 cap-2)
   (selected-candidate-from-list-2
     (exp06-stateful-cap-sweep-after tick-3 cap-2)
     (cap-candidate-pool
       2
       (exp05-affinity-candidate-pool-2 seed-7 4 1))))

(= (exp06-stateful-cap-sweep-after tick-4 cap-1)
   (chamber-tick-with-candidate
     (exp06-stateful-cap-sweep-after tick-3 cap-1)
     (exp06-stateful-cap-sweep-selected tick-4 cap-1)))

(= (exp06-stateful-cap-sweep-after tick-4 cap-2)
   (chamber-tick-with-candidate
     (exp06-stateful-cap-sweep-after tick-3 cap-2)
     (exp06-stateful-cap-sweep-selected tick-4 cap-2)))

(= (exp06-candidate-cap-stateful-two-tick-sweep)
   (candidate-cap-stateful-two-tick-sweep
     ticks (3 4)
     caps (cap-1 cap-2)
     initial-chambers ((exp06-stateful-cap-sweep-initial-chamber exp06-stateful-cap1 cap-1)
                       (exp06-stateful-cap-sweep-initial-chamber exp06-stateful-cap2 cap-2))
     selected-candidates ((exp06-stateful-cap-sweep-selected tick-3 cap-1)
                          (exp06-stateful-cap-sweep-selected tick-3 cap-2)
                          (exp06-stateful-cap-sweep-selected tick-4 cap-1)
                          (exp06-stateful-cap-sweep-selected tick-4 cap-2))
     final-chambers ((exp06-stateful-cap-sweep-after tick-4 cap-1)
                     (exp06-stateful-cap-sweep-after tick-4 cap-2))
     cap-1-pathway repeated-first-source-rule
     cap-2-pathway first-then-second-source-rule
     cap-effect accumulated-abundance-divergence-after-stateful-two-tick-sweep
     scientific-boundary stateful-two-tick-diagnostic-not-raf-status
     next-test longer-stateful-sweep-with-acs-scan
     emergence-claim none))

; Extend the stateful diagnostic by one more selected tick.  Tick 5 selects the
; first source rule for both caps.  Because the two-tick stateful sweep has
; already exhausted molecule A in both arms, this third tick is explicitly
; recorded as a blocked/no-op tick that advances time without inventing negative
; abundances or a RAF claim.

(= (chamber-tick-with-candidate
      (chamber $id
               (state $tick $seed
                      (mol A 0)
                      (mol B $b-count)
                      (mol C $c-count)
                      (mol AB $ab-count)
                      (mol AC $ac-count)
                      (mol BC $bc-count))
               $rules
               ($event-0 $event-1))
      (candidate $tick (rule e5r0 A B AB $catalyst) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol A 0)
                   (mol B $b-count)
                   (mol C $c-count)
                   (mol AB $ab-count)
                   (mol AC $ac-count)
                   (mol BC $bc-count))
            $rules
            ($event-0 $event-1)))

(= (exp06-stateful-cap-sweep-selected tick-5 cap-1)
   (assign-soft-biased-candidate-4
     seed-7 5 1 (exp05-source-rule) (exp05-catalyst-candidates)))

(= (exp06-stateful-cap-sweep-selected tick-5 cap-2)
   (selected-candidate-from-list-2
     (exp06-stateful-cap-sweep-after tick-4 cap-2)
     (cap-candidate-pool
       2
       (exp05-affinity-candidate-pool-2 seed-7 5 1))))

(= (exp06-stateful-cap-sweep-after tick-5 cap-1)
   (chamber-tick-with-candidate
     (exp06-stateful-cap-sweep-after tick-4 cap-1)
     (exp06-stateful-cap-sweep-selected tick-5 cap-1)))

(= (exp06-stateful-cap-sweep-after tick-5 cap-2)
   (chamber-tick-with-candidate
     (exp06-stateful-cap-sweep-after tick-4 cap-2)
     (exp06-stateful-cap-sweep-selected tick-5 cap-2)))

(= (exp06-candidate-cap-stateful-three-tick-sweep)
   (candidate-cap-stateful-three-tick-sweep
     ticks (3 4 5)
     caps (cap-1 cap-2)
     selected-candidates ((exp06-stateful-cap-sweep-selected tick-3 cap-1)
                          (exp06-stateful-cap-sweep-selected tick-3 cap-2)
                          (exp06-stateful-cap-sweep-selected tick-4 cap-1)
                          (exp06-stateful-cap-sweep-selected tick-4 cap-2)
                          (exp06-stateful-cap-sweep-selected tick-5 cap-1)
                          (exp06-stateful-cap-sweep-selected tick-5 cap-2))
     final-chambers ((exp06-stateful-cap-sweep-after tick-5 cap-1)
                     (exp06-stateful-cap-sweep-after tick-5 cap-2))
     tick-5-result blocked-by-a-exhaustion-in-both-arms
     cap-effect divergence-persists-through-bounded-blocked-tick
     scientific-boundary three-tick-stateful-diagnostic-not-raf-status
     next-test attach-acs-scan-boundary-to-stateful-sweep
     emergence-claim none))

; Protected-release / anti-precedence placeholder as a testable bias contract,
; not an implemented terminal-forcing policy.
(= (exp06-protected-release-bias-contract)
   (protected-release-bias
     value-relative anti-precedence
     penalize over-dominant-pathway-families
     protect shared-catalytic-machinery
     terminal-condition not-fixed
     evaluation compare-unguided-vs-biased-dynamics
     emergence-claim none))

(= (exp06-scaffold-status)
   (exp06-status bridge-to-acs-favorable-conditions
                 initial-soup verified-no-acs
                 terminal-soup exp04-raf-rich
                 path-search deterministic-shortest-path-scaffold
                 host-role bookkeeping-only
                 chemistry-kernel petta-native
                 emergence-claim none))
