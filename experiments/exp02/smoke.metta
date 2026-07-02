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

!(test (exp02-seed-rule-components seed-17 rr0)
       (exp02-rule-components seed-17 rr0 S0 S1 S01 S10 S2))

!(test (exp02-rule-components-product (exp02-seed-rule-components seed-17 rr0)) S01)

!(test (exp02-generated-rules-8 seed-17 random-polymer)
       ((rule rr0 S0 S1 S01 S10)
        (rule rr1 S2 S3 S10 S01)
        (rule rr2 S4 S5 S45 S54)
        (rule rr3 S6 S7 S54 S45)
        (rule rr4 S8 S9 S89 S2)
        (rule rr5 S0 S5 S05 S3)
        (rule rr6 S1 S6 S16 S5)
        (rule rr7 S2 S7 S27 S9)))

!(test (exp02-generated-rules-8 seed-17 shuffled-catalysts)
       ((rule rr0 S0 S1 S01 S2)
        (rule rr1 S2 S3 S10 S4)
        (rule rr2 S4 S5 S45 S6)
        (rule rr3 S6 S7 S54 S8)
        (rule rr4 S8 S9 S89 S10)
        (rule rr5 S0 S5 S05 S01)
        (rule rr6 S1 S6 S16 S45)
        (rule rr7 S2 S7 S27 S54)))

!(test (exp02-seed-17-active-count random-polymer) 2)

!(test (exp02-seed-17-active-count shuffled-catalysts) 0)

!(test (exp02-seed-17-active-count no-catalysis) 0)

!(test (exp02-seed-17-sweep-discriminates?) True)

!(test (run-record-passed? (exp02-run-record seed-17-random)) True)

!(test (run-record-passed? (exp02-run-record seed-17-shuffled)) True)

!(test (run-record-passed? (exp02-run-record seed-17-no-catalysis)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-17-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-17-shuffled)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-17-no-catalysis)) True)

!(test (exp02-metrics seed-17-random)
       ((metric active-acs-count exp02-seed-17-rules-8-random 2)
        (metric control-family exp02-seed-17-rules-8-random random-polymer)
        (metric rule-count exp02-seed-17-rules-8-random 8)
        (metric generation-seam exp02-seed-17-rules-8-random seed-to-components)))

!(test (exp02-seed-rule-components seed-19 rr0)
       (exp02-rule-components seed-19 rr0 T0 T1 T01 T2 T3))

!(test (exp02-generated-rules-8 seed-19 random-polymer)
       ((rule rr0 T0 T1 T01 T2)
        (rule rr1 T2 T3 T23 T4)
        (rule rr2 T4 T5 T45 T6)
        (rule rr3 T6 T7 T67 T8)
        (rule rr4 T8 T9 T89 T0)
        (rule rr5 T1 T4 T14 T3)
        (rule rr6 T3 T6 T36 T5)
        (rule rr7 T5 T8 T58 T7)))

!(test (exp02-seed-19-active-count random-polymer) 0)

!(test (exp02-seed-19-active-count shuffled-catalysts) 0)

!(test (exp02-seed-19-active-count no-catalysis) 0)

!(test (exp02-seed-19-generated-negative-control?) True)

!(test (run-record-passed? (exp02-run-record seed-19-random)) True)

!(test (run-record-passed? (exp02-run-record seed-19-shuffled)) True)

!(test (run-record-passed? (exp02-run-record seed-19-no-catalysis)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-19-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-19-shuffled)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-19-no-catalysis)) True)

!(test (exp02-metrics seed-19-random)
       ((metric active-acs-count exp02-seed-19-rules-8-random 0)
        (metric control-family exp02-seed-19-rules-8-random random-polymer)
        (metric rule-count exp02-seed-19-rules-8-random 8)
        (metric generation-seam exp02-seed-19-rules-8-random seed-to-components)
        (metric sweep-kind exp02-seed-19-rules-8-random generated-unplanted-control)))


!(test (exp02-seed-rule-components seed-23 rr0)
       (exp02-rule-components seed-23 rr0 U0 U1 U01 U4 U5))

!(test (exp02-generated-rules-8 seed-23 random-polymer)
       ((rule rr0 U0 U1 U01 U4)
        (rule rr1 U2 U3 U23 U6)
        (rule rr2 U4 U5 U45 U8)
        (rule rr3 U6 U7 U67 U0)
        (rule rr4 U8 U9 U89 U2)
        (rule rr5 U1 U4 U14 U5)
        (rule rr6 U3 U6 U36 U7)
        (rule rr7 U5 U8 U58 U9)))

!(test (exp02-seed-23-active-count random-polymer) 0)

!(test (exp02-seed-23-active-count shuffled-catalysts) 0)

!(test (exp02-seed-23-active-count no-catalysis) 0)

!(test (exp02-seed-23-generated-negative-control?) True)

!(test (run-record-passed? (exp02-run-record seed-23-random)) True)

!(test (run-record-passed? (exp02-run-record seed-23-shuffled)) True)

!(test (run-record-passed? (exp02-run-record seed-23-no-catalysis)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-23-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-23-shuffled)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-23-no-catalysis)) True)

!(test (exp02-metrics seed-23-random)
       ((metric active-acs-count exp02-seed-23-rules-8-random 0)
        (metric control-family exp02-seed-23-rules-8-random random-polymer)
        (metric rule-count exp02-seed-23-rules-8-random 8)
        (metric generation-seam exp02-seed-23-rules-8-random seed-to-components)
        (metric sweep-kind exp02-seed-23-rules-8-random generated-unplanted-control)))


!(test (exp02-factored-unplanted-rule-components seed-29 rr0)
       (exp02-rule-components seed-29 rr0 V0 V1 V01 V6 V7))

!(test (exp02-generated-rules-8 seed-29 random-polymer)
       ((rule rr0 V0 V1 V01 V6)
        (rule rr1 V2 V3 V23 V8)
        (rule rr2 V4 V5 V45 V0)
        (rule rr3 V6 V7 V67 V2)
        (rule rr4 V8 V9 V89 V4)
        (rule rr5 V1 V4 V14 V7)
        (rule rr6 V3 V6 V36 V9)
        (rule rr7 V5 V8 V58 V1)))

!(test (exp02-generated-rules-8 seed-29 shuffled-catalysts)
       ((rule rr0 V0 V1 V01 V7)
        (rule rr1 V2 V3 V23 V9)
        (rule rr2 V4 V5 V45 V1)
        (rule rr3 V6 V7 V67 V3)
        (rule rr4 V8 V9 V89 V5)
        (rule rr5 V1 V4 V14 V8)
        (rule rr6 V3 V6 V36 V0)
        (rule rr7 V5 V8 V58 V2)))

!(test (exp02-seed-29-active-count random-polymer) 0)

!(test (exp02-seed-29-active-count shuffled-catalysts) 0)

!(test (exp02-seed-29-active-count no-catalysis) 0)

!(test (exp02-seed-29-generated-negative-control?) True)

!(test (run-record-passed? (exp02-run-record seed-29-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-29-random)) True)

!(test (exp02-factored-unplanted-rule-components seed-31 rr0)
       (exp02-rule-components seed-31 rr0 W0 W1 W01 W6 W7))

!(test (exp02-generated-rules-8 seed-31 random-polymer)
       ((rule rr0 W0 W1 W01 W6)
        (rule rr1 W2 W3 W23 W8)
        (rule rr2 W4 W5 W45 W0)
        (rule rr3 W6 W7 W67 W2)
        (rule rr4 W8 W9 W89 W4)
        (rule rr5 W1 W4 W14 W7)
        (rule rr6 W3 W6 W36 W9)
        (rule rr7 W5 W8 W58 W1)))

!(test (exp02-seed-31-active-count random-polymer) 0)

!(test (exp02-seed-31-active-count shuffled-catalysts) 0)

!(test (exp02-seed-31-active-count no-catalysis) 0)

!(test (exp02-seed-31-generated-negative-control?) True)

!(test (run-record-passed? (exp02-run-record seed-31-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-31-random)) True)


!(test (exp02-factored-unplanted-rule-components seed-37 rr0)
       (exp02-rule-components seed-37 rr0 X0 X1 X01 X6 X7))

!(test (exp02-generated-rules-8 seed-37 random-polymer)
       ((rule rr0 X0 X1 X01 X6)
        (rule rr1 X2 X3 X23 X8)
        (rule rr2 X4 X5 X45 X0)
        (rule rr3 X6 X7 X67 X2)
        (rule rr4 X8 X9 X89 X4)
        (rule rr5 X1 X4 X14 X7)
        (rule rr6 X3 X6 X36 X9)
        (rule rr7 X5 X8 X58 X1)))

!(test (exp02-seed-37-active-count random-polymer) 0)

!(test (exp02-seed-37-active-count shuffled-catalysts) 0)

!(test (exp02-seed-37-active-count no-catalysis) 0)

!(test (exp02-seed-37-generated-negative-control?) True)

!(test (run-record-passed? (exp02-run-record seed-37-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-37-random)) True)



!(test (exp02-factored-unplanted-rule-components seed-41 rr0)
       (exp02-rule-components seed-41 rr0 Y0 Y1 Y01 Y6 Y7))

!(test (exp02-generated-rules-8 seed-41 random-polymer)
       ((rule rr0 Y0 Y1 Y01 Y6)
        (rule rr1 Y2 Y3 Y23 Y8)
        (rule rr2 Y4 Y5 Y45 Y0)
        (rule rr3 Y6 Y7 Y67 Y2)
        (rule rr4 Y8 Y9 Y89 Y4)
        (rule rr5 Y1 Y4 Y14 Y7)
        (rule rr6 Y3 Y6 Y36 Y9)
        (rule rr7 Y5 Y8 Y58 Y1)))

!(test (exp02-seed-41-active-count random-polymer) 0)

!(test (exp02-seed-41-active-count shuffled-catalysts) 0)

!(test (exp02-seed-41-active-count no-catalysis) 0)

!(test (exp02-seed-41-generated-negative-control?) True)

!(test (run-record-passed? (exp02-run-record seed-41-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-41-random)) True)


!(test (exp02-factored-unplanted-rule-components seed-43 rr0)
       (exp02-rule-components seed-43 rr0 Z0 Z1 Z01 Z6 Z7))

!(test (exp02-generated-rules-8 seed-43 random-polymer)
       ((rule rr0 Z0 Z1 Z01 Z6)
        (rule rr1 Z2 Z3 Z23 Z8)
        (rule rr2 Z4 Z5 Z45 Z0)
        (rule rr3 Z6 Z7 Z67 Z2)
        (rule rr4 Z8 Z9 Z89 Z4)
        (rule rr5 Z1 Z4 Z14 Z7)
        (rule rr6 Z3 Z6 Z36 Z9)
        (rule rr7 Z5 Z8 Z58 Z1)))

!(test (exp02-seed-43-active-count random-polymer) 0)

!(test (exp02-seed-43-active-count shuffled-catalysts) 0)

!(test (exp02-seed-43-active-count no-catalysis) 0)

!(test (exp02-seed-43-generated-negative-control?) True)

!(test (run-record-passed? (exp02-run-record seed-43-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-43-random)) True)

!(test (exp02-factored-unplanted-rule-components seed-47 rr0)
       (exp02-rule-components seed-47 rr0 ZA0 ZA1 ZA01 ZA6 ZA7))

!(test (exp02-generated-rules-8 seed-47 random-polymer)
       ((rule rr0 ZA0 ZA1 ZA01 ZA6)
        (rule rr1 ZA2 ZA3 ZA23 ZA8)
        (rule rr2 ZA4 ZA5 ZA45 ZA0)
        (rule rr3 ZA6 ZA7 ZA67 ZA2)
        (rule rr4 ZA8 ZA9 ZA89 ZA4)
        (rule rr5 ZA1 ZA4 ZA14 ZA7)
        (rule rr6 ZA3 ZA6 ZA36 ZA9)
        (rule rr7 ZA5 ZA8 ZA58 ZA1)))

!(test (exp02-seed-47-active-count random-polymer) 0)

!(test (exp02-seed-47-active-count shuffled-catalysts) 0)

!(test (exp02-seed-47-active-count no-catalysis) 0)

!(test (exp02-seed-47-generated-negative-control?) True)

!(test (run-record-passed? (exp02-run-record seed-47-random)) True)

!(test (run-record-ids-consistent? (exp02-run-record seed-47-random)) True)

!(test (exp02-list-length (exp02-planted-control-records)) 12)

!(test (exp02-list-length (exp02-generated-unplanted-control-records)) 24)

!(test (exp02-active-family-record-count (exp02-planted-control-records)) 4)

!(test (exp02-active-pair-total (exp02-planted-control-records)) 7)

!(test (exp02-active-random-point-count (exp02-planted-control-records)) 4)

!(test (exp02-active-family-record-count (exp02-generated-unplanted-control-records)) 0)

!(test (exp02-active-pair-total (exp02-generated-unplanted-control-records)) 0)

!(test (exp02-sweep-kind-summaries)
       ((exp02-sweep-kind-summary planted-reciprocal-pair-control 4 12 4 7 4)
        (exp02-sweep-kind-summary generated-unplanted-control 8 24 0 0 0)
        (active-pair-rate planted-reciprocal-pair-control 4 12)
        (active-pair-rate generated-unplanted-control 0 24)))

!(test (exp02-sweep-kind-summary-report)
       ((exp02-summary-row planted-reciprocal-pair-control 4 12 4 7 4 (active-pair-rate planted-reciprocal-pair-control 4 12))
        (exp02-summary-row generated-unplanted-control 8 24 0 0 0 (active-pair-rate generated-unplanted-control 0 24))
        (exp02-summary-note conservative-reciprocal-product-as-catalyst-pairs-only)
        (exp02-summary-note no-spontaneous-emergence-claim-yet)))

!(test (exp02-sweep-kind-report-complete?) True)

!(test (exp02-systematic-sweep-points)
       ((exp02-sweep-point seed-7 4 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-11 6 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-13 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-17 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-19 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-23 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-29 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-31 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-37 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-41 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-43 8 (random-polymer shuffled-catalysts no-catalysis))
        (exp02-sweep-point seed-47 8 (random-polymer shuffled-catalysts no-catalysis))))

!(test (exp02-systematic-sweep-record-count) 36)

!(test (exp02-systematic-sweep-complete?) True)

!(test (exp02-broadened-sweep-complete?) True)
