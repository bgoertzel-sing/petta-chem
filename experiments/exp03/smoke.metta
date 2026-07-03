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
