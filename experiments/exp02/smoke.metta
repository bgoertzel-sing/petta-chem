!(import! &self ../../src/chem_exp01.metta)
!(import! &self ../../src/run_contract.metta)
!(import! &self ../../src/chem_exp02.metta)

!(test (exp02-random-polymer-rules seed-7)
       ((rule rr0 P0 P1 P01 P10)
        (rule rr1 P2 P3 P10 P01)
        (rule rr2 P0 P3 P03 P2)
        (rule rr3 P1 P2 P12 P0)))

!(test (exp02-shuffled-control-rules seed-7)
       ((rule sr0 P0 P1 P01 P2)
        (rule sr1 P2 P3 P10 P0)
        (rule sr2 P0 P3 P03 P10)
        (rule sr3 P1 P2 P12 P3)))

!(test (exp02-no-catalysis-control-rules seed-7)
       ((rule nr0 P0 P1 P01 None)
        (rule nr1 P2 P3 P10 None)
        (rule nr2 P0 P3 P03 None)
        (rule nr3 P1 P2 P12 None)))

!(test (exp02-random-acs-candidates seed-7)
       ((acs-candidate
          pair-0-1
          ((rule rr0 P0 P1 P01 P10) (rule rr1 P2 P3 P10 P01))
          (P01 P10)
          (P10 P01)
          active)
        (acs-candidate
          pair-0-2
          ((rule rr0 P0 P1 P01 P10) (rule rr2 P0 P3 P03 P2))
          (P01 P03)
          (P10 P2)
          rejected)
        (acs-candidate
          pair-0-3
          ((rule rr0 P0 P1 P01 P10) (rule rr3 P1 P2 P12 P0))
          (P01 P12)
          (P10 P0)
          rejected)
        (acs-candidate
          pair-1-2
          ((rule rr1 P2 P3 P10 P01) (rule rr2 P0 P3 P03 P2))
          (P10 P03)
          (P01 P2)
          rejected)
        (acs-candidate
          pair-1-3
          ((rule rr1 P2 P3 P10 P01) (rule rr3 P1 P2 P12 P0))
          (P10 P12)
          (P01 P0)
          rejected)
        (acs-candidate
          pair-2-3
          ((rule rr2 P0 P3 P03 P2) (rule rr3 P1 P2 P12 P0))
          (P03 P12)
          (P2 P0)
          rejected)))

!(test (exp02-random-active-count seed-7) 1)

!(test (exp02-shuffled-active-count seed-7) 0)

!(test (exp02-no-catalysis-active-count seed-7) 0)

!(test (exp02-small-sweep-discriminates?) True)

!(test (exp02-run-config random)
       (run-config exp02-small-random exp02 (seed-7) 1 (candidate-cap 4 1) random-polymer))

!(test (exp02-run-config shuffled)
       (run-config exp02-small-shuffled exp02 (seed-7) 1 (candidate-cap 4 1) shuffled-catalysts))

!(test (exp02-run-config no-catalysis)
       (run-config exp02-small-no-catalysis exp02 (seed-7) 1 (candidate-cap 4 1) no-catalysis))

!(test (exp02-metrics random)
       ((metric active-acs-count exp02-small-random 1)
        (metric control-family exp02-small-random random-polymer)))

!(test (exp02-metrics shuffled)
       ((metric active-acs-count exp02-small-shuffled 0)
        (metric control-family exp02-small-shuffled shuffled-catalysts)))

!(test (exp02-metrics no-catalysis)
       ((metric active-acs-count exp02-small-no-catalysis 0)
        (metric control-family exp02-small-no-catalysis no-catalysis)))

!(test (run-record-passed? (exp02-run-record random)) True)

!(test (run-record-passed? (exp02-run-record shuffled)) True)

!(test (run-record-passed? (exp02-run-record no-catalysis)) True)

!(test (run-record-ids-consistent? (exp02-run-record random)) True)

!(test (run-record-ids-consistent? (exp02-run-record shuffled)) True)

!(test (run-record-ids-consistent? (exp02-run-record no-catalysis)) True)

!(test (exp02-run-records)
       ((run-record
          exp02-small-random
          (run-config exp02-small-random exp02 (seed-7) 1 (candidate-cap 4 1) random-polymer)
          (run-manifest exp02-small-random config-hash-exp02-small-random petta-local swi-9-3-36 scripts-run-exp02-sh 0)
          ((event 0 rr0 P0 P1 P01 P10) (event 1 rr1 P2 P3 P10 P01))
          ((abundance-snapshot 0 ((mol P0 2) (mol P1 1) (mol P2 1) (mol P3 1) (mol P01 0) (mol P10 1))))
          ((metric active-acs-count exp02-small-random 1) (metric control-family exp02-small-random random-polymer))
          ((acs-candidate pair-0-1 ((rule rr0 P0 P1 P01 P10) (rule rr1 P2 P3 P10 P01)) (P01 P10) (P10 P01) active)
           (acs-candidate pair-0-2 ((rule rr0 P0 P1 P01 P10) (rule rr2 P0 P3 P03 P2)) (P01 P03) (P10 P2) rejected)
           (acs-candidate pair-0-3 ((rule rr0 P0 P1 P01 P10) (rule rr3 P1 P2 P12 P0)) (P01 P12) (P10 P0) rejected)
           (acs-candidate pair-1-2 ((rule rr1 P2 P3 P10 P01) (rule rr2 P0 P3 P03 P2)) (P10 P03) (P01 P2) rejected)
           (acs-candidate pair-1-3 ((rule rr1 P2 P3 P10 P01) (rule rr3 P1 P2 P12 P0)) (P10 P12) (P01 P0) rejected)
           (acs-candidate pair-2-3 ((rule rr2 P0 P3 P03 P2) (rule rr3 P1 P2 P12 P0)) (P03 P12) (P2 P0) rejected))
          ()
          (run-summary exp02-small-random passed seed-7-random-has-one-active-pair True))
        (run-record
          exp02-small-shuffled
          (run-config exp02-small-shuffled exp02 (seed-7) 1 (candidate-cap 4 1) shuffled-catalysts)
          (run-manifest exp02-small-shuffled config-hash-exp02-small-shuffled petta-local swi-9-3-36 scripts-run-exp02-sh 0)
          ()
          ((abundance-snapshot 0 ((mol P0 2) (mol P1 1) (mol P2 1) (mol P3 1) (mol P01 0) (mol P10 1))))
          ((metric active-acs-count exp02-small-shuffled 0) (metric control-family exp02-small-shuffled shuffled-catalysts))
          (exp02-shuffled-acs-candidates seed-7)
          ()
          (run-summary exp02-small-shuffled passed shuffled-control-has-zero-active-pairs True))
        (run-record
          exp02-small-no-catalysis
          (run-config exp02-small-no-catalysis exp02 (seed-7) 1 (candidate-cap 4 1) no-catalysis)
          (run-manifest exp02-small-no-catalysis config-hash-exp02-small-no-catalysis petta-local swi-9-3-36 scripts-run-exp02-sh 0)
          ()
          ((abundance-snapshot 0 ((mol P0 2) (mol P1 1) (mol P2 1) (mol P3 1) (mol P01 0) (mol P10 1))))
          ((metric active-acs-count exp02-small-no-catalysis 0) (metric control-family exp02-small-no-catalysis no-catalysis))
          (exp02-no-catalysis-acs-candidates seed-7)
          ()
          (run-summary exp02-small-no-catalysis passed no-catalysis-control-has-zero-active-pairs True))))

!(test (exp02-small-sweep-complete?) True)

!(test (exp02-random-polymer-rules seed-11)
       ((rule rr0 Q0 Q1 Q01 Q10)
        (rule rr1 Q2 Q3 Q10 Q01)
        (rule rr2 Q4 Q5 Q45 Q54)
        (rule rr3 Q6 Q7 Q54 Q45)
        (rule rr4 Q0 Q5 Q05 Q2)
        (rule rr5 Q1 Q6 Q16 Q3)))

!(test (exp02-random-active-count-6 seed-11) 2)

!(test (exp02-shuffled-active-count-6 seed-11) 0)

!(test (exp02-no-catalysis-active-count-6 seed-11) 0)

!(test (exp02-seed-11-sweep-discriminates?) True)

!(test (exp02-run-config seed-11-random)
       (run-config exp02-seed-11-rules-6-random exp02 (seed-11) 1 (candidate-cap 6 1) random-polymer))

!(test (exp02-metrics seed-11-random)
       ((metric active-acs-count exp02-seed-11-rules-6-random 2)
        (metric control-family exp02-seed-11-rules-6-random random-polymer)
        (metric rule-count exp02-seed-11-rules-6-random 6)))

!(test (run-record-passed? (exp02-run-record seed-11-random)) True)

!(test (run-record-passed? (exp02-run-record seed-11-shuffled)) True)

!(test (run-record-passed? (exp02-run-record seed-11-no-catalysis)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-11-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-11-shuffled)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-11-no-catalysis)) True)

!(test (exp02-parameterized-sweep-complete?) True)


!(test (exp02-seed-13-rules random-polymer)
       ((rule rr0 R0 R1 R01 R10)
        (rule rr1 R2 R3 R10 R01)
        (rule rr2 R4 R5 R45 R54)
        (rule rr3 R6 R7 R54 R45)
        (rule rr4 R8 R9 R89 R2)
        (rule rr5 R0 R5 R05 R3)
        (rule rr6 R1 R6 R16 R5)
        (rule rr7 R2 R7 R27 R9)))

!(test (exp02-seed-13-active-count random-polymer) 2)

!(test (exp02-seed-13-active-count shuffled-catalysts) 0)

!(test (exp02-seed-13-active-count no-catalysis) 0)

!(test (exp02-seed-13-sweep-discriminates?) True)

!(test (exp02-run-config seed-13-random)
       (run-config exp02-seed-13-rules-8-random exp02 (seed-13) 1 (candidate-cap 8 1) random-polymer))

!(test (exp02-metrics seed-13-random)
       ((metric active-acs-count exp02-seed-13-rules-8-random 2)
        (metric control-family exp02-seed-13-rules-8-random random-polymer)
        (metric rule-count exp02-seed-13-rules-8-random 8)))

!(test (run-record-passed? (exp02-run-record seed-13-random)) True)

!(test (run-record-passed? (exp02-run-record seed-13-shuffled)) True)

!(test (run-record-passed? (exp02-run-record seed-13-no-catalysis)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-13-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-13-shuffled)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-13-no-catalysis)) True)

!(test (exp02-broadened-sweep-complete?) True)
