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
