!(import! &self ../../src/chem_exp00.metta)

!(test (mol-name (mol A 1)) A)

!(test (mol-abundance (mol AB 3)) 3)

!(test (exp00-rule r0)
       (rule r0 A B AB Cat))

!(test (rule-id (exp00-rule r0)) r0)

!(test (rule-reactant-a (exp00-rule r0)) A)

!(test (rule-reactant-b (exp00-rule r0)) B)

!(test (rule-product (exp00-rule r0)) AB)

!(test (rule-catalyst (exp00-rule r0)) Cat)

!(test (exp00-initial-state seed-7)
       (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))

!(test (state-tick (exp00-initial-state seed-7)) 0)

!(test (state-seed (exp00-initial-state seed-7)) seed-7)

!(test (make-event 0 (exp00-rule r0))
       (event 0 r0 A B AB Cat))

!(test (trace-state (exp00-expected-trace seed-7))
       (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1)))

!(test (trace-event (exp00-expected-trace seed-7))
       (event 0 r0 A B AB Cat))

!(test (exp00-candidate seed-7)
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (candidate-tick (exp00-candidate seed-7)) 0)

!(test (candidate-rule (exp00-candidate seed-7))
       (rule r0 A B AB Cat))

!(test (candidate-score (exp00-candidate seed-7)) 1)

!(test (exp00-initial-chamber seed-7)
       (chamber exp00
                (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
                ((rule r0 A B AB Cat))
                ()))

!(test (chamber-id (exp00-initial-chamber seed-7)) exp00)

!(test (chamber-state (exp00-initial-chamber seed-7))
       (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))

!(test (chamber-rules (exp00-initial-chamber seed-7))
       ((rule r0 A B AB Cat)))

!(test (chamber-events (exp00-initial-chamber seed-7)) ())

!(test (fire-binary-catalytic
         (rule r0 A B AB Cat)
         (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))
       (trace
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         (event 0 r0 A B AB Cat)))

!(test (exp00-run seed-7)
       (trace
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         (event 0 r0 A B AB Cat)))

!(test (exp00-event-log seed-7)
       ((event 0 r0 A B AB Cat)))

!(test (exp00-chamber-after-one-tick seed-7)
       (chamber exp00
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r0 A B AB Cat))
                ((event 0 r0 A B AB Cat))))

!(test (exp00-product-abundance seed-7) 1)

!(test (exp00-product-metric seed-7)
       (metric product-abundance AB 1))

!(test (exp00-catalyst-preserved? seed-7) True)

!(test (exp00-replay-ok? seed-7) True)
