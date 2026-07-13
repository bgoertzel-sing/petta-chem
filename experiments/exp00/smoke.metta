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

!(test (seeded-choice-6 seed-7 0) 1)

!(test (seeded-choice-6 seed-8 0) 2)

!(test (seeded-choice-7 seed-7 0) 0)

!(test (seeded-choice-7 seed-8 0) 1)

!(test (seeded-choice-8 seed-7 0) 7)

!(test (seeded-choice-8 seed-8 0) 0)

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

!(test (exp00-candidate-cap-6)
       (candidate-cap 6 1))

!(test (exp00-candidate-cap-7)
       (candidate-cap 7 1))

!(test (exp00-candidate-cap-8)
       (candidate-cap 8 1))

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

!(test (cap-candidate-pool
         6
         (candidate-pool
           0
           ((exp00-distractor-candidate seed-7)
            (exp00-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-candidate seed-7))))
       ((candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)
        (candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)))

!(test (cap-candidate-pool
         7
         (candidate-pool
           0
           ((exp00-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-candidate seed-7))))
       ((candidate 0 (rule r0 A B AB Cat) 1)
        (candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)
        (candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)
        (candidate 0 (rule r1 B Cat BCat A) 1)))

!(test (cap-candidate-pool
         8
         (candidate-pool
           0
           ((exp00-distractor-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7)
            (exp00-candidate seed-7))))
       ((candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)
        (candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r2 A Cat ACat B) 1)
        (candidate 0 (rule r1 B Cat BCat A) 1)
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

!(test (select-candidate-6
         seed-7
         0
         (exp00-distractor-candidate seed-7)
         (exp00-candidate seed-7)
         (exp00-third-candidate seed-7)
         (exp00-distractor-candidate seed-7)
         (exp00-candidate seed-7)
         (exp00-third-candidate seed-7))
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (select-candidate-7
         seed-8
         0
         (exp00-distractor-candidate seed-8)
         (exp00-candidate seed-8)
         (exp00-third-candidate seed-8)
         (exp00-distractor-candidate seed-8)
         (exp00-candidate seed-8)
         (exp00-third-candidate seed-8)
         (exp00-distractor-candidate seed-8))
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (select-candidate-8
         seed-7
         0
         (exp00-distractor-candidate seed-7)
         (exp00-third-candidate seed-7)
         (exp00-distractor-candidate seed-7)
         (exp00-third-candidate seed-7)
         (exp00-distractor-candidate seed-7)
         (exp00-third-candidate seed-7)
         (exp00-distractor-candidate seed-7)
         (exp00-candidate seed-7))
       (candidate 0 (rule r0 A B AB Cat) 1))

!(test (chamber-tick-candidate-pool-1
         (candidate-cap 1 1)
         (exp00-initial-chamber seed-7)
         (candidate-pool
           0
           ((exp00-candidate seed-7)
            (exp00-third-candidate seed-7)
            (exp00-distractor-candidate seed-7))))
       (chamber exp00
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B))
                ((event 0 r0 A B AB Cat))))

!(test (chamber-tick-generated-1
         (candidate-cap 1 1)
         (make-chamber
           exp00-cap1
           (exp00-initial-state seed-7)
           ((exp00-rule r0))
           ()))
       (chamber exp00-cap1
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r0 A B AB Cat))
                ((event 0 r0 A B AB Cat))))

!(test (chamber-tick-candidate-pool-3
         (exp00-candidate-cap-3)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (chamber exp00
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B))
                ((event 0 r0 A B AB Cat))))

!(test (cap-candidate-pool
         1
         (candidate-pool 0
           ((candidate 0 r0 1) (candidate 0 r1 1) (candidate 0 r2 1)
            (candidate 0 r3 1) (candidate 0 r4 1) (candidate 0 r5 1)
            (candidate 0 r6 1) (candidate 0 r7 1))))
       ((candidate 0 r0 1)))

!(test (cap-candidate-pool
         6
         (candidate-pool 0
           ((candidate 0 r0 1) (candidate 0 r1 1) (candidate 0 r2 1)
            (candidate 0 r3 1) (candidate 0 r4 1) (candidate 0 r5 1)
            (candidate 0 r6 1))))
       ((candidate 0 r0 1) (candidate 0 r1 1) (candidate 0 r2 1)
        (candidate 0 r3 1) (candidate 0 r4 1) (candidate 0 r5 1)))

!(test (generate-candidate-pool
         (make-chamber
           exp00-cap5
           (exp00-initial-state seed-7)
           ((exp00-rule r0)
            (exp00-rule r1)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r0))
           ()))
       (candidate-pool
         0
         ((candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1))))

!(test (chamber-tick-generated-5
         (exp00-candidate-cap-5)
         (make-chamber
           exp00-cap5
           (exp00-initial-state seed-7)
           ((exp00-rule r1)
            (exp00-rule r2)
            (exp00-rule r0)
            (exp00-rule r1)
            (exp00-rule r2))
           ()))
       (chamber exp00-cap5
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r2 A Cat ACat B)
                 (rule r0 A B AB Cat)
                 (rule r1 B Cat BCat A)
                 (rule r2 A Cat ACat B))
                ((event 0 r0 A B AB Cat))))

!(test (generate-candidate-pool
         (make-chamber
           exp00-cap7
           (exp00-initial-state seed-7)
           ((exp00-rule r0)
            (exp00-rule r1)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r0)
            (exp00-rule r2)
            (exp00-rule r1))
           ()))
       (candidate-pool
         0
         ((candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1))))

!(test (chamber-tick-generated-6
         (exp00-candidate-cap-6)
         (make-chamber
           exp00-cap6
           (exp00-initial-state seed-7)
           ((exp00-rule r1)
            (exp00-rule r0)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r0)
            (exp00-rule r2))
           ()))
       (chamber exp00-cap6
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B)
                 (rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B))
                ((event 0 r0 A B AB Cat))))

!(test (chamber-tick-candidate-pool-6
         (exp00-candidate-cap-6)
         (make-chamber
           exp00-cap6
           (exp00-initial-state seed-7)
           ((exp00-rule r1)
            (exp00-rule r0)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r0)
            (exp00-rule r2))
           ())
         (generate-candidate-pool
           (make-chamber
             exp00-cap6
             (exp00-initial-state seed-7)
             ((exp00-rule r1)
              (exp00-rule r0)
              (exp00-rule r2)
              (exp00-rule r1)
              (exp00-rule r0)
              (exp00-rule r2))
             ())))
       (chamber exp00-cap6
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B)
                 (rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B))
                ((event 0 r0 A B AB Cat))))

!(test (chamber-tick-generated-7
         (exp00-candidate-cap-7)
         (make-chamber
           exp00-cap7
           (exp00-initial-state seed-7)
           ((exp00-rule r0)
            (exp00-rule r1)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r0)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r0))
           ()))
       (chamber exp00-cap7
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r0 A B AB Cat)
                 (rule r1 B Cat BCat A)
                 (rule r2 A Cat ACat B)
                 (rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat)
                 (rule r2 A Cat ACat B)
                 (rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat))
                ((event 0 r0 A B AB Cat))))

!(test (chamber-tick-generated-8
         (exp00-candidate-cap-8)
         (make-chamber
           exp00-cap8
           (exp00-initial-state seed-7)
           ((exp00-rule r1)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r2)
            (exp00-rule r1)
            (exp00-rule r0))
           ()))
       (chamber exp00-cap8
                (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r1 B Cat BCat A)
                 (rule r2 A Cat ACat B)
                 (rule r1 B Cat BCat A)
                 (rule r2 A Cat ACat B)
                 (rule r1 B Cat BCat A)
                 (rule r2 A Cat ACat B)
                 (rule r1 B Cat BCat A)
                 (rule r0 A B AB Cat))
                ((event 0 r0 A B AB Cat))))

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

!(test (chamber-tick-candidate-pool-2
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (exp00-chamber-after-generated-tick seed-7))

!(test (chamber-tick-candidate-pool
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (exp00-chamber-after-generated-tick seed-7))

; Selection provenance preserves the exact bounded list and selected candidate
; in the same object consumed by generic chamber ticking.
!(test (candidate-selection-from-pool
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (candidate-selection
         2
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1))
         (candidate 0 (rule r0 A B AB Cat) 1)))

!(test (candidate-selection-bounded-pool
         (candidate-selection-from-pool
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)
           (exp00-generated-candidate-pool seed-7)))
       ((candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)))

!(test (selected-candidate-from-pool
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (candidate 0 (rule r0 A B AB Cat) 1))

; The generic chamber tick projects from one object containing both the full
; bounded-selection provenance and the chamber produced by that exact choice.
!(test (selection-fire-record-from-pool
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (selection-fire-record
         (candidate-selection
           2
           ((candidate 0 (rule r1 B Cat BCat A) 1)
            (candidate 0 (rule r0 A B AB Cat) 1))
           (candidate 0 (rule r0 A B AB Cat) 1))
         (chamber exp00
                  (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                  ((rule r1 B Cat BCat A)
                   (rule r0 A B AB Cat)
                   (rule r2 A Cat ACat B))
                  ((event 0 r0 A B AB Cat)))))

; Generated ticking retains the uncapped generated pool in the same provenance
; chain as capping, deterministic selection, and the resulting chamber.
!(test (generated-selection-fire-record-from-chamber
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7))
       (generated-selection-fire-record
         (candidate-pool
           0
           ((candidate 0 (rule r1 B Cat BCat A) 1)
            (candidate 0 (rule r0 A B AB Cat) 1)
            (candidate 0 (rule r2 A Cat ACat B) 1)))
         (selection-fire-record
           (candidate-selection
             2
             ((candidate 0 (rule r1 B Cat BCat A) 1)
              (candidate 0 (rule r0 A B AB Cat) 1))
             (candidate 0 (rule r0 A B AB Cat) 1))
           (exp00-chamber-after-generated-tick seed-7))))

!(test (generated-selection-fire-record-pool
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-generated-candidate-pool seed-7))

; The complete generated record directly projects the exact bounded pool and
; selected candidate that were bound once and consumed by chamber firing.
!(test (generated-selection-fire-record-bounded-pool
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       ((candidate 0 (rule r1 B Cat BCat A) 1)
        (candidate 0 (rule r0 A B AB Cat) 1)))

!(test (generated-selection-fire-record-selected
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (candidate 0 (rule r0 A B AB Cat) 1))

; Cap zero and empty source chambers now complete the same generic provenance
; path without selecting/firing a candidate or changing the chamber.
!(test (candidate-selection-from-pool
         (make-candidate-cap 0 1)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (candidate-selection 0 () no-candidate))

!(test (chamber-tick-generated
         (make-candidate-cap 0 1)
         (exp00-initial-chamber seed-7))
       (exp00-initial-chamber seed-7))

!(test (generated-selection-fire-record-from-chamber
         (make-candidate-cap 2 1)
         (chamber exp00
                  (exp00-initial-state seed-7)
                  ()
                  ()))
       (generated-selection-fire-record
         (candidate-pool 0 ())
         (selection-fire-record
           (candidate-selection 2 () no-candidate)
           (chamber exp00
                    (exp00-initial-state seed-7)
                    ()
                    ()))))

; Caps are maxima for every smaller non-empty cardinality, not only cap 8 over
; three candidates. Cap 7 preserves this two-candidate external pool.
!(test (candidate-selection-from-pool
         (exp00-candidate-cap-7)
         (exp00-initial-chamber seed-7)
         (candidate-pool
           0
           ((candidate 0 (rule r1 B Cat BCat A) 1)
            (candidate 0 (rule r0 A B AB Cat) 1))))
       (candidate-selection
         7
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1))
         (candidate 0 (rule r0 A B AB Cat) 1)))

; A cap larger than the source pool selects by actual bounded cardinality (3),
; not by requested cap (8): (7 + 0) mod 3 = 1, hence productive r0.
!(test (selected-candidate-from-pool
         (exp00-candidate-cap-8)
         (exp00-initial-chamber seed-7)
         (generate-candidate-pool (exp00-initial-chamber seed-7)))
       (candidate 0 (rule r0 A B AB Cat) 1))

; The generic operation dispatches by the actual bounded cardinality rather
; than requiring callers to choose a cap-specific tick function. Here cap 8
; safely selects from the generated three-rule pool and fires r0 for seed 7.
!(test (chamber-tick-generated
         (exp00-candidate-cap-8)
         (exp00-initial-chamber seed-7))
       (exp00-chamber-after-generated-tick seed-7))

!(test (exp00-product-abundance seed-7) 1)

!(test (exp00-product-metric seed-7)
       (metric product-abundance AB 1))

!(test (exp00-catalyst-preserved? seed-7) True)

!(test (exp00-replay-ok? seed-7) True)

!(test (exp00-chamber-replay-ok? seed-7) True)

!(test (exp00-generated-replay-equivalent? seed-7) True)
