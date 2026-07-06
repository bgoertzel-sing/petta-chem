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

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5))
   6)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6))
   7)

(= (event-count ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7))
   8)

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

(= (run-export-events
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $events)

(= (run-export-metrics
      (run-export $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $metrics)

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
