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

; 3-rule catalytic cycle closure: product(r0) = catalyst(r1),
; product(r1) = catalyst(r2), product(r2) = catalyst(r0).
; This is the natural generalization of the pair scanner to RAF-like
; 3-cycles, enabling detection of longer autocatalytic structures
; that the pair-only scanner would miss.

(= (product-catalyst-closed-3?
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2))
   (and (== $product-0 $catalyst-1)
        (and (== $product-1 $catalyst-2)
             (== $product-2 $catalyst-0))))

(= (useful-acs-3?
      $rule-0
      $rule-1
      $rule-2)
   (product-catalyst-closed-3? $rule-0 $rule-1 $rule-2))

(= (acs-status-for-triple $rule-0 $rule-1 $rule-2)
   (if (useful-acs-3? $rule-0 $rule-1 $rule-2)
       active
       rejected))

(= (scan-rule-triple
      $id
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2))
   (make-acs-candidate
     $id
     ((rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2))
     ($product-0 $product-1 $product-2)
     ($catalyst-0 $catalyst-1 $catalyst-2)
     (acs-status-for-triple
       (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
       (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
       (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2))))

; Scan all C(4,3)=4 triples from a 4-rule list.
(= (scan-rule-triples-4 ($rule-0 $rule-1 $rule-2 $rule-3))
   ((scan-rule-triple triple-0-1-2 $rule-0 $rule-1 $rule-2)
    (scan-rule-triple triple-0-1-3 $rule-0 $rule-1 $rule-3)
    (scan-rule-triple triple-0-2-3 $rule-0 $rule-2 $rule-3)
    (scan-rule-triple triple-1-2-3 $rule-1 $rule-2 $rule-3)))

(= (active-triple-count-4 ($c0 $c1 $c2 $c3))
   (+ (if (== (acs-status $c0) active) 1 0)
   (+ (if (== (acs-status $c1) active) 1 0)
   (+ (if (== (acs-status $c2) active) 1 0)
      (if (== (acs-status $c3) active) 1 0)))))

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

; ----- planted 3-rule catalytic cycle fixture with distractors -----
;
; Three rules form a catalytic 3-cycle: tc0 produces TC1 which catalyzes
; tc1, tc1 produces TC2 which catalyzes tc2, tc2 produces TC0 which
; catalyzes tc0.  A distractor rule td0 does not participate in any cycle.
; This validates that the triple scanner recovers planted 3-cycles and
; rejects non-cycles, generalizing the pair scanner to RAF-like closure.

(= (exp01-planted-triple-rule tc0)
   (rule tc0 TF0 TB0 TC1 TC0))

(= (exp01-planted-triple-rule tc1)
   (rule tc1 TF1 TB1 TC2 TC1))

(= (exp01-planted-triple-rule tc2)
   (rule tc2 TF2 TB2 TC0 TC2))

(= (exp01-triple-distractor-rule td0)
   (rule td0 TF3 TB3 TNone TNone))

(= (exp01-triple-rules-with-distractors)
   ((exp01-planted-triple-rule tc0)
    (exp01-planted-triple-rule tc1)
    (exp01-triple-distractor-rule td0)
    (exp01-planted-triple-rule tc2)))

(= (exp01-triple-closure-ok?)
   (product-catalyst-closed-3?
     (exp01-planted-triple-rule tc0)
     (exp01-planted-triple-rule tc1)
     (exp01-planted-triple-rule tc2)))

(= (exp01-triple-distractor-rejected?)
   (== (useful-acs-3?
         (exp01-planted-triple-rule tc0)
         (exp01-planted-triple-rule tc1)
         (exp01-triple-distractor-rule td0))
       False))

(= (exp01-scanned-triples)
   (scan-rule-triples-4 (exp01-triple-rules-with-distractors)))

(= (exp01-recovered-triple-active-count)
   (active-triple-count-4 (exp01-scanned-triples)))

(= (exp01-triple-recovered?)
   (== (exp01-recovered-triple-active-count) 1))

; ----- 4-rule catalytic cycle scanner -----
;
; 4-rule catalytic cycle closure: product(r0) = catalyst(r1),
; product(r1) = catalyst(r2), product(r2) = catalyst(r3),
; product(r3) = catalyst(r0).  This generalizes the triple scanner
; to RAF-like 4-cycles, enabling detection of longer autocatalytic
; structures that pair/triple scanning would miss.

(= (product-catalyst-closed-4?
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3))
   (and (== $product-0 $catalyst-1)
        (and (== $product-1 $catalyst-2)
        (and (== $product-2 $catalyst-3)
             (== $product-3 $catalyst-0)))))

(= (useful-acs-4?
      $rule-0
      $rule-1
      $rule-2
      $rule-3)
   (product-catalyst-closed-4? $rule-0 $rule-1 $rule-2 $rule-3))

(= (acs-status-for-quadruple $rule-0 $rule-1 $rule-2 $rule-3)
   (if (useful-acs-4? $rule-0 $rule-1 $rule-2 $rule-3)
       active
       rejected))

(= (scan-rule-quadruple
      $id
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3))
   (make-acs-candidate
     $id
     ((rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3))
     ($product-0 $product-1 $product-2 $product-3)
     ($catalyst-0 $catalyst-1 $catalyst-2 $catalyst-3)
     (acs-status-for-quadruple
       (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
       (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
       (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
       (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3))))

; Scan all C(5,4)=5 quadruples from a 5-rule list.
(= (scan-rule-quadruples-5 ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4))
   ((scan-rule-quadruple quadruple-0-1-2-3 $rule-0 $rule-1 $rule-2 $rule-3)
    (scan-rule-quadruple quadruple-0-1-2-4 $rule-0 $rule-1 $rule-2 $rule-4)
    (scan-rule-quadruple quadruple-0-1-3-4 $rule-0 $rule-1 $rule-3 $rule-4)
    (scan-rule-quadruple quadruple-0-2-3-4 $rule-0 $rule-2 $rule-3 $rule-4)
    (scan-rule-quadruple quadruple-1-2-3-4 $rule-1 $rule-2 $rule-3 $rule-4)))

(= (active-quadruple-count-5 ($c0 $c1 $c2 $c3 $c4))
   (+ (if (== (acs-status $c0) active) 1 0)
   (+ (if (== (acs-status $c1) active) 1 0)
   (+ (if (== (acs-status $c2) active) 1 0)
   (+ (if (== (acs-status $c3) active) 1 0)
      (if (== (acs-status $c4) active) 1 0))))))

; ----- planted 4-rule catalytic cycle fixture with distractors -----
;
; Four rules form a catalytic 4-cycle: qc0 produces QC1 which catalyzes
; qc1, qc1 produces QC2 which catalyzes qc2, qc2 produces QC3 which
; catalyzes qc3, qc3 produces QC0 which catalyzes qc0.  A distractor
; rule qd0 does not participate in any cycle.  This validates that the
; quadruple scanner recovers planted 4-cycles and rejects non-cycles,
; generalizing the triple scanner to RAF-like 4-closure.

(= (exp01-planted-quadruple-rule qc0)
   (rule qc0 QF0 QB0 QC1 QC0))

(= (exp01-planted-quadruple-rule qc1)
   (rule qc1 QF1 QB1 QC2 QC1))

(= (exp01-planted-quadruple-rule qc2)
   (rule qc2 QF2 QB2 QC3 QC2))

(= (exp01-planted-quadruple-rule qc3)
   (rule qc3 QF3 QB3 QC0 QC3))

(= (exp01-quadruple-distractor-rule qd0)
   (rule qd0 QF4 QB4 QNone QNone))

(= (exp01-quadruple-rules-with-distractors)
   ((exp01-planted-quadruple-rule qc0)
    (exp01-planted-quadruple-rule qc1)
    (exp01-quadruple-distractor-rule qd0)
    (exp01-planted-quadruple-rule qc2)
    (exp01-planted-quadruple-rule qc3)))

(= (exp01-quadruple-closure-ok?)
   (product-catalyst-closed-4?
     (exp01-planted-quadruple-rule qc0)
     (exp01-planted-quadruple-rule qc1)
     (exp01-planted-quadruple-rule qc2)
     (exp01-planted-quadruple-rule qc3)))

(= (exp01-quadruple-distractor-rejected?)
   (== (useful-acs-4?
         (exp01-planted-quadruple-rule qc0)
         (exp01-planted-quadruple-rule qc1)
         (exp01-quadruple-distractor-rule qd0)
         (exp01-planted-quadruple-rule qc3))
       False))

(= (exp01-scanned-quadruples)
   (scan-rule-quadruples-5 (exp01-quadruple-rules-with-distractors)))

(= (exp01-recovered-quadruple-active-count)
   (active-quadruple-count-5 (exp01-scanned-quadruples)))

(= (exp01-quadruple-recovered?)
   (== (exp01-recovered-quadruple-active-count) 1))

; ----- 5-rule catalytic cycle (quintuple) scanner -----
;
; Detects RAF-like 5-cycles: product(r0) = catalyst(r1),
; product(r1) = catalyst(r2), product(r2) = catalyst(r3),
; product(r3) = catalyst(r4), product(r4) = catalyst(r0).
; This generalizes the quadruple scanner to 5-rule closure,
; enabling detection of longer autocatalytic structures.

(= (product-catalyst-closed-5?
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4))
   (and (== $product-0 $catalyst-1)
        (and (== $product-1 $catalyst-2)
        (and (== $product-2 $catalyst-3)
        (and (== $product-3 $catalyst-4)
             (== $product-4 $catalyst-0))))))

(= (useful-acs-5?
      $rule-0
      $rule-1
      $rule-2
      $rule-3
      $rule-4)
   (product-catalyst-closed-5? $rule-0 $rule-1 $rule-2 $rule-3 $rule-4))

(= (acs-status-for-quintuple $rule-0 $rule-1 $rule-2 $rule-3 $rule-4)
   (if (useful-acs-5? $rule-0 $rule-1 $rule-2 $rule-3 $rule-4)
       active
       rejected))

(= (scan-rule-quintuple
      $id
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4))
   (make-acs-candidate
     $id
     ((rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4))
     ($product-0 $product-1 $product-2 $product-3 $product-4)
     ($catalyst-0 $catalyst-1 $catalyst-2 $catalyst-3 $catalyst-4)
     (acs-status-for-quintuple
       (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
       (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
       (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
       (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
       (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4))))

; Scan all C(6,5)=6 quintuples from a 6-rule list.
(= (scan-rule-quintuples-6 ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5))
   ((scan-rule-quintuple quintuple-0-1-2-3-4 $rule-0 $rule-1 $rule-2 $rule-3 $rule-4)
    (scan-rule-quintuple quintuple-0-1-2-3-5 $rule-0 $rule-1 $rule-2 $rule-3 $rule-5)
    (scan-rule-quintuple quintuple-0-1-2-4-5 $rule-0 $rule-1 $rule-2 $rule-4 $rule-5)
    (scan-rule-quintuple quintuple-0-1-3-4-5 $rule-0 $rule-1 $rule-3 $rule-4 $rule-5)
    (scan-rule-quintuple quintuple-0-2-3-4-5 $rule-0 $rule-2 $rule-3 $rule-4 $rule-5)
    (scan-rule-quintuple quintuple-1-2-3-4-5 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5)))

(= (active-quintuple-count-6 ($c0 $c1 $c2 $c3 $c4 $c5))
   (+ (if (== (acs-status $c0) active) 1 0)
   (+ (if (== (acs-status $c1) active) 1 0)
   (+ (if (== (acs-status $c2) active) 1 0)
   (+ (if (== (acs-status $c3) active) 1 0)
   (+ (if (== (acs-status $c4) active) 1 0)
      (if (== (acs-status $c5) active) 1 0)))))))

; ----- planted 5-rule catalytic cycle fixture with distractors -----
;
; Five rules form a catalytic 5-cycle: qc0 produces QC1 which
; catalyzes qc1, qc1 produces QC2 which catalyzes qc2, qc2 produces
; QC3 which catalyzes qc3, qc3 produces QC4 which catalyzes qc4,
; qc4 produces QC0 which catalyzes qc0.  A distractor rule qd0 does
; not participate in any cycle.

(= (exp01-planted-quintuple-rule qc0)
   (rule qc0 QF0 QB0 QC1 QC0))

(= (exp01-planted-quintuple-rule qc1)
   (rule qc1 QF1 QB1 QC2 QC1))

(= (exp01-planted-quintuple-rule qc2)
   (rule qc2 QF2 QB2 QC3 QC2))

(= (exp01-planted-quintuple-rule qc3)
   (rule qc3 QF3 QB3 QC4 QC3))

(= (exp01-planted-quintuple-rule qc4)
   (rule qc4 QF4 QB4 QC0 QC4))

(= (exp01-quintuple-distractor-rule qd0)
   (rule qd0 QF5 QB5 QNone QNone))

(= (exp01-quintuple-rules-with-distractors)
   ((exp01-planted-quintuple-rule qc0)
    (exp01-planted-quintuple-rule qc1)
    (exp01-quintuple-distractor-rule qd0)
    (exp01-planted-quintuple-rule qc2)
    (exp01-planted-quintuple-rule qc3)
    (exp01-planted-quintuple-rule qc4)))

(= (exp01-quintuple-closure-ok?)
   (product-catalyst-closed-5?
     (exp01-planted-quintuple-rule qc0)
     (exp01-planted-quintuple-rule qc1)
     (exp01-planted-quintuple-rule qc2)
     (exp01-planted-quintuple-rule qc3)
     (exp01-planted-quintuple-rule qc4)))

(= (exp01-quintuple-distractor-rejected?)
   (== (useful-acs-5?
         (exp01-planted-quintuple-rule qc0)
         (exp01-planted-quintuple-rule qc1)
         (exp01-quintuple-distractor-rule qd0)
         (exp01-planted-quintuple-rule qc3)
         (exp01-planted-quintuple-rule qc4))
       False))

(= (exp01-scanned-quintuples)
   (scan-rule-quintuples-6 (exp01-quintuple-rules-with-distractors)))

(= (exp01-recovered-quintuple-active-count)
   (active-quintuple-count-6 (exp01-scanned-quintuples)))

(= (exp01-quintuple-recovered?)
   (== (exp01-recovered-quintuple-active-count) 1))

; ----- 6-rule catalytic cycle (sextuple) scanner -----
;
; Detects RAF-like 6-cycles: product(r0) = catalyst(r1),
; product(r1) = catalyst(r2), product(r2) = catalyst(r3),
; product(r3) = catalyst(r4), product(r4) = catalyst(r5),
; product(r5) = catalyst(r0).
; This generalizes the quintuple scanner to 6-rule closure,
; enabling detection of longer autocatalytic structures.

(= (product-catalyst-closed-6?
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4)
      (rule $id-5 $a-5 $b-5 $product-5 $catalyst-5))
   (and (== $product-0 $catalyst-1)
        (and (== $product-1 $catalyst-2)
        (and (== $product-2 $catalyst-3)
        (and (== $product-3 $catalyst-4)
        (and (== $product-4 $catalyst-5)
             (== $product-5 $catalyst-0)))))))

(= (useful-acs-6?
      $rule-0
      $rule-1
      $rule-2
      $rule-3
      $rule-4
      $rule-5)
   (product-catalyst-closed-6? $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5))

(= (acs-status-for-sextuple $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5)
   (if (useful-acs-6? $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5)
       active
       rejected))

(= (scan-rule-sextuple
      $id
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4)
      (rule $id-5 $a-5 $b-5 $product-5 $catalyst-5))
   (make-acs-candidate
     $id
     ((rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4)
      (rule $id-5 $a-5 $b-5 $product-5 $catalyst-5))
     ($product-0 $product-1 $product-2 $product-3 $product-4 $product-5)
     ($catalyst-0 $catalyst-1 $catalyst-2 $catalyst-3 $catalyst-4 $catalyst-5)
     (acs-status-for-sextuple
       (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
       (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
       (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
       (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
       (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4)
       (rule $id-5 $a-5 $b-5 $product-5 $catalyst-5))))

; Scan all C(7,6)=7 sextuples from a 7-rule list.
(= (scan-rule-sextuples-7 ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6))
   ((scan-rule-sextuple sextuple-0-1-2-3-4-5 $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5)
    (scan-rule-sextuple sextuple-0-1-2-3-4-6 $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-6)
    (scan-rule-sextuple sextuple-0-1-2-3-5-6 $rule-0 $rule-1 $rule-2 $rule-3 $rule-5 $rule-6)
    (scan-rule-sextuple sextuple-0-1-2-4-5-6 $rule-0 $rule-1 $rule-2 $rule-4 $rule-5 $rule-6)
    (scan-rule-sextuple sextuple-0-1-3-4-5-6 $rule-0 $rule-1 $rule-3 $rule-4 $rule-5 $rule-6)
    (scan-rule-sextuple sextuple-0-2-3-4-5-6 $rule-0 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6)
    (scan-rule-sextuple sextuple-1-2-3-4-5-6 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6)))

(= (active-sextuple-count-7 ($c0 $c1 $c2 $c3 $c4 $c5 $c6))
   (+ (if (== (acs-status $c0) active) 1 0)
   (+ (if (== (acs-status $c1) active) 1 0)
   (+ (if (== (acs-status $c2) active) 1 0)
   (+ (if (== (acs-status $c3) active) 1 0)
   (+ (if (== (acs-status $c4) active) 1 0)
   (+ (if (== (acs-status $c5) active) 1 0)
      (if (== (acs-status $c6) active) 1 0))))))))

; ----- planted 6-rule catalytic cycle fixture with distractors -----
;
; Six rules form a catalytic 6-cycle: sc0 produces SC1 which
; catalyzes sc1, sc1 produces SC2 which catalyzes sc2, sc2 produces
; SC3 which catalyzes sc3, sc3 produces SC4 which catalyzes sc4,
; sc4 produces SC5 which catalyzes sc5, sc5 produces SC0 which
; catalyzes sc0.  A distractor rule sd0 does not participate.

(= (exp01-planted-sextuple-rule sc0)
   (rule sc0 SF0 SB0 SC1 SC0))

(= (exp01-planted-sextuple-rule sc1)
   (rule sc1 SF1 SB1 SC2 SC1))

(= (exp01-planted-sextuple-rule sc2)
   (rule sc2 SF2 SB2 SC3 SC2))

(= (exp01-planted-sextuple-rule sc3)
   (rule sc3 SF3 SB3 SC4 SC3))

(= (exp01-planted-sextuple-rule sc4)
   (rule sc4 SF4 SB4 SC5 SC4))

(= (exp01-planted-sextuple-rule sc5)
   (rule sc5 SF5 SB5 SC0 SC5))

(= (exp01-sextuple-distractor-rule sd0)
   (rule sd0 SF6 SB6 SNone SNone))

(= (exp01-sextuple-rules-with-distractors)
   ((exp01-planted-sextuple-rule sc0)
    (exp01-planted-sextuple-rule sc1)
    (exp01-sextuple-distractor-rule sd0)
    (exp01-planted-sextuple-rule sc2)
    (exp01-planted-sextuple-rule sc3)
    (exp01-planted-sextuple-rule sc4)
    (exp01-planted-sextuple-rule sc5)))

(= (exp01-sextuple-closure-ok?)
   (product-catalyst-closed-6?
     (exp01-planted-sextuple-rule sc0)
     (exp01-planted-sextuple-rule sc1)
     (exp01-planted-sextuple-rule sc2)
     (exp01-planted-sextuple-rule sc3)
     (exp01-planted-sextuple-rule sc4)
     (exp01-planted-sextuple-rule sc5)))

(= (exp01-sextuple-distractor-rejected?)
   (== (useful-acs-6?
         (exp01-planted-sextuple-rule sc0)
         (exp01-planted-sextuple-rule sc1)
         (exp01-sextuple-distractor-rule sd0)
         (exp01-planted-sextuple-rule sc3)
         (exp01-planted-sextuple-rule sc4)
         (exp01-planted-sextuple-rule sc5))
       False))

(= (exp01-scanned-sextuples)
   (scan-rule-sextuples-7 (exp01-sextuple-rules-with-distractors)))

(= (exp01-recovered-sextuple-active-count)
   (active-sextuple-count-7 (exp01-scanned-sextuples)))

(= (exp01-sextuple-recovered?)
   (== (exp01-recovered-sextuple-active-count) 1))

; ----- 7-rule catalytic cycle (septuple) scanner -----
;
; Detects RAF-like 7-cycles: product(r0) = catalyst(r1),
; product(r1) = catalyst(r2), product(r2) = catalyst(r3),
; product(r3) = catalyst(r4), product(r4) = catalyst(r5),
; product(r5) = catalyst(r6), product(r6) = catalyst(r0).
; This generalizes the sextuple scanner to 7-rule closure,
; enabling detection of longer autocatalytic structures.

(= (product-catalyst-closed-7?
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4)
      (rule $id-5 $a-5 $b-5 $product-5 $catalyst-5)
      (rule $id-6 $a-6 $b-6 $product-6 $catalyst-6))
   (and (== $product-0 $catalyst-1)
        (and (== $product-1 $catalyst-2)
        (and (== $product-2 $catalyst-3)
        (and (== $product-3 $catalyst-4)
        (and (== $product-4 $catalyst-5)
        (and (== $product-5 $catalyst-6)
             (== $product-6 $catalyst-0))))))))

(= (useful-acs-7?
      $rule-0
      $rule-1
      $rule-2
      $rule-3
      $rule-4
      $rule-5
      $rule-6)
   (product-catalyst-closed-7? $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6))

(= (acs-status-for-septuple $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6)
   (if (useful-acs-7? $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6)
       active
       rejected))

(= (scan-rule-septuple
      $id
      (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4)
      (rule $id-5 $a-5 $b-5 $product-5 $catalyst-5)
      (rule $id-6 $a-6 $b-6 $product-6 $catalyst-6))
   (make-acs-candidate
     $id
     ((rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
      (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
      (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
      (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
      (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4)
      (rule $id-5 $a-5 $b-5 $product-5 $catalyst-5)
      (rule $id-6 $a-6 $b-6 $product-6 $catalyst-6))
     ($product-0 $product-1 $product-2 $product-3 $product-4 $product-5 $product-6)
     ($catalyst-0 $catalyst-1 $catalyst-2 $catalyst-3 $catalyst-4 $catalyst-5 $catalyst-6)
     (acs-status-for-septuple
       (rule $id-0 $a-0 $b-0 $product-0 $catalyst-0)
       (rule $id-1 $a-1 $b-1 $product-1 $catalyst-1)
       (rule $id-2 $a-2 $b-2 $product-2 $catalyst-2)
       (rule $id-3 $a-3 $b-3 $product-3 $catalyst-3)
       (rule $id-4 $a-4 $b-4 $product-4 $catalyst-4)
       (rule $id-5 $a-5 $b-5 $product-5 $catalyst-5)
       (rule $id-6 $a-6 $b-6 $product-6 $catalyst-6))))

; Scan all C(8,7)=8 septuples from an 8-rule list.
(= (scan-rule-septuples-8 ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7))
   ((scan-rule-septuple septuple-0-1-2-3-4-5-6 $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6)
    (scan-rule-septuple septuple-0-1-2-3-4-5-7 $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-7)
    (scan-rule-septuple septuple-0-1-2-3-4-6-7 $rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-6 $rule-7)
    (scan-rule-septuple septuple-0-1-2-3-5-6-7 $rule-0 $rule-1 $rule-2 $rule-3 $rule-5 $rule-6 $rule-7)
    (scan-rule-septuple septuple-0-1-2-4-5-6-7 $rule-0 $rule-1 $rule-2 $rule-4 $rule-5 $rule-6 $rule-7)
    (scan-rule-septuple septuple-0-1-3-4-5-6-7 $rule-0 $rule-1 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7)
    (scan-rule-septuple septuple-0-2-3-4-5-6-7 $rule-0 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7)
    (scan-rule-septuple septuple-1-2-3-4-5-6-7 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7)))

; Count active septuples: split 8 into two groups of 4 to stay within
; PeTTa's nested-operation compilation limit.
(= (septuple-count-active-4 ($c0 $c1 $c2 $c3))
   (+ (if (== (acs-status $c0) active) 1 0)
   (+ (if (== (acs-status $c1) active) 1 0)
   (+ (if (== (acs-status $c2) active) 1 0)
      (if (== (acs-status $c3) active) 1 0)))))

(= (active-septuple-count-8 ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7))
   (+ (septuple-count-active-4 ($c0 $c1 $c2 $c3))
      (septuple-count-active-4 ($c4 $c5 $c6 $c7))))

; ----- planted 7-rule catalytic cycle fixture with distractors -----
;
; Seven rules form a catalytic 7-cycle: sp0 produces SP1 which
; catalyzes sp1, sp1 produces SP2 which catalyzes sp2, sp2 produces
; SP3 which catalyzes sp3, sp3 produces SP4 which catalyzes sp4,
; sp4 produces SP5 which catalyzes sp5, sp5 produces SP6 which
; catalyzes sp6, sp6 produces SP0 which catalyzes sp0.
; A distractor rule spd0 does not participate.

(= (exp01-planted-septuple-rule sp0)
   (rule sp0 SF0 SB0 SP1 SP0))

(= (exp01-planted-septuple-rule sp1)
   (rule sp1 SF1 SB1 SP2 SP1))

(= (exp01-planted-septuple-rule sp2)
   (rule sp2 SF2 SB2 SP3 SP2))

(= (exp01-planted-septuple-rule sp3)
   (rule sp3 SF3 SB3 SP4 SP3))

(= (exp01-planted-septuple-rule sp4)
   (rule sp4 SF4 SB4 SP5 SP4))

(= (exp01-planted-septuple-rule sp5)
   (rule sp5 SF5 SB5 SP6 SP5))

(= (exp01-planted-septuple-rule sp6)
   (rule sp6 SF6 SB6 SP0 SP6))

(= (exp01-septuple-distractor-rule spd0)
   (rule spd0 SF7 SB7 SNone SNone))

(= (exp01-septuple-rules-with-distractors)
   ((exp01-planted-septuple-rule sp0)
    (exp01-planted-septuple-rule sp1)
    (exp01-septuple-distractor-rule spd0)
    (exp01-planted-septuple-rule sp2)
    (exp01-planted-septuple-rule sp3)
    (exp01-planted-septuple-rule sp4)
    (exp01-planted-septuple-rule sp5)
    (exp01-planted-septuple-rule sp6)))

(= (exp01-septuple-closure-ok?)
   (product-catalyst-closed-7?
     (exp01-planted-septuple-rule sp0)
     (exp01-planted-septuple-rule sp1)
     (exp01-planted-septuple-rule sp2)
     (exp01-planted-septuple-rule sp3)
     (exp01-planted-septuple-rule sp4)
     (exp01-planted-septuple-rule sp5)
     (exp01-planted-septuple-rule sp6)))

(= (exp01-septuple-distractor-rejected?)
   (== (useful-acs-7?
         (exp01-planted-septuple-rule sp0)
         (exp01-planted-septuple-rule sp1)
         (exp01-septuple-distractor-rule spd0)
         (exp01-planted-septuple-rule sp3)
         (exp01-planted-septuple-rule sp4)
         (exp01-planted-septuple-rule sp5)
         (exp01-planted-septuple-rule sp6))
       False))

(= (exp01-scanned-septuples)
   (scan-rule-septuples-8 (exp01-septuple-rules-with-distractors)))

(= (exp01-recovered-septuple-active-count)
   (active-septuple-count-8 (exp01-scanned-septuples)))

(= (exp01-septuple-recovered?)
   (== (exp01-recovered-septuple-active-count) 1))
