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
