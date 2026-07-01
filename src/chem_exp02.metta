; exp02 small random polymer sweep scaffold.
;
; This first exp02 slice keeps the chemistry/ACS logic PeTTa-native while
; recording a tiny deterministic sweep in the run-contract atom shape.  It is
; not an emergence claim: one seed-derived polymer rule set is compared against
; shuffled-catalyst and no-catalysis controls so the control plumbing, ACS scan,
; metrics, and replayable run records are testable before larger sweeps.

; Load chem_exp01.metta and run_contract.metta before this file in smoke tests or
; harnesses; direct relative imports are intentionally left to callers because
; PeTTa resolves nested imports relative to the top-level runnable.

; ----- exp02 random-polymer/control fixture -----

(= (exp02-random-polymer-rule seed-7 rr0)
   (rule rr0 P0 P1 P01 P10))

(= (exp02-random-polymer-rule seed-7 rr1)
   (rule rr1 P2 P3 P10 P01))

(= (exp02-random-polymer-rule seed-7 rr2)
   (rule rr2 P0 P3 P03 P2))

(= (exp02-random-polymer-rule seed-7 rr3)
   (rule rr3 P1 P2 P12 P0))

(= (exp02-random-polymer-rules seed-7)
   ((exp02-random-polymer-rule seed-7 rr0)
    (exp02-random-polymer-rule seed-7 rr1)
    (exp02-random-polymer-rule seed-7 rr2)
    (exp02-random-polymer-rule seed-7 rr3)))

(= (exp02-shuffled-control-rule seed-7 sr0)
   (rule sr0 P0 P1 P01 P2))

(= (exp02-shuffled-control-rule seed-7 sr1)
   (rule sr1 P2 P3 P10 P0))

(= (exp02-shuffled-control-rule seed-7 sr2)
   (rule sr2 P0 P3 P03 P10))

(= (exp02-shuffled-control-rule seed-7 sr3)
   (rule sr3 P1 P2 P12 P3))

(= (exp02-shuffled-control-rules seed-7)
   ((exp02-shuffled-control-rule seed-7 sr0)
    (exp02-shuffled-control-rule seed-7 sr1)
    (exp02-shuffled-control-rule seed-7 sr2)
    (exp02-shuffled-control-rule seed-7 sr3)))

(= (exp02-no-catalysis-control-rule seed-7 nr0)
   (rule nr0 P0 P1 P01 None))

(= (exp02-no-catalysis-control-rule seed-7 nr1)
   (rule nr1 P2 P3 P10 None))

(= (exp02-no-catalysis-control-rule seed-7 nr2)
   (rule nr2 P0 P3 P03 None))

(= (exp02-no-catalysis-control-rule seed-7 nr3)
   (rule nr3 P1 P2 P12 None))

(= (exp02-no-catalysis-control-rules seed-7)
   ((exp02-no-catalysis-control-rule seed-7 nr0)
    (exp02-no-catalysis-control-rule seed-7 nr1)
    (exp02-no-catalysis-control-rule seed-7 nr2)
    (exp02-no-catalysis-control-rule seed-7 nr3)))

(= (exp02-scan-rules ($rule-0 $rule-1 $rule-2 $rule-3))
   (scan-rule-pairs-4 ($rule-0 $rule-1 $rule-2 $rule-3)))

(= (active-acs-count-6
      ((acs-candidate $id-0 $rules-0 $products-0 $catalysts-0 $status-0)
       (acs-candidate $id-1 $rules-1 $products-1 $catalysts-1 $status-1)
       (acs-candidate $id-2 $rules-2 $products-2 $catalysts-2 $status-2)
       (acs-candidate $id-3 $rules-3 $products-3 $catalysts-3 $status-3)
       (acs-candidate $id-4 $rules-4 $products-4 $catalysts-4 $status-4)
       (acs-candidate $id-5 $rules-5 $products-5 $catalysts-5 $status-5)))
   (+ (if (== $status-0 active) 1 0)
      (+ (if (== $status-1 active) 1 0)
         (+ (if (== $status-2 active) 1 0)
            (+ (if (== $status-3 active) 1 0)
               (+ (if (== $status-4 active) 1 0)
                  (if (== $status-5 active) 1 0)))))))

(= (exp02-active-acs-count $acs-candidates)
   (active-acs-count-6 $acs-candidates))

(= (exp02-random-acs-candidates seed-7)
   (exp02-scan-rules (exp02-random-polymer-rules seed-7)))

(= (exp02-shuffled-acs-candidates seed-7)
   (exp02-scan-rules (exp02-shuffled-control-rules seed-7)))

(= (exp02-no-catalysis-acs-candidates seed-7)
   (exp02-scan-rules (exp02-no-catalysis-control-rules seed-7)))

(= (exp02-random-active-count seed-7)
   (exp02-active-acs-count (exp02-random-acs-candidates seed-7)))

(= (exp02-shuffled-active-count seed-7)
   (exp02-active-acs-count (exp02-shuffled-acs-candidates seed-7)))

(= (exp02-no-catalysis-active-count seed-7)
   (exp02-active-acs-count (exp02-no-catalysis-acs-candidates seed-7)))

(= (exp02-small-sweep-discriminates?)
   (and (> (exp02-random-active-count seed-7)
           (exp02-shuffled-active-count seed-7))
        (> (exp02-random-active-count seed-7)
           (exp02-no-catalysis-active-count seed-7))))

; ----- run contract records for the tiny sweep -----

(= (exp02-run-config random)
   (make-run-config exp02-small-random exp02 (seed-7) 1 (candidate-cap 4 1) random-polymer))

(= (exp02-run-config shuffled)
   (make-run-config exp02-small-shuffled exp02 (seed-7) 1 (candidate-cap 4 1) shuffled-catalysts))

(= (exp02-run-config no-catalysis)
   (make-run-config exp02-small-no-catalysis exp02 (seed-7) 1 (candidate-cap 4 1) no-catalysis))

(= (exp02-run-manifest random)
   (make-run-manifest exp02-small-random config-hash-exp02-small-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest shuffled)
   (make-run-manifest exp02-small-shuffled config-hash-exp02-small-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest no-catalysis)
   (make-run-manifest exp02-small-no-catalysis config-hash-exp02-small-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-initial-abundances)
   ((make-abundance-snapshot
      0
      ((mol P0 2) (mol P1 1) (mol P2 1) (mol P3 1) (mol P01 0) (mol P10 1)))))

(= (exp02-events random)
   ((event 0 rr0 P0 P1 P01 P10)
    (event 1 rr1 P2 P3 P10 P01)))

(= (exp02-events shuffled)
   ())

(= (exp02-events no-catalysis)
   ())

(= (exp02-metrics random)
   ((metric active-acs-count exp02-small-random (exp02-random-active-count seed-7))
    (metric control-family exp02-small-random random-polymer)))

(= (exp02-metrics shuffled)
   ((metric active-acs-count exp02-small-shuffled (exp02-shuffled-active-count seed-7))
    (metric control-family exp02-small-shuffled shuffled-catalysts)))

(= (exp02-metrics no-catalysis)
   ((metric active-acs-count exp02-small-no-catalysis (exp02-no-catalysis-active-count seed-7))
    (metric control-family exp02-small-no-catalysis no-catalysis)))

(= (exp02-run-summary random)
   (make-run-summary exp02-small-random passed seed-7-random-has-one-active-pair True))

(= (exp02-run-summary shuffled)
   (make-run-summary exp02-small-shuffled passed shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary no-catalysis)
   (make-run-summary exp02-small-no-catalysis passed no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record random)
   (make-run-record
     exp02-small-random
     (exp02-run-config random)
     (exp02-run-manifest random)
     (exp02-events random)
     (exp02-initial-abundances)
     (exp02-metrics random)
     (exp02-random-acs-candidates seed-7)
     ()
     (exp02-run-summary random)))

(= (exp02-run-record shuffled)
   (make-run-record
     exp02-small-shuffled
     (exp02-run-config shuffled)
     (exp02-run-manifest shuffled)
     (exp02-events shuffled)
     (exp02-initial-abundances)
     (exp02-metrics shuffled)
     (exp02-shuffled-acs-candidates seed-7)
     ()
     (exp02-run-summary shuffled)))

(= (exp02-run-record no-catalysis)
   (make-run-record
     exp02-small-no-catalysis
     (exp02-run-config no-catalysis)
     (exp02-run-manifest no-catalysis)
     (exp02-events no-catalysis)
     (exp02-initial-abundances)
     (exp02-metrics no-catalysis)
     (exp02-no-catalysis-acs-candidates seed-7)
     ()
     (exp02-run-summary no-catalysis)))

(= (exp02-run-records)
   ((exp02-run-record random)
    (exp02-run-record shuffled)
    (exp02-run-record no-catalysis)))

(= (exp02-small-sweep-complete?)
   (and (run-record-passed? (exp02-run-record random))
        (and (run-record-passed? (exp02-run-record shuffled))
             (and (run-record-passed? (exp02-run-record no-catalysis))
                  (exp02-small-sweep-discriminates?)))))

; ----- second exp02 parameter point: different seed and rule count -----
;
; This extends the sweep beyond the original seed-7/four-rule fixture while
; keeping the same conservative reciprocal product-as-catalyst ACS criterion.
; seed-11 uses six generated rules, with two planted-by-seed reciprocal pairs
; and two distractors; shuffled/no-catalysis controls should still recover zero
; active pairs.

(= (exp02-random-polymer-rule seed-11 rr0)
   (rule rr0 Q0 Q1 Q01 Q10))

(= (exp02-random-polymer-rule seed-11 rr1)
   (rule rr1 Q2 Q3 Q10 Q01))

(= (exp02-random-polymer-rule seed-11 rr2)
   (rule rr2 Q4 Q5 Q45 Q54))

(= (exp02-random-polymer-rule seed-11 rr3)
   (rule rr3 Q6 Q7 Q54 Q45))

(= (exp02-random-polymer-rule seed-11 rr4)
   (rule rr4 Q0 Q5 Q05 Q2))

(= (exp02-random-polymer-rule seed-11 rr5)
   (rule rr5 Q1 Q6 Q16 Q3))

(= (exp02-random-polymer-rules seed-11)
   ((exp02-random-polymer-rule seed-11 rr0)
    (exp02-random-polymer-rule seed-11 rr1)
    (exp02-random-polymer-rule seed-11 rr2)
    (exp02-random-polymer-rule seed-11 rr3)
    (exp02-random-polymer-rule seed-11 rr4)
    (exp02-random-polymer-rule seed-11 rr5)))

(= (exp02-shuffled-control-rule seed-11 sr0)
   (rule sr0 Q0 Q1 Q01 Q2))

(= (exp02-shuffled-control-rule seed-11 sr1)
   (rule sr1 Q2 Q3 Q10 Q4))

(= (exp02-shuffled-control-rule seed-11 sr2)
   (rule sr2 Q4 Q5 Q45 Q6))

(= (exp02-shuffled-control-rule seed-11 sr3)
   (rule sr3 Q6 Q7 Q54 Q0))

(= (exp02-shuffled-control-rule seed-11 sr4)
   (rule sr4 Q0 Q5 Q05 Q10))

(= (exp02-shuffled-control-rule seed-11 sr5)
   (rule sr5 Q1 Q6 Q16 Q54))

(= (exp02-shuffled-control-rules seed-11)
   ((exp02-shuffled-control-rule seed-11 sr0)
    (exp02-shuffled-control-rule seed-11 sr1)
    (exp02-shuffled-control-rule seed-11 sr2)
    (exp02-shuffled-control-rule seed-11 sr3)
    (exp02-shuffled-control-rule seed-11 sr4)
    (exp02-shuffled-control-rule seed-11 sr5)))

(= (exp02-no-catalysis-control-rule seed-11 nr0)
   (rule nr0 Q0 Q1 Q01 None))

(= (exp02-no-catalysis-control-rule seed-11 nr1)
   (rule nr1 Q2 Q3 Q10 None))

(= (exp02-no-catalysis-control-rule seed-11 nr2)
   (rule nr2 Q4 Q5 Q45 None))

(= (exp02-no-catalysis-control-rule seed-11 nr3)
   (rule nr3 Q6 Q7 Q54 None))

(= (exp02-no-catalysis-control-rule seed-11 nr4)
   (rule nr4 Q0 Q5 Q05 None))

(= (exp02-no-catalysis-control-rule seed-11 nr5)
   (rule nr5 Q1 Q6 Q16 None))

(= (exp02-no-catalysis-control-rules seed-11)
   ((exp02-no-catalysis-control-rule seed-11 nr0)
    (exp02-no-catalysis-control-rule seed-11 nr1)
    (exp02-no-catalysis-control-rule seed-11 nr2)
    (exp02-no-catalysis-control-rule seed-11 nr3)
    (exp02-no-catalysis-control-rule seed-11 nr4)
    (exp02-no-catalysis-control-rule seed-11 nr5)))

(= (exp02-scan-rules-6 ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5))
   ((scan-rule-pair pair-0-1 $rule-0 $rule-1)
    (scan-rule-pair pair-0-2 $rule-0 $rule-2)
    (scan-rule-pair pair-0-3 $rule-0 $rule-3)
    (scan-rule-pair pair-0-4 $rule-0 $rule-4)
    (scan-rule-pair pair-0-5 $rule-0 $rule-5)
    (scan-rule-pair pair-1-2 $rule-1 $rule-2)
    (scan-rule-pair pair-1-3 $rule-1 $rule-3)
    (scan-rule-pair pair-1-4 $rule-1 $rule-4)
    (scan-rule-pair pair-1-5 $rule-1 $rule-5)
    (scan-rule-pair pair-2-3 $rule-2 $rule-3)
    (scan-rule-pair pair-2-4 $rule-2 $rule-4)
    (scan-rule-pair pair-2-5 $rule-2 $rule-5)
    (scan-rule-pair pair-3-4 $rule-3 $rule-4)
    (scan-rule-pair pair-3-5 $rule-3 $rule-5)
    (scan-rule-pair pair-4-5 $rule-4 $rule-5)))

(= (active-acs-count-15
      ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4
       $candidate-5 $candidate-6 $candidate-7 $candidate-8 $candidate-9
       $candidate-10 $candidate-11 $candidate-12 $candidate-13 $candidate-14))
   (+ (if (== (acs-status $candidate-0) active) 1 0)
      (+ (if (== (acs-status $candidate-1) active) 1 0)
         (+ (if (== (acs-status $candidate-2) active) 1 0)
            (+ (if (== (acs-status $candidate-3) active) 1 0)
               (+ (if (== (acs-status $candidate-4) active) 1 0)
                  (+ (if (== (acs-status $candidate-5) active) 1 0)
                     (+ (if (== (acs-status $candidate-6) active) 1 0)
                        (+ (if (== (acs-status $candidate-7) active) 1 0)
                           (+ (if (== (acs-status $candidate-8) active) 1 0)
                              (+ (if (== (acs-status $candidate-9) active) 1 0)
                                 (+ (if (== (acs-status $candidate-10) active) 1 0)
                                    (+ (if (== (acs-status $candidate-11) active) 1 0)
                                       (+ (if (== (acs-status $candidate-12) active) 1 0)
                                          (+ (if (== (acs-status $candidate-13) active) 1 0)
                                             (if (== (acs-status $candidate-14) active) 1 0))))))))))))))))

(= (exp02-random-acs-candidates-6 seed-11)
   (exp02-scan-rules-6 (exp02-random-polymer-rules seed-11)))

(= (exp02-shuffled-acs-candidates-6 seed-11)
   (exp02-scan-rules-6 (exp02-shuffled-control-rules seed-11)))

(= (exp02-no-catalysis-acs-candidates-6 seed-11)
   (exp02-scan-rules-6 (exp02-no-catalysis-control-rules seed-11)))

(= (exp02-random-active-count-6 seed-11)
   (active-acs-count-15 (exp02-random-acs-candidates-6 seed-11)))

(= (exp02-shuffled-active-count-6 seed-11)
   (active-acs-count-15 (exp02-shuffled-acs-candidates-6 seed-11)))

(= (exp02-no-catalysis-active-count-6 seed-11)
   (active-acs-count-15 (exp02-no-catalysis-acs-candidates-6 seed-11)))

(= (exp02-seed-11-sweep-discriminates?)
   (and (> (exp02-random-active-count-6 seed-11)
           (exp02-shuffled-active-count-6 seed-11))
        (> (exp02-random-active-count-6 seed-11)
           (exp02-no-catalysis-active-count-6 seed-11))))

(= (exp02-run-config seed-11-random)
   (make-run-config exp02-seed-11-rules-6-random exp02 (seed-11) 1 (candidate-cap 6 1) random-polymer))

(= (exp02-run-config seed-11-shuffled)
   (make-run-config exp02-seed-11-rules-6-shuffled exp02 (seed-11) 1 (candidate-cap 6 1) shuffled-catalysts))

(= (exp02-run-config seed-11-no-catalysis)
   (make-run-config exp02-seed-11-rules-6-no-catalysis exp02 (seed-11) 1 (candidate-cap 6 1) no-catalysis))

(= (exp02-run-manifest seed-11-random)
   (make-run-manifest exp02-seed-11-rules-6-random config-hash-exp02-seed-11-rules-6-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-11-shuffled)
   (make-run-manifest exp02-seed-11-rules-6-shuffled config-hash-exp02-seed-11-rules-6-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-11-no-catalysis)
   (make-run-manifest exp02-seed-11-rules-6-no-catalysis config-hash-exp02-seed-11-rules-6-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-11-random)
   ((metric active-acs-count exp02-seed-11-rules-6-random (exp02-random-active-count-6 seed-11))
    (metric control-family exp02-seed-11-rules-6-random random-polymer)
    (metric rule-count exp02-seed-11-rules-6-random 6)))

(= (exp02-metrics seed-11-shuffled)
   ((metric active-acs-count exp02-seed-11-rules-6-shuffled (exp02-shuffled-active-count-6 seed-11))
    (metric control-family exp02-seed-11-rules-6-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-11-rules-6-shuffled 6)))

(= (exp02-metrics seed-11-no-catalysis)
   ((metric active-acs-count exp02-seed-11-rules-6-no-catalysis (exp02-no-catalysis-active-count-6 seed-11))
    (metric control-family exp02-seed-11-rules-6-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-11-rules-6-no-catalysis 6)))

(= (exp02-run-summary seed-11-random)
   (make-run-summary exp02-seed-11-rules-6-random passed seed-11-rules-6-random-has-two-active-pairs True))

(= (exp02-run-summary seed-11-shuffled)
   (make-run-summary exp02-seed-11-rules-6-shuffled passed seed-11-rules-6-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-11-no-catalysis)
   (make-run-summary exp02-seed-11-rules-6-no-catalysis passed seed-11-rules-6-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-11-random)
   (make-run-record
     exp02-seed-11-rules-6-random
     (exp02-run-config seed-11-random)
     (exp02-run-manifest seed-11-random)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-11-random)
     (exp02-random-acs-candidates-6 seed-11)
     ()
     (exp02-run-summary seed-11-random)))

(= (exp02-run-record seed-11-shuffled)
   (make-run-record
     exp02-seed-11-rules-6-shuffled
     (exp02-run-config seed-11-shuffled)
     (exp02-run-manifest seed-11-shuffled)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-11-shuffled)
     (exp02-shuffled-acs-candidates-6 seed-11)
     ()
     (exp02-run-summary seed-11-shuffled)))

(= (exp02-run-record seed-11-no-catalysis)
   (make-run-record
     exp02-seed-11-rules-6-no-catalysis
     (exp02-run-config seed-11-no-catalysis)
     (exp02-run-manifest seed-11-no-catalysis)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-11-no-catalysis)
     (exp02-no-catalysis-acs-candidates-6 seed-11)
     ()
     (exp02-run-summary seed-11-no-catalysis)))

(= (exp02-parameterized-run-records)
   ((exp02-run-record random)
    (exp02-run-record shuffled)
    (exp02-run-record no-catalysis)
    (exp02-run-record seed-11-random)
    (exp02-run-record seed-11-shuffled)
    (exp02-run-record seed-11-no-catalysis)))

(= (exp02-parameterized-sweep-complete?)
   (and (exp02-small-sweep-complete?)
        (and (run-record-passed? (exp02-run-record seed-11-random))
             (and (run-record-passed? (exp02-run-record seed-11-shuffled))
                  (and (run-record-passed? (exp02-run-record seed-11-no-catalysis))
                       (exp02-seed-11-sweep-discriminates?))))))


; ----- third exp02 parameter point: component-generated eight-rule family -----
;
; seed-13 broadens exp02 with eight rules constructed through PeTTa-side rule
; component functions rather than spelling each full rule separately. The random
; family contains two reciprocal product-as-catalyst pairs plus four distractors;
; shuffled/no-catalysis controls keep the same reactant/product scaffold while
; changing only catalysts.

(= (exp02-seed-13-reactant-a rr0) R0)
(= (exp02-seed-13-reactant-a rr1) R2)
(= (exp02-seed-13-reactant-a rr2) R4)
(= (exp02-seed-13-reactant-a rr3) R6)
(= (exp02-seed-13-reactant-a rr4) R8)
(= (exp02-seed-13-reactant-a rr5) R0)
(= (exp02-seed-13-reactant-a rr6) R1)
(= (exp02-seed-13-reactant-a rr7) R2)

(= (exp02-seed-13-reactant-b rr0) R1)
(= (exp02-seed-13-reactant-b rr1) R3)
(= (exp02-seed-13-reactant-b rr2) R5)
(= (exp02-seed-13-reactant-b rr3) R7)
(= (exp02-seed-13-reactant-b rr4) R9)
(= (exp02-seed-13-reactant-b rr5) R5)
(= (exp02-seed-13-reactant-b rr6) R6)
(= (exp02-seed-13-reactant-b rr7) R7)

(= (exp02-seed-13-product rr0) R01)
(= (exp02-seed-13-product rr1) R10)
(= (exp02-seed-13-product rr2) R45)
(= (exp02-seed-13-product rr3) R54)
(= (exp02-seed-13-product rr4) R89)
(= (exp02-seed-13-product rr5) R05)
(= (exp02-seed-13-product rr6) R16)
(= (exp02-seed-13-product rr7) R27)

(= (exp02-seed-13-catalyst random-polymer rr0) R10)
(= (exp02-seed-13-catalyst random-polymer rr1) R01)
(= (exp02-seed-13-catalyst random-polymer rr2) R54)
(= (exp02-seed-13-catalyst random-polymer rr3) R45)
(= (exp02-seed-13-catalyst random-polymer rr4) R2)
(= (exp02-seed-13-catalyst random-polymer rr5) R3)
(= (exp02-seed-13-catalyst random-polymer rr6) R5)
(= (exp02-seed-13-catalyst random-polymer rr7) R9)

(= (exp02-seed-13-catalyst shuffled-catalysts rr0) R2)
(= (exp02-seed-13-catalyst shuffled-catalysts rr1) R4)
(= (exp02-seed-13-catalyst shuffled-catalysts rr2) R6)
(= (exp02-seed-13-catalyst shuffled-catalysts rr3) R8)
(= (exp02-seed-13-catalyst shuffled-catalysts rr4) R10)
(= (exp02-seed-13-catalyst shuffled-catalysts rr5) R01)
(= (exp02-seed-13-catalyst shuffled-catalysts rr6) R45)
(= (exp02-seed-13-catalyst shuffled-catalysts rr7) R54)

(= (exp02-seed-13-catalyst no-catalysis rr0) None)
(= (exp02-seed-13-catalyst no-catalysis rr1) None)
(= (exp02-seed-13-catalyst no-catalysis rr2) None)
(= (exp02-seed-13-catalyst no-catalysis rr3) None)
(= (exp02-seed-13-catalyst no-catalysis rr4) None)
(= (exp02-seed-13-catalyst no-catalysis rr5) None)
(= (exp02-seed-13-catalyst no-catalysis rr6) None)
(= (exp02-seed-13-catalyst no-catalysis rr7) None)

(= (exp02-seed-13-rule $family $rule-id)
   (rule $rule-id
         (exp02-seed-13-reactant-a $rule-id)
         (exp02-seed-13-reactant-b $rule-id)
         (exp02-seed-13-product $rule-id)
         (exp02-seed-13-catalyst $family $rule-id)))

(= (exp02-seed-13-rules $family)
   ((exp02-seed-13-rule $family rr0)
    (exp02-seed-13-rule $family rr1)
    (exp02-seed-13-rule $family rr2)
    (exp02-seed-13-rule $family rr3)
    (exp02-seed-13-rule $family rr4)
    (exp02-seed-13-rule $family rr5)
    (exp02-seed-13-rule $family rr6)
    (exp02-seed-13-rule $family rr7)))
(= (exp02-scan-rules-8 ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7))
   (
(scan-rule-pair pair-0-1 $rule-0 $rule-1)
    (scan-rule-pair pair-0-2 $rule-0 $rule-2)
    (scan-rule-pair pair-0-3 $rule-0 $rule-3)
    (scan-rule-pair pair-0-4 $rule-0 $rule-4)
    (scan-rule-pair pair-0-5 $rule-0 $rule-5)
    (scan-rule-pair pair-0-6 $rule-0 $rule-6)
    (scan-rule-pair pair-0-7 $rule-0 $rule-7)
    (scan-rule-pair pair-1-2 $rule-1 $rule-2)
    (scan-rule-pair pair-1-3 $rule-1 $rule-3)
    (scan-rule-pair pair-1-4 $rule-1 $rule-4)
    (scan-rule-pair pair-1-5 $rule-1 $rule-5)
    (scan-rule-pair pair-1-6 $rule-1 $rule-6)
    (scan-rule-pair pair-1-7 $rule-1 $rule-7)
    (scan-rule-pair pair-2-3 $rule-2 $rule-3)
    (scan-rule-pair pair-2-4 $rule-2 $rule-4)
    (scan-rule-pair pair-2-5 $rule-2 $rule-5)
    (scan-rule-pair pair-2-6 $rule-2 $rule-6)
    (scan-rule-pair pair-2-7 $rule-2 $rule-7)
    (scan-rule-pair pair-3-4 $rule-3 $rule-4)
    (scan-rule-pair pair-3-5 $rule-3 $rule-5)
    (scan-rule-pair pair-3-6 $rule-3 $rule-6)
    (scan-rule-pair pair-3-7 $rule-3 $rule-7)
    (scan-rule-pair pair-4-5 $rule-4 $rule-5)
    (scan-rule-pair pair-4-6 $rule-4 $rule-6)
    (scan-rule-pair pair-4-7 $rule-4 $rule-7)
    (scan-rule-pair pair-5-6 $rule-5 $rule-6)
    (scan-rule-pair pair-5-7 $rule-5 $rule-7)
    (scan-rule-pair pair-6-7 $rule-6 $rule-7)))

(= (active-acs-count-28 ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7 $candidate-8 $candidate-9 $candidate-10 $candidate-11 $candidate-12 $candidate-13 $candidate-14 $candidate-15 $candidate-16 $candidate-17 $candidate-18 $candidate-19 $candidate-20 $candidate-21 $candidate-22 $candidate-23 $candidate-24 $candidate-25 $candidate-26 $candidate-27))
   (+ (if (== (acs-status $candidate-0) active) 1 0)
   (+ (if (== (acs-status $candidate-1) active) 1 0)
   (+ (if (== (acs-status $candidate-2) active) 1 0)
   (+ (if (== (acs-status $candidate-3) active) 1 0)
   (+ (if (== (acs-status $candidate-4) active) 1 0)
   (+ (if (== (acs-status $candidate-5) active) 1 0)
   (+ (if (== (acs-status $candidate-6) active) 1 0)
   (+ (if (== (acs-status $candidate-7) active) 1 0)
   (+ (if (== (acs-status $candidate-8) active) 1 0)
   (+ (if (== (acs-status $candidate-9) active) 1 0)
   (+ (if (== (acs-status $candidate-10) active) 1 0)
   (+ (if (== (acs-status $candidate-11) active) 1 0)
   (+ (if (== (acs-status $candidate-12) active) 1 0)
   (+ (if (== (acs-status $candidate-13) active) 1 0)
   (+ (if (== (acs-status $candidate-14) active) 1 0)
   (+ (if (== (acs-status $candidate-15) active) 1 0)
   (+ (if (== (acs-status $candidate-16) active) 1 0)
   (+ (if (== (acs-status $candidate-17) active) 1 0)
   (+ (if (== (acs-status $candidate-18) active) 1 0)
   (+ (if (== (acs-status $candidate-19) active) 1 0)
   (+ (if (== (acs-status $candidate-20) active) 1 0)
   (+ (if (== (acs-status $candidate-21) active) 1 0)
   (+ (if (== (acs-status $candidate-22) active) 1 0)
   (+ (if (== (acs-status $candidate-23) active) 1 0)
   (+ (if (== (acs-status $candidate-24) active) 1 0)
   (+ (if (== (acs-status $candidate-25) active) 1 0)
   (+ (if (== (acs-status $candidate-26) active) 1 0)
   (if (== (acs-status $candidate-27) active) 1 0)))))))))))))))))))))))))))))

(= (exp02-seed-13-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-seed-13-rules $family)))

(= (exp02-seed-13-active-count $family)
   (active-acs-count-28 (exp02-seed-13-acs-candidates $family)))

(= (exp02-seed-13-sweep-discriminates?)
   (and (> (exp02-seed-13-active-count random-polymer)
           (exp02-seed-13-active-count shuffled-catalysts))
        (> (exp02-seed-13-active-count random-polymer)
           (exp02-seed-13-active-count no-catalysis))))

(= (exp02-run-config seed-13-random)
   (make-run-config exp02-seed-13-rules-8-random exp02 (seed-13) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-13-shuffled)
   (make-run-config exp02-seed-13-rules-8-shuffled exp02 (seed-13) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-13-no-catalysis)
   (make-run-config exp02-seed-13-rules-8-no-catalysis exp02 (seed-13) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-13-random)
   (make-run-manifest exp02-seed-13-rules-8-random config-hash-exp02-seed-13-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-13-shuffled)
   (make-run-manifest exp02-seed-13-rules-8-shuffled config-hash-exp02-seed-13-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-13-no-catalysis)
   (make-run-manifest exp02-seed-13-rules-8-no-catalysis config-hash-exp02-seed-13-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-13-random)
   ((metric active-acs-count exp02-seed-13-rules-8-random (exp02-seed-13-active-count random-polymer))
    (metric control-family exp02-seed-13-rules-8-random random-polymer)
    (metric rule-count exp02-seed-13-rules-8-random 8)))

(= (exp02-metrics seed-13-shuffled)
   ((metric active-acs-count exp02-seed-13-rules-8-shuffled (exp02-seed-13-active-count shuffled-catalysts))
    (metric control-family exp02-seed-13-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-13-rules-8-shuffled 8)))

(= (exp02-metrics seed-13-no-catalysis)
   ((metric active-acs-count exp02-seed-13-rules-8-no-catalysis (exp02-seed-13-active-count no-catalysis))
    (metric control-family exp02-seed-13-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-13-rules-8-no-catalysis 8)))

(= (exp02-run-summary seed-13-random)
   (make-run-summary exp02-seed-13-rules-8-random passed seed-13-rules-8-random-has-two-active-pairs True))

(= (exp02-run-summary seed-13-shuffled)
   (make-run-summary exp02-seed-13-rules-8-shuffled passed seed-13-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-13-no-catalysis)
   (make-run-summary exp02-seed-13-rules-8-no-catalysis passed seed-13-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-13-random)
   (make-run-record
     exp02-seed-13-rules-8-random
     (exp02-run-config seed-13-random)
     (exp02-run-manifest seed-13-random)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-13-random)
     (exp02-seed-13-acs-candidates random-polymer)
     ()
     (exp02-run-summary seed-13-random)))

(= (exp02-run-record seed-13-shuffled)
   (make-run-record
     exp02-seed-13-rules-8-shuffled
     (exp02-run-config seed-13-shuffled)
     (exp02-run-manifest seed-13-shuffled)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-13-shuffled)
     (exp02-seed-13-acs-candidates shuffled-catalysts)
     ()
     (exp02-run-summary seed-13-shuffled)))

(= (exp02-run-record seed-13-no-catalysis)
   (make-run-record
     exp02-seed-13-rules-8-no-catalysis
     (exp02-run-config seed-13-no-catalysis)
     (exp02-run-manifest seed-13-no-catalysis)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-13-no-catalysis)
     (exp02-seed-13-acs-candidates no-catalysis)
     ()
     (exp02-run-summary seed-13-no-catalysis)))

(= (exp02-broadened-run-records)
   ((exp02-run-record random)
    (exp02-run-record shuffled)
    (exp02-run-record no-catalysis)
    (exp02-run-record seed-11-random)
    (exp02-run-record seed-11-shuffled)
    (exp02-run-record seed-11-no-catalysis)
    (exp02-run-record seed-13-random)
    (exp02-run-record seed-13-shuffled)
    (exp02-run-record seed-13-no-catalysis)))

(= (exp02-broadened-sweep-complete?)
   (and (exp02-parameterized-sweep-complete?)
        (and (run-record-passed? (exp02-run-record seed-13-random))
             (and (run-record-passed? (exp02-run-record seed-13-shuffled))
                  (and (run-record-passed? (exp02-run-record seed-13-no-catalysis))
                       (exp02-seed-13-sweep-discriminates?))))))
