!(import! &self ../../src/chem_exp00.metta)
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

!(test (chamber-run-1 (exp03-initial-chamber seed-7))
       (chamber exp03
                (state 1 seed-7 (mol A 4) (mol B 4) (mol AB 1) (mol Cat 1))
                ((rule r0 A B AB Cat)
                 (rule r0 A B AB Cat))
                ((event 0 r0 A B AB Cat))))

!(test (exp03-after-5 seed-7)
       (chamber exp03
                (state 5 seed-7 (mol A 0) (mol B 0) (mol AB 5) (mol Cat 1))
                ((rule r0 A B AB Cat)
                 (rule r0 A B AB Cat))
                ((event 0 r0 A B AB Cat)
                 (event 1 r0 A B AB Cat)
                 (event 2 r0 A B AB Cat)
                 (event 3 r0 A B AB Cat)
                 (event 4 r0 A B AB Cat))))

!(test (state-tick (chamber-state (exp03-after-5 seed-7))) 5)

!(test (chamber-run (exp03-initial-chamber seed-7) 5)
       (exp03-after-5 seed-7))

!(test (chamber-abundance-snapshot (exp03-after-5 seed-7))
       (abundance-snapshot 5 ((mol A 0) (mol B 0) (mol AB 5) (mol Cat 1))))

!(test (trace-events (exp03-after-5 seed-7))
       ((event 0 r0 A B AB Cat)
        (event 1 r0 A B AB Cat)
        (event 2 r0 A B AB Cat)
        (event 3 r0 A B AB Cat)
        (event 4 r0 A B AB Cat)))

!(test (event-count (trace-events (exp03-after-5 seed-7))) 5)

!(test (exp03-starved-after-3 seed-7)
       (chamber exp03-starved
                (state 3 seed-7 (mol A 0) (mol B 1) (mol AB 0) (mol Cat 1))
                ((rule r0 A B AB Cat)
                 (rule r0 A B AB Cat))
                ()))

!(test (state-tick (chamber-state (exp03-starved-after-3 seed-7))) 3)

!(test (event-count (trace-events (exp03-starved-after-3 seed-7))) 0)

!(test (exp03-replay-5-ok?) True)
