!(import! &self /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem-v3-speedup/src/chem_neutral_raf.metta)
!(import! &self /home/openclaw/research-agent/projects/petta-chem/repos/petta-chem-v3-speedup/src/chem_neutral_ssa.metta)
; Reachability known-answer canary (negative-no-events) on the NEW (speedup) source.
; Mirrors neutral-ssa-run-calibration-row step for step (RAF detection ->
; rule ids -> neutral-ssa-run-selected-raf-endpoints), with the only harness
; difference that reactions/catalysis are hand-made instead of generated
; from (L, graph-seed, f).  Frozen batch scalars: V=100, burn-in 100.0,
; bin width 10.0, 40 bins, threshold 32; event bound / T as stated.
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
               (canary-result label negative-no-events
                 maximal-raf-rule-ids $raf-rule-ids
                 closure (neutral-raf-closure $food $raf-reactions)
                 endpoints
                   (neutral-ssa-run-selected-raf-endpoints
                     0 $dynamics-seed 0
                     $event-count $time-limit
                     $food $molecules $reactions $volume
                     100.0 10.0 40 32
                     $catalysis $raf-reactions $raf-rule-ids)))))))))
!(canary-row 2001 0 500.0 100)
