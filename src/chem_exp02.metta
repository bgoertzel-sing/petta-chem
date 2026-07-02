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

; ----- fourth exp02 parameter point: seed-to-component generation seam -----
;
; seed-17 introduces a less fixture-like PeTTa-side generation seam.  The seed
; maps to compact `rule-components` atoms, and all three families are generated
; through the same component-to-rule function before ACS scanning.  This is
; still a deterministic smoke sweep, not an emergence claim.

(= (make-exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst)
   (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))

(= (exp02-rule-components-seed
      (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))
   $seed)

(= (exp02-rule-components-id
      (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))
   $rule-id)

(= (exp02-rule-components-product
      (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))
   $product)

(= (exp02-seed-rule-components seed-17 rr0)
   (make-exp02-rule-components seed-17 rr0 S0 S1 S01 S10 S2))
(= (exp02-seed-rule-components seed-17 rr1)
   (make-exp02-rule-components seed-17 rr1 S2 S3 S10 S01 S4))
(= (exp02-seed-rule-components seed-17 rr2)
   (make-exp02-rule-components seed-17 rr2 S4 S5 S45 S54 S6))
(= (exp02-seed-rule-components seed-17 rr3)
   (make-exp02-rule-components seed-17 rr3 S6 S7 S54 S45 S8))
(= (exp02-seed-rule-components seed-17 rr4)
   (make-exp02-rule-components seed-17 rr4 S8 S9 S89 S2 S10))
(= (exp02-seed-rule-components seed-17 rr5)
   (make-exp02-rule-components seed-17 rr5 S0 S5 S05 S3 S01))
(= (exp02-seed-rule-components seed-17 rr6)
   (make-exp02-rule-components seed-17 rr6 S1 S6 S16 S5 S45))
(= (exp02-seed-rule-components seed-17 rr7)
   (make-exp02-rule-components seed-17 rr7 S2 S7 S27 S9 S54))

(= (exp02-component-catalyst random-polymer
      (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))
   $random-catalyst)

(= (exp02-component-catalyst shuffled-catalysts
      (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))
   $shuffled-catalyst)

(= (exp02-component-catalyst no-catalysis
      (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))
   None)

(= (exp02-generated-rule
      $family
      (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))
   (rule $rule-id
         $a
         $b
         $product
         (exp02-component-catalyst
           $family
           (exp02-rule-components $seed $rule-id $a $b $product $random-catalyst $shuffled-catalyst))))

(= (exp02-generated-rules-8 $seed $family)
   ((exp02-generated-rule $family (exp02-seed-rule-components $seed rr0))
    (exp02-generated-rule $family (exp02-seed-rule-components $seed rr1))
    (exp02-generated-rule $family (exp02-seed-rule-components $seed rr2))
    (exp02-generated-rule $family (exp02-seed-rule-components $seed rr3))
    (exp02-generated-rule $family (exp02-seed-rule-components $seed rr4))
    (exp02-generated-rule $family (exp02-seed-rule-components $seed rr5))
    (exp02-generated-rule $family (exp02-seed-rule-components $seed rr6))
    (exp02-generated-rule $family (exp02-seed-rule-components $seed rr7))))

(= (exp02-seed-17-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-17 $family)))

(= (exp02-seed-17-active-count $family)
   (active-acs-count-28 (exp02-seed-17-acs-candidates $family)))

(= (exp02-seed-17-sweep-discriminates?)
   (and (> (exp02-seed-17-active-count random-polymer)
           (exp02-seed-17-active-count shuffled-catalysts))
        (> (exp02-seed-17-active-count random-polymer)
           (exp02-seed-17-active-count no-catalysis))))

(= (exp02-run-config seed-17-random)
   (make-run-config exp02-seed-17-rules-8-random exp02 (seed-17) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-17-shuffled)
   (make-run-config exp02-seed-17-rules-8-shuffled exp02 (seed-17) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-17-no-catalysis)
   (make-run-config exp02-seed-17-rules-8-no-catalysis exp02 (seed-17) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-17-random)
   (make-run-manifest exp02-seed-17-rules-8-random config-hash-exp02-seed-17-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-17-shuffled)
   (make-run-manifest exp02-seed-17-rules-8-shuffled config-hash-exp02-seed-17-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-17-no-catalysis)
   (make-run-manifest exp02-seed-17-rules-8-no-catalysis config-hash-exp02-seed-17-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-17-random)
   ((metric active-acs-count exp02-seed-17-rules-8-random (exp02-seed-17-active-count random-polymer))
    (metric control-family exp02-seed-17-rules-8-random random-polymer)
    (metric rule-count exp02-seed-17-rules-8-random 8)
    (metric generation-seam exp02-seed-17-rules-8-random seed-to-components)))

(= (exp02-metrics seed-17-shuffled)
   ((metric active-acs-count exp02-seed-17-rules-8-shuffled (exp02-seed-17-active-count shuffled-catalysts))
    (metric control-family exp02-seed-17-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-17-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-17-rules-8-shuffled seed-to-components)))

(= (exp02-metrics seed-17-no-catalysis)
   ((metric active-acs-count exp02-seed-17-rules-8-no-catalysis (exp02-seed-17-active-count no-catalysis))
    (metric control-family exp02-seed-17-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-17-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-17-rules-8-no-catalysis seed-to-components)))

(= (exp02-run-summary seed-17-random)
   (make-run-summary exp02-seed-17-rules-8-random passed seed-17-rules-8-random-has-two-active-pairs True))

(= (exp02-run-summary seed-17-shuffled)
   (make-run-summary exp02-seed-17-rules-8-shuffled passed seed-17-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-17-no-catalysis)
   (make-run-summary exp02-seed-17-rules-8-no-catalysis passed seed-17-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-17-random)
   (make-run-record
     exp02-seed-17-rules-8-random
     (exp02-run-config seed-17-random)
     (exp02-run-manifest seed-17-random)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-17-random)
     (exp02-seed-17-acs-candidates random-polymer)
     ()
     (exp02-run-summary seed-17-random)))

(= (exp02-run-record seed-17-shuffled)
   (make-run-record
     exp02-seed-17-rules-8-shuffled
     (exp02-run-config seed-17-shuffled)
     (exp02-run-manifest seed-17-shuffled)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-17-shuffled)
     (exp02-seed-17-acs-candidates shuffled-catalysts)
     ()
     (exp02-run-summary seed-17-shuffled)))

(= (exp02-run-record seed-17-no-catalysis)
   (make-run-record
     exp02-seed-17-rules-8-no-catalysis
     (exp02-run-config seed-17-no-catalysis)
     (exp02-run-manifest seed-17-no-catalysis)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-17-no-catalysis)
     (exp02-seed-17-acs-candidates no-catalysis)
     ()
     (exp02-run-summary seed-17-no-catalysis)))

; ----- generated non-planted control point -----
;
; seed-19 starts separating systematic generated sweeps from planted-by-seed
; reciprocal-pair controls.  It uses the same seed-to-component generator, but
; the random-polymer catalyst column is intentionally non-reciprocal, so the
; conservative pair scanner should recover zero active pairs in every family.
; This is a negative generated-control point, not a failed discriminating point.

(= (exp02-seed-rule-components seed-19 rr0)
   (make-exp02-rule-components seed-19 rr0 T0 T1 T01 T2 T3))
(= (exp02-seed-rule-components seed-19 rr1)
   (make-exp02-rule-components seed-19 rr1 T2 T3 T23 T4 T5))
(= (exp02-seed-rule-components seed-19 rr2)
   (make-exp02-rule-components seed-19 rr2 T4 T5 T45 T6 T7))
(= (exp02-seed-rule-components seed-19 rr3)
   (make-exp02-rule-components seed-19 rr3 T6 T7 T67 T8 T9))
(= (exp02-seed-rule-components seed-19 rr4)
   (make-exp02-rule-components seed-19 rr4 T8 T9 T89 T0 T1))
(= (exp02-seed-rule-components seed-19 rr5)
   (make-exp02-rule-components seed-19 rr5 T1 T4 T14 T3 T6))
(= (exp02-seed-rule-components seed-19 rr6)
   (make-exp02-rule-components seed-19 rr6 T3 T6 T36 T5 T8))
(= (exp02-seed-rule-components seed-19 rr7)
   (make-exp02-rule-components seed-19 rr7 T5 T8 T58 T7 T0))

(= (exp02-seed-19-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-19 $family)))

(= (exp02-seed-19-active-count $family)
   (active-acs-count-28 (exp02-seed-19-acs-candidates $family)))

(= (exp02-seed-19-generated-negative-control?)
   (and (== (exp02-seed-19-active-count random-polymer) 0)
        (and (== (exp02-seed-19-active-count shuffled-catalysts) 0)
             (== (exp02-seed-19-active-count no-catalysis) 0))))

(= (exp02-run-config seed-19-random)
   (make-run-config exp02-seed-19-rules-8-random exp02 (seed-19) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-19-shuffled)
   (make-run-config exp02-seed-19-rules-8-shuffled exp02 (seed-19) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-19-no-catalysis)
   (make-run-config exp02-seed-19-rules-8-no-catalysis exp02 (seed-19) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-19-random)
   (make-run-manifest exp02-seed-19-rules-8-random config-hash-exp02-seed-19-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-19-shuffled)
   (make-run-manifest exp02-seed-19-rules-8-shuffled config-hash-exp02-seed-19-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-19-no-catalysis)
   (make-run-manifest exp02-seed-19-rules-8-no-catalysis config-hash-exp02-seed-19-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-19-random)
   ((metric active-acs-count exp02-seed-19-rules-8-random (exp02-seed-19-active-count random-polymer))
    (metric control-family exp02-seed-19-rules-8-random random-polymer)
    (metric rule-count exp02-seed-19-rules-8-random 8)
    (metric generation-seam exp02-seed-19-rules-8-random seed-to-components)
    (metric sweep-kind exp02-seed-19-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-19-shuffled)
   ((metric active-acs-count exp02-seed-19-rules-8-shuffled (exp02-seed-19-active-count shuffled-catalysts))
    (metric control-family exp02-seed-19-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-19-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-19-rules-8-shuffled seed-to-components)
    (metric sweep-kind exp02-seed-19-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-19-no-catalysis)
   ((metric active-acs-count exp02-seed-19-rules-8-no-catalysis (exp02-seed-19-active-count no-catalysis))
    (metric control-family exp02-seed-19-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-19-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-19-rules-8-no-catalysis seed-to-components)
    (metric sweep-kind exp02-seed-19-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-19-random)
   (make-run-summary exp02-seed-19-rules-8-random passed seed-19-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-19-shuffled)
   (make-run-summary exp02-seed-19-rules-8-shuffled passed seed-19-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-19-no-catalysis)
   (make-run-summary exp02-seed-19-rules-8-no-catalysis passed seed-19-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-19-random)
   (make-run-record
     exp02-seed-19-rules-8-random
     (exp02-run-config seed-19-random)
     (exp02-run-manifest seed-19-random)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-19-random)
     (exp02-seed-19-acs-candidates random-polymer)
     ()
     (exp02-run-summary seed-19-random)))

(= (exp02-run-record seed-19-shuffled)
   (make-run-record
     exp02-seed-19-rules-8-shuffled
     (exp02-run-config seed-19-shuffled)
     (exp02-run-manifest seed-19-shuffled)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-19-shuffled)
     (exp02-seed-19-acs-candidates shuffled-catalysts)
     ()
     (exp02-run-summary seed-19-shuffled)))

(= (exp02-run-record seed-19-no-catalysis)
   (make-run-record
     exp02-seed-19-rules-8-no-catalysis
     (exp02-run-config seed-19-no-catalysis)
     (exp02-run-manifest seed-19-no-catalysis)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-19-no-catalysis)
     (exp02-seed-19-acs-candidates no-catalysis)
     ()
     (exp02-run-summary seed-19-no-catalysis)))


; ----- second generated non-planted control point -----
;
; seed-23 adds another generated-unplanted-control point through the same
; seed-to-component seam.  Its catalyst columns are intentionally non-reciprocal
; with respect to product columns, so all three families should scan to zero
; active reciprocal pairs.

(= (exp02-seed-rule-components seed-23 rr0)
   (make-exp02-rule-components seed-23 rr0 U0 U1 U01 U4 U5))
(= (exp02-seed-rule-components seed-23 rr1)
   (make-exp02-rule-components seed-23 rr1 U2 U3 U23 U6 U7))
(= (exp02-seed-rule-components seed-23 rr2)
   (make-exp02-rule-components seed-23 rr2 U4 U5 U45 U8 U9))
(= (exp02-seed-rule-components seed-23 rr3)
   (make-exp02-rule-components seed-23 rr3 U6 U7 U67 U0 U1))
(= (exp02-seed-rule-components seed-23 rr4)
   (make-exp02-rule-components seed-23 rr4 U8 U9 U89 U2 U3))
(= (exp02-seed-rule-components seed-23 rr5)
   (make-exp02-rule-components seed-23 rr5 U1 U4 U14 U5 U6))
(= (exp02-seed-rule-components seed-23 rr6)
   (make-exp02-rule-components seed-23 rr6 U3 U6 U36 U7 U8))
(= (exp02-seed-rule-components seed-23 rr7)
   (make-exp02-rule-components seed-23 rr7 U5 U8 U58 U9 U0))

(= (exp02-seed-23-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-23 $family)))

(= (exp02-seed-23-active-count $family)
   (active-acs-count-28 (exp02-seed-23-acs-candidates $family)))

(= (exp02-seed-23-generated-negative-control?)
   (and (== (exp02-seed-23-active-count random-polymer) 0)
        (and (== (exp02-seed-23-active-count shuffled-catalysts) 0)
             (== (exp02-seed-23-active-count no-catalysis) 0))))

(= (exp02-run-config seed-23-random)
   (make-run-config exp02-seed-23-rules-8-random exp02 (seed-23) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-23-shuffled)
   (make-run-config exp02-seed-23-rules-8-shuffled exp02 (seed-23) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-23-no-catalysis)
   (make-run-config exp02-seed-23-rules-8-no-catalysis exp02 (seed-23) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-23-random)
   (make-run-manifest exp02-seed-23-rules-8-random config-hash-exp02-seed-23-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-23-shuffled)
   (make-run-manifest exp02-seed-23-rules-8-shuffled config-hash-exp02-seed-23-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-23-no-catalysis)
   (make-run-manifest exp02-seed-23-rules-8-no-catalysis config-hash-exp02-seed-23-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-23-random)
   ((metric active-acs-count exp02-seed-23-rules-8-random (exp02-seed-23-active-count random-polymer))
    (metric control-family exp02-seed-23-rules-8-random random-polymer)
    (metric rule-count exp02-seed-23-rules-8-random 8)
    (metric generation-seam exp02-seed-23-rules-8-random seed-to-components)
    (metric sweep-kind exp02-seed-23-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-23-shuffled)
   ((metric active-acs-count exp02-seed-23-rules-8-shuffled (exp02-seed-23-active-count shuffled-catalysts))
    (metric control-family exp02-seed-23-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-23-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-23-rules-8-shuffled seed-to-components)
    (metric sweep-kind exp02-seed-23-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-23-no-catalysis)
   ((metric active-acs-count exp02-seed-23-rules-8-no-catalysis (exp02-seed-23-active-count no-catalysis))
    (metric control-family exp02-seed-23-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-23-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-23-rules-8-no-catalysis seed-to-components)
    (metric sweep-kind exp02-seed-23-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-23-random)
   (make-run-summary exp02-seed-23-rules-8-random passed seed-23-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-23-shuffled)
   (make-run-summary exp02-seed-23-rules-8-shuffled passed seed-23-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-23-no-catalysis)
   (make-run-summary exp02-seed-23-rules-8-no-catalysis passed seed-23-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-23-random)
   (make-run-record
     exp02-seed-23-rules-8-random
     (exp02-run-config seed-23-random)
     (exp02-run-manifest seed-23-random)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-23-random)
     (exp02-seed-23-acs-candidates random-polymer)
     ()
     (exp02-run-summary seed-23-random)))

(= (exp02-run-record seed-23-shuffled)
   (make-run-record
     exp02-seed-23-rules-8-shuffled
     (exp02-run-config seed-23-shuffled)
     (exp02-run-manifest seed-23-shuffled)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-23-shuffled)
     (exp02-seed-23-acs-candidates shuffled-catalysts)
     ()
     (exp02-run-summary seed-23-shuffled)))

(= (exp02-run-record seed-23-no-catalysis)
   (make-run-record
     exp02-seed-23-rules-8-no-catalysis
     (exp02-run-config seed-23-no-catalysis)
     (exp02-run-manifest seed-23-no-catalysis)
     ()
     (exp02-initial-abundances)
     (exp02-metrics seed-23-no-catalysis)
     (exp02-seed-23-acs-candidates no-catalysis)
     ()
     (exp02-run-summary seed-23-no-catalysis)))


; ----- factored generated non-planted control point -----
;
; seed-29 factors the generated-unplanted table one step further: the seed only
; supplies molecule/product symbols, while a reusable eight-rule unplanted
; template chooses reactant/product/catalyst slots.  This keeps the PeTTa kernel
; deterministic while reducing per-seed hand-authored component rows.

(= (exp02-seed-token seed-29 0) V0)
(= (exp02-seed-token seed-29 1) V1)
(= (exp02-seed-token seed-29 2) V2)
(= (exp02-seed-token seed-29 3) V3)
(= (exp02-seed-token seed-29 4) V4)
(= (exp02-seed-token seed-29 5) V5)
(= (exp02-seed-token seed-29 6) V6)
(= (exp02-seed-token seed-29 7) V7)
(= (exp02-seed-token seed-29 8) V8)
(= (exp02-seed-token seed-29 9) V9)

(= (exp02-seed-product seed-29 01) V01)
(= (exp02-seed-product seed-29 23) V23)
(= (exp02-seed-product seed-29 45) V45)
(= (exp02-seed-product seed-29 67) V67)
(= (exp02-seed-product seed-29 89) V89)
(= (exp02-seed-product seed-29 14) V14)
(= (exp02-seed-product seed-29 36) V36)
(= (exp02-seed-product seed-29 58) V58)

(= (exp02-factored-unplanted-rule-components $seed rr0)
   (make-exp02-rule-components $seed rr0 (exp02-seed-token $seed 0) (exp02-seed-token $seed 1) (exp02-seed-product $seed 01) (exp02-seed-token $seed 6) (exp02-seed-token $seed 7)))
(= (exp02-factored-unplanted-rule-components $seed rr1)
   (make-exp02-rule-components $seed rr1 (exp02-seed-token $seed 2) (exp02-seed-token $seed 3) (exp02-seed-product $seed 23) (exp02-seed-token $seed 8) (exp02-seed-token $seed 9)))
(= (exp02-factored-unplanted-rule-components $seed rr2)
   (make-exp02-rule-components $seed rr2 (exp02-seed-token $seed 4) (exp02-seed-token $seed 5) (exp02-seed-product $seed 45) (exp02-seed-token $seed 0) (exp02-seed-token $seed 1)))
(= (exp02-factored-unplanted-rule-components $seed rr3)
   (make-exp02-rule-components $seed rr3 (exp02-seed-token $seed 6) (exp02-seed-token $seed 7) (exp02-seed-product $seed 67) (exp02-seed-token $seed 2) (exp02-seed-token $seed 3)))
(= (exp02-factored-unplanted-rule-components $seed rr4)
   (make-exp02-rule-components $seed rr4 (exp02-seed-token $seed 8) (exp02-seed-token $seed 9) (exp02-seed-product $seed 89) (exp02-seed-token $seed 4) (exp02-seed-token $seed 5)))
(= (exp02-factored-unplanted-rule-components $seed rr5)
   (make-exp02-rule-components $seed rr5 (exp02-seed-token $seed 1) (exp02-seed-token $seed 4) (exp02-seed-product $seed 14) (exp02-seed-token $seed 7) (exp02-seed-token $seed 8)))
(= (exp02-factored-unplanted-rule-components $seed rr6)
   (make-exp02-rule-components $seed rr6 (exp02-seed-token $seed 3) (exp02-seed-token $seed 6) (exp02-seed-product $seed 36) (exp02-seed-token $seed 9) (exp02-seed-token $seed 0)))
(= (exp02-factored-unplanted-rule-components $seed rr7)
   (make-exp02-rule-components $seed rr7 (exp02-seed-token $seed 5) (exp02-seed-token $seed 8) (exp02-seed-product $seed 58) (exp02-seed-token $seed 1) (exp02-seed-token $seed 2)))

(= (exp02-seed-rule-components seed-29 rr0) (exp02-factored-unplanted-rule-components seed-29 rr0))
(= (exp02-seed-rule-components seed-29 rr1) (exp02-factored-unplanted-rule-components seed-29 rr1))
(= (exp02-seed-rule-components seed-29 rr2) (exp02-factored-unplanted-rule-components seed-29 rr2))
(= (exp02-seed-rule-components seed-29 rr3) (exp02-factored-unplanted-rule-components seed-29 rr3))
(= (exp02-seed-rule-components seed-29 rr4) (exp02-factored-unplanted-rule-components seed-29 rr4))
(= (exp02-seed-rule-components seed-29 rr5) (exp02-factored-unplanted-rule-components seed-29 rr5))
(= (exp02-seed-rule-components seed-29 rr6) (exp02-factored-unplanted-rule-components seed-29 rr6))
(= (exp02-seed-rule-components seed-29 rr7) (exp02-factored-unplanted-rule-components seed-29 rr7))

(= (exp02-seed-29-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-29 $family)))

(= (exp02-seed-29-active-count $family)
   (active-acs-count-28 (exp02-seed-29-acs-candidates $family)))

(= (exp02-seed-29-generated-negative-control?)
   (and (== (exp02-seed-29-active-count random-polymer) 0)
        (and (== (exp02-seed-29-active-count shuffled-catalysts) 0)
             (== (exp02-seed-29-active-count no-catalysis) 0))))

(= (exp02-run-config seed-29-random)
   (make-run-config exp02-seed-29-rules-8-random exp02 (seed-29) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-29-shuffled)
   (make-run-config exp02-seed-29-rules-8-shuffled exp02 (seed-29) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-29-no-catalysis)
   (make-run-config exp02-seed-29-rules-8-no-catalysis exp02 (seed-29) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-29-random)
   (make-run-manifest exp02-seed-29-rules-8-random config-hash-exp02-seed-29-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-29-shuffled)
   (make-run-manifest exp02-seed-29-rules-8-shuffled config-hash-exp02-seed-29-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-29-no-catalysis)
   (make-run-manifest exp02-seed-29-rules-8-no-catalysis config-hash-exp02-seed-29-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-29-random)
   ((metric active-acs-count exp02-seed-29-rules-8-random (exp02-seed-29-active-count random-polymer))
    (metric control-family exp02-seed-29-rules-8-random random-polymer)
    (metric rule-count exp02-seed-29-rules-8-random 8)
    (metric generation-seam exp02-seed-29-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-29-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-29-shuffled)
   ((metric active-acs-count exp02-seed-29-rules-8-shuffled (exp02-seed-29-active-count shuffled-catalysts))
    (metric control-family exp02-seed-29-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-29-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-29-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-29-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-29-no-catalysis)
   ((metric active-acs-count exp02-seed-29-rules-8-no-catalysis (exp02-seed-29-active-count no-catalysis))
    (metric control-family exp02-seed-29-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-29-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-29-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-29-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-29-random)
   (make-run-summary exp02-seed-29-rules-8-random passed seed-29-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-29-shuffled)
   (make-run-summary exp02-seed-29-rules-8-shuffled passed seed-29-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-29-no-catalysis)
   (make-run-summary exp02-seed-29-rules-8-no-catalysis passed seed-29-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-29-random)
   (make-run-record exp02-seed-29-rules-8-random (exp02-run-config seed-29-random) (exp02-run-manifest seed-29-random) () (exp02-initial-abundances) (exp02-metrics seed-29-random) (exp02-seed-29-acs-candidates random-polymer) () (exp02-run-summary seed-29-random)))

(= (exp02-run-record seed-29-shuffled)
   (make-run-record exp02-seed-29-rules-8-shuffled (exp02-run-config seed-29-shuffled) (exp02-run-manifest seed-29-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-29-shuffled) (exp02-seed-29-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-29-shuffled)))

(= (exp02-run-record seed-29-no-catalysis)
   (make-run-record exp02-seed-29-rules-8-no-catalysis (exp02-run-config seed-29-no-catalysis) (exp02-run-manifest seed-29-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-29-no-catalysis) (exp02-seed-29-acs-candidates no-catalysis) () (exp02-run-summary seed-29-no-catalysis)))


; seed-31 reuses the factored generated-unplanted template with a new compact
; token/product dictionary.  It adds another negative control point without
; introducing new per-rule component rows.

(= (exp02-seed-token seed-31 0) W0)
(= (exp02-seed-token seed-31 1) W1)
(= (exp02-seed-token seed-31 2) W2)
(= (exp02-seed-token seed-31 3) W3)
(= (exp02-seed-token seed-31 4) W4)
(= (exp02-seed-token seed-31 5) W5)
(= (exp02-seed-token seed-31 6) W6)
(= (exp02-seed-token seed-31 7) W7)
(= (exp02-seed-token seed-31 8) W8)
(= (exp02-seed-token seed-31 9) W9)

(= (exp02-seed-product seed-31 01) W01)
(= (exp02-seed-product seed-31 23) W23)
(= (exp02-seed-product seed-31 45) W45)
(= (exp02-seed-product seed-31 67) W67)
(= (exp02-seed-product seed-31 89) W89)
(= (exp02-seed-product seed-31 14) W14)
(= (exp02-seed-product seed-31 36) W36)
(= (exp02-seed-product seed-31 58) W58)

(= (exp02-seed-rule-components seed-31 rr0) (exp02-factored-unplanted-rule-components seed-31 rr0))
(= (exp02-seed-rule-components seed-31 rr1) (exp02-factored-unplanted-rule-components seed-31 rr1))
(= (exp02-seed-rule-components seed-31 rr2) (exp02-factored-unplanted-rule-components seed-31 rr2))
(= (exp02-seed-rule-components seed-31 rr3) (exp02-factored-unplanted-rule-components seed-31 rr3))
(= (exp02-seed-rule-components seed-31 rr4) (exp02-factored-unplanted-rule-components seed-31 rr4))
(= (exp02-seed-rule-components seed-31 rr5) (exp02-factored-unplanted-rule-components seed-31 rr5))
(= (exp02-seed-rule-components seed-31 rr6) (exp02-factored-unplanted-rule-components seed-31 rr6))
(= (exp02-seed-rule-components seed-31 rr7) (exp02-factored-unplanted-rule-components seed-31 rr7))

(= (exp02-seed-31-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-31 $family)))

(= (exp02-seed-31-active-count $family)
   (active-acs-count-28 (exp02-seed-31-acs-candidates $family)))

(= (exp02-seed-31-generated-negative-control?)
   (and (== (exp02-seed-31-active-count random-polymer) 0)
        (and (== (exp02-seed-31-active-count shuffled-catalysts) 0)
             (== (exp02-seed-31-active-count no-catalysis) 0))))

(= (exp02-run-config seed-31-random)
   (make-run-config exp02-seed-31-rules-8-random exp02 (seed-31) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-31-shuffled)
   (make-run-config exp02-seed-31-rules-8-shuffled exp02 (seed-31) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-31-no-catalysis)
   (make-run-config exp02-seed-31-rules-8-no-catalysis exp02 (seed-31) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-31-random)
   (make-run-manifest exp02-seed-31-rules-8-random config-hash-exp02-seed-31-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-31-shuffled)
   (make-run-manifest exp02-seed-31-rules-8-shuffled config-hash-exp02-seed-31-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-31-no-catalysis)
   (make-run-manifest exp02-seed-31-rules-8-no-catalysis config-hash-exp02-seed-31-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-31-random)
   ((metric active-acs-count exp02-seed-31-rules-8-random (exp02-seed-31-active-count random-polymer))
    (metric control-family exp02-seed-31-rules-8-random random-polymer)
    (metric rule-count exp02-seed-31-rules-8-random 8)
    (metric generation-seam exp02-seed-31-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-31-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-31-shuffled)
   ((metric active-acs-count exp02-seed-31-rules-8-shuffled (exp02-seed-31-active-count shuffled-catalysts))
    (metric control-family exp02-seed-31-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-31-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-31-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-31-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-31-no-catalysis)
   ((metric active-acs-count exp02-seed-31-rules-8-no-catalysis (exp02-seed-31-active-count no-catalysis))
    (metric control-family exp02-seed-31-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-31-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-31-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-31-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-31-random)
   (make-run-summary exp02-seed-31-rules-8-random passed seed-31-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-31-shuffled)
   (make-run-summary exp02-seed-31-rules-8-shuffled passed seed-31-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-31-no-catalysis)
   (make-run-summary exp02-seed-31-rules-8-no-catalysis passed seed-31-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-31-random)
   (make-run-record exp02-seed-31-rules-8-random (exp02-run-config seed-31-random) (exp02-run-manifest seed-31-random) () (exp02-initial-abundances) (exp02-metrics seed-31-random) (exp02-seed-31-acs-candidates random-polymer) () (exp02-run-summary seed-31-random)))

(= (exp02-run-record seed-31-shuffled)
   (make-run-record exp02-seed-31-rules-8-shuffled (exp02-run-config seed-31-shuffled) (exp02-run-manifest seed-31-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-31-shuffled) (exp02-seed-31-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-31-shuffled)))

(= (exp02-run-record seed-31-no-catalysis)
   (make-run-record exp02-seed-31-rules-8-no-catalysis (exp02-run-config seed-31-no-catalysis) (exp02-run-manifest seed-31-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-31-no-catalysis) (exp02-seed-31-acs-candidates no-catalysis) () (exp02-run-summary seed-31-no-catalysis)))

; seed-37 adds the next factored-template generated-unplanted point.  Only the
; compact token/product dictionary changes; candidate generation, controls, ACS
; scanning, metrics, and summaries continue through the PeTTa-side seams.

(= (exp02-seed-token seed-37 0) X0)
(= (exp02-seed-token seed-37 1) X1)
(= (exp02-seed-token seed-37 2) X2)
(= (exp02-seed-token seed-37 3) X3)
(= (exp02-seed-token seed-37 4) X4)
(= (exp02-seed-token seed-37 5) X5)
(= (exp02-seed-token seed-37 6) X6)
(= (exp02-seed-token seed-37 7) X7)
(= (exp02-seed-token seed-37 8) X8)
(= (exp02-seed-token seed-37 9) X9)

(= (exp02-seed-product seed-37 01) X01)
(= (exp02-seed-product seed-37 23) X23)
(= (exp02-seed-product seed-37 45) X45)
(= (exp02-seed-product seed-37 67) X67)
(= (exp02-seed-product seed-37 89) X89)
(= (exp02-seed-product seed-37 14) X14)
(= (exp02-seed-product seed-37 36) X36)
(= (exp02-seed-product seed-37 58) X58)

(= (exp02-seed-rule-components seed-37 rr0) (exp02-factored-unplanted-rule-components seed-37 rr0))
(= (exp02-seed-rule-components seed-37 rr1) (exp02-factored-unplanted-rule-components seed-37 rr1))
(= (exp02-seed-rule-components seed-37 rr2) (exp02-factored-unplanted-rule-components seed-37 rr2))
(= (exp02-seed-rule-components seed-37 rr3) (exp02-factored-unplanted-rule-components seed-37 rr3))
(= (exp02-seed-rule-components seed-37 rr4) (exp02-factored-unplanted-rule-components seed-37 rr4))
(= (exp02-seed-rule-components seed-37 rr5) (exp02-factored-unplanted-rule-components seed-37 rr5))
(= (exp02-seed-rule-components seed-37 rr6) (exp02-factored-unplanted-rule-components seed-37 rr6))
(= (exp02-seed-rule-components seed-37 rr7) (exp02-factored-unplanted-rule-components seed-37 rr7))

(= (exp02-seed-37-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-37 $family)))

(= (exp02-seed-37-active-count $family)
   (active-acs-count-28 (exp02-seed-37-acs-candidates $family)))

(= (exp02-seed-37-generated-negative-control?)
   (and (== (exp02-seed-37-active-count random-polymer) 0)
        (and (== (exp02-seed-37-active-count shuffled-catalysts) 0)
             (== (exp02-seed-37-active-count no-catalysis) 0))))

(= (exp02-run-config seed-37-random)
   (make-run-config exp02-seed-37-rules-8-random exp02 (seed-37) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-37-shuffled)
   (make-run-config exp02-seed-37-rules-8-shuffled exp02 (seed-37) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-37-no-catalysis)
   (make-run-config exp02-seed-37-rules-8-no-catalysis exp02 (seed-37) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-37-random)
   (make-run-manifest exp02-seed-37-rules-8-random config-hash-exp02-seed-37-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-37-shuffled)
   (make-run-manifest exp02-seed-37-rules-8-shuffled config-hash-exp02-seed-37-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-37-no-catalysis)
   (make-run-manifest exp02-seed-37-rules-8-no-catalysis config-hash-exp02-seed-37-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-37-random)
   ((metric active-acs-count exp02-seed-37-rules-8-random (exp02-seed-37-active-count random-polymer))
    (metric control-family exp02-seed-37-rules-8-random random-polymer)
    (metric rule-count exp02-seed-37-rules-8-random 8)
    (metric generation-seam exp02-seed-37-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-37-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-37-shuffled)
   ((metric active-acs-count exp02-seed-37-rules-8-shuffled (exp02-seed-37-active-count shuffled-catalysts))
    (metric control-family exp02-seed-37-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-37-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-37-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-37-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-37-no-catalysis)
   ((metric active-acs-count exp02-seed-37-rules-8-no-catalysis (exp02-seed-37-active-count no-catalysis))
    (metric control-family exp02-seed-37-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-37-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-37-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-37-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-37-random)
   (make-run-summary exp02-seed-37-rules-8-random passed seed-37-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-37-shuffled)
   (make-run-summary exp02-seed-37-rules-8-shuffled passed seed-37-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-37-no-catalysis)
   (make-run-summary exp02-seed-37-rules-8-no-catalysis passed seed-37-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-37-random)
   (make-run-record exp02-seed-37-rules-8-random (exp02-run-config seed-37-random) (exp02-run-manifest seed-37-random) () (exp02-initial-abundances) (exp02-metrics seed-37-random) (exp02-seed-37-acs-candidates random-polymer) () (exp02-run-summary seed-37-random)))

(= (exp02-run-record seed-37-shuffled)
   (make-run-record exp02-seed-37-rules-8-shuffled (exp02-run-config seed-37-shuffled) (exp02-run-manifest seed-37-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-37-shuffled) (exp02-seed-37-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-37-shuffled)))

(= (exp02-run-record seed-37-no-catalysis)
   (make-run-record exp02-seed-37-rules-8-no-catalysis (exp02-run-config seed-37-no-catalysis) (exp02-run-manifest seed-37-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-37-no-catalysis) (exp02-seed-37-acs-candidates no-catalysis) () (exp02-run-summary seed-37-no-catalysis)))


; seed-41 adds another factored-template generated-unplanted point using the
; existing PeTTa-side token/product dictionary seam.  The rule template is
; unchanged, so this extends coverage without adding per-rule component rows.

(= (exp02-seed-token seed-41 0) Y0)
(= (exp02-seed-token seed-41 1) Y1)
(= (exp02-seed-token seed-41 2) Y2)
(= (exp02-seed-token seed-41 3) Y3)
(= (exp02-seed-token seed-41 4) Y4)
(= (exp02-seed-token seed-41 5) Y5)
(= (exp02-seed-token seed-41 6) Y6)
(= (exp02-seed-token seed-41 7) Y7)
(= (exp02-seed-token seed-41 8) Y8)
(= (exp02-seed-token seed-41 9) Y9)

(= (exp02-seed-product seed-41 01) Y01)
(= (exp02-seed-product seed-41 23) Y23)
(= (exp02-seed-product seed-41 45) Y45)
(= (exp02-seed-product seed-41 67) Y67)
(= (exp02-seed-product seed-41 89) Y89)
(= (exp02-seed-product seed-41 14) Y14)
(= (exp02-seed-product seed-41 36) Y36)
(= (exp02-seed-product seed-41 58) Y58)

(= (exp02-seed-rule-components seed-41 rr0) (exp02-factored-unplanted-rule-components seed-41 rr0))
(= (exp02-seed-rule-components seed-41 rr1) (exp02-factored-unplanted-rule-components seed-41 rr1))
(= (exp02-seed-rule-components seed-41 rr2) (exp02-factored-unplanted-rule-components seed-41 rr2))
(= (exp02-seed-rule-components seed-41 rr3) (exp02-factored-unplanted-rule-components seed-41 rr3))
(= (exp02-seed-rule-components seed-41 rr4) (exp02-factored-unplanted-rule-components seed-41 rr4))
(= (exp02-seed-rule-components seed-41 rr5) (exp02-factored-unplanted-rule-components seed-41 rr5))
(= (exp02-seed-rule-components seed-41 rr6) (exp02-factored-unplanted-rule-components seed-41 rr6))
(= (exp02-seed-rule-components seed-41 rr7) (exp02-factored-unplanted-rule-components seed-41 rr7))

(= (exp02-seed-41-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-41 $family)))

(= (exp02-seed-41-active-count $family)
   (active-acs-count-28 (exp02-seed-41-acs-candidates $family)))

(= (exp02-seed-41-generated-negative-control?)
   (and (== (exp02-seed-41-active-count random-polymer) 0)
        (and (== (exp02-seed-41-active-count shuffled-catalysts) 0)
             (== (exp02-seed-41-active-count no-catalysis) 0))))

(= (exp02-run-config seed-41-random)
   (make-run-config exp02-seed-41-rules-8-random exp02 (seed-41) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-41-shuffled)
   (make-run-config exp02-seed-41-rules-8-shuffled exp02 (seed-41) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-41-no-catalysis)
   (make-run-config exp02-seed-41-rules-8-no-catalysis exp02 (seed-41) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-41-random)
   (make-run-manifest exp02-seed-41-rules-8-random config-hash-exp02-seed-41-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-41-shuffled)
   (make-run-manifest exp02-seed-41-rules-8-shuffled config-hash-exp02-seed-41-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-41-no-catalysis)
   (make-run-manifest exp02-seed-41-rules-8-no-catalysis config-hash-exp02-seed-41-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-41-random)
   ((metric active-acs-count exp02-seed-41-rules-8-random (exp02-seed-41-active-count random-polymer))
    (metric control-family exp02-seed-41-rules-8-random random-polymer)
    (metric rule-count exp02-seed-41-rules-8-random 8)
    (metric generation-seam exp02-seed-41-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-41-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-41-shuffled)
   ((metric active-acs-count exp02-seed-41-rules-8-shuffled (exp02-seed-41-active-count shuffled-catalysts))
    (metric control-family exp02-seed-41-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-41-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-41-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-41-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-41-no-catalysis)
   ((metric active-acs-count exp02-seed-41-rules-8-no-catalysis (exp02-seed-41-active-count no-catalysis))
    (metric control-family exp02-seed-41-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-41-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-41-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-41-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-41-random)
   (make-run-summary exp02-seed-41-rules-8-random passed seed-41-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-41-shuffled)
   (make-run-summary exp02-seed-41-rules-8-shuffled passed seed-41-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-41-no-catalysis)
   (make-run-summary exp02-seed-41-rules-8-no-catalysis passed seed-41-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-41-random)
   (make-run-record exp02-seed-41-rules-8-random (exp02-run-config seed-41-random) (exp02-run-manifest seed-41-random) () (exp02-initial-abundances) (exp02-metrics seed-41-random) (exp02-seed-41-acs-candidates random-polymer) () (exp02-run-summary seed-41-random)))

(= (exp02-run-record seed-41-shuffled)
   (make-run-record exp02-seed-41-rules-8-shuffled (exp02-run-config seed-41-shuffled) (exp02-run-manifest seed-41-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-41-shuffled) (exp02-seed-41-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-41-shuffled)))

(= (exp02-run-record seed-41-no-catalysis)
   (make-run-record exp02-seed-41-rules-8-no-catalysis (exp02-run-config seed-41-no-catalysis) (exp02-run-manifest seed-41-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-41-no-catalysis) (exp02-seed-41-acs-candidates no-catalysis) () (exp02-run-summary seed-41-no-catalysis)))

; seed-43 adds the next factored-template generated-unplanted point using
; only a new token/product dictionary.  The shared PeTTa-side rule template,
; controls, scanner, and run-record seams remain unchanged.

(= (exp02-seed-token seed-43 0) Z0)
(= (exp02-seed-token seed-43 1) Z1)
(= (exp02-seed-token seed-43 2) Z2)
(= (exp02-seed-token seed-43 3) Z3)
(= (exp02-seed-token seed-43 4) Z4)
(= (exp02-seed-token seed-43 5) Z5)
(= (exp02-seed-token seed-43 6) Z6)
(= (exp02-seed-token seed-43 7) Z7)
(= (exp02-seed-token seed-43 8) Z8)
(= (exp02-seed-token seed-43 9) Z9)

(= (exp02-seed-product seed-43 01) Z01)
(= (exp02-seed-product seed-43 23) Z23)
(= (exp02-seed-product seed-43 45) Z45)
(= (exp02-seed-product seed-43 67) Z67)
(= (exp02-seed-product seed-43 89) Z89)
(= (exp02-seed-product seed-43 14) Z14)
(= (exp02-seed-product seed-43 36) Z36)
(= (exp02-seed-product seed-43 58) Z58)

(= (exp02-seed-rule-components seed-43 rr0) (exp02-factored-unplanted-rule-components seed-43 rr0))
(= (exp02-seed-rule-components seed-43 rr1) (exp02-factored-unplanted-rule-components seed-43 rr1))
(= (exp02-seed-rule-components seed-43 rr2) (exp02-factored-unplanted-rule-components seed-43 rr2))
(= (exp02-seed-rule-components seed-43 rr3) (exp02-factored-unplanted-rule-components seed-43 rr3))
(= (exp02-seed-rule-components seed-43 rr4) (exp02-factored-unplanted-rule-components seed-43 rr4))
(= (exp02-seed-rule-components seed-43 rr5) (exp02-factored-unplanted-rule-components seed-43 rr5))
(= (exp02-seed-rule-components seed-43 rr6) (exp02-factored-unplanted-rule-components seed-43 rr6))
(= (exp02-seed-rule-components seed-43 rr7) (exp02-factored-unplanted-rule-components seed-43 rr7))

(= (exp02-seed-43-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-43 $family)))

(= (exp02-seed-43-active-count $family)
   (active-acs-count-28 (exp02-seed-43-acs-candidates $family)))

(= (exp02-seed-43-generated-negative-control?)
   (and (== (exp02-seed-43-active-count random-polymer) 0)
        (and (== (exp02-seed-43-active-count shuffled-catalysts) 0)
             (== (exp02-seed-43-active-count no-catalysis) 0))))

(= (exp02-run-config seed-43-random)
   (make-run-config exp02-seed-43-rules-8-random exp02 (seed-43) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-43-shuffled)
   (make-run-config exp02-seed-43-rules-8-shuffled exp02 (seed-43) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-43-no-catalysis)
   (make-run-config exp02-seed-43-rules-8-no-catalysis exp02 (seed-43) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-43-random)
   (make-run-manifest exp02-seed-43-rules-8-random config-hash-exp02-seed-43-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-43-shuffled)
   (make-run-manifest exp02-seed-43-rules-8-shuffled config-hash-exp02-seed-43-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-43-no-catalysis)
   (make-run-manifest exp02-seed-43-rules-8-no-catalysis config-hash-exp02-seed-43-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-43-random)
   ((metric active-acs-count exp02-seed-43-rules-8-random (exp02-seed-43-active-count random-polymer))
    (metric control-family exp02-seed-43-rules-8-random random-polymer)
    (metric rule-count exp02-seed-43-rules-8-random 8)
    (metric generation-seam exp02-seed-43-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-43-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-43-shuffled)
   ((metric active-acs-count exp02-seed-43-rules-8-shuffled (exp02-seed-43-active-count shuffled-catalysts))
    (metric control-family exp02-seed-43-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-43-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-43-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-43-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-43-no-catalysis)
   ((metric active-acs-count exp02-seed-43-rules-8-no-catalysis (exp02-seed-43-active-count no-catalysis))
    (metric control-family exp02-seed-43-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-43-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-43-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-43-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-43-random)
   (make-run-summary exp02-seed-43-rules-8-random passed seed-43-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-43-shuffled)
   (make-run-summary exp02-seed-43-rules-8-shuffled passed seed-43-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-43-no-catalysis)
   (make-run-summary exp02-seed-43-rules-8-no-catalysis passed seed-43-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-43-random)
   (make-run-record exp02-seed-43-rules-8-random (exp02-run-config seed-43-random) (exp02-run-manifest seed-43-random) () (exp02-initial-abundances) (exp02-metrics seed-43-random) (exp02-seed-43-acs-candidates random-polymer) () (exp02-run-summary seed-43-random)))

(= (exp02-run-record seed-43-shuffled)
   (make-run-record exp02-seed-43-rules-8-shuffled (exp02-run-config seed-43-shuffled) (exp02-run-manifest seed-43-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-43-shuffled) (exp02-seed-43-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-43-shuffled)))

(= (exp02-run-record seed-43-no-catalysis)
   (make-run-record exp02-seed-43-rules-8-no-catalysis (exp02-run-config seed-43-no-catalysis) (exp02-run-manifest seed-43-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-43-no-catalysis) (exp02-seed-43-acs-candidates no-catalysis) () (exp02-run-summary seed-43-no-catalysis)))


; seed-47 adds a further factored-template generated-unplanted point using
; only a new token/product dictionary.  The shared PeTTa-side rule template,
; controls, scanner, and run-record seams remain unchanged.

(= (exp02-seed-token seed-47 0) ZA0)
(= (exp02-seed-token seed-47 1) ZA1)
(= (exp02-seed-token seed-47 2) ZA2)
(= (exp02-seed-token seed-47 3) ZA3)
(= (exp02-seed-token seed-47 4) ZA4)
(= (exp02-seed-token seed-47 5) ZA5)
(= (exp02-seed-token seed-47 6) ZA6)
(= (exp02-seed-token seed-47 7) ZA7)
(= (exp02-seed-token seed-47 8) ZA8)
(= (exp02-seed-token seed-47 9) ZA9)

(= (exp02-seed-product seed-47 01) ZA01)
(= (exp02-seed-product seed-47 23) ZA23)
(= (exp02-seed-product seed-47 45) ZA45)
(= (exp02-seed-product seed-47 67) ZA67)
(= (exp02-seed-product seed-47 89) ZA89)
(= (exp02-seed-product seed-47 14) ZA14)
(= (exp02-seed-product seed-47 36) ZA36)
(= (exp02-seed-product seed-47 58) ZA58)

(= (exp02-seed-rule-components seed-47 rr0) (exp02-factored-unplanted-rule-components seed-47 rr0))
(= (exp02-seed-rule-components seed-47 rr1) (exp02-factored-unplanted-rule-components seed-47 rr1))
(= (exp02-seed-rule-components seed-47 rr2) (exp02-factored-unplanted-rule-components seed-47 rr2))
(= (exp02-seed-rule-components seed-47 rr3) (exp02-factored-unplanted-rule-components seed-47 rr3))
(= (exp02-seed-rule-components seed-47 rr4) (exp02-factored-unplanted-rule-components seed-47 rr4))
(= (exp02-seed-rule-components seed-47 rr5) (exp02-factored-unplanted-rule-components seed-47 rr5))
(= (exp02-seed-rule-components seed-47 rr6) (exp02-factored-unplanted-rule-components seed-47 rr6))
(= (exp02-seed-rule-components seed-47 rr7) (exp02-factored-unplanted-rule-components seed-47 rr7))

(= (exp02-seed-47-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-47 $family)))

(= (exp02-seed-47-active-count $family)
   (active-acs-count-28 (exp02-seed-47-acs-candidates $family)))

(= (exp02-seed-47-generated-negative-control?)
   (and (== (exp02-seed-47-active-count random-polymer) 0)
        (and (== (exp02-seed-47-active-count shuffled-catalysts) 0)
             (== (exp02-seed-47-active-count no-catalysis) 0))))

(= (exp02-run-config seed-47-random)
   (make-run-config exp02-seed-47-rules-8-random exp02 (seed-47) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-47-shuffled)
   (make-run-config exp02-seed-47-rules-8-shuffled exp02 (seed-47) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-47-no-catalysis)
   (make-run-config exp02-seed-47-rules-8-no-catalysis exp02 (seed-47) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-47-random)
   (make-run-manifest exp02-seed-47-rules-8-random config-hash-exp02-seed-47-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-47-shuffled)
   (make-run-manifest exp02-seed-47-rules-8-shuffled config-hash-exp02-seed-47-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-47-no-catalysis)
   (make-run-manifest exp02-seed-47-rules-8-no-catalysis config-hash-exp02-seed-47-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-47-random)
   ((metric active-acs-count exp02-seed-47-rules-8-random (exp02-seed-47-active-count random-polymer))
    (metric control-family exp02-seed-47-rules-8-random random-polymer)
    (metric rule-count exp02-seed-47-rules-8-random 8)
    (metric generation-seam exp02-seed-47-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-47-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-47-shuffled)
   ((metric active-acs-count exp02-seed-47-rules-8-shuffled (exp02-seed-47-active-count shuffled-catalysts))
    (metric control-family exp02-seed-47-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-47-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-47-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-47-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-47-no-catalysis)
   ((metric active-acs-count exp02-seed-47-rules-8-no-catalysis (exp02-seed-47-active-count no-catalysis))
    (metric control-family exp02-seed-47-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-47-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-47-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-47-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-47-random)
   (make-run-summary exp02-seed-47-rules-8-random passed seed-47-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-47-shuffled)
   (make-run-summary exp02-seed-47-rules-8-shuffled passed seed-47-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-47-no-catalysis)
   (make-run-summary exp02-seed-47-rules-8-no-catalysis passed seed-47-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-47-random)
   (make-run-record exp02-seed-47-rules-8-random (exp02-run-config seed-47-random) (exp02-run-manifest seed-47-random) () (exp02-initial-abundances) (exp02-metrics seed-47-random) (exp02-seed-47-acs-candidates random-polymer) () (exp02-run-summary seed-47-random)))

(= (exp02-run-record seed-47-shuffled)
   (make-run-record exp02-seed-47-rules-8-shuffled (exp02-run-config seed-47-shuffled) (exp02-run-manifest seed-47-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-47-shuffled) (exp02-seed-47-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-47-shuffled)))

(= (exp02-run-record seed-47-no-catalysis)
   (make-run-record exp02-seed-47-rules-8-no-catalysis (exp02-run-config seed-47-no-catalysis) (exp02-run-manifest seed-47-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-47-no-catalysis) (exp02-seed-47-acs-candidates no-catalysis) () (exp02-run-summary seed-47-no-catalysis)))


; seed-53 continues the factored-template generated-unplanted batch through
; the same PeTTa-side token/product dictionary seam.  Only the compact
; dictionary changes; rule generation, controls, ACS scanning, and run-record
; construction stay on the shared kernel path.

(= (exp02-seed-token seed-53 0) ZB0)
(= (exp02-seed-token seed-53 1) ZB1)
(= (exp02-seed-token seed-53 2) ZB2)
(= (exp02-seed-token seed-53 3) ZB3)
(= (exp02-seed-token seed-53 4) ZB4)
(= (exp02-seed-token seed-53 5) ZB5)
(= (exp02-seed-token seed-53 6) ZB6)
(= (exp02-seed-token seed-53 7) ZB7)
(= (exp02-seed-token seed-53 8) ZB8)
(= (exp02-seed-token seed-53 9) ZB9)

(= (exp02-seed-product seed-53 01) ZB01)
(= (exp02-seed-product seed-53 23) ZB23)
(= (exp02-seed-product seed-53 45) ZB45)
(= (exp02-seed-product seed-53 67) ZB67)
(= (exp02-seed-product seed-53 89) ZB89)
(= (exp02-seed-product seed-53 14) ZB14)
(= (exp02-seed-product seed-53 36) ZB36)
(= (exp02-seed-product seed-53 58) ZB58)

(= (exp02-seed-rule-components seed-53 rr0) (exp02-factored-unplanted-rule-components seed-53 rr0))
(= (exp02-seed-rule-components seed-53 rr1) (exp02-factored-unplanted-rule-components seed-53 rr1))
(= (exp02-seed-rule-components seed-53 rr2) (exp02-factored-unplanted-rule-components seed-53 rr2))
(= (exp02-seed-rule-components seed-53 rr3) (exp02-factored-unplanted-rule-components seed-53 rr3))
(= (exp02-seed-rule-components seed-53 rr4) (exp02-factored-unplanted-rule-components seed-53 rr4))
(= (exp02-seed-rule-components seed-53 rr5) (exp02-factored-unplanted-rule-components seed-53 rr5))
(= (exp02-seed-rule-components seed-53 rr6) (exp02-factored-unplanted-rule-components seed-53 rr6))
(= (exp02-seed-rule-components seed-53 rr7) (exp02-factored-unplanted-rule-components seed-53 rr7))

(= (exp02-seed-53-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-53 $family)))

(= (exp02-seed-53-active-count $family)
   (active-acs-count-28 (exp02-seed-53-acs-candidates $family)))

(= (exp02-seed-53-generated-negative-control?)
   (and (== (exp02-seed-53-active-count random-polymer) 0)
        (and (== (exp02-seed-53-active-count shuffled-catalysts) 0)
             (== (exp02-seed-53-active-count no-catalysis) 0))))

(= (exp02-run-config seed-53-random)
   (make-run-config exp02-seed-53-rules-8-random exp02 (seed-53) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-53-shuffled)
   (make-run-config exp02-seed-53-rules-8-shuffled exp02 (seed-53) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-53-no-catalysis)
   (make-run-config exp02-seed-53-rules-8-no-catalysis exp02 (seed-53) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-53-random)
   (make-run-manifest exp02-seed-53-rules-8-random config-hash-exp02-seed-53-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-53-shuffled)
   (make-run-manifest exp02-seed-53-rules-8-shuffled config-hash-exp02-seed-53-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-53-no-catalysis)
   (make-run-manifest exp02-seed-53-rules-8-no-catalysis config-hash-exp02-seed-53-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-53-random)
   ((metric active-acs-count exp02-seed-53-rules-8-random (exp02-seed-53-active-count random-polymer))
    (metric control-family exp02-seed-53-rules-8-random random-polymer)
    (metric rule-count exp02-seed-53-rules-8-random 8)
    (metric generation-seam exp02-seed-53-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-53-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-53-shuffled)
   ((metric active-acs-count exp02-seed-53-rules-8-shuffled (exp02-seed-53-active-count shuffled-catalysts))
    (metric control-family exp02-seed-53-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-53-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-53-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-53-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-53-no-catalysis)
   ((metric active-acs-count exp02-seed-53-rules-8-no-catalysis (exp02-seed-53-active-count no-catalysis))
    (metric control-family exp02-seed-53-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-53-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-53-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-53-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-53-random)
   (make-run-summary exp02-seed-53-rules-8-random passed seed-53-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-53-shuffled)
   (make-run-summary exp02-seed-53-rules-8-shuffled passed seed-53-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-53-no-catalysis)
   (make-run-summary exp02-seed-53-rules-8-no-catalysis passed seed-53-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-53-random)
   (make-run-record exp02-seed-53-rules-8-random (exp02-run-config seed-53-random) (exp02-run-manifest seed-53-random) () (exp02-initial-abundances) (exp02-metrics seed-53-random) (exp02-seed-53-acs-candidates random-polymer) () (exp02-run-summary seed-53-random)))

(= (exp02-run-record seed-53-shuffled)
   (make-run-record exp02-seed-53-rules-8-shuffled (exp02-run-config seed-53-shuffled) (exp02-run-manifest seed-53-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-53-shuffled) (exp02-seed-53-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-53-shuffled)))

(= (exp02-run-record seed-53-no-catalysis)
   (make-run-record exp02-seed-53-rules-8-no-catalysis (exp02-run-config seed-53-no-catalysis) (exp02-run-manifest seed-53-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-53-no-catalysis) (exp02-seed-53-acs-candidates no-catalysis) () (exp02-run-summary seed-53-no-catalysis)))

; seed-59 adds the next factored-template generated-unplanted point through
; the same PeTTa-side token/product dictionary seam.  Only the compact
; dictionary changes; rule generation, controls, ACS scanning, and run-record
; construction stay on the shared kernel path.

(= (exp02-seed-token seed-59 0) ZC0)
(= (exp02-seed-token seed-59 1) ZC1)
(= (exp02-seed-token seed-59 2) ZC2)
(= (exp02-seed-token seed-59 3) ZC3)
(= (exp02-seed-token seed-59 4) ZC4)
(= (exp02-seed-token seed-59 5) ZC5)
(= (exp02-seed-token seed-59 6) ZC6)
(= (exp02-seed-token seed-59 7) ZC7)
(= (exp02-seed-token seed-59 8) ZC8)
(= (exp02-seed-token seed-59 9) ZC9)

(= (exp02-seed-product seed-59 01) ZC01)
(= (exp02-seed-product seed-59 23) ZC23)
(= (exp02-seed-product seed-59 45) ZC45)
(= (exp02-seed-product seed-59 67) ZC67)
(= (exp02-seed-product seed-59 89) ZC89)
(= (exp02-seed-product seed-59 14) ZC14)
(= (exp02-seed-product seed-59 36) ZC36)
(= (exp02-seed-product seed-59 58) ZC58)

(= (exp02-seed-rule-components seed-59 rr0) (exp02-factored-unplanted-rule-components seed-59 rr0))
(= (exp02-seed-rule-components seed-59 rr1) (exp02-factored-unplanted-rule-components seed-59 rr1))
(= (exp02-seed-rule-components seed-59 rr2) (exp02-factored-unplanted-rule-components seed-59 rr2))
(= (exp02-seed-rule-components seed-59 rr3) (exp02-factored-unplanted-rule-components seed-59 rr3))
(= (exp02-seed-rule-components seed-59 rr4) (exp02-factored-unplanted-rule-components seed-59 rr4))
(= (exp02-seed-rule-components seed-59 rr5) (exp02-factored-unplanted-rule-components seed-59 rr5))
(= (exp02-seed-rule-components seed-59 rr6) (exp02-factored-unplanted-rule-components seed-59 rr6))
(= (exp02-seed-rule-components seed-59 rr7) (exp02-factored-unplanted-rule-components seed-59 rr7))

(= (exp02-seed-59-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-59 $family)))

(= (exp02-seed-59-active-count $family)
   (active-acs-count-28 (exp02-seed-59-acs-candidates $family)))

(= (exp02-seed-59-generated-negative-control?)
   (and (== (exp02-seed-59-active-count random-polymer) 0)
        (and (== (exp02-seed-59-active-count shuffled-catalysts) 0)
             (== (exp02-seed-59-active-count no-catalysis) 0))))

(= (exp02-run-config seed-59-random)
   (make-run-config exp02-seed-59-rules-8-random exp02 (seed-59) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-59-shuffled)
   (make-run-config exp02-seed-59-rules-8-shuffled exp02 (seed-59) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-59-no-catalysis)
   (make-run-config exp02-seed-59-rules-8-no-catalysis exp02 (seed-59) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-59-random)
   (make-run-manifest exp02-seed-59-rules-8-random config-hash-exp02-seed-59-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-59-shuffled)
   (make-run-manifest exp02-seed-59-rules-8-shuffled config-hash-exp02-seed-59-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-59-no-catalysis)
   (make-run-manifest exp02-seed-59-rules-8-no-catalysis config-hash-exp02-seed-59-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-59-random)
   ((metric active-acs-count exp02-seed-59-rules-8-random (exp02-seed-59-active-count random-polymer))
    (metric control-family exp02-seed-59-rules-8-random random-polymer)
    (metric rule-count exp02-seed-59-rules-8-random 8)
    (metric generation-seam exp02-seed-59-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-59-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-59-shuffled)
   ((metric active-acs-count exp02-seed-59-rules-8-shuffled (exp02-seed-59-active-count shuffled-catalysts))
    (metric control-family exp02-seed-59-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-59-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-59-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-59-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-59-no-catalysis)
   ((metric active-acs-count exp02-seed-59-rules-8-no-catalysis (exp02-seed-59-active-count no-catalysis))
    (metric control-family exp02-seed-59-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-59-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-59-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-59-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-59-random)
   (make-run-summary exp02-seed-59-rules-8-random passed seed-59-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-59-shuffled)
   (make-run-summary exp02-seed-59-rules-8-shuffled passed seed-59-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-59-no-catalysis)
   (make-run-summary exp02-seed-59-rules-8-no-catalysis passed seed-59-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-59-random)
   (make-run-record exp02-seed-59-rules-8-random (exp02-run-config seed-59-random) (exp02-run-manifest seed-59-random) () (exp02-initial-abundances) (exp02-metrics seed-59-random) (exp02-seed-59-acs-candidates random-polymer) () (exp02-run-summary seed-59-random)))

(= (exp02-run-record seed-59-shuffled)
   (make-run-record exp02-seed-59-rules-8-shuffled (exp02-run-config seed-59-shuffled) (exp02-run-manifest seed-59-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-59-shuffled) (exp02-seed-59-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-59-shuffled)))

(= (exp02-run-record seed-59-no-catalysis)
   (make-run-record exp02-seed-59-rules-8-no-catalysis (exp02-run-config seed-59-no-catalysis) (exp02-run-manifest seed-59-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-59-no-catalysis) (exp02-seed-59-acs-candidates no-catalysis) () (exp02-run-summary seed-59-no-catalysis)))


; seed-61 adds the next factored-template generated-unplanted point through
; the same PeTTa-side token/product dictionary seam.  Only the compact
; dictionary changes; rule generation, controls, ACS scanning, and run-record
; construction stay on the shared kernel path.

(= (exp02-seed-token seed-61 0) ZD0)
(= (exp02-seed-token seed-61 1) ZD1)
(= (exp02-seed-token seed-61 2) ZD2)
(= (exp02-seed-token seed-61 3) ZD3)
(= (exp02-seed-token seed-61 4) ZD4)
(= (exp02-seed-token seed-61 5) ZD5)
(= (exp02-seed-token seed-61 6) ZD6)
(= (exp02-seed-token seed-61 7) ZD7)
(= (exp02-seed-token seed-61 8) ZD8)
(= (exp02-seed-token seed-61 9) ZD9)

(= (exp02-seed-product seed-61 01) ZD01)
(= (exp02-seed-product seed-61 23) ZD23)
(= (exp02-seed-product seed-61 45) ZD45)
(= (exp02-seed-product seed-61 67) ZD67)
(= (exp02-seed-product seed-61 89) ZD89)
(= (exp02-seed-product seed-61 14) ZD14)
(= (exp02-seed-product seed-61 36) ZD36)
(= (exp02-seed-product seed-61 58) ZD58)

(= (exp02-seed-rule-components seed-61 rr0) (exp02-factored-unplanted-rule-components seed-61 rr0))
(= (exp02-seed-rule-components seed-61 rr1) (exp02-factored-unplanted-rule-components seed-61 rr1))
(= (exp02-seed-rule-components seed-61 rr2) (exp02-factored-unplanted-rule-components seed-61 rr2))
(= (exp02-seed-rule-components seed-61 rr3) (exp02-factored-unplanted-rule-components seed-61 rr3))
(= (exp02-seed-rule-components seed-61 rr4) (exp02-factored-unplanted-rule-components seed-61 rr4))
(= (exp02-seed-rule-components seed-61 rr5) (exp02-factored-unplanted-rule-components seed-61 rr5))
(= (exp02-seed-rule-components seed-61 rr6) (exp02-factored-unplanted-rule-components seed-61 rr6))
(= (exp02-seed-rule-components seed-61 rr7) (exp02-factored-unplanted-rule-components seed-61 rr7))

(= (exp02-seed-61-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-61 $family)))

(= (exp02-seed-61-active-count $family)
   (active-acs-count-28 (exp02-seed-61-acs-candidates $family)))

(= (exp02-seed-61-generated-negative-control?)
   (and (== (exp02-seed-61-active-count random-polymer) 0)
        (and (== (exp02-seed-61-active-count shuffled-catalysts) 0)
             (== (exp02-seed-61-active-count no-catalysis) 0))))

(= (exp02-run-config seed-61-random)
   (make-run-config exp02-seed-61-rules-8-random exp02 (seed-61) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-61-shuffled)
   (make-run-config exp02-seed-61-rules-8-shuffled exp02 (seed-61) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-61-no-catalysis)
   (make-run-config exp02-seed-61-rules-8-no-catalysis exp02 (seed-61) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-61-random)
   (make-run-manifest exp02-seed-61-rules-8-random config-hash-exp02-seed-61-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-61-shuffled)
   (make-run-manifest exp02-seed-61-rules-8-shuffled config-hash-exp02-seed-61-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-61-no-catalysis)
   (make-run-manifest exp02-seed-61-rules-8-no-catalysis config-hash-exp02-seed-61-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-61-random)
   ((metric active-acs-count exp02-seed-61-rules-8-random (exp02-seed-61-active-count random-polymer))
    (metric control-family exp02-seed-61-rules-8-random random-polymer)
    (metric rule-count exp02-seed-61-rules-8-random 8)
    (metric generation-seam exp02-seed-61-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-61-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-61-shuffled)
   ((metric active-acs-count exp02-seed-61-rules-8-shuffled (exp02-seed-61-active-count shuffled-catalysts))
    (metric control-family exp02-seed-61-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-61-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-61-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-61-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-61-no-catalysis)
   ((metric active-acs-count exp02-seed-61-rules-8-no-catalysis (exp02-seed-61-active-count no-catalysis))
    (metric control-family exp02-seed-61-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-61-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-61-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-61-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-61-random)
   (make-run-summary exp02-seed-61-rules-8-random passed seed-61-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-61-shuffled)
   (make-run-summary exp02-seed-61-rules-8-shuffled passed seed-61-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-61-no-catalysis)
   (make-run-summary exp02-seed-61-rules-8-no-catalysis passed seed-61-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-61-random)
   (make-run-record exp02-seed-61-rules-8-random (exp02-run-config seed-61-random) (exp02-run-manifest seed-61-random) () (exp02-initial-abundances) (exp02-metrics seed-61-random) (exp02-seed-61-acs-candidates random-polymer) () (exp02-run-summary seed-61-random)))

(= (exp02-run-record seed-61-shuffled)
   (make-run-record exp02-seed-61-rules-8-shuffled (exp02-run-config seed-61-shuffled) (exp02-run-manifest seed-61-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-61-shuffled) (exp02-seed-61-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-61-shuffled)))

(= (exp02-run-record seed-61-no-catalysis)
   (make-run-record exp02-seed-61-rules-8-no-catalysis (exp02-run-config seed-61-no-catalysis) (exp02-run-manifest seed-61-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-61-no-catalysis) (exp02-seed-61-acs-candidates no-catalysis) () (exp02-run-summary seed-61-no-catalysis)))



; seed-67 adds another factored-template generated-unplanted point through
; the same PeTTa-side token/product dictionary seam.  The point broadens the
; host-swept negative-control batch without changing the chemistry kernel path.

(= (exp02-seed-token seed-67 0) ZE0)
(= (exp02-seed-token seed-67 1) ZE1)
(= (exp02-seed-token seed-67 2) ZE2)
(= (exp02-seed-token seed-67 3) ZE3)
(= (exp02-seed-token seed-67 4) ZE4)
(= (exp02-seed-token seed-67 5) ZE5)
(= (exp02-seed-token seed-67 6) ZE6)
(= (exp02-seed-token seed-67 7) ZE7)
(= (exp02-seed-token seed-67 8) ZE8)
(= (exp02-seed-token seed-67 9) ZE9)

(= (exp02-seed-product seed-67 01) ZE01)
(= (exp02-seed-product seed-67 23) ZE23)
(= (exp02-seed-product seed-67 45) ZE45)
(= (exp02-seed-product seed-67 67) ZE67)
(= (exp02-seed-product seed-67 89) ZE89)
(= (exp02-seed-product seed-67 14) ZE14)
(= (exp02-seed-product seed-67 36) ZE36)
(= (exp02-seed-product seed-67 58) ZE58)

(= (exp02-seed-rule-components seed-67 rr0) (exp02-factored-unplanted-rule-components seed-67 rr0))
(= (exp02-seed-rule-components seed-67 rr1) (exp02-factored-unplanted-rule-components seed-67 rr1))
(= (exp02-seed-rule-components seed-67 rr2) (exp02-factored-unplanted-rule-components seed-67 rr2))
(= (exp02-seed-rule-components seed-67 rr3) (exp02-factored-unplanted-rule-components seed-67 rr3))
(= (exp02-seed-rule-components seed-67 rr4) (exp02-factored-unplanted-rule-components seed-67 rr4))
(= (exp02-seed-rule-components seed-67 rr5) (exp02-factored-unplanted-rule-components seed-67 rr5))
(= (exp02-seed-rule-components seed-67 rr6) (exp02-factored-unplanted-rule-components seed-67 rr6))
(= (exp02-seed-rule-components seed-67 rr7) (exp02-factored-unplanted-rule-components seed-67 rr7))

(= (exp02-seed-67-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-67 $family)))

(= (exp02-seed-67-active-count $family)
   (active-acs-count-28 (exp02-seed-67-acs-candidates $family)))

(= (exp02-seed-67-generated-negative-control?)
   (and (== (exp02-seed-67-active-count random-polymer) 0)
        (and (== (exp02-seed-67-active-count shuffled-catalysts) 0)
             (== (exp02-seed-67-active-count no-catalysis) 0))))

(= (exp02-run-config seed-67-random)
   (make-run-config exp02-seed-67-rules-8-random exp02 (seed-67) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-67-shuffled)
   (make-run-config exp02-seed-67-rules-8-shuffled exp02 (seed-67) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-67-no-catalysis)
   (make-run-config exp02-seed-67-rules-8-no-catalysis exp02 (seed-67) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-67-random)
   (make-run-manifest exp02-seed-67-rules-8-random config-hash-exp02-seed-67-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-67-shuffled)
   (make-run-manifest exp02-seed-67-rules-8-shuffled config-hash-exp02-seed-67-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-67-no-catalysis)
   (make-run-manifest exp02-seed-67-rules-8-no-catalysis config-hash-exp02-seed-67-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-67-random)
   ((metric active-acs-count exp02-seed-67-rules-8-random (exp02-seed-67-active-count random-polymer))
    (metric control-family exp02-seed-67-rules-8-random random-polymer)
    (metric rule-count exp02-seed-67-rules-8-random 8)
    (metric generation-seam exp02-seed-67-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-67-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-67-shuffled)
   ((metric active-acs-count exp02-seed-67-rules-8-shuffled (exp02-seed-67-active-count shuffled-catalysts))
    (metric control-family exp02-seed-67-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-67-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-67-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-67-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-67-no-catalysis)
   ((metric active-acs-count exp02-seed-67-rules-8-no-catalysis (exp02-seed-67-active-count no-catalysis))
    (metric control-family exp02-seed-67-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-67-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-67-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-67-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-67-random)
   (make-run-summary exp02-seed-67-rules-8-random passed seed-67-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-67-shuffled)
   (make-run-summary exp02-seed-67-rules-8-shuffled passed seed-67-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-67-no-catalysis)
   (make-run-summary exp02-seed-67-rules-8-no-catalysis passed seed-67-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-67-random)
   (make-run-record exp02-seed-67-rules-8-random (exp02-run-config seed-67-random) (exp02-run-manifest seed-67-random) () (exp02-initial-abundances) (exp02-metrics seed-67-random) (exp02-seed-67-acs-candidates random-polymer) () (exp02-run-summary seed-67-random)))

(= (exp02-run-record seed-67-shuffled)
   (make-run-record exp02-seed-67-rules-8-shuffled (exp02-run-config seed-67-shuffled) (exp02-run-manifest seed-67-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-67-shuffled) (exp02-seed-67-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-67-shuffled)))

(= (exp02-run-record seed-67-no-catalysis)
   (make-run-record exp02-seed-67-rules-8-no-catalysis (exp02-run-config seed-67-no-catalysis) (exp02-run-manifest seed-67-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-67-no-catalysis) (exp02-seed-67-acs-candidates no-catalysis) () (exp02-run-summary seed-67-no-catalysis)))


; seed-71 adds another factored-template generated-unplanted point through
; the same PeTTa-side token/product dictionary seam.  The point broadens the
; host-swept negative-control batch without changing the chemistry kernel path.

(= (exp02-seed-token seed-71 0) ZF0)
(= (exp02-seed-token seed-71 1) ZF1)
(= (exp02-seed-token seed-71 2) ZF2)
(= (exp02-seed-token seed-71 3) ZF3)
(= (exp02-seed-token seed-71 4) ZF4)
(= (exp02-seed-token seed-71 5) ZF5)
(= (exp02-seed-token seed-71 6) ZF6)
(= (exp02-seed-token seed-71 7) ZF7)
(= (exp02-seed-token seed-71 8) ZF8)
(= (exp02-seed-token seed-71 9) ZF9)

(= (exp02-seed-product seed-71 01) ZF01)
(= (exp02-seed-product seed-71 23) ZF23)
(= (exp02-seed-product seed-71 45) ZF45)
(= (exp02-seed-product seed-71 67) ZF67)
(= (exp02-seed-product seed-71 89) ZF89)
(= (exp02-seed-product seed-71 14) ZF14)
(= (exp02-seed-product seed-71 36) ZF36)
(= (exp02-seed-product seed-71 58) ZF58)

(= (exp02-seed-rule-components seed-71 rr0) (exp02-factored-unplanted-rule-components seed-71 rr0))
(= (exp02-seed-rule-components seed-71 rr1) (exp02-factored-unplanted-rule-components seed-71 rr1))
(= (exp02-seed-rule-components seed-71 rr2) (exp02-factored-unplanted-rule-components seed-71 rr2))
(= (exp02-seed-rule-components seed-71 rr3) (exp02-factored-unplanted-rule-components seed-71 rr3))
(= (exp02-seed-rule-components seed-71 rr4) (exp02-factored-unplanted-rule-components seed-71 rr4))
(= (exp02-seed-rule-components seed-71 rr5) (exp02-factored-unplanted-rule-components seed-71 rr5))
(= (exp02-seed-rule-components seed-71 rr6) (exp02-factored-unplanted-rule-components seed-71 rr6))
(= (exp02-seed-rule-components seed-71 rr7) (exp02-factored-unplanted-rule-components seed-71 rr7))

(= (exp02-seed-71-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-71 $family)))

(= (exp02-seed-71-active-count $family)
   (active-acs-count-28 (exp02-seed-71-acs-candidates $family)))

(= (exp02-seed-71-generated-negative-control?)
   (and (== (exp02-seed-71-active-count random-polymer) 0)
        (and (== (exp02-seed-71-active-count shuffled-catalysts) 0)
             (== (exp02-seed-71-active-count no-catalysis) 0))))

(= (exp02-run-config seed-71-random)
   (make-run-config exp02-seed-71-rules-8-random exp02 (seed-71) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-71-shuffled)
   (make-run-config exp02-seed-71-rules-8-shuffled exp02 (seed-71) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-71-no-catalysis)
   (make-run-config exp02-seed-71-rules-8-no-catalysis exp02 (seed-71) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-71-random)
   (make-run-manifest exp02-seed-71-rules-8-random config-hash-exp02-seed-71-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-71-shuffled)
   (make-run-manifest exp02-seed-71-rules-8-shuffled config-hash-exp02-seed-71-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-71-no-catalysis)
   (make-run-manifest exp02-seed-71-rules-8-no-catalysis config-hash-exp02-seed-71-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-71-random)
   ((metric active-acs-count exp02-seed-71-rules-8-random (exp02-seed-71-active-count random-polymer))
    (metric control-family exp02-seed-71-rules-8-random random-polymer)
    (metric rule-count exp02-seed-71-rules-8-random 8)
    (metric generation-seam exp02-seed-71-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-71-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-71-shuffled)
   ((metric active-acs-count exp02-seed-71-rules-8-shuffled (exp02-seed-71-active-count shuffled-catalysts))
    (metric control-family exp02-seed-71-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-71-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-71-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-71-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-71-no-catalysis)
   ((metric active-acs-count exp02-seed-71-rules-8-no-catalysis (exp02-seed-71-active-count no-catalysis))
    (metric control-family exp02-seed-71-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-71-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-71-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-71-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-71-random)
   (make-run-summary exp02-seed-71-rules-8-random passed seed-71-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-71-shuffled)
   (make-run-summary exp02-seed-71-rules-8-shuffled passed seed-71-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-71-no-catalysis)
   (make-run-summary exp02-seed-71-rules-8-no-catalysis passed seed-71-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-71-random)
   (make-run-record exp02-seed-71-rules-8-random (exp02-run-config seed-71-random) (exp02-run-manifest seed-71-random) () (exp02-initial-abundances) (exp02-metrics seed-71-random) (exp02-seed-71-acs-candidates random-polymer) () (exp02-run-summary seed-71-random)))

(= (exp02-run-record seed-71-shuffled)
   (make-run-record exp02-seed-71-rules-8-shuffled (exp02-run-config seed-71-shuffled) (exp02-run-manifest seed-71-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-71-shuffled) (exp02-seed-71-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-71-shuffled)))

(= (exp02-run-record seed-71-no-catalysis)
   (make-run-record exp02-seed-71-rules-8-no-catalysis (exp02-run-config seed-71-no-catalysis) (exp02-run-manifest seed-71-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-71-no-catalysis) (exp02-seed-71-acs-candidates no-catalysis) () (exp02-run-summary seed-71-no-catalysis)))


; seed-73 adds the next factored-template generated-unplanted point through
; the same PeTTa-side token/product dictionary seam.  The point broadens the
; host-swept negative-control batch without changing the chemistry kernel path.

(= (exp02-seed-token seed-73 0) ZG0)
(= (exp02-seed-token seed-73 1) ZG1)
(= (exp02-seed-token seed-73 2) ZG2)
(= (exp02-seed-token seed-73 3) ZG3)
(= (exp02-seed-token seed-73 4) ZG4)
(= (exp02-seed-token seed-73 5) ZG5)
(= (exp02-seed-token seed-73 6) ZG6)
(= (exp02-seed-token seed-73 7) ZG7)
(= (exp02-seed-token seed-73 8) ZG8)
(= (exp02-seed-token seed-73 9) ZG9)

(= (exp02-seed-product seed-73 01) ZG01)
(= (exp02-seed-product seed-73 23) ZG23)
(= (exp02-seed-product seed-73 45) ZG45)
(= (exp02-seed-product seed-73 67) ZG67)
(= (exp02-seed-product seed-73 89) ZG89)
(= (exp02-seed-product seed-73 14) ZG14)
(= (exp02-seed-product seed-73 36) ZG36)
(= (exp02-seed-product seed-73 58) ZG58)

(= (exp02-seed-rule-components seed-73 rr0) (exp02-factored-unplanted-rule-components seed-73 rr0))
(= (exp02-seed-rule-components seed-73 rr1) (exp02-factored-unplanted-rule-components seed-73 rr1))
(= (exp02-seed-rule-components seed-73 rr2) (exp02-factored-unplanted-rule-components seed-73 rr2))
(= (exp02-seed-rule-components seed-73 rr3) (exp02-factored-unplanted-rule-components seed-73 rr3))
(= (exp02-seed-rule-components seed-73 rr4) (exp02-factored-unplanted-rule-components seed-73 rr4))
(= (exp02-seed-rule-components seed-73 rr5) (exp02-factored-unplanted-rule-components seed-73 rr5))
(= (exp02-seed-rule-components seed-73 rr6) (exp02-factored-unplanted-rule-components seed-73 rr6))
(= (exp02-seed-rule-components seed-73 rr7) (exp02-factored-unplanted-rule-components seed-73 rr7))

(= (exp02-seed-73-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-73 $family)))

(= (exp02-seed-73-active-count $family)
   (active-acs-count-28 (exp02-seed-73-acs-candidates $family)))

(= (exp02-seed-73-generated-negative-control?)
   (and (== (exp02-seed-73-active-count random-polymer) 0)
        (and (== (exp02-seed-73-active-count shuffled-catalysts) 0)
             (== (exp02-seed-73-active-count no-catalysis) 0))))

(= (exp02-run-config seed-73-random)
   (make-run-config exp02-seed-73-rules-8-random exp02 (seed-73) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-73-shuffled)
   (make-run-config exp02-seed-73-rules-8-shuffled exp02 (seed-73) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-73-no-catalysis)
   (make-run-config exp02-seed-73-rules-8-no-catalysis exp02 (seed-73) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-73-random)
   (make-run-manifest exp02-seed-73-rules-8-random config-hash-exp02-seed-73-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-73-shuffled)
   (make-run-manifest exp02-seed-73-rules-8-shuffled config-hash-exp02-seed-73-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-73-no-catalysis)
   (make-run-manifest exp02-seed-73-rules-8-no-catalysis config-hash-exp02-seed-73-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-73-random)
   ((metric active-acs-count exp02-seed-73-rules-8-random (exp02-seed-73-active-count random-polymer))
    (metric control-family exp02-seed-73-rules-8-random random-polymer)
    (metric rule-count exp02-seed-73-rules-8-random 8)
    (metric generation-seam exp02-seed-73-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-73-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-73-shuffled)
   ((metric active-acs-count exp02-seed-73-rules-8-shuffled (exp02-seed-73-active-count shuffled-catalysts))
    (metric control-family exp02-seed-73-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-73-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-73-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-73-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-73-no-catalysis)
   ((metric active-acs-count exp02-seed-73-rules-8-no-catalysis (exp02-seed-73-active-count no-catalysis))
    (metric control-family exp02-seed-73-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-73-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-73-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-73-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-73-random)
   (make-run-summary exp02-seed-73-rules-8-random passed seed-73-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-73-shuffled)
   (make-run-summary exp02-seed-73-rules-8-shuffled passed seed-73-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-73-no-catalysis)
   (make-run-summary exp02-seed-73-rules-8-no-catalysis passed seed-73-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-73-random)
   (make-run-record exp02-seed-73-rules-8-random (exp02-run-config seed-73-random) (exp02-run-manifest seed-73-random) () (exp02-initial-abundances) (exp02-metrics seed-73-random) (exp02-seed-73-acs-candidates random-polymer) () (exp02-run-summary seed-73-random)))

(= (exp02-run-record seed-73-shuffled)
   (make-run-record exp02-seed-73-rules-8-shuffled (exp02-run-config seed-73-shuffled) (exp02-run-manifest seed-73-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-73-shuffled) (exp02-seed-73-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-73-shuffled)))

(= (exp02-run-record seed-73-no-catalysis)
   (make-run-record exp02-seed-73-rules-8-no-catalysis (exp02-run-config seed-73-no-catalysis) (exp02-run-manifest seed-73-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-73-no-catalysis) (exp02-seed-73-acs-candidates no-catalysis) () (exp02-run-summary seed-73-no-catalysis)))




; seed-79 adds the next factored-template generated-unplanted point through
; the same PeTTa-side token/product dictionary seam.  The point broadens the
; host-swept negative-control batch without changing the chemistry kernel path.

(= (exp02-seed-token seed-79 0) ZH0)
(= (exp02-seed-token seed-79 1) ZH1)
(= (exp02-seed-token seed-79 2) ZH2)
(= (exp02-seed-token seed-79 3) ZH3)
(= (exp02-seed-token seed-79 4) ZH4)
(= (exp02-seed-token seed-79 5) ZH5)
(= (exp02-seed-token seed-79 6) ZH6)
(= (exp02-seed-token seed-79 7) ZH7)
(= (exp02-seed-token seed-79 8) ZH8)
(= (exp02-seed-token seed-79 9) ZH9)

(= (exp02-seed-product seed-79 01) ZH01)
(= (exp02-seed-product seed-79 23) ZH23)
(= (exp02-seed-product seed-79 45) ZH45)
(= (exp02-seed-product seed-79 67) ZH67)
(= (exp02-seed-product seed-79 89) ZH89)
(= (exp02-seed-product seed-79 14) ZH14)
(= (exp02-seed-product seed-79 36) ZH36)
(= (exp02-seed-product seed-79 58) ZH58)

(= (exp02-seed-rule-components seed-79 rr0) (exp02-factored-unplanted-rule-components seed-79 rr0))
(= (exp02-seed-rule-components seed-79 rr1) (exp02-factored-unplanted-rule-components seed-79 rr1))
(= (exp02-seed-rule-components seed-79 rr2) (exp02-factored-unplanted-rule-components seed-79 rr2))
(= (exp02-seed-rule-components seed-79 rr3) (exp02-factored-unplanted-rule-components seed-79 rr3))
(= (exp02-seed-rule-components seed-79 rr4) (exp02-factored-unplanted-rule-components seed-79 rr4))
(= (exp02-seed-rule-components seed-79 rr5) (exp02-factored-unplanted-rule-components seed-79 rr5))
(= (exp02-seed-rule-components seed-79 rr6) (exp02-factored-unplanted-rule-components seed-79 rr6))
(= (exp02-seed-rule-components seed-79 rr7) (exp02-factored-unplanted-rule-components seed-79 rr7))

(= (exp02-seed-79-acs-candidates $family)
   (exp02-scan-rules-8 (exp02-generated-rules-8 seed-79 $family)))

(= (exp02-seed-79-active-count $family)
   (active-acs-count-28 (exp02-seed-79-acs-candidates $family)))

(= (exp02-seed-79-generated-negative-control?)
   (and (== (exp02-seed-79-active-count random-polymer) 0)
        (and (== (exp02-seed-79-active-count shuffled-catalysts) 0)
             (== (exp02-seed-79-active-count no-catalysis) 0))))

(= (exp02-run-config seed-79-random)
   (make-run-config exp02-seed-79-rules-8-random exp02 (seed-79) 1 (candidate-cap 8 1) random-polymer))

(= (exp02-run-config seed-79-shuffled)
   (make-run-config exp02-seed-79-rules-8-shuffled exp02 (seed-79) 1 (candidate-cap 8 1) shuffled-catalysts))

(= (exp02-run-config seed-79-no-catalysis)
   (make-run-config exp02-seed-79-rules-8-no-catalysis exp02 (seed-79) 1 (candidate-cap 8 1) no-catalysis))

(= (exp02-run-manifest seed-79-random)
   (make-run-manifest exp02-seed-79-rules-8-random config-hash-exp02-seed-79-rules-8-random petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-79-shuffled)
   (make-run-manifest exp02-seed-79-rules-8-shuffled config-hash-exp02-seed-79-rules-8-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-run-manifest seed-79-no-catalysis)
   (make-run-manifest exp02-seed-79-rules-8-no-catalysis config-hash-exp02-seed-79-rules-8-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0))

(= (exp02-metrics seed-79-random)
   ((metric active-acs-count exp02-seed-79-rules-8-random (exp02-seed-79-active-count random-polymer))
    (metric control-family exp02-seed-79-rules-8-random random-polymer)
    (metric rule-count exp02-seed-79-rules-8-random 8)
    (metric generation-seam exp02-seed-79-rules-8-random factored-seed-template)
    (metric sweep-kind exp02-seed-79-rules-8-random generated-unplanted-control)))

(= (exp02-metrics seed-79-shuffled)
   ((metric active-acs-count exp02-seed-79-rules-8-shuffled (exp02-seed-79-active-count shuffled-catalysts))
    (metric control-family exp02-seed-79-rules-8-shuffled shuffled-catalysts)
    (metric rule-count exp02-seed-79-rules-8-shuffled 8)
    (metric generation-seam exp02-seed-79-rules-8-shuffled factored-seed-template)
    (metric sweep-kind exp02-seed-79-rules-8-shuffled generated-unplanted-control)))

(= (exp02-metrics seed-79-no-catalysis)
   ((metric active-acs-count exp02-seed-79-rules-8-no-catalysis (exp02-seed-79-active-count no-catalysis))
    (metric control-family exp02-seed-79-rules-8-no-catalysis no-catalysis)
    (metric rule-count exp02-seed-79-rules-8-no-catalysis 8)
    (metric generation-seam exp02-seed-79-rules-8-no-catalysis factored-seed-template)
    (metric sweep-kind exp02-seed-79-rules-8-no-catalysis generated-unplanted-control)))

(= (exp02-run-summary seed-79-random)
   (make-run-summary exp02-seed-79-rules-8-random passed seed-79-rules-8-generated-random-has-zero-active-pairs True))

(= (exp02-run-summary seed-79-shuffled)
   (make-run-summary exp02-seed-79-rules-8-shuffled passed seed-79-rules-8-shuffled-control-has-zero-active-pairs True))

(= (exp02-run-summary seed-79-no-catalysis)
   (make-run-summary exp02-seed-79-rules-8-no-catalysis passed seed-79-rules-8-no-catalysis-control-has-zero-active-pairs True))

(= (exp02-run-record seed-79-random)
   (make-run-record exp02-seed-79-rules-8-random (exp02-run-config seed-79-random) (exp02-run-manifest seed-79-random) () (exp02-initial-abundances) (exp02-metrics seed-79-random) (exp02-seed-79-acs-candidates random-polymer) () (exp02-run-summary seed-79-random)))

(= (exp02-run-record seed-79-shuffled)
   (make-run-record exp02-seed-79-rules-8-shuffled (exp02-run-config seed-79-shuffled) (exp02-run-manifest seed-79-shuffled) () (exp02-initial-abundances) (exp02-metrics seed-79-shuffled) (exp02-seed-79-acs-candidates shuffled-catalysts) () (exp02-run-summary seed-79-shuffled)))

(= (exp02-run-record seed-79-no-catalysis)
   (make-run-record exp02-seed-79-rules-8-no-catalysis (exp02-run-config seed-79-no-catalysis) (exp02-run-manifest seed-79-no-catalysis) () (exp02-initial-abundances) (exp02-metrics seed-79-no-catalysis) (exp02-seed-79-acs-candidates no-catalysis) () (exp02-run-summary seed-79-no-catalysis)))



; ----- PeTTa-side fold for sweep-kind summaries -----
;
; The first exp02 summary rows were deliberately explicit.  These helpers move
; the accounting onto tested run-record atoms so larger sweeps can extend record
; lists without retyping active-family and active-pair totals by hand.

(= (exp02-list-length $items)
   (if (== $items ())
       0
       (+ 1 (exp02-list-length (cdr-atom $items)))))

(= (exp02-metric-name (metric $name $run-id $value))
   $name)

(= (exp02-metric-value (metric $name $run-id $value))
   $value)

(= (exp02-find-metric-value $name $metrics)
   (if (== $metrics ())
       None
       (if (== (exp02-metric-name (car-atom $metrics)) $name)
           (exp02-metric-value (car-atom $metrics))
           (exp02-find-metric-value $name (cdr-atom $metrics)))))

(= (exp02-run-record-active-count $record)
   (exp02-find-metric-value active-acs-count (run-record-metrics $record)))

(= (exp02-run-record-control-family $record)
   (exp02-find-metric-value control-family (run-record-metrics $record)))

(= (exp02-active-family-record? $record)
   (> (exp02-run-record-active-count $record) 0))

(= (exp02-active-family-record-count $records)
   (if (== $records ())
       0
       (+ (if (exp02-active-family-record? (car-atom $records)) 1 0)
          (exp02-active-family-record-count (cdr-atom $records)))))

(= (exp02-active-pair-total $records)
   (if (== $records ())
       0
       (+ (exp02-run-record-active-count (car-atom $records))
          (exp02-active-pair-total (cdr-atom $records)))))

(= (exp02-active-random-point-count $records)
   (if (== $records ())
       0
       (+ (if (and (== (exp02-run-record-control-family (car-atom $records)) random-polymer)
                   (exp02-active-family-record? (car-atom $records)))
              1
              0)
          (exp02-active-random-point-count (cdr-atom $records)))))

(= (exp02-fold-sweep-kind-summary $kind $sweep-points $records)
   (make-exp02-sweep-kind-summary
      $kind
      $sweep-points
      (exp02-list-length $records)
      (exp02-active-family-record-count $records)
      (exp02-active-pair-total $records)
      (exp02-active-random-point-count $records)))

(= (exp02-planted-control-records)
   ((exp02-run-record random)
    (exp02-run-record shuffled)
    (exp02-run-record no-catalysis)
    (exp02-run-record seed-11-random)
    (exp02-run-record seed-11-shuffled)
    (exp02-run-record seed-11-no-catalysis)
    (exp02-run-record seed-13-random)
    (exp02-run-record seed-13-shuffled)
    (exp02-run-record seed-13-no-catalysis)
    (exp02-run-record seed-17-random)
    (exp02-run-record seed-17-shuffled)
    (exp02-run-record seed-17-no-catalysis)))

(= (exp02-generated-unplanted-control-records)
   ((exp02-run-record seed-19-random)
    (exp02-run-record seed-19-shuffled)
    (exp02-run-record seed-19-no-catalysis)
    (exp02-run-record seed-23-random)
    (exp02-run-record seed-23-shuffled)
    (exp02-run-record seed-23-no-catalysis)
    (exp02-run-record seed-29-random)
    (exp02-run-record seed-29-shuffled)
    (exp02-run-record seed-29-no-catalysis)
    (exp02-run-record seed-31-random)
    (exp02-run-record seed-31-shuffled)
    (exp02-run-record seed-31-no-catalysis)
    (exp02-run-record seed-37-random)
    (exp02-run-record seed-37-shuffled)
    (exp02-run-record seed-37-no-catalysis)
    (exp02-run-record seed-41-random)
    (exp02-run-record seed-41-shuffled)
    (exp02-run-record seed-41-no-catalysis)
    (exp02-run-record seed-43-random)
    (exp02-run-record seed-43-shuffled)
    (exp02-run-record seed-43-no-catalysis)
    (exp02-run-record seed-47-random)
    (exp02-run-record seed-47-shuffled)
    (exp02-run-record seed-47-no-catalysis)
    (exp02-run-record seed-53-random)
    (exp02-run-record seed-53-shuffled)
    (exp02-run-record seed-53-no-catalysis)
    (exp02-run-record seed-59-random)
    (exp02-run-record seed-59-shuffled)
    (exp02-run-record seed-59-no-catalysis)
    (exp02-run-record seed-61-random)
    (exp02-run-record seed-61-shuffled)
    (exp02-run-record seed-61-no-catalysis)
    (exp02-run-record seed-67-random)
    (exp02-run-record seed-67-shuffled)
    (exp02-run-record seed-67-no-catalysis)
    (exp02-run-record seed-71-random)
    (exp02-run-record seed-71-shuffled)
    (exp02-run-record seed-71-no-catalysis)
    (exp02-run-record seed-73-random)
    (exp02-run-record seed-73-shuffled)
    (exp02-run-record seed-73-no-catalysis)
    (exp02-run-record seed-79-random)
    (exp02-run-record seed-79-shuffled)
    (exp02-run-record seed-79-no-catalysis)))

(= (make-exp02-sweep-kind-summary
      $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points)
   (exp02-sweep-kind-summary
      $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points))

(= (exp02-sweep-kind-active-pair-rate $kind $active-family-records $family-records)
   (active-pair-rate $kind $active-family-records $family-records))

(= (exp02-planted-control-summary)
   (exp02-fold-sweep-kind-summary
      planted-reciprocal-pair-control 4 (exp02-planted-control-records)))

(= (exp02-generated-unplanted-control-summary)
   (exp02-fold-sweep-kind-summary
      generated-unplanted-control 15 (exp02-generated-unplanted-control-records)))

(= (exp02-sweep-kind-summaries)
   ((exp02-planted-control-summary)
    (exp02-generated-unplanted-control-summary)
    (exp02-sweep-kind-active-pair-rate planted-reciprocal-pair-control 4 12)
    (exp02-sweep-kind-active-pair-rate generated-unplanted-control 0 45)))

(= (make-exp02-summary-row
      $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points $rate)
   (exp02-summary-row
      $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points $rate))

(= (exp02-summary-kind
      (exp02-sweep-kind-summary $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points))
   $kind)

(= (exp02-summary-sweep-points
      (exp02-sweep-kind-summary $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points))
   $sweep-points)

(= (exp02-summary-family-records
      (exp02-sweep-kind-summary $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points))
   $family-records)

(= (exp02-summary-active-family-records
      (exp02-sweep-kind-summary $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points))
   $active-family-records)

(= (exp02-summary-active-pair-total
      (exp02-sweep-kind-summary $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points))
   $active-pair-total)

(= (exp02-summary-active-random-points
      (exp02-sweep-kind-summary $kind $sweep-points $family-records $active-family-records $active-pair-total $active-random-points))
   $active-random-points)

(= (exp02-summary-row-from-summary $summary)
   (make-exp02-summary-row
      (exp02-summary-kind $summary)
      (exp02-summary-sweep-points $summary)
      (exp02-summary-family-records $summary)
      (exp02-summary-active-family-records $summary)
      (exp02-summary-active-pair-total $summary)
      (exp02-summary-active-random-points $summary)
      (active-pair-rate
         (exp02-summary-kind $summary)
         (exp02-summary-active-family-records $summary)
         (exp02-summary-family-records $summary))))

(= (exp02-sweep-kind-summary-report)
   ((exp02-summary-row-from-summary (exp02-planted-control-summary))
    (exp02-summary-row-from-summary (exp02-generated-unplanted-control-summary))
    (exp02-summary-note conservative-reciprocal-product-as-catalyst-pairs-only)
    (exp02-summary-note no-spontaneous-emergence-claim-yet)))

(= (exp02-sweep-kind-report-complete?)
   (== (exp02-sweep-kind-summary-report)
       ((exp02-summary-row planted-reciprocal-pair-control 4 12 4 7 4 (active-pair-rate planted-reciprocal-pair-control 4 12))
        (exp02-summary-row generated-unplanted-control 15 45 0 0 0 (active-pair-rate generated-unplanted-control 0 45))
        (exp02-summary-note conservative-reciprocal-product-as-catalyst-pairs-only)
        (exp02-summary-note no-spontaneous-emergence-claim-yet))))

(= (make-exp02-sweep-point $seed $rule-count $families)
   (exp02-sweep-point $seed $rule-count $families))

(= (exp02-sweep-point-seed (exp02-sweep-point $seed $rule-count $families))
   $seed)

(= (exp02-sweep-point-rule-count (exp02-sweep-point $seed $rule-count $families))
   $rule-count)

(= (exp02-sweep-point-families (exp02-sweep-point $seed $rule-count $families))
   $families)

(= (exp02-family-keys)
   (random-polymer shuffled-catalysts no-catalysis))

(= (exp02-systematic-sweep-points)
   ((make-exp02-sweep-point seed-7 4 (exp02-family-keys))
    (make-exp02-sweep-point seed-11 6 (exp02-family-keys))
    (make-exp02-sweep-point seed-13 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-17 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-19 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-23 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-29 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-31 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-37 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-41 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-43 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-47 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-53 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-59 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-61 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-67 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-71 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-73 8 (exp02-family-keys))
    (make-exp02-sweep-point seed-79 8 (exp02-family-keys))))

(= (exp02-broadened-run-records)
   ((exp02-run-record random)
    (exp02-run-record shuffled)
    (exp02-run-record no-catalysis)
    (exp02-run-record seed-11-random)
    (exp02-run-record seed-11-shuffled)
    (exp02-run-record seed-11-no-catalysis)
    (exp02-run-record seed-13-random)
    (exp02-run-record seed-13-shuffled)
    (exp02-run-record seed-13-no-catalysis)
    (exp02-run-record seed-17-random)
    (exp02-run-record seed-17-shuffled)
    (exp02-run-record seed-17-no-catalysis)
    (exp02-run-record seed-19-random)
    (exp02-run-record seed-19-shuffled)
    (exp02-run-record seed-19-no-catalysis)
    (exp02-run-record seed-23-random)
    (exp02-run-record seed-23-shuffled)
    (exp02-run-record seed-23-no-catalysis)
    (exp02-run-record seed-29-random)
    (exp02-run-record seed-29-shuffled)
    (exp02-run-record seed-29-no-catalysis)
    (exp02-run-record seed-31-random)
    (exp02-run-record seed-31-shuffled)
    (exp02-run-record seed-31-no-catalysis)
    (exp02-run-record seed-37-random)
    (exp02-run-record seed-37-shuffled)
    (exp02-run-record seed-37-no-catalysis)
    (exp02-run-record seed-41-random)
    (exp02-run-record seed-41-shuffled)
    (exp02-run-record seed-41-no-catalysis)
    (exp02-run-record seed-43-random)
    (exp02-run-record seed-43-shuffled)
    (exp02-run-record seed-43-no-catalysis)
    (exp02-run-record seed-47-random)
    (exp02-run-record seed-47-shuffled)
    (exp02-run-record seed-47-no-catalysis)
    (exp02-run-record seed-53-random)
    (exp02-run-record seed-53-shuffled)
    (exp02-run-record seed-53-no-catalysis)
    (exp02-run-record seed-59-random)
    (exp02-run-record seed-59-shuffled)
    (exp02-run-record seed-59-no-catalysis)
    (exp02-run-record seed-61-random)
    (exp02-run-record seed-61-shuffled)
    (exp02-run-record seed-61-no-catalysis)
    (exp02-run-record seed-67-random)
    (exp02-run-record seed-67-shuffled)
    (exp02-run-record seed-67-no-catalysis)
    (exp02-run-record seed-71-random)
    (exp02-run-record seed-71-shuffled)
    (exp02-run-record seed-71-no-catalysis)
    (exp02-run-record seed-73-random)
    (exp02-run-record seed-73-shuffled)
    (exp02-run-record seed-73-no-catalysis)
    (exp02-run-record seed-79-random)
    (exp02-run-record seed-79-shuffled)
    (exp02-run-record seed-79-no-catalysis)))

(= (exp02-systematic-sweep-run-records)
   (exp02-broadened-run-records))

(= (exp02-systematic-sweep-record-count)
   57)

(= (exp02-systematic-sweep-complete?)
   (and (== (exp02-systematic-sweep-record-count) 57)
        (and (== (exp02-sweep-point-rule-count (make-exp02-sweep-point seed-13 8 (exp02-family-keys))) 8)
             (and (exp02-small-sweep-discriminates?)
                  (and (exp02-seed-11-sweep-discriminates?)
                       (and (exp02-seed-13-sweep-discriminates?)
                            (and (exp02-seed-17-sweep-discriminates?)
                                 (and (exp02-seed-19-generated-negative-control?)
                                      (and (exp02-seed-23-generated-negative-control?)
                                           (and (exp02-seed-29-generated-negative-control?)
                                                (and (exp02-seed-31-generated-negative-control?)
                                                     (and (exp02-seed-37-generated-negative-control?)
                                                          (and (exp02-seed-41-generated-negative-control?)
                                                               (and (exp02-seed-43-generated-negative-control?)
                                                                    (and (exp02-seed-47-generated-negative-control?)
                                                                    (and (exp02-seed-53-generated-negative-control?)
                                                                    (and (exp02-seed-59-generated-negative-control?)
                                                                    (and (exp02-seed-61-generated-negative-control?)
                                                                    (and (exp02-seed-67-generated-negative-control?)
                                                                    (and (exp02-seed-71-generated-negative-control?)
                                                                    (and (exp02-seed-73-generated-negative-control?)
                                                                    (and (exp02-seed-79-generated-negative-control?)
                                                                         (exp02-sweep-kind-report-complete?)))))))))))))))))))))))

(= (exp02-broadened-sweep-complete?)
   (and (exp02-parameterized-sweep-complete?)
        (and (run-record-passed? (exp02-run-record seed-13-random))
             (and (run-record-passed? (exp02-run-record seed-13-shuffled))
                  (and (run-record-passed? (exp02-run-record seed-13-no-catalysis))
                       (and (run-record-passed? (exp02-run-record seed-17-random))
                            (and (run-record-passed? (exp02-run-record seed-17-shuffled))
                                 (and (run-record-passed? (exp02-run-record seed-17-no-catalysis))
                                      (and (run-record-passed? (exp02-run-record seed-19-random))
                                           (and (run-record-passed? (exp02-run-record seed-19-shuffled))
                                                (and (run-record-passed? (exp02-run-record seed-19-no-catalysis))
                                                     (and (run-record-passed? (exp02-run-record seed-23-random))
                                                          (and (run-record-passed? (exp02-run-record seed-23-shuffled))
                                                               (and (run-record-passed? (exp02-run-record seed-23-no-catalysis))
                                                                    (and (run-record-passed? (exp02-run-record seed-31-random))
                                                                         (exp02-systematic-sweep-complete?))))))))))))))))
