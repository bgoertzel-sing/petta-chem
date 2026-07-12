!(import! &self ../../src/chem_exp00.metta)
!(import! &self ../../src/chem_exp05.metta)

; Generic token-overlap similarity, not a product=catalyst lookup table.
!(test (token-overlap AB AB) 2)
!(test (token-overlap AC AB) 1)
!(test (token-overlap CD AB) 0)
!(test (token-overlap BC AC) 1)

; Strength zero is unbiased; strength one gives baseline-plus-overlap weights.
!(test (affinity-profile-4 0 AB (exp05-catalyst-candidates)) (1 1 1 1))
!(test (affinity-profile-4 1 AB (exp05-catalyst-candidates)) (3 2 2 1))
!(test (shuffled-affinity-profile-4 1 AB (exp05-catalyst-candidates)) (1 3 2 2))

; Seed-7/tick-0 draws 7 from total weight 8. Treatment therefore selects the
; last low-affinity candidate; the rotated control assigns the last candidate
; weight 2 and selects it as well. Tick 1 wraps to draw 0, exposing the changed
; weight-to-candidate association: treatment selects AB, control selects AB
; under only the rotated baseline interval. Tick 3 draws 2: treatment still AB,
; while the control selects AC.
!(test (affinity-draw-4 seed-7 0 3 2 2 1) 7)
!(test (soft-biased-catalyst-4 seed-7 3 1 AB (exp05-catalyst-candidates)) AB)
!(test (shuffled-affinity-catalyst-4 seed-7 3 1 AB (exp05-catalyst-candidates)) AC)

; Source chemistry is fixed before either assignment.
!(test (exp05-source-rule) (rule e5r0 A B AB None))
!(test (exp05-affinity-assigned-rule seed-7 3 1) (rule e5r0 A B AB AB))
!(test (exp05-shuffled-affinity-rule seed-7 3 1) (rule e5r0 A B AB AC))

!(test (exp05-first-slice-status)
       (exp05-status catalyst-affinity-scaffold
                     generic-similarity token-overlap
                     positive-baseline 1
                     treatment weighted-assignment
                     control rotated-weight-profile
                     raf-scan not-yet-run
                     emergence-claim none))

; Affinity assignment now projects into ordinary exp00 candidate-pool atoms so
; bounded candidate caps can be reused by later chamber-ticking slices.
!(test (exp05-second-source-rule) (rule e5r1 A C AC None))
!(test (assign-soft-biased-candidate-4
         seed-7 3 1 (exp05-source-rule) (exp05-catalyst-candidates))
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (assign-soft-biased-candidate-4
         seed-7 3 1 (exp05-second-source-rule) (exp05-catalyst-candidates))
       (candidate 3 (rule e5r1 A C AC AB) 2))
!(test (assign-shuffled-affinity-candidate-4
         seed-7 3 1 (exp05-source-rule) (exp05-catalyst-candidates))
       (candidate 3 (rule e5r0 A B AB AC) 2))
!(test (exp05-affinity-candidate-pool-2 seed-7 3 1)
       (candidate-pool 3
         ((candidate 3 (rule e5r0 A B AB AB) 3)
          (candidate 3 (rule e5r1 A C AC AB) 2))))
!(test (exp05-shuffled-affinity-candidate-pool-2 seed-7 3 1)
       (candidate-pool 3
         ((candidate 3 (rule e5r0 A B AB AC) 2)
          (candidate 3 (rule e5r1 A C AC AB) 2))))
!(test (exp05-affinity-bounded-first-candidate seed-7 3 1)
       ((candidate 3 (rule e5r0 A B AB AB) 3)))

; The projected affinity candidates now feed a minimal chamber tick directly:
; source rules -> affinity assignment -> cap-2 bounded pool -> deterministic
; seed/tick selector -> ordinary exp00 chamber ticking.  The matched rotated
; control uses the same path with only the weight profile rotated.
!(test (exp05-affinity-selected-candidate-2 seed-7 3 1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-7 3 1)
       (candidate 3 (rule e5r0 A B AB AC) 2))
!(test (exp05-chamber-tick-affinity-2 seed-7 3 1)
       (chamber exp05-treatment
                (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-7 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AC))))
; Seed-10 is the fourth exp07 selector-phase fixture: cap-2 selection chooses
; the second source rule, while the rotated control uses a distinct productive
; catalyst context from seed-8.
!(test (exp05-affinity-selected-candidate-2 seed-10 3 1)
       (candidate 3 (rule e5r1 A C AC AC) 3))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-10 3 1)
       (candidate 3 (rule e5r1 A C AC BC) 2))
!(test (exp05-chamber-tick-affinity-2 seed-10 3 1)
       (chamber exp05-treatment
                (state 4 seed-10 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC AC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-10 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-10 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC BC))))


; Seeds 11 and 12 extend exp07's strength-1/cap-2 provenance sweep while
; keeping the selected bounded candidates productive through ordinary exp00
; chamber ticking.
!(test (exp05-affinity-selected-candidate-2 seed-11 3 1)
       (candidate 3 (rule e5r0 A B AB BC) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-11 3 1)
       (candidate 3 (rule e5r0 A B AB CD) 1))
!(test (exp05-chamber-tick-affinity-2 seed-11 3 1)
       (chamber exp05-treatment
                (state 4 seed-11 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB BC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-11 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-11 (mol A 0) (mol B 0) (mol AB 1) (mol CD 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB CD))))
!(test (exp05-affinity-selected-candidate-2 seed-12 3 1)
       (candidate 3 (rule e5r1 A C AC BC) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-12 3 1)
       (candidate 3 (rule e5r1 A C AC BC) 2))
!(test (exp05-chamber-tick-affinity-2 seed-12 3 1)
       (chamber exp05-treatment
                (state 4 seed-12 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC BC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-12 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-12 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC BC))))
!(test (exp05-affinity-selected-candidate-2 seed-13 3 1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-13 3 1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp05-chamber-tick-affinity-2 seed-13 3 1)
       (chamber exp05-treatment
                (state 4 seed-13 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-13 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-13 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp05-affinity-selected-candidate-2 seed-14 3 1)
       (candidate 3 (rule e5r1 A C AC CD) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-14 3 1)
       (candidate 3 (rule e5r1 A C AC CD) 2))
!(test (exp05-chamber-tick-affinity-2 seed-14 3 1)
       (chamber exp05-treatment
                (state 4 seed-14 (mol A 0) (mol C 0) (mol AC 1) (mol CD 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC CD))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-14 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-14 (mol A 0) (mol C 0) (mol AC 1) (mol CD 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC CD))))
!(test (exp05-affinity-selected-candidate-2 seed-15 3 1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-15 3 1)
       (candidate 3 (rule e5r0 A B AB AC) 2))
!(test (exp05-chamber-tick-affinity-2 seed-15 3 1)
       (chamber exp05-treatment
                (state 4 seed-15 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-15 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-15 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AC))))
!(test (exp05-affinity-selected-candidate-2 seed-16 3 1)
       (candidate 3 (rule e5r1 A C AC AB) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-16 3 1)
       (candidate 3 (rule e5r1 A C AC AB) 2))
!(test (exp05-chamber-tick-affinity-2 seed-16 3 1)
       (chamber exp05-treatment
                (state 4 seed-16 (mol A 0) (mol C 0) (mol AC 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC AB))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-16 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-16 (mol A 0) (mol C 0) (mol AC 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC AB))))

!(test (exp05-affinity-selected-candidate-2 seed-17 3 1)
       (candidate 3 (rule e5r0 A B AB AC) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-17 3 1)
       (candidate 3 (rule e5r0 A B AB BC) 2))
!(test (exp05-chamber-tick-affinity-2 seed-17 3 1)
       (chamber exp05-treatment
                (state 4 seed-17 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-17 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-17 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB BC))))
!(test (exp05-affinity-selected-candidate-2 seed-18 3 1)
       (candidate 3 (rule e5r1 A C AC AC) 3))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-18 3 1)
       (candidate 3 (rule e5r1 A C AC AC) 3))
!(test (exp05-chamber-tick-affinity-2 seed-18 3 1)
       (chamber exp05-treatment
                (state 4 seed-18 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC AC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-18 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-18 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC AC))))
!(test (exp05-affinity-selected-candidate-2 seed-19 3 1)
       (candidate 3 (rule e5r0 A B AB BC) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-19 3 1)
       (candidate 3 (rule e5r0 A B AB CD) 1))
!(test (exp05-chamber-tick-affinity-2 seed-19 3 1)
       (chamber exp05-treatment
                (state 4 seed-19 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB BC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-19 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-19 (mol A 0) (mol B 0) (mol AB 1) (mol CD 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB CD))))
!(test (exp05-affinity-selected-candidate-2 seed-20 3 1)
       (candidate 3 (rule e5r1 A C AC BC) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-20 3 1)
       (candidate 3 (rule e5r1 A C AC BC) 2))
!(test (exp05-chamber-tick-affinity-2 seed-20 3 1)
       (chamber exp05-treatment
                (state 4 seed-20 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC BC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-20 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-20 (mol A 0) (mol C 0) (mol AC 1) (mol BC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC BC))))

!(test (exp05-affinity-selected-candidate-2 seed-21 3 1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-21 3 1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp05-chamber-tick-affinity-2 seed-21 3 1)
       (chamber exp05-treatment
                (state 4 seed-21 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-21 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-21 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp05-affinity-selected-candidate-2 seed-22 3 1)
       (candidate 3 (rule e5r1 A C AC CD) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-22 3 1)
       (candidate 3 (rule e5r1 A C AC CD) 2))
!(test (exp05-chamber-tick-affinity-2 seed-22 3 1)
       (chamber exp05-treatment
                (state 4 seed-22 (mol A 0) (mol C 0) (mol AC 1) (mol CD 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC CD))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-22 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-22 (mol A 0) (mol C 0) (mol AC 1) (mol CD 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC CD))))



!(test (exp05-affinity-selected-candidate-2 seed-23 3 1)
       (candidate 3 (rule e5r0 A B AB AB) 3))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-23 3 1)
       (candidate 3 (rule e5r0 A B AB AC) 2))
!(test (exp05-chamber-tick-affinity-2 seed-23 3 1)
       (chamber exp05-treatment
                (state 4 seed-23 (mol A 0) (mol B 0) (mol AB 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AB))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-23 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-23 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r0 A B AB AC))))
!(test (exp05-affinity-selected-candidate-2 seed-24 3 1)
       (candidate 3 (rule e5r1 A C AC AB) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-24 3 1)
       (candidate 3 (rule e5r1 A C AC AB) 2))
!(test (exp05-chamber-tick-affinity-2 seed-24 3 1)
       (chamber exp05-treatment
                (state 4 seed-24 (mol A 0) (mol C 0) (mol AC 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC AB))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-24 3 1)
       (chamber exp05-rotated-control
                (state 4 seed-24 (mol A 0) (mol C 0) (mol AC 1) (mol AB 1))
                ((rule e5r0 A B AB None) (rule e5r1 A C AC None))
                ((event 3 e5r1 A C AC AB))))

!(test (exp05-affinity-selected-candidate-2 seed-25 3 1) (candidate 3 (rule e5r0 A B AB AC) 2))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-25 3 1) (candidate 3 (rule e5r0 A B AB BC) 2))
!(test (exp05-chamber-tick-affinity-2 seed-25 3 1) (chamber exp05-treatment (state 4 seed-25 (mol A 0) (mol B 0) (mol AB 1) (mol AC 1)) ((rule e5r0 A B AB None) (rule e5r1 A C AC None)) ((event 3 e5r0 A B AB AC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-25 3 1) (chamber exp05-rotated-control (state 4 seed-25 (mol A 0) (mol B 0) (mol AB 1) (mol BC 1)) ((rule e5r0 A B AB None) (rule e5r1 A C AC None)) ((event 3 e5r0 A B AB BC))))
!(test (exp05-affinity-selected-candidate-2 seed-26 3 1) (candidate 3 (rule e5r1 A C AC AC) 3))
!(test (exp05-shuffled-affinity-selected-candidate-2 seed-26 3 1) (candidate 3 (rule e5r1 A C AC AC) 3))
!(test (exp05-chamber-tick-affinity-2 seed-26 3 1) (chamber exp05-treatment (state 4 seed-26 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1)) ((rule e5r0 A B AB None) (rule e5r1 A C AC None)) ((event 3 e5r1 A C AC AC))))
!(test (exp05-chamber-tick-shuffled-affinity-2 seed-26 3 1) (chamber exp05-rotated-control (state 4 seed-26 (mol A 0) (mol C 0) (mol AC 1) (mol AC 1)) ((rule e5r0 A B AB None) (rule e5r1 A C AC None)) ((event 3 e5r1 A C AC AC))))

!(test (exp05-chamber-ticking-slice-status)
       (exp05-status catalyst-affinity-to-chamber-tick
                     candidate-source affinity-assigned-pool
                     cap 2
                     selector deterministic-seed-tick
                     treatment weighted-assignment
                     control rotated-weight-profile
                     raf-scan not-yet-run
                     emergence-claim none))
