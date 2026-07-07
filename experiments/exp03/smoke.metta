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

; ----- 10-tick smoke tests -----

!(test (exp03-after-10-tick seed-7) 10)

!(test (exp03-after-10-event-count seed-7) 5)

!(test (trace-events (exp03-after-10 seed-7))
       ((event 0 r0 A B AB Cat)
        (event 2 r0 A B AB Cat)
        (event 4 r0 A B AB Cat)
        (event 6 r0 A B AB Cat)
        (event 8 r0 A B AB Cat)))

!(test (exp03-after-10-abundances seed-7)
       (abundance-snapshot 10 ((mol A 0) (mol B 0) (mol AB 5) (mol Cat 1))))

!(test (exp03-reactant-exhausted-after-10? seed-7) True)

!(test (exp03-replay-10-ok?) True)

!(test (chamber-run (exp03-initial-chamber seed-7) 10)
       (exp03-after-10 seed-7))

; ----- 16-tick smoke tests -----

!(test (state-tick (chamber-state (exp03-longer-after-16 seed-7))) 16)

!(test (exp03-longer-event-count seed-7) 8)

!(test (trace-events (exp03-longer-after-16 seed-7))
       ((event 0 r0 A B AB Cat)
        (event 2 r0 A B AB Cat)
        (event 4 r0 A B AB Cat)
        (event 6 r0 A B AB Cat)
        (event 8 r0 A B AB Cat)
        (event 10 r0 A B AB Cat)
        (event 12 r0 A B AB Cat)
        (event 14 r0 A B AB Cat)))

!(test (exp03-longer-abundances seed-7)
       (abundance-snapshot 16 ((mol A 0) (mol B 0) (mol AB 8) (mol Cat 1))))

!(test (exp03-longer-reactant-exhausted? seed-7) True)

!(test (exp03-longer-replay-16-ok?) True)

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

!(test (run-record-events (exp03-exp02-full-source-run-record seed-7 shuffled)) ())

!(test (run-record-abundances (exp03-exp02-full-source-run-record seed-7 no-catalysis))
       ((abundance-snapshot 0 ((mol P0 2) (mol P1 2) (mol P01 0) (mol P10 1)))
        (abundance-snapshot 3 ((mol P0 2) (mol P1 2) (mol P01 0) (mol P10 1)))))

!(test (run-export-events (exp03-exp02-full-source-run-export seed-7 random))
       ((event 0 rr0 P0 P1 P01 P10)
        (event 2 rr0 P0 P1 P01 P10)))

!(test (run-export-metrics (exp03-exp02-full-source-run-export seed-7 shuffled))
       ((metric dynamic-event-count exp03-exp02-seed-7-full-source-shuffled 0)
        (metric control-family exp03-exp02-seed-7-full-source-shuffled shuffled-catalysts)
        (metric source-exp02-rule-count exp03-exp02-seed-7-full-source-shuffled 4)
        (metric dynamic-candidate-cap exp03-exp02-seed-7-full-source-shuffled 2)))

!(test (run-export-summary (exp03-exp02-full-source-run-export seed-7 no-catalysis))
       (run-summary exp03-exp02-seed-7-full-source-no-catalysis passed seed-7-no-catalysis-full-source-control-zero-events True))

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

!(test (run-export-events (exp03-exp02-full-source-run-export seed-13 no-catalysis)) ())

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

!(test (run-export-metrics (exp03-exp02-full-source-run-export seed-17 random-polymer))
       ((metric dynamic-event-count exp03-exp02-seed-17-full-source-random 2)
        (metric source-exp02-rule-count exp03-exp02-seed-17-full-source-random 8)
        (metric dynamic-candidate-cap exp03-exp02-seed-17-full-source-random 2)
        (metric generation-seam exp03-exp02-seed-17-full-source-random seed-to-components)))

!(test (exp03-exp02-full-source-run-records-complete-seed-17?) True)

!(test (exp03-dynamic-summary-row-for seed-7)
       (exp03-dynamic-summary-row seed-7 2 0 0 2 True))

!(test (exp03-dynamic-summary-row-for seed-13)
       (exp03-dynamic-summary-row seed-13 2 0 0 2 True))

!(test (exp03-dynamic-summary-row-for seed-17)
       (exp03-dynamic-summary-row seed-17 2 0 0 2 True))

!(test (exp03-dynamic-summary-rows)
       ((exp03-dynamic-summary-row seed-7 2 0 0 2 True)
        (exp03-dynamic-summary-row seed-13 2 0 0 2 True)
        (exp03-dynamic-summary-row seed-17 2 0 0 2 True)))

!(test (exp03-dynamic-aggregate-report-current)
       (exp03-dynamic-aggregate-report
         tested-full-source-exports
         (seeds seed-7 seed-13 seed-17)
         (family-records 9)
         (active-random-family-records 3)
         (zero-event-control-family-records 6)
         (total-random-events 6)
         (total-control-events 0)
         (candidate-cap 2)
         (rows ((exp03-dynamic-summary-row seed-7 2 0 0 2 True)
                (exp03-dynamic-summary-row seed-13 2 0 0 2 True)
                (exp03-dynamic-summary-row seed-17 2 0 0 2 True)))))

; ----- 10-tick exp02-family bridge tests (seed-7) -----

!(test (exp03-exp02-longer-event-count random seed-7) 5)

!(test (exp03-exp02-longer-event-count shuffled seed-7) 0)

!(test (exp03-exp02-longer-event-count no-catalysis seed-7) 0)

!(test (exp03-exp02-longer-tick random seed-7) 10)

!(test (exp03-exp02-longer-tick shuffled seed-7) 10)

!(test (exp03-exp02-longer-tick no-catalysis seed-7) 10)

!(test (exp03-exp02-longer-abundances random seed-7)
       (abundance-snapshot 10 ((mol P0 0) (mol P1 0) (mol P01 5) (mol P10 1))))

!(test (exp03-exp02-longer-abundances shuffled seed-7)
       (abundance-snapshot 10 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1))))

!(test (exp03-exp02-longer-abundances no-catalysis seed-7)
       (abundance-snapshot 10 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1))))

!(test (exp03-exp02-longer-reactant-exhausted? seed-7) True)

!(test (exp03-exp02-longer-replay-ok? random seed-7) True)

!(test (exp03-exp02-longer-replay-ok? shuffled seed-7) True)

!(test (exp03-exp02-longer-replay-ok? no-catalysis seed-7) True)

!(test (exp03-exp02-longer-controls-discriminate? seed-7) True)

!(test (trace-events (exp03-exp02-longer-after-10 random seed-7))
       ((event 0 rr0 P0 P1 P01 P10)
        (event 2 rr0 P0 P1 P01 P10)
        (event 4 rr0 P0 P1 P01 P10)
        (event 6 rr0 P0 P1 P01 P10)
        (event 8 rr0 P0 P1 P01 P10)))

!(test (trace-events (exp03-exp02-longer-after-10 shuffled seed-7)) ())

!(test (trace-events (exp03-exp02-longer-after-10 no-catalysis seed-7)) ())

!(test (run-record-events (exp03-exp02-longer-run-record seed-7 random))
       ((event 0 rr0 P0 P1 P01 P10)
        (event 2 rr0 P0 P1 P01 P10)
        (event 4 rr0 P0 P1 P01 P10)
        (event 6 rr0 P0 P1 P01 P10)
        (event 8 rr0 P0 P1 P01 P10)))

!(test (run-record-abundances (exp03-exp02-longer-run-record seed-7 random))
       ((abundance-snapshot 0 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1)))
        (abundance-snapshot 10 ((mol P0 0) (mol P1 0) (mol P01 5) (mol P10 1)))))

!(test (run-record-abundances (exp03-exp02-longer-run-record seed-7 shuffled))
       ((abundance-snapshot 0 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1)))
        (abundance-snapshot 10 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1)))))

!(test (exp03-exp02-longer-run-records-complete? seed-7) True)

; ----- 10-tick exp02-family bridge tests (seed-13) -----

!(test (exp03-exp02-longer-event-count random-polymer seed-13) 5)

!(test (exp03-exp02-longer-event-count shuffled-catalysts seed-13) 0)

!(test (exp03-exp02-longer-event-count no-catalysis seed-13) 0)

!(test (exp03-exp02-longer-tick random-polymer seed-13) 10)

!(test (exp03-exp02-longer-tick shuffled-catalysts seed-13) 10)

!(test (exp03-exp02-longer-tick no-catalysis seed-13) 10)

!(test (exp03-exp02-longer-abundances random-polymer seed-13)
       (abundance-snapshot 10 ((mol R0 0) (mol R1 0) (mol R01 5) (mol R10 1))))

!(test (exp03-exp02-longer-abundances shuffled-catalysts seed-13)
       (abundance-snapshot 10 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1))))

!(test (exp03-exp02-longer-abundances no-catalysis seed-13)
       (abundance-snapshot 10 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1))))

!(test (exp03-exp02-longer-reactant-exhausted? seed-13) True)

!(test (exp03-exp02-longer-replay-ok? random-polymer seed-13) True)

!(test (exp03-exp02-longer-replay-ok? shuffled-catalysts seed-13) True)

!(test (exp03-exp02-longer-replay-ok? no-catalysis seed-13) True)

!(test (exp03-exp02-longer-controls-discriminate? seed-13) True)

!(test (trace-events (exp03-exp02-longer-after-10 random-polymer seed-13))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 2 rr0 R0 R1 R01 R10)
        (event 4 rr0 R0 R1 R01 R10)
        (event 6 rr0 R0 R1 R01 R10)
        (event 8 rr0 R0 R1 R01 R10)))

!(test (trace-events (exp03-exp02-longer-after-10 shuffled-catalysts seed-13)) ())

!(test (trace-events (exp03-exp02-longer-after-10 no-catalysis seed-13)) ())

!(test (run-record-events (exp03-exp02-longer-run-record seed-13 random-polymer))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 2 rr0 R0 R1 R01 R10)
        (event 4 rr0 R0 R1 R01 R10)
        (event 6 rr0 R0 R1 R01 R10)
        (event 8 rr0 R0 R1 R01 R10)))

!(test (run-record-abundances (exp03-exp02-longer-run-record seed-13 random-polymer))
       ((abundance-snapshot 0 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1)))
        (abundance-snapshot 10 ((mol R0 0) (mol R1 0) (mol R01 5) (mol R10 1)))))

!(test (run-record-abundances (exp03-exp02-longer-run-record seed-13 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1)))
        (abundance-snapshot 10 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1)))))

!(test (exp03-exp02-longer-run-records-complete? seed-13) True)

; ----- 10-tick exp02-family bridge tests (seed-17) -----

!(test (exp03-exp02-longer-event-count random-polymer seed-17) 5)

!(test (exp03-exp02-longer-event-count shuffled-catalysts seed-17) 0)

!(test (exp03-exp02-longer-event-count no-catalysis seed-17) 0)

!(test (exp03-exp02-longer-tick random-polymer seed-17) 10)

!(test (exp03-exp02-longer-tick shuffled-catalysts seed-17) 10)

!(test (exp03-exp02-longer-tick no-catalysis seed-17) 10)

!(test (exp03-exp02-longer-abundances random-polymer seed-17)
       (abundance-snapshot 10 ((mol S0 0) (mol S1 0) (mol S01 5) (mol S10 1))))

!(test (exp03-exp02-longer-abundances shuffled-catalysts seed-17)
       (abundance-snapshot 10 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1))))

!(test (exp03-exp02-longer-abundances no-catalysis seed-17)
       (abundance-snapshot 10 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1))))

!(test (exp03-exp02-longer-reactant-exhausted? seed-17) True)

!(test (exp03-exp02-longer-replay-ok? random-polymer seed-17) True)

!(test (exp03-exp02-longer-replay-ok? shuffled-catalysts seed-17) True)

!(test (exp03-exp02-longer-replay-ok? no-catalysis seed-17) True)

!(test (exp03-exp02-longer-controls-discriminate? seed-17) True)

!(test (trace-events (exp03-exp02-longer-after-10 random-polymer seed-17))
       ((event 0 rr0 S0 S1 S01 S10)
        (event 2 rr0 S0 S1 S01 S10)
        (event 4 rr0 S0 S1 S01 S10)
        (event 6 rr0 S0 S1 S01 S10)
        (event 8 rr0 S0 S1 S01 S10)))

!(test (trace-events (exp03-exp02-longer-after-10 shuffled-catalysts seed-17)) ())

!(test (trace-events (exp03-exp02-longer-after-10 no-catalysis seed-17)) ())

!(test (run-record-events (exp03-exp02-longer-run-record seed-17 random-polymer))
       ((event 0 rr0 S0 S1 S01 S10)
        (event 2 rr0 S0 S1 S01 S10)
        (event 4 rr0 S0 S1 S01 S10)
        (event 6 rr0 S0 S1 S01 S10)
        (event 8 rr0 S0 S1 S01 S10)))

!(test (run-record-abundances (exp03-exp02-longer-run-record seed-17 random-polymer))
       ((abundance-snapshot 0 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1)))
        (abundance-snapshot 10 ((mol S0 0) (mol S1 0) (mol S01 5) (mol S10 1)))))

!(test (run-record-abundances (exp03-exp02-longer-run-record seed-17 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1)))
        (abundance-snapshot 10 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1)))))

!(test (exp03-exp02-longer-run-records-complete? seed-17) True)

; ----- 10-tick exp02-family bridge (seed-11) smoke tests -----

!(test (exp03-exp02-longer-event-count random seed-11) 5)
!(test (exp03-exp02-longer-event-count shuffled seed-11) 0)
!(test (exp03-exp02-longer-event-count no-catalysis seed-11) 0)

!(test (exp03-exp02-longer-tick random seed-11) 10)
!(test (exp03-exp02-longer-tick shuffled seed-11) 10)
!(test (exp03-exp02-longer-tick no-catalysis seed-11) 10)

!(test (exp03-exp02-longer-abundances random seed-11)
       (abundance-snapshot 10 ((mol Q0 0) (mol Q1 0) (mol Q01 5) (mol Q10 1))))
!(test (exp03-exp02-longer-abundances shuffled seed-11)
       (abundance-snapshot 10 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1))))
!(test (exp03-exp02-longer-abundances no-catalysis seed-11)
       (abundance-snapshot 10 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1))))

!(test (exp03-exp02-longer-reactant-exhausted? seed-11) True)

!(test (exp03-exp02-longer-replay-ok? random seed-11) True)
!(test (exp03-exp02-longer-replay-ok? shuffled seed-11) True)
!(test (exp03-exp02-longer-replay-ok? no-catalysis seed-11) True)

!(test (exp03-exp02-longer-controls-discriminate? seed-11) True)

!(test (trace-events (exp03-exp02-longer-after-10 random seed-11))
       ((event 0 rr0 Q0 Q1 Q01 Q10)
        (event 2 rr0 Q0 Q1 Q01 Q10)
        (event 4 rr0 Q0 Q1 Q01 Q10)
        (event 6 rr0 Q0 Q1 Q01 Q10)
        (event 8 rr0 Q0 Q1 Q01 Q10)))

!(test (trace-events (exp03-exp02-longer-after-10 shuffled seed-11)) ())
!(test (trace-events (exp03-exp02-longer-after-10 no-catalysis seed-11)) ())

!(test (run-record-events (exp03-exp02-longer-run-record seed-11 random))
       ((event 0 rr0 Q0 Q1 Q01 Q10)
        (event 2 rr0 Q0 Q1 Q01 Q10)
        (event 4 rr0 Q0 Q1 Q01 Q10)
        (event 6 rr0 Q0 Q1 Q01 Q10)
        (event 8 rr0 Q0 Q1 Q01 Q10)))

!(test (run-record-abundances (exp03-exp02-longer-run-record seed-11 random))
       ((abundance-snapshot 0 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1)))
        (abundance-snapshot 10 ((mol Q0 0) (mol Q1 0) (mol Q01 5) (mol Q10 1)))))

!(test (run-record-abundances (exp03-exp02-longer-run-record seed-11 shuffled))
       ((abundance-snapshot 0 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1)))
        (abundance-snapshot 10 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1)))))

!(test (exp03-exp02-longer-run-records-complete? seed-11) True)

; ----- 16-tick exp02-family bridge (seed-13) smoke tests -----

!(test (exp03-exp02-longest-event-count random-polymer seed-13) 8)
!(test (exp03-exp02-longest-event-count shuffled-catalysts seed-13) 0)
!(test (exp03-exp02-longest-event-count no-catalysis seed-13) 0)

!(test (exp03-exp02-longest-tick random-polymer seed-13) 16)
!(test (exp03-exp02-longest-tick shuffled-catalysts seed-13) 16)
!(test (exp03-exp02-longest-tick no-catalysis seed-13) 16)

!(test (exp03-exp02-longest-abundances random-polymer seed-13)
       (abundance-snapshot 16 ((mol R0 0) (mol R1 0) (mol R01 8) (mol R10 1))))
!(test (exp03-exp02-longest-abundances shuffled-catalysts seed-13)
       (abundance-snapshot 16 ((mol R0 8) (mol R1 8) (mol R01 0) (mol R10 1))))
!(test (exp03-exp02-longest-abundances no-catalysis seed-13)
       (abundance-snapshot 16 ((mol R0 8) (mol R1 8) (mol R01 0) (mol R10 1))))

!(test (exp03-exp02-longest-reactant-exhausted? seed-13) True)

!(test (exp03-exp02-longest-replay-ok? random-polymer seed-13) True)
!(test (exp03-exp02-longest-replay-ok? shuffled-catalysts seed-13) True)
!(test (exp03-exp02-longest-replay-ok? no-catalysis seed-13) True)

!(test (exp03-exp02-longest-controls-discriminate? seed-13) True)

!(test (trace-events (exp03-exp02-longest-after-16 random-polymer seed-13))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 2 rr0 R0 R1 R01 R10)
        (event 4 rr0 R0 R1 R01 R10)
        (event 6 rr0 R0 R1 R01 R10)
        (event 8 rr0 R0 R1 R01 R10)
        (event 10 rr0 R0 R1 R01 R10)
        (event 12 rr0 R0 R1 R01 R10)
        (event 14 rr0 R0 R1 R01 R10)))

!(test (trace-events (exp03-exp02-longest-after-16 shuffled-catalysts seed-13)) ())
!(test (trace-events (exp03-exp02-longest-after-16 no-catalysis seed-13)) ())

!(test (run-record-events (exp03-exp02-longest-run-record seed-13 random-polymer))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 2 rr0 R0 R1 R01 R10)
        (event 4 rr0 R0 R1 R01 R10)
        (event 6 rr0 R0 R1 R01 R10)
        (event 8 rr0 R0 R1 R01 R10)
        (event 10 rr0 R0 R1 R01 R10)
        (event 12 rr0 R0 R1 R01 R10)
        (event 14 rr0 R0 R1 R01 R10)))

!(test (run-record-abundances (exp03-exp02-longest-run-record seed-13 random-polymer))
       ((abundance-snapshot 0 ((mol R0 8) (mol R1 8) (mol R01 0) (mol R10 1)))
        (abundance-snapshot 16 ((mol R0 0) (mol R1 0) (mol R01 8) (mol R10 1)))))

!(test (run-record-abundances (exp03-exp02-longest-run-record seed-13 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol R0 8) (mol R1 8) (mol R01 0) (mol R10 1)))
        (abundance-snapshot 16 ((mol R0 8) (mol R1 8) (mol R01 0) (mol R10 1)))))

!(test (exp03-exp02-longest-run-records-complete? seed-13) True)

!(test (exp03-dynamic-aggregate-report-complete?) True)

; ---- Cap-3 bridge tests (seed-13, 15-tick, candidate cap 3) ----
;
; Cap 3 extends the per-tick pool from 2 to 3 candidates.  The deterministic
; selector cycles (13+tick)%3 = 1,2,0,1,2,0,... so rr0 (position 1) fires
; at ticks 0,3,6,9,12 for 5 productive events; rr2 (position 2) and rr1
; (position 0) are distractors.  Controls remain zero-event.

!(test (exp03-cap3-event-count random-polymer seed-13) 5)
!(test (exp03-cap3-event-count shuffled-catalysts seed-13) 0)
!(test (exp03-cap3-event-count no-catalysis seed-13) 0)

!(test (exp03-cap3-tick random-polymer seed-13) 15)
!(test (exp03-cap3-tick shuffled-catalysts seed-13) 15)
!(test (exp03-cap3-tick no-catalysis seed-13) 15)

!(test (exp03-cap3-abundances random-polymer seed-13)
       (abundance-snapshot 15 ((mol R0 0) (mol R1 0) (mol R01 5) (mol R10 1))))

!(test (exp03-cap3-abundances shuffled-catalysts seed-13)
       (abundance-snapshot 15 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1))))

!(test (exp03-cap3-abundances no-catalysis seed-13)
       (abundance-snapshot 15 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1))))

!(test (exp03-cap3-reactant-exhausted? seed-13) True)
!(test (exp03-cap3-controls-discriminate? seed-13) True)
!(test (exp03-cap3-replay-ok? random-polymer seed-13) True)
!(test (exp03-cap3-replay-ok? shuffled-catalysts seed-13) True)
!(test (exp03-cap3-replay-ok? no-catalysis seed-13) True)

!(test (trace-events (exp03-cap3-after-15 random-polymer seed-13))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 3 rr0 R0 R1 R01 R10)
        (event 6 rr0 R0 R1 R01 R10)
        (event 9 rr0 R0 R1 R01 R10)
        (event 12 rr0 R0 R1 R01 R10)))

!(test (trace-events (exp03-cap3-after-15 shuffled-catalysts seed-13)) ())
!(test (trace-events (exp03-cap3-after-15 no-catalysis seed-13)) ())

!(test (run-record-events (exp03-cap3-run-record seed-13 random-polymer))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 3 rr0 R0 R1 R01 R10)
        (event 6 rr0 R0 R1 R01 R10)
        (event 9 rr0 R0 R1 R01 R10)
        (event 12 rr0 R0 R1 R01 R10)))

!(test (run-record-abundances (exp03-cap3-run-record seed-13 random-polymer))
       ((abundance-snapshot 0 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1)))
        (abundance-snapshot 15 ((mol R0 0) (mol R1 0) (mol R01 5) (mol R10 1)))))

!(test (run-record-abundances (exp03-cap3-run-record seed-13 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1)))
        (abundance-snapshot 15 ((mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1)))))

!(test (exp03-cap3-run-records-complete? seed-13) True)

; --- Cap-3 bridge: seed-7 (4-rule P-molecule family) ---

!(test (exp03-cap3-event-count random-polymer seed-7) 5)
!(test (exp03-cap3-event-count shuffled-catalysts seed-7) 0)
!(test (exp03-cap3-event-count no-catalysis seed-7) 0)

!(test (exp03-cap3-tick random-polymer seed-7) 15)
!(test (exp03-cap3-tick shuffled-catalysts seed-7) 15)
!(test (exp03-cap3-tick no-catalysis seed-7) 15)

!(test (exp03-cap3-abundances random-polymer seed-7)
       (abundance-snapshot 15 ((mol P0 0) (mol P1 0) (mol P01 5) (mol P10 1))))
!(test (exp03-cap3-abundances shuffled-catalysts seed-7)
       (abundance-snapshot 15 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1))))
!(test (exp03-cap3-abundances no-catalysis seed-7)
       (abundance-snapshot 15 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1))))

!(test (exp03-cap3-reactant-exhausted? seed-7) True)
!(test (exp03-cap3-controls-discriminate? seed-7) True)
!(test (exp03-cap3-replay-ok? random-polymer seed-7) True)
!(test (exp03-cap3-replay-ok? shuffled-catalysts seed-7) True)
!(test (exp03-cap3-replay-ok? no-catalysis seed-7) True)

!(test (trace-events (exp03-cap3-after-15 random-polymer seed-7))
       ((event 0 rr0 P0 P1 P01 P10)
        (event 3 rr0 P0 P1 P01 P10)
        (event 6 rr0 P0 P1 P01 P10)
        (event 9 rr0 P0 P1 P01 P10)
        (event 12 rr0 P0 P1 P01 P10)))

!(test (trace-events (exp03-cap3-after-15 shuffled-catalysts seed-7)) ())
!(test (trace-events (exp03-cap3-after-15 no-catalysis seed-7)) ())

!(test (run-record-events (exp03-cap3-run-record seed-7 random-polymer))
       ((event 0 rr0 P0 P1 P01 P10)
        (event 3 rr0 P0 P1 P01 P10)
        (event 6 rr0 P0 P1 P01 P10)
        (event 9 rr0 P0 P1 P01 P10)
        (event 12 rr0 P0 P1 P01 P10)))

!(test (run-record-abundances (exp03-cap3-run-record seed-7 random-polymer))
       ((abundance-snapshot 0 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1)))
        (abundance-snapshot 15 ((mol P0 0) (mol P1 0) (mol P01 5) (mol P10 1)))))

!(test (run-record-abundances (exp03-cap3-run-record seed-7 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1)))
        (abundance-snapshot 15 ((mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1)))))

!(test (exp03-cap3-run-records-complete? seed-7) True)

; --- Cap-3 bridge: seed-17 (8-rule S-molecule family) ---

!(test (exp03-cap3-event-count random-polymer seed-17) 5)
!(test (exp03-cap3-event-count shuffled-catalysts seed-17) 0)
!(test (exp03-cap3-event-count no-catalysis seed-17) 0)

!(test (exp03-cap3-tick random-polymer seed-17) 15)
!(test (exp03-cap3-tick shuffled-catalysts seed-17) 15)
!(test (exp03-cap3-tick no-catalysis seed-17) 15)

!(test (exp03-cap3-abundances random-polymer seed-17)
       (abundance-snapshot 15 ((mol S0 0) (mol S1 0) (mol S01 5) (mol S10 1))))
!(test (exp03-cap3-abundances shuffled-catalysts seed-17)
       (abundance-snapshot 15 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1))))
!(test (exp03-cap3-abundances no-catalysis seed-17)
       (abundance-snapshot 15 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1))))

!(test (exp03-cap3-reactant-exhausted? seed-17) True)
!(test (exp03-cap3-controls-discriminate? seed-17) True)
!(test (exp03-cap3-replay-ok? random-polymer seed-17) True)
!(test (exp03-cap3-replay-ok? shuffled-catalysts seed-17) True)
!(test (exp03-cap3-replay-ok? no-catalysis seed-17) True)

!(test (trace-events (exp03-cap3-after-15 random-polymer seed-17))
       ((event 2 rr0 S0 S1 S01 S10)
        (event 5 rr0 S0 S1 S01 S10)
        (event 8 rr0 S0 S1 S01 S10)
        (event 11 rr0 S0 S1 S01 S10)
        (event 14 rr0 S0 S1 S01 S10)))

!(test (trace-events (exp03-cap3-after-15 shuffled-catalysts seed-17)) ())
!(test (trace-events (exp03-cap3-after-15 no-catalysis seed-17)) ())

!(test (run-record-events (exp03-cap3-run-record seed-17 random-polymer))
       ((event 2 rr0 S0 S1 S01 S10)
        (event 5 rr0 S0 S1 S01 S10)
        (event 8 rr0 S0 S1 S01 S10)
        (event 11 rr0 S0 S1 S01 S10)
        (event 14 rr0 S0 S1 S01 S10)))

!(test (run-record-abundances (exp03-cap3-run-record seed-17 random-polymer))
       ((abundance-snapshot 0 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1)))
        (abundance-snapshot 15 ((mol S0 0) (mol S1 0) (mol S01 5) (mol S10 1)))))

!(test (run-record-abundances (exp03-cap3-run-record seed-17 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1)))
        (abundance-snapshot 15 ((mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1)))))

!(test (exp03-cap3-run-records-complete? seed-17) True)

; --- Cap-3 bridge: seed-11 (6-rule Q-molecule family) ---

!(test (exp03-cap3-event-count random-polymer seed-11) 5)
!(test (exp03-cap3-event-count shuffled-catalysts seed-11) 0)
!(test (exp03-cap3-event-count no-catalysis seed-11) 0)

!(test (exp03-cap3-tick random-polymer seed-11) 15)
!(test (exp03-cap3-tick shuffled-catalysts seed-11) 15)
!(test (exp03-cap3-tick no-catalysis seed-11) 15)

!(test (exp03-cap3-abundances random-polymer seed-11)
       (abundance-snapshot 15 ((mol Q0 0) (mol Q1 0) (mol Q01 5) (mol Q10 1))))
!(test (exp03-cap3-abundances shuffled-catalysts seed-11)
       (abundance-snapshot 15 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1))))
!(test (exp03-cap3-abundances no-catalysis seed-11)
       (abundance-snapshot 15 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1))))

!(test (exp03-cap3-reactant-exhausted? seed-11) True)
!(test (exp03-cap3-controls-discriminate? seed-11) True)
!(test (exp03-cap3-replay-ok? random-polymer seed-11) True)
!(test (exp03-cap3-replay-ok? shuffled-catalysts seed-11) True)
!(test (exp03-cap3-replay-ok? no-catalysis seed-11) True)

!(test (trace-events (exp03-cap3-after-15 random-polymer seed-11))
       ((event 2 rr0 Q0 Q1 Q01 Q10)
        (event 5 rr0 Q0 Q1 Q01 Q10)
        (event 8 rr0 Q0 Q1 Q01 Q10)
        (event 11 rr0 Q0 Q1 Q01 Q10)
        (event 14 rr0 Q0 Q1 Q01 Q10)))

!(test (trace-events (exp03-cap3-after-15 shuffled-catalysts seed-11)) ())
!(test (trace-events (exp03-cap3-after-15 no-catalysis seed-11)) ())

!(test (run-record-events (exp03-cap3-run-record seed-11 random-polymer))
       ((event 2 rr0 Q0 Q1 Q01 Q10)
        (event 5 rr0 Q0 Q1 Q01 Q10)
        (event 8 rr0 Q0 Q1 Q01 Q10)
        (event 11 rr0 Q0 Q1 Q01 Q10)
        (event 14 rr0 Q0 Q1 Q01 Q10)))

!(test (run-record-abundances (exp03-cap3-run-record seed-11 random-polymer))
       ((abundance-snapshot 0 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1)))
        (abundance-snapshot 15 ((mol Q0 0) (mol Q1 0) (mol Q01 5) (mol Q10 1)))))

!(test (run-record-abundances (exp03-cap3-run-record seed-11 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1)))
        (abundance-snapshot 15 ((mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1)))))

!(test (exp03-cap3-run-records-complete? seed-11) True)

; ============================================================================
; Cap-3 RICH bridge smoke tests (seed-13, 10-molecule multi-rule productive state)
; ============================================================================

; Random-polymer: 9 productive events (3 rr0 + 3 rr2 + 3 rr1)
!(test (exp03-cap3-rich-event-count random-polymer seed-13) 9)
; Shuffled-catalysts: 6 productive events (3 rr0 + 3 rr1, rr2 no-op)
!(test (exp03-cap3-rich-event-count shuffled-catalysts seed-13) 6)
; No-catalysis: 0 events
!(test (exp03-cap3-rich-event-count no-catalysis seed-13) 0)

; All runs reach tick 15
!(test (exp03-cap3-rich-tick random-polymer seed-13) 15)
!(test (exp03-cap3-rich-tick shuffled-catalysts seed-13) 15)
!(test (exp03-cap3-rich-tick no-catalysis seed-13) 15)

; Random-polymer final abundances: all reactants exhausted
!(test (exp03-cap3-rich-abundances random-polymer seed-13)
       (abundance-snapshot 15 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                                (mol R4 0) (mol R5 0) (mol R01 4) (mol R10 4)
                                (mol R45 3) (mol R54 1))))
; Shuffled-catalysts: R0/R1 exhausted (rr0), R2/R3 exhausted (rr1), R4/R5 untouched (rr2 no-op)
!(test (exp03-cap3-rich-abundances shuffled-catalysts seed-13)
       (abundance-snapshot 15 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                                (mol R4 3) (mol R5 3) (mol R01 4) (mol R10 4)
                                (mol R45 0) (mol R54 1))))
; No-catalysis: unchanged from initial
!(test (exp03-cap3-rich-abundances no-catalysis seed-13)
       (abundance-snapshot 15 ((mol R0 3) (mol R1 3) (mol R2 3) (mol R3 3)
                                (mol R4 3) (mol R5 3) (mol R01 1) (mol R10 1)
                                (mol R45 0) (mol R54 1))))

; Reactant exhaustion for random
!(test (exp03-cap3-rich-reactant-exhausted? seed-13) True)
; Control discrimination: random (9) > shuffled (6) > no-catalysis (0)
!(test (exp03-cap3-rich-controls-discriminate? seed-13) True)
; Replay equivalence
!(test (exp03-cap3-rich-replay-ok? random-polymer seed-13) True)
!(test (exp03-cap3-rich-replay-ok? shuffled-catalysts seed-13) True)
!(test (exp03-cap3-rich-replay-ok? no-catalysis seed-13) True)

; Random-polymer events: 3 rounds of rr0/rr2/rr1 starting at tick 0
!(test (trace-events (exp03-cap3-rich-after-15 random-polymer seed-13))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 1 rr2 R4 R5 R45 R54)
        (event 2 rr1 R2 R3 R10 R01)
        (event 3 rr0 R0 R1 R01 R10)
        (event 4 rr2 R4 R5 R45 R54)
        (event 5 rr1 R2 R3 R10 R01)
        (event 6 rr0 R0 R1 R01 R10)
        (event 7 rr2 R4 R5 R45 R54)
        (event 8 rr1 R2 R3 R10 R01)))

; Shuffled-catalysts events: 3 rr0 + 3 rr1 (rr2 no-op, R6 absent)
!(test (trace-events (exp03-cap3-rich-after-15 shuffled-catalysts seed-13))
       ((event 0 rr0 R0 R1 R01 R2)
        (event 2 rr1 R2 R3 R10 R4)
        (event 3 rr0 R0 R1 R01 R2)
        (event 5 rr1 R2 R3 R10 R4)
        (event 6 rr0 R0 R1 R01 R2)
        (event 8 rr1 R2 R3 R10 R4)))

; No-catalysis events: empty
!(test (trace-events (exp03-cap3-rich-after-15 no-catalysis seed-13)) ())

; Run-record coverage
!(test (run-record-events (exp03-cap3-rich-run-record seed-13 random-polymer))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 1 rr2 R4 R5 R45 R54)
        (event 2 rr1 R2 R3 R10 R01)
        (event 3 rr0 R0 R1 R01 R10)
        (event 4 rr2 R4 R5 R45 R54)
        (event 5 rr1 R2 R3 R10 R01)
        (event 6 rr0 R0 R1 R01 R10)
        (event 7 rr2 R4 R5 R45 R54)
        (event 8 rr1 R2 R3 R10 R01)))

!(test (run-record-abundances (exp03-cap3-rich-run-record seed-13 random-polymer))
       ((abundance-snapshot 0 ((mol R0 3) (mol R1 3) (mol R2 3) (mol R3 3)
                               (mol R4 3) (mol R5 3) (mol R01 1) (mol R10 1)
                               (mol R45 0) (mol R54 1)))
        (abundance-snapshot 15 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                                (mol R4 0) (mol R5 0) (mol R01 4) (mol R10 4)
                                (mol R45 3) (mol R54 1)))))

!(test (run-record-abundances (exp03-cap3-rich-run-record seed-13 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol R0 3) (mol R1 3) (mol R2 3) (mol R3 3)
                               (mol R4 3) (mol R5 3) (mol R01 1) (mol R10 1)
                               (mol R45 0) (mol R54 1)))
        (abundance-snapshot 15 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                                (mol R4 3) (mol R5 3) (mol R01 4) (mol R10 4)
                                (mol R45 0) (mol R54 1)))))

!(test (exp03-cap3-rich-run-records-complete? seed-13) True)

; ============================================================================
; Cap-4 RICH bridge for seed-13 (12-molecule, 4-rule productive cycle)
; ============================================================================

; Random-polymer: 12 productive events (3 rr0 + 3 rr2 + 3 rr3 + 3 rr1)
!(test (exp03-cap4-rich-event-count random-polymer seed-13) 12)
; Shuffled-catalysts: 8 productive events (3 rr0 + 3 rr2 + 2 rr1)
;   rr1's shuffled catalyst is R4, which is consumed by rr2, so the 3rd rr1
;   is blocked after R4 is exhausted.
!(test (exp03-cap4-rich-event-count shuffled-catalysts seed-13) 8)
; No-catalysis: 0 events
!(test (exp03-cap4-rich-event-count no-catalysis seed-13) 0)

; All runs reach tick 12
!(test (exp03-cap4-rich-tick random-polymer seed-13) 12)
!(test (exp03-cap4-rich-tick shuffled-catalysts seed-13) 12)
!(test (exp03-cap4-rich-tick no-catalysis seed-13) 12)

; Random-polymer final abundances: all reactants exhausted
!(test (exp03-cap4-rich-abundances random-polymer seed-13)
       (abundance-snapshot 12 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                                (mol R4 0) (mol R5 0) (mol R6 0) (mol R7 0)
                                (mol R01 3) (mol R10 4) (mol R45 3) (mol R54 4))))
; Shuffled-catalysts: R0/R1 exhausted (rr0), R4/R5 exhausted (rr2),
;   R2/R3 partially consumed (2 rr1 firings), R6/R7 untouched (rr3 no-op)
!(test (exp03-cap4-rich-abundances shuffled-catalysts seed-13)
       (abundance-snapshot 12 ((mol R0 0) (mol R1 0) (mol R2 1) (mol R3 1)
                                (mol R4 0) (mol R5 0) (mol R6 3) (mol R7 3)
                                (mol R01 3) (mol R10 3) (mol R45 3) (mol R54 1))))
; No-catalysis: unchanged from initial
!(test (exp03-cap4-rich-abundances no-catalysis seed-13)
       (abundance-snapshot 12 ((mol R0 3) (mol R1 3) (mol R2 3) (mol R3 3)
                                (mol R4 3) (mol R5 3) (mol R6 3) (mol R7 3)
                                (mol R01 0) (mol R10 1) (mol R45 0) (mol R54 1))))

; Reactant exhaustion for random
!(test (exp03-cap4-rich-reactant-exhausted? seed-13) True)
; Control discrimination: random (12) > shuffled (8) > no-catalysis (0)
!(test (exp03-cap4-rich-controls-discriminate? seed-13) True)
; Replay equivalence
!(test (exp03-cap4-rich-replay-ok? random-polymer seed-13) True)
!(test (exp03-cap4-rich-replay-ok? shuffled-catalysts seed-13) True)
!(test (exp03-cap4-rich-replay-ok? no-catalysis seed-13) True)

; Random-polymer events: 3 rounds of rr0/rr2/rr3/rr1 starting at tick 0
!(test (trace-events (exp03-cap4-rich-after-12 random-polymer seed-13))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 1 rr2 R4 R5 R45 R54)
        (event 2 rr3 R6 R7 R54 R45)
        (event 3 rr1 R2 R3 R10 R01)
        (event 4 rr0 R0 R1 R01 R10)
        (event 5 rr2 R4 R5 R45 R54)
        (event 6 rr3 R6 R7 R54 R45)
        (event 7 rr1 R2 R3 R10 R01)
        (event 8 rr0 R0 R1 R01 R10)
        (event 9 rr2 R4 R5 R45 R54)
        (event 10 rr3 R6 R7 R54 R45)
        (event 11 rr1 R2 R3 R10 R01)))

; Shuffled-catalysts events: 3 rr0 + 3 rr2 + 2 rr1 (rr3 no-op, rr1 blocked 3rd)
!(test (trace-events (exp03-cap4-rich-after-12 shuffled-catalysts seed-13))
       ((event 0 rr0 R0 R1 R01 R2)
        (event 1 rr2 R4 R5 R45 R6)
        (event 3 rr1 R2 R3 R10 R4)
        (event 4 rr0 R0 R1 R01 R2)
        (event 5 rr2 R4 R5 R45 R6)
        (event 7 rr1 R2 R3 R10 R4)
        (event 8 rr0 R0 R1 R01 R2)
        (event 9 rr2 R4 R5 R45 R6)))

; No-catalysis events: empty
!(test (trace-events (exp03-cap4-rich-after-12 no-catalysis seed-13)) ())

; Run-record coverage
!(test (run-record-events (exp03-cap4-rich-run-record seed-13 random-polymer))
       ((event 0 rr0 R0 R1 R01 R10)
        (event 1 rr2 R4 R5 R45 R54)
        (event 2 rr3 R6 R7 R54 R45)
        (event 3 rr1 R2 R3 R10 R01)
        (event 4 rr0 R0 R1 R01 R10)
        (event 5 rr2 R4 R5 R45 R54)
        (event 6 rr3 R6 R7 R54 R45)
        (event 7 rr1 R2 R3 R10 R01)
        (event 8 rr0 R0 R1 R01 R10)
        (event 9 rr2 R4 R5 R45 R54)
        (event 10 rr3 R6 R7 R54 R45)
        (event 11 rr1 R2 R3 R10 R01)))

!(test (run-record-abundances (exp03-cap4-rich-run-record seed-13 random-polymer))
       ((abundance-snapshot 0 ((mol R0 3) (mol R1 3) (mol R2 3) (mol R3 3)
                               (mol R4 3) (mol R5 3) (mol R6 3) (mol R7 3)
                               (mol R01 0) (mol R10 1) (mol R45 0) (mol R54 1)))
        (abundance-snapshot 12 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                                (mol R4 0) (mol R5 0) (mol R6 0) (mol R7 0)
                                (mol R01 3) (mol R10 4) (mol R45 3) (mol R54 4)))))

!(test (run-record-abundances (exp03-cap4-rich-run-record seed-13 shuffled-catalysts))
       ((abundance-snapshot 0 ((mol R0 3) (mol R1 3) (mol R2 3) (mol R3 3)
                               (mol R4 3) (mol R5 3) (mol R6 3) (mol R7 3)
                               (mol R01 0) (mol R10 1) (mol R45 0) (mol R54 1)))
        (abundance-snapshot 12 ((mol R0 0) (mol R1 0) (mol R2 1) (mol R3 1)
                                (mol R4 0) (mol R5 0) (mol R6 3) (mol R7 3)
                                (mol R01 3) (mol R10 3) (mol R45 3) (mol R54 1)))))

!(test (exp03-cap4-rich-run-records-complete? seed-13) True)


; Cap-4 rich bridge extension: seed-17 via generated S-family rules.
; Seed-17 has the same cap-4 selector phase as seed-13: (17+tick)%4 = 1,2,3,0...
!(test (exp03-cap4-rich-event-count random-polymer seed-17) 12)
!(test (exp03-cap4-rich-event-count shuffled-catalysts seed-17) 8)
!(test (exp03-cap4-rich-event-count no-catalysis seed-17) 0)

!(test (exp03-cap4-rich-tick random-polymer seed-17) 12)
!(test (exp03-cap4-rich-abundances random-polymer seed-17)
       (abundance-snapshot 12 ((mol S0 0) (mol S1 0) (mol S2 0) (mol S3 0)
                                (mol S4 0) (mol S5 0) (mol S6 0) (mol S7 0)
                                (mol S01 3) (mol S10 4) (mol S45 3) (mol S54 4))))
!(test (exp03-cap4-rich-abundances shuffled-catalysts seed-17)
       (abundance-snapshot 12 ((mol S0 0) (mol S1 0) (mol S2 1) (mol S3 1)
                                (mol S4 0) (mol S5 0) (mol S6 3) (mol S7 3)
                                (mol S01 3) (mol S10 3) (mol S45 3) (mol S54 1))))
!(test (exp03-cap4-rich-abundances no-catalysis seed-17)
       (abundance-snapshot 12 ((mol S0 3) (mol S1 3) (mol S2 3) (mol S3 3)
                                (mol S4 3) (mol S5 3) (mol S6 3) (mol S7 3)
                                (mol S01 0) (mol S10 1) (mol S45 0) (mol S54 1))))

!(test (exp03-cap4-rich-reactant-exhausted? seed-17) True)
!(test (exp03-cap4-rich-controls-discriminate? seed-17) True)
!(test (exp03-cap4-rich-replay-ok? random-polymer seed-17) True)
!(test (exp03-cap4-rich-run-records-complete? seed-17) True)
!(test (trace-events (exp03-cap4-rich-after-12 random-polymer seed-17))
       ((event 0 rr0 S0 S1 S01 S10)
        (event 1 rr2 S4 S5 S45 S54)
        (event 2 rr3 S6 S7 S54 S45)
        (event 3 rr1 S2 S3 S10 S01)
        (event 4 rr0 S0 S1 S01 S10)
        (event 5 rr2 S4 S5 S45 S54)
        (event 6 rr3 S6 S7 S54 S45)
        (event 7 rr1 S2 S3 S10 S01)
        (event 8 rr0 S0 S1 S01 S10)
        (event 9 rr2 S4 S5 S45 S54)
        (event 10 rr3 S6 S7 S54 S45)
        (event 11 rr1 S2 S3 S10 S01)))

; Cap-4 rich bridge extension: seed-11 via Q-family six-rule source pool.
; Candidate cap 4 exposes the first four source rules from the six-rule family;
; the deterministic selector phase is (11+tick)%4 = 3,0,1,2...
; The cap-5 exploratory seam bounds the same six-rule rich-state pool to five
; candidates and selects deterministically with (11+0)%5 = 1.
!(test (exp03-cap5-rich-capped-candidates random seed-11)
       ((candidate 0 (rule rr1 Q2 Q3 Q10 Q01) 1)
        (candidate 0 (rule rr0 Q0 Q1 Q01 Q10) 1)
        (candidate 0 (rule rr2 Q4 Q5 Q45 Q54) 1)
        (candidate 0 (rule rr3 Q6 Q7 Q54 Q45) 1)
        (candidate 0 (rule rr4 Q0 Q5 Q05 Q2) 1)))
!(test (exp03-cap5-rich-selected-candidate random seed-11)
       (candidate 0 (rule rr0 Q0 Q1 Q01 Q10) 1))
!(test (exp03-cap5-rich-event-count random seed-11) 10)
!(test (exp03-cap5-rich-event-count shuffled seed-11) 8)
!(test (exp03-cap5-rich-event-count no-catalysis seed-11) 0)
!(test (exp03-cap5-rich-tick random seed-11) 15)
!(test (exp03-cap5-rich-abundances random seed-11)
       (abundance-snapshot 15 ((mol Q0 1) (mol Q1 1) (mol Q2 0) (mol Q3 0)
                               (mol Q4 1) (mol Q5 1) (mol Q6 0) (mol Q7 0)
                               (mol Q01 3) (mol Q10 3) (mol Q45 3) (mol Q54 3))))
!(test (exp03-cap5-rich-controls-discriminate? seed-11) True)
!(test (exp03-cap5-rich-replay-ok? random seed-11) True)
!(test (exp03-cap5-rich-run-records-complete? seed-11) True)
!(test (trace-events (exp03-cap5-rich-after-15 random seed-11))
       ((event 2 rr3 Q6 Q7 Q54 Q45)
        (event 4 rr1 Q2 Q3 Q10 Q01)
        (event 5 rr0 Q0 Q1 Q01 Q10)
        (event 6 rr2 Q4 Q5 Q45 Q54)
        (event 7 rr3 Q6 Q7 Q54 Q45)
        (event 9 rr1 Q2 Q3 Q10 Q01)
        (event 10 rr0 Q0 Q1 Q01 Q10)
        (event 11 rr2 Q4 Q5 Q45 Q54)
        (event 12 rr3 Q6 Q7 Q54 Q45)
        (event 14 rr1 Q2 Q3 Q10 Q01)))

; Cap-5 productive fifth-candidate bridge: seed-13 via R-family eight-rule pool.
; This 15-molecule state adds R8/R9/R89 so rr4 is selected and fires in-state.
!(test (exp03-cap5-productive-capped-candidates random-polymer seed-13)
       ((candidate 0 (rule rr1 R2 R3 R10 R01) 1)
        (candidate 0 (rule rr0 R0 R1 R01 R10) 1)
        (candidate 0 (rule rr2 R4 R5 R45 R54) 1)
        (candidate 0 (rule rr3 R6 R7 R54 R45) 1)
        (candidate 0 (rule rr4 R8 R9 R89 R2) 1)))
!(test (exp03-cap5-productive-selected-candidate random-polymer seed-13)
       (candidate 0 (rule rr3 R6 R7 R54 R45) 1))
!(test (exp03-cap5-productive-event-count random-polymer seed-13) 10)
!(test (exp03-cap5-productive-tick random-polymer seed-13) 10)
!(test (exp03-cap5-productive-abundances random-polymer seed-13)
       (abundance-snapshot 10 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0) (mol R4 0)
                               (mol R5 0) (mol R6 0) (mol R7 0) (mol R8 0) (mol R9 0)
                               (mol R01 3) (mol R10 3) (mol R45 3) (mol R54 3) (mol R89 2))))
!(test (exp03-cap5-productive-replay-ok? random-polymer seed-13) True)
!(test (exp03-cap5-productive-run-record-complete? seed-13) True)
!(test (trace-events (exp03-cap5-productive-after-10 random-polymer seed-13))
       ((event 0 rr3 R6 R7 R54 R45)
        (event 1 rr4 R8 R9 R89 R2)
        (event 2 rr1 R2 R3 R10 R01)
        (event 3 rr0 R0 R1 R01 R10)
        (event 4 rr2 R4 R5 R45 R54)
        (event 5 rr3 R6 R7 R54 R45)
        (event 6 rr4 R8 R9 R89 R2)
        (event 7 rr1 R2 R3 R10 R01)
        (event 8 rr0 R0 R1 R01 R10)
        (event 9 rr2 R4 R5 R45 R54)))

; Cap-5 rich bridge extension: seed-17 via S-family eight-rule source pool.
; Candidate cap 5 exposes rr1/rr0/rr2/rr3/rr4 from the generated source pool;
; the fifth candidate remains a bounded no-op because S8/S9/S89 are outside the
; 12-molecule rich state.
!(test (exp03-cap5-rich-capped-candidates random-polymer seed-17)
       ((candidate 0 (rule rr1 S2 S3 S10 S01) 1)
        (candidate 0 (rule rr0 S0 S1 S01 S10) 1)
        (candidate 0 (rule rr2 S4 S5 S45 S54) 1)
        (candidate 0 (rule rr3 S6 S7 S54 S45) 1)
        (candidate 0 (rule rr4 S8 S9 S89 S2) 1)))
!(test (exp03-cap5-rich-selected-candidate random-polymer seed-17)
       (candidate 0 (rule rr2 S4 S5 S45 S54) 1))
!(test (exp03-cap5-rich-event-count random-polymer seed-17) 11)
!(test (exp03-cap5-rich-event-count shuffled-catalysts seed-17) 8)
!(test (exp03-cap5-rich-event-count no-catalysis seed-17) 0)
!(test (exp03-cap5-rich-tick random-polymer seed-17) 15)
!(test (exp03-cap5-rich-abundances random-polymer seed-17)
       (abundance-snapshot 15 ((mol S0 0) (mol S1 0) (mol S2 1) (mol S3 1)
                               (mol S4 0) (mol S5 0) (mol S6 0) (mol S7 0)
                               (mol S01 3) (mol S10 3) (mol S45 3) (mol S54 4))))
!(test (exp03-cap5-rich-controls-discriminate? seed-17) True)
!(test (exp03-cap5-rich-replay-ok? random-polymer seed-17) True)
!(test (exp03-cap5-rich-run-records-complete? seed-17) True)
!(test (trace-events (exp03-cap5-rich-after-15 random-polymer seed-17))
       ((event 0 rr2 S4 S5 S45 S54)
        (event 1 rr3 S6 S7 S54 S45)
        (event 4 rr0 S0 S1 S01 S10)
        (event 5 rr2 S4 S5 S45 S54)
        (event 6 rr3 S6 S7 S54 S45)
        (event 8 rr1 S2 S3 S10 S01)
        (event 9 rr0 S0 S1 S01 S10)
        (event 10 rr2 S4 S5 S45 S54)
        (event 11 rr3 S6 S7 S54 S45)
        (event 13 rr1 S2 S3 S10 S01)
        (event 14 rr0 S0 S1 S01 S10)))
!(test (exp03-cap4-rich-event-count random seed-11) 12)
!(test (exp03-cap4-rich-event-count no-catalysis seed-11) 0)
!(test (exp03-cap4-rich-tick random seed-11) 12)
!(test (exp03-cap4-rich-abundances random seed-11)
       (abundance-snapshot 12 ((mol Q0 0) (mol Q1 0) (mol Q2 0) (mol Q3 0)
                               (mol Q4 0) (mol Q5 0) (mol Q6 0) (mol Q7 0)
                               (mol Q01 4) (mol Q10 3) (mol Q45 4) (mol Q54 3))))
!(test (exp03-cap4-rich-reactant-exhausted? seed-11) True)
!(test (exp03-cap4-rich-controls-discriminate? seed-11) True)
!(test (exp03-cap4-rich-replay-ok? random seed-11) True)
!(test (exp03-cap4-rich-run-records-complete? seed-11) True)

; Cap-4 rich bridge extension: seed-7 via P-family four-rule source pool.
; The selector phase is (7+tick)%4 = 3,0,1,2..., so the capped pool exercises
; rr3/sr3, rr1/sr1, rr0/sr0, rr2/sr2 for three full rounds.
!(test (exp03-cap4-rich-event-count random seed-7) 12)
!(test (exp03-cap4-rich-event-count shuffled seed-7) 12)
!(test (exp03-cap4-rich-event-count no-catalysis seed-7) 0)
!(test (exp03-cap4-rich-tick random seed-7) 12)
!(test (exp03-cap4-rich-abundances random seed-7)
       (abundance-snapshot 12 ((mol P0 0) (mol P1 0) (mol P2 1) (mol P3 0)
                               (mol P4 0) (mol P5 0) (mol P6 0) (mol P7 0)
                               (mol P01 4) (mol P10 3) (mol P03 3) (mol P12 3))))
!(test (exp03-cap4-rich-abundances no-catalysis seed-7)
       (abundance-snapshot 12 ((mol P0 6) (mol P1 6) (mol P2 7) (mol P3 6)
                               (mol P4 0) (mol P5 0) (mol P6 0) (mol P7 0)
                               (mol P01 1) (mol P10 0) (mol P03 0) (mol P12 0))))
!(test (exp03-cap4-rich-reactant-exhausted? seed-7) True)
!(test (exp03-cap4-rich-controls-discriminate? seed-7) True)
!(test (exp03-cap4-rich-replay-ok? random seed-7) True)
!(test (exp03-cap4-rich-run-records-complete? seed-7) True)
!(test (trace-events (exp03-cap4-rich-after-12 random seed-7))
       ((event 0 rr3 P1 P2 P12 P0)
        (event 1 rr1 P2 P3 P10 P01)
        (event 2 rr0 P0 P1 P01 P10)
        (event 3 rr2 P0 P3 P03 P2)
        (event 4 rr3 P1 P2 P12 P0)
        (event 5 rr1 P2 P3 P10 P01)
        (event 6 rr0 P0 P1 P01 P10)
        (event 7 rr2 P0 P3 P03 P2)
        (event 8 rr3 P1 P2 P12 P0)
        (event 9 rr1 P2 P3 P10 P01)
        (event 10 rr0 P0 P1 P01 P10)
        (event 11 rr2 P0 P3 P03 P2)))
