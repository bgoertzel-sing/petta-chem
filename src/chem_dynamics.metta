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

(= (state-advance-tick (state $tick $seed $m0 $m1 $m2 $m3))
   (state (+ $tick 1) $seed $m0 $m1 $m2 $m3))

(= (state-abundance-snapshot (state $tick $seed $m0 $m1 $m2 $m3))
   (abundance-snapshot $tick ($m0 $m1 $m2 $m3)))

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
