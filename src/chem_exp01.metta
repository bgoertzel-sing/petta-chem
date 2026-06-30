; exp01 planted ACS recovery scaffold.
;
; This file keeps the chemistry/ACS logic in PeTTa.  The first exp01 target is
; intentionally tiny and conservative: a planted two-rule catalytic set is
; embedded beside distractor reactions, recovered by exact structural closure
; checks, and subjected to an ablation productivity-drop test.
;
; Atom conventions added here:
;   (acs-candidate <id> <rules> <products> <catalysts> <status>)
;   (ablation <acs-id> <removed-rule-id> <baseline> <ablated> <drop>)
;   (productivity-trace <id> <replayed-traces>)
;
; The scanner remains deliberately conservative: for now an active ACS/RAF-like
; pair requires reciprocal product-as-catalyst closure between two rules.  The
; scan keeps rejected pairs explicit so fixture tests can prove distractors and
; non-catalytic cycles are inspected, not silently ignored.

!(import! &self chem_exp00.metta)

; ----- exp01 atom accessors -----

(= (make-acs-candidate $id $rules $products $catalysts $status)
   (acs-candidate $id $rules $products $catalysts $status))

(= (acs-id (acs-candidate $id $rules $products $catalysts $status))
   $id)

(= (acs-rules (acs-candidate $id $rules $products $catalysts $status))
   $rules)

(= (acs-products (acs-candidate $id $rules $products $catalysts $status))
   $products)

(= (acs-catalysts (acs-candidate $id $rules $products $catalysts $status))
   $catalysts)

(= (acs-status (acs-candidate $id $rules $products $catalysts $status))
   $status)

(= (make-ablation $acs-id $removed-rule-id $baseline $ablated)
   (ablation $acs-id
             $removed-rule-id
             $baseline
             $ablated
             (- $baseline $ablated)))

(= (ablation-drop (ablation $acs-id $removed-rule-id $baseline $ablated $drop))
   $drop)

(= (make-productivity-trace $id $traces)
   (productivity-trace $id $traces))

(= (productivity-trace-id (productivity-trace $id $traces))
   $id)

(= (productivity-trace-traces (productivity-trace $id $traces))
   $traces)

(= (productivity-trace-count (productivity-trace $id ()))
   0)

(= (productivity-trace-count (productivity-trace $id ($trace-0)))
   1)

(= (productivity-trace-count (productivity-trace $id ($trace-0 $trace-1)))
   2)

(= (make-productivity-trace-1 $id $trace-0)
   (make-productivity-trace $id ($trace-0)))

(= (make-productivity-trace-2 $id $trace-0 $trace-1)
   (make-productivity-trace $id ($trace-0 $trace-1)))

(= (rule-productivity-trace
      $id
      (rule $rule-id $a $b $product $catalyst)
      (state $tick $seed
             (mol $a $a-count)
             (mol $b $b-count)
             (mol $product $product-count)
             (mol $catalyst $catalyst-count)))
   (make-productivity-trace-1
     $id
     (trace
       (state (+ $tick 1) $seed
              (mol $a (- $a-count 1))
              (mol $b (- $b-count 1))
              (mol $product (+ $product-count 1))
              (mol $catalyst $catalyst-count))
       (event $tick $rule-id $a $b $product $catalyst))))

(= (acs-productivity-trace-2
      $id
      (rule $rule-id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (state $tick-0 $seed-0
             (mol $a-0 $a-count-0)
             (mol $b-0 $b-count-0)
             (mol $product-0 $product-count-0)
             (mol $catalyst-0 $catalyst-count-0))
      (rule $rule-id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (state $tick-1 $seed-1
             (mol $a-1 $a-count-1)
             (mol $b-1 $b-count-1)
             (mol $product-1 $product-count-1)
             (mol $catalyst-1 $catalyst-count-1)))
   (make-productivity-trace-2
     $id
     (trace
       (state (+ $tick-0 1) $seed-0
              (mol $a-0 (- $a-count-0 1))
              (mol $b-0 (- $b-count-0 1))
              (mol $product-0 (+ $product-count-0 1))
              (mol $catalyst-0 $catalyst-count-0))
       (event $tick-0 $rule-id-0 $a-0 $b-0 $product-0 $catalyst-0))
     (trace
       (state (+ $tick-1 1) $seed-1
              (mol $a-1 (- $a-count-1 1))
              (mol $b-1 (- $b-count-1 1))
              (mol $product-1 (+ $product-count-1 1))
              (mol $catalyst-1 $catalyst-count-1))
       (event $tick-1 $rule-id-1 $a-1 $b-1 $product-1 $catalyst-1))))

(= (ablate-productivity-trace-2
      $id
      $removed-rule-id
      (rule $rule-id-0 $a-0 $b-0 $product-0 $catalyst-0)
      $state-0
      $rule-1
      $state-1)
   (if (== $removed-rule-id $rule-id-0)
       (rule-productivity-trace $id $rule-1 $state-1)
       (rule-productivity-trace
         $id
         (rule $rule-id-0 $a-0 $b-0 $product-0 $catalyst-0)
         $state-0)))

(= (trace-productivity-ablation $acs-id $removed-rule-id $baseline-trace $ablated-trace)
   (make-ablation $acs-id
                  $removed-rule-id
                  (productivity-trace-count $baseline-trace)
                  (productivity-trace-count $ablated-trace)))

(= (product-catalyst-closed-2?
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1))
   (and (== $product-0 $catalyst-1)
        (== $product-1 $catalyst-0)))

(= (non-catalytic-cycle-2?
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1))
   (and (== $product-0 $a-1)
        (== $product-1 $a-0)))

(= (useful-acs-2?
      $rule-0
      $rule-1)
   (product-catalyst-closed-2? $rule-0 $rule-1))

(= (acs-status-for-pair $rule-0 $rule-1)
   (if (useful-acs-2? $rule-0 $rule-1)
       active
       rejected))

(= (scan-rule-pair $id
                   (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
                   (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1))
   (make-acs-candidate
     $id
     ((rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1))
     ($product-0 $product-1)
     ($catalyst-0 $catalyst-1)
     (acs-status-for-pair
       (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
       (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1))))

(= (candidate-rule-set-closed-2? ($rule-0 $rule-1))
   (useful-acs-2? $rule-0 $rule-1))

(= (scan-rule-set-2 $id ($rule-0 $rule-1))
   (scan-rule-pair $id $rule-0 $rule-1))

(= (scan-rule-pairs-4 ($rule-0 $rule-1 $rule-2 $rule-3))
   ((scan-rule-pair pair-0-1 $rule-0 $rule-1)
    (scan-rule-pair pair-0-2 $rule-0 $rule-2)
    (scan-rule-pair pair-0-3 $rule-0 $rule-3)
    (scan-rule-pair pair-1-2 $rule-1 $rule-2)
    (scan-rule-pair pair-1-3 $rule-1 $rule-3)
    (scan-rule-pair pair-2-3 $rule-2 $rule-3)))

(= (productive-rule-count-2 $rule-0 $rule-1)
   (if (useful-acs-2? $rule-0 $rule-1)
       2
       0))

(= (ablated-productivity-count-2 $removed-rule-id $rule-0 $rule-1)
   (if (useful-acs-2? $rule-0 $rule-1)
       1
       0))

(= (ablation-productivity-drop-2 $removed-rule-id $rule-0 $rule-1)
   (make-ablation exp01-planted
                  $removed-rule-id
                  (productive-rule-count-2 $rule-0 $rule-1)
                  (ablated-productivity-count-2 $removed-rule-id $rule-0 $rule-1)))

; ----- planted ACS fixture with distractors -----

(= (exp01-planted-rule rp0)
   (rule rp0 Food X Y Z))

(= (exp01-planted-rule rp1)
   (rule rp1 Food W Z Y))

(= (exp01-distractor-rule rd0)
   (rule rd0 Food X Waste W))

(= (exp01-distractor-rule rd1)
   (rule rd1 Waste X Food W))

(= (exp01-noncatalytic-cycle-rule rc0)
   (rule rc0 Food X W Cat))

(= (exp01-noncatalytic-cycle-rule rc1)
   (rule rc1 W X Food Cat))

(= (exp01-rules-with-distractors)
   ((exp01-distractor-rule rd0)
    (exp01-planted-rule rp0)
    (exp01-distractor-rule rd1)
    (exp01-planted-rule rp1)))

(= (recover-exp01-planted-acs
      ($rule-0 $rule-1 $rule-2 $rule-3))
   (scan-rule-pair exp01-planted $rule-1 $rule-3))

(= (exp01-scanned-pairs)
   (scan-rule-pairs-4 (exp01-rules-with-distractors)))

(= (exp01-recovered-acs)
   (recover-exp01-planted-acs (exp01-rules-with-distractors)))

(= (exp01-recovered-rules)
   (acs-rules (exp01-recovered-acs)))

(= (exp01-planted-closure-ok?)
   (product-catalyst-closed-2?
     (exp01-planted-rule rp0)
     (exp01-planted-rule rp1)))

(= (exp01-distractor-pair-rejected?)
   (== (useful-acs-2?
         (exp01-distractor-rule rd0)
         (exp01-distractor-rule rd1))
       False))

(= (exp01-noncatalytic-cycle-rejected?)
   (and (non-catalytic-cycle-2?
          (exp01-noncatalytic-cycle-rule rc0)
          (exp01-noncatalytic-cycle-rule rc1))
        (== (useful-acs-2?
              (exp01-noncatalytic-cycle-rule rc0)
              (exp01-noncatalytic-cycle-rule rc1))
            False)))

(= (exp01-rp0-replay-state)
   (state 0 seed-7 (mol Food 2) (mol X 1) (mol Y 0) (mol Z 1)))

(= (exp01-rp1-replay-state)
   (state 1 seed-7 (mol Food 1) (mol W 1) (mol Z 0) (mol Y 1)))

(= (exp01-baseline-productivity-trace)
   (acs-productivity-trace-2
     exp01-planted-baseline
     (exp01-planted-rule rp0)
     (exp01-rp0-replay-state)
     (exp01-planted-rule rp1)
     (exp01-rp1-replay-state)))

(= (exp01-ablate-rp0-productivity-trace)
   (ablate-productivity-trace-2
     exp01-planted-ablate-rp0
     rp0
     (exp01-planted-rule rp0)
     (exp01-rp0-replay-state)
     (exp01-planted-rule rp1)
     (exp01-rp1-replay-state)))

(= (exp01-baseline-productivity)
   (productivity-trace-count (exp01-baseline-productivity-trace)))

(= (exp01-ablate-rp0)
   (trace-productivity-ablation
     exp01-planted
     rp0
     (exp01-baseline-productivity-trace)
     (exp01-ablate-rp0-productivity-trace)))

(= (exp01-ablation-drop-positive?)
   (> (ablation-drop (exp01-ablate-rp0)) 0))
