; exp05 soft-biased ecological autocatalysis: first PeTTa scaffold.
;
; This slice implements a generic, soft catalyst-affinity assignment seam.
; Molecules are represented by token-incidence signatures and catalyst weights
; depend only on overlap with the reaction product:
;
;   weight = 1 + strength * token-overlap(catalyst, product)
;
; The positive baseline keeps every candidate selectable.  Rule chemistry is
; supplied before assignment, and no RAF scanner/outcome is consulted.  The
; matched shuffled control retains the same catalyst candidates and rotates the
; complete weight profile by one position, preserving its exact multiset.
;
; This is assignment/control plumbing, not an emergence claim.
;
; Load chem_exp00.metta before this file so the shared `(rule ...)` schema and
; `seed-number` accessor are available. Direct relative imports are left to the
; caller because PeTTa resolves nested imports relative to the top-level file.

; ----- Generic token-incidence similarity -----
;
; PeTTa molecule names are atomic, so this bounded scaffold exposes their
; generated string signatures as four token bits.  Future generated pools can
; emit these facts from their molecule-token generator without changing the
; overlap or weighted-assignment functions.

(= (molecule-token-bit AB A) 1)
(= (molecule-token-bit AB B) 1)
(= (molecule-token-bit AB C) 0)
(= (molecule-token-bit AB D) 0)

(= (molecule-token-bit AC A) 1)
(= (molecule-token-bit AC B) 0)
(= (molecule-token-bit AC C) 1)
(= (molecule-token-bit AC D) 0)

(= (molecule-token-bit BC A) 0)
(= (molecule-token-bit BC B) 1)
(= (molecule-token-bit BC C) 1)
(= (molecule-token-bit BC D) 0)

(= (molecule-token-bit CD A) 0)
(= (molecule-token-bit CD B) 0)
(= (molecule-token-bit CD C) 1)
(= (molecule-token-bit CD D) 1)

(= (token-overlap $left $right)
   (+ (* (molecule-token-bit $left A) (molecule-token-bit $right A))
      (+ (* (molecule-token-bit $left B) (molecule-token-bit $right B))
         (+ (* (molecule-token-bit $left C) (molecule-token-bit $right C))
            (* (molecule-token-bit $left D) (molecule-token-bit $right D))))))

(= (soft-affinity-weight $strength $catalyst $product)
   (+ 1 (* $strength (token-overlap $catalyst $product))))

(= (exp05-catalyst-candidates) (AB AC BC CD))

(= (affinity-profile-4 $strength $product ($c0 $c1 $c2 $c3))
   ((soft-affinity-weight $strength $c0 $product)
    (soft-affinity-weight $strength $c1 $product)
    (soft-affinity-weight $strength $c2 $product)
    (soft-affinity-weight $strength $c3 $product)))

; One-position rotation of the treatment weights over the unchanged catalyst
; list.  For treatment weights (w0 w1 w2 w3), the control uses
; (w3 w0 w1 w2), preserving total weight and the exact weight multiset.
(= (shuffled-affinity-profile-4 $strength $product ($c0 $c1 $c2 $c3))
   ((soft-affinity-weight $strength $c3 $product)
    (soft-affinity-weight $strength $c0 $product)
    (soft-affinity-weight $strength $c1 $product)
    (soft-affinity-weight $strength $c2 $product)))

; ----- Seeded weighted assignment -----

(= (affinity-total-4 $w0 $w1 $w2 $w3)
   (+ $w0 (+ $w1 (+ $w2 $w3))))

(= (affinity-seed-tick $seed $tick)
   (+ (seed-number $seed) $tick))

(= (affinity-draw-4 $seed $tick $w0 $w1 $w2 $w3)
   (#mod (affinity-seed-tick $seed $tick)
         (affinity-total-4 $w0 $w1 $w2 $w3)))

(= (select-weighted-catalyst-4
      $seed $tick
      $c0 $w0 $c1 $w1 $c2 $w2 $c3 $w3)
   (let $draw (affinity-draw-4 $seed $tick $w0 $w1 $w2 $w3)
     (if (< $draw $w0)
         $c0
         (if (< $draw (+ $w0 $w1))
             $c1
             (if (< $draw (+ $w0 (+ $w1 $w2)))
                 $c2
                 $c3)))))

(= (soft-biased-catalyst-4
      $seed $tick $strength $product ($c0 $c1 $c2 $c3))
   (select-weighted-catalyst-4
     $seed $tick
     $c0 (soft-affinity-weight $strength $c0 $product)
     $c1 (soft-affinity-weight $strength $c1 $product)
     $c2 (soft-affinity-weight $strength $c2 $product)
     $c3 (soft-affinity-weight $strength $c3 $product)))

(= (shuffled-affinity-catalyst-4
      $seed $tick $strength $product ($c0 $c1 $c2 $c3))
   (select-weighted-catalyst-4
     $seed $tick
     $c0 (soft-affinity-weight $strength $c3 $product)
     $c1 (soft-affinity-weight $strength $c0 $product)
     $c2 (soft-affinity-weight $strength $c1 $product)
     $c3 (soft-affinity-weight $strength $c2 $product)))

; Catalyst-free source rules are instantiated only after their reactants and
; products are fixed.  These functions cannot inspect or repair RAF closure.
(= (assign-soft-biased-catalyst-4
      $seed $tick $strength
      (rule $id $a $b $product None)
      $candidates)
   (rule $id $a $b $product
         (soft-biased-catalyst-4
           $seed $tick $strength $product $candidates)))

(= (assign-shuffled-affinity-catalyst-4
      $seed $tick $strength
      (rule $id $a $b $product None)
      $candidates)
   (rule $id $a $b $product
         (shuffled-affinity-catalyst-4
           $seed $tick $strength $product $candidates)))

; ----- First inspectable fixture and explicit scientific boundary -----

(= (exp05-source-rule)
   (rule e5r0 A B AB None))

(= (exp05-affinity-assigned-rule $seed $tick $strength)
   (assign-soft-biased-catalyst-4
     $seed $tick $strength
     (exp05-source-rule)
     (exp05-catalyst-candidates)))

(= (exp05-shuffled-affinity-rule $seed $tick $strength)
   (assign-shuffled-affinity-catalyst-4
     $seed $tick $strength
     (exp05-source-rule)
     (exp05-catalyst-candidates)))

(= (exp05-first-slice-status)
   (exp05-status catalyst-affinity-scaffold
                 generic-similarity token-overlap
                 positive-baseline 1
                 treatment weighted-assignment
                 control rotated-weight-profile
                 raf-scan not-yet-run
                 emergence-claim none))

; ----- Candidate-pool projection for affinity-assigned source rules -----
;
; This keeps the soft-affinity assignment directly queryable as ordinary
; exp00 candidate atoms, so later chamber slices can reuse the existing bounded
; candidate-pool/cap machinery instead of adding a parallel selection path.

(= (exp05-second-source-rule)
   (rule e5r1 A C AC None))

(= (assign-soft-biased-candidate-4
      $seed $tick $strength
      (rule $id $a $b $product None)
      $candidates)
   (let $assigned-rule (assign-soft-biased-catalyst-4
                         $seed $tick $strength
                         (rule $id $a $b $product None)
                         $candidates)
     (make-candidate
       $tick
       $assigned-rule
       (soft-affinity-weight
         $strength
         (rule-catalyst $assigned-rule)
         $product))))

(= (assign-shuffled-affinity-candidate-4
      $seed $tick $strength
      (rule $id $a $b $product None)
      $candidates)
   (let $assigned-rule (assign-shuffled-affinity-catalyst-4
                         $seed $tick $strength
                         (rule $id $a $b $product None)
                         $candidates)
     (make-candidate
       $tick
       $assigned-rule
       (soft-affinity-weight
         $strength
         (rule-catalyst $assigned-rule)
         $product))))

(= (exp05-affinity-candidate-pool-2 $seed $tick $strength)
   (candidate-pool
     $tick
     ((assign-soft-biased-candidate-4
        $seed $tick $strength (exp05-source-rule) (exp05-catalyst-candidates))
      (assign-soft-biased-candidate-4
        $seed $tick $strength (exp05-second-source-rule) (exp05-catalyst-candidates)))))

(= (exp05-shuffled-affinity-candidate-pool-2 $seed $tick $strength)
   (candidate-pool
     $tick
     ((assign-shuffled-affinity-candidate-4
        $seed $tick $strength (exp05-source-rule) (exp05-catalyst-candidates))
      (assign-shuffled-affinity-candidate-4
        $seed $tick $strength (exp05-second-source-rule) (exp05-catalyst-candidates)))))

(= (exp05-affinity-bounded-first-candidate $seed $tick $strength)
   (cap-candidate-pool 1 (exp05-affinity-candidate-pool-2 $seed $tick $strength)))

; ----- Minimal chamber-ticking slice over affinity-assigned pools -----
;
; The source rules are still catalyst-free before assignment.  Each tick builds
; an affinity-assigned candidate pool, applies a bounded cap, chooses from the
; bounded candidates with exp00's seed/tick deterministic selector, and then
; hands the selected ordinary candidate to exp00 chamber ticking.  The rotated
; control follows the same path with only the weight-to-catalyst profile
; rotated.

(= (exp05-treatment-chamber seed-7 3)
   (chamber exp05-treatment
            (state 3 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol AB 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp05-rotated-control-chamber seed-7 3)
   (chamber exp05-rotated-control
            (state 3 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

; Matched second selector-phase fixture for exp07 seed variation.  With seed-8
; at tick 3, `(seed + tick) % 2 = 1`, so deterministic cap-2 selection chooses
; the second affinity-assigned source rule (`e5r1`).  The state makes that
; selected AC-producing rule productive without changing the assignment path.
(= (exp05-treatment-chamber seed-8 3)
   (chamber exp05-treatment
            (state 3 seed-8 (mol A 1) (mol C 1) (mol AC 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp05-rotated-control-chamber seed-8 3)
   (chamber exp05-rotated-control
            (state 3 seed-8 (mol A 1) (mol C 1) (mol AC 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

; Third small seed-sweep fixture for exp07.  Seed-9 returns to the first
; cap-2 selector phase at tick 3, and the affinity draw assigns `AC` as the
; selected catalyst.  The state keeps that catalyst present so the first
; candidate is still an ordinary productive exp00 chamber tick.
(= (exp05-treatment-chamber seed-9 3)
   (chamber exp05-treatment
            (state 3 seed-9 (mol A 1) (mol B 1) (mol AB 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp05-rotated-control-chamber seed-9 3)
   (chamber exp05-rotated-control
            (state 3 seed-9 (mol A 1) (mol B 1) (mol AB 0) (mol BC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

; Fourth seed-sweep fixture for exp07.  Seed-10 selects the second bounded
; candidate at tick 3, while the affinity draw assigns a different rotated
; control catalyst than seed-8.  Both treatment and control states keep the
; selected catalysts present so the second candidate is handed to ordinary
; productive chamber ticking.
(= (exp05-treatment-chamber seed-10 3)
   (chamber exp05-treatment
            (state 3 seed-10 (mol A 1) (mol C 1) (mol AC 0) (mol AC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp05-rotated-control-chamber seed-10 3)
   (chamber exp05-rotated-control
            (state 3 seed-10 (mol A 1) (mol C 1) (mol AC 0) (mol BC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))


; Fifth and sixth seed-sweep fixtures for exp07.  Seed-11 repeats the
; first-candidate selector phase with later affinity draws that select `BC`
; in treatment and `CD` in the rotated control.  Seed-12 repeats the
; second-candidate phase with `BC` selected in both treatment and rotated
; control.  The selected catalysts are present in-state, so each arm still
; verifies the selected bounded candidate is handed to productive exp00
; chamber ticking.
(= (exp05-treatment-chamber seed-11 3)
   (chamber exp05-treatment
            (state 3 seed-11 (mol A 1) (mol B 1) (mol AB 0) (mol BC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp05-rotated-control-chamber seed-11 3)
   (chamber exp05-rotated-control
            (state 3 seed-11 (mol A 1) (mol B 1) (mol AB 0) (mol CD 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp05-treatment-chamber seed-12 3)
   (chamber exp05-treatment
            (state 3 seed-12 (mol A 1) (mol C 1) (mol AC 0) (mol BC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp05-rotated-control-chamber seed-12 3)
   (chamber exp05-rotated-control
            (state 3 seed-12 (mol A 1) (mol C 1) (mol AC 0) (mol BC 1))
            ((exp05-source-rule) (exp05-second-source-rule))
            ()))

(= (exp05-affinity-selected-candidate-2 $seed $tick $strength)
   (let $pool (exp05-affinity-candidate-pool-2 $seed $tick $strength)
     (selected-candidate-from-list-2
       (exp05-treatment-chamber $seed $tick)
       (cap-candidate-pool 2 $pool))))

(= (exp05-shuffled-affinity-selected-candidate-2 $seed $tick $strength)
   (let $pool (exp05-shuffled-affinity-candidate-pool-2 $seed $tick $strength)
     (selected-candidate-from-list-2
       (exp05-rotated-control-chamber $seed $tick)
       (cap-candidate-pool 2 $pool))))

(= (exp05-chamber-tick-affinity-2 $seed $tick $strength)
   (chamber-tick-with-candidate
     (exp05-treatment-chamber $seed $tick)
     (exp05-affinity-selected-candidate-2 $seed $tick $strength)))

(= (exp05-chamber-tick-shuffled-affinity-2 $seed $tick $strength)
   (chamber-tick-with-candidate
     (exp05-rotated-control-chamber $seed $tick)
     (exp05-shuffled-affinity-selected-candidate-2 $seed $tick $strength)))

(= (exp05-chamber-ticking-slice-status)
   (exp05-status catalyst-affinity-to-chamber-tick
                 candidate-source affinity-assigned-pool
                 cap 2
                 selector deterministic-seed-tick
                 treatment weighted-assignment
                 control rotated-weight-profile
                 raf-scan not-yet-run
                 emergence-claim none))
