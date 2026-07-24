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

; Candidate provenance is tick-scoped. A stale candidate cannot fire against a
; later chamber even when its reactants and catalyst remain abundant.
!(test (candidate-applicable?
         (candidate 0 (exp00-rule r0) 1)
         (state 1 seed-7
                (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))
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

!(test (chamber-tick-with-candidate
         (chamber exp00-starved
                  (exp00-starved-state seed-7)
                  ((exp00-rule r0))
                  ())
         (exp00-candidate seed-7))
       (chamber exp00-starved
                (state 0 seed-7
                       (mol A 0) (mol B 1) (mol AB 0) (mol Cat 1))
                ((rule r0 A B AB Cat))
                ()))

; Unified chamber ticking must preserve existing provenance when a later
; selected candidate fires; replacing the event list would erase history.
!(test (chamber-tick-with-candidate
         (chamber exp00-history
                  (exp00-initial-state seed-7)
                  ((exp00-rule r0))
                  ((event prior-tick prior-rule X Y XY Z)))
         (exp00-candidate seed-7))
       (chamber exp00-history
                (state 1 seed-7
                       (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
                ((rule r0 A B AB Cat))
                ((event prior-tick prior-rule X Y XY Z)
                 (event 0 r0 A B AB Cat))))

!(test (selection-fire-record-from-pool
         (make-candidate-cap 1 1)
         (chamber exp00-starved
                  (exp00-starved-state seed-7)
                  ((exp00-rule r0))
                  ())
         (candidate-pool 0 ((exp00-candidate seed-7))))
       (selection-fire-record
         (candidate-selection
           1
           ((candidate 0 (rule r0 A B AB Cat) 1))
           (candidate 0 (rule r0 A B AB Cat) 1))
         (chamber exp00-starved
                  (state 0 seed-7
                         (mol A 0) (mol B 1) (mol AB 0) (mol Cat 1))
                  ((rule r0 A B AB Cat))
                  ())))

!(test (selection-fire-record-from-pool
         (make-candidate-cap 1 1)
         (chamber exp00-later
                  (state 1 seed-7
                         (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
                  ((exp00-rule r0))
                  ())
         (candidate-pool 0 ((candidate 0 (exp00-rule r0) 1))))
       (selection-fire-record
         (candidate-selection
           1
           ((candidate 0 (rule r0 A B AB Cat) 1))
           (candidate 0 (rule r0 A B AB Cat) 1))
         (chamber exp00-later
                  (state 1 seed-7
                         (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
                  ((rule r0 A B AB Cat))
                  ())))

; The candidate-pool envelope is also tick-scoped. A malformed stale envelope
; cannot fire a candidate that independently claims the chamber's current tick.
!(test (candidate-pool-current-for-chamber?
         (candidate-pool 0 ((candidate 1 (exp00-rule r0) 1)))
         (chamber exp00-later
                  (state 1 seed-7
                         (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
                  ((exp00-rule r0))
                  ()))
       False)

!(test (selection-fire-record-from-pool
         (make-candidate-cap 1 1)
         (chamber exp00-later
                  (state 1 seed-7
                         (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
                  ((exp00-rule r0))
                  ())
         (candidate-pool 0 ((candidate 1 (exp00-rule r0) 1))))
       (selection-fire-record
         (candidate-selection
           1
           ((candidate 1 (rule r0 A B AB Cat) 1))
           (candidate 1 (rule r0 A B AB Cat) 1))
         (chamber exp00-later
                  (state 1 seed-7
                         (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
                  ((rule r0 A B AB Cat))
                  ())))

; An externally supplied candidate can only mutate a chamber when its rule is
; actually in that chamber's bounded rule list. The foreign choice remains in
; selection provenance but is rejected at the chamber safety boundary.
!(test (candidate-applicable-in-chamber?
         (candidate 0 (rule foreign A B AB Cat) 1)
         (exp00-initial-chamber seed-7))
       False)

; Reusing a chamber-owned rule id must not authorize an externally altered
; rewrite. Catalyst reassignment remains allowed, but reactants/product are
; part of the source-rule identity handed to chamber ticking.
!(test (candidate-applicable-in-chamber?
         (candidate 0 (rule r0 A B ACat Cat) 1)
         (chamber exp00-altered-rewrite
                  (state 0 seed-7
                         (mol A 1) (mol B 1) (mol ACat 0) (mol Cat 1))
                  ((exp00-rule r0))
                  ()))
       False)

!(test (selection-fire-record-from-pool
         (make-candidate-cap 1 1)
         (chamber exp00-altered-rewrite
                  (state 0 seed-7
                         (mol A 1) (mol B 1) (mol ACat 0) (mol Cat 1))
                  ((exp00-rule r0))
                  ())
         (candidate-pool
           0
           ((candidate 0 (rule r0 A B ACat Cat) 1))))
       (selection-fire-record
         (candidate-selection
           1
           ((candidate 0 (rule r0 A B ACat Cat) 1))
           (candidate 0 (rule r0 A B ACat Cat) 1))
         (chamber exp00-altered-rewrite
                  (state 0 seed-7
                         (mol A 1) (mol B 1) (mol ACat 0) (mol Cat 1))
                  ((rule r0 A B AB Cat))
                  ())))

!(test (selection-fire-record-from-pool
         (make-candidate-cap 1 1)
         (exp00-initial-chamber seed-7)
         (candidate-pool
           0
           ((candidate 0 (rule foreign A B AB Cat) 1))))
       (selection-fire-record
         (candidate-selection
           1
           ((candidate 0 (rule foreign A B AB Cat) 1))
           (candidate 0 (rule foreign A B AB Cat) 1))
         (exp00-initial-chamber seed-7)))

!(test (chamber-tick-generated
         (make-candidate-cap 1 1)
         (chamber exp00-starved
                  (exp00-starved-state seed-7)
                  ((exp00-rule r0))
                  ()))
       (chamber exp00-starved
                (state 0 seed-7
                       (mol A 0) (mol B 1) (mol AB 0) (mol Cat 1))
                ((rule r0 A B AB Cat))
                ()))

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

!(test (candidate-selection-cap
         (candidate-selection-from-pool
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)
           (exp00-generated-candidate-pool seed-7)))
       2)

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
         (candidate-cap 2 1)
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

; Cardinality accessors expose the generated and actually selectable pool
; sizes without host-side list inspection.
!(test (generated-selection-fire-record-generated-count
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       3)

!(test (generated-selection-fire-record-bounded-count
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       2)

!(test (generated-selection-fire-record-bounded-count
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap-3)
           (exp00-initial-chamber seed-7)))
       3)

!(test (generated-selection-fire-record-bounded-count
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 0 3)
           (exp00-initial-chamber seed-7)))
       0)

; Generation and selection are separate bounded stages. The ordinary
; three-rule source omits nothing during generation, while the explicitly
; supported twelve-rule source reports four rules beyond the generator's
; stable first-eight boundary.
!(test (chamber-source-rule-count (exp00-initial-chamber seed-7)) 3)

!(test (generated-selection-fire-record-generation-cap
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       8)

!(test (generated-selection-fire-record-generation-remaining-count
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       5)

!(test (generated-selection-fire-record-generation-capacity-disposition
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       open)

!(test (generated-selection-fire-record-generation-omitted-count
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       0)

!(test (generated-selection-fire-record-generation-disposition
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       complete)

!(test (generated-selection-fire-record-generation-omitted-count
         (make-chamber
           exp00-twelve-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
           ())
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 8 1)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       4)

!(test (generated-selection-fire-record-generation-disposition
         (make-chamber
           exp00-twelve-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
           ())
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 8 1)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       truncated)

!(test (generated-selection-fire-record-generation-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 8 1)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       8)

!(test (generated-selection-fire-record-generation-remaining-count
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 8 1)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       0)

!(test (generated-selection-fire-record-generation-capacity-disposition
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 8 1)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       saturated)

; End-to-end attrition combines the generator and selection boundaries. The
; ordinary source loses one candidate only at cap selection; the twelve-rule
; source loses four at generation and six more when bounded to two.
!(test (generated-selection-fire-record-total-omitted-count
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (generated-selection-fire-record-total-omitted-count
         (make-chamber
           exp00-twelve-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
           ())
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       10)

; End-to-end disposition reports whether all source rules survived both
; bounded stages, rather than only classifying the generated pool.
!(test (generated-selection-fire-record-total-disposition
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap-3)
           (exp00-initial-chamber seed-7)))
       preserved)

!(test (generated-selection-fire-record-total-disposition
         (make-chamber
           exp00-twelve-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
           ())
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 8 1)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       truncated)

; Attribute source loss to neither bounded stage, selection only, generation
; only, or both stages using the same complete provenance record.
!(test (generated-selection-fire-record-attrition-stage
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap-3)
           (exp00-initial-chamber seed-7)))
       none)

!(test (generated-selection-fire-record-attrition-stage
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       selection)

!(test (generated-selection-fire-record-attrition-stage
         (make-chamber
           exp00-twelve-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
           ())
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 8 1)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       generation)

!(test (generated-selection-fire-record-attrition-stage
         (make-chamber
           exp00-twelve-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
           ())
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (make-chamber
             exp00-twelve-rules
             (exp00-initial-state seed-7)
             ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
              (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
             ())))
       both)

; The truncation magnitude is derived from the same complete PeTTa-native
; record: cap 2 drops one, cap 3 drops none, and a closed cap drops all three.
!(test (generated-selection-fire-record-dropped-count
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (generated-selection-fire-record-dropped-count
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap-3)
           (exp00-initial-chamber seed-7)))
       0)

!(test (generated-selection-fire-record-dropped-count
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 0 3)
           (exp00-initial-chamber seed-7)))
       3)

; Report whether the effective cap preserved or truncated generation without
; host-side list inspection.
!(test (generated-selection-fire-record-cap-disposition
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       truncated)

!(test (generated-selection-fire-record-cap-disposition
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap-3)
           (exp00-initial-chamber seed-7)))
       preserved)

!(test (generated-selection-fire-record-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 9 1)
           (exp00-initial-chamber seed-7)))
       8)

; The complete supported cap remains queryable beside the requested cap. The
; generator normalizes every positive per-rule allowance to its one-candidate
; contract without changing the effective per-tick bound.
!(test (generated-selection-fire-record-effective-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 9 3)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 8 1))

; Scalar field accessors let audit consumers compare requested and effective
; boundaries without reconstructing or destructuring the complete record.
!(test (generated-selection-fire-record-requested-per-tick
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 9 3)
           (exp00-initial-chamber seed-7)))
       9)

!(test (generated-selection-fire-record-requested-per-rule
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 9 3)
           (exp00-initial-chamber seed-7)))
       3)

!(test (generated-selection-fire-record-effective-per-tick
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 9 3)
           (exp00-initial-chamber seed-7)))
       8)

!(test (generated-selection-fire-record-effective-per-rule
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 9 3)
           (exp00-initial-chamber seed-7)))
       1)

; A positive per-rule request above the generator's one-candidate-per-source
; contract is retained for audit while its effective field normalizes to one.
!(test (generated-selection-fire-record-requested-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 2 3)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 2 3))

!(test (generated-selection-fire-record-effective-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 2 3)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 2 1))

!(test (chamber-tick-generated
         (make-candidate-cap 2 3)
         (exp00-initial-chamber seed-7))
       (exp00-chamber-after-generated-tick seed-7))

!(test (generated-selection-fire-record-effective-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 2 0)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 0 0))

; Preserve the complete requested cap beside its effective scalar so callers
; can distinguish an ordinary cap from a clamp or per-rule closure.
!(test (generated-selection-fire-record-requested-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 9 1)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 9 1))

!(test (generated-selection-fire-record-requested-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 2 0)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 2 0))

!(test (generated-selection-fire-record-selected
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (candidate 0 (rule r0 A B AB Cat) 1))

; One compact audit atom carries source, generated, bounded, generation-loss,
; selection-loss, total-loss, and causal-stage fields for the ordinary path.
!(test (generated-selection-fire-record-attrition-summary
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (candidate-attrition 3 3 2 0 1 1 selection))

!(test (generated-selection-fire-record-attrition-summary
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap-3)
           (exp00-initial-chamber seed-7)))
       (candidate-attrition 3 3 3 0 0 0 none))

; Every compact attrition field remains directly queryable inside PeTTa, so
; report and persistence layers do not have to decode positional fields.
!(test (candidate-attrition-source-count
         (generated-selection-fire-record-attrition-summary
           (exp00-initial-chamber seed-7)
           (generated-selection-fire-record-from-chamber
             (exp00-candidate-cap)
             (exp00-initial-chamber seed-7))))
       3)

!(test (candidate-attrition-generated-count
         (candidate-attrition 12 8 2 4 6 10 both))
       8)

!(test (candidate-attrition-bounded-count
         (candidate-attrition 12 8 2 4 6 10 both))
       2)

!(test (candidate-attrition-generation-omitted-count
         (candidate-attrition 12 8 2 4 6 10 both))
       4)

!(test (candidate-attrition-selection-omitted-count
         (candidate-attrition 12 8 2 4 6 10 both))
       6)

!(test (candidate-attrition-total-omitted-count
         (candidate-attrition 12 8 2 4 6 10 both))
       10)

!(test (candidate-attrition-stage
         (candidate-attrition 12 8 2 4 6 10 both))
       both)

; Compact attrition provenance validates all three source -> generation ->
; bounded-pool conservation identities directly in PeTTa.
!(test (candidate-attrition-consistent?
         (generated-selection-fire-record-attrition-summary
           (exp00-initial-chamber seed-7)
           (generated-selection-fire-record-from-chamber
             (exp00-candidate-cap)
             (exp00-initial-chamber seed-7))))
       true)

!(test (candidate-attrition-consistent?
         (candidate-attrition 12 8 2 4 6 10 both))
       true)

!(test (candidate-attrition-consistent?
         (candidate-attrition 12 8 2 3 6 10 both))
       false)

; Correct arithmetic is not sufficient if the attributed stage is stale or
; misleading. Validate all four supported labels and reject a mismatched one.
!(test (candidate-attrition-stage-consistent?
         (candidate-attrition 3 3 3 0 0 0 none))
       true)

!(test (candidate-attrition-stage-consistent?
         (candidate-attrition 3 3 2 0 1 1 selection))
       true)

!(test (candidate-attrition-stage-consistent?
         (candidate-attrition 12 8 8 4 0 4 generation))
       true)

!(test (candidate-attrition-stage-consistent?
         (candidate-attrition 12 8 2 4 6 10 both))
       true)

!(test (candidate-attrition-stage-consistent?
         (candidate-attrition 12 8 2 4 6 10 selection))
       false)

; Count-domain validity is independent of conservation: this impossible
; record balances arithmetically and has the matching stage label.
!(test (candidate-attrition-counts-nonnegative?
         (candidate-attrition 3 3 -1 0 4 4 selection))
       false)

!(test (candidate-attrition-counts-nonnegative?
         (candidate-attrition 12 8 2 4 6 10 both))
       true)

; The combined persistence gate accepts live provenance and rejects
; impossible counts, malformed arithmetic, or a misleading stage label.
!(test (candidate-attrition-valid?
         (generated-selection-fire-record-attrition-summary
           (exp00-initial-chamber seed-7)
           (generated-selection-fire-record-from-chamber
             (exp00-candidate-cap)
             (exp00-initial-chamber seed-7))))
       true)

!(test (candidate-attrition-valid?
         (candidate-attrition 12 8 2 3 6 10 both))
       false)

!(test (candidate-attrition-valid?
         (candidate-attrition 3 3 -1 0 4 4 selection))
       false)

!(test (candidate-attrition-valid?
         (candidate-attrition 12 8 2 4 6 10 selection))
       false)

; Complete generation/selection/fire provenance exposes its validity without
; requiring callers to materialize and then validate the compact summary.
!(test (generated-selection-fire-record-attrition-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       true)

!(test (generated-selection-fire-record-attrition-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       true)

; The complete live record also validates its fixed generator boundary,
; normalized selection cap, and embedded scalar cap in one PeTTa-native gate.
!(test (generated-selection-fire-record-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       true)

!(test (generated-selection-fire-record-validity
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       valid)

; Every rejection disposition is directly testable, with the documented
; first-failure precedence retained for records that violate later gates too.
!(test (generated-selection-fire-record-validity
         (make-chamber exp00-empty (exp00-initial-state seed-7) () ())
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       invalid-attrition)

; Internally consistent generation/selection/fire provenance must also come
; from the chamber's exact source-rule order. This forged equal-width pool is
; self-consistent through firing, but cannot claim to have been generated by
; the input chamber.
!(test (generated-selection-fire-record-generation-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (candidate-pool
             0
             ((candidate 0 (rule r2 A Cat ACat B) 1)
              (candidate 0 (rule r0 A B AB Cat) 1)
              (candidate 0 (rule r1 B Cat BCat A) 1)))
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r2 A Cat ACat B) 1)
                (candidate 0 (rule r0 A B AB Cat) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-chamber-after-generated-tick seed-7))))
       false)

!(test (generated-selection-fire-record-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (candidate-pool
             0
             ((candidate 0 (rule r2 A Cat ACat B) 1)
              (candidate 0 (rule r0 A B AB Cat) 1)
              (candidate 0 (rule r1 B Cat BCat A) 1)))
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r2 A Cat ACat B) 1)
                (candidate 0 (rule r0 A B AB Cat) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-chamber-after-generated-tick seed-7))))
       false)

!(test (generated-selection-fire-record-validity
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (candidate-pool
             0
             ((candidate 0 (rule r2 A Cat ACat B) 1)
              (candidate 0 (rule r0 A B AB Cat) 1)
              (candidate 0 (rule r1 B Cat BCat A) 1)))
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r2 A Cat ACat B) 1)
                (candidate 0 (rule r0 A B AB Cat) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-chamber-after-generated-tick seed-7))))
       invalid-generation)

!(test (chamber-tick-from-generated-record
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (candidate-pool
             0
             ((candidate 0 (rule r2 A Cat ACat B) 1)
              (candidate 0 (rule r0 A B AB Cat) 1)
              (candidate 0 (rule r1 B Cat BCat A) 1)))
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r2 A Cat ACat B) 1)
                (candidate 0 (rule r0 A B AB Cat) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-chamber-after-generated-tick seed-7))))
       (exp00-initial-chamber seed-7))

; Equal cardinalities and valid caps are insufficient when persisted
; provenance substitutes a different bounded pool or deterministic choice.
!(test (generated-selection-fire-record-selection-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       true)

!(test (generated-selection-fire-record-selection-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (candidate-pool
             0
             ((candidate 0 (rule r1 B Cat BCat A) 1)
              (candidate 0 (rule r0 A B AB Cat) 1)
              (candidate 0 (rule r2 A Cat ACat B) 1)))
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r0 A B AB Cat) 1)
                (candidate 0 (rule r2 A Cat ACat B) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-chamber-after-generated-tick seed-7))))
       false)

!(test (generated-selection-fire-record-validity
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r0 A B AB Cat) 1)
                (candidate 0 (rule r2 A Cat ACat B) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-chamber-after-generated-tick seed-7))))
       invalid-selection)

; A record may carry the exact generated pool, bounded pool, and deterministic
; choice while forging the chamber produced by firing. The firing validity
; gate reconstructs that transition and the complete gate fails closed.
!(test (generated-selection-fire-record-firing-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       true)

!(test (generated-selection-fire-record-firing-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r1 B Cat BCat A) 1)
                (candidate 0 (rule r0 A B AB Cat) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-initial-chamber seed-7))))
       false)

!(test (generated-selection-fire-record-validity
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r1 B Cat BCat A) 1)
                (candidate 0 (rule r0 A B AB Cat) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-initial-chamber seed-7))))
       invalid-firing)

!(test (chamber-tick-from-generated-record
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r1 B Cat BCat A) 1)
                (candidate 0 (rule r0 A B AB Cat) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-initial-chamber seed-7))))
       (exp00-initial-chamber seed-7))

!(test (chamber-tick-from-generated-record
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (candidate-cap 2 1)
           (candidate-pool
             0
             ((candidate 0 (rule r1 B Cat BCat A) 1)
              (candidate 0 (rule r0 A B AB Cat) 1)
              (candidate 0 (rule r2 A Cat ACat B) 1)))
           (selection-fire-record
             (candidate-selection
               2
               ((candidate 0 (rule r0 A B AB Cat) 1)
                (candidate 0 (rule r2 A Cat ACat B) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-chamber-after-generated-tick seed-7))))
       (exp00-initial-chamber seed-7))

!(test (generated-selection-fire-record-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       true)

; Conservation alone accepts this synthetic record (3 -> 3 -> 3), but its
; three-candidate bounded pool violates the requested effective cap of two.
!(test (generated-selection-fire-record-attrition-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (make-candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               3
               ((candidate 0 (rule r0 A B AB Cat) 1)
                (candidate 0 (rule r1 B Cat BCat A) 1)
                (candidate 0 (rule r2 A Cat ACat B) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-initial-chamber seed-7))))
       true)

!(test (generated-selection-fire-record-valid?
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (make-candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               3
               ((candidate 0 (rule r0 A B AB Cat) 1)
                (candidate 0 (rule r1 B Cat BCat A) 1)
                (candidate 0 (rule r2 A Cat ACat B) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-initial-chamber seed-7))))
       false)

!(test (generated-selection-fire-record-validity
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (make-candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               3
               ((candidate 0 (rule r0 A B AB Cat) 1)
                (candidate 0 (rule r1 B Cat BCat A) 1)
                (candidate 0 (rule r2 A Cat ACat B) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-initial-chamber seed-7))))
       invalid-bounds)

; The chamber-tick projection itself now consumes the validity gate. A
; malformed over-cap record cannot mutate the chamber, while ordinary live
; generation continues through the same deterministic firing path.
!(test (chamber-tick-from-generated-record
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (make-candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               3
               ((candidate 0 (rule r0 A B AB Cat) 1)
                (candidate 0 (rule r1 B Cat BCat A) 1)
                (candidate 0 (rule r2 A Cat ACat B) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-after-generated-chamber seed-7))))
       (exp00-initial-chamber seed-7))

!(test (chamber-tick-from-generated-record
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record-from-chamber
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (chamber exp00
         (state 1 seed-7
           (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         ((rule r1 B Cat BCat A)
          (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B))
         ((event 0 r0 A B AB Cat))))

; Live ticking can retain the complete validation disposition beside its
; projected chamber, while the established chamber-only API remains an exact
; projection of the same checked result.
!(test (chamber-tick-generated-result
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7))
       (chamber-tick-result
         valid
         (exp00-chamber-after-generated-tick seed-7)))

!(test (chamber-tick-result-validity
         (chamber-tick-generated-result
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       valid)

!(test (chamber-tick-result-valid?
         (chamber-tick-generated-result
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       True)

!(test (chamber-tick-result-changed?
         (exp00-initial-chamber seed-7)
         (chamber-tick-generated-result
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       True)

!(test (chamber-tick-result-outcome
         (exp00-initial-chamber seed-7)
         (chamber-tick-generated-result
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       productive)

!(test (chamber-tick-generated-outcome
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7))
       productive)

!(test (chamber-tick-generated-step
         (exp00-candidate-cap)
         (exp00-initial-chamber seed-7))
       (chamber-tick-step
         productive
         (exp00-chamber-after-generated-tick seed-7)))

!(test (chamber-tick-step-outcome
         (chamber-tick-generated-step
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       productive)

!(test (chamber-tick-step-chamber
         (chamber-tick-generated-step
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-chamber-after-generated-tick seed-7))

; The loop seam hands the first projected chamber directly into a second live
; generated tick. A closed cap makes both transitions explicit valid no-ops.
!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-2
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       (no-op no-op))

!(test (chamber-tick-steps-chamber
         (chamber-tick-generated-steps-2
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       (exp00-initial-chamber seed-7))

!(test (chamber-tick-steps-count
         (chamber-tick-generated-steps-2
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       2)

!(test (chamber-tick-steps-productive-count
         (chamber-tick-generated-steps-2
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       0)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-2
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       2)

; Productive state handoff must also remain total when the next deterministic
; selection uses a rule whose fixed molecule layout is absent from the
; projected state. The second checked tick is a valid no-op, not an
; irreducible applicability expression.
!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-2
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (productive no-op))

!(test (chamber-tick-steps-chamber
         (chamber-tick-generated-steps-2
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-chamber-after-generated-tick seed-7))

!(test (chamber-tick-steps-productive-count
         (chamber-tick-generated-steps-2
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-2
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

; The third bounded live step consumes the second projected chamber. Both the
; closed cap and productive-first paths remain total and exactly auditable.
!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-3
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       (no-op no-op no-op))

!(test (chamber-tick-steps-count
         (chamber-tick-generated-steps-3
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       3)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-3
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       3)

!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-3
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (productive no-op no-op))

!(test (chamber-tick-steps-chamber
         (chamber-tick-generated-steps-3
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-chamber-after-generated-tick seed-7))

!(test (chamber-tick-steps-productive-count
         (chamber-tick-generated-steps-3
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-3
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       2)

; A fourth bounded checked handoff retains the same deterministic audit
; contract for both the closed-cap and productive-first paths.
!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-4
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       (no-op no-op no-op no-op))

!(test (chamber-tick-steps-count
         (chamber-tick-generated-steps-4
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       4)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-4
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       4)

!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-4
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (productive no-op no-op no-op))

!(test (chamber-tick-steps-chamber
         (chamber-tick-generated-steps-4
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-chamber-after-generated-tick seed-7))

!(test (chamber-tick-steps-productive-count
         (chamber-tick-generated-steps-4
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-4
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       3)

; The fifth bounded live handoff exercises the four-step projected-chamber
; accessor and preserves exact audit summaries across an odd sequence width.
!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-5
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       (no-op no-op no-op no-op no-op))

!(test (chamber-tick-steps-count
         (chamber-tick-generated-steps-5
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       5)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-5
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       5)

!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-5
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (productive no-op no-op no-op no-op))

!(test (chamber-tick-steps-chamber
         (chamber-tick-generated-steps-5
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-chamber-after-generated-tick seed-7))

!(test (chamber-tick-steps-productive-count
         (chamber-tick-generated-steps-5
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-5
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       4)

; The sixth bounded live handoff exercises the five-step projected-chamber
; accessor and preserves exact audit summaries across an even sequence width.
!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-6
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       (no-op no-op no-op no-op no-op no-op))

!(test (chamber-tick-steps-count
         (chamber-tick-generated-steps-6
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       6)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-6
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       6)

!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-6
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (productive no-op no-op no-op no-op no-op))

!(test (chamber-tick-steps-chamber
         (chamber-tick-generated-steps-6
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-chamber-after-generated-tick seed-7))

!(test (chamber-tick-steps-productive-count
         (chamber-tick-generated-steps-6
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-6
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       5)

; The seventh bounded live handoff exercises the six-step projected-chamber
; accessor while preserving exact odd-width audit summaries.
!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-7
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       (no-op no-op no-op no-op no-op no-op no-op))

!(test (chamber-tick-steps-count
         (chamber-tick-generated-steps-7
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       7)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-7
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       7)

!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-7
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (productive no-op no-op no-op no-op no-op no-op))

!(test (chamber-tick-steps-chamber
         (chamber-tick-generated-steps-7
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-chamber-after-generated-tick seed-7))

!(test (chamber-tick-steps-productive-count
         (chamber-tick-generated-steps-7
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-7
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       6)

; The eighth live handoff completes the bounded sequence at the stable
; eight-candidate generation boundary.
!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-8
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       (no-op no-op no-op no-op no-op no-op no-op no-op))

!(test (chamber-tick-steps-count
         (chamber-tick-generated-steps-8
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       8)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-8
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       8)

!(test (chamber-tick-steps-outcomes
         (chamber-tick-generated-steps-8
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (productive no-op no-op no-op no-op no-op no-op no-op))

!(test (chamber-tick-steps-chamber
         (chamber-tick-generated-steps-8
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       (exp00-chamber-after-generated-tick seed-7))

!(test (chamber-tick-steps-productive-count
         (chamber-tick-generated-steps-8
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       1)

!(test (chamber-tick-steps-no-op-count
         (chamber-tick-generated-steps-8
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       7)

; Every supported live outcome is accounted for as productive or no-op. The
; invariant rejects an otherwise well-shaped bounded history containing an
; unknown outcome token.
!(test (chamber-tick-steps-outcome-accounting-valid?
         (chamber-tick-generated-steps-8
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       True)

!(test (chamber-tick-steps-unaccounted-count
         (chamber-tick-generated-steps-8
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       0)

!(test (chamber-tick-steps-outcome-accounting-valid?
         (chamber-tick-generated-steps-8
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       True)

!(test (chamber-tick-steps-unaccounted-count
         (chamber-tick-generated-steps-8
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       0)

!(test (chamber-tick-steps-outcome-accounting-valid?
         (chamber-tick-steps
           (productive no-op unknown)
           (exp00-initial-chamber seed-7)))
       False)

!(test (chamber-tick-steps-unaccounted-count
         (chamber-tick-steps
           (productive no-op unknown)
           (exp00-initial-chamber seed-7)))
       1)

; The complete loop-facing disposition distinguishes valid chemistry progress,
; valid quiescence, and malformed retained outcomes without host-side logic.
!(test (chamber-tick-steps-disposition
         (chamber-tick-generated-steps-8
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       quiescent)

!(test (chamber-tick-steps-disposition
         (chamber-tick-generated-steps-8
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       productive)

!(test (chamber-tick-steps-disposition
         (chamber-tick-steps
           (productive no-op unknown)
           (exp00-initial-chamber seed-7)))
       invalid-outcomes)

; The disposition drives a PeTTa-native fail-closed loop-control decision.
!(test (chamber-tick-steps-next-action
         (chamber-tick-generated-steps-8
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       stop-quiescent)

!(test (chamber-tick-steps-next-action
         (chamber-tick-generated-steps-8
           (exp00-candidate-cap)
           (exp00-initial-chamber seed-7)))
       continue)

!(test (chamber-tick-steps-next-action
         (chamber-tick-steps
           (productive no-op unknown)
           (exp00-initial-chamber seed-7)))
       stop-invalid)

; A checked closed-cap tick is valid but does not change its chamber.
!(test (chamber-tick-result-valid?
         (chamber-tick-generated-result
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       True)

!(test (chamber-tick-result-changed?
         (exp00-initial-chamber seed-7)
         (chamber-tick-generated-result
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       False)

!(test (chamber-tick-result-outcome
         (exp00-initial-chamber seed-7)
         (chamber-tick-generated-result
           (make-candidate-cap 0 1)
           (exp00-initial-chamber seed-7)))
       no-op)

!(test (chamber-tick-generated-outcome
         (make-candidate-cap 0 1)
         (exp00-initial-chamber seed-7))
       no-op)

!(test (chamber-tick-generated-step
         (make-candidate-cap 0 1)
         (exp00-initial-chamber seed-7))
       (chamber-tick-step
         no-op
         (exp00-initial-chamber seed-7)))

!(test (chamber-tick-result-from-generated-record
         (exp00-initial-chamber seed-7)
         (generated-selection-fire-record
           (make-candidate-cap 2 1)
           (exp00-generated-candidate-pool seed-7)
           (selection-fire-record
             (candidate-selection
               3
               ((candidate 0 (rule r0 A B AB Cat) 1)
                (candidate 0 (rule r1 B Cat BCat A) 1)
                (candidate 0 (rule r2 A Cat ACat B) 1))
               (candidate 0 (rule r0 A B AB Cat) 1))
             (exp00-after-generated-chamber seed-7))))
       (chamber-tick-result
         invalid-bounds
         (exp00-initial-chamber seed-7)))

!(test (chamber-tick-result-validity
         (chamber-tick-result-from-generated-record
           (exp00-initial-chamber seed-7)
           (generated-selection-fire-record
             (make-candidate-cap 2 1)
             (exp00-generated-candidate-pool seed-7)
             (selection-fire-record
               (candidate-selection
                 3
                 ((candidate 0 (rule r0 A B AB Cat) 1)
                  (candidate 0 (rule r1 B Cat BCat A) 1)
                  (candidate 0 (rule r2 A Cat ACat B) 1))
                 (candidate 0 (rule r0 A B AB Cat) 1))
               (exp00-after-generated-chamber seed-7)))))
       invalid-bounds)

!(test (chamber-tick-result-valid?
         (chamber-tick-result-from-generated-record
           (exp00-initial-chamber seed-7)
           (generated-selection-fire-record
             (make-candidate-cap 2 1)
             (exp00-generated-candidate-pool seed-7)
             (selection-fire-record
               (candidate-selection
                 3
                 ((candidate 0 (rule r0 A B AB Cat) 1)
                  (candidate 0 (rule r1 B Cat BCat A) 1)
                  (candidate 0 (rule r2 A Cat ACat B) 1))
                 (candidate 0 (rule r0 A B AB Cat) 1))
               (exp00-after-generated-chamber seed-7)))))
       False)

!(test (chamber-tick-result-changed?
         (exp00-initial-chamber seed-7)
         (chamber-tick-result-from-generated-record
           (exp00-initial-chamber seed-7)
           (generated-selection-fire-record
             (make-candidate-cap 2 1)
             (exp00-generated-candidate-pool seed-7)
             (selection-fire-record
               (candidate-selection
                 3
                 ((candidate 0 (rule r0 A B AB Cat) 1)
                  (candidate 0 (rule r1 B Cat BCat A) 1)
                  (candidate 0 (rule r2 A Cat ACat B) 1))
                 (candidate 0 (rule r0 A B AB Cat) 1))
               (exp00-after-generated-chamber seed-7)))))
       False)

!(test (chamber-tick-result-outcome
         (exp00-initial-chamber seed-7)
         (chamber-tick-result-from-generated-record
           (exp00-initial-chamber seed-7)
           (generated-selection-fire-record
             (make-candidate-cap 2 1)
             (exp00-generated-candidate-pool seed-7)
             (selection-fire-record
               (candidate-selection
                 3
                 ((candidate 0 (rule r0 A B AB Cat) 1)
                  (candidate 0 (rule r1 B Cat BCat A) 1)
                  (candidate 0 (rule r2 A Cat ACat B) 1))
                 (candidate 0 (rule r0 A B AB Cat) 1))
               (exp00-after-generated-chamber seed-7)))))
       invalid-bounds)

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

; A zero per-rule allowance also closes the bounded selection path. Generic
; generation emits one candidate per source rule, so none may cross this cap.
!(test (bounded-candidate-pool
         (make-candidate-cap 2 0)
         (exp00-initial-chamber seed-7))
       (candidate-pool 0 ()))

!(test (candidate-selection-from-pool
         (make-candidate-cap 2 0)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (candidate-selection 0 () no-candidate))

!(test (chamber-tick-generated
         (make-candidate-cap 2 0)
         (exp00-initial-chamber seed-7))
       (exp00-initial-chamber seed-7))

; Malformed negative bounds are conservatively clamped to the same closed
; boundary instead of reaching an unsupported cap-candidate-pool operation.
!(test (effective-candidate-cap-per-tick
         (make-candidate-cap -1 1))
       0)

!(test (effective-candidate-cap
         (make-candidate-cap -1 1))
       (candidate-cap 0 0))

!(test (effective-candidate-cap
         (make-candidate-cap 0 3))
       (candidate-cap 0 0))

; Complete provenance retains both kinds of closed per-tick request while the
; effective cap closes both fields and the chamber remains unchanged.
!(test (generated-selection-fire-record-requested-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap -1 1)
           (exp00-initial-chamber seed-7)))
       (candidate-cap -1 1))

!(test (generated-selection-fire-record-effective-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap -1 1)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 0 0))

!(test (generated-selection-fire-record-requested-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 0 3)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 0 3))

!(test (generated-selection-fire-record-after-chamber
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 0 3)
           (exp00-initial-chamber seed-7)))
       (exp00-initial-chamber seed-7))

; A negative per-rule boundary closes both effective fields just like zero,
; and the complete generated record retains the malformed request for audit.
!(test (effective-candidate-cap
         (make-candidate-cap 2 -1))
       (candidate-cap 0 0))

!(test (generated-selection-fire-record-requested-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 2 -1)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 2 -1))

!(test (generated-selection-fire-record-effective-cap
         (generated-selection-fire-record-from-chamber
           (make-candidate-cap 2 -1)
           (exp00-initial-chamber seed-7)))
       (candidate-cap 0 0))

!(test (bounded-candidate-pool
         (make-candidate-cap -1 1)
         (exp00-initial-chamber seed-7))
       (candidate-pool 0 ()))

!(test (candidate-selection-from-pool
         (make-candidate-cap -1 1)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (candidate-selection 0 () no-candidate))

!(test (chamber-tick-generated
         (make-candidate-cap 2 -1)
         (exp00-initial-chamber seed-7))
       (exp00-initial-chamber seed-7))

; The base kernel explicitly supports at most eight generated candidates.
; Oversized allowances clamp to that supported boundary while preserving a
; smaller generated pool and the ordinary deterministic chamber tick.
!(test (effective-candidate-cap-per-tick
         (make-candidate-cap 9 1))
       8)

!(test (bounded-candidate-pool
         (make-candidate-cap 9 1)
         (exp00-initial-chamber seed-7))
       (candidate-pool
         0
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1))))

!(test (candidate-selection-from-pool
         (make-candidate-cap 9 1)
         (exp00-initial-chamber seed-7)
         (exp00-generated-candidate-pool seed-7))
       (candidate-selection
         8
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1))
         (candidate 0 (rule r0 A B AB Cat) 1)))

!(test (chamber-tick-generated
         (make-candidate-cap 9 1)
         (exp00-initial-chamber seed-7))
       (exp00-chamber-after-generated-tick seed-7))

; Generated pools enforce the same explicit eight-candidate kernel boundary.
; A ninth source rule remains chamber provenance but does not make generation
; irreducible; a smaller cap still selects and fires from the stable prefix.
!(test (generate-candidate-pool
         (make-chamber
           exp00-nine-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2))
           ()))
       (candidate-pool
         0
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1))))

!(test (chamber-tick-generated
         (make-candidate-cap 2 1)
         (make-chamber
           exp00-nine-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2))
           ()))
       (chamber
         exp00-nine-rules
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         ((rule r1 B Cat BCat A) (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B) (rule r1 B Cat BCat A)
          (rule r0 A B AB Cat) (rule r2 A Cat ACat B)
          (rule r1 B Cat BCat A) (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B))
         ((event 0 r0 A B AB Cat))))

; The same bounded prefix and ordinary selection-to-tick path remain total at
; the next oversized source-list boundary.
!(test (generate-candidate-pool
         (make-chamber
           exp00-ten-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1))
           ()))
       (candidate-pool
         0
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1))))

!(test (chamber-tick-generated
         (make-candidate-cap 2 1)
         (make-chamber
           exp00-ten-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1))
           ()))
       (chamber
         exp00-ten-rules
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         ((rule r1 B Cat BCat A) (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B) (rule r1 B Cat BCat A)
          (rule r0 A B AB Cat) (rule r2 A Cat ACat B)
          (rule r1 B Cat BCat A) (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B) (rule r1 B Cat BCat A))
         ((event 0 r0 A B AB Cat))))

; Eleven retained source rules remain total under the same bounded generation
; contract. The ownership guard also sees a source rewrite beyond the generated
; first-eight prefix, so provenance is not silently discarded by the cap.
!(test (generate-candidate-pool
         (make-chamber
           exp00-eleven-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (rule r10 A B AB Cat))
           ()))
       (candidate-pool
         0
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1))))

!(test (rule-rewrite-in-chamber-rules?
         (rule r10 A B AB Cat)
         ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
          (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
          (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
          (exp00-rule r1) (rule r10 A B AB Cat)))
       True)

!(test (chamber-tick-generated
         (make-candidate-cap 2 1)
         (make-chamber
           exp00-eleven-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (rule r10 A B AB Cat))
           ()))
       (chamber
         exp00-eleven-rules
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         ((rule r1 B Cat BCat A) (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B) (rule r1 B Cat BCat A)
          (rule r0 A B AB Cat) (rule r2 A Cat ACat B)
          (rule r1 B Cat BCat A) (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B) (rule r1 B Cat BCat A)
          (rule r10 A B AB Cat))
         ((event 0 r0 A B AB Cat))))

; Extend the explicit oversized boundary once more while preserving the same
; stable generated prefix, complete source-rule provenance, and direct tick.
!(test (generate-candidate-pool
         (make-chamber
           exp00-twelve-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
           ()))
       (candidate-pool
         0
         ((candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1)
          (candidate 0 (rule r2 A Cat ACat B) 1)
          (candidate 0 (rule r1 B Cat BCat A) 1)
          (candidate 0 (rule r0 A B AB Cat) 1))))

!(test (rule-rewrite-in-chamber-rules?
         (rule r11 A B AB Cat)
         ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
          (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
          (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
          (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat)))
       True)

!(test (chamber-tick-generated
         (make-candidate-cap 2 1)
         (make-chamber
           exp00-twelve-rules
           (exp00-initial-state seed-7)
           ((exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (exp00-rule r2)
            (exp00-rule r1) (exp00-rule r0) (rule r11 A B AB Cat))
           ()))
       (chamber
         exp00-twelve-rules
         (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
         ((rule r1 B Cat BCat A) (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B) (rule r1 B Cat BCat A)
          (rule r0 A B AB Cat) (rule r2 A Cat ACat B)
          (rule r1 B Cat BCat A) (rule r0 A B AB Cat)
          (rule r2 A Cat ACat B) (rule r1 B Cat BCat A)
          (rule r0 A B AB Cat) (rule r11 A B AB Cat))
         ((event 0 r0 A B AB Cat))))

!(test (generated-selection-fire-record-from-chamber
         (make-candidate-cap 2 1)
         (chamber exp00
                  (exp00-initial-state seed-7)
                  ()
                  ()))
       (generated-selection-fire-record
         (candidate-cap 2 1)
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

; Named molecule lists let matched experiments share one chemistry containing
; all reachable reactants, products, and catalysts while retaining the ordinary
; candidate applicability -> chamber tick path.
!(test (candidate-applicable-in-chamber?
         (candidate 3 (rule e5r0 A B AB CD) 1)
         (chamber exp00-multi
           (state 3 seed-7
             (molecules ((mol A 2) (mol B 1) (mol C 1)
                         (mol AB 1) (mol AC 1) (mol BC 1) (mol CD 1))))
           ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
           ()))
       True)

!(test (chamber-tick-with-candidate
         (chamber exp00-multi
           (state 3 seed-7
             (molecules ((mol A 2) (mol B 1) (mol C 1)
                         (mol AB 1) (mol AC 1) (mol BC 1) (mol CD 1))))
           ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
           ())
         (candidate 3 (rule e5r1 A C AC BC) 1))
       (chamber exp00-multi
         (state 4 seed-7
           (molecules ((mol A 1) (mol B 1) (mol C 0)
                       (mol AB 1) (mol AC 2) (mol BC 1) (mol CD 1))))
         ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
         ((event 3 e5r1 A C AC BC))))
