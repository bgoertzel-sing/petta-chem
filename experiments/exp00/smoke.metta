!(import! &self ../../src/chem_exp00.metta)

!(test (mol-name (mol A 1)) A)

!(test (mol-abundance (mol AB 3)) 3)

!(test (mol-positive? (mol AB 3)) True)

!(test (mol-positive? (mol AB 0)) False)

!(test (mol-nonnegative? (mol AB 0)) True)

!(test (symbol-code AB) 17)

!(test (mol-hash (mol AB 3)) 1703)

!(test (exp00-rule r0)
       (rule r0 A B AB Cat))

!(test (rule-id (exp00-rule r0)) r0)

!(test (rule-reactant-a (exp00-rule r0)) A)

!(test (rule-reactant-b (exp00-rule r0)) B)

!(test (rule-product (exp00-rule r0)) AB)

!(test (rule-catalyst (exp00-rule r0)) Cat)

!(test (rule-hash (exp00-rule r0)) 3111131719)

!(test (rule-hash (exp00-rule r1)) 3713192311)

!(test (seed-number seed-7) 7)

!(test (seeded-choice-2 seed-7 0) 1)

!(test (seeded-choice-2 seed-8 0) 0)

!(test (seeded-choice-5 seed-7 0) 2)

!(test (seeded-choice-5 seed-8 0) 3)

!(test (exp00-initial-state seed-7)
       (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))

!(test (state-tick (exp00-initial-state seed-7)) 0)

!(test (state-seed (exp00-initial-state seed-7)) seed-7)

!(test (state-nonnegative? (exp00-initial-state seed-7)) True)

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

!(test (exp00-distractor-candidate seed-7)
       (candidate 0 (rule r1 B Cat BCat A) 1))

!(test (exp00-third-candidate seed-7)
       (candidate 0 (rule r2 A Cat ACat B) 1))

!(test (make-candidate-for-rule 0 (exp00-rule r0))
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (exp00-rules)
       ((rule r1 B Cat BCat A)
        (rule r0 A B AB Cat)
        (rule r2 A Cat ACat B)))

!(test (exp00-generated-candidate-pool seed-7)
       (candidate-pool
         0
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1))))

!(test (candidate-pool-tick (exp00-generated-candidate-pool seed-7)) 0)

!(test (candidate-pool-candidates (exp00-generated-candidate-pool seed-7))
       ((candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)))

!(test (exp00-candidate-cap)
       (candidate-cap 2 1))

!(test (candidate-cap-per-tick (exp00-candidate-cap)) 2)

!(test (candidate-cap-per-rule (exp00-candidate-cap)) 1)

!(test (cap-candidate-pool 0 (exp00-generated-candidate-pool seed-7))
       ())

!(test (cap-candidate-pool 1 (exp00-generated-candidate-pool seed-7))
       ((candidate 0 (rule r1 B Cat BCat A) 1)))

!(test (exp00-capped-candidate-pool seed-7)
       (candidate-pool
         0
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1))))

!(test (exp00-capped-candidates-2 seed-7)
       ((candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)))

!(test (cap-candidate-pool 3 (exp00-generated-candidate-pool seed-7))
       ((candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)))

!(test (exp00-candidate-cap-5)
       (candidate-cap 5 1))

!(test (cap-candidate-pool
         5
         (candidate-pool
           0
           ((exp00-distractor-candidate seed-7)
            (exp00-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-candidate seed-7)
            (exp00-third-candidate seed-7))))
       ((candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)
        (candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)))

!(test (select-candidate-2
         seed-7
         0
         (exp00-distractor-candidate seed-7)
         (exp00-candidate seed-7))
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (select-candidate-2
         seed-8
         0
         (exp00-distractor-candidate seed-8)
         (exp00-candidate seed-8))
       (candidate 0 (rule r1 B Cat BCat A) 1))

!(test (exp00-sampled-candidate seed-7)
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (select-candidate-5
         seed-7
         0
         (exp00-distractor-candidate seed-7)
         (exp00-candidate seed-7)
         (exp00-third-candidate seed-7)
         (exp00-distractor-candidate seed-7)
         (exp00-candidate seed-7))
       (candidate 0 (rule r2 A Cat ACat B) 1))

!(test (selected-candidate-from-chamber-2
         (exp00-initial-chamber seed-7)
         (exp00-distractor-candidate seed-7)
         (exp00-candidate seed-7))
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (candidate-applicable?
         (exp00-candidate seed-7)
         (exp00-initial-state seed-7))
       True)

!(test (candidate-applicable?
         (exp00-candidate seed-7)
         (exp00-starved-state seed-7))
       False)

!(test (exp00-initial-chamber seed-7)
       (chamber exp00
                (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B))
                ()))

!(test (chamber-id (exp00-initial-chamber seed-7)) exp00)

!(test (chamber-state (exp00-initial-chamber seed-7))
       (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))

!(test (chamber-rules (exp00-initial-chamber seed-7))
       ((rule r1 B Cat BCat A)
        (rule r0 A B AB Cat)
        (rule r2 A Cat ACat B)))

!(test (chamber-events (exp00-initial-chamber seed-7)) ())

!(test (fire-binary-catalytic
         (rule r0 A B AB Cat)
         (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))
       (trace
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         (event 0 r0 A B AB Cat)))

!(test (safe-fire-candidate
         (exp00-candidate seed-7)
         (exp00-initial-state seed-7))
       (trace
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         (event 0 r0 A B AB Cat)))

!(test (safe-fire-candidate
         (exp00-candidate seed-7)
         (exp00-starved-state seed-7))
       (blocked
         (candidate 0 (rule r0 A B AB Cat) 1)
         (state 0 seed-7 (mol A 0) (mol B 1) (mol AB 0) (mol Cat 1))
         not-applicable))

!(test (trace-nonnegative? (exp00-run seed-7)) True)

!(test (exp00-run seed-7)
       (trace
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         (event 0 r0 A B AB Cat)))

!(test (exp00-event-log seed-7)
       ((event 0 r0 A B AB Cat)))

!(test (exp00-chamber-after-one-tick seed-7)
       (chamber exp00
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B))
                ((event 0 r0 A B AB Cat))))

!(test (exp00-chamber-after-selected-tick seed-7)
       (chamber exp00
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B))
                ((event 0 r0 A B AB Cat))))

!(test (exp00-chamber-after-generated-tick seed-7)
       (chamber exp00
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B))
                ((event 0 r0 A B AB Cat))))

!(test (exp00-product-abundance seed-7) 1)

!(test (exp00-product-metric seed-7)
       (metric product-abundance AB 1))

!(test (exp00-catalyst-preserved? seed-7) True)

!(test (exp00-replay-ok? seed-7) True)

!(test (exp00-chamber-replay-ok? seed-7) True)

!(test (exp00-generated-replay-equivalent? seed-7) True)
