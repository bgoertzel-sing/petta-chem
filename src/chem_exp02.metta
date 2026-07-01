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
