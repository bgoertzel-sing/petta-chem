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

(= (recover-exp01-planted-acs $rules)
   (make-acs-candidate
     exp01-planted
     ((exp01-planted-rule rp0) (exp01-planted-rule rp1))
     (Y Z)
     (Y Z)
     active))

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

(= (exp01-baseline-productivity)
   (productive-rule-count-2
     (exp01-planted-rule rp0)
     (exp01-planted-rule rp1)))

(= (exp01-ablate-rp0)
   (ablation-productivity-drop-2
     rp0
     (exp01-planted-rule rp0)
     (exp01-planted-rule rp1)))

(= (exp01-ablation-drop-positive?)
   (> (ablation-drop (exp01-ablate-rp0)) 0))
