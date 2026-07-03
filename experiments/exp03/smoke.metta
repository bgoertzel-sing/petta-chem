!(import! &self ../../src/chem_exp00.metta)
!(import! &self ../../src/chem_exp01.metta)
!(import! &self ../../src/run_contract.metta)
!(import! &self ../../src/chem_exp02.metta)
!(import! &self ../../src/chem_dynamics.metta)

!(test (append-event () (event 0 r0 A B AB Cat))
       ((event 0 r0 A B AB Cat)))

!(test (append-event ((event 0 r0 A B AB Cat)) (event 1 r0 A B AB Cat))
       ((event 0 r0 A B AB Cat) (event 1 r0 A B AB Cat)))

!(test (state-abundance-snapshot
         (state 2 seed-7 (mol A 3) (mol B 3) (mol AB 2) (mol Cat 1)))
       (abundance-snapshot 2 ((mol A 3) (mol B 3) (mol AB 2) (mol Cat 1))))

!(test (chamber-abundance-snapshot (exp03-initial-chamber seed-7))
       (abundance-snapshot 0 ((mol A 5) (mol B 5) (mol AB 0) (mol Cat 1))))

!(test (chamber-event-log (exp03-initial-chamber seed-7)) ())

!(test (chamber-run (exp03-initial-chamber seed-7) 0)
       (exp03-initial-chamber seed-7))

!(test (exp03-selected-candidate-at 0 seed-7)
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (exp03-selected-candidate-at 1 seed-7)
       (candidate 1 (rule r1 B Cat BCat A) 1))

!(test (exp03-selectable-rule-pool-ok?) True)

!(test (chamber-run-1 (exp03-initial-chamber seed-7))
       (chamber exp03
                (state 1 seed-7 (mol A 4) (mol B 4) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat))
                ((event 0 r0 A B AB Cat))))

!(test (exp03-after-5 seed-7)
       (chamber exp03
                (state 5 seed-7 (mol A 2) (mol B 2) (mol AB 3) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat))
                ((event 0 r0 A B AB Cat)
                 (event 2 r0 A B AB Cat)
                 (event 4 r0 A B AB Cat))))

!(test (state-tick (chamber-state (exp03-after-5 seed-7))) 5)

!(test (chamber-run (exp03-initial-chamber seed-7) 5)
       (exp03-after-5 seed-7))

!(test (chamber-abundance-snapshot (exp03-after-5 seed-7))
       (abundance-snapshot 5 ((mol A 2) (mol B 2) (mol AB 3) (mol Cat 1))))

!(test (trace-events (exp03-after-5 seed-7))
       ((event 0 r0 A B AB Cat)
        (event 2 r0 A B AB Cat)
        (event 4 r0 A B AB Cat)))

!(test (event-count (trace-events (exp03-after-5 seed-7))) 3)

!(test (exp03-starved-after-3 seed-7)
       (chamber exp03-starved
                (state 3 seed-7 (mol A 0) (mol B 1) (mol AB 0) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat))
                ()))

!(test (state-tick (chamber-state (exp03-starved-after-3 seed-7))) 3)

!(test (event-count (trace-events (exp03-starved-after-3 seed-7))) 0)

!(test (exp03-replay-5-ok?) True)

!(test (exp03-exp02-after-3 random seed-7)
       (chamber (exp03-exp02 random)
                (state 3 seed-7 (mol P0 0) (mol P1 0) (mol P01 2) (mol P10 1))
                ((rule rr1 P2 P3 P10 P01)
                 (rule rr0 P0 P1 P01 P10))
                ((event 0 rr0 P0 P1 P01 P10)
                 (event 2 rr0 P0 P1 P01 P10))))

!(test (exp03-exp02-event-count random seed-7) 2)

!(test (exp03-exp02-event-count shuffled seed-7) 0)

!(test (exp03-exp02-event-count no-catalysis seed-7) 0)

!(test (exp03-exp02-dynamic-controls-discriminate?) True)

!(test (exp03-exp02-after-3 random seed-11)
       (chamber (exp03-exp02 random seed-11)
                (state 3 seed-11 (mol Q0 0) (mol Q1 0) (mol Q01 2) (mol Q10 1))
                ((rule rr1 Q2 Q3 Q10 Q01)
                 (rule rr0 Q0 Q1 Q01 Q10))
                ((event 0 rr0 Q0 Q1 Q01 Q10)
                 (event 2 rr0 Q0 Q1 Q01 Q10))))

!(test (exp03-exp02-event-count random seed-11) 2)

!(test (exp03-exp02-event-count shuffled seed-11) 0)

!(test (exp03-exp02-event-count no-catalysis seed-11) 0)

!(test (exp03-exp02-dynamic-controls-discriminate-seed-11?) True)

!(test (run-record-passed? (exp03-exp02-dynamic-run-record seed-11 random)) True)

!(test (run-record-events (exp03-exp02-dynamic-run-record seed-11 random))
       ((event 0 rr0 Q0 Q1 Q01 Q10)
        (event 2 rr0 Q0 Q1 Q01 Q10)))

!(test (run-record-abundances (exp03-exp02-dynamic-run-record seed-11 shuffled))
       ((abundance-snapshot 0 ((mol Q0 2) (mol Q1 2) (mol Q01 0) (mol Q10 1)))
        (abundance-snapshot 3 ((mol Q0 2) (mol Q1 2) (mol Q01 0) (mol Q10 1)))))

!(test (exp03-exp02-dynamic-run-records-complete-seed-11?) True)

!(test (exp03-exp02-full-source-capped-pool random seed-7)
       (candidate-pool
         0
         ((candidate 0 (rule rr1 P2 P3 P10 P01) 1)
          (candidate 0 (rule rr0 P0 P1 P01 P10) 1))))

!(test (exp03-exp02-full-source-after-3 random seed-7)
       (chamber (exp03-exp02-full-source random seed-7)
                (state 3 seed-7 (mol P0 0) (mol P1 0) (mol P01 2) (mol P10 1))
                ((rule rr1 P2 P3 P10 P01)
                 (rule rr0 P0 P1 P01 P10)
                 (rule rr2 P0 P3 P03 P2)
                 (rule rr3 P1 P2 P12 P0))
                ((event 0 rr0 P0 P1 P01 P10)
                 (event 2 rr0 P0 P1 P01 P10))))

!(test (exp03-exp02-full-source-event-count random seed-7) 2)

!(test (exp03-exp02-full-source-event-count shuffled seed-7) 0)

!(test (exp03-exp02-full-source-event-count no-catalysis seed-7) 0)

!(test (exp03-exp02-full-source-controls-discriminate?) True)

!(test (exp03-exp02-full-source-replay-ok?) True)

!(test (run-record-events (exp03-exp02-full-source-run-record seed-7 random))
       ((event 0 rr0 P0 P1 P01 P10)
        (event 2 rr0 P0 P1 P01 P10)))

!(test (exp03-exp02-full-source-run-record-complete?) True)

!(test (exp03-exp02-full-source-capped-pool random-polymer seed-13)
       (candidate-pool
         0
         ((candidate 0 (rule rr1 R2 R3 R10 R01) 1)
          (candidate 0 (rule rr0 R0 R1 R01 R10) 1))))

!(test (exp03-exp02-full-source-after-3 random-polymer seed-13)
       (chamber (exp03-exp02-full-source random-polymer seed-13)
                (state 3 seed-13 (mol R0 0) (mol R1 0) (mol R01 2) (mol R10 1))
                ((rule rr1 R2 R3 R10 R01)
                 (rule rr0 R0 R1 R01 R10)
                 (rule rr2 R4 R5 R45 R54)
                 (rule rr3 R6 R7 R54 R45)
                 (rule rr4 R8 R9 R89 R2)
                 (rule rr5 R0 R5 R05 R3)
                 (rule rr6 R1 R6 R16 R5)
                 (rule rr7 R2 R7 R27 R9))
                ((event 0 rr0 R0 R1 R01 R10)
                 (event 2 rr0 R0 R1 R01 R10))))

!(test (exp03-exp02-full-source-event-count random-polymer seed-13) 2)

!(test (exp03-exp02-full-source-event-count shuffled-catalysts seed-13) 0)

!(test (exp03-exp02-full-source-event-count no-catalysis seed-13) 0)

!(test (exp03-exp02-full-source-controls-discriminate-seed-13?) True)

!(test (exp03-exp02-full-source-replay-ok-seed-13?) True)

!(test (run-record-events (exp03-exp02-full-source-run-record seed-13 random-polymer))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 2 rr0 R0 R1 R01 R10)))

!(test (run-record-abundances (exp03-exp02-full-source-run-record seed-13 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol R0 2) (mol R1 2) (mol R01 0) (mol R10 1)))
        (abundance-snapshot 3 ((mol R0 2) (mol R1 2) (mol R01 0) (mol R10 1)))))

!(test (exp03-exp02-full-source-run-records-complete-seed-13?) True)


!(test (exp03-exp02-full-source-capped-pool random-polymer seed-17)
       (candidate-pool
         0
         ((candidate 0 (rule rr1 S2 S3 S10 S01) 1)
          (candidate 0 (rule rr0 S0 S1 S01 S10) 1))))

!(test (exp03-exp02-full-source-after-3 random-polymer seed-17)
       (chamber (exp03-exp02-full-source random-polymer seed-17)
                (state 3 seed-17 (mol S0 0) (mol S1 0) (mol S01 2) (mol S10 1))
                ((rule rr1 S2 S3 S10 S01)
                 (rule rr0 S0 S1 S01 S10)
                 (rule rr2 S4 S5 S45 S54)
                 (rule rr3 S6 S7 S54 S45)
                 (rule rr4 S8 S9 S89 S2)
                 (rule rr5 S0 S5 S05 S3)
                 (rule rr6 S1 S6 S16 S5)
                 (rule rr7 S2 S7 S27 S9))
                ((event 0 rr0 S0 S1 S01 S10)
                 (event 2 rr0 S0 S1 S01 S10))))

!(test (exp03-exp02-full-source-event-count random-polymer seed-17) 2)

!(test (exp03-exp02-full-source-event-count shuffled-catalysts seed-17) 0)

!(test (exp03-exp02-full-source-event-count no-catalysis seed-17) 0)

!(test (exp03-exp02-full-source-controls-discriminate-seed-17?) True)

!(test (exp03-exp02-full-source-replay-ok-seed-17?) True)

!(test (run-record-events (exp03-exp02-full-source-run-record seed-17 random-polymer))
       ((event 0 rr0 S0 S1 S01 S10)
        (event 2 rr0 S0 S1 S01 S10)))

!(test (run-record-abundances (exp03-exp02-full-source-run-record seed-17 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol S0 2) (mol S1 2) (mol S01 0) (mol S10 1)))
        (abundance-snapshot 3 ((mol S0 2) (mol S1 2) (mol S01 0) (mol S10 1)))))

!(test (run-record-metrics (exp03-exp02-full-source-run-record seed-17 random-polymer))
       ((metric dynamic-event-count exp03-exp02-seed-17-full-source-random 2)
        (metric source-exp02-rule-count exp03-exp02-seed-17-full-source-random 8)
        (metric dynamic-candidate-cap exp03-exp02-seed-17-full-source-random 2)
        (metric generation-seam exp03-exp02-seed-17-full-source-random seed-to-components)))

!(test (exp03-exp02-full-source-run-records-complete-seed-17?) True)
