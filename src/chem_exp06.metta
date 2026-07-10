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
