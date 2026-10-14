!(import! &self /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem/src/chem_neutral_raf.metta)
!(import! &self /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem/src/chem_neutral_ssa.metta)
; Reachability known-answer canary (negative-no-events) on the OLD source (6a5c0c1c).
; Same composition as old neutral-ssa-run-detected-raf-endpoints /
; neutral-ssa-run-catalysis-ablation-pair, but with the hand-made catalysis
; (the old pair function re-samples catalysis from graph-seed, so its body is
; inlined here verbatim with $catalysis given).
; Hand-made network.  Food and molecule universe are the batch ones at L4
; (food = the frozen six-food set, molecules = (neutral-ssa-binary-polymers 4));
; reactions and catalysis are hand-picked in the batch atom formats:
;   R1 lig:00:1  "00" + "1"   -> "001"   catalysed by food "0"
;   R2 lig:001:0 "001" + "0"  -> "0010"  catalysed by "001" (product of R1)
; {R1, R2} is a catalysed, food-generated RAF (closure adds "001", "0010");
; R1 has catalyst count 20 at t=0, so it fires almost immediately.
(= (canary-food) ("0" "1" "00" "01" "10" "11"))
(= (canary-reactions)
   ((ligation "lig:00:1" "00" "1" "001")
    (ligation "lig:001:0" "001" "0" "0010")))
(= (canary-catalysis) (("0" "lig:00:1") ("001" "lig:001:0")))

(= (canary-row $dynamics-seed $event-count $time-limit $volume)
   (let $food (canary-food)
     (let $molecules (neutral-ssa-binary-polymers 4)
       (let $reactions (canary-reactions)
         (let $catalysis (canary-catalysis)
           (let $raf-reactions
             (neutral-raf-maximal-reactions
               $food
               (neutral-ssa-raf-reactions $reactions)
               (neutral-ssa-raf-catalysis $catalysis))
             (let $raf-rule-ids (neutral-raf-reaction-ids $raf-reactions)
               (let $closure-molecules (neutral-raf-closure $food $raf-reactions)
                 (let $persistence-molecules
                   (neutral-ssa-raf-catalyst-molecules
                     $catalysis $raf-rule-ids $closure-molecules
                     (neutral-ssa-raf-reactant-molecules $raf-reactions ()))
                   (let $ablated-catalysis
                     (neutral-ssa-delete-catalysis-into $raf-rule-ids $catalysis)
                     (let $pair
                       (neutral-catalysis-ablation-pair
                         model neutral-crs-v1
                         graph-seed 0
                         dynamics-seed $dynamics-seed
                         raf-rule-ids $raf-rule-ids
                         baseline-catalysis $catalysis
                         ablated-catalysis $ablated-catalysis
                         baseline
                           (neutral-ssa-run-until
                             $dynamics-seed $event-count $time-limit
                             $food $molecules $reactions $volume $catalysis
                             (neutral-ssa-initial-counts $molecules $food $volume))
                         ablated
                           (neutral-ssa-run-until
                             $dynamics-seed $event-count $time-limit
                             $food $molecules $reactions $volume $ablated-catalysis
                             (neutral-ssa-initial-counts $molecules $food $volume)))
                       (canary-result label negative-no-events
                         maximal-raf-rule-ids $raf-rule-ids
                         closure $closure-molecules
                         endpoints
                           (neutral-ssa-ablation-pair-endpoints
                             $pair
                             (neutral-ssa-initial-counts $molecules $food $volume)
                             $food $raf-rule-ids $persistence-molecules $closure-molecules
                             100.0 $time-limit 10.0 40 32)))))))))))))
!(canary-row 2001 0 500.0 100)
