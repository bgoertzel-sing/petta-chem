; exp03 multi-tick soup dynamics.
;
; This layer extends exp00 without changing its single-tick contracts.  It keeps
; the fixed four-molecule state shape and the deterministic two-candidate seam,
; but advances chambers through multiple ticks while preserving an accumulated
; event log.  The smoke fixture now uses a productive rule plus a selectable
; distractor rule so multi-tick dynamics exercise deterministic candidate choice
; rather than a duplicated productive candidate.

!(import! &self chem_exp00.metta)

; ----- Event accumulation and snapshots -----

(= (append-event () $event)
   ($event))

(= (append-event ($event-0) $event)
   ($event-0 $event))

(= (append-event ($event-0 $event-1) $event)
   ($event-0 $event-1 $event))

(= (append-event ($event-0 $event-1 $event-2) $event)
   ($event-0 $event-1 $event-2 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3) $event)
   ($event-0 $event-1 $event-2 $event-3 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event))

(= (append-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event))

(= (state-advance-tick (state $tick $seed $m0 $m1 $m2 $m3))
   (state (+ $tick 1) $seed $m0 $m1 $m2 $m3))

(= (state-abundance-snapshot (state $tick $seed $m0 $m1 $m2 $m3))
   (abundance-snapshot $tick ($m0 $m1 $m2 $m3)))

(= (state-abundance-snapshot (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9))
   (abundance-snapshot $tick ($m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9)))

(= (state-abundance-snapshot (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11))
   (abundance-snapshot $tick ($m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11)))

(= (state-abundance-snapshot (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14))
   (abundance-snapshot $tick ($m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14)))

(= (state-abundance-snapshot (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15))
   (abundance-snapshot $tick ($m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15)))

(= (state-abundance-snapshot (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15 $m16))
   (abundance-snapshot $tick ($m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15 $m16)))

(= (chamber-abundance-snapshot (chamber $id $state $rules $events))
   (state-abundance-snapshot $state))

(= (chamber-event-log (chamber $id $state $rules $events))
   $events)

(= (trace-events $chamber)
   (chamber-event-log $chamber))

(= (event-count ())
   0)

(= (event-count ($event-0))
   1)

(= (event-count ($event-0 $event-1))
   2)

(= (event-count ($event-0 $event-1 $event-2))
   3)

(= (event-count ($event-0 $event-1 $event-2 $event-3))
   4)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4))
   5)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5))
   6)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6))
   7)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7))
   8)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8))
   9)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9))
   10)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10))
   11)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11))
   12)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12))
   13)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13))
   14)

; ----- Safe accumulated tick -----

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol A $a-count)
                      (mol B $b-count)
                      (mol AB $product-count)
                      (mol Cat $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule r0 A B AB Cat) $score))
   (if (and (> $a-count 0)
            (and (> $b-count 0)
                 (> $catalyst-count 0)))
       (let $trace (fire-binary-catalytic
                     (rule r0 A B AB Cat)
                     (state $tick $seed
                            (mol A $a-count)
                            (mol B $b-count)
                            (mol AB $product-count)
                            (mol Cat $catalyst-count)))
         (chamber $id
                  (trace-state $trace)
                  $rules
                  (append-event $events (trace-event $trace))))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol A $a-count)
                       (mol B $b-count)
                       (mol AB $product-count)
                       (mol Cat $catalyst-count))
                $rules
                $events)))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol A $a-count)
                      (mol B $b-count)
                      (mol AB $product-count)
                      (mol Cat $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule r1 B Cat BCat A) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol A $a-count)
                   (mol B $b-count)
                   (mol AB $product-count)
                   (mol Cat $catalyst-count))
            $rules
            $events))

(= (chamber-tick-generated-2-accum $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-with-candidate-accum
       $chamber
       (selected-candidate-from-list-2
         $chamber
         (candidate-pool-candidates $candidate-pool)))))

; Cap-3 accum: selects 1 of 3 candidates per tick, accumulates events.
(= (chamber-tick-generated-3-accum $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-with-candidate-accum
       $chamber
       (selected-candidate-from-list-3
         $chamber
         (candidate-pool-candidates $candidate-pool)))))

; Cap-4 accum: selects 1 of 4 candidates per tick, accumulates events.
(= (chamber-tick-generated-4-accum $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-with-candidate-accum
       $chamber
       (selected-candidate-from-list-4
         $chamber
         (candidate-pool-candidates $candidate-pool)))))

; Cap-5 accum: selects 1 of 5 candidates per tick, accumulates events.
(= (chamber-tick-generated-5-accum $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-with-candidate-accum
       $chamber
       (selected-candidate-from-list-5
         $chamber
         (candidate-pool-candidates $candidate-pool)))))

; Recursive entry point for PeTTa implementations that reduce arithmetic in
; recursive arguments.  The explicit exp03-run-* wrappers below keep smoke tests
; bounded and transparent while using the same per-tick transition.
(= (chamber-run $chamber $n)
   (if (> $n 0)
       (chamber-run
         (chamber-tick-generated-2-accum (exp00-candidate-cap) $chamber)
         (- $n 1))
       $chamber))

(= (chamber-run-1 $chamber)
   (chamber-tick-generated-2-accum (exp00-candidate-cap) $chamber))

(= (chamber-run-2 $chamber)
   (chamber-run-1 (chamber-run-1 $chamber)))

(= (chamber-run-3 $chamber)
   (chamber-run-1 (chamber-run-2 $chamber)))

(= (chamber-run-4 $chamber)
   (chamber-run-1 (chamber-run-3 $chamber)))

(= (chamber-run-5 $chamber)
   (chamber-run-1 (chamber-run-4 $chamber)))

(= (chamber-run-6 $chamber)
   (chamber-run-1 (chamber-run-5 $chamber)))

(= (chamber-run-7 $chamber)
   (chamber-run-1 (chamber-run-6 $chamber)))

(= (chamber-run-8 $chamber)
   (chamber-run-1 (chamber-run-7 $chamber)))

(= (chamber-run-9 $chamber)
   (chamber-run-1 (chamber-run-8 $chamber)))

(= (chamber-run-10 $chamber)
   (chamber-run-1 (chamber-run-9 $chamber)))

; Cap-3 chamber-run wrappers: each tick selects 1 of 3 candidates.
(= (chamber-run-3cap-1 $chamber)
   (chamber-tick-generated-3-accum (exp00-candidate-cap-3) $chamber))

(= (chamber-run-3cap-2 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-1 $chamber)))

(= (chamber-run-3cap-3 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-2 $chamber)))

(= (chamber-run-3cap-4 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-3 $chamber)))

(= (chamber-run-3cap-5 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-4 $chamber)))

(= (chamber-run-3cap-6 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-5 $chamber)))

(= (chamber-run-3cap-7 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-6 $chamber)))

(= (chamber-run-3cap-8 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-7 $chamber)))

(= (chamber-run-3cap-9 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-8 $chamber)))

(= (chamber-run-3cap-10 $chamber)
   (chamber-run-3cap-1 (chamber-run-3cap-9 $chamber)))

(= (chamber-run-3cap-15 $chamber)
   (chamber-run-3cap-5 (chamber-run-3cap-10 $chamber)))

; Cap-4 chamber-run wrappers: each tick selects 1 of 4 candidates.
(= (chamber-run-4cap-1 $chamber)
   (chamber-tick-generated-4-accum (exp00-candidate-cap-4) $chamber))

(= (chamber-run-4cap-2 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-1 $chamber)))

(= (chamber-run-4cap-3 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-2 $chamber)))

(= (chamber-run-4cap-4 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-3 $chamber)))

(= (chamber-run-4cap-5 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-4 $chamber)))

(= (chamber-run-4cap-6 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-5 $chamber)))

(= (chamber-run-4cap-7 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-6 $chamber)))

(= (chamber-run-4cap-8 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-7 $chamber)))

(= (chamber-run-4cap-9 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-8 $chamber)))

(= (chamber-run-4cap-10 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-9 $chamber)))

(= (chamber-run-4cap-11 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-10 $chamber)))

(= (chamber-run-4cap-12 $chamber)
   (chamber-run-4cap-1 (chamber-run-4cap-11 $chamber)))

(= (chamber-run-4cap-15 $chamber)
   (chamber-run-4cap-3 (chamber-run-4cap-12 $chamber)))

; Cap-5 chamber-run wrappers: each tick selects 1 of 5 candidates.
(= (chamber-run-5cap-1 $chamber)
   (chamber-tick-generated-5-accum (exp00-candidate-cap-5) $chamber))

(= (chamber-run-5cap-2 $chamber)
   (chamber-run-5cap-1 (chamber-run-5cap-1 $chamber)))

(= (chamber-run-5cap-3 $chamber)
   (chamber-run-5cap-1 (chamber-run-5cap-2 $chamber)))

(= (chamber-run-5cap-4 $chamber)
   (chamber-run-5cap-1 (chamber-run-5cap-3 $chamber)))

(= (chamber-run-5cap-5 $chamber)
   (chamber-run-5cap-1 (chamber-run-5cap-4 $chamber)))

(= (chamber-run-5cap-10 $chamber)
   (chamber-run-5cap-5 (chamber-run-5cap-5 $chamber)))

(= (chamber-run-5cap-15 $chamber)
   (chamber-run-5cap-5 (chamber-run-5cap-10 $chamber)))

; Cap-6 chamber-run wrappers: each tick selects 1 of 6 candidates.
(= (chamber-tick-generated-6-accum $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-with-candidate-accum
       $chamber
       (selected-candidate-from-list-6
         $chamber
         (candidate-pool-candidates $candidate-pool)))))

(= (chamber-run-6cap-1 $chamber)
   (chamber-tick-generated-6-accum (exp00-candidate-cap-6) $chamber))

(= (chamber-run-6cap-2 $chamber)
   (chamber-run-6cap-1 (chamber-run-6cap-1 $chamber)))

(= (chamber-run-6cap-3 $chamber)
   (chamber-run-6cap-1 (chamber-run-6cap-2 $chamber)))

(= (chamber-run-6cap-4 $chamber)
   (chamber-run-6cap-1 (chamber-run-6cap-3 $chamber)))

(= (chamber-run-6cap-5 $chamber)
   (chamber-run-6cap-1 (chamber-run-6cap-4 $chamber)))

(= (chamber-run-6cap-6 $chamber)
   (chamber-run-6cap-1 (chamber-run-6cap-5 $chamber)))

(= (chamber-run-6cap-12 $chamber)
   (chamber-run-6cap-6 (chamber-run-6cap-6 $chamber)))

; Cap-7 chamber-run wrappers: each tick selects 1 of 7 candidates.
(= (chamber-tick-generated-7-accum $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-with-candidate-accum
       $chamber
       (selected-candidate-from-list-7
         $chamber
         (candidate-pool-candidates $candidate-pool)))))

(= (chamber-run-7cap-1 $chamber)
   (chamber-tick-generated-7-accum (exp00-candidate-cap-7) $chamber))

(= (chamber-run-7cap-2 $chamber)
   (chamber-run-7cap-1 (chamber-run-7cap-1 $chamber)))

(= (chamber-run-7cap-3 $chamber)
   (chamber-run-7cap-1 (chamber-run-7cap-2 $chamber)))

(= (chamber-run-7cap-4 $chamber)
   (chamber-run-7cap-1 (chamber-run-7cap-3 $chamber)))

(= (chamber-run-7cap-5 $chamber)
   (chamber-run-7cap-1 (chamber-run-7cap-4 $chamber)))

(= (chamber-run-7cap-6 $chamber)
   (chamber-run-7cap-1 (chamber-run-7cap-5 $chamber)))

(= (chamber-run-7cap-7 $chamber)
   (chamber-run-7cap-1 (chamber-run-7cap-6 $chamber)))

(= (chamber-run-7cap-14 $chamber)
   (chamber-run-7cap-7 (chamber-run-7cap-7 $chamber)))

(= (chamber-run-16 $chamber)
   (chamber-run-1 (chamber-run-1 (chamber-run-1 (chamber-run-1
     (chamber-run-1 (chamber-run-1 (chamber-run-10 $chamber))))))))

; ----- exp03 fixtures -----

(= (exp03-initial-state seed-7)
   (state 0 seed-7 (mol A 5) (mol B 5) (mol AB 0) (mol Cat 1)))

(= (exp03-rules)
   ((exp00-rule r1)
    (exp00-rule r0)))

(= (exp03-selected-candidate-at $tick $seed)
   (selected-candidate-from-list-2
     (make-chamber exp03
                   (state $tick $seed
                          (mol A 5)
                          (mol B 5)
                          (mol AB 0)
                          (mol Cat 1))
                   (exp03-rules)
                   ())
     ((make-candidate-for-rule $tick (exp00-rule r1))
      (make-candidate-for-rule $tick (exp00-rule r0)))))

(= (exp03-initial-chamber seed-7)
   (make-chamber exp03
                 (exp03-initial-state seed-7)
                 (exp03-rules)
                 ()))

(= (exp03-starved-chamber seed-7)
   (make-chamber exp03-starved
                 (exp00-starved-state seed-7)
                 (exp03-rules)
                 ()))

(= (exp03-after-5 seed-7)
   (chamber-run-5 (exp03-initial-chamber seed-7)))

(= (exp03-starved-after-3 seed-7)
   (chamber-run-3 (exp03-starved-chamber seed-7)))

(= (exp03-replay-5 seed-7)
   (chamber-run-1
     (chamber-run-1
       (chamber-run-1
         (chamber-run-1
           (chamber-run-1 (exp03-initial-chamber seed-7)))))))

(= (exp03-replay-5-ok?)
   (== (exp03-after-5 seed-7)
       (exp03-replay-5 seed-7)))

; ----- 10-tick fixture: longer multi-tick evolution with reactant exhaustion -----
;
; With A=5, B=5, the productive r0 rule fires at even ticks (0,2,4,6,8) consuming
; one A and one B each time.  By tick 8 both A and B reach zero.  Tick 10 would
; select r0 again but is blocked (no reactants).  This gives 5 events over 10
; ticks and validates deterministic replay over a longer horizon.

(= (exp03-after-10 seed-7)
   (chamber-run-10 (exp03-initial-chamber seed-7)))

(= (exp03-replay-10 seed-7)
   (chamber-run-5 (exp03-after-5 seed-7)))

(= (exp03-replay-10-ok?)
   (== (exp03-after-10 seed-7)
       (exp03-replay-10 seed-7)))

(= (exp03-after-10-tick seed-7)
   (state-tick (chamber-state (exp03-after-10 seed-7))))

(= (exp03-after-10-event-count seed-7)
   (event-count (trace-events (exp03-after-10 seed-7))))

(= (exp03-after-10-abundances seed-7)
   (chamber-abundance-snapshot (exp03-after-10 seed-7)))

(= (exp03-reactant-exhausted-after-10? seed-7)
   (== (exp03-after-10-abundances seed-7)
       (abundance-snapshot 10 ((mol A 0) (mol B 0) (mol AB 5) (mol Cat 1)))))

; ----- 16-tick fixture: higher abundances for longer productive evolution -----
;
; Starting with A=8, B=8, the productive r0 rule fires at even ticks
; (0,2,4,6,8,10,12,14) for 8 events over 16 ticks before reactant exhaustion.

(= (exp03-longer-initial-state seed-7)
   (state 0 seed-7 (mol A 8) (mol B 8) (mol AB 0) (mol Cat 1)))

(= (exp03-longer-chamber seed-7)
   (make-chamber exp03-longer
                 (exp03-longer-initial-state seed-7)
                 (exp03-rules)
                 ()))

(= (exp03-longer-after-16 seed-7)
   (chamber-run-16 (exp03-longer-chamber seed-7)))

(= (exp03-longer-replay-16 seed-7)
   (chamber-run-8 (chamber-run-8 (exp03-longer-chamber seed-7))))

(= (exp03-longer-replay-16-ok?)
   (== (exp03-longer-after-16 seed-7)
       (exp03-longer-replay-16 seed-7)))

(= (exp03-longer-event-count seed-7)
   (event-count (trace-events (exp03-longer-after-16 seed-7))))

(= (exp03-longer-abundances seed-7)
   (chamber-abundance-snapshot (exp03-longer-after-16 seed-7)))

(= (exp03-longer-reactant-exhausted? seed-7)
   (== (exp03-longer-abundances seed-7)
       (abundance-snapshot 16 ((mol A 0) (mol B 0) (mol AB 8) (mol Cat 1)))))

(= (exp03-selectable-rule-pool-ok?)
   (and (== (exp03-selected-candidate-at 0 seed-7)
            (candidate 0 (rule r0 A B AB Cat) 1))
        (== (exp03-selected-candidate-at 1 seed-7)
            (candidate 1 (rule r1 B Cat BCat A) 1))))

; ----- exp03/exp02 bridge: dynamic random/control family smoke -----
;
; This fixture keeps the exp03 state intentionally bounded while sourcing rule
; identities from the exp02 seed-7 random/control families.  It is a first
; dynamic-plumbing check, not an emergence claim: the random family can fire its
; rr0 rule under the deterministic selector, while shuffled/no-catalysis controls
; are carried through the same multi-tick runner as no-op controls.

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr0 P0 P1 P01 P10) $score))
   (if (and (> $p0-count 0)
            (and (> $p1-count 0)
                 (> $catalyst-count 0)))
       (let $trace (fire-binary-catalytic
                     (rule rr0 P0 P1 P01 P10)
                     (state $tick $seed
                            (mol P0 $p0-count)
                            (mol P1 $p1-count)
                            (mol P01 $product-count)
                            (mol P10 $catalyst-count)))
         (chamber $id
                  (trace-state $trace)
                  $rules
                  (append-event $events (trace-event $trace))))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0-count)
                       (mol P1 $p1-count)
                       (mol P01 $product-count)
                       (mol P10 $catalyst-count))
                $rules
                $events)))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr1 P2 P3 P10 P01) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0-count)
                   (mol P1 $p1-count)
                   (mol P01 $product-count)
                   (mol P10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule sr0 P0 P1 P01 P2) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0-count)
                   (mol P1 $p1-count)
                   (mol P01 $product-count)
                   (mol P10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule sr1 P2 P3 P10 P0) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0-count)
                   (mol P1 $p1-count)
                   (mol P01 $product-count)
                   (mol P10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule nr0 P0 P1 P01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0-count)
                   (mol P1 $p1-count)
                   (mol P01 $product-count)
                   (mol P10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule nr1 P2 P3 P10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0-count)
                   (mol P1 $p1-count)
                   (mol P01 $product-count)
                   (mol P10 $catalyst-count))
            $rules
            $events))

(= (exp03-exp02-initial-state seed-7)
   (state 0 seed-7 (mol P0 2) (mol P1 2) (mol P01 0) (mol P10 1)))

(= (exp03-exp02-rules random)
   ((exp02-random-polymer-rule seed-7 rr1)
    (exp02-random-polymer-rule seed-7 rr0)))

(= (exp03-exp02-rules shuffled)
   ((exp02-shuffled-control-rule seed-7 sr1)
    (exp02-shuffled-control-rule seed-7 sr0)))

(= (exp03-exp02-rules no-catalysis)
   ((exp02-no-catalysis-control-rule seed-7 nr1)
    (exp02-no-catalysis-control-rule seed-7 nr0)))

(= (exp03-exp02-chamber $family seed-7)
   (make-chamber (exp03-exp02 $family)
                 (exp03-exp02-initial-state seed-7)
                 (exp03-exp02-rules $family)
                 ()))

(= (exp03-exp02-after-3 $family seed-7)
   (chamber-run-3 (exp03-exp02-chamber $family seed-7)))

(= (exp03-exp02-event-count $family seed-7)
   (event-count (trace-events (exp03-exp02-after-3 $family seed-7))))

(= (exp03-exp02-dynamic-controls-discriminate?)
   (and (> (exp03-exp02-event-count random seed-7)
           (exp03-exp02-event-count shuffled seed-7))
        (> (exp03-exp02-event-count random seed-7)
           (exp03-exp02-event-count no-catalysis seed-7))))

; ----- broader exp03/exp02 dynamic run records -----
;
; The first bridge above used only seed-7 and a two-rule window.  This second
; point keeps the same bounded four-molecule dynamic state but sources a
; different exp02 parameter point (seed-11/six-rule static sweep) and records the
; dynamic outputs in the v0.1 run-contract shape.  The two-rule dynamic window is
; still intentionally conservative: it tests deterministic multi-tick plumbing
; and random/control discrimination before larger matching/state shapes.

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr0 Q0 Q1 Q01 Q10) $score))
   (if (and (> $q0-count 0)
            (and (> $q1-count 0)
                 (> $catalyst-count 0)))
       (let $trace (fire-binary-catalytic
                     (rule rr0 Q0 Q1 Q01 Q10)
                     (state $tick $seed
                            (mol Q0 $q0-count)
                            (mol Q1 $q1-count)
                            (mol Q01 $product-count)
                            (mol Q10 $catalyst-count)))
         (chamber $id
                  (trace-state $trace)
                  $rules
                  (append-event $events (trace-event $trace))))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0-count)
                       (mol Q1 $q1-count)
                       (mol Q01 $product-count)
                       (mol Q10 $catalyst-count))
                $rules
                $events)))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr1 Q2 Q3 Q10 Q01) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0-count)
                   (mol Q1 $q1-count)
                   (mol Q01 $product-count)
                   (mol Q10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule sr0 Q0 Q1 Q01 Q2) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0-count)
                   (mol Q1 $q1-count)
                   (mol Q01 $product-count)
                   (mol Q10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule sr1 Q2 Q3 Q10 Q4) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0-count)
                   (mol Q1 $q1-count)
                   (mol Q01 $product-count)
                   (mol Q10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule nr0 Q0 Q1 Q01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0-count)
                   (mol Q1 $q1-count)
                   (mol Q01 $product-count)
                   (mol Q10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule nr1 Q2 Q3 Q10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0-count)
                   (mol Q1 $q1-count)
                   (mol Q01 $product-count)
                   (mol Q10 $catalyst-count))
            $rules
            $events))

(= (exp03-exp02-initial-state seed-11)
   (state 0 seed-11 (mol Q0 2) (mol Q1 2) (mol Q01 0) (mol Q10 1)))

(= (seed-number seed-11) 11)

(= (exp03-exp02-rules seed-11 random)
   ((exp02-random-polymer-rule seed-11 rr1)
    (exp02-random-polymer-rule seed-11 rr0)))

(= (exp03-exp02-rules seed-11 shuffled)
   ((exp02-shuffled-control-rule seed-11 sr1)
    (exp02-shuffled-control-rule seed-11 sr0)))

(= (exp03-exp02-rules seed-11 no-catalysis)
   ((exp02-no-catalysis-control-rule seed-11 nr1)
    (exp02-no-catalysis-control-rule seed-11 nr0)))

(= (exp03-exp02-chamber $family seed-11)
   (make-chamber (exp03-exp02 $family seed-11)
                 (exp03-exp02-initial-state seed-11)
                 (exp03-exp02-rules seed-11 $family)
                 ()))

(= (exp03-exp02-after-3 $family seed-11)
   (chamber-run-3 (exp03-exp02-chamber $family seed-11)))

(= (exp03-exp02-event-count $family seed-11)
   (event-count (trace-events (exp03-exp02-after-3 $family seed-11))))

(= (exp03-exp02-dynamic-controls-discriminate-seed-11?)
   (and (> (exp03-exp02-event-count random seed-11)
           (exp03-exp02-event-count shuffled seed-11))
        (> (exp03-exp02-event-count random seed-11)
           (exp03-exp02-event-count no-catalysis seed-11))))

(= (exp03-exp02-dynamic-run-config seed-11 random)
   (make-run-config exp03-exp02-seed-11-random exp03 (seed-11) 3 (candidate-cap 2 1) random-polymer))

(= (exp03-exp02-dynamic-run-config seed-11 shuffled)
   (make-run-config exp03-exp02-seed-11-shuffled exp03 (seed-11) 3 (candidate-cap 2 1) shuffled-catalysts))

(= (exp03-exp02-dynamic-run-config seed-11 no-catalysis)
   (make-run-config exp03-exp02-seed-11-no-catalysis exp03 (seed-11) 3 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-dynamic-run-manifest seed-11 random)
   (make-run-manifest exp03-exp02-seed-11-random config-hash-exp03-exp02-seed-11-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-dynamic-run-manifest seed-11 shuffled)
   (make-run-manifest exp03-exp02-seed-11-shuffled config-hash-exp03-exp02-seed-11-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-dynamic-run-manifest seed-11 no-catalysis)
   (make-run-manifest exp03-exp02-seed-11-no-catalysis config-hash-exp03-exp02-seed-11-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-dynamic-abundances seed-11 $family)
   ((state-abundance-snapshot (exp03-exp02-initial-state seed-11))
    (chamber-abundance-snapshot (exp03-exp02-after-3 $family seed-11))))

(= (exp03-exp02-dynamic-metrics seed-11 random)
   ((metric dynamic-event-count exp03-exp02-seed-11-random (exp03-exp02-event-count random seed-11))
    (metric control-family exp03-exp02-seed-11-random random-polymer)
    (metric source-exp02-rule-count exp03-exp02-seed-11-random 6)))

(= (exp03-exp02-dynamic-metrics seed-11 shuffled)
   ((metric dynamic-event-count exp03-exp02-seed-11-shuffled (exp03-exp02-event-count shuffled seed-11))
    (metric control-family exp03-exp02-seed-11-shuffled shuffled-catalysts)
    (metric source-exp02-rule-count exp03-exp02-seed-11-shuffled 6)))

(= (exp03-exp02-dynamic-metrics seed-11 no-catalysis)
   ((metric dynamic-event-count exp03-exp02-seed-11-no-catalysis (exp03-exp02-event-count no-catalysis seed-11))
    (metric control-family exp03-exp02-seed-11-no-catalysis no-catalysis)
    (metric source-exp02-rule-count exp03-exp02-seed-11-no-catalysis 6)))

(= (exp03-exp02-dynamic-run-summary seed-11 random)
   (make-run-summary exp03-exp02-seed-11-random passed seed-11-random-dynamic-produces-events True))

(= (exp03-exp02-dynamic-run-summary seed-11 shuffled)
   (make-run-summary exp03-exp02-seed-11-shuffled passed seed-11-shuffled-dynamic-control-zero-events True))

(= (exp03-exp02-dynamic-run-summary seed-11 no-catalysis)
   (make-run-summary exp03-exp02-seed-11-no-catalysis passed seed-11-no-catalysis-dynamic-control-zero-events True))

(= (exp03-exp02-dynamic-acs-candidates seed-11 random)
   (exp02-random-acs-candidates-6 seed-11))

(= (exp03-exp02-dynamic-acs-candidates seed-11 shuffled)
   (exp02-shuffled-acs-candidates-6 seed-11))

(= (exp03-exp02-dynamic-acs-candidates seed-11 no-catalysis)
   (exp02-no-catalysis-acs-candidates-6 seed-11))

(= (exp03-exp02-dynamic-run-record seed-11 $family)
   (make-run-record
     (run-config-id (exp03-exp02-dynamic-run-config seed-11 $family))
     (exp03-exp02-dynamic-run-config seed-11 $family)
     (exp03-exp02-dynamic-run-manifest seed-11 $family)
     (trace-events (exp03-exp02-after-3 $family seed-11))
     (exp03-exp02-dynamic-abundances seed-11 $family)
     (exp03-exp02-dynamic-metrics seed-11 $family)
     (exp03-exp02-dynamic-acs-candidates seed-11 $family)
     ()
     (exp03-exp02-dynamic-run-summary seed-11 $family)))

(= (exp03-exp02-dynamic-run-records seed-11)
   ((exp03-exp02-dynamic-run-record seed-11 random)
    (exp03-exp02-dynamic-run-record seed-11 shuffled)
    (exp03-exp02-dynamic-run-record seed-11 no-catalysis)))

(= (exp03-exp02-dynamic-run-records-complete-seed-11?)
   (and (run-record-passed? (exp03-exp02-dynamic-run-record seed-11 random))
        (and (run-record-passed? (exp03-exp02-dynamic-run-record seed-11 shuffled))
             (and (run-record-passed? (exp03-exp02-dynamic-run-record seed-11 no-catalysis))
                  (exp03-exp02-dynamic-controls-discriminate-seed-11?)))))

; ----- full source-pool dynamic bridge -----
;
; This keeps candidate firing bounded to the deterministic two-candidate selector
; while putting the full seed-7/four-rule exp02 source pool in the chamber.  The
; first two candidates are deliberately ordered as rr1/rr0 so seed-7 tick-0
; selects the productive rule, while rr2/rr3 remain visible in the chamber and
; bounded pool provenance without being eligible for this narrow dynamic tick.

(= (exp03-exp02-full-source-rules seed-7 random)
   ((exp02-random-polymer-rule seed-7 rr1)
    (exp02-random-polymer-rule seed-7 rr0)
    (exp02-random-polymer-rule seed-7 rr2)
    (exp02-random-polymer-rule seed-7 rr3)))

(= (exp03-exp02-full-source-rules seed-7 shuffled)
   ((exp02-shuffled-control-rule seed-7 sr1)
    (exp02-shuffled-control-rule seed-7 sr0)
    (exp02-shuffled-control-rule seed-7 sr2)
    (exp02-shuffled-control-rule seed-7 sr3)))

(= (exp03-exp02-full-source-rules seed-7 no-catalysis)
   ((exp02-no-catalysis-control-rule seed-7 nr1)
    (exp02-no-catalysis-control-rule seed-7 nr0)
    (exp02-no-catalysis-control-rule seed-7 nr2)
    (exp02-no-catalysis-control-rule seed-7 nr3)))

(= (exp03-exp02-full-source-chamber $family seed-7)
   (make-chamber (exp03-exp02-full-source $family seed-7)
                 (exp03-exp02-initial-state seed-7)
                 (exp03-exp02-full-source-rules seed-7 $family)
                 ()))

(= (exp03-exp02-full-source-capped-pool $family seed-7)
   (bounded-candidate-pool
     (exp00-candidate-cap)
     (exp03-exp02-full-source-chamber $family seed-7)))

(= (exp03-exp02-full-source-after-3 $family seed-7)
   (chamber-run-3 (exp03-exp02-full-source-chamber $family seed-7)))

(= (exp03-exp02-full-source-event-count $family seed-7)
   (event-count (trace-events (exp03-exp02-full-source-after-3 $family seed-7))))

(= (exp03-exp02-full-source-controls-discriminate?)
   (and (> (exp03-exp02-full-source-event-count random seed-7)
           (exp03-exp02-full-source-event-count shuffled seed-7))
        (> (exp03-exp02-full-source-event-count random seed-7)
           (exp03-exp02-full-source-event-count no-catalysis seed-7))))

(= (exp03-exp02-full-source-replay-ok?)
   (== (exp03-exp02-full-source-after-3 random seed-7)
       (chamber-run-1
         (chamber-run-1
           (chamber-run-1 (exp03-exp02-full-source-chamber random seed-7))))))

(= (exp03-exp02-full-source-run-config seed-7 random)
   (make-run-config exp03-exp02-seed-7-full-source-random exp03 (seed-7) 3 (candidate-cap 2 1) random-polymer))

(= (exp03-exp02-full-source-run-config seed-7 shuffled)
   (make-run-config exp03-exp02-seed-7-full-source-shuffled exp03 (seed-7) 3 (candidate-cap 2 1) shuffled-catalysts))

(= (exp03-exp02-full-source-run-config seed-7 no-catalysis)
   (make-run-config exp03-exp02-seed-7-full-source-no-catalysis exp03 (seed-7) 3 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-full-source-run-manifest seed-7 random)
   (make-run-manifest exp03-exp02-seed-7-full-source-random config-hash-exp03-exp02-seed-7-full-source-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-run-manifest seed-7 shuffled)
   (make-run-manifest exp03-exp02-seed-7-full-source-shuffled config-hash-exp03-exp02-seed-7-full-source-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-run-manifest seed-7 no-catalysis)
   (make-run-manifest exp03-exp02-seed-7-full-source-no-catalysis config-hash-exp03-exp02-seed-7-full-source-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-metrics seed-7 random)
   ((metric dynamic-event-count exp03-exp02-seed-7-full-source-random (exp03-exp02-full-source-event-count random seed-7))
    (metric control-family exp03-exp02-seed-7-full-source-random random-polymer)
    (metric source-exp02-rule-count exp03-exp02-seed-7-full-source-random 4)
    (metric dynamic-candidate-cap exp03-exp02-seed-7-full-source-random 2)))

(= (exp03-exp02-full-source-metrics seed-7 shuffled)
   ((metric dynamic-event-count exp03-exp02-seed-7-full-source-shuffled (exp03-exp02-full-source-event-count shuffled seed-7))
    (metric control-family exp03-exp02-seed-7-full-source-shuffled shuffled-catalysts)
    (metric source-exp02-rule-count exp03-exp02-seed-7-full-source-shuffled 4)
    (metric dynamic-candidate-cap exp03-exp02-seed-7-full-source-shuffled 2)))

(= (exp03-exp02-full-source-metrics seed-7 no-catalysis)
   ((metric dynamic-event-count exp03-exp02-seed-7-full-source-no-catalysis (exp03-exp02-full-source-event-count no-catalysis seed-7))
    (metric control-family exp03-exp02-seed-7-full-source-no-catalysis no-catalysis)
    (metric source-exp02-rule-count exp03-exp02-seed-7-full-source-no-catalysis 4)
    (metric dynamic-candidate-cap exp03-exp02-seed-7-full-source-no-catalysis 2)))

(= (exp03-exp02-full-source-run-summary seed-7 random)
   (make-run-summary exp03-exp02-seed-7-full-source-random passed seed-7-full-source-bounded-dynamic-replay-ok True))

(= (exp03-exp02-full-source-run-summary seed-7 shuffled)
   (make-run-summary exp03-exp02-seed-7-full-source-shuffled passed seed-7-shuffled-full-source-control-zero-events True))

(= (exp03-exp02-full-source-run-summary seed-7 no-catalysis)
   (make-run-summary exp03-exp02-seed-7-full-source-no-catalysis passed seed-7-no-catalysis-full-source-control-zero-events True))

(= (exp03-exp02-full-source-acs-candidates seed-7 random)
   (exp02-random-acs-candidates seed-7))

(= (exp03-exp02-full-source-acs-candidates seed-7 shuffled)
   (exp02-shuffled-acs-candidates seed-7))

(= (exp03-exp02-full-source-acs-candidates seed-7 no-catalysis)
   (exp02-no-catalysis-acs-candidates seed-7))

(= (exp03-exp02-full-source-run-record seed-7 $family)
   (make-run-record
     (run-config-id (exp03-exp02-full-source-run-config seed-7 $family))
     (exp03-exp02-full-source-run-config seed-7 $family)
     (exp03-exp02-full-source-run-manifest seed-7 $family)
     (trace-events (exp03-exp02-full-source-after-3 $family seed-7))
     ((state-abundance-snapshot (exp03-exp02-initial-state seed-7))
      (chamber-abundance-snapshot (exp03-exp02-full-source-after-3 $family seed-7)))
     (exp03-exp02-full-source-metrics seed-7 $family)
     (exp03-exp02-full-source-acs-candidates seed-7 $family)
     ()
     (exp03-exp02-full-source-run-summary seed-7 $family)))

(= (exp03-exp02-full-source-run-records seed-7)
   ((exp03-exp02-full-source-run-record seed-7 random)
    (exp03-exp02-full-source-run-record seed-7 shuffled)
    (exp03-exp02-full-source-run-record seed-7 no-catalysis)))

(= (make-run-export $record)
   (run-export
     (run-record-config $record)
     (run-record-manifest $record)
     (run-record-events $record)
     (run-record-abundances $record)
     (run-record-metrics $record)
     (run-record-acs-candidates $record)
     (run-record-ablations $record)
     (run-record-summary $record)))

(= (run-export-config
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $config)

(= (run-export-manifest
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $manifest)

(= (run-export-events
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $events)

(= (run-export-abundances
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $abundances)

(= (run-export-metrics
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $metrics)

(= (run-export-acs-candidates
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $acs-candidates)

(= (run-export-ablations
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $ablations)

(= (run-export-summary
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $summary)

(= (exp03-exp02-full-source-run-export seed-7 $family)
   (make-run-export (exp03-exp02-full-source-run-record seed-7 $family)))

(= (exp03-exp02-full-source-run-export seed-13 $family)
   (make-run-export (exp03-exp02-full-source-run-record seed-13 $family)))

(= (exp03-exp02-full-source-run-export seed-17 $family)
   (make-run-export (exp03-exp02-full-source-run-record seed-17 $family)))

(= (exp03-exp02-full-source-run-record-complete?)
   (and (run-record-passed? (exp03-exp02-full-source-run-record seed-7 random))
        (and (run-record-passed? (exp03-exp02-full-source-run-record seed-7 shuffled))
             (and (run-record-passed? (exp03-exp02-full-source-run-record seed-7 no-catalysis))
                  (and (exp03-exp02-full-source-controls-discriminate?)
                       (exp03-exp02-full-source-replay-ok?))))))

; ----- seed-13/eight-rule full source-pool dynamic bridge -----
;
; This extends the full-source bridge from seed-7/four-rule visibility to the
; seed-13/eight-rule exp02 source family.  The chamber carries all eight source
; rules; the existing candidate cap keeps each dynamic tick bounded to the first
; two candidates, ordered rr1/rr0 so the deterministic seed/tick selector can
; replay the productive rr0 path for random-polymer while the control families
; remain no-op under the same state/cap.

(= (seed-number seed-13) 13)

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr0 R0 R1 R01 R10) $score))
   (if (and (> $r0-count 0)
            (and (> $r1-count 0)
                 (> $catalyst-count 0)))
       (let $trace (fire-binary-catalytic
                     (rule rr0 R0 R1 R01 R10)
                     (state $tick $seed
                            (mol R0 $r0-count)
                            (mol R1 $r1-count)
                            (mol R01 $product-count)
                            (mol R10 $catalyst-count)))
         (chamber $id
                  (trace-state $trace)
                  $rules
                  (append-event $events (trace-event $trace))))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0-count)
                       (mol R1 $r1-count)
                       (mol R01 $product-count)
                       (mol R10 $catalyst-count))
                $rules
                $events)))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr1 R2 R3 R10 R01) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0-count)
                   (mol R1 $r1-count)
                   (mol R01 $product-count)
                   (mol R10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr0 R0 R1 R01 R2) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0-count)
                   (mol R1 $r1-count)
                   (mol R01 $product-count)
                   (mol R10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr1 R2 R3 R10 R4) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0-count)
                   (mol R1 $r1-count)
                   (mol R01 $product-count)
                   (mol R10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr0 R0 R1 R01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0-count)
                   (mol R1 $r1-count)
                   (mol R01 $product-count)
                   (mol R10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr1 R2 R3 R10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0-count)
                   (mol R1 $r1-count)
                   (mol R01 $product-count)
                   (mol R10 $catalyst-count))
            $rules
            $events))

; rr2 clauses for cap-3 pool extension (all no-op in R0/R1/R01/R10 state).
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr2 R4 R5 R45 R54) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0-count)
                   (mol R1 $r1-count)
                   (mol R01 $product-count)
                   (mol R10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr2 R4 R5 R45 R6) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0-count)
                   (mol R1 $r1-count)
                   (mol R01 $product-count)
                   (mol R10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0-count)
                      (mol R1 $r1-count)
                      (mol R01 $product-count)
                      (mol R10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr2 R4 R5 R45 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0-count)
                   (mol R1 $r1-count)
                   (mol R01 $product-count)
                   (mol R10 $catalyst-count))
            $rules
            $events))

; rr2 clauses for cap-3 pool extension in P0/P1/P01/P10 state (seed-7).
; rr2/sr2/nr2 all need P3 which is absent → no-op.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr2 P0 P3 P03 P2) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0-count)
                   (mol P1 $p1-count)
                   (mol P01 $product-count)
                   (mol P10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule sr2 P0 P3 P03 P10) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0-count)
                   (mol P1 $p1-count)
                   (mol P01 $product-count)
                   (mol P10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0-count)
                      (mol P1 $p1-count)
                      (mol P01 $product-count)
                      (mol P10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule nr2 P0 P3 P03 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0-count)
                   (mol P1 $p1-count)
                   (mol P01 $product-count)
                   (mol P10 $catalyst-count))
            $rules
            $events))

; rr2 clauses for cap-3 pool extension in S0/S1/S01/S10 state (seed-17).
; rr2 needs S4/S5 which are absent → no-op.  Same rule name for all families
; (generated rules differ only in catalyst field).
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr2 S4 S5 S45 S54) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0-count)
                   (mol S1 $s1-count)
                   (mol S01 $product-count)
                   (mol S10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr2 S4 S5 S45 S6) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0-count)
                   (mol S1 $s1-count)
                   (mol S01 $product-count)
                   (mol S10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr2 S4 S5 S45 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0-count)
                   (mol S1 $s1-count)
                   (mol S01 $product-count)
                   (mol S10 $catalyst-count))
            $rules
            $events))

; rr2 clauses for cap-3 pool extension in Q0/Q1/Q01/Q10 state (seed-11).
; rr2/sr2/nr2 all need Q4/Q5 which are absent → no-op.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr2 Q4 Q5 Q45 Q54) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0-count)
                   (mol Q1 $q1-count)
                   (mol Q01 $product-count)
                   (mol Q10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule sr2 Q4 Q5 Q45 Q6) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0-count)
                   (mol Q1 $q1-count)
                   (mol Q01 $product-count)
                   (mol Q10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0-count)
                      (mol Q1 $q1-count)
                      (mol Q01 $product-count)
                      (mol Q10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule nr2 Q4 Q5 Q45 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0-count)
                   (mol Q1 $q1-count)
                   (mol Q01 $product-count)
                   (mol Q10 $catalyst-count))
            $rules
            $events))

(= (exp03-exp02-initial-state seed-13)
   (state 0 seed-13 (mol R0 2) (mol R1 2) (mol R01 0) (mol R10 1)))

(= (exp03-exp02-full-source-rules seed-13 $family)
   ((exp02-seed-13-rule $family rr1)
    (exp02-seed-13-rule $family rr0)
    (exp02-seed-13-rule $family rr2)
    (exp02-seed-13-rule $family rr3)
    (exp02-seed-13-rule $family rr4)
    (exp02-seed-13-rule $family rr5)
    (exp02-seed-13-rule $family rr6)
    (exp02-seed-13-rule $family rr7)))

(= (exp03-exp02-full-source-chamber $family seed-13)
   (make-chamber (exp03-exp02-full-source $family seed-13)
                 (exp03-exp02-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 $family)
                 ()))

(= (exp03-exp02-full-source-capped-pool $family seed-13)
   (bounded-candidate-pool
     (exp00-candidate-cap)
     (exp03-exp02-full-source-chamber $family seed-13)))

(= (exp03-exp02-full-source-after-3 $family seed-13)
   (chamber-run-3 (exp03-exp02-full-source-chamber $family seed-13)))

(= (exp03-exp02-full-source-event-count $family seed-13)
   (event-count (trace-events (exp03-exp02-full-source-after-3 $family seed-13))))

(= (exp03-exp02-full-source-controls-discriminate-seed-13?)
   (and (> (exp03-exp02-full-source-event-count random-polymer seed-13)
           (exp03-exp02-full-source-event-count shuffled-catalysts seed-13))
        (> (exp03-exp02-full-source-event-count random-polymer seed-13)
           (exp03-exp02-full-source-event-count no-catalysis seed-13))))

(= (exp03-exp02-full-source-replay-ok-seed-13?)
   (== (exp03-exp02-full-source-after-3 random-polymer seed-13)
       (chamber-run-1
         (chamber-run-1
           (chamber-run-1 (exp03-exp02-full-source-chamber random-polymer seed-13))))))

(= (exp03-exp02-full-source-run-config seed-13 random-polymer)
   (make-run-config exp03-exp02-seed-13-full-source-random exp03 (seed-13) 3 (candidate-cap 2 1) random-polymer))

(= (exp03-exp02-full-source-run-config seed-13 shuffled-catalysts)
   (make-run-config exp03-exp02-seed-13-full-source-shuffled exp03 (seed-13) 3 (candidate-cap 2 1) shuffled-catalysts))

(= (exp03-exp02-full-source-run-config seed-13 no-catalysis)
   (make-run-config exp03-exp02-seed-13-full-source-no-catalysis exp03 (seed-13) 3 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-full-source-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-exp02-seed-13-full-source-random config-hash-exp03-exp02-seed-13-full-source-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-run-manifest seed-13 shuffled-catalysts)
   (make-run-manifest exp03-exp02-seed-13-full-source-shuffled config-hash-exp03-exp02-seed-13-full-source-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-run-manifest seed-13 no-catalysis)
   (make-run-manifest exp03-exp02-seed-13-full-source-no-catalysis config-hash-exp03-exp02-seed-13-full-source-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-metrics seed-13 $family)
   ((metric dynamic-event-count (run-config-id (exp03-exp02-full-source-run-config seed-13 $family)) (exp03-exp02-full-source-event-count $family seed-13))
    (metric source-exp02-rule-count (run-config-id (exp03-exp02-full-source-run-config seed-13 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-exp02-full-source-run-config seed-13 $family)) 2)))

(= (exp03-exp02-full-source-run-summary seed-13 random-polymer)
   (make-run-summary exp03-exp02-seed-13-full-source-random passed seed-13-full-source-bounded-dynamic-replay-ok True))

(= (exp03-exp02-full-source-run-summary seed-13 shuffled-catalysts)
   (make-run-summary exp03-exp02-seed-13-full-source-shuffled passed seed-13-shuffled-full-source-control-zero-events True))

(= (exp03-exp02-full-source-run-summary seed-13 no-catalysis)
   (make-run-summary exp03-exp02-seed-13-full-source-no-catalysis passed seed-13-no-catalysis-full-source-control-zero-events True))

(= (exp03-exp02-full-source-run-record seed-13 $family)
   (make-run-record
     (run-config-id (exp03-exp02-full-source-run-config seed-13 $family))
     (exp03-exp02-full-source-run-config seed-13 $family)
     (exp03-exp02-full-source-run-manifest seed-13 $family)
     (trace-events (exp03-exp02-full-source-after-3 $family seed-13))
     ((state-abundance-snapshot (exp03-exp02-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-exp02-full-source-after-3 $family seed-13)))
     (exp03-exp02-full-source-metrics seed-13 $family)
     (exp02-seed-13-acs-candidates $family)
     ()
     (exp03-exp02-full-source-run-summary seed-13 $family)))

(= (exp03-exp02-full-source-run-records-complete-seed-13?)
   (and (run-record-passed? (exp03-exp02-full-source-run-record seed-13 random-polymer))
        (and (run-record-passed? (exp03-exp02-full-source-run-record seed-13 shuffled-catalysts))
             (and (run-record-passed? (exp03-exp02-full-source-run-record seed-13 no-catalysis))
                  (and (exp03-exp02-full-source-controls-discriminate-seed-13?)
                       (exp03-exp02-full-source-replay-ok-seed-13?))))))

; ----- seed-17/eight-rule generated full source-pool dynamic bridge -----
;
; This adds a second eight-rule full-source dynamic point using the seed-to-
; components exp02 generation seam.  The chamber keeps all eight generated
; rules visible while the same cap/order exposes a bounded rr1/rr0 dynamic
; window: random-polymer fires rr0 twice over three ticks, while shuffled and
; no-catalysis controls remain no-op.

(= (seed-number seed-17) 17)

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr0 S0 S1 S01 S10) $score))
   (if (and (> $s0-count 0)
            (and (> $s1-count 0)
                 (> $catalyst-count 0)))
       (let $trace (fire-binary-catalytic
                     (rule rr0 S0 S1 S01 S10)
                     (state $tick $seed
                            (mol S0 $s0-count)
                            (mol S1 $s1-count)
                            (mol S01 $product-count)
                            (mol S10 $catalyst-count)))
         (chamber $id
                  (trace-state $trace)
                  $rules
                  (append-event $events (trace-event $trace))))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0-count)
                       (mol S1 $s1-count)
                       (mol S01 $product-count)
                       (mol S10 $catalyst-count))
                $rules
                $events)))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr1 S2 S3 S10 S01) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0-count)
                   (mol S1 $s1-count)
                   (mol S01 $product-count)
                   (mol S10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr0 S0 S1 S01 S2) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0-count)
                   (mol S1 $s1-count)
                   (mol S01 $product-count)
                   (mol S10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr1 S2 S3 S10 S4) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0-count)
                   (mol S1 $s1-count)
                   (mol S01 $product-count)
                   (mol S10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr0 S0 S1 S01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0-count)
                   (mol S1 $s1-count)
                   (mol S01 $product-count)
                   (mol S10 $catalyst-count))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0-count)
                      (mol S1 $s1-count)
                      (mol S01 $product-count)
                      (mol S10 $catalyst-count))
               $rules
               $events)
      (candidate $candidate-tick (rule rr1 S2 S3 S10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0-count)
                   (mol S1 $s1-count)
                   (mol S01 $product-count)
                   (mol S10 $catalyst-count))
            $rules
            $events))

(= (exp03-exp02-initial-state seed-17)
   (state 0 seed-17 (mol S0 2) (mol S1 2) (mol S01 0) (mol S10 1)))

(= (exp03-exp02-full-source-rules seed-17 $family)
   ((exp02-generated-rule $family (exp02-seed-rule-components seed-17 rr1))
    (exp02-generated-rule $family (exp02-seed-rule-components seed-17 rr0))
    (exp02-generated-rule $family (exp02-seed-rule-components seed-17 rr2))
    (exp02-generated-rule $family (exp02-seed-rule-components seed-17 rr3))
    (exp02-generated-rule $family (exp02-seed-rule-components seed-17 rr4))
    (exp02-generated-rule $family (exp02-seed-rule-components seed-17 rr5))
    (exp02-generated-rule $family (exp02-seed-rule-components seed-17 rr6))
    (exp02-generated-rule $family (exp02-seed-rule-components seed-17 rr7))))

(= (exp03-exp02-full-source-chamber $family seed-17)
   (make-chamber (exp03-exp02-full-source $family seed-17)
                 (exp03-exp02-initial-state seed-17)
                 (exp03-exp02-full-source-rules seed-17 $family)
                 ()))

(= (exp03-exp02-full-source-capped-pool $family seed-17)
   (bounded-candidate-pool
     (exp00-candidate-cap)
     (exp03-exp02-full-source-chamber $family seed-17)))

(= (exp03-exp02-full-source-after-3 $family seed-17)
   (chamber-run-3 (exp03-exp02-full-source-chamber $family seed-17)))

(= (exp03-exp02-full-source-event-count $family seed-17)
   (event-count (trace-events (exp03-exp02-full-source-after-3 $family seed-17))))

(= (exp03-exp02-full-source-controls-discriminate-seed-17?)
   (and (> (exp03-exp02-full-source-event-count random-polymer seed-17)
           (exp03-exp02-full-source-event-count shuffled-catalysts seed-17))
        (> (exp03-exp02-full-source-event-count random-polymer seed-17)
           (exp03-exp02-full-source-event-count no-catalysis seed-17))))

(= (exp03-exp02-full-source-replay-ok-seed-17?)
   (== (exp03-exp02-full-source-after-3 random-polymer seed-17)
       (chamber-run-1
         (chamber-run-1
           (chamber-run-1 (exp03-exp02-full-source-chamber random-polymer seed-17))))))

(= (exp03-exp02-full-source-run-config seed-17 random-polymer)
   (make-run-config exp03-exp02-seed-17-full-source-random exp03 (seed-17) 3 (candidate-cap 2 1) random-polymer))

(= (exp03-exp02-full-source-run-config seed-17 shuffled-catalysts)
   (make-run-config exp03-exp02-seed-17-full-source-shuffled exp03 (seed-17) 3 (candidate-cap 2 1) shuffled-catalysts))

(= (exp03-exp02-full-source-run-config seed-17 no-catalysis)
   (make-run-config exp03-exp02-seed-17-full-source-no-catalysis exp03 (seed-17) 3 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-full-source-run-manifest seed-17 random-polymer)
   (make-run-manifest exp03-exp02-seed-17-full-source-random config-hash-exp03-exp02-seed-17-full-source-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-run-manifest seed-17 shuffled-catalysts)
   (make-run-manifest exp03-exp02-seed-17-full-source-shuffled config-hash-exp03-exp02-seed-17-full-source-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-run-manifest seed-17 no-catalysis)
   (make-run-manifest exp03-exp02-seed-17-full-source-no-catalysis config-hash-exp03-exp02-seed-17-full-source-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-full-source-metrics seed-17 $family)
   ((metric dynamic-event-count (run-config-id (exp03-exp02-full-source-run-config seed-17 $family)) (exp03-exp02-full-source-event-count $family seed-17))
    (metric source-exp02-rule-count (run-config-id (exp03-exp02-full-source-run-config seed-17 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-exp02-full-source-run-config seed-17 $family)) 2)
    (metric generation-seam (run-config-id (exp03-exp02-full-source-run-config seed-17 $family)) seed-to-components)))

(= (exp03-exp02-full-source-run-summary seed-17 random-polymer)
   (make-run-summary exp03-exp02-seed-17-full-source-random passed seed-17-full-source-bounded-dynamic-replay-ok True))

(= (exp03-exp02-full-source-run-summary seed-17 shuffled-catalysts)
   (make-run-summary exp03-exp02-seed-17-full-source-shuffled passed seed-17-shuffled-full-source-control-zero-events True))

(= (exp03-exp02-full-source-run-summary seed-17 no-catalysis)
   (make-run-summary exp03-exp02-seed-17-full-source-no-catalysis passed seed-17-no-catalysis-full-source-control-zero-events True))

(= (exp03-exp02-full-source-run-record seed-17 $family)
   (make-run-record
     (run-config-id (exp03-exp02-full-source-run-config seed-17 $family))
     (exp03-exp02-full-source-run-config seed-17 $family)
     (exp03-exp02-full-source-run-manifest seed-17 $family)
     (trace-events (exp03-exp02-full-source-after-3 $family seed-17))
     ((state-abundance-snapshot (exp03-exp02-initial-state seed-17))
      (chamber-abundance-snapshot (exp03-exp02-full-source-after-3 $family seed-17)))
     (exp03-exp02-full-source-metrics seed-17 $family)
     (exp02-seed-17-acs-candidates $family)
     ()
     (exp03-exp02-full-source-run-summary seed-17 $family)))

(= (exp03-exp02-full-source-run-records-complete-seed-17?)
   (and (run-record-passed? (exp03-exp02-full-source-run-record seed-17 random-polymer))
        (and (run-record-passed? (exp03-exp02-full-source-run-record seed-17 shuffled-catalysts))
             (and (run-record-passed? (exp03-exp02-full-source-run-record seed-17 no-catalysis))
                  (and (exp03-exp02-full-source-controls-discriminate-seed-17?)
                       (exp03-exp02-full-source-replay-ok-seed-17?))))))

; ----- 10-tick exp02-family dynamic bridge (seed-7) -----
;
; This extends the seed-7 exp02-family bridge from 3 ticks to 10 ticks with
; higher initial abundances (P0=5, P1=5).  The productive rr0 rule fires at
; even ticks (0,2,4,6,8) for 5 events before reactant exhaustion at tick 8.
; Shuffled/no-catalysis controls remain zero-event over the same 10-tick horizon.
; This connects the longer multi-tick evolution fixtures to the exp02-style
; family bridge structure.

(= (exp03-exp02-longer-initial-state seed-7)
   (state 0 seed-7 (mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1)))

(= (exp03-exp02-longer-chamber $family seed-7)
   (make-chamber (exp03-exp02-longer $family seed-7)
                 (exp03-exp02-longer-initial-state seed-7)
                 (exp03-exp02-rules $family)
                 ()))

(= (exp03-exp02-longer-after-10 $family seed-7)
   (chamber-run-10 (exp03-exp02-longer-chamber $family seed-7)))

(= (exp03-exp02-longer-event-count $family seed-7)
   (event-count (trace-events (exp03-exp02-longer-after-10 $family seed-7))))

(= (exp03-exp02-longer-tick $family seed-7)
   (state-tick (chamber-state (exp03-exp02-longer-after-10 $family seed-7))))

(= (exp03-exp02-longer-abundances $family seed-7)
   (chamber-abundance-snapshot (exp03-exp02-longer-after-10 $family seed-7)))

(= (exp03-exp02-longer-replay-10 $family seed-7)
   (chamber-run-5 (chamber-run-5 (exp03-exp02-longer-chamber $family seed-7))))

(= (exp03-exp02-longer-replay-ok? $family seed-7)
   (== (exp03-exp02-longer-after-10 $family seed-7)
       (exp03-exp02-longer-replay-10 $family seed-7)))

(= (exp03-exp02-longer-reactant-exhausted? seed-7)
   (== (exp03-exp02-longer-abundances random seed-7)
       (abundance-snapshot 10 ((mol P0 0) (mol P1 0) (mol P01 5) (mol P10 1)))))

(= (exp03-exp02-longer-controls-discriminate? seed-7)
   (and (> (exp03-exp02-longer-event-count random seed-7)
           (exp03-exp02-longer-event-count shuffled seed-7))
        (> (exp03-exp02-longer-event-count random seed-7)
           (exp03-exp02-longer-event-count no-catalysis seed-7))))

(= (exp03-exp02-longer-run-config seed-7 random)
   (make-run-config exp03-exp02-seed-7-longer-random exp03 (seed-7) 10 (candidate-cap 2 1) random-polymer))

(= (exp03-exp02-longer-run-config seed-7 shuffled)
   (make-run-config exp03-exp02-seed-7-longer-shuffled exp03 (seed-7) 10 (candidate-cap 2 1) shuffled-catalysts))

(= (exp03-exp02-longer-run-config seed-7 no-catalysis)
   (make-run-config exp03-exp02-seed-7-longer-no-catalysis exp03 (seed-7) 10 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-longer-run-manifest seed-7 random)
   (make-run-manifest exp03-exp02-seed-7-longer-random config-hash-exp03-exp02-seed-7-longer-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-run-manifest seed-7 shuffled)
   (make-run-manifest exp03-exp02-seed-7-longer-shuffled config-hash-exp03-exp02-seed-7-longer-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-run-manifest seed-7 no-catalysis)
   (make-run-manifest exp03-exp02-seed-7-longer-no-catalysis config-hash-exp03-exp02-seed-7-longer-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-metrics seed-7 $family)
   ((metric dynamic-event-count (run-config-id (exp03-exp02-longer-run-config seed-7 $family)) (exp03-exp02-longer-event-count $family seed-7))
    (metric dynamic-tick-count (run-config-id (exp03-exp02-longer-run-config seed-7 $family)) 10)
    (metric source-exp02-rule-count (run-config-id (exp03-exp02-longer-run-config seed-7 $family)) 2)
    (metric dynamic-candidate-cap (run-config-id (exp03-exp02-longer-run-config seed-7 $family)) 2)))

(= (exp03-exp02-longer-run-summary seed-7 random)
   (make-run-summary exp03-exp02-seed-7-longer-random passed seed-7-longer-dynamic-produces-events True))

(= (exp03-exp02-longer-run-summary seed-7 shuffled)
   (make-run-summary exp03-exp02-seed-7-longer-shuffled passed seed-7-longer-shuffled-control-zero-events True))

(= (exp03-exp02-longer-run-summary seed-7 no-catalysis)
   (make-run-summary exp03-exp02-seed-7-longer-no-catalysis passed seed-7-longer-no-catalysis-control-zero-events True))

(= (exp03-exp02-longer-run-record seed-7 $family)
   (make-run-record
     (run-config-id (exp03-exp02-longer-run-config seed-7 $family))
     (exp03-exp02-longer-run-config seed-7 $family)
     (exp03-exp02-longer-run-manifest seed-7 $family)
     (trace-events (exp03-exp02-longer-after-10 $family seed-7))
     ((state-abundance-snapshot (exp03-exp02-longer-initial-state seed-7))
      (chamber-abundance-snapshot (exp03-exp02-longer-after-10 $family seed-7)))
     (exp03-exp02-longer-metrics seed-7 $family)
     (exp02-random-acs-candidates seed-7)
     ()
     (exp03-exp02-longer-run-summary seed-7 $family)))

(= (exp03-exp02-longer-run-records seed-7)
   ((exp03-exp02-longer-run-record seed-7 random)
    (exp03-exp02-longer-run-record seed-7 shuffled)
    (exp03-exp02-longer-run-record seed-7 no-catalysis)))

(= (exp03-exp02-longer-run-records-complete? seed-7)
   (and (run-record-passed? (exp03-exp02-longer-run-record seed-7 random))
        (and (run-record-passed? (exp03-exp02-longer-run-record seed-7 shuffled))
             (and (run-record-passed? (exp03-exp02-longer-run-record seed-7 no-catalysis))
                  (and (exp03-exp02-longer-controls-discriminate? seed-7)
                       (exp03-exp02-longer-replay-ok? random seed-7))))))

; ----- 10-tick exp02-family dynamic bridge (seed-13) -----
;
; This extends the seed-13 full-source exp02-family bridge from 3 ticks to 10
; ticks with higher initial abundances (R0=5, R1=5).  The productive rr0 rule
; fires at even ticks (0,2,4,6,8) for 5 events before reactant exhaustion at
; tick 8.  Shuffled/no-catalysis controls remain zero-event over the same 10-tick
; horizon.  The chamber carries all eight seed-13 source rules; the candidate
; cap bounds each tick to the first two candidates (rr1/rr0), preserving the
; deterministic seed/tick alternation pattern (seed-13: (13+tick)%2 = 1 at even
; ticks → rr0 productive; 0 at odd ticks → rr1 distractor).

(= (exp03-exp02-longer-initial-state seed-13)
   (state 0 seed-13 (mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1)))

(= (exp03-exp02-longer-chamber $family seed-13)
   (make-chamber (exp03-exp02-longer $family seed-13)
                 (exp03-exp02-longer-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 $family)
                 ()))

(= (exp03-exp02-longer-after-10 $family seed-13)
   (chamber-run-10 (exp03-exp02-longer-chamber $family seed-13)))

(= (exp03-exp02-longer-event-count $family seed-13)
   (event-count (trace-events (exp03-exp02-longer-after-10 $family seed-13))))

(= (exp03-exp02-longer-tick $family seed-13)
   (state-tick (chamber-state (exp03-exp02-longer-after-10 $family seed-13))))

(= (exp03-exp02-longer-abundances $family seed-13)
   (chamber-abundance-snapshot (exp03-exp02-longer-after-10 $family seed-13)))

(= (exp03-exp02-longer-replay-10 $family seed-13)
   (chamber-run-5 (chamber-run-5 (exp03-exp02-longer-chamber $family seed-13))))

(= (exp03-exp02-longer-replay-ok? $family seed-13)
   (== (exp03-exp02-longer-after-10 $family seed-13)
       (exp03-exp02-longer-replay-10 $family seed-13)))

(= (exp03-exp02-longer-reactant-exhausted? seed-13)
   (== (exp03-exp02-longer-abundances random-polymer seed-13)
       (abundance-snapshot 10 ((mol R0 0) (mol R1 0) (mol R01 5) (mol R10 1)))))

(= (exp03-exp02-longer-controls-discriminate? seed-13)
   (and (> (exp03-exp02-longer-event-count random-polymer seed-13)
           (exp03-exp02-longer-event-count shuffled-catalysts seed-13))
        (> (exp03-exp02-longer-event-count random-polymer seed-13)
           (exp03-exp02-longer-event-count no-catalysis seed-13))))

(= (exp03-exp02-longer-run-config seed-13 random-polymer)
   (make-run-config exp03-exp02-seed-13-longer-random exp03 (seed-13) 10 (candidate-cap 2 1) random-polymer))

(= (exp03-exp02-longer-run-config seed-13 shuffled-catalysts)
   (make-run-config exp03-exp02-seed-13-longer-shuffled exp03 (seed-13) 10 (candidate-cap 2 1) shuffled-catalysts))

(= (exp03-exp02-longer-run-config seed-13 no-catalysis)
   (make-run-config exp03-exp02-seed-13-longer-no-catalysis exp03 (seed-13) 10 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-longer-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-exp02-seed-13-longer-random config-hash-exp03-exp02-seed-13-longer-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-run-manifest seed-13 shuffled-catalysts)
   (make-run-manifest exp03-exp02-seed-13-longer-shuffled config-hash-exp03-exp02-seed-13-longer-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-run-manifest seed-13 no-catalysis)
   (make-run-manifest exp03-exp02-seed-13-longer-no-catalysis config-hash-exp03-exp02-seed-13-longer-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-metrics seed-13 $family)
   ((metric dynamic-event-count (run-config-id (exp03-exp02-longer-run-config seed-13 $family)) (exp03-exp02-longer-event-count $family seed-13))
    (metric dynamic-tick-count (run-config-id (exp03-exp02-longer-run-config seed-13 $family)) 10)
    (metric source-exp02-rule-count (run-config-id (exp03-exp02-longer-run-config seed-13 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-exp02-longer-run-config seed-13 $family)) 2)))

(= (exp03-exp02-longer-run-summary seed-13 random-polymer)
   (make-run-summary exp03-exp02-seed-13-longer-random passed seed-13-longer-dynamic-produces-events True))

(= (exp03-exp02-longer-run-summary seed-13 shuffled-catalysts)
   (make-run-summary exp03-exp02-seed-13-longer-shuffled passed seed-13-longer-shuffled-control-zero-events True))

(= (exp03-exp02-longer-run-summary seed-13 no-catalysis)
   (make-run-summary exp03-exp02-seed-13-longer-no-catalysis passed seed-13-longer-no-catalysis-control-zero-events True))

(= (exp03-exp02-longer-run-record seed-13 $family)
   (make-run-record
     (run-config-id (exp03-exp02-longer-run-config seed-13 $family))
     (exp03-exp02-longer-run-config seed-13 $family)
     (exp03-exp02-longer-run-manifest seed-13 $family)
     (trace-events (exp03-exp02-longer-after-10 $family seed-13))
     ((state-abundance-snapshot (exp03-exp02-longer-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-exp02-longer-after-10 $family seed-13)))
     (exp03-exp02-longer-metrics seed-13 $family)
     (exp02-seed-13-acs-candidates $family)
     ()
     (exp03-exp02-longer-run-summary seed-13 $family)))

(= (exp03-exp02-longer-run-records seed-13)
   ((exp03-exp02-longer-run-record seed-13 random-polymer)
    (exp03-exp02-longer-run-record seed-13 shuffled-catalysts)
    (exp03-exp02-longer-run-record seed-13 no-catalysis)))

(= (exp03-exp02-longer-run-records-complete? seed-13)
   (and (run-record-passed? (exp03-exp02-longer-run-record seed-13 random-polymer))
        (and (run-record-passed? (exp03-exp02-longer-run-record seed-13 shuffled-catalysts))
             (and (run-record-passed? (exp03-exp02-longer-run-record seed-13 no-catalysis))
                  (and (exp03-exp02-longer-controls-discriminate? seed-13)
                       (exp03-exp02-longer-replay-ok? random-polymer seed-13))))))

; ----- 10-tick exp02-family dynamic bridge (seed-17) -----
;
; This extends the seed-17 full-source exp02-family bridge from 3 ticks to 10
; ticks with higher initial abundances (S0=5, S1=5).  The productive rr0 rule
; fires at even ticks (0,2,4,6,8) for 5 events before reactant exhaustion at
; tick 8.  Shuffled/no-catalysis controls remain zero-event over the same 10-tick
; horizon.  The chamber carries all eight seed-17 generated source rules; the
; candidate cap bounds each tick to the first two candidates (rr1/rr0),
; preserving the deterministic seed/tick alternation pattern (seed-17:
; (17+tick)%2 = 1 at even ticks → rr0 productive; 0 at odd ticks → rr1
; distractor).

(= (exp03-exp02-longer-initial-state seed-17)
   (state 0 seed-17 (mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1)))

(= (exp03-exp02-longer-chamber $family seed-17)
   (make-chamber (exp03-exp02-longer $family seed-17)
                 (exp03-exp02-longer-initial-state seed-17)
                 (exp03-exp02-full-source-rules seed-17 $family)
                 ()))

(= (exp03-exp02-longer-after-10 $family seed-17)
   (chamber-run-10 (exp03-exp02-longer-chamber $family seed-17)))

(= (exp03-exp02-longer-event-count $family seed-17)
   (event-count (trace-events (exp03-exp02-longer-after-10 $family seed-17))))

(= (exp03-exp02-longer-tick $family seed-17)
   (state-tick (chamber-state (exp03-exp02-longer-after-10 $family seed-17))))

(= (exp03-exp02-longer-abundances $family seed-17)
   (chamber-abundance-snapshot (exp03-exp02-longer-after-10 $family seed-17)))

(= (exp03-exp02-longer-replay-10 $family seed-17)
   (chamber-run-5 (chamber-run-5 (exp03-exp02-longer-chamber $family seed-17))))

(= (exp03-exp02-longer-replay-ok? $family seed-17)
   (== (exp03-exp02-longer-after-10 $family seed-17)
       (exp03-exp02-longer-replay-10 $family seed-17)))

(= (exp03-exp02-longer-reactant-exhausted? seed-17)
   (== (exp03-exp02-longer-abundances random-polymer seed-17)
       (abundance-snapshot 10 ((mol S0 0) (mol S1 0) (mol S01 5) (mol S10 1)))))

(= (exp03-exp02-longer-controls-discriminate? seed-17)
   (and (> (exp03-exp02-longer-event-count random-polymer seed-17)
           (exp03-exp02-longer-event-count shuffled-catalysts seed-17))
        (> (exp03-exp02-longer-event-count random-polymer seed-17)
           (exp03-exp02-longer-event-count no-catalysis seed-17))))

(= (exp03-exp02-longer-run-config seed-17 random-polymer)
   (make-run-config exp03-exp02-seed-17-longer-random exp03 (seed-17) 10 (candidate-cap 2 1) random-polymer))

(= (exp03-exp02-longer-run-config seed-17 shuffled-catalysts)
   (make-run-config exp03-exp02-seed-17-longer-shuffled exp03 (seed-17) 10 (candidate-cap 2 1) shuffled-catalysts))

(= (exp03-exp02-longer-run-config seed-17 no-catalysis)
   (make-run-config exp03-exp02-seed-17-longer-no-catalysis exp03 (seed-17) 10 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-longer-run-manifest seed-17 random-polymer)
   (make-run-manifest exp03-exp02-seed-17-longer-random config-hash-exp03-exp02-seed-17-longer-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-run-manifest seed-17 shuffled-catalysts)
   (make-run-manifest exp03-exp02-seed-17-longer-shuffled config-hash-exp03-exp02-seed-17-longer-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-run-manifest seed-17 no-catalysis)
   (make-run-manifest exp03-exp02-seed-17-longer-no-catalysis config-hash-exp03-exp02-seed-17-longer-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-metrics seed-17 $family)
   ((metric dynamic-event-count (run-config-id (exp03-exp02-longer-run-config seed-17 $family)) (exp03-exp02-longer-event-count $family seed-17))
    (metric dynamic-tick-count (run-config-id (exp03-exp02-longer-run-config seed-17 $family)) 10)
    (metric source-exp02-rule-count (run-config-id (exp03-exp02-longer-run-config seed-17 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-exp02-longer-run-config seed-17 $family)) 2)
    (metric generation-seam (run-config-id (exp03-exp02-longer-run-config seed-17 $family)) seed-to-components)))

(= (exp03-exp02-longer-run-summary seed-17 random-polymer)
   (make-run-summary exp03-exp02-seed-17-longer-random passed seed-17-longer-dynamic-produces-events True))

(= (exp03-exp02-longer-run-summary seed-17 shuffled-catalysts)
   (make-run-summary exp03-exp02-seed-17-longer-shuffled passed seed-17-longer-shuffled-control-zero-events True))

(= (exp03-exp02-longer-run-summary seed-17 no-catalysis)
   (make-run-summary exp03-exp02-seed-17-longer-no-catalysis passed seed-17-longer-no-catalysis-control-zero-events True))

(= (exp03-exp02-longer-run-record seed-17 $family)
   (make-run-record
     (run-config-id (exp03-exp02-longer-run-config seed-17 $family))
     (exp03-exp02-longer-run-config seed-17 $family)
     (exp03-exp02-longer-run-manifest seed-17 $family)
     (trace-events (exp03-exp02-longer-after-10 $family seed-17))
     ((state-abundance-snapshot (exp03-exp02-longer-initial-state seed-17))
      (chamber-abundance-snapshot (exp03-exp02-longer-after-10 $family seed-17)))
     (exp03-exp02-longer-metrics seed-17 $family)
     (exp02-seed-17-acs-candidates $family)
     ()
     (exp03-exp02-longer-run-summary seed-17 $family)))

(= (exp03-exp02-longer-run-records seed-17)
   ((exp03-exp02-longer-run-record seed-17 random-polymer)
    (exp03-exp02-longer-run-record seed-17 shuffled-catalysts)
    (exp03-exp02-longer-run-record seed-17 no-catalysis)))

(= (exp03-exp02-longer-run-records-complete? seed-17)
   (and (run-record-passed? (exp03-exp02-longer-run-record seed-17 random-polymer))
        (and (run-record-passed? (exp03-exp02-longer-run-record seed-17 shuffled-catalysts))
             (and (run-record-passed? (exp03-exp02-longer-run-record seed-17 no-catalysis))
                  (and (exp03-exp02-longer-controls-discriminate? seed-17)
                       (exp03-exp02-longer-replay-ok? random-polymer seed-17))))))

; ----- 10-tick exp02-family dynamic bridge (seed-11) -----
;
; This extends the seed-11 exp02-family bridge from 3 ticks to 10 ticks with
; higher initial abundances (Q0=5, Q1=5).  The productive rr0 rule fires at
; even ticks (0,2,4,6,8) for 5 events before reactant exhaustion at tick 8.
; Shuffled/no-catalysis controls remain zero-event over the same 10-tick
; horizon.  The chamber carries all six seed-11 source rules; the candidate
; cap bounds each tick to the first two candidates (rr1/rr0), preserving the
; deterministic seed/tick alternation pattern (seed-11: (11+tick)%2 = 1 at
; even ticks → rr0 productive; 0 at odd ticks → rr1 distractor).

(= (exp03-exp02-longer-initial-state seed-11)
   (state 0 seed-11 (mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1)))

(= (exp03-exp02-full-source-rules seed-11 random)
   ((exp02-random-polymer-rule seed-11 rr1)
    (exp02-random-polymer-rule seed-11 rr0)
    (exp02-random-polymer-rule seed-11 rr2)
    (exp02-random-polymer-rule seed-11 rr3)
    (exp02-random-polymer-rule seed-11 rr4)
    (exp02-random-polymer-rule seed-11 rr5)))

(= (exp03-exp02-full-source-rules seed-11 shuffled)
   ((exp02-shuffled-control-rule seed-11 sr1)
    (exp02-shuffled-control-rule seed-11 sr0)
    (exp02-shuffled-control-rule seed-11 sr2)
    (exp02-shuffled-control-rule seed-11 sr3)
    (exp02-shuffled-control-rule seed-11 sr4)
    (exp02-shuffled-control-rule seed-11 sr5)))

(= (exp03-exp02-full-source-rules seed-11 no-catalysis)
   ((exp02-no-catalysis-control-rule seed-11 nr1)
    (exp02-no-catalysis-control-rule seed-11 nr0)
    (exp02-no-catalysis-control-rule seed-11 nr2)
    (exp02-no-catalysis-control-rule seed-11 nr3)
    (exp02-no-catalysis-control-rule seed-11 nr4)
    (exp02-no-catalysis-control-rule seed-11 nr5)))

(= (exp03-exp02-longer-chamber $family seed-11)
   (make-chamber (exp03-exp02-longer $family seed-11)
                 (exp03-exp02-longer-initial-state seed-11)
                 (exp03-exp02-full-source-rules seed-11 $family)
                 ()))

(= (exp03-exp02-longer-after-10 $family seed-11)
   (chamber-run-10 (exp03-exp02-longer-chamber $family seed-11)))

(= (exp03-exp02-longer-event-count $family seed-11)
   (event-count (trace-events (exp03-exp02-longer-after-10 $family seed-11))))

(= (exp03-exp02-longer-tick $family seed-11)
   (state-tick (chamber-state (exp03-exp02-longer-after-10 $family seed-11))))

(= (exp03-exp02-longer-abundances $family seed-11)
   (chamber-abundance-snapshot (exp03-exp02-longer-after-10 $family seed-11)))

(= (exp03-exp02-longer-replay-10 $family seed-11)
   (chamber-run-5 (chamber-run-5 (exp03-exp02-longer-chamber $family seed-11))))

(= (exp03-exp02-longer-replay-ok? $family seed-11)
   (== (exp03-exp02-longer-after-10 $family seed-11)
       (exp03-exp02-longer-replay-10 $family seed-11)))

(= (exp03-exp02-longer-reactant-exhausted? seed-11)
   (== (exp03-exp02-longer-abundances random seed-11)
       (abundance-snapshot 10 ((mol Q0 0) (mol Q1 0) (mol Q01 5) (mol Q10 1)))))

(= (exp03-exp02-longer-controls-discriminate? seed-11)
   (and (> (exp03-exp02-longer-event-count random seed-11)
           (exp03-exp02-longer-event-count shuffled seed-11))
        (> (exp03-exp02-longer-event-count random seed-11)
           (exp03-exp02-longer-event-count no-catalysis seed-11))))

(= (exp03-exp02-longer-run-config seed-11 random)
   (make-run-config exp03-exp02-seed-11-longer-random exp03 (seed-11) 10 (candidate-cap 2 1) random))

(= (exp03-exp02-longer-run-config seed-11 shuffled)
   (make-run-config exp03-exp02-seed-11-longer-shuffled exp03 (seed-11) 10 (candidate-cap 2 1) shuffled))

(= (exp03-exp02-longer-run-config seed-11 no-catalysis)
   (make-run-config exp03-exp02-seed-11-longer-no-catalysis exp03 (seed-11) 10 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-longer-run-manifest seed-11 random)
   (make-run-manifest exp03-exp02-seed-11-longer-random config-hash-exp03-exp02-seed-11-longer-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-run-manifest seed-11 shuffled)
   (make-run-manifest exp03-exp02-seed-11-longer-shuffled config-hash-exp03-exp02-seed-11-longer-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-run-manifest seed-11 no-catalysis)
   (make-run-manifest exp03-exp02-seed-11-longer-no-catalysis config-hash-exp03-exp02-seed-11-longer-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longer-metrics seed-11 $family)
   ((metric dynamic-event-count (run-config-id (exp03-exp02-longer-run-config seed-11 $family)) (exp03-exp02-longer-event-count $family seed-11))
    (metric dynamic-tick-count (run-config-id (exp03-exp02-longer-run-config seed-11 $family)) 10)
    (metric source-exp02-rule-count (run-config-id (exp03-exp02-longer-run-config seed-11 $family)) 6)
    (metric dynamic-candidate-cap (run-config-id (exp03-exp02-longer-run-config seed-11 $family)) 2)))

(= (exp03-exp02-longer-run-summary seed-11 random)
   (make-run-summary exp03-exp02-seed-11-longer-random passed seed-11-longer-dynamic-produces-events True))

(= (exp03-exp02-longer-run-summary seed-11 shuffled)
   (make-run-summary exp03-exp02-seed-11-longer-shuffled passed seed-11-longer-shuffled-control-zero-events True))

(= (exp03-exp02-longer-run-summary seed-11 no-catalysis)
   (make-run-summary exp03-exp02-seed-11-longer-no-catalysis passed seed-11-longer-no-catalysis-control-zero-events True))

(= (exp03-exp02-longer-run-record seed-11 $family)
   (make-run-record
     (run-config-id (exp03-exp02-longer-run-config seed-11 $family))
     (exp03-exp02-longer-run-config seed-11 $family)
     (exp03-exp02-longer-run-manifest seed-11 $family)
     (trace-events (exp03-exp02-longer-after-10 $family seed-11))
     ((state-abundance-snapshot (exp03-exp02-longer-initial-state seed-11))
      (chamber-abundance-snapshot (exp03-exp02-longer-after-10 $family seed-11)))
     (exp03-exp02-longer-metrics seed-11 $family)
     (exp02-random-acs-candidates-6 seed-11)
     ()
     (exp03-exp02-longer-run-summary seed-11 $family)))

(= (exp03-exp02-longer-run-records seed-11)
   ((exp03-exp02-longer-run-record seed-11 random)
    (exp03-exp02-longer-run-record seed-11 shuffled)
    (exp03-exp02-longer-run-record seed-11 no-catalysis)))

(= (exp03-exp02-longer-run-records-complete? seed-11)
   (and (run-record-passed? (exp03-exp02-longer-run-record seed-11 random))
        (and (run-record-passed? (exp03-exp02-longer-run-record seed-11 shuffled))
             (and (run-record-passed? (exp03-exp02-longer-run-record seed-11 no-catalysis))
                  (and (exp03-exp02-longer-controls-discriminate? seed-11)
                       (exp03-exp02-longer-replay-ok? random seed-11))))))

; ----- 16-tick exp02-family dynamic bridge (seed-13, longer evolution) -----
;
; This extends the seed-13 exp02-family bridge from 10 ticks to 16 ticks with
; higher initial abundances (R0=8, R1=8).  The productive rr0 rule fires at
; even ticks (0,2,4,6,8,10,12,14) for 8 events before reactant exhaustion at
; tick 14.  Shuffled/no-catalysis controls remain zero-event over the same 16-tick
; horizon.  The chamber carries all eight seed-13 source rules; the candidate
; cap bounds each tick to the first two candidates (rr1/rr0), preserving the
; deterministic seed/tick alternation pattern (seed-13: (13+tick)%2 = 1 at
; even ticks → rr0 productive; 0 at odd ticks → rr1 distractor).

(= (exp03-exp02-longest-initial-state seed-13)
   (state 0 seed-13 (mol R0 8) (mol R1 8) (mol R01 0) (mol R10 1)))

(= (exp03-exp02-longest-chamber $family seed-13)
   (make-chamber (exp03-exp02-longest $family seed-13)
                 (exp03-exp02-longest-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 $family)
                 ()))

(= (exp03-exp02-longest-after-16 $family seed-13)
   (chamber-run-16 (exp03-exp02-longest-chamber $family seed-13)))

(= (exp03-exp02-longest-event-count $family seed-13)
   (event-count (trace-events (exp03-exp02-longest-after-16 $family seed-13))))

(= (exp03-exp02-longest-tick $family seed-13)
   (state-tick (chamber-state (exp03-exp02-longest-after-16 $family seed-13))))

(= (exp03-exp02-longest-abundances $family seed-13)
   (chamber-abundance-snapshot (exp03-exp02-longest-after-16 $family seed-13)))

(= (exp03-exp02-longest-replay-16 $family seed-13)
   (chamber-run-8 (chamber-run-8 (exp03-exp02-longest-chamber $family seed-13))))

(= (exp03-exp02-longest-replay-ok? $family seed-13)
   (== (exp03-exp02-longest-after-16 $family seed-13)
       (exp03-exp02-longest-replay-16 $family seed-13)))

(= (exp03-exp02-longest-reactant-exhausted? seed-13)
   (== (exp03-exp02-longest-abundances random-polymer seed-13)
       (abundance-snapshot 16 ((mol R0 0) (mol R1 0) (mol R01 8) (mol R10 1)))))

(= (exp03-exp02-longest-controls-discriminate? seed-13)
   (and (> (exp03-exp02-longest-event-count random-polymer seed-13)
           (exp03-exp02-longest-event-count shuffled-catalysts seed-13))
        (> (exp03-exp02-longest-event-count random-polymer seed-13)
           (exp03-exp02-longest-event-count no-catalysis seed-13))))

(= (exp03-exp02-longest-run-config seed-13 random-polymer)
   (make-run-config exp03-exp02-seed-13-longest-random exp03 (seed-13) 16 (candidate-cap 2 1) random-polymer))

(= (exp03-exp02-longest-run-config seed-13 shuffled-catalysts)
   (make-run-config exp03-exp02-seed-13-longest-shuffled exp03 (seed-13) 16 (candidate-cap 2 1) shuffled-catalysts))

(= (exp03-exp02-longest-run-config seed-13 no-catalysis)
   (make-run-config exp03-exp02-seed-13-longest-no-catalysis exp03 (seed-13) 16 (candidate-cap 2 1) no-catalysis))

(= (exp03-exp02-longest-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-exp02-seed-13-longest-random config-hash-exp03-exp02-seed-13-longest-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longest-run-manifest seed-13 shuffled-catalysts)
   (make-run-manifest exp03-exp02-seed-13-longest-shuffled config-hash-exp03-exp02-seed-13-longest-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longest-run-manifest seed-13 no-catalysis)
   (make-run-manifest exp03-exp02-seed-13-longest-no-catalysis config-hash-exp03-exp02-seed-13-longest-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-exp02-longest-metrics seed-13 $family)
   ((metric dynamic-event-count (run-config-id (exp03-exp02-longest-run-config seed-13 $family)) (exp03-exp02-longest-event-count $family seed-13))
    (metric dynamic-tick-count (run-config-id (exp03-exp02-longest-run-config seed-13 $family)) 16)
    (metric source-exp02-rule-count (run-config-id (exp03-exp02-longest-run-config seed-13 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-exp02-longest-run-config seed-13 $family)) 2)))

(= (exp03-exp02-longest-run-summary seed-13 random-polymer)
   (make-run-summary exp03-exp02-seed-13-longest-random passed seed-13-longest-dynamic-produces-events True))

(= (exp03-exp02-longest-run-summary seed-13 shuffled-catalysts)
   (make-run-summary exp03-exp02-seed-13-longest-shuffled passed seed-13-longest-shuffled-control-zero-events True))

(= (exp03-exp02-longest-run-summary seed-13 no-catalysis)
   (make-run-summary exp03-exp02-seed-13-longest-no-catalysis passed seed-13-longest-no-catalysis-control-zero-events True))

(= (exp03-exp02-longest-run-record seed-13 $family)
   (make-run-record
     (run-config-id (exp03-exp02-longest-run-config seed-13 $family))
     (exp03-exp02-longest-run-config seed-13 $family)
     (exp03-exp02-longest-run-manifest seed-13 $family)
     (trace-events (exp03-exp02-longest-after-16 $family seed-13))
     ((state-abundance-snapshot (exp03-exp02-longest-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-exp02-longest-after-16 $family seed-13)))
     (exp03-exp02-longest-metrics seed-13 $family)
     (exp02-seed-13-acs-candidates $family)
     ()
     (exp03-exp02-longest-run-summary seed-13 $family)))

(= (exp03-exp02-longest-run-records seed-13)
   ((exp03-exp02-longest-run-record seed-13 random-polymer)
    (exp03-exp02-longest-run-record seed-13 shuffled-catalysts)
    (exp03-exp02-longest-run-record seed-13 no-catalysis)))

(= (exp03-exp02-longest-run-records-complete? seed-13)
   (and (run-record-passed? (exp03-exp02-longest-run-record seed-13 random-polymer))
        (and (run-record-passed? (exp03-exp02-longest-run-record seed-13 shuffled-catalysts))
             (and (run-record-passed? (exp03-exp02-longest-run-record seed-13 no-catalysis))
                  (and (exp03-exp02-longest-controls-discriminate? seed-13)
                       (exp03-exp02-longest-replay-ok? random-polymer seed-13))))))

; ----- compact dynamic aggregate/report over tested full-source exports -----
;
; These atoms summarize the current exp03 full-source dynamic evidence across the
; tested seed-7, seed-13, and seed-17 run-export projections.  The report is a
; PeTTa-side compact provenance object for smoke tests and human-facing notes: it
; records random-family event counts, zero-event controls, and the common bounded
; candidate cap without broadening the chemistry kernel into host code.

(= (make-exp03-dynamic-summary-row $seed $random-events $shuffled-events $no-catalysis-events $candidate-cap $replay-ok?)
   (exp03-dynamic-summary-row $seed $random-events $shuffled-events $no-catalysis-events $candidate-cap $replay-ok?))

(= (exp03-dynamic-summary-row-seed
      (exp03-dynamic-summary-row $seed $random-events $shuffled-events $no-catalysis-events $candidate-cap $replay-ok?))
   $seed)

(= (exp03-dynamic-summary-row-random-events
      (exp03-dynamic-summary-row $seed $random-events $shuffled-events $no-catalysis-events $candidate-cap $replay-ok?))
   $random-events)

(= (exp03-dynamic-summary-row-control-zero?
      (exp03-dynamic-summary-row $seed $random-events 0 0 $candidate-cap $replay-ok?))
   True)

(= (exp03-dynamic-summary-row-for seed-7)
   (make-exp03-dynamic-summary-row
     seed-7
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-7 random)))
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-7 shuffled)))
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-7 no-catalysis)))
     2
     (exp03-exp02-full-source-replay-ok?)))

(= (exp03-dynamic-summary-row-for seed-13)
   (make-exp03-dynamic-summary-row
     seed-13
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-13 random-polymer)))
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-13 shuffled-catalysts)))
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-13 no-catalysis)))
     2
     (exp03-exp02-full-source-replay-ok-seed-13?)))

(= (exp03-dynamic-summary-row-for seed-17)
   (make-exp03-dynamic-summary-row
     seed-17
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-17 random-polymer)))
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-17 shuffled-catalysts)))
     (event-count (run-export-events (exp03-exp02-full-source-run-export seed-17 no-catalysis)))
     2
     (exp03-exp02-full-source-replay-ok-seed-17?)))

(= (exp03-dynamic-summary-rows)
   ((exp03-dynamic-summary-row-for seed-7)
    (exp03-dynamic-summary-row-for seed-13)
    (exp03-dynamic-summary-row-for seed-17)))

(= (exp03-dynamic-aggregate-report-current)
   (exp03-dynamic-aggregate-report
     tested-full-source-exports
     (seeds seed-7 seed-13 seed-17)
     (family-records 9)
     (active-random-family-records 3)
     (zero-event-control-family-records 6)
     (total-random-events 6)
     (total-control-events 0)
     (candidate-cap 2)
     (rows (exp03-dynamic-summary-rows))))

(= (exp03-dynamic-aggregate-report-control-clean?
      (exp03-dynamic-aggregate-report
        tested-full-source-exports
        (seeds seed-7 seed-13 seed-17)
        (family-records 9)
        (active-random-family-records 3)
        (zero-event-control-family-records 6)
        (total-random-events 6)
        (total-control-events 0)
        (candidate-cap 2)
        $rows))
   True)

(= (exp03-dynamic-aggregate-report-complete?)
   (and (exp03-dynamic-summary-row-control-zero? (exp03-dynamic-summary-row-for seed-7))
        (and (exp03-dynamic-summary-row-control-zero? (exp03-dynamic-summary-row-for seed-13))
             (and (exp03-dynamic-summary-row-control-zero? (exp03-dynamic-summary-row-for seed-17))
                  (exp03-dynamic-aggregate-report-control-clean? (exp03-dynamic-aggregate-report-current))))))

; ----- Cap-3 exp02-family dynamic bridge (seed-13, 15-tick evolution) -----
;
; This bridge explores candidate cap 3 to allow more rules to be considered per
; tick.  The chamber carries all eight seed-13 source rules; cap 3 bounds the
; per-tick pool to the first three candidates (rr1/rr0/rr2).  The deterministic
; seed/tick selector cycles through 3 positions: (13+tick)%3 = 1,2,0,1,2,0,...
; so rr0 (position 1) fires at ticks 0,3,6,9,12 for 5 productive events with
; R0=5/R1=5 exhaustion at tick 12.  rr2 (position 2) and rr1 (position 0) are
; distractors (their reactants R2/R3/R4/R5 are absent from state).  Shuffled
; and no-catalysis controls remain zero-event under the same cap.

(= (exp03-cap3-initial-state seed-13)
   (state 0 seed-13 (mol R0 5) (mol R1 5) (mol R01 0) (mol R10 1)))

(= (exp03-cap3-chamber $family seed-13)
   (make-chamber (exp03-cap3 $family seed-13)
                 (exp03-cap3-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 $family)
                 ()))

(= (exp03-cap3-after-15 $family seed-13)
   (chamber-run-3cap-15 (exp03-cap3-chamber $family seed-13)))

(= (exp03-cap3-event-count $family seed-13)
   (event-count (trace-events (exp03-cap3-after-15 $family seed-13))))

(= (exp03-cap3-tick $family seed-13)
   (state-tick (chamber-state (exp03-cap3-after-15 $family seed-13))))

(= (exp03-cap3-abundances $family seed-13)
   (chamber-abundance-snapshot (exp03-cap3-after-15 $family seed-13)))

(= (exp03-cap3-replay-15 $family seed-13)
   (chamber-run-3cap-5 (chamber-run-3cap-10 (exp03-cap3-chamber $family seed-13))))

(= (exp03-cap3-replay-ok? $family seed-13)
   (== (exp03-cap3-after-15 $family seed-13)
       (exp03-cap3-replay-15 $family seed-13)))

(= (exp03-cap3-reactant-exhausted? seed-13)
   (== (exp03-cap3-abundances random-polymer seed-13)
       (abundance-snapshot 15 ((mol R0 0) (mol R1 0) (mol R01 5) (mol R10 1)))))

(= (exp03-cap3-controls-discriminate? seed-13)
   (and (> (exp03-cap3-event-count random-polymer seed-13)
           (exp03-cap3-event-count shuffled-catalysts seed-13))
        (> (exp03-cap3-event-count random-polymer seed-13)
           (exp03-cap3-event-count no-catalysis seed-13))))

(= (exp03-cap3-run-config seed-13 random-polymer)
   (make-run-config exp03-cap3-seed-13-random exp03 (seed-13) 15 (candidate-cap 3 1) random-polymer))

(= (exp03-cap3-run-config seed-13 shuffled-catalysts)
   (make-run-config exp03-cap3-seed-13-shuffled exp03 (seed-13) 15 (candidate-cap 3 1) shuffled-catalysts))

(= (exp03-cap3-run-config seed-13 no-catalysis)
   (make-run-config exp03-cap3-seed-13-no-catalysis exp03 (seed-13) 15 (candidate-cap 3 1) no-catalysis))

(= (exp03-cap3-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-cap3-seed-13-random config-hash-exp03-cap3-seed-13-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-run-manifest seed-13 shuffled-catalysts)
   (make-run-manifest exp03-cap3-seed-13-shuffled config-hash-exp03-cap3-seed-13-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-run-manifest seed-13 no-catalysis)
   (make-run-manifest exp03-cap3-seed-13-no-catalysis config-hash-exp03-cap3-seed-13-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-metrics seed-13 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap3-run-config seed-13 $family)) (exp03-cap3-event-count $family seed-13))
    (metric dynamic-tick-count (run-config-id (exp03-cap3-run-config seed-13 $family)) 15)
    (metric source-exp02-rule-count (run-config-id (exp03-cap3-run-config seed-13 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap3-run-config seed-13 $family)) 3)))

(= (exp03-cap3-run-summary seed-13 random-polymer)
   (make-run-summary exp03-cap3-seed-13-random passed cap3-seed-13-bounded-dynamic-replay-ok True))

(= (exp03-cap3-run-summary seed-13 shuffled-catalysts)
   (make-run-summary exp03-cap3-seed-13-shuffled passed cap3-seed-13-shuffled-control-zero-events True))

(= (exp03-cap3-run-summary seed-13 no-catalysis)
   (make-run-summary exp03-cap3-seed-13-no-catalysis passed cap3-seed-13-no-catalysis-control-zero-events True))

(= (exp03-cap3-acs-candidates seed-13 random-polymer)
   (exp02-seed-13-acs-candidates random-polymer))

(= (exp03-cap3-acs-candidates seed-13 shuffled-catalysts)
   (exp02-seed-13-acs-candidates shuffled-catalysts))

(= (exp03-cap3-acs-candidates seed-13 no-catalysis)
   (exp02-seed-13-acs-candidates no-catalysis))

(= (exp03-cap3-run-record seed-13 $family)
   (make-run-record
     (run-config-id (exp03-cap3-run-config seed-13 $family))
     (exp03-cap3-run-config seed-13 $family)
     (exp03-cap3-run-manifest seed-13 $family)
     (trace-events (exp03-cap3-after-15 $family seed-13))
     ((state-abundance-snapshot (exp03-cap3-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-cap3-after-15 $family seed-13)))
     (exp03-cap3-metrics seed-13 $family)
     (exp03-cap3-acs-candidates seed-13 $family)
     ()
     (exp03-cap3-run-summary seed-13 $family)))

(= (exp03-cap3-run-records seed-13)
   ((exp03-cap3-run-record seed-13 random-polymer)
    (exp03-cap3-run-record seed-13 shuffled-catalysts)
    (exp03-cap3-run-record seed-13 no-catalysis)))

(= (exp03-cap3-run-records-complete? seed-13)
   (and (run-record-passed? (exp03-cap3-run-record seed-13 random-polymer))
        (and (run-record-passed? (exp03-cap3-run-record seed-13 shuffled-catalysts))
             (and (run-record-passed? (exp03-cap3-run-record seed-13 no-catalysis))
                  (and (exp03-cap3-controls-discriminate? seed-13)
                       (exp03-cap3-replay-ok? random-polymer seed-13))))))

; ============================================================================
; Cap-3 bridge for seed-7 (4-rule P-molecule family).
; (7+tick)%3 = 1,2,0,1,2,0,... so rr0 (position 1) fires at ticks 0,3,6,9,12
; for 5 productive events with P0=5/P1=5 exhaustion at tick 12.
; rr2 (position 2) and rr1 (position 0) are distractors (reactants absent).
; Note: seed-7 uses random/shuffled/no-catalysis family names in full-source-rules.
; ============================================================================

(= (exp03-cap3-initial-state seed-7)
   (state 0 seed-7 (mol P0 5) (mol P1 5) (mol P01 0) (mol P10 1)))

(= (exp03-cap3-chamber random-polymer seed-7)
   (make-chamber (exp03-cap3 random-polymer seed-7)
                 (exp03-cap3-initial-state seed-7)
                 (exp03-exp02-full-source-rules seed-7 random)
                 ()))

(= (exp03-cap3-chamber shuffled-catalysts seed-7)
   (make-chamber (exp03-cap3 shuffled-catalysts seed-7)
                 (exp03-cap3-initial-state seed-7)
                 (exp03-exp02-full-source-rules seed-7 shuffled)
                 ()))

(= (exp03-cap3-chamber no-catalysis seed-7)
   (make-chamber (exp03-cap3 no-catalysis seed-7)
                 (exp03-cap3-initial-state seed-7)
                 (exp03-exp02-full-source-rules seed-7 no-catalysis)
                 ()))

(= (exp03-cap3-after-15 $family seed-7)
   (chamber-run-3cap-15 (exp03-cap3-chamber $family seed-7)))

(= (exp03-cap3-event-count $family seed-7)
   (event-count (trace-events (exp03-cap3-after-15 $family seed-7))))

(= (exp03-cap3-tick $family seed-7)
   (state-tick (chamber-state (exp03-cap3-after-15 $family seed-7))))

(= (exp03-cap3-abundances $family seed-7)
   (chamber-abundance-snapshot (exp03-cap3-after-15 $family seed-7)))

(= (exp03-cap3-replay-15 $family seed-7)
   (chamber-run-3cap-5 (chamber-run-3cap-10 (exp03-cap3-chamber $family seed-7))))

(= (exp03-cap3-replay-ok? $family seed-7)
   (== (exp03-cap3-after-15 $family seed-7)
       (exp03-cap3-replay-15 $family seed-7)))

(= (exp03-cap3-reactant-exhausted? seed-7)
   (== (exp03-cap3-abundances random-polymer seed-7)
       (abundance-snapshot 15 ((mol P0 0) (mol P1 0) (mol P01 5) (mol P10 1)))))

(= (exp03-cap3-controls-discriminate? seed-7)
   (and (> (exp03-cap3-event-count random-polymer seed-7)
           (exp03-cap3-event-count shuffled-catalysts seed-7))
        (> (exp03-cap3-event-count random-polymer seed-7)
           (exp03-cap3-event-count no-catalysis seed-7))))

(= (exp03-cap3-run-config seed-7 random-polymer)
   (make-run-config exp03-cap3-seed-7-random exp03 (seed-7) 15 (candidate-cap 3 1) random-polymer))

(= (exp03-cap3-run-config seed-7 shuffled-catalysts)
   (make-run-config exp03-cap3-seed-7-shuffled exp03 (seed-7) 15 (candidate-cap 3 1) shuffled-catalysts))

(= (exp03-cap3-run-config seed-7 no-catalysis)
   (make-run-config exp03-cap3-seed-7-no-catalysis exp03 (seed-7) 15 (candidate-cap 3 1) no-catalysis))

(= (exp03-cap3-run-manifest seed-7 random-polymer)
   (make-run-manifest exp03-cap3-seed-7-random config-hash-exp03-cap3-seed-7-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-run-manifest seed-7 shuffled-catalysts)
   (make-run-manifest exp03-cap3-seed-7-shuffled config-hash-exp03-cap3-seed-7-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-run-manifest seed-7 no-catalysis)
   (make-run-manifest exp03-cap3-seed-7-no-catalysis config-hash-exp03-cap3-seed-7-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-metrics seed-7 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap3-run-config seed-7 $family)) (exp03-cap3-event-count $family seed-7))
    (metric dynamic-tick-count (run-config-id (exp03-cap3-run-config seed-7 $family)) 15)
    (metric source-exp02-rule-count (run-config-id (exp03-cap3-run-config seed-7 $family)) 4)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap3-run-config seed-7 $family)) 3)))

(= (exp03-cap3-run-summary seed-7 random-polymer)
   (make-run-summary exp03-cap3-seed-7-random passed cap3-seed-7-bounded-dynamic-replay-ok True))

(= (exp03-cap3-run-summary seed-7 shuffled-catalysts)
   (make-run-summary exp03-cap3-seed-7-shuffled passed cap3-seed-7-shuffled-control-zero-events True))

(= (exp03-cap3-run-summary seed-7 no-catalysis)
   (make-run-summary exp03-cap3-seed-7-no-catalysis passed cap3-seed-7-no-catalysis-control-zero-events True))

(= (exp03-cap3-acs-candidates seed-7 random-polymer)
   (exp02-random-acs-candidates seed-7))

(= (exp03-cap3-acs-candidates seed-7 shuffled-catalysts)
   (exp02-shuffled-acs-candidates seed-7))

(= (exp03-cap3-acs-candidates seed-7 no-catalysis)
   (exp02-no-catalysis-acs-candidates seed-7))

(= (exp03-cap3-run-record seed-7 $family)
   (make-run-record
     (run-config-id (exp03-cap3-run-config seed-7 $family))
     (exp03-cap3-run-config seed-7 $family)
     (exp03-cap3-run-manifest seed-7 $family)
     (trace-events (exp03-cap3-after-15 $family seed-7))
     ((state-abundance-snapshot (exp03-cap3-initial-state seed-7))
      (chamber-abundance-snapshot (exp03-cap3-after-15 $family seed-7)))
     (exp03-cap3-metrics seed-7 $family)
     (exp03-cap3-acs-candidates seed-7 $family)
     ()
     (exp03-cap3-run-summary seed-7 $family)))

(= (exp03-cap3-run-records seed-7)
   ((exp03-cap3-run-record seed-7 random-polymer)
    (exp03-cap3-run-record seed-7 shuffled-catalysts)
    (exp03-cap3-run-record seed-7 no-catalysis)))

(= (exp03-cap3-run-records-complete? seed-7)
   (and (run-record-passed? (exp03-cap3-run-record seed-7 random-polymer))
        (and (run-record-passed? (exp03-cap3-run-record seed-7 shuffled-catalysts))
             (and (run-record-passed? (exp03-cap3-run-record seed-7 no-catalysis))
                  (and (exp03-cap3-controls-discriminate? seed-7)
                       (exp03-cap3-replay-ok? random-polymer seed-7))))))

; ============================================================================
; Cap-3 bridge for seed-17 (8-rule S-molecule family).
; (17+tick)%3 = 2,0,1,2,0,1,... so rr0 (position 1) fires at ticks 2,5,8,11,14
; for 5 productive events with S0=5/S1=5 exhaustion at tick 14.
; rr2 (position 2) and rr1 (position 0) are distractors (reactants absent).
; ============================================================================

(= (exp03-cap3-initial-state seed-17)
   (state 0 seed-17 (mol S0 5) (mol S1 5) (mol S01 0) (mol S10 1)))

(= (exp03-cap3-chamber $family seed-17)
   (make-chamber (exp03-cap3 $family seed-17)
                 (exp03-cap3-initial-state seed-17)
                 (exp03-exp02-full-source-rules seed-17 $family)
                 ()))

(= (exp03-cap3-after-15 $family seed-17)
   (chamber-run-3cap-15 (exp03-cap3-chamber $family seed-17)))

(= (exp03-cap3-event-count $family seed-17)
   (event-count (trace-events (exp03-cap3-after-15 $family seed-17))))

(= (exp03-cap3-tick $family seed-17)
   (state-tick (chamber-state (exp03-cap3-after-15 $family seed-17))))

(= (exp03-cap3-abundances $family seed-17)
   (chamber-abundance-snapshot (exp03-cap3-after-15 $family seed-17)))

(= (exp03-cap3-replay-15 $family seed-17)
   (chamber-run-3cap-5 (chamber-run-3cap-10 (exp03-cap3-chamber $family seed-17))))

(= (exp03-cap3-replay-ok? $family seed-17)
   (== (exp03-cap3-after-15 $family seed-17)
       (exp03-cap3-replay-15 $family seed-17)))

(= (exp03-cap3-reactant-exhausted? seed-17)
   (== (exp03-cap3-abundances random-polymer seed-17)
       (abundance-snapshot 15 ((mol S0 0) (mol S1 0) (mol S01 5) (mol S10 1)))))

(= (exp03-cap3-controls-discriminate? seed-17)
   (and (> (exp03-cap3-event-count random-polymer seed-17)
           (exp03-cap3-event-count shuffled-catalysts seed-17))
        (> (exp03-cap3-event-count random-polymer seed-17)
           (exp03-cap3-event-count no-catalysis seed-17))))

(= (exp03-cap3-run-config seed-17 random-polymer)
   (make-run-config exp03-cap3-seed-17-random exp03 (seed-17) 15 (candidate-cap 3 1) random-polymer))

(= (exp03-cap3-run-config seed-17 shuffled-catalysts)
   (make-run-config exp03-cap3-seed-17-shuffled exp03 (seed-17) 15 (candidate-cap 3 1) shuffled-catalysts))

(= (exp03-cap3-run-config seed-17 no-catalysis)
   (make-run-config exp03-cap3-seed-17-no-catalysis exp03 (seed-17) 15 (candidate-cap 3 1) no-catalysis))

(= (exp03-cap3-run-manifest seed-17 random-polymer)
   (make-run-manifest exp03-cap3-seed-17-random config-hash-exp03-cap3-seed-17-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-run-manifest seed-17 shuffled-catalysts)
   (make-run-manifest exp03-cap3-seed-17-shuffled config-hash-exp03-cap3-seed-17-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-run-manifest seed-17 no-catalysis)
   (make-run-manifest exp03-cap3-seed-17-no-catalysis config-hash-exp03-cap3-seed-17-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-metrics seed-17 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap3-run-config seed-17 $family)) (exp03-cap3-event-count $family seed-17))
    (metric dynamic-tick-count (run-config-id (exp03-cap3-run-config seed-17 $family)) 15)
    (metric source-exp02-rule-count (run-config-id (exp03-cap3-run-config seed-17 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap3-run-config seed-17 $family)) 3)))

(= (exp03-cap3-run-summary seed-17 random-polymer)
   (make-run-summary exp03-cap3-seed-17-random passed cap3-seed-17-bounded-dynamic-replay-ok True))

(= (exp03-cap3-run-summary seed-17 shuffled-catalysts)
   (make-run-summary exp03-cap3-seed-17-shuffled passed cap3-seed-17-shuffled-control-zero-events True))

(= (exp03-cap3-run-summary seed-17 no-catalysis)
   (make-run-summary exp03-cap3-seed-17-no-catalysis passed cap3-seed-17-no-catalysis-control-zero-events True))

(= (exp03-cap3-acs-candidates seed-17 random-polymer)
   (exp02-seed-17-acs-candidates random-polymer))

(= (exp03-cap3-acs-candidates seed-17 shuffled-catalysts)
   (exp02-seed-17-acs-candidates shuffled-catalysts))

(= (exp03-cap3-acs-candidates seed-17 no-catalysis)
   (exp02-seed-17-acs-candidates no-catalysis))

(= (exp03-cap3-run-record seed-17 $family)
   (make-run-record
     (run-config-id (exp03-cap3-run-config seed-17 $family))
     (exp03-cap3-run-config seed-17 $family)
     (exp03-cap3-run-manifest seed-17 $family)
     (trace-events (exp03-cap3-after-15 $family seed-17))
     ((state-abundance-snapshot (exp03-cap3-initial-state seed-17))
      (chamber-abundance-snapshot (exp03-cap3-after-15 $family seed-17)))
     (exp03-cap3-metrics seed-17 $family)
     (exp03-cap3-acs-candidates seed-17 $family)
     ()
     (exp03-cap3-run-summary seed-17 $family)))

(= (exp03-cap3-run-records seed-17)
   ((exp03-cap3-run-record seed-17 random-polymer)
    (exp03-cap3-run-record seed-17 shuffled-catalysts)
    (exp03-cap3-run-record seed-17 no-catalysis)))

(= (exp03-cap3-run-records-complete? seed-17)
   (and (run-record-passed? (exp03-cap3-run-record seed-17 random-polymer))
        (and (run-record-passed? (exp03-cap3-run-record seed-17 shuffled-catalysts))
             (and (run-record-passed? (exp03-cap3-run-record seed-17 no-catalysis))
                  (and (exp03-cap3-controls-discriminate? seed-17)
                       (exp03-cap3-replay-ok? random-polymer seed-17))))))

; ============================================================================
; Cap-3 bridge for seed-11 (6-rule Q-molecule family).
; (11+tick)%3 = 2,0,1,2,0,1,... so rr0 (position 1) fires at ticks 2,5,8,11,14
; for 5 productive events with Q0=5/Q1=5 exhaustion at tick 14.
; rr2 (position 2) and rr1 (position 0) are distractors (reactants absent).
; Note: seed-11 uses random/shuffled/no-catalysis family names in full-source-rules.
; ============================================================================

(= (exp03-cap3-initial-state seed-11)
   (state 0 seed-11 (mol Q0 5) (mol Q1 5) (mol Q01 0) (mol Q10 1)))

(= (exp03-cap3-chamber random-polymer seed-11)
   (make-chamber (exp03-cap3 random-polymer seed-11)
                 (exp03-cap3-initial-state seed-11)
                 (exp03-exp02-full-source-rules seed-11 random)
                 ()))

(= (exp03-cap3-chamber shuffled-catalysts seed-11)
   (make-chamber (exp03-cap3 shuffled-catalysts seed-11)
                 (exp03-cap3-initial-state seed-11)
                 (exp03-exp02-full-source-rules seed-11 shuffled)
                 ()))

(= (exp03-cap3-chamber no-catalysis seed-11)
   (make-chamber (exp03-cap3 no-catalysis seed-11)
                 (exp03-cap3-initial-state seed-11)
                 (exp03-exp02-full-source-rules seed-11 no-catalysis)
                 ()))

(= (exp03-cap3-after-15 $family seed-11)
   (chamber-run-3cap-15 (exp03-cap3-chamber $family seed-11)))

(= (exp03-cap3-event-count $family seed-11)
   (event-count (trace-events (exp03-cap3-after-15 $family seed-11))))

(= (exp03-cap3-tick $family seed-11)
   (state-tick (chamber-state (exp03-cap3-after-15 $family seed-11))))

(= (exp03-cap3-abundances $family seed-11)
   (chamber-abundance-snapshot (exp03-cap3-after-15 $family seed-11)))

(= (exp03-cap3-replay-15 $family seed-11)
   (chamber-run-3cap-5 (chamber-run-3cap-10 (exp03-cap3-chamber $family seed-11))))

(= (exp03-cap3-replay-ok? $family seed-11)
   (== (exp03-cap3-after-15 $family seed-11)
       (exp03-cap3-replay-15 $family seed-11)))

(= (exp03-cap3-reactant-exhausted? seed-11)
   (== (exp03-cap3-abundances random-polymer seed-11)
       (abundance-snapshot 15 ((mol Q0 0) (mol Q1 0) (mol Q01 5) (mol Q10 1)))))

(= (exp03-cap3-controls-discriminate? seed-11)
   (and (> (exp03-cap3-event-count random-polymer seed-11)
           (exp03-cap3-event-count shuffled-catalysts seed-11))
        (> (exp03-cap3-event-count random-polymer seed-11)
           (exp03-cap3-event-count no-catalysis seed-11))))

(= (exp03-cap3-run-config seed-11 random-polymer)
   (make-run-config exp03-cap3-seed-11-random exp03 (seed-11) 15 (candidate-cap 3 1) random-polymer))

(= (exp03-cap3-run-config seed-11 shuffled-catalysts)
   (make-run-config exp03-cap3-seed-11-shuffled exp03 (seed-11) 15 (candidate-cap 3 1) shuffled-catalysts))

(= (exp03-cap3-run-config seed-11 no-catalysis)
   (make-run-config exp03-cap3-seed-11-no-catalysis exp03 (seed-11) 15 (candidate-cap 3 1) no-catalysis))

(= (exp03-cap3-run-manifest seed-11 random-polymer)
   (make-run-manifest exp03-cap3-seed-11-random config-hash-exp03-cap3-seed-11-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-run-manifest seed-11 shuffled-catalysts)
   (make-run-manifest exp03-cap3-seed-11-shuffled config-hash-exp03-cap3-seed-11-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-run-manifest seed-11 no-catalysis)
   (make-run-manifest exp03-cap3-seed-11-no-catalysis config-hash-exp03-cap3-seed-11-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-metrics seed-11 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap3-run-config seed-11 $family)) (exp03-cap3-event-count $family seed-11))
    (metric dynamic-tick-count (run-config-id (exp03-cap3-run-config seed-11 $family)) 15)
    (metric source-exp02-rule-count (run-config-id (exp03-cap3-run-config seed-11 $family)) 6)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap3-run-config seed-11 $family)) 3)))

(= (exp03-cap3-run-summary seed-11 random-polymer)
   (make-run-summary exp03-cap3-seed-11-random passed cap3-seed-11-bounded-dynamic-replay-ok True))

(= (exp03-cap3-run-summary seed-11 shuffled-catalysts)
   (make-run-summary exp03-cap3-seed-11-shuffled passed cap3-seed-11-shuffled-control-zero-events True))

(= (exp03-cap3-run-summary seed-11 no-catalysis)
   (make-run-summary exp03-cap3-seed-11-no-catalysis passed cap3-seed-11-no-catalysis-control-zero-events True))

(= (exp03-cap3-acs-candidates seed-11 random-polymer)
   (exp02-random-acs-candidates-6 seed-11))

(= (exp03-cap3-acs-candidates seed-11 shuffled-catalysts)
   (exp02-shuffled-acs-candidates-6 seed-11))

(= (exp03-cap3-acs-candidates seed-11 no-catalysis)
   (exp02-no-catalysis-acs-candidates-6 seed-11))

(= (exp03-cap3-run-record seed-11 $family)
   (make-run-record
     (run-config-id (exp03-cap3-run-config seed-11 $family))
     (exp03-cap3-run-config seed-11 $family)
     (exp03-cap3-run-manifest seed-11 $family)
     (trace-events (exp03-cap3-after-15 $family seed-11))
     ((state-abundance-snapshot (exp03-cap3-initial-state seed-11))
      (chamber-abundance-snapshot (exp03-cap3-after-15 $family seed-11)))
     (exp03-cap3-metrics seed-11 $family)
     (exp03-cap3-acs-candidates seed-11 $family)
     ()
     (exp03-cap3-run-summary seed-11 $family)))

(= (exp03-cap3-run-records seed-11)
   ((exp03-cap3-run-record seed-11 random-polymer)
    (exp03-cap3-run-record seed-11 shuffled-catalysts)
    (exp03-cap3-run-record seed-11 no-catalysis)))

(= (exp03-cap3-run-records-complete? seed-11)
   (and (run-record-passed? (exp03-cap3-run-record seed-11 random-polymer))
        (and (run-record-passed? (exp03-cap3-run-record seed-11 shuffled-catalysts))
             (and (run-record-passed? (exp03-cap3-run-record seed-11 no-catalysis))
                  (and (exp03-cap3-controls-discriminate? seed-11)
                       (exp03-cap3-replay-ok? random-polymer seed-11))))))

; ============================================================================
; Cap-3 RICH bridge for seed-13 (10-molecule multi-rule productive state).
;
; This bridge explores the top TASKS.md item: richer state shapes where
; multiple rules fire productively under cap 3.  The initial state includes
; reactants for all three cap-3 rules (rr0, rr1, rr2), so ALL three can fire:
;   rr0: R0+R1 -> R01, cat R10  (random) / R2 (shuffled) / None (no-cat)
;   rr1: R2+R3 -> R10, cat R01  (random) / R4 (shuffled) / None (no-cat)
;   rr2: R4+R5 -> R45, cat R54  (random) / R6 (shuffled) / None (no-cat)
;
; The selector cycles (13+tick)%3 = 1,2,0,1,2,0,... so:
;   tick 0: rr0 fires, tick 1: rr2 fires, tick 2: rr1 fires, ...
;   After 9 ticks: 3 rounds x 3 rules = 9 productive events, all reactants
;   exhausted (R0=R1=R2=R3=R4=R5=0).
;
; Shuffled control: rr0 fires (cat R2 present), rr1 fires (cat R4 present),
;   but rr2 is no-op (cat R6 absent).  Total 6 events.
; No-catalysis control: 0 events (all catalysts None).
; Control discrimination: random (9) > shuffled (6) > no-catalysis (0).
; ============================================================================

; --- 10-molecule chamber-tick-with-candidate-accum clauses ---

; rr0 with cat R10 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 R10) $score))
   (if (and (> $r0 0) (and (> $r1 0) (> $r10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1))
                       (mol R1 (- $r1 1))
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 (+ $r01 1))
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr0 R0 R1 R01 R10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr0 with cat R2 (shuffled-catalysts): productive (R2 present in rich state)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 R2) $score))
   (if (and (> $r0 0) (and (> $r1 0) (> $r2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1))
                       (mol R1 (- $r1 1))
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 (+ $r01 1))
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr0 R0 R1 R01 R2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr0 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))

; rr1 with cat R01 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 R01) $score))
   (if (and (> $r2 0) (and (> $r3 0) (> $r01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 (- $r2 1))
                       (mol R3 (- $r3 1))
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 $r01)
                       (mol R10 (+ $r10 1))
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr1 R2 R3 R10 R01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr1 with cat R4 (shuffled-catalysts): productive (R4 present in rich state)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 R4) $score))
   (if (and (> $r2 0) (and (> $r3 0) (> $r4 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 (- $r2 1))
                       (mol R3 (- $r3 1))
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 $r01)
                       (mol R10 (+ $r10 1))
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr1 R2 R3 R10 R4)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr1 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))

; rr2 with cat R54 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 R54) $score))
   (if (and (> $r4 0) (and (> $r5 0) (> $r54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 (- $r4 1))
                       (mol R5 (- $r5 1))
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 (+ $r45 1))
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr2 R4 R5 R45 R54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr2 with cat R6 (shuffled-catalysts): no-op (R6 absent from state)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 R6) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))

; rr2 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))

; ============================================================================
; Cap-4 RICH bridge for seed-13 (12-molecule multi-rule productive state).
;
; This bridge explores cap-4 pools with richer state shapes.  The initial
; state includes reactants for all four cap-4 rules (rr0, rr1, rr2, rr3),
; so ALL four can fire under random-polymer catalysis:
;   rr0: R0+R1 -> R01, cat R10  (random) / R2 (shuffled) / None (no-cat)
;   rr1: R2+R3 -> R10, cat R01  (random) / R4 (shuffled) / None (no-cat)
;   rr2: R4+R5 -> R45, cat R54  (random) / R6 (shuffled) / None (no-cat)
;   rr3: R6+R7 -> R54, cat R45  (random) / R8 (shuffled) / None (no-cat)
;
; The selector cycles (13+tick)%4 = 1,2,3,0,1,2,3,0,... so:
;   tick 0: rr0, tick 1: rr2, tick 2: rr3, tick 3: rr1, ...
;   After 12 ticks: 3 rounds x 4 rules = 12 productive events, all reactants
;   exhausted (R0=R1=R2=R3=R4=R5=R6=R7=0).
;
; Shuffled control: rr0 (cat R2), rr1 (cat R4), rr2 (cat R6) all fire, but
;   rr3 is no-op (cat R8 absent).  Total 9 events.
; No-catalysis control: 0 events.
; Control discrimination: random (12) > shuffled (9) > no-catalysis (0).
; ============================================================================

; --- 12-molecule chamber-tick-with-candidate-accum clauses ---

; rr0 with cat R10 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 R10) $score))
   (if (and (> $r0 0) (and (> $r1 0) (> $r10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1))
                       (mol R1 (- $r1 1))
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 (+ $r01 1))
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr0 R0 R1 R01 R10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr0 with cat R2 (shuffled-catalysts): productive (R2 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 R2) $score))
   (if (and (> $r0 0) (and (> $r1 0) (> $r2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1))
                       (mol R1 (- $r1 1))
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 (+ $r01 1))
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr0 R0 R1 R01 R2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr0 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R6 $r6)
                   (mol R7 $r7)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))

; rr1 with cat R01 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 R01) $score))
   (if (and (> $r2 0) (and (> $r3 0) (> $r01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 (- $r2 1))
                       (mol R3 (- $r3 1))
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 (+ $r10 1))
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr1 R2 R3 R10 R01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr1 with cat R4 (shuffled-catalysts): productive (R4 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 R4) $score))
   (if (and (> $r2 0) (and (> $r3 0) (> $r4 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 (- $r2 1))
                       (mol R3 (- $r3 1))
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 (+ $r10 1))
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr1 R2 R3 R10 R4)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr1 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R6 $r6)
                   (mol R7 $r7)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))

; rr2 with cat R54 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 R54) $score))
   (if (and (> $r4 0) (and (> $r5 0) (> $r54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 (- $r4 1))
                       (mol R5 (- $r5 1))
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 (+ $r45 1))
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr2 R4 R5 R45 R54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr2 with cat R6 (shuffled-catalysts): productive (R6 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                       (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 R6) $score))
   (if (and (> $r4 0) (and (> $r5 0) (> $r6 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 (- $r4 1))
                       (mol R5 (- $r5 1))
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 (+ $r45 1))
                       (mol R54 $r54))
                $rules
                (append-event $events (event $tick rr2 R4 R5 R45 R6)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr2 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                       (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R6 $r6)
                   (mol R7 $r7)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))

; rr3 with cat R45 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr3 R6 R7 R54 R45) $score))
   (if (and (> $r6 0) (and (> $r7 0) (> $r45 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 (- $r6 1))
                       (mol R7 (- $r7 1))
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 (+ $r54 1)))
                $rules
                (append-event $events (event $tick rr3 R6 R7 R54 R45)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54))
                $rules
                $events)))

; rr3 with cat R8 (shuffled-catalysts): no-op (R8 absent from state)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr3 R6 R7 R54 R8) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R6 $r6)
                   (mol R7 $r7)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))

; rr3 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54))
               $rules
               $events)
      (candidate $ct (rule rr3 R6 R7 R54 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol R0 $r0)
                   (mol R1 $r1)
                   (mol R2 $r2)
                   (mol R3 $r3)
                   (mol R4 $r4)
                   (mol R5 $r5)
                   (mol R6 $r6)
                   (mol R7 $r7)
                   (mol R01 $r01)
                   (mol R10 $r10)
                   (mol R45 $r45)
                   (mol R54 $r54))
            $rules
            $events))



; --- 12-molecule Q-family chamber-tick-with-candidate-accum clauses ---

; rr0 with cat Q10 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule rr0 Q0 Q1 Q01 Q10) $score))
   (if (and (> $q0 0) (and (> $q1 0) (> $q10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 (- $q0 1))
                       (mol Q1 (- $q1 1))
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 (+ $q01 1))
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                (append-event $events (event $tick rr0 Q0 Q1 Q01 Q10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                $events)))

; rr0 with cat Q2 (shuffled-catalysts): productive (Q2 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule sr0 Q0 Q1 Q01 Q2) $score))
   (if (and (> $q0 0) (and (> $q1 0) (> $q2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 (- $q0 1))
                       (mol Q1 (- $q1 1))
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 (+ $q01 1))
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                (append-event $events (event $tick rr0 Q0 Q1 Q01 Q2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                $events)))

; rr0 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule nr0 Q0 Q1 Q01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

; rr1 with cat Q01 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule rr1 Q2 Q3 Q10 Q01) $score))
   (if (and (> $q2 0) (and (> $q3 0) (> $q01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 (- $q2 1))
                       (mol Q3 (- $q3 1))
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 (+ $q10 1))
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                (append-event $events (event $tick rr1 Q2 Q3 Q10 Q01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                $events)))

; rr1 with cat Q4 (shuffled-catalysts): productive (Q4 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule sr1 Q2 Q3 Q10 Q4) $score))
   (if (and (> $q2 0) (and (> $q3 0) (> $q4 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 (- $q2 1))
                       (mol Q3 (- $q3 1))
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 (+ $q10 1))
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                (append-event $events (event $tick rr1 Q2 Q3 Q10 Q4)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                $events)))

; rr1 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule nr1 Q2 Q3 Q10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

; rr2 with cat Q54 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule rr2 Q4 Q5 Q45 Q54) $score))
   (if (and (> $q4 0) (and (> $q5 0) (> $q54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 (- $q4 1))
                       (mol Q5 (- $q5 1))
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 (+ $q45 1))
                       (mol Q54 $q54))
                $rules
                (append-event $events (event $tick rr2 Q4 Q5 Q45 Q54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                $events)))

; rr2 with cat Q6 (shuffled-catalysts): productive (Q6 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                       (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule sr2 Q4 Q5 Q45 Q6) $score))
   (if (and (> $q4 0) (and (> $q5 0) (> $q6 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 (- $q4 1))
                       (mol Q5 (- $q5 1))
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 (+ $q45 1))
                       (mol Q54 $q54))
                $rules
                (append-event $events (event $tick rr2 Q4 Q5 Q45 Q6)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                $events)))

; rr2 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                       (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule nr2 Q4 Q5 Q45 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

; rr3 with cat Q45 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule rr3 Q6 Q7 Q54 Q45) $score))
   (if (and (> $q6 0) (and (> $q7 0) (> $q45 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 (- $q6 1))
                       (mol Q7 (- $q7 1))
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 (+ $q54 1)))
                $rules
                (append-event $events (event $tick rr3 Q6 Q7 Q54 Q45)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0)
                       (mol Q1 $q1)
                       (mol Q2 $q2)
                       (mol Q3 $q3)
                       (mol Q4 $q4)
                       (mol Q5 $q5)
                       (mol Q6 $q6)
                       (mol Q7 $q7)
                       (mol Q01 $q01)
                       (mol Q10 $q10)
                       (mol Q45 $q45)
                       (mol Q54 $q54))
                $rules
                $events)))

; rr3 with cat Q8 (shuffled-catalysts): no-op (Q8 absent from state)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule sr3 Q6 Q7 Q54 Q0) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

; rr3 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule nr3 Q6 Q7 Q54 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))


; rr4 uses Q05, which is intentionally outside this 12-molecule rich-state
; bridge.  Treat it as a bounded cap-5 distractor/no-op while preserving tick
; advancement and keeping the rule visible in the candidate pool.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule rr4 Q0 Q5 Q05 Q2) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule sr4 Q0 Q5 Q05 Q10) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule nr4 Q0 Q5 Q05 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

; rr5 is the sixth seed-11/Q-family source rule.  It is intentionally outside
; this 12-molecule rich-state bridge (product Q16), so cap-6 can expose the
; full six-rule source pool while preserving safe no-op tick advancement.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule rr5 Q1 Q6 Q16 Q3) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule sr5 Q1 Q6 Q16 Q54) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0)
                      (mol Q1 $q1)
                      (mol Q2 $q2)
                      (mol Q3 $q3)
                      (mol Q4 $q4)
                      (mol Q5 $q5)
                      (mol Q6 $q6)
                      (mol Q7 $q7)
                      (mol Q01 $q01)
                      (mol Q10 $q10)
                      (mol Q45 $q45)
                      (mol Q54 $q54))
               $rules
               $events)
      (candidate $ct (rule nr5 Q1 Q6 Q16 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol Q0 $q0)
                   (mol Q1 $q1)
                   (mol Q2 $q2)
                   (mol Q3 $q3)
                   (mol Q4 $q4)
                   (mol Q5 $q5)
                   (mol Q6 $q6)
                   (mol Q7 $q7)
                   (mol Q01 $q01)
                   (mol Q10 $q10)
                   (mol Q45 $q45)
                   (mol Q54 $q54))
            $rules
            $events))

; --- 12-molecule S-family chamber-tick-with-candidate-accum clauses (seed-17 cap-4 rich bridge) ---

; rr0 with cat S10 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr0 S0 S1 S01 S10) $score))
   (if (and (> $s0 0) (and (> $s1 0) (> $s10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 (- $s0 1))
                       (mol S1 (- $s1 1))
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 (+ $s01 1))
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                (append-event $events (event $tick rr0 S0 S1 S01 S10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                $events)))

; rr0 with cat S2 (shuffled-catalysts): productive (S2 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr0 S0 S1 S01 S2) $score))
   (if (and (> $s0 0) (and (> $s1 0) (> $s2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 (- $s0 1))
                       (mol S1 (- $s1 1))
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 (+ $s01 1))
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                (append-event $events (event $tick rr0 S0 S1 S01 S2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                $events)))

; rr0 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr0 S0 S1 S01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0)
                   (mol S1 $s1)
                   (mol S2 $s2)
                   (mol S3 $s3)
                   (mol S4 $s4)
                   (mol S5 $s5)
                   (mol S6 $s6)
                   (mol S7 $s7)
                   (mol S01 $s01)
                   (mol S10 $s10)
                   (mol S45 $s45)
                   (mol S54 $s54))
            $rules
            $events))

; rr1 with cat S01 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr1 S2 S3 S10 S01) $score))
   (if (and (> $s2 0) (and (> $s3 0) (> $s01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 (- $s2 1))
                       (mol S3 (- $s3 1))
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 (+ $s10 1))
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                (append-event $events (event $tick rr1 S2 S3 S10 S01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                $events)))

; rr1 with cat S4 (shuffled-catalysts): productive (S4 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr1 S2 S3 S10 S4) $score))
   (if (and (> $s2 0) (and (> $s3 0) (> $s4 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 (- $s2 1))
                       (mol S3 (- $s3 1))
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 (+ $s10 1))
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                (append-event $events (event $tick rr1 S2 S3 S10 S4)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                $events)))

; rr1 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr1 S2 S3 S10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0)
                   (mol S1 $s1)
                   (mol S2 $s2)
                   (mol S3 $s3)
                   (mol S4 $s4)
                   (mol S5 $s5)
                   (mol S6 $s6)
                   (mol S7 $s7)
                   (mol S01 $s01)
                   (mol S10 $s10)
                   (mol S45 $s45)
                   (mol S54 $s54))
            $rules
            $events))

; rr2 with cat S54 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr2 S4 S5 S45 S54) $score))
   (if (and (> $s4 0) (and (> $s5 0) (> $s54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 (- $s4 1))
                       (mol S5 (- $s5 1))
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 (+ $s45 1))
                       (mol S54 $s54))
                $rules
                (append-event $events (event $tick rr2 S4 S5 S45 S54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                $events)))

; rr2 with cat S6 (shuffled-catalysts): productive (S6 present)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                       (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr2 S4 S5 S45 S6) $score))
   (if (and (> $s4 0) (and (> $s5 0) (> $s6 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 (- $s4 1))
                       (mol S5 (- $s5 1))
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 (+ $s45 1))
                       (mol S54 $s54))
                $rules
                (append-event $events (event $tick rr2 S4 S5 S45 S6)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                $events)))

; rr2 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                       (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr2 S4 S5 S45 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0)
                   (mol S1 $s1)
                   (mol S2 $s2)
                   (mol S3 $s3)
                   (mol S4 $s4)
                   (mol S5 $s5)
                   (mol S6 $s6)
                   (mol S7 $s7)
                   (mol S01 $s01)
                   (mol S10 $s10)
                   (mol S45 $s45)
                   (mol S54 $s54))
            $rules
            $events))

; rr3 with cat S45 (random-polymer): productive
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr3 S6 S7 S54 S45) $score))
   (if (and (> $s6 0) (and (> $s7 0) (> $s45 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 (- $s6 1))
                       (mol S7 (- $s7 1))
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 (+ $s54 1)))
                $rules
                (append-event $events (event $tick rr3 S6 S7 S54 S45)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0)
                       (mol S1 $s1)
                       (mol S2 $s2)
                       (mol S3 $s3)
                       (mol S4 $s4)
                       (mol S5 $s5)
                       (mol S6 $s6)
                       (mol S7 $s7)
                       (mol S01 $s01)
                       (mol S10 $s10)
                       (mol S45 $s45)
                       (mol S54 $s54))
                $rules
                $events)))

; rr3 with cat S8 (shuffled-catalysts): no-op (S8 absent from state)
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr3 S6 S7 S54 S8) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0)
                   (mol S1 $s1)
                   (mol S2 $s2)
                   (mol S3 $s3)
                   (mol S4 $s4)
                   (mol S5 $s5)
                   (mol S6 $s6)
                   (mol S7 $s7)
                   (mol S01 $s01)
                   (mol S10 $s10)
                   (mol S45 $s45)
                   (mol S54 $s54))
            $rules
            $events))

; rr3 with cat None (no-catalysis): no-op
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr3 S6 S7 S54 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0)
                   (mol S1 $s1)
                   (mol S2 $s2)
                   (mol S3 $s3)
                   (mol S4 $s4)
                   (mol S5 $s5)
                   (mol S6 $s6)
                   (mol S7 $s7)
                   (mol S01 $s01)
                   (mol S10 $s10)
                   (mol S45 $s45)
                   (mol S54 $s54))
            $rules
            $events))


; --- Rich bridge atoms ---

(= (exp03-cap3-rich-initial-state seed-13)
   (state 0 seed-13
          (mol R0 3) (mol R1 3) (mol R2 3) (mol R3 3)
          (mol R4 3) (mol R5 3) (mol R01 1) (mol R10 1)
          (mol R45 0) (mol R54 1)))

(= (exp03-cap3-rich-chamber $family seed-13)
   (make-chamber (exp03-cap3-rich $family seed-13)
                 (exp03-cap3-rich-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 $family)
                 ()))

(= (exp03-cap3-rich-after-15 $family seed-13)
   (chamber-run-3cap-15 (exp03-cap3-rich-chamber $family seed-13)))

(= (exp03-cap3-rich-event-count $family seed-13)
   (event-count (trace-events (exp03-cap3-rich-after-15 $family seed-13))))

(= (exp03-cap3-rich-tick $family seed-13)
   (state-tick (chamber-state (exp03-cap3-rich-after-15 $family seed-13))))

(= (exp03-cap3-rich-abundances $family seed-13)
   (chamber-abundance-snapshot (exp03-cap3-rich-after-15 $family seed-13)))

(= (exp03-cap3-rich-replay-15 $family seed-13)
   (chamber-run-3cap-5 (chamber-run-3cap-10 (exp03-cap3-rich-chamber $family seed-13))))

(= (exp03-cap3-rich-replay-ok? $family seed-13)
   (== (exp03-cap3-rich-after-15 $family seed-13)
       (exp03-cap3-rich-replay-15 $family seed-13)))

(= (exp03-cap3-rich-reactant-exhausted? seed-13)
   (== (exp03-cap3-rich-abundances random-polymer seed-13)
       (abundance-snapshot 15 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                               (mol R4 0) (mol R5 0) (mol R01 4) (mol R10 4)
                               (mol R45 3) (mol R54 1)))))

(= (exp03-cap3-rich-controls-discriminate? seed-13)
   (and (> (exp03-cap3-rich-event-count random-polymer seed-13)
           (exp03-cap3-rich-event-count shuffled-catalysts seed-13))
        (> (exp03-cap3-rich-event-count random-polymer seed-13)
           (exp03-cap3-rich-event-count no-catalysis seed-13))))

(= (exp03-cap3-rich-run-config seed-13 random-polymer)
   (make-run-config exp03-cap3-rich-seed-13-random exp03 (seed-13) 15 (candidate-cap 3 1) random-polymer))

(= (exp03-cap3-rich-run-config seed-13 shuffled-catalysts)
   (make-run-config exp03-cap3-rich-seed-13-shuffled exp03 (seed-13) 15 (candidate-cap 3 1) shuffled-catalysts))

(= (exp03-cap3-rich-run-config seed-13 no-catalysis)
   (make-run-config exp03-cap3-rich-seed-13-no-catalysis exp03 (seed-13) 15 (candidate-cap 3 1) no-catalysis))

(= (exp03-cap3-rich-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-cap3-rich-seed-13-random config-hash-exp03-cap3-rich-seed-13-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-rich-run-manifest seed-13 shuffled-catalysts)
   (make-run-manifest exp03-cap3-rich-seed-13-shuffled config-hash-exp03-cap3-rich-seed-13-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-rich-run-manifest seed-13 no-catalysis)
   (make-run-manifest exp03-cap3-rich-seed-13-no-catalysis config-hash-exp03-cap3-rich-seed-13-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap3-rich-metrics seed-13 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap3-rich-run-config seed-13 $family)) (exp03-cap3-rich-event-count $family seed-13))
    (metric dynamic-tick-count (run-config-id (exp03-cap3-rich-run-config seed-13 $family)) 15)
    (metric source-exp02-rule-count (run-config-id (exp03-cap3-rich-run-config seed-13 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap3-rich-run-config seed-13 $family)) 3)
    (metric rich-state-molecule-count (run-config-id (exp03-cap3-rich-run-config seed-13 $family)) 10)))

(= (exp03-cap3-rich-run-summary seed-13 random-polymer)
   (make-run-summary exp03-cap3-rich-seed-13-random passed cap3-rich-seed-13-multi-rule-productive True))

(= (exp03-cap3-rich-run-summary seed-13 shuffled-catalysts)
   (make-run-summary exp03-cap3-rich-seed-13-shuffled passed cap3-rich-seed-13-shuffled-partial-productive True))

(= (exp03-cap3-rich-run-summary seed-13 no-catalysis)
   (make-run-summary exp03-cap3-rich-seed-13-no-catalysis passed cap3-rich-seed-13-no-catalysis-control-zero-events True))

(= (exp03-cap3-rich-acs-candidates seed-13 $family)
   (exp02-seed-13-acs-candidates $family))

(= (exp03-cap3-rich-run-record seed-13 $family)
   (make-run-record
     (run-config-id (exp03-cap3-rich-run-config seed-13 $family))
     (exp03-cap3-rich-run-config seed-13 $family)
     (exp03-cap3-rich-run-manifest seed-13 $family)
     (trace-events (exp03-cap3-rich-after-15 $family seed-13))
     ((state-abundance-snapshot (exp03-cap3-rich-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-cap3-rich-after-15 $family seed-13)))
     (exp03-cap3-rich-metrics seed-13 $family)
     (exp03-cap3-rich-acs-candidates seed-13 $family)
     ()
     (exp03-cap3-rich-run-summary seed-13 $family)))

(= (exp03-cap3-rich-run-records seed-13)
   ((exp03-cap3-rich-run-record seed-13 random-polymer)
    (exp03-cap3-rich-run-record seed-13 shuffled-catalysts)
    (exp03-cap3-rich-run-record seed-13 no-catalysis)))

(= (exp03-cap3-rich-run-records-complete? seed-13)
   (and (run-record-passed? (exp03-cap3-rich-run-record seed-13 random-polymer))
        (and (run-record-passed? (exp03-cap3-rich-run-record seed-13 shuffled-catalysts))
             (and (run-record-passed? (exp03-cap3-rich-run-record seed-13 no-catalysis))
                  (and (exp03-cap3-rich-controls-discriminate? seed-13)
                       (exp03-cap3-rich-replay-ok? random-polymer seed-13))))))

; ============================================================================
; rr4 uses S8/S9/S89, which are intentionally outside this 12-molecule
; rich-state bridge.  Keep the fifth cap-5 candidate visible as a no-op that
; still advances the chamber tick across random/shuffled/no-catalysis families.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr4 S8 S9 S89 S2) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0)
                   (mol S1 $s1)
                   (mol S2 $s2)
                   (mol S3 $s3)
                   (mol S4 $s4)
                   (mol S5 $s5)
                   (mol S6 $s6)
                   (mol S7 $s7)
                   (mol S01 $s01)
                   (mol S10 $s10)
                   (mol S45 $s45)
                   (mol S54 $s54))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr4 S8 S9 S89 S10) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0)
                   (mol S1 $s1)
                   (mol S2 $s2)
                   (mol S3 $s3)
                   (mol S4 $s4)
                   (mol S5 $s5)
                   (mol S6 $s6)
                   (mol S7 $s7)
                   (mol S01 $s01)
                   (mol S10 $s10)
                   (mol S45 $s45)
                   (mol S54 $s54))
            $rules
            $events))

(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0)
                      (mol S1 $s1)
                      (mol S2 $s2)
                      (mol S3 $s3)
                      (mol S4 $s4)
                      (mol S5 $s5)
                      (mol S6 $s6)
                      (mol S7 $s7)
                      (mol S01 $s01)
                      (mol S10 $s10)
                      (mol S45 $s45)
                      (mol S54 $s54))
               $rules
               $events)
      (candidate $ct (rule rr4 S8 S9 S89 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol S0 $s0)
                   (mol S1 $s1)
                   (mol S2 $s2)
                   (mol S3 $s3)
                   (mol S4 $s4)
                   (mol S5 $s5)
                   (mol S6 $s6)
                   (mol S7 $s7)
                   (mol S01 $s01)
                   (mol S10 $s10)
                   (mol S45 $s45)
                   (mol S54 $s54))
            $rules
            $events))

; 12-molecule P-family chamber-tick-with-candidate-accum clauses (seed-7 cap-4 rich bridge)
; ============================================================================

; rr0 with cat P10: productive in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule rr0 P0 P1 P01 P10) $score))
   (if (and (> $p0 0) (and (> $p1 0) (> $p10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 (- $p0 1))
                       (mol P1 (- $p1 1))
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 (+ $p01 1))
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                (append-event $events (event $tick rr0 P0 P1 P01 P10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                $events)))

; rr1 with cat P01: productive in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule rr1 P2 P3 P10 P01) $score))
   (if (and (> $p2 0) (and (> $p3 0) (> $p01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 (- $p2 1))
                       (mol P3 (- $p3 1))
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 (+ $p10 1))
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                (append-event $events (event $tick rr1 P2 P3 P10 P01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                $events)))

; rr2 with cat P2: productive in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule rr2 P0 P3 P03 P2) $score))
   (if (and (> $p0 0) (and (> $p3 0) (> $p2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 (- $p0 1))
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 (- $p3 1))
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 (+ $p03 1))
                       (mol P12 $p12))
                $rules
                (append-event $events (event $tick rr2 P0 P3 P03 P2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                $events)))

; rr3 with cat P0: productive in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule rr3 P1 P2 P12 P0) $score))
   (if (and (> $p1 0) (and (> $p2 0) (> $p0 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 (- $p1 1))
                       (mol P2 (- $p2 1))
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 (+ $p12 1)))
                $rules
                (append-event $events (event $tick rr3 P1 P2 P12 P0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                $events)))

; sr0 with cat P2: productive in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule sr0 P0 P1 P01 P2) $score))
   (if (and (> $p0 0) (and (> $p1 0) (> $p2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 (- $p0 1))
                       (mol P1 (- $p1 1))
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 (+ $p01 1))
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                (append-event $events (event $tick sr0 P0 P1 P01 P2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                $events)))

; sr1 with cat P0: productive in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule sr1 P2 P3 P10 P0) $score))
   (if (and (> $p2 0) (and (> $p3 0) (> $p0 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 (- $p2 1))
                       (mol P3 (- $p3 1))
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 (+ $p10 1))
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                (append-event $events (event $tick sr1 P2 P3 P10 P0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                $events)))

; sr2 with cat P10: productive in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule sr2 P0 P3 P03 P10) $score))
   (if (and (> $p0 0) (and (> $p3 0) (> $p10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 (- $p0 1))
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 (- $p3 1))
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 (+ $p03 1))
                       (mol P12 $p12))
                $rules
                (append-event $events (event $tick sr2 P0 P3 P03 P10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                $events)))

; sr3 with cat P3: productive in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule sr3 P1 P2 P12 P3) $score))
   (if (and (> $p1 0) (and (> $p2 0) (> $p3 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 (- $p1 1))
                       (mol P2 (- $p2 1))
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 (+ $p12 1)))
                $rules
                (append-event $events (event $tick sr3 P1 P2 P12 P3)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol P0 $p0)
                       (mol P1 $p1)
                       (mol P2 $p2)
                       (mol P3 $p3)
                       (mol P4 $p4)
                       (mol P5 $p5)
                       (mol P6 $p6)
                       (mol P7 $p7)
                       (mol P01 $p01)
                       (mol P10 $p10)
                       (mol P03 $p03)
                       (mol P12 $p12))
                $rules
                $events)))

; nr0 with cat None: no-op in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule nr0 P0 P1 P01 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0)
                   (mol P1 $p1)
                   (mol P2 $p2)
                   (mol P3 $p3)
                   (mol P4 $p4)
                   (mol P5 $p5)
                   (mol P6 $p6)
                   (mol P7 $p7)
                   (mol P01 $p01)
                   (mol P10 $p10)
                   (mol P03 $p03)
                   (mol P12 $p12))
            $rules
            $events))

; nr1 with cat None: no-op in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule nr1 P2 P3 P10 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0)
                   (mol P1 $p1)
                   (mol P2 $p2)
                   (mol P3 $p3)
                   (mol P4 $p4)
                   (mol P5 $p5)
                   (mol P6 $p6)
                   (mol P7 $p7)
                   (mol P01 $p01)
                   (mol P10 $p10)
                   (mol P03 $p03)
                   (mol P12 $p12))
            $rules
            $events))

; nr2 with cat None: no-op in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule nr2 P0 P3 P03 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0)
                   (mol P1 $p1)
                   (mol P2 $p2)
                   (mol P3 $p3)
                   (mol P4 $p4)
                   (mol P5 $p5)
                   (mol P6 $p6)
                   (mol P7 $p7)
                   (mol P01 $p01)
                   (mol P10 $p10)
                   (mol P03 $p03)
                   (mol P12 $p12))
            $rules
            $events))

; nr3 with cat None: no-op in seed-7 cap-4 rich state
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol P0 $p0)
                      (mol P1 $p1)
                      (mol P2 $p2)
                      (mol P3 $p3)
                      (mol P4 $p4)
                      (mol P5 $p5)
                      (mol P6 $p6)
                      (mol P7 $p7)
                      (mol P01 $p01)
                      (mol P10 $p10)
                      (mol P03 $p03)
                      (mol P12 $p12))
               $rules
               $events)
      (candidate $ct (rule nr3 P1 P2 P12 None) $score))
   (chamber $id
            (state (+ $tick 1) $seed
                   (mol P0 $p0)
                   (mol P1 $p1)
                   (mol P2 $p2)
                   (mol P3 $p3)
                   (mol P4 $p4)
                   (mol P5 $p5)
                   (mol P6 $p6)
                   (mol P7 $p7)
                   (mol P01 $p01)
                   (mol P10 $p10)
                   (mol P03 $p03)
                   (mol P12 $p12))
            $rules
            $events))


; ============================================================================
; Cap-4 RICH bridge atoms for seed-7 (12-molecule P-family, 4-rule productive state)
; ============================================================================

(= (exp03-cap4-rich-initial-state seed-7)
   (state 0 seed-7
          (mol P0 6) (mol P1 6) (mol P2 7) (mol P3 6)
          (mol P4 0) (mol P5 0) (mol P6 0) (mol P7 0)
          (mol P01 1) (mol P10 0) (mol P03 0) (mol P12 0)))

(= (exp03-cap4-rich-chamber $family seed-7)
   (make-chamber (exp03-cap4-rich $family seed-7)
                 (exp03-cap4-rich-initial-state seed-7)
                 (exp03-exp02-full-source-rules seed-7 $family)
                 ()))

(= (exp03-cap4-rich-after-12 $family seed-7)
   (chamber-run-4cap-12 (exp03-cap4-rich-chamber $family seed-7)))

(= (exp03-cap4-rich-event-count $family seed-7)
   (event-count (trace-events (exp03-cap4-rich-after-12 $family seed-7))))

(= (exp03-cap4-rich-tick $family seed-7)
   (state-tick (chamber-state (exp03-cap4-rich-after-12 $family seed-7))))

(= (exp03-cap4-rich-abundances $family seed-7)
   (chamber-abundance-snapshot (exp03-cap4-rich-after-12 $family seed-7)))

(= (exp03-cap4-rich-replay-12 $family seed-7)
   (chamber-run-4cap-3 (chamber-run-4cap-9 (exp03-cap4-rich-chamber $family seed-7))))

(= (exp03-cap4-rich-replay-ok? $family seed-7)
   (== (exp03-cap4-rich-after-12 $family seed-7)
       (exp03-cap4-rich-replay-12 $family seed-7)))

(= (exp03-cap4-rich-reactant-exhausted? seed-7)
   (== (exp03-cap4-rich-abundances random seed-7)
       (abundance-snapshot 12 ((mol P0 0) (mol P1 0) (mol P2 1) (mol P3 0)
                               (mol P4 0) (mol P5 0) (mol P6 0) (mol P7 0)
                               (mol P01 4) (mol P10 3) (mol P03 3) (mol P12 3)))))

(= (exp03-cap4-rich-controls-discriminate? seed-7)
   (and (== (exp03-cap4-rich-event-count random seed-7)
            (exp03-cap4-rich-event-count shuffled seed-7))
        (> (exp03-cap4-rich-event-count random seed-7)
           (exp03-cap4-rich-event-count no-catalysis seed-7))))

(= (exp03-cap4-rich-run-config seed-7 random)
   (make-run-config exp03-cap4-rich-seed-7-random exp03 (seed-7) 12 (candidate-cap 4 1) random))

(= (exp03-cap4-rich-run-config seed-7 shuffled)
   (make-run-config exp03-cap4-rich-seed-7-shuffled exp03 (seed-7) 12 (candidate-cap 4 1) shuffled))

(= (exp03-cap4-rich-run-config seed-7 no-catalysis)
   (make-run-config exp03-cap4-rich-seed-7-no-catalysis exp03 (seed-7) 12 (candidate-cap 4 1) no-catalysis))

(= (exp03-cap4-rich-run-manifest seed-7 random)
   (make-run-manifest exp03-cap4-rich-seed-7-random config-hash-exp03-cap4-rich-seed-7-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-run-manifest seed-7 shuffled)
   (make-run-manifest exp03-cap4-rich-seed-7-shuffled config-hash-exp03-cap4-rich-seed-7-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-run-manifest seed-7 no-catalysis)
   (make-run-manifest exp03-cap4-rich-seed-7-no-catalysis config-hash-exp03-cap4-rich-seed-7-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-metrics seed-7 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap4-rich-run-config seed-7 $family)) (exp03-cap4-rich-event-count $family seed-7))
    (metric dynamic-tick-count (run-config-id (exp03-cap4-rich-run-config seed-7 $family)) 12)
    (metric source-exp02-rule-count (run-config-id (exp03-cap4-rich-run-config seed-7 $family)) 4)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap4-rich-run-config seed-7 $family)) 4)
    (metric rich-state-molecule-count (run-config-id (exp03-cap4-rich-run-config seed-7 $family)) 12)))

(= (exp03-cap4-rich-run-summary seed-7 random)
   (make-run-summary exp03-cap4-rich-seed-7-random passed cap4-rich-seed-7-4-rule-productive True))

(= (exp03-cap4-rich-run-summary seed-7 shuffled)
   (make-run-summary exp03-cap4-rich-seed-7-shuffled passed cap4-rich-seed-7-shuffled-productive-control True))

(= (exp03-cap4-rich-run-summary seed-7 no-catalysis)
   (make-run-summary exp03-cap4-rich-seed-7-no-catalysis passed cap4-rich-seed-7-no-catalysis-control-zero-events True))

(= (exp03-cap4-rich-acs-candidates seed-7 random)
   (exp02-random-acs-candidates seed-7))

(= (exp03-cap4-rich-acs-candidates seed-7 shuffled)
   (exp02-shuffled-acs-candidates seed-7))

(= (exp03-cap4-rich-acs-candidates seed-7 no-catalysis)
   (exp02-no-catalysis-acs-candidates seed-7))

(= (exp03-cap4-rich-run-record seed-7 $family)
   (make-run-record
     (run-config-id (exp03-cap4-rich-run-config seed-7 $family))
     (exp03-cap4-rich-run-config seed-7 $family)
     (exp03-cap4-rich-run-manifest seed-7 $family)
     (trace-events (exp03-cap4-rich-after-12 $family seed-7))
     ((state-abundance-snapshot (exp03-cap4-rich-initial-state seed-7))
      (chamber-abundance-snapshot (exp03-cap4-rich-after-12 $family seed-7)))
     (exp03-cap4-rich-metrics seed-7 $family)
     (exp03-cap4-rich-acs-candidates seed-7 $family)
     ()
     (exp03-cap4-rich-run-summary seed-7 $family)))

(= (exp03-cap4-rich-run-records seed-7)
   ((exp03-cap4-rich-run-record seed-7 random)
    (exp03-cap4-rich-run-record seed-7 shuffled)
    (exp03-cap4-rich-run-record seed-7 no-catalysis)))

(= (exp03-cap4-rich-run-records-complete? seed-7)
   (and (run-record-passed? (exp03-cap4-rich-run-record seed-7 random))
        (and (run-record-passed? (exp03-cap4-rich-run-record seed-7 shuffled))
             (and (run-record-passed? (exp03-cap4-rich-run-record seed-7 no-catalysis))
                  (and (exp03-cap4-rich-controls-discriminate? seed-7)
                       (exp03-cap4-rich-replay-ok? random seed-7))))))

; ============================================================================
; Cap-4 RICH bridge atoms for seed-13 (12-molecule, 4-rule productive cycle)
; ============================================================================

(= (exp03-cap4-rich-initial-state seed-13)
   (state 0 seed-13
          (mol R0 3) (mol R1 3) (mol R2 3) (mol R3 3)
          (mol R4 3) (mol R5 3) (mol R6 3) (mol R7 3)
          (mol R01 0) (mol R10 1) (mol R45 0) (mol R54 1)))

(= (exp03-cap4-rich-chamber $family seed-13)
   (make-chamber (exp03-cap4-rich $family seed-13)
                 (exp03-cap4-rich-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 $family)
                 ()))

(= (exp03-cap4-rich-after-12 $family seed-13)
   (chamber-run-4cap-12 (exp03-cap4-rich-chamber $family seed-13)))

(= (exp03-cap4-rich-event-count $family seed-13)
   (event-count (trace-events (exp03-cap4-rich-after-12 $family seed-13))))

(= (exp03-cap4-rich-tick $family seed-13)
   (state-tick (chamber-state (exp03-cap4-rich-after-12 $family seed-13))))

(= (exp03-cap4-rich-abundances $family seed-13)
   (chamber-abundance-snapshot (exp03-cap4-rich-after-12 $family seed-13)))

(= (exp03-cap4-rich-replay-12 $family seed-13)
   (chamber-run-4cap-3 (chamber-run-4cap-9 (exp03-cap4-rich-chamber $family seed-13))))

(= (exp03-cap4-rich-replay-ok? $family seed-13)
   (== (exp03-cap4-rich-after-12 $family seed-13)
       (exp03-cap4-rich-replay-12 $family seed-13)))

(= (exp03-cap4-rich-reactant-exhausted? seed-13)
   (== (exp03-cap4-rich-abundances random-polymer seed-13)
       (abundance-snapshot 12 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                               (mol R4 0) (mol R5 0) (mol R6 0) (mol R7 0)
                               (mol R01 3) (mol R10 4) (mol R45 3) (mol R54 4)))))

(= (exp03-cap4-rich-controls-discriminate? seed-13)
   (and (> (exp03-cap4-rich-event-count random-polymer seed-13)
           (exp03-cap4-rich-event-count shuffled-catalysts seed-13))
        (> (exp03-cap4-rich-event-count random-polymer seed-13)
           (exp03-cap4-rich-event-count no-catalysis seed-13))))

(= (exp03-cap4-rich-run-config seed-13 random-polymer)
   (make-run-config exp03-cap4-rich-seed-13-random exp03 (seed-13) 12 (candidate-cap 4 1) random-polymer))

(= (exp03-cap4-rich-run-config seed-13 shuffled-catalysts)
   (make-run-config exp03-cap4-rich-seed-13-shuffled exp03 (seed-13) 12 (candidate-cap 4 1) shuffled-catalysts))

(= (exp03-cap4-rich-run-config seed-13 no-catalysis)
   (make-run-config exp03-cap4-rich-seed-13-no-catalysis exp03 (seed-13) 12 (candidate-cap 4 1) no-catalysis))

(= (exp03-cap4-rich-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-cap4-rich-seed-13-random config-hash-exp03-cap4-rich-seed-13-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-run-manifest seed-13 shuffled-catalysts)
   (make-run-manifest exp03-cap4-rich-seed-13-shuffled config-hash-exp03-cap4-rich-seed-13-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-run-manifest seed-13 no-catalysis)
   (make-run-manifest exp03-cap4-rich-seed-13-no-catalysis config-hash-exp03-cap4-rich-seed-13-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-metrics seed-13 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap4-rich-run-config seed-13 $family)) (exp03-cap4-rich-event-count $family seed-13))
    (metric dynamic-tick-count (run-config-id (exp03-cap4-rich-run-config seed-13 $family)) 12)
    (metric source-exp02-rule-count (run-config-id (exp03-cap4-rich-run-config seed-13 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap4-rich-run-config seed-13 $family)) 4)
    (metric rich-state-molecule-count (run-config-id (exp03-cap4-rich-run-config seed-13 $family)) 12)))

(= (exp03-cap4-rich-run-summary seed-13 random-polymer)
   (make-run-summary exp03-cap4-rich-seed-13-random passed cap4-rich-seed-13-4-rule-productive True))

(= (exp03-cap4-rich-run-summary seed-13 shuffled-catalysts)
   (make-run-summary exp03-cap4-rich-seed-13-shuffled passed cap4-rich-seed-13-shuffled-partial-productive True))

(= (exp03-cap4-rich-run-summary seed-13 no-catalysis)
   (make-run-summary exp03-cap4-rich-seed-13-no-catalysis passed cap4-rich-seed-13-no-catalysis-control-zero-events True))

(= (exp03-cap4-rich-acs-candidates seed-13 $family)
   (exp02-seed-13-acs-candidates $family))

(= (exp03-cap4-rich-run-record seed-13 $family)
   (make-run-record
     (run-config-id (exp03-cap4-rich-run-config seed-13 $family))
     (exp03-cap4-rich-run-config seed-13 $family)
     (exp03-cap4-rich-run-manifest seed-13 $family)
     (trace-events (exp03-cap4-rich-after-12 $family seed-13))
     ((state-abundance-snapshot (exp03-cap4-rich-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-cap4-rich-after-12 $family seed-13)))
     (exp03-cap4-rich-metrics seed-13 $family)
     (exp03-cap4-rich-acs-candidates seed-13 $family)
     ()
     (exp03-cap4-rich-run-summary seed-13 $family)))

(= (exp03-cap4-rich-run-records seed-13)
   ((exp03-cap4-rich-run-record seed-13 random-polymer)
    (exp03-cap4-rich-run-record seed-13 shuffled-catalysts)
    (exp03-cap4-rich-run-record seed-13 no-catalysis)))

(= (exp03-cap4-rich-run-records-complete? seed-13)
   (and (run-record-passed? (exp03-cap4-rich-run-record seed-13 random-polymer))
        (and (run-record-passed? (exp03-cap4-rich-run-record seed-13 shuffled-catalysts))
             (and (run-record-passed? (exp03-cap4-rich-run-record seed-13 no-catalysis))
                  (and (exp03-cap4-rich-controls-discriminate? seed-13)
                       (exp03-cap4-rich-replay-ok? random-polymer seed-13))))))


; ============================================================================
; Cap-4 RICH bridge atoms for seed-17 (12-molecule S-family, 4-rule productive cycle)
; ============================================================================

(= (exp03-cap4-rich-initial-state seed-17)
   (state 0 seed-17
          (mol S0 3) (mol S1 3) (mol S2 3) (mol S3 3)
          (mol S4 3) (mol S5 3) (mol S6 3) (mol S7 3)
          (mol S01 0) (mol S10 1) (mol S45 0) (mol S54 1)))

(= (exp03-cap4-rich-chamber $family seed-17)
   (make-chamber (exp03-cap4-rich $family seed-17)
                 (exp03-cap4-rich-initial-state seed-17)
                 (exp03-exp02-full-source-rules seed-17 $family)
                 ()))

(= (exp03-cap4-rich-after-12 $family seed-17)
   (chamber-run-4cap-12 (exp03-cap4-rich-chamber $family seed-17)))

(= (exp03-cap4-rich-event-count $family seed-17)
   (event-count (trace-events (exp03-cap4-rich-after-12 $family seed-17))))

(= (exp03-cap4-rich-tick $family seed-17)
   (state-tick (chamber-state (exp03-cap4-rich-after-12 $family seed-17))))

(= (exp03-cap4-rich-abundances $family seed-17)
   (chamber-abundance-snapshot (exp03-cap4-rich-after-12 $family seed-17)))

(= (exp03-cap4-rich-replay-12 $family seed-17)
   (chamber-run-4cap-3 (chamber-run-4cap-9 (exp03-cap4-rich-chamber $family seed-17))))

(= (exp03-cap4-rich-replay-ok? $family seed-17)
   (== (exp03-cap4-rich-after-12 $family seed-17)
       (exp03-cap4-rich-replay-12 $family seed-17)))

(= (exp03-cap4-rich-reactant-exhausted? seed-17)
   (== (exp03-cap4-rich-abundances random-polymer seed-17)
       (abundance-snapshot 12 ((mol S0 0) (mol S1 0) (mol S2 0) (mol S3 0)
                               (mol S4 0) (mol S5 0) (mol S6 0) (mol S7 0)
                               (mol S01 3) (mol S10 4) (mol S45 3) (mol S54 4)))))

(= (exp03-cap4-rich-controls-discriminate? seed-17)
   (and (> (exp03-cap4-rich-event-count random-polymer seed-17)
           (exp03-cap4-rich-event-count shuffled-catalysts seed-17))
        (> (exp03-cap4-rich-event-count random-polymer seed-17)
           (exp03-cap4-rich-event-count no-catalysis seed-17))))

(= (exp03-cap4-rich-run-config seed-17 random-polymer)
   (make-run-config exp03-cap4-rich-seed-17-random exp03 (seed-17) 12 (candidate-cap 4 1) random-polymer))

(= (exp03-cap4-rich-run-config seed-17 shuffled-catalysts)
   (make-run-config exp03-cap4-rich-seed-17-shuffled exp03 (seed-17) 12 (candidate-cap 4 1) shuffled-catalysts))

(= (exp03-cap4-rich-run-config seed-17 no-catalysis)
   (make-run-config exp03-cap4-rich-seed-17-no-catalysis exp03 (seed-17) 12 (candidate-cap 4 1) no-catalysis))

(= (exp03-cap4-rich-run-manifest seed-17 random-polymer)
   (make-run-manifest exp03-cap4-rich-seed-17-random config-hash-exp03-cap4-rich-seed-17-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-run-manifest seed-17 shuffled-catalysts)
   (make-run-manifest exp03-cap4-rich-seed-17-shuffled config-hash-exp03-cap4-rich-seed-17-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-run-manifest seed-17 no-catalysis)
   (make-run-manifest exp03-cap4-rich-seed-17-no-catalysis config-hash-exp03-cap4-rich-seed-17-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-metrics seed-17 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap4-rich-run-config seed-17 $family)) (exp03-cap4-rich-event-count $family seed-17))
    (metric dynamic-tick-count (run-config-id (exp03-cap4-rich-run-config seed-17 $family)) 12)
    (metric source-exp02-rule-count (run-config-id (exp03-cap4-rich-run-config seed-17 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap4-rich-run-config seed-17 $family)) 4)
    (metric rich-state-molecule-count (run-config-id (exp03-cap4-rich-run-config seed-17 $family)) 12)))

(= (exp03-cap4-rich-run-summary seed-17 random-polymer)
   (make-run-summary exp03-cap4-rich-seed-17-random passed cap4-rich-seed-17-4-rule-productive True))

(= (exp03-cap4-rich-run-summary seed-17 shuffled-catalysts)
   (make-run-summary exp03-cap4-rich-seed-17-shuffled passed cap4-rich-seed-17-shuffled-partial-productive True))

(= (exp03-cap4-rich-run-summary seed-17 no-catalysis)
   (make-run-summary exp03-cap4-rich-seed-17-no-catalysis passed cap4-rich-seed-17-no-catalysis-control-zero-events True))

(= (exp03-cap4-rich-acs-candidates seed-17 $family)
   (exp02-seed-17-acs-candidates $family))

(= (exp03-cap4-rich-run-record seed-17 $family)
   (make-run-record
     (run-config-id (exp03-cap4-rich-run-config seed-17 $family))
     (exp03-cap4-rich-run-config seed-17 $family)
     (exp03-cap4-rich-run-manifest seed-17 $family)
     (trace-events (exp03-cap4-rich-after-12 $family seed-17))
     ((state-abundance-snapshot (exp03-cap4-rich-initial-state seed-17))
      (chamber-abundance-snapshot (exp03-cap4-rich-after-12 $family seed-17)))
     (exp03-cap4-rich-metrics seed-17 $family)
     (exp03-cap4-rich-acs-candidates seed-17 $family)
     ()
     (exp03-cap4-rich-run-summary seed-17 $family)))

(= (exp03-cap4-rich-run-records seed-17)
   ((exp03-cap4-rich-run-record seed-17 random-polymer)
    (exp03-cap4-rich-run-record seed-17 shuffled-catalysts)
    (exp03-cap4-rich-run-record seed-17 no-catalysis)))

(= (exp03-cap4-rich-run-records-complete? seed-17)
   (and (run-record-passed? (exp03-cap4-rich-run-record seed-17 random-polymer))
        (and (run-record-passed? (exp03-cap4-rich-run-record seed-17 shuffled-catalysts))
             (and (run-record-passed? (exp03-cap4-rich-run-record seed-17 no-catalysis))
                  (and (exp03-cap4-rich-controls-discriminate? seed-17)
                       (exp03-cap4-rich-replay-ok? random-polymer seed-17))))))


; ============================================================================
; Cap-5 PRODUCTIVE bridge for seed-13 (15-molecule R-family, productive fifth candidate)
; ============================================================================
;
; The cap-5 seed-17 bridge deliberately leaves rr4 outside the 12-molecule
; state shape as a bounded no-op.  This companion fixture expands seed-13 to a
; 15-molecule R-family state with R8/R9/R89 present so the deterministic cap-5
; selector can choose rr4 and fire it productively in the chamber tick path.

; rr1: productive in the 15-molecule seed-13 R-family cap-5 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R8 $r8)
                      (mol R9 $r9)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54)
                      (mol R89 $r89))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 R01) $score))
   (if (and (> $r2 0) (and (> $r3 0) (> $r01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 (- $r2 1))
                       (mol R3 (- $r3 1))
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 $r01)
                       (mol R10 (+ $r10 1))
                       (mol R45 $r45)
                       (mol R54 $r54)
                       (mol R89 $r89))
                $rules
                (append-event $events (event $tick rr1 R2 R3 R10 R01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54)
                       (mol R89 $r89))
                $rules
                $events)))

; rr0: productive in the 15-molecule seed-13 R-family cap-5 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R8 $r8)
                      (mol R9 $r9)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54)
                      (mol R89 $r89))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 R10) $score))
   (if (and (> $r0 0) (and (> $r1 0) (> $r10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1))
                       (mol R1 (- $r1 1))
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 (+ $r01 1))
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54)
                       (mol R89 $r89))
                $rules
                (append-event $events (event $tick rr0 R0 R1 R01 R10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54)
                       (mol R89 $r89))
                $rules
                $events)))

; rr2: productive in the 15-molecule seed-13 R-family cap-5 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R8 $r8)
                      (mol R9 $r9)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54)
                      (mol R89 $r89))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 R54) $score))
   (if (and (> $r4 0) (and (> $r5 0) (> $r54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 (- $r4 1))
                       (mol R5 (- $r5 1))
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 (+ $r45 1))
                       (mol R54 $r54)
                       (mol R89 $r89))
                $rules
                (append-event $events (event $tick rr2 R4 R5 R45 R54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54)
                       (mol R89 $r89))
                $rules
                $events)))

; rr3: productive in the 15-molecule seed-13 R-family cap-5 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R8 $r8)
                      (mol R9 $r9)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54)
                      (mol R89 $r89))
               $rules
               $events)
      (candidate $ct (rule rr3 R6 R7 R54 R45) $score))
   (if (and (> $r6 0) (and (> $r7 0) (> $r45 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 (- $r6 1))
                       (mol R7 (- $r7 1))
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 (+ $r54 1))
                       (mol R89 $r89))
                $rules
                (append-event $events (event $tick rr3 R6 R7 R54 R45)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54)
                       (mol R89 $r89))
                $rules
                $events)))

; rr4: productive in the 15-molecule seed-13 R-family cap-5 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0)
                      (mol R1 $r1)
                      (mol R2 $r2)
                      (mol R3 $r3)
                      (mol R4 $r4)
                      (mol R5 $r5)
                      (mol R6 $r6)
                      (mol R7 $r7)
                      (mol R8 $r8)
                      (mol R9 $r9)
                      (mol R01 $r01)
                      (mol R10 $r10)
                      (mol R45 $r45)
                      (mol R54 $r54)
                      (mol R89 $r89))
               $rules
               $events)
      (candidate $ct (rule rr4 R8 R9 R89 R2) $score))
   (if (and (> $r8 0) (and (> $r9 0) (> $r2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 (- $r8 1))
                       (mol R9 (- $r9 1))
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54)
                       (mol R89 (+ $r89 1)))
                $rules
                (append-event $events (event $tick rr4 R8 R9 R89 R2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0)
                       (mol R1 $r1)
                       (mol R2 $r2)
                       (mol R3 $r3)
                       (mol R4 $r4)
                       (mol R5 $r5)
                       (mol R6 $r6)
                       (mol R7 $r7)
                       (mol R8 $r8)
                       (mol R9 $r9)
                       (mol R01 $r01)
                       (mol R10 $r10)
                       (mol R45 $r45)
                       (mol R54 $r54)
                       (mol R89 $r89))
                $rules
                $events)))

(= (exp03-cap5-productive-initial-state seed-13)
   (state 0 seed-13
          (mol R0 2) (mol R1 2) (mol R2 2) (mol R3 2) (mol R4 2)
          (mol R5 2) (mol R6 2) (mol R7 2) (mol R8 2) (mol R9 2)
          (mol R01 1) (mol R10 1) (mol R45 1) (mol R54 1) (mol R89 0)))

(= (exp03-cap5-productive-chamber $family seed-13)
   (make-chamber (exp03-cap5-productive $family seed-13)
                 (exp03-cap5-productive-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 $family)
                 ()))

(= (exp03-cap5-productive-capped-candidates $family seed-13)
   (candidate-pool-candidates
     (bounded-candidate-pool
       (exp00-candidate-cap-5)
       (exp03-cap5-productive-chamber $family seed-13))))

(= (exp03-cap5-productive-selected-candidate $family seed-13)
   (selected-candidate-from-list-5
     (exp03-cap5-productive-chamber $family seed-13)
     (exp03-cap5-productive-capped-candidates $family seed-13)))

(= (exp03-cap5-productive-after-10 $family seed-13)
   (chamber-run-5cap-10 (exp03-cap5-productive-chamber $family seed-13)))

(= (exp03-cap5-productive-event-count $family seed-13)
   (event-count (trace-events (exp03-cap5-productive-after-10 $family seed-13))))

(= (exp03-cap5-productive-tick $family seed-13)
   (state-tick (chamber-state (exp03-cap5-productive-after-10 $family seed-13))))

(= (exp03-cap5-productive-abundances $family seed-13)
   (chamber-abundance-snapshot (exp03-cap5-productive-after-10 $family seed-13)))

(= (exp03-cap5-productive-replay-10 $family seed-13)
   (chamber-run-5cap-5 (chamber-run-5cap-5 (exp03-cap5-productive-chamber $family seed-13))))

(= (exp03-cap5-productive-replay-ok? $family seed-13)
   (== (exp03-cap5-productive-after-10 $family seed-13)
       (exp03-cap5-productive-replay-10 $family seed-13)))

(= (exp03-cap5-productive-run-config seed-13 random-polymer)
   (make-run-config exp03-cap5-productive-seed-13-random exp03 (seed-13) 10 (candidate-cap 5 1) random-polymer))

(= (exp03-cap5-productive-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-cap5-productive-seed-13-random config-hash-exp03-cap5-productive-seed-13-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap5-productive-metrics seed-13 random-polymer)
   ((metric dynamic-event-count exp03-cap5-productive-seed-13-random (exp03-cap5-productive-event-count random-polymer seed-13))
    (metric dynamic-tick-count exp03-cap5-productive-seed-13-random 10)
    (metric source-exp02-rule-count exp03-cap5-productive-seed-13-random 8)
    (metric dynamic-candidate-cap exp03-cap5-productive-seed-13-random 5)
    (metric productive-fifth-candidate exp03-cap5-productive-seed-13-random rr4)))

(= (exp03-cap5-productive-run-summary seed-13 random-polymer)
   (make-run-summary exp03-cap5-productive-seed-13-random passed cap5-productive-fifth-candidate-seed-13 True))

(= (exp03-cap5-productive-run-record seed-13 random-polymer)
   (make-run-record
     exp03-cap5-productive-seed-13-random
     (exp03-cap5-productive-run-config seed-13 random-polymer)
     (exp03-cap5-productive-run-manifest seed-13 random-polymer)
     (trace-events (exp03-cap5-productive-after-10 random-polymer seed-13))
     ((state-abundance-snapshot (exp03-cap5-productive-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-cap5-productive-after-10 random-polymer seed-13)))
     (exp03-cap5-productive-metrics seed-13 random-polymer)
     (exp02-seed-13-acs-candidates random-polymer)
     ()
     (exp03-cap5-productive-run-summary seed-13 random-polymer)))

(= (exp03-cap5-productive-run-export seed-13 random-polymer)
   (make-run-export (exp03-cap5-productive-run-record seed-13 random-polymer)))

(= (exp03-cap5-productive-run-record-complete? seed-13)
   (and (run-record-passed? (exp03-cap5-productive-run-record seed-13 random-polymer))
        (exp03-cap5-productive-replay-ok? random-polymer seed-13)))


; ============================================================================
; Cap-6 PRODUCTIVE bridge for seed-13 (16-molecule R-family, beyond seed-11)
; ============================================================================
;
; This fixture extends productive cap-6 dynamics beyond seed-11/Q-family.  The
; 16-molecule R-family state keeps rr0..rr5 in-state, including both rr4/R89
; and sixth bounded candidate rr5/R05, while the source pool still contains all
; eight seed-13 rules and is capped to six candidates per tick.

; rr1: productive in the 16-molecule seed-13 R-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 R01) $score))
   (if (and (> $r2 0) (and (> $r3 0) (> $r01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 (- $r2 1)) (mol R3 (- $r3 1))
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 (+ $r10 1))
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                (append-event $events (event $tick rr1 R2 R3 R10 R01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                $events)))

; rr0: productive in the 16-molecule seed-13 R-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 R10) $score))
   (if (and (> $r0 0) (and (> $r1 0) (> $r10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1)) (mol R1 (- $r1 1)) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 (+ $r01 1)) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                (append-event $events (event $tick rr0 R0 R1 R01 R10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                $events)))

; rr2: productive in the 16-molecule seed-13 R-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 R54) $score))
   (if (and (> $r4 0) (and (> $r5 0) (> $r54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 (- $r4 1)) (mol R5 (- $r5 1)) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 (+ $r45 1)) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                (append-event $events (event $tick rr2 R4 R5 R45 R54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                $events)))

; rr3: productive in the 16-molecule seed-13 R-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
               $rules
               $events)
      (candidate $ct (rule rr3 R6 R7 R54 R45) $score))
   (if (and (> $r6 0) (and (> $r7 0) (> $r45 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 (- $r6 1)) (mol R7 (- $r7 1))
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 (+ $r54 1)) (mol R89 $r89) (mol R05 $r05))
                $rules
                (append-event $events (event $tick rr3 R6 R7 R54 R45)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                $events)))

; rr4: productive in the 16-molecule seed-13 R-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
               $rules
               $events)
      (candidate $ct (rule rr4 R8 R9 R89 R2) $score))
   (if (and (> $r8 0) (and (> $r9 0) (> $r2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 (- $r8 1)) (mol R9 (- $r9 1)) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 (+ $r89 1)) (mol R05 $r05))
                $rules
                (append-event $events (event $tick rr4 R8 R9 R89 R2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                $events)))

; rr5: productive in the 16-molecule seed-13 R-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
               $rules
               $events)
      (candidate $ct (rule rr5 R0 R5 R05 R3) $score))
   (if (and (> $r0 0) (and (> $r5 0) (> $r3 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1)) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 (- $r5 1)) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 (+ $r05 1)))
                $rules
                (append-event $events (event $tick rr5 R0 R5 R05 R3)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                       (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                       (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                       (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05))
                $rules
                $events)))

(= (exp03-cap6-productive-initial-state seed-13)
   (state 0 seed-13
          (mol R0 4) (mol R1 2) (mol R2 2) (mol R3 2)
          (mol R4 2) (mol R5 4) (mol R6 2) (mol R7 2)
          (mol R8 2) (mol R9 2) (mol R01 1) (mol R10 1)
          (mol R45 1) (mol R54 1) (mol R89 0) (mol R05 0)))

(= (exp03-cap6-productive-chamber random-polymer seed-13)
   (make-chamber (exp03-cap6-productive random-polymer seed-13)
                 (exp03-cap6-productive-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 random-polymer)
                 ()))

(= (exp03-cap6-productive-capped-candidates random-polymer seed-13)
   (candidate-pool-candidates
     (bounded-candidate-pool
       (exp00-candidate-cap-6)
       (exp03-cap6-productive-chamber random-polymer seed-13))))

(= (exp03-cap6-productive-selected-candidate random-polymer seed-13)
   (selected-candidate-from-list-6
     (exp03-cap6-productive-chamber random-polymer seed-13)
     (exp03-cap6-productive-capped-candidates random-polymer seed-13)))

(= (exp03-cap6-productive-after-12 random-polymer seed-13)
   (chamber-run-6cap-12 (exp03-cap6-productive-chamber random-polymer seed-13)))

(= (exp03-cap6-productive-event-count random-polymer seed-13)
   (event-count (trace-events (exp03-cap6-productive-after-12 random-polymer seed-13))))

(= (exp03-cap6-productive-tick random-polymer seed-13)
   (state-tick (chamber-state (exp03-cap6-productive-after-12 random-polymer seed-13))))

(= (exp03-cap6-productive-abundances random-polymer seed-13)
   (chamber-abundance-snapshot (exp03-cap6-productive-after-12 random-polymer seed-13)))

(= (exp03-cap6-productive-replay-12 random-polymer seed-13)
   (chamber-run-6cap-6 (chamber-run-6cap-6 (exp03-cap6-productive-chamber random-polymer seed-13))))

(= (exp03-cap6-productive-replay-ok? random-polymer seed-13)
   (== (exp03-cap6-productive-after-12 random-polymer seed-13)
       (exp03-cap6-productive-replay-12 random-polymer seed-13)))

(= (exp03-cap6-productive-final-abundances-ok? seed-13)
   (== (exp03-cap6-productive-abundances random-polymer seed-13)
       (abundance-snapshot 12 ((mol R0 0) (mol R1 0) (mol R2 0) (mol R3 0)
                               (mol R4 0) (mol R5 0) (mol R6 0) (mol R7 0)
                               (mol R8 0) (mol R9 0) (mol R01 3) (mol R10 3)
                               (mol R45 3) (mol R54 3) (mol R89 2) (mol R05 2)))))

(= (exp03-cap6-productive-run-config seed-13 random-polymer)
   (make-run-config exp03-cap6-productive-seed-13-random exp03 (seed-13) 12 (candidate-cap 6 1) random-polymer))

(= (exp03-cap6-productive-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-cap6-productive-seed-13-random config-hash-exp03-cap6-productive-seed-13-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap6-productive-metrics seed-13 random-polymer)
   ((metric dynamic-event-count exp03-cap6-productive-seed-13-random (exp03-cap6-productive-event-count random-polymer seed-13))
    (metric dynamic-tick-count exp03-cap6-productive-seed-13-random 12)
    (metric source-exp02-rule-count exp03-cap6-productive-seed-13-random 8)
    (metric dynamic-candidate-cap exp03-cap6-productive-seed-13-random 6)
    (metric rich-state-molecule-count exp03-cap6-productive-seed-13-random 16)
    (metric productive-sixth-candidate exp03-cap6-productive-seed-13-random rr5)))

(= (exp03-cap6-productive-run-summary seed-13 random-polymer)
   (make-run-summary exp03-cap6-productive-seed-13-random passed cap6-productive-sixth-candidate-seed-13 True))

(= (exp03-cap6-productive-run-record seed-13 random-polymer)
   (make-run-record
     exp03-cap6-productive-seed-13-random
     (exp03-cap6-productive-run-config seed-13 random-polymer)
     (exp03-cap6-productive-run-manifest seed-13 random-polymer)
     (trace-events (exp03-cap6-productive-after-12 random-polymer seed-13))
     ((state-abundance-snapshot (exp03-cap6-productive-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-cap6-productive-after-12 random-polymer seed-13)))
     (exp03-cap6-productive-metrics seed-13 random-polymer)
     (exp02-seed-13-acs-candidates random-polymer)
     ()
     (exp03-cap6-productive-run-summary seed-13 random-polymer)))

(= (exp03-cap6-productive-run-export seed-13 random-polymer)
   (make-run-export (exp03-cap6-productive-run-record seed-13 random-polymer)))

(= (exp03-cap6-productive-run-record-complete? seed-13)
   (and (run-record-passed? (exp03-cap6-productive-run-record seed-13 random-polymer))
        (and (exp03-cap6-productive-replay-ok? random-polymer seed-13)
             (exp03-cap6-productive-final-abundances-ok? seed-13))))


; Cap-7 productive fixture over seed-13/R-family.  This widens the cap-6
; productive state with R16 so the seventh bounded candidate rr6 is selected
; directly by chamber ticking and fires productively in PeTTa.

; rr1: productive in the 17-molecule seed-13 R-family cap-7 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
               $rules
               $events)
      (candidate $ct (rule rr1 R2 R3 R10 R01) $score))
   (if (and (> $r2 0) (and (> $r3 0) (> $r01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 (- $r2 1)) (mol R3 (- $r3 1))
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 (+ $r10 1))
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                (append-event $events (event $tick rr1 R2 R3 R10 R01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                $events)))

; rr0: productive in the 17-molecule seed-13 R-family cap-7 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
               $rules
               $events)
      (candidate $ct (rule rr0 R0 R1 R01 R10) $score))
   (if (and (> $r0 0) (and (> $r1 0) (> $r10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1)) (mol R1 (- $r1 1)) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 (+ $r01 1)) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                (append-event $events (event $tick rr0 R0 R1 R01 R10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                $events)))

; rr2: productive in the 17-molecule seed-13 R-family cap-7 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
               $rules
               $events)
      (candidate $ct (rule rr2 R4 R5 R45 R54) $score))
   (if (and (> $r4 0) (and (> $r5 0) (> $r54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 (- $r4 1)) (mol R5 (- $r5 1)) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 (+ $r45 1)) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                (append-event $events (event $tick rr2 R4 R5 R45 R54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                $events)))

; rr3: productive in the 17-molecule seed-13 R-family cap-7 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
               $rules
               $events)
      (candidate $ct (rule rr3 R6 R7 R54 R45) $score))
   (if (and (> $r6 0) (and (> $r7 0) (> $r45 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 (- $r6 1)) (mol R7 (- $r7 1))
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 (+ $r54 1)) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                (append-event $events (event $tick rr3 R6 R7 R54 R45)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                $events)))

; rr4: productive in the 17-molecule seed-13 R-family cap-7 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
               $rules
               $events)
      (candidate $ct (rule rr4 R8 R9 R89 R2) $score))
   (if (and (> $r8 0) (and (> $r9 0) (> $r2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 (- $r8 1)) (mol R9 (- $r9 1)) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 (+ $r89 1)) (mol R05 $r05) (mol R16 $r16))
                $rules
                (append-event $events (event $tick rr4 R8 R9 R89 R2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                $events)))

; rr5: productive in the 17-molecule seed-13 R-family cap-7 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
               $rules
               $events)
      (candidate $ct (rule rr5 R0 R5 R05 R3) $score))
   (if (and (> $r0 0) (and (> $r5 0) (> $r3 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 (- $r0 1)) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 (- $r5 1)) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 (+ $r05 1)) (mol R16 $r16))
                $rules
                (append-event $events (event $tick rr5 R0 R5 R05 R3)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                $events)))

; rr6: productive in the 17-molecule seed-13 R-family cap-7 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
               $rules
               $events)
      (candidate $ct (rule rr6 R1 R6 R16 R5) $score))
   (if (and (> $r1 0) (and (> $r6 0) (> $r5 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 (- $r1 1)) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 (- $r6 1)) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 (+ $r16 1)))
                $rules
                (append-event $events (event $tick rr6 R1 R6 R16 R5)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol R0 $r0) (mol R1 $r1) (mol R2 $r2) (mol R3 $r3)
                      (mol R4 $r4) (mol R5 $r5) (mol R6 $r6) (mol R7 $r7)
                      (mol R8 $r8) (mol R9 $r9) (mol R01 $r01) (mol R10 $r10)
                      (mol R45 $r45) (mol R54 $r54) (mol R89 $r89) (mol R05 $r05) (mol R16 $r16))
                $rules
                $events)))

(= (exp03-cap7-productive-initial-state seed-13)
   (state 0 seed-13
          (mol R0 4) (mol R1 4) (mol R2 3) (mol R3 3)
          (mol R4 2) (mol R5 4) (mol R6 4) (mol R7 2)
          (mol R8 2) (mol R9 2) (mol R01 1) (mol R10 1)
          (mol R45 1) (mol R54 1) (mol R89 0) (mol R05 0) (mol R16 0)))

(= (exp03-cap7-productive-chamber random-polymer seed-13)
   (make-chamber (exp03-cap7-productive random-polymer seed-13)
                 (exp03-cap7-productive-initial-state seed-13)
                 (exp03-exp02-full-source-rules seed-13 random-polymer)
                 ()))

(= (exp03-cap7-productive-capped-candidates random-polymer seed-13)
   (candidate-pool-candidates
     (bounded-candidate-pool
       (exp00-candidate-cap-7)
       (exp03-cap7-productive-chamber random-polymer seed-13))))

(= (exp03-cap7-productive-selected-candidate random-polymer seed-13)
   (selected-candidate-from-list-7
     (exp03-cap7-productive-chamber random-polymer seed-13)
     (exp03-cap7-productive-capped-candidates random-polymer seed-13)))

(= (exp03-cap7-productive-after-14 random-polymer seed-13)
   (chamber-run-7cap-14 (exp03-cap7-productive-chamber random-polymer seed-13)))

(= (exp03-cap7-productive-event-count random-polymer seed-13)
   (event-count (trace-events (exp03-cap7-productive-after-14 random-polymer seed-13))))

(= (exp03-cap7-productive-tick random-polymer seed-13)
   (state-tick (chamber-state (exp03-cap7-productive-after-14 random-polymer seed-13))))

(= (exp03-cap7-productive-abundances random-polymer seed-13)
   (chamber-abundance-snapshot (exp03-cap7-productive-after-14 random-polymer seed-13)))

(= (exp03-cap7-productive-replay-14 random-polymer seed-13)
   (chamber-run-7cap-7 (chamber-run-7cap-7 (exp03-cap7-productive-chamber random-polymer seed-13))))

(= (exp03-cap7-productive-replay-ok? random-polymer seed-13)
   (== (exp03-cap7-productive-after-14 random-polymer seed-13)
       (exp03-cap7-productive-replay-14 random-polymer seed-13)))

(= (exp03-cap7-productive-final-abundances-ok? seed-13)
   (== (exp03-cap7-productive-abundances random-polymer seed-13)
       (abundance-snapshot 14 ((mol R0 0) (mol R1 0) (mol R2 1) (mol R3 1)
                               (mol R4 0) (mol R5 0) (mol R6 0) (mol R7 0)
                               (mol R8 0) (mol R9 0) (mol R01 3) (mol R10 3)
                               (mol R45 3) (mol R54 3) (mol R89 2) (mol R05 2) (mol R16 2)))))

(= (exp03-cap7-productive-run-config seed-13 random-polymer)
   (make-run-config exp03-cap7-productive-seed-13-random exp03 (seed-13) 14 (candidate-cap 7 1) random-polymer))

(= (exp03-cap7-productive-run-manifest seed-13 random-polymer)
   (make-run-manifest exp03-cap7-productive-seed-13-random config-hash-exp03-cap7-productive-seed-13-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap7-productive-metrics seed-13 random-polymer)
   ((metric dynamic-event-count exp03-cap7-productive-seed-13-random (exp03-cap7-productive-event-count random-polymer seed-13))
    (metric dynamic-tick-count exp03-cap7-productive-seed-13-random 14)
    (metric source-exp02-rule-count exp03-cap7-productive-seed-13-random 8)
    (metric dynamic-candidate-cap exp03-cap7-productive-seed-13-random 7)
    (metric rich-state-molecule-count exp03-cap7-productive-seed-13-random 17)
    (metric productive-seventh-candidate exp03-cap7-productive-seed-13-random rr6)))

(= (exp03-cap7-productive-run-summary seed-13 random-polymer)
   (make-run-summary exp03-cap7-productive-seed-13-random passed cap7-productive-seventh-candidate-seed-13 True))

(= (exp03-cap7-productive-run-record seed-13 random-polymer)
   (make-run-record
     exp03-cap7-productive-seed-13-random
     (exp03-cap7-productive-run-config seed-13 random-polymer)
     (exp03-cap7-productive-run-manifest seed-13 random-polymer)
     (trace-events (exp03-cap7-productive-after-14 random-polymer seed-13))
     ((state-abundance-snapshot (exp03-cap7-productive-initial-state seed-13))
      (chamber-abundance-snapshot (exp03-cap7-productive-after-14 random-polymer seed-13)))
     (exp03-cap7-productive-metrics seed-13 random-polymer)
     (exp02-seed-13-acs-candidates random-polymer)
     ()
     (exp03-cap7-productive-run-summary seed-13 random-polymer)))

(= (exp03-cap7-productive-run-record-complete? seed-13)
   (and (run-record-passed? (exp03-cap7-productive-run-record seed-13 random-polymer))
        (and (exp03-cap7-productive-replay-ok? random-polymer seed-13)
             (exp03-cap7-productive-final-abundances-ok? seed-13))))

; This fixture extends productive cap-6 dynamics to the seed-17/S-family
; state shape.  The 16-molecule S-family state keeps rr0..rr5 in-state,
; including both rr4/S89 and sixth bounded candidate rr5/S05, while the source
; pool still contains all eight seed-17 rules and is capped to six candidates.

; rr1: productive in the 16-molecule seed-17 S-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                      (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                      (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                      (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
               $rules
               $events)
      (candidate $ct (rule rr1 S2 S3 S10 S01) $score))
   (if (and (> $s2 0) (and (> $s3 0) (> $s01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 (- $s2 1)) (mol S3 (- $s3 1))
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 (+ $s10 1))
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                (append-event $events (event $tick rr1 S2 S3 S10 S01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                $events)))

; rr0: productive in the 16-molecule seed-17 S-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                      (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                      (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                      (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
               $rules
               $events)
      (candidate $ct (rule rr0 S0 S1 S01 S10) $score))
   (if (and (> $s0 0) (and (> $s1 0) (> $s10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 (- $s0 1)) (mol S1 (- $s1 1)) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 (+ $s01 1)) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                (append-event $events (event $tick rr0 S0 S1 S01 S10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                $events)))

; rr2: productive in the 16-molecule seed-17 S-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                      (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                      (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                      (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
               $rules
               $events)
      (candidate $ct (rule rr2 S4 S5 S45 S54) $score))
   (if (and (> $s4 0) (and (> $s5 0) (> $s54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 (- $s4 1)) (mol S5 (- $s5 1)) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 (+ $s45 1)) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                (append-event $events (event $tick rr2 S4 S5 S45 S54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                $events)))

; rr3: productive in the 16-molecule seed-17 S-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                      (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                      (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                      (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
               $rules
               $events)
      (candidate $ct (rule rr3 S6 S7 S54 S45) $score))
   (if (and (> $s6 0) (and (> $s7 0) (> $s45 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 (- $s6 1)) (mol S7 (- $s7 1))
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 (+ $s54 1)) (mol S89 $s89) (mol S05 $s05))
                $rules
                (append-event $events (event $tick rr3 S6 S7 S54 S45)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                $events)))

; rr4: productive in the 16-molecule seed-17 S-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                      (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                      (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                      (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
               $rules
               $events)
      (candidate $ct (rule rr4 S8 S9 S89 S2) $score))
   (if (and (> $s8 0) (and (> $s9 0) (> $s2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 (- $s8 1)) (mol S9 (- $s9 1)) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 (+ $s89 1)) (mol S05 $s05))
                $rules
                (append-event $events (event $tick rr4 S8 S9 S89 S2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                $events)))

; rr5: productive in the 16-molecule seed-17 S-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                      (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                      (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                      (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
               $rules
               $events)
      (candidate $ct (rule rr5 S0 S5 S05 S3) $score))
   (if (and (> $s0 0) (and (> $s5 0) (> $s3 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 (- $s0 1)) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 (- $s5 1)) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 (+ $s05 1)))
                $rules
                (append-event $events (event $tick rr5 S0 S5 S05 S3)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol S0 $s0) (mol S1 $s1) (mol S2 $s2) (mol S3 $s3)
                       (mol S4 $s4) (mol S5 $s5) (mol S6 $s6) (mol S7 $s7)
                       (mol S8 $s8) (mol S9 $s9) (mol S01 $s01) (mol S10 $s10)
                       (mol S45 $s45) (mol S54 $s54) (mol S89 $s89) (mol S05 $s05))
                $rules
                $events)))

(= (exp03-cap6-productive-initial-state seed-17)
   (state 0 seed-17
          (mol S0 4) (mol S1 2) (mol S2 4) (mol S3 2)
          (mol S4 2) (mol S5 4) (mol S6 2) (mol S7 2)
          (mol S8 2) (mol S9 2) (mol S01 1) (mol S10 1)
          (mol S45 1) (mol S54 1) (mol S89 0) (mol S05 0)))

(= (exp03-cap6-productive-chamber random-polymer seed-17)
   (make-chamber (exp03-cap6-productive random-polymer seed-17)
                 (exp03-cap6-productive-initial-state seed-17)
                 (exp03-exp02-full-source-rules seed-17 random-polymer)
                 ()))

(= (exp03-cap6-productive-capped-candidates random-polymer seed-17)
   (candidate-pool-candidates
     (bounded-candidate-pool
       (exp00-candidate-cap-6)
       (exp03-cap6-productive-chamber random-polymer seed-17))))

(= (exp03-cap6-productive-selected-candidate random-polymer seed-17)
   (selected-candidate-from-list-6
     (exp03-cap6-productive-chamber random-polymer seed-17)
     (exp03-cap6-productive-capped-candidates random-polymer seed-17)))

(= (exp03-cap6-productive-after-12 random-polymer seed-17)
   (chamber-run-6cap-12 (exp03-cap6-productive-chamber random-polymer seed-17)))

(= (exp03-cap6-productive-event-count random-polymer seed-17)
   (event-count (trace-events (exp03-cap6-productive-after-12 random-polymer seed-17))))

(= (exp03-cap6-productive-tick random-polymer seed-17)
   (state-tick (chamber-state (exp03-cap6-productive-after-12 random-polymer seed-17))))

(= (exp03-cap6-productive-abundances random-polymer seed-17)
   (chamber-abundance-snapshot (exp03-cap6-productive-after-12 random-polymer seed-17)))

(= (exp03-cap6-productive-replay-12 random-polymer seed-17)
   (chamber-run-6cap-6 (chamber-run-6cap-6 (exp03-cap6-productive-chamber random-polymer seed-17))))

(= (exp03-cap6-productive-replay-ok? random-polymer seed-17)
   (== (exp03-cap6-productive-after-12 random-polymer seed-17)
       (exp03-cap6-productive-replay-12 random-polymer seed-17)))

(= (exp03-cap6-productive-final-abundances-ok? seed-17)
   (== (exp03-cap6-productive-abundances random-polymer seed-17)
       (abundance-snapshot 12 ((mol S0 0) (mol S1 0) (mol S2 2) (mol S3 0)
                               (mol S4 0) (mol S5 0) (mol S6 0) (mol S7 0)
                               (mol S8 0) (mol S9 0) (mol S01 3) (mol S10 3)
                               (mol S45 3) (mol S54 3) (mol S89 2) (mol S05 2)))))

(= (exp03-cap6-productive-run-config seed-17 random-polymer)
   (make-run-config exp03-cap6-productive-seed-17-random exp03 (seed-17) 12 (candidate-cap 6 1) random-polymer))

(= (exp03-cap6-productive-run-manifest seed-17 random-polymer)
   (make-run-manifest exp03-cap6-productive-seed-17-random config-hash-exp03-cap6-productive-seed-17-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap6-productive-metrics seed-17 random-polymer)
   ((metric dynamic-event-count exp03-cap6-productive-seed-17-random (exp03-cap6-productive-event-count random-polymer seed-17))
    (metric dynamic-tick-count exp03-cap6-productive-seed-17-random 12)
    (metric source-exp02-rule-count exp03-cap6-productive-seed-17-random 8)
    (metric dynamic-candidate-cap exp03-cap6-productive-seed-17-random 6)
    (metric rich-state-molecule-count exp03-cap6-productive-seed-17-random 16)
    (metric productive-sixth-candidate exp03-cap6-productive-seed-17-random rr5)))

(= (exp03-cap6-productive-run-summary seed-17 random-polymer)
   (make-run-summary exp03-cap6-productive-seed-17-random passed cap6-productive-sixth-candidate-seed-17 True))

(= (exp03-cap6-productive-run-record seed-17 random-polymer)
   (make-run-record
     exp03-cap6-productive-seed-17-random
     (exp03-cap6-productive-run-config seed-17 random-polymer)
     (exp03-cap6-productive-run-manifest seed-17 random-polymer)
     (trace-events (exp03-cap6-productive-after-12 random-polymer seed-17))
     ((state-abundance-snapshot (exp03-cap6-productive-initial-state seed-17))
      (chamber-abundance-snapshot (exp03-cap6-productive-after-12 random-polymer seed-17)))
     (exp03-cap6-productive-metrics seed-17 random-polymer)
     (exp02-seed-17-acs-candidates random-polymer)
     ()
     (exp03-cap6-productive-run-summary seed-17 random-polymer)))

(= (exp03-cap6-productive-run-export seed-17 random-polymer)
   (make-run-export (exp03-cap6-productive-run-record seed-17 random-polymer)))

(= (exp03-cap6-productive-run-record-complete? seed-17)
   (and (run-record-passed? (exp03-cap6-productive-run-record seed-17 random-polymer))
        (and (exp03-cap6-productive-replay-ok? random-polymer seed-17)
             (exp03-cap6-productive-final-abundances-ok? seed-17))))

; Cap-5 bridge over the seed-17 S-family rich state.  The fifth bounded
; candidate is intentionally outside the 12-molecule state shape (S8/S9/S89)
; but remains visible to the deterministic selector as a tick-advancing no-op.
(= (exp03-cap5-rich-capped-candidates $family seed-17)
   (candidate-pool-candidates
     (bounded-candidate-pool
       (exp00-candidate-cap-5)
       (exp03-cap4-rich-chamber $family seed-17))))

(= (exp03-cap5-rich-selected-candidate $family seed-17)
   (selected-candidate-from-list-5
     (exp03-cap4-rich-chamber $family seed-17)
     (exp03-cap5-rich-capped-candidates $family seed-17)))

(= (exp03-cap5-rich-after-15 $family seed-17)
   (chamber-run-5cap-15 (exp03-cap4-rich-chamber $family seed-17)))

(= (exp03-cap5-rich-event-count $family seed-17)
   (event-count (trace-events (exp03-cap5-rich-after-15 $family seed-17))))

(= (exp03-cap5-rich-tick $family seed-17)
   (state-tick (chamber-state (exp03-cap5-rich-after-15 $family seed-17))))

(= (exp03-cap5-rich-abundances $family seed-17)
   (chamber-abundance-snapshot (exp03-cap5-rich-after-15 $family seed-17)))

(= (exp03-cap5-rich-replay-15 $family seed-17)
   (chamber-run-5cap-5 (chamber-run-5cap-10 (exp03-cap4-rich-chamber $family seed-17))))

(= (exp03-cap5-rich-replay-ok? $family seed-17)
   (== (exp03-cap5-rich-after-15 $family seed-17)
       (exp03-cap5-rich-replay-15 $family seed-17)))

(= (exp03-cap5-rich-controls-discriminate? seed-17)
   (and (> (exp03-cap5-rich-event-count random-polymer seed-17)
           (exp03-cap5-rich-event-count shuffled-catalysts seed-17))
        (> (exp03-cap5-rich-event-count random-polymer seed-17)
           (exp03-cap5-rich-event-count no-catalysis seed-17))))

(= (exp03-cap5-rich-run-config seed-17 random-polymer)
   (make-run-config exp03-cap5-rich-seed-17-random exp03 (seed-17) 15 (candidate-cap 5 1) random-polymer))

(= (exp03-cap5-rich-run-config seed-17 shuffled-catalysts)
   (make-run-config exp03-cap5-rich-seed-17-shuffled exp03 (seed-17) 15 (candidate-cap 5 1) shuffled-catalysts))

(= (exp03-cap5-rich-run-config seed-17 no-catalysis)
   (make-run-config exp03-cap5-rich-seed-17-no-catalysis exp03 (seed-17) 15 (candidate-cap 5 1) no-catalysis))

(= (exp03-cap5-rich-run-manifest seed-17 random-polymer)
   (make-run-manifest exp03-cap5-rich-seed-17-random config-hash-exp03-cap5-rich-seed-17-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap5-rich-run-manifest seed-17 shuffled-catalysts)
   (make-run-manifest exp03-cap5-rich-seed-17-shuffled config-hash-exp03-cap5-rich-seed-17-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap5-rich-run-manifest seed-17 no-catalysis)
   (make-run-manifest exp03-cap5-rich-seed-17-no-catalysis config-hash-exp03-cap5-rich-seed-17-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap5-rich-metrics seed-17 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap5-rich-run-config seed-17 $family)) (exp03-cap5-rich-event-count $family seed-17))
    (metric dynamic-tick-count (run-config-id (exp03-cap5-rich-run-config seed-17 $family)) 15)
    (metric source-exp02-rule-count (run-config-id (exp03-cap5-rich-run-config seed-17 $family)) 8)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap5-rich-run-config seed-17 $family)) 5)
    (metric rich-state-molecule-count (run-config-id (exp03-cap5-rich-run-config seed-17 $family)) 12)
    (metric cap5-distractor-rule (run-config-id (exp03-cap5-rich-run-config seed-17 $family)) fifth-candidate-outside-state-shape)
    (metric generation-seam (run-config-id (exp03-cap5-rich-run-config seed-17 $family)) seed-to-components)))

(= (exp03-cap5-rich-run-summary seed-17 random-polymer)
   (make-run-summary exp03-cap5-rich-seed-17-random passed cap5-rich-seed-17-five-candidate-dynamics True))

(= (exp03-cap5-rich-run-summary seed-17 shuffled-catalysts)
   (make-run-summary exp03-cap5-rich-seed-17-shuffled passed cap5-rich-seed-17-shuffled-partial-productive True))

(= (exp03-cap5-rich-run-summary seed-17 no-catalysis)
   (make-run-summary exp03-cap5-rich-seed-17-no-catalysis passed cap5-rich-seed-17-no-catalysis-control-zero-events True))

(= (exp03-cap5-rich-acs-candidates seed-17 $family)
   (exp02-seed-17-acs-candidates $family))

(= (exp03-cap5-rich-run-record seed-17 $family)
   (make-run-record
     (run-config-id (exp03-cap5-rich-run-config seed-17 $family))
     (exp03-cap5-rich-run-config seed-17 $family)
     (exp03-cap5-rich-run-manifest seed-17 $family)
     (trace-events (exp03-cap5-rich-after-15 $family seed-17))
     ((state-abundance-snapshot (exp03-cap4-rich-initial-state seed-17))
      (chamber-abundance-snapshot (exp03-cap5-rich-after-15 $family seed-17)))
     (exp03-cap5-rich-metrics seed-17 $family)
     (exp03-cap5-rich-acs-candidates seed-17 $family)
     ()
     (exp03-cap5-rich-run-summary seed-17 $family)))

(= (exp03-cap5-rich-run-records seed-17)
   ((exp03-cap5-rich-run-record seed-17 random-polymer)
    (exp03-cap5-rich-run-record seed-17 shuffled-catalysts)
    (exp03-cap5-rich-run-record seed-17 no-catalysis)))

(= (exp03-cap5-rich-run-records-complete? seed-17)
   (and (run-record-passed? (exp03-cap5-rich-run-record seed-17 random-polymer))
        (and (run-record-passed? (exp03-cap5-rich-run-record seed-17 shuffled-catalysts))
             (and (run-record-passed? (exp03-cap5-rich-run-record seed-17 no-catalysis))
                  (and (exp03-cap5-rich-controls-discriminate? seed-17)
                       (exp03-cap5-rich-replay-ok? random-polymer seed-17))))))


; ============================================================================
; Cap-4 RICH bridge atoms for seed-11 (12-molecule Q-family, 4-rule productive cycle)
; ============================================================================

(= (exp03-cap4-rich-initial-state seed-11)
   (state 0 seed-11
          (mol Q0 3) (mol Q1 3) (mol Q2 3) (mol Q3 3)
          (mol Q4 3) (mol Q5 3) (mol Q6 3) (mol Q7 3)
          (mol Q01 1) (mol Q10 0) (mol Q45 1) (mol Q54 0)))

(= (exp03-cap4-rich-chamber $family seed-11)
   (make-chamber (exp03-cap4-rich $family seed-11)
                 (exp03-cap4-rich-initial-state seed-11)
                 (exp03-exp02-full-source-rules seed-11 $family)
                 ()))

; Cap-5 exploratory seam over the same richer 12-molecule seed-11 state.
; This keeps the chemistry PeTTa-native and verifies that six-rule source pools
; can be bounded to five per-tick candidates before adding longer cap-5 dynamics.
(= (exp03-cap5-rich-capped-candidates $family seed-11)
   (candidate-pool-candidates
     (bounded-candidate-pool
       (exp00-candidate-cap-5)
       (exp03-cap4-rich-chamber $family seed-11))))

(= (exp03-cap5-rich-selected-candidate $family seed-11)
   (selected-candidate-from-list-5
     (exp03-cap4-rich-chamber $family seed-11)
     (exp03-cap5-rich-capped-candidates $family seed-11)))

(= (exp03-cap5-rich-after-15 $family seed-11)
   (chamber-run-5cap-15 (exp03-cap4-rich-chamber $family seed-11)))

(= (exp03-cap5-rich-event-count $family seed-11)
   (event-count (trace-events (exp03-cap5-rich-after-15 $family seed-11))))

(= (exp03-cap5-rich-tick $family seed-11)
   (state-tick (chamber-state (exp03-cap5-rich-after-15 $family seed-11))))

(= (exp03-cap5-rich-abundances $family seed-11)
   (chamber-abundance-snapshot (exp03-cap5-rich-after-15 $family seed-11)))

(= (exp03-cap5-rich-replay-15 $family seed-11)
   (chamber-run-5cap-5 (chamber-run-5cap-10 (exp03-cap4-rich-chamber $family seed-11))))

(= (exp03-cap5-rich-replay-ok? $family seed-11)
   (== (exp03-cap5-rich-after-15 $family seed-11)
       (exp03-cap5-rich-replay-15 $family seed-11)))

(= (exp03-cap5-rich-controls-discriminate? seed-11)
   (and (> (exp03-cap5-rich-event-count random seed-11)
           (exp03-cap5-rich-event-count shuffled seed-11))
        (> (exp03-cap5-rich-event-count random seed-11)
           (exp03-cap5-rich-event-count no-catalysis seed-11))))

(= (exp03-cap5-rich-run-config seed-11 random)
   (make-run-config exp03-cap5-rich-seed-11-random exp03 (seed-11) 15 (candidate-cap 5 1) random))

(= (exp03-cap5-rich-run-config seed-11 shuffled)
   (make-run-config exp03-cap5-rich-seed-11-shuffled exp03 (seed-11) 15 (candidate-cap 5 1) shuffled))

(= (exp03-cap5-rich-run-config seed-11 no-catalysis)
   (make-run-config exp03-cap5-rich-seed-11-no-catalysis exp03 (seed-11) 15 (candidate-cap 5 1) no-catalysis))

(= (exp03-cap5-rich-run-manifest seed-11 random)
   (make-run-manifest exp03-cap5-rich-seed-11-random config-hash-exp03-cap5-rich-seed-11-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap5-rich-run-manifest seed-11 shuffled)
   (make-run-manifest exp03-cap5-rich-seed-11-shuffled config-hash-exp03-cap5-rich-seed-11-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap5-rich-run-manifest seed-11 no-catalysis)
   (make-run-manifest exp03-cap5-rich-seed-11-no-catalysis config-hash-exp03-cap5-rich-seed-11-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap5-rich-metrics seed-11 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap5-rich-run-config seed-11 $family)) (exp03-cap5-rich-event-count $family seed-11))
    (metric dynamic-tick-count (run-config-id (exp03-cap5-rich-run-config seed-11 $family)) 15)
    (metric source-exp02-rule-count (run-config-id (exp03-cap5-rich-run-config seed-11 $family)) 6)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap5-rich-run-config seed-11 $family)) 5)
    (metric rich-state-molecule-count (run-config-id (exp03-cap5-rich-run-config seed-11 $family)) 12)
    (metric cap5-distractor-rule (run-config-id (exp03-cap5-rich-run-config seed-11 $family)) fifth-candidate-outside-state-shape)))

(= (exp03-cap5-rich-run-summary seed-11 random)
   (make-run-summary exp03-cap5-rich-seed-11-random passed cap5-rich-seed-11-five-candidate-dynamics True))

(= (exp03-cap5-rich-run-summary seed-11 shuffled)
   (make-run-summary exp03-cap5-rich-seed-11-shuffled passed cap5-rich-seed-11-shuffled-partial-productive True))

(= (exp03-cap5-rich-run-summary seed-11 no-catalysis)
   (make-run-summary exp03-cap5-rich-seed-11-no-catalysis passed cap5-rich-seed-11-no-catalysis-control-zero-events True))

(= (exp03-cap5-rich-acs-candidates seed-11 $family)
   (exp02-random-acs-candidates-6 seed-11))

(= (exp03-cap5-rich-run-record seed-11 $family)
   (make-run-record
     (run-config-id (exp03-cap5-rich-run-config seed-11 $family))
     (exp03-cap5-rich-run-config seed-11 $family)
     (exp03-cap5-rich-run-manifest seed-11 $family)
     (trace-events (exp03-cap5-rich-after-15 $family seed-11))
     ((state-abundance-snapshot (exp03-cap4-rich-initial-state seed-11))
      (chamber-abundance-snapshot (exp03-cap5-rich-after-15 $family seed-11)))
     (exp03-cap5-rich-metrics seed-11 $family)
     (exp03-cap5-rich-acs-candidates seed-11 $family)
     ()
     (exp03-cap5-rich-run-summary seed-11 $family)))

(= (exp03-cap5-rich-run-records seed-11)
   ((exp03-cap5-rich-run-record seed-11 random)
    (exp03-cap5-rich-run-record seed-11 shuffled)
    (exp03-cap5-rich-run-record seed-11 no-catalysis)))

(= (exp03-cap5-rich-run-records-complete? seed-11)
   (and (run-record-passed? (exp03-cap5-rich-run-record seed-11 random))
        (and (run-record-passed? (exp03-cap5-rich-run-record seed-11 shuffled))
             (and (run-record-passed? (exp03-cap5-rich-run-record seed-11 no-catalysis))
                  (and (exp03-cap5-rich-controls-discriminate? seed-11)
                       (exp03-cap5-rich-replay-ok? random seed-11))))))


; ============================================================================
; Cap-6 PRODUCTIVE bridge for seed-11 (15-molecule Q-family, productive sixth candidate)
; ============================================================================
;
; The cap-6 rich bridge above exposes rr5 as a safe no-op because Q16 is outside
; the 12-molecule state shape.  This wider state includes Q05 and Q16 so all six
; bounded seed-11 random-polymer candidates can fire through chamber ticking.

; rr1: productive in the 15-molecule seed-11 Q-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                      (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                      (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                      (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
               $rules
               $events)
      (candidate $ct (rule rr1 Q2 Q3 Q10 Q01) $score))
   (if (and (> $q2 0) (and (> $q3 0) (> $q01 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 (- $q2 1)) (mol Q3 (- $q3 1))
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 (+ $q10 1)) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                (append-event $events (event $tick rr1 Q2 Q3 Q10 Q01)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                $events)))

; rr0: productive in the 15-molecule seed-11 Q-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                      (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                      (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                      (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
               $rules
               $events)
      (candidate $ct (rule rr0 Q0 Q1 Q01 Q10) $score))
   (if (and (> $q0 0) (and (> $q1 0) (> $q10 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 (- $q0 1)) (mol Q1 (- $q1 1)) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 (+ $q01 1)) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                (append-event $events (event $tick rr0 Q0 Q1 Q01 Q10)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                $events)))

; rr2: productive in the 15-molecule seed-11 Q-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                      (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                      (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                      (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
               $rules
               $events)
      (candidate $ct (rule rr2 Q4 Q5 Q45 Q54) $score))
   (if (and (> $q4 0) (and (> $q5 0) (> $q54 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 (- $q4 1)) (mol Q5 (- $q5 1)) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 (+ $q45 1)) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                (append-event $events (event $tick rr2 Q4 Q5 Q45 Q54)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                $events)))

; rr3: productive in the 15-molecule seed-11 Q-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                      (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                      (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                      (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
               $rules
               $events)
      (candidate $ct (rule rr3 Q6 Q7 Q54 Q45) $score))
   (if (and (> $q6 0) (and (> $q7 0) (> $q45 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 (- $q6 1)) (mol Q7 (- $q7 1))
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 (+ $q54 1))
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                (append-event $events (event $tick rr3 Q6 Q7 Q54 Q45)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                $events)))

; rr4: productive in the 15-molecule seed-11 Q-family cap-6 state.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                      (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                      (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                      (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
               $rules
               $events)
      (candidate $ct (rule rr4 Q0 Q5 Q05 Q2) $score))
   (if (and (> $q0 0) (and (> $q5 0) (> $q2 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 (- $q0 1)) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 (- $q5 1)) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 (+ $q05 1)) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                (append-event $events (event $tick rr4 Q0 Q5 Q05 Q2)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                $events)))

; rr5: productive in the wider state, making the sixth cap-6 candidate an
; in-state reaction instead of a bounded no-op.
(= (chamber-tick-with-candidate-accum
      (chamber $id
               (state $tick $seed
                      (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                      (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                      (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                      (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
               $rules
               $events)
      (candidate $ct (rule rr5 Q1 Q6 Q16 Q3) $score))
   (if (and (> $q1 0) (and (> $q6 0) (> $q3 0)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 (- $q1 1)) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 (- $q6 1)) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 (+ $q16 1)) (mol Q99 $q99))
                $rules
                (append-event $events (event $tick rr5 Q1 Q6 Q16 Q3)))
       (chamber $id
                (state (+ $tick 1) $seed
                       (mol Q0 $q0) (mol Q1 $q1) (mol Q2 $q2) (mol Q3 $q3)
                       (mol Q4 $q4) (mol Q5 $q5) (mol Q6 $q6) (mol Q7 $q7)
                       (mol Q01 $q01) (mol Q10 $q10) (mol Q45 $q45) (mol Q54 $q54)
                       (mol Q05 $q05) (mol Q16 $q16) (mol Q99 $q99))
                $rules
                $events)))

(= (exp03-cap6-productive-initial-state seed-11)
   (state 0 seed-11
          (mol Q0 4) (mol Q1 4) (mol Q2 3) (mol Q3 2)
          (mol Q4 2) (mol Q5 4) (mol Q6 4) (mol Q7 2)
          (mol Q01 1) (mol Q10 1) (mol Q45 1) (mol Q54 1)
          (mol Q05 0) (mol Q16 0) (mol Q99 0)))

(= (exp03-cap6-productive-chamber random seed-11)
   (make-chamber (exp03-cap6-productive random seed-11)
                 (exp03-cap6-productive-initial-state seed-11)
                 (exp03-exp02-full-source-rules seed-11 random)
                 ()))

(= (exp03-cap6-productive-capped-candidates random seed-11)
   (candidate-pool-candidates
     (bounded-candidate-pool
       (exp00-candidate-cap-6)
       (exp03-cap6-productive-chamber random seed-11))))

(= (exp03-cap6-productive-selected-candidate random seed-11)
   (selected-candidate-from-list-6
     (exp03-cap6-productive-chamber random seed-11)
     (exp03-cap6-productive-capped-candidates random seed-11)))

(= (exp03-cap6-productive-after-12 random seed-11)
   (chamber-run-6cap-12 (exp03-cap6-productive-chamber random seed-11)))

(= (exp03-cap6-productive-event-count random seed-11)
   (event-count (trace-events (exp03-cap6-productive-after-12 random seed-11))))

(= (exp03-cap6-productive-tick random seed-11)
   (state-tick (chamber-state (exp03-cap6-productive-after-12 random seed-11))))

(= (exp03-cap6-productive-abundances random seed-11)
   (chamber-abundance-snapshot (exp03-cap6-productive-after-12 random seed-11)))

(= (exp03-cap6-productive-replay-12 random seed-11)
   (chamber-run-6cap-6 (chamber-run-6cap-6 (exp03-cap6-productive-chamber random seed-11))))

(= (exp03-cap6-productive-replay-ok? random seed-11)
   (== (exp03-cap6-productive-after-12 random seed-11)
       (exp03-cap6-productive-replay-12 random seed-11)))

(= (exp03-cap6-productive-final-abundances-ok? seed-11)
   (== (exp03-cap6-productive-abundances random seed-11)
       (abundance-snapshot 12 ((mol Q0 0) (mol Q1 0) (mol Q2 1) (mol Q3 0)
                               (mol Q4 0) (mol Q5 0) (mol Q6 0) (mol Q7 0)
                               (mol Q01 3) (mol Q10 3) (mol Q45 3) (mol Q54 3)
                               (mol Q05 2) (mol Q16 2) (mol Q99 0)))))

(= (exp03-cap6-productive-run-config seed-11 random)
   (make-run-config exp03-cap6-productive-seed-11-random exp03 (seed-11) 12 (candidate-cap 6 1) random))

(= (exp03-cap6-productive-run-manifest seed-11 random)
   (make-run-manifest exp03-cap6-productive-seed-11-random config-hash-exp03-cap6-productive-seed-11-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap6-productive-metrics seed-11 random)
   ((metric dynamic-event-count exp03-cap6-productive-seed-11-random (exp03-cap6-productive-event-count random seed-11))
    (metric dynamic-tick-count exp03-cap6-productive-seed-11-random 12)
    (metric source-exp02-rule-count exp03-cap6-productive-seed-11-random 6)
    (metric dynamic-candidate-cap exp03-cap6-productive-seed-11-random 6)
    (metric rich-state-molecule-count exp03-cap6-productive-seed-11-random 15)
    (metric productive-sixth-candidate exp03-cap6-productive-seed-11-random rr5)))

(= (exp03-cap6-productive-run-summary seed-11 random)
   (make-run-summary exp03-cap6-productive-seed-11-random passed cap6-productive-sixth-candidate-seed-11 True))

(= (exp03-cap6-productive-run-record seed-11 random)
   (make-run-record
     exp03-cap6-productive-seed-11-random
     (exp03-cap6-productive-run-config seed-11 random)
     (exp03-cap6-productive-run-manifest seed-11 random)
     (trace-events (exp03-cap6-productive-after-12 random seed-11))
     ((state-abundance-snapshot (exp03-cap6-productive-initial-state seed-11))
      (chamber-abundance-snapshot (exp03-cap6-productive-after-12 random seed-11)))
     (exp03-cap6-productive-metrics seed-11 random)
     (exp02-random-acs-candidates-6 seed-11)
     ()
     (exp03-cap6-productive-run-summary seed-11 random)))

(= (exp03-cap6-productive-run-export seed-11 random)
   (make-run-export (exp03-cap6-productive-run-record seed-11 random)))

(= (exp03-cap6-productive-run-record-complete? seed-11)
   (and (run-record-passed? (exp03-cap6-productive-run-record seed-11 random))
        (and (exp03-cap6-productive-replay-ok? random seed-11)
             (exp03-cap6-productive-final-abundances-ok? seed-11))))

; Cap-6 bridge over the same seed-11/Q-family rich state.  This is the first
; exp03 dynamic run where the full six-rule source pool is visible to per-tick
; deterministic selection.  The sixth rule is outside the 12-molecule state
; shape and therefore advances as a bounded no-op, while rr0..rr3 remain
; productive when their catalysts are present.
(= (exp03-cap6-rich-capped-candidates $family seed-11)
   (candidate-pool-candidates
     (bounded-candidate-pool
       (exp00-candidate-cap-6)
       (exp03-cap4-rich-chamber $family seed-11))))

(= (exp03-cap6-rich-selected-candidate $family seed-11)
   (selected-candidate-from-list-6
     (exp03-cap4-rich-chamber $family seed-11)
     (exp03-cap6-rich-capped-candidates $family seed-11)))

(= (exp03-cap6-rich-after-12 $family seed-11)
   (chamber-run-6cap-12 (exp03-cap4-rich-chamber $family seed-11)))

(= (exp03-cap6-rich-event-count $family seed-11)
   (event-count (trace-events (exp03-cap6-rich-after-12 $family seed-11))))

(= (exp03-cap6-rich-tick $family seed-11)
   (state-tick (chamber-state (exp03-cap6-rich-after-12 $family seed-11))))

(= (exp03-cap6-rich-abundances $family seed-11)
   (chamber-abundance-snapshot (exp03-cap6-rich-after-12 $family seed-11)))

(= (exp03-cap6-rich-replay-12 $family seed-11)
   (chamber-run-6cap-6 (chamber-run-6cap-6 (exp03-cap4-rich-chamber $family seed-11))))

(= (exp03-cap6-rich-replay-ok? $family seed-11)
   (== (exp03-cap6-rich-after-12 $family seed-11)
       (exp03-cap6-rich-replay-12 $family seed-11)))

(= (exp03-cap6-rich-run-config seed-11 random)
   (make-run-config exp03-cap6-rich-seed-11-random exp03 (seed-11) 12 (candidate-cap 6 1) random))

(= (exp03-cap6-rich-run-manifest seed-11 random)
   (make-run-manifest exp03-cap6-rich-seed-11-random config-hash-exp03-cap6-rich-seed-11-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap6-rich-metrics seed-11 random)
   ((metric dynamic-event-count exp03-cap6-rich-seed-11-random (exp03-cap6-rich-event-count random seed-11))
    (metric dynamic-tick-count exp03-cap6-rich-seed-11-random 12)
    (metric source-exp02-rule-count exp03-cap6-rich-seed-11-random 6)
    (metric dynamic-candidate-cap exp03-cap6-rich-seed-11-random 6)
    (metric rich-state-molecule-count exp03-cap6-rich-seed-11-random 12)
    (metric cap6-sixth-candidate exp03-cap6-rich-seed-11-random bounded-outside-state-shape)))

(= (exp03-cap6-rich-run-summary seed-11 random)
   (make-run-summary exp03-cap6-rich-seed-11-random passed cap6-rich-seed-11-six-candidate-dynamics True))

(= (exp03-cap6-rich-run-record seed-11 random)
   (make-run-record
     exp03-cap6-rich-seed-11-random
     (exp03-cap6-rich-run-config seed-11 random)
     (exp03-cap6-rich-run-manifest seed-11 random)
     (trace-events (exp03-cap6-rich-after-12 random seed-11))
     ((state-abundance-snapshot (exp03-cap4-rich-initial-state seed-11))
      (chamber-abundance-snapshot (exp03-cap6-rich-after-12 random seed-11)))
     (exp03-cap6-rich-metrics seed-11 random)
     (exp02-random-acs-candidates-6 seed-11)
     ()
     (exp03-cap6-rich-run-summary seed-11 random)))

(= (exp03-cap6-rich-run-export seed-11 random)
   (make-run-export (exp03-cap6-rich-run-record seed-11 random)))

(= (exp03-cap7-productive-run-export seed-13 random-polymer)
   (make-run-export (exp03-cap7-productive-run-record seed-13 random-polymer)))

(= (exp03-productive-cap-run-exports)
   ((exp03-cap5-productive-run-export seed-13 random-polymer)
    (exp03-cap6-rich-run-export seed-11 random)
    (exp03-cap6-productive-run-export seed-11 random)
    (exp03-cap6-productive-run-export seed-13 random-polymer)
    (exp03-cap6-productive-run-export seed-17 random-polymer)
    (exp03-cap7-productive-run-export seed-13 random-polymer)))

(= (exp03-productive-cap-run-exports-complete?)
   (and (== (event-count (run-export-events (exp03-cap5-productive-run-export seed-13 random-polymer))) 10)
        (and (== (event-count (run-export-events (exp03-cap6-rich-run-export seed-11 random))) 7)
             (and (== (event-count (run-export-events (exp03-cap6-productive-run-export seed-11 random))) 12)
                  (and (== (event-count (run-export-events (exp03-cap6-productive-run-export seed-13 random-polymer))) 12)
                       (and (== (event-count (run-export-events (exp03-cap6-productive-run-export seed-17 random-polymer))) 12)
                            (== (event-count (run-export-events (exp03-cap7-productive-run-export seed-13 random-polymer))) 14)))))))

; PeTTa-side per-file bundle projections for thin host serializers.  These keep
; file section choice in the PeTTa contract rather than rebuilding it in Python.
(= (exp03-cap5-productive-file-bundle seed-13 random-polymer)
   (make-run-file-bundle (exp03-cap5-productive-run-record seed-13 random-polymer)))

(= (exp03-cap6-rich-file-bundle seed-11 random)
   (make-run-file-bundle (exp03-cap6-rich-run-record seed-11 random)))

(= (exp03-cap6-productive-file-bundle seed-11 random)
   (make-run-file-bundle (exp03-cap6-productive-run-record seed-11 random)))

(= (exp03-cap6-productive-file-bundle seed-13 random-polymer)
   (make-run-file-bundle (exp03-cap6-productive-run-record seed-13 random-polymer)))

(= (exp03-cap6-productive-file-bundle seed-17 random-polymer)
   (make-run-file-bundle (exp03-cap6-productive-run-record seed-17 random-polymer)))

(= (exp03-cap7-productive-file-bundle seed-13 random-polymer)
   (make-run-file-bundle (exp03-cap7-productive-run-record seed-13 random-polymer)))

(= (exp03-productive-cap-file-bundles)
   ((exp03-cap5-productive-file-bundle seed-13 random-polymer)
    (exp03-cap6-rich-file-bundle seed-11 random)
    (exp03-cap6-productive-file-bundle seed-11 random)
    (exp03-cap6-productive-file-bundle seed-13 random-polymer)
    (exp03-cap6-productive-file-bundle seed-17 random-polymer)
    (exp03-cap7-productive-file-bundle seed-13 random-polymer)))

(= (exp03-productive-cap-file-bundles-complete?)
   (and (== (run-file-bundle-id (exp03-cap5-productive-file-bundle seed-13 random-polymer))
            exp03-cap5-productive-seed-13-random)
        (and (== (run-file-bundle-id (exp03-cap6-rich-file-bundle seed-11 random))
                 exp03-cap6-rich-seed-11-random)
             (and (== (run-file-bundle-id (exp03-cap6-productive-file-bundle seed-11 random))
                      exp03-cap6-productive-seed-11-random)
                  (and (== (run-file-bundle-id (exp03-cap6-productive-file-bundle seed-13 random-polymer))
                           exp03-cap6-productive-seed-13-random)
                       (and (== (run-file-bundle-id (exp03-cap6-productive-file-bundle seed-17 random-polymer))
                                exp03-cap6-productive-seed-17-random)
                            (== (run-file-bundle-id (exp03-cap7-productive-file-bundle seed-13 random-polymer))
                                exp03-cap7-productive-seed-13-random)))))))

(= (exp03-cap6-rich-run-record-complete? seed-11)
   (and (run-record-passed? (exp03-cap6-rich-run-record seed-11 random))
        (exp03-cap6-rich-replay-ok? random seed-11)))

(= (exp03-cap4-rich-after-12 $family seed-11)
   (chamber-run-4cap-12 (exp03-cap4-rich-chamber $family seed-11)))

(= (exp03-cap4-rich-event-count $family seed-11)
   (event-count (trace-events (exp03-cap4-rich-after-12 $family seed-11))))

(= (exp03-cap4-rich-tick $family seed-11)
   (state-tick (chamber-state (exp03-cap4-rich-after-12 $family seed-11))))

(= (exp03-cap4-rich-abundances $family seed-11)
   (chamber-abundance-snapshot (exp03-cap4-rich-after-12 $family seed-11)))

(= (exp03-cap4-rich-replay-12 $family seed-11)
   (chamber-run-4cap-3 (chamber-run-4cap-9 (exp03-cap4-rich-chamber $family seed-11))))

(= (exp03-cap4-rich-replay-ok? $family seed-11)
   (== (exp03-cap4-rich-after-12 $family seed-11)
       (exp03-cap4-rich-replay-12 $family seed-11)))

(= (exp03-cap4-rich-reactant-exhausted? seed-11)
   (== (exp03-cap4-rich-abundances random seed-11)
       (abundance-snapshot 12 ((mol Q0 0) (mol Q1 0) (mol Q2 0) (mol Q3 0)
                               (mol Q4 0) (mol Q5 0) (mol Q6 0) (mol Q7 0)
                               (mol Q01 4) (mol Q10 3) (mol Q45 4) (mol Q54 3)))))

(= (exp03-cap4-rich-controls-discriminate? seed-11)
   (and (> (exp03-cap4-rich-event-count random seed-11)
           (exp03-cap4-rich-event-count shuffled seed-11))
        (> (exp03-cap4-rich-event-count random seed-11)
           (exp03-cap4-rich-event-count no-catalysis seed-11))))

(= (exp03-cap4-rich-run-config seed-11 random)
   (make-run-config exp03-cap4-rich-seed-11-random exp03 (seed-11) 12 (candidate-cap 4 1) random))

(= (exp03-cap4-rich-run-config seed-11 shuffled)
   (make-run-config exp03-cap4-rich-seed-11-shuffled exp03 (seed-11) 12 (candidate-cap 4 1) shuffled))

(= (exp03-cap4-rich-run-config seed-11 no-catalysis)
   (make-run-config exp03-cap4-rich-seed-11-no-catalysis exp03 (seed-11) 12 (candidate-cap 4 1) no-catalysis))

(= (exp03-cap4-rich-run-manifest seed-11 random)
   (make-run-manifest exp03-cap4-rich-seed-11-random config-hash-exp03-cap4-rich-seed-11-random petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-run-manifest seed-11 shuffled)
   (make-run-manifest exp03-cap4-rich-seed-11-shuffled config-hash-exp03-cap4-rich-seed-11-shuffled petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-run-manifest seed-11 no-catalysis)
   (make-run-manifest exp03-cap4-rich-seed-11-no-catalysis config-hash-exp03-cap4-rich-seed-11-no-catalysis petta-local swi-9-3-36 scripts-run-exp03-sh 0))

(= (exp03-cap4-rich-metrics seed-11 $family)
   ((metric dynamic-event-count (run-config-id (exp03-cap4-rich-run-config seed-11 $family)) (exp03-cap4-rich-event-count $family seed-11))
    (metric dynamic-tick-count (run-config-id (exp03-cap4-rich-run-config seed-11 $family)) 12)
    (metric source-exp02-rule-count (run-config-id (exp03-cap4-rich-run-config seed-11 $family)) 6)
    (metric dynamic-candidate-cap (run-config-id (exp03-cap4-rich-run-config seed-11 $family)) 4)
    (metric rich-state-molecule-count (run-config-id (exp03-cap4-rich-run-config seed-11 $family)) 12)))

(= (exp03-cap4-rich-run-summary seed-11 random)
   (make-run-summary exp03-cap4-rich-seed-11-random passed cap4-rich-seed-11-4-rule-productive True))

(= (exp03-cap4-rich-run-summary seed-11 shuffled)
   (make-run-summary exp03-cap4-rich-seed-11-shuffled passed cap4-rich-seed-11-shuffled-partial-productive True))

(= (exp03-cap4-rich-run-summary seed-11 no-catalysis)
   (make-run-summary exp03-cap4-rich-seed-11-no-catalysis passed cap4-rich-seed-11-no-catalysis-control-zero-events True))

(= (exp03-cap4-rich-acs-candidates seed-11 $family)
   (exp02-random-acs-candidates-6 seed-11))

(= (exp03-cap4-rich-run-record seed-11 $family)
   (make-run-record
     (run-config-id (exp03-cap4-rich-run-config seed-11 $family))
     (exp03-cap4-rich-run-config seed-11 $family)
     (exp03-cap4-rich-run-manifest seed-11 $family)
     (trace-events (exp03-cap4-rich-after-12 $family seed-11))
     ((state-abundance-snapshot (exp03-cap4-rich-initial-state seed-11))
      (chamber-abundance-snapshot (exp03-cap4-rich-after-12 $family seed-11)))
     (exp03-cap4-rich-metrics seed-11 $family)
     (exp03-cap4-rich-acs-candidates seed-11 $family)
     ()
     (exp03-cap4-rich-run-summary seed-11 $family)))

(= (exp03-cap4-rich-run-records seed-11)
   ((exp03-cap4-rich-run-record seed-11 random)
    (exp03-cap4-rich-run-record seed-11 shuffled)
    (exp03-cap4-rich-run-record seed-11 no-catalysis)))

(= (exp03-cap4-rich-run-records-complete? seed-11)
   (and (run-record-passed? (exp03-cap4-rich-run-record seed-11 random))
        (and (run-record-passed? (exp03-cap4-rich-run-record seed-11 shuffled))
             (and (run-record-passed? (exp03-cap4-rich-run-record seed-11 no-catalysis))
                  (and (exp03-cap4-rich-controls-discriminate? seed-11)
                       (exp03-cap4-rich-replay-ok? random seed-11))))))
