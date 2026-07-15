; exp00 PeTTa-native chemistry kernel spike.
;
; This file intentionally avoids Python or host-side simulation.  It defines a
; tiny deterministic symbolic chemistry transition in PeTTa/MeTTa terms so the
; first repository commits have executable PeTTa kernel shapes.
;
; Atom conventions, version 0.1:
;   (mol <name> <abundance>)
;   (rule <id> <reactant-a> <reactant-b> <product> <catalyst>)
;   (state <tick> <seed> <mol>...)
;   (candidate <tick> <rule> <score>)
;   (candidate-pool <tick> (<candidate>...))
;   (candidate-cap <per-tick> <per-rule>)
;   (event <tick> <rule-id> <reactant-a> <reactant-b> <product> <catalyst>)
;   (trace <state-after> <event>...)
;   (chamber <id> <state> <rules> <events>)
;   (metric <name> <subject> <value>)
;
; exp00 remains deliberately bounded: one binary catalytic rule over a compact
; four-molecule state.  The transition is now expressed by generic accessors and
; a generic state transformer instead of one fully hard-coded replay clause.

; ----- Atom contracts / accessors -----

(= (mol-name (mol $name $abundance))
   $name)

(= (mol-abundance (mol $name $abundance))
   $abundance)

(= (mol-positive? (mol $name $abundance))
   (> $abundance 0))

(= (mol-nonnegative? (mol $name $abundance))
   (>= $abundance 0))

(= (symbol-code A) 11)

(= (symbol-code B) 13)

(= (symbol-code AB) 17)

(= (symbol-code Cat) 19)

(= (symbol-code BCat) 23)

(= (symbol-code ACat) 29)

(= (symbol-code r0) 31)

(= (symbol-code r1) 37)

(= (symbol-code r2) 41)

; Deterministic structural hashes for tiny exp00 fixtures.  They are not
; cryptographic hashes; they provide stable PeTTa-native identities for replay
; and run-contract tests before host-side canonical hashing exists.
(= (mol-hash (mol $name $abundance))
   (+ (* (symbol-code $name) 100) $abundance))

(= (rule-hash (rule $id $a $b $product $catalyst))
   (+ (* (symbol-code $id) 100000000)
      (+ (* (symbol-code $a) 1000000)
         (+ (* (symbol-code $b) 10000)
            (+ (* (symbol-code $product) 100)
               (symbol-code $catalyst))))))

(= (rule-id (rule $id $a $b $product $catalyst))
   $id)

(= (rule-reactant-a (rule $id $a $b $product $catalyst))
   $a)

(= (rule-reactant-b (rule $id $a $b $product $catalyst))
   $b)

(= (rule-product (rule $id $a $b $product $catalyst))
   $product)

(= (rule-catalyst (rule $id $a $b $product $catalyst))
   $catalyst)

(= (seed-number seed-7) 7)

(= (seed-number seed-8) 8)

(= (seed-number seed-9) 9)

(= (seed-number seed-10) 10)

(= (seed-number seed-11) 11)

(= (seed-number seed-12) 12)

(= (seed-number seed-13) 13)

(= (seed-number seed-14) 14)

(= (seed-number seed-15) 15)

(= (seed-number seed-16) 16)

(= (seed-number seed-17) 17)

(= (seed-number seed-18) 18)

(= (seed-number seed-19) 19)

(= (seed-number seed-20) 20)

(= (seed-number seed-21) 21)

(= (seed-number seed-22) 22)

(= (seed-number seed-23) 23)

(= (seed-number seed-24) 24)

(= (seed-number seed-25) 25)

(= (seed-number seed-26) 26)

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3))
   $tick)

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9))
   $tick)

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11))
   $tick)

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14))
   $tick)

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15))
   $tick)

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15 $m16))
   $tick)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3))
   $seed)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9))
   $seed)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11))
   $seed)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14))
   $seed)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15))
   $seed)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15 $m16))
   $seed)

(= (state-nonnegative?
      (state $tick $seed $m0 $m1 $m2 $m3))
   (and (mol-nonnegative? $m0)
        (and (mol-nonnegative? $m1)
             (and (mol-nonnegative? $m2)
                  (mol-nonnegative? $m3)))))

(= (make-event $tick (rule $id $a $b $product $catalyst))
   (event $tick $id $a $b $product $catalyst))

(= (trace-state (trace $state-after $event))
   $state-after)

(= (trace-event (trace $state-after $event))
   $event)

(= (make-candidate $tick $rule $score)
   (candidate $tick $rule $score))

(= (candidate-tick (candidate $tick $rule $score))
   $tick)

(= (candidate-rule (candidate $tick $rule $score))
   $rule)

(= (candidate-score (candidate $tick $rule $score))
   $score)

(= (make-candidate-for-rule $tick $rule)
   (make-candidate $tick $rule 1))

(= (candidate-pool-tick (candidate-pool $tick $candidates))
   $tick)

(= (candidate-pool-candidates (candidate-pool $tick $candidates))
   $candidates)

(= (make-candidate-cap $per-tick $per-rule)
   (candidate-cap $per-tick $per-rule))

(= (candidate-cap-per-tick (candidate-cap $per-tick $per-rule))
   $per-tick)

(= (candidate-cap-per-rule (candidate-cap $per-tick $per-rule))
   $per-rule)

; Generic generation emits at most one candidate for each source rule. A
; zero per-rule allowance must therefore close the selection boundary even
; when the wider per-tick cap is positive.
(= (effective-candidate-cap-per-tick $cap)
   (if (> (candidate-cap-per-rule $cap) 0)
       (candidate-cap-per-tick $cap)
       0))

(= (make-chamber $id $state $rules $events)
   (chamber $id $state $rules $events))

(= (chamber-id (chamber $id $state $rules $events))
   $id)

(= (chamber-state (chamber $id $state $rules $events))
   $state)

(= (chamber-rules (chamber $id $state $rules $events))
   $rules)

(= (chamber-events (chamber $id $state $rules $events))
   $events)

(= (make-metric $name $subject $value)
   (metric $name $subject $value))

; Deterministic sampler seam.  This is not yet a scientific stochastic sampler;
; it gives exp00 a replayable seed/tick-indexed choice point that later weighted
; sampling can replace without changing candidate/chamber contracts.
(= (seeded-choice-2 $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 2))

(= (select-candidate-2 $seed $tick $candidate-0 $candidate-1)
   (if (== (seeded-choice-2 $seed $tick) 0)
       $candidate-0
       $candidate-1))

; 3-candidate deterministic seam for cap-3 pools.
(= (seeded-choice-3 $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 3))

(= (select-candidate-3 $seed $tick $candidate-0 $candidate-1 $candidate-2)
   (if (== (seeded-choice-3 $seed $tick) 0)
       $candidate-0
       (if (== (seeded-choice-3 $seed $tick) 1)
           $candidate-1
           $candidate-2)))

; 4-candidate deterministic seam for cap-4 pools.
(= (seeded-choice-4 $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 4))

(= (select-candidate-4 $seed $tick $candidate-0 $candidate-1 $candidate-2 $candidate-3)
   (if (== (seeded-choice-4 $seed $tick) 0)
       $candidate-0
       (if (== (seeded-choice-4 $seed $tick) 1)
           $candidate-1
           (if (== (seeded-choice-4 $seed $tick) 2)
               $candidate-2
               $candidate-3))))

; 5-candidate deterministic seam for cap-5 pools.
(= (seeded-choice-5 $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 5))

(= (select-candidate-5 $seed $tick $candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)
   (if (== (seeded-choice-5 $seed $tick) 0)
       $candidate-0
       (if (== (seeded-choice-5 $seed $tick) 1)
           $candidate-1
           (if (== (seeded-choice-5 $seed $tick) 2)
               $candidate-2
               (if (== (seeded-choice-5 $seed $tick) 3)
                   $candidate-3
                   $candidate-4)))))

; 6-candidate deterministic seam for cap-6 pools.
(= (seeded-choice-6 $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 6))

(= (select-candidate-6 $seed $tick $candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)
   (if (== (seeded-choice-6 $seed $tick) 0)
       $candidate-0
       (if (== (seeded-choice-6 $seed $tick) 1)
           $candidate-1
           (if (== (seeded-choice-6 $seed $tick) 2)
               $candidate-2
               (if (== (seeded-choice-6 $seed $tick) 3)
                   $candidate-3
                   (if (== (seeded-choice-6 $seed $tick) 4)
                       $candidate-4
                       $candidate-5))))))

; 7-candidate deterministic seam for cap-7 pools.
(= (seeded-choice-7 $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 7))

(= (select-candidate-7 $seed $tick $candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)
   (if (== (seeded-choice-7 $seed $tick) 0)
       $candidate-0
       (if (== (seeded-choice-7 $seed $tick) 1)
           $candidate-1
           (if (== (seeded-choice-7 $seed $tick) 2)
               $candidate-2
               (if (== (seeded-choice-7 $seed $tick) 3)
                   $candidate-3
                   (if (== (seeded-choice-7 $seed $tick) 4)
                       $candidate-4
                       (if (== (seeded-choice-7 $seed $tick) 5)
                           $candidate-5
                           $candidate-6)))))))

; 8-candidate deterministic seam for full eight-rule pools.
(= (seeded-choice-8 $seed $tick)
   (#mod (+ (seed-number $seed) $tick) 8))

(= (select-candidate-8 $seed $tick $candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)
   (if (== (seeded-choice-8 $seed $tick) 0)
       $candidate-0
       (if (== (seeded-choice-8 $seed $tick) 1)
           $candidate-1
           (if (== (seeded-choice-8 $seed $tick) 2)
               $candidate-2
               (if (== (seeded-choice-8 $seed $tick) 3)
                   $candidate-3
                   (if (== (seeded-choice-8 $seed $tick) 4)
                       $candidate-4
                       (if (== (seeded-choice-8 $seed $tick) 5)
                           $candidate-5
                           (if (== (seeded-choice-8 $seed $tick) 6)
                               $candidate-6
                               $candidate-7))))))))

(= (cap-candidate-pool 0 (candidate-pool $tick $candidates))
   ())

; Empty generated/external pools remain empty under every positive cap.
(= (cap-candidate-pool $cap (candidate-pool $tick ()))
   ())

; Candidate caps are maxima: preserve every non-empty source pool smaller
; than the requested cap, then truncate pools at or above that cap below.
(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 5 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 5 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 5 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 5 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 6 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 6 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 6 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 6 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 6 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))

(= (cap-candidate-pool 7 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 7 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 7 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 7 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 7 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))

(= (cap-candidate-pool 7 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5))

(= (cap-candidate-pool 8 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 8 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 8 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 8 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))

(= (cap-candidate-pool 8 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5))

(= (cap-candidate-pool 8 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))
   ($candidate-0))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

(= (cap-candidate-pool 5 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))

(= (cap-candidate-pool 5 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))

(= (cap-candidate-pool 5 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))

(= (cap-candidate-pool 5 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))

(= (cap-candidate-pool 6 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5))

(= (cap-candidate-pool 6 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5))

(= (cap-candidate-pool 6 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5))

(= (cap-candidate-pool 7 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6))
(= (cap-candidate-pool 7 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6))

; A cap is a maximum: preserve smaller pools rather than requiring callers to
; lower the requested cap to the source cardinality.
(= (cap-candidate-pool 8 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 8 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) () $events))
   (candidate-pool $tick ()))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5)
      (make-candidate-for-rule $tick $rule-6))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5)
      (make-candidate-for-rule $tick $rule-6)
      (make-candidate-for-rule $tick $rule-7))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5)
      (make-candidate-for-rule $tick $rule-6)
      (make-candidate-for-rule $tick $rule-7))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11) ($rule-0 $rule-1 $rule-2 $rule-3) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5)
      (make-candidate-for-rule $tick $rule-6)
      (make-candidate-for-rule $tick $rule-7))))


(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5)
      (make-candidate-for-rule $tick $rule-6)
      (make-candidate-for-rule $tick $rule-7))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5)
      (make-candidate-for-rule $tick $rule-6)
      (make-candidate-for-rule $tick $rule-7))))

(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3 $m4 $m5 $m6 $m7 $m8 $m9 $m10 $m11 $m12 $m13 $m14 $m15 $m16) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7) $events))
   (candidate-pool
     $tick
     ((make-candidate-for-rule $tick $rule-0)
      (make-candidate-for-rule $tick $rule-1)
      (make-candidate-for-rule $tick $rule-2)
      (make-candidate-for-rule $tick $rule-3)
      (make-candidate-for-rule $tick $rule-4)
      (make-candidate-for-rule $tick $rule-5)
      (make-candidate-for-rule $tick $rule-6)
      (make-candidate-for-rule $tick $rule-7))))

(= (bounded-candidate-pool $cap $chamber)
   (let $generated-pool (generate-candidate-pool $chamber)
     (candidate-pool
       (candidate-pool-tick $generated-pool)
       (cap-candidate-pool
         (effective-candidate-cap-per-tick $cap)
         $generated-pool))))

; Generic deterministic firing for the exp00 state shape:
;   A + B --Cat--> AB
; Preconditions such as positive abundance are intentionally not yet modeled as
; search/filter logic; exp00 only fixes the replayable transformation contract.
(= (fire-binary-catalytic
      (rule $id $a $b $product $catalyst)
      (state $tick $seed
             (mol $a $a-count)
             (mol $b $b-count)
             (mol $product $product-count)
             (mol $catalyst $catalyst-count)))
   (trace
     (state (+ $tick 1) $seed
            (mol $a (- $a-count 1))
            (mol $b (- $b-count 1))
            (mol $product (+ $product-count 1))
            (mol $catalyst $catalyst-count))
     (make-event $tick (rule $id $a $b $product $catalyst))))

(= (replay-trace-ok? $rule $before $expected)
   (== (fire-binary-catalytic $rule $before) $expected))

(= (replay-chamber-ok? $candidate $before $expected)
   (== (chamber-tick-with-candidate $before $candidate) $expected))

(= (fire-candidate $candidate $state)
   (fire-binary-catalytic (candidate-rule $candidate) $state))

(= (candidate-applicable?
      (candidate $candidate-tick (rule $id $a $b $product $catalyst) $score)
      (state $state-tick $seed
             (mol $a $a-count)
             (mol $b $b-count)
             (mol $product $product-count)
             (mol $catalyst $catalyst-count)))
   (and (== $candidate-tick $state-tick)
        (and (> $a-count 0)
             (and (> $b-count 0)
                  (> $catalyst-count 0)))))

(= (safe-fire-candidate $candidate $state)
   (if (candidate-applicable? $candidate $state)
       (fire-candidate $candidate $state)
       (blocked $candidate $state not-applicable)))

; External/scored pools may only fire rewrites that belong to the chamber.
; Keep rejected selections visible in provenance at the same safety boundary as
; stale or starved candidates. The bounded kernel supports up to eight rules.
; Stable rule identity alone is not enough for externally scored pools: a
; candidate must preserve the chamber rule's reactants and product. Scoring
; layers may still reassign only the catalyst (as exp05 does).
(= (same-rule-rewrite?
      (rule $candidate-id $candidate-a $candidate-b $candidate-product $candidate-catalyst)
      (rule $source-id $source-a $source-b $source-product $source-catalyst))
   (and (== $candidate-id $source-id)
        (and (== $candidate-a $source-a)
             (and (== $candidate-b $source-b)
                  (== $candidate-product $source-product)))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule ()) False)

(= (rule-rewrite-in-chamber-rules? $candidate-rule ($rule-0))
   (same-rule-rewrite? $candidate-rule $rule-0))

(= (rule-rewrite-in-chamber-rules? $candidate-rule ($rule-0 $rule-1))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (same-rule-rewrite? $candidate-rule $rule-1)))

(= (rule-rewrite-in-chamber-rules? $candidate-rule ($rule-0 $rule-1 $rule-2))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (same-rule-rewrite? $candidate-rule $rule-2))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (same-rule-rewrite? $candidate-rule $rule-3)))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (or (same-rule-rewrite? $candidate-rule $rule-3)
                   (same-rule-rewrite? $candidate-rule $rule-4))))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (or (same-rule-rewrite? $candidate-rule $rule-3)
                   (or (same-rule-rewrite? $candidate-rule $rule-4)
                       (same-rule-rewrite? $candidate-rule $rule-5)))))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (or (same-rule-rewrite? $candidate-rule $rule-3)
                   (or (same-rule-rewrite? $candidate-rule $rule-4)
                       (or (same-rule-rewrite? $candidate-rule $rule-5)
                           (same-rule-rewrite? $candidate-rule $rule-6))))))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (or (same-rule-rewrite? $candidate-rule $rule-3)
                   (or (same-rule-rewrite? $candidate-rule $rule-4)
                       (or (same-rule-rewrite? $candidate-rule $rule-5)
                           (or (same-rule-rewrite? $candidate-rule $rule-6)
                               (same-rule-rewrite? $candidate-rule $rule-7)))))))))

(= (candidate-applicable-in-chamber?
      (candidate $tick $candidate-rule $score)
      (chamber $id $state $rules $events))
   (and (candidate-applicable?
          (candidate $tick $candidate-rule $score)
          $state)
        (rule-rewrite-in-chamber-rules? $candidate-rule $rules)))

(= (safe-fire-candidate-in-chamber
      $candidate
      (chamber $id $state $rules $events))
   (if (candidate-applicable-in-chamber?
         $candidate
         (chamber $id $state $rules $events))
       (fire-candidate $candidate $state)
       (blocked $candidate $state not-applicable)))

(= (trace-nonnegative? $trace)
   (state-nonnegative? (trace-state $trace)))

; Convert safe firing outcomes into chamber transitions. An inapplicable
; deterministic selection remains inspectable in provenance but is a no-op:
; it cannot create negative abundance or a fictitious event.
; Successful ticks append to existing chamber history rather than replacing
; it. The base kernel keeps the same explicit bounded-list style as candidate
; pools and chamber rules.
(= (append-chamber-event () $event)
   ($event))

(= (append-chamber-event ($event-0) $event)
   ($event-0 $event))

(= (append-chamber-event ($event-0 $event-1) $event)
   ($event-0 $event-1 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2) $event)
   ($event-0 $event-1 $event-2 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3) $event)
   ($event-0 $event-1 $event-2 $event-3 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event))

(= (chamber-tick-with-fire-result
      (chamber $id $state $rules $events)
      (trace $after-state $event))
   (chamber $id $after-state $rules (append-chamber-event $events $event)))

(= (chamber-tick-with-fire-result
      $chamber
      (blocked $candidate $state not-applicable))
   $chamber)

(= (chamber-tick-with-candidate
      (chamber $id $state $rules $events)
      $candidate)
   (chamber-tick-with-fire-result
     (chamber $id $state $rules $events)
     (safe-fire-candidate-in-chamber
       $candidate
       (chamber $id $state $rules $events))))

; 1-candidate deterministic selection from a bounded pool.
(= (selected-candidate-from-list-1
      (chamber $id $state $rules $events)
      ($candidate-0))
   $candidate-0)

(= (chamber-tick-candidate-pool-1 $cap $chamber $candidate-pool)
   (chamber-tick-candidate-pool $cap $chamber $candidate-pool))

(= (chamber-tick-generated-1 $cap $chamber)
   (chamber-tick-generated $cap $chamber))

(= (selected-candidate-from-chamber-2
      (chamber $id $state $rules $events)
      $candidate-0
      $candidate-1)
   (select-candidate-2
     (state-seed $state)
     (state-tick $state)
     $candidate-0
     $candidate-1))

(= (selected-candidate-from-list-2
      (chamber $id $state $rules $events)
      ($candidate-0 $candidate-1))
   (select-candidate-2
     (state-seed $state)
     (state-tick $state)
     $candidate-0
     $candidate-1))

(= (chamber-tick-select-2
      $chamber
      $candidate-0
      $candidate-1)
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-chamber-2 $chamber $candidate-0 $candidate-1)))

; Direct deterministic chamber tick from an already generated candidate pool.
; This keeps affinity/scoring producers outside the generic generator while
; making bounded cap -> seeded selection -> firing one kernel operation.
(= (chamber-tick-candidate-pool-2 $cap $chamber $candidate-pool)
   (chamber-tick-candidate-pool $cap $chamber $candidate-pool))

(= (chamber-tick-generated-2 $cap $chamber)
   (chamber-tick-generated $cap $chamber))

; 3-candidate deterministic selection from a bounded pool.
(= (selected-candidate-from-list-3
      (chamber $id $state $rules $events)
      ($candidate-0 $candidate-1 $candidate-2))
   (select-candidate-3
     (state-seed $state)
     (state-tick $state)
     $candidate-0
     $candidate-1
     $candidate-2))

(= (chamber-tick-candidate-pool-3 $cap $chamber $candidate-pool)
   (chamber-tick-candidate-pool $cap $chamber $candidate-pool))

(= (chamber-tick-generated-3 $cap $chamber)
   (chamber-tick-generated $cap $chamber))

; 4-candidate deterministic selection from a bounded pool.
(= (selected-candidate-from-list-4
      (chamber $id $state $rules $events)
      ($candidate-0 $candidate-1 $candidate-2 $candidate-3))
   (select-candidate-4
     (state-seed $state)
     (state-tick $state)
     $candidate-0
     $candidate-1
     $candidate-2
     $candidate-3))

(= (chamber-tick-candidate-pool-4 $cap $chamber $candidate-pool)
   (chamber-tick-candidate-pool $cap $chamber $candidate-pool))

(= (chamber-tick-generated-4 $cap $chamber)
   (chamber-tick-generated $cap $chamber))

; 5-candidate deterministic selection from a bounded pool.
(= (selected-candidate-from-list-5
      (chamber $id $state $rules $events)
      ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))
   (select-candidate-5
     (state-seed $state)
     (state-tick $state)
     $candidate-0
     $candidate-1
     $candidate-2
     $candidate-3
     $candidate-4))

(= (chamber-tick-candidate-pool-5 $cap $chamber $candidate-pool)
   (chamber-tick-candidate-pool $cap $chamber $candidate-pool))

(= (chamber-tick-generated-5 $cap $chamber)
   (chamber-tick-generated $cap $chamber))

; 6-candidate deterministic selection from a bounded pool.
(= (selected-candidate-from-list-6
      (chamber $id $state $rules $events)
      ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5))
   (select-candidate-6
     (state-seed $state)
     (state-tick $state)
     $candidate-0
     $candidate-1
     $candidate-2
     $candidate-3
     $candidate-4
     $candidate-5))

(= (chamber-tick-candidate-pool-6 $cap $chamber $candidate-pool)
   (chamber-tick-candidate-pool $cap $chamber $candidate-pool))

(= (chamber-tick-generated-6 $cap $chamber)
   (chamber-tick-generated $cap $chamber))

; 7-candidate deterministic selection from a bounded pool.
(= (selected-candidate-from-list-7
      (chamber $id $state $rules $events)
      ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6))
   (select-candidate-7
     (state-seed $state)
     (state-tick $state)
     $candidate-0
     $candidate-1
     $candidate-2
     $candidate-3
     $candidate-4
     $candidate-5
     $candidate-6))

(= (chamber-tick-candidate-pool-7 $cap $chamber $candidate-pool)
   (chamber-tick-candidate-pool $cap $chamber $candidate-pool))

(= (chamber-tick-generated-7 $cap $chamber)
   (chamber-tick-generated $cap $chamber))

; 8-candidate deterministic selection from a bounded pool.
(= (selected-candidate-from-list-8
      (chamber $id $state $rules $events)
      ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7))
   (select-candidate-8
     (state-seed $state)
     (state-tick $state)
     $candidate-0
     $candidate-1
     $candidate-2
     $candidate-3
     $candidate-4
     $candidate-5
     $candidate-6
     $candidate-7))

(= (chamber-tick-candidate-pool-8 $cap $chamber $candidate-pool)
   (chamber-tick-candidate-pool $cap $chamber $candidate-pool))

(= (chamber-tick-generated-8 $cap $chamber)
   (chamber-tick-generated $cap $chamber))

; Generic bounded candidate-pool tick. Dispatch on the actual bounded pool
; cardinality, so a requested cap may safely exceed a smaller source pool.
; Empty pools expose an explicit no-candidate result instead of leaving the
; cap -> selection path irreducible.
(= (selected-candidate-from-bounded-list $chamber ())
   no-candidate)

(= (selected-candidate-from-bounded-list $chamber ($candidate-0))
   (selected-candidate-from-list-1 $chamber ($candidate-0)))

(= (selected-candidate-from-bounded-list $chamber ($candidate-0 $candidate-1))
   (selected-candidate-from-list-2 $chamber ($candidate-0 $candidate-1)))

(= (selected-candidate-from-bounded-list $chamber ($candidate-0 $candidate-1 $candidate-2))
   (selected-candidate-from-list-3 $chamber ($candidate-0 $candidate-1 $candidate-2)))

(= (selected-candidate-from-bounded-list $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3))
   (selected-candidate-from-list-4 $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))

(= (selected-candidate-from-bounded-list $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4))
   (selected-candidate-from-list-5 $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4)))

(= (selected-candidate-from-bounded-list $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5))
   (selected-candidate-from-list-6 $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5)))

(= (selected-candidate-from-bounded-list $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6))
   (selected-candidate-from-list-7 $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6)))

(= (selected-candidate-from-bounded-list $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7))
   (selected-candidate-from-list-8 $chamber ($candidate-0 $candidate-1 $candidate-2 $candidate-3 $candidate-4 $candidate-5 $candidate-6 $candidate-7)))

; Preserve the bounded pool and deterministic choice in one inspectable atom.
; This is the provenance object consumed directly by generic chamber ticking.
(= (candidate-selection-bounded-pool
      (candidate-selection $cap $bounded-pool $selected-candidate))
   $bounded-pool)

(= (candidate-selection-selected
      (candidate-selection $cap $bounded-pool $selected-candidate))
   $selected-candidate)

; Bind the cap and bounded pool once before selecting. The provenance object and
; selector therefore consume the exact same bounded value rather than relying
; on repeated deterministic reconstruction.
(= (candidate-selection-from-pool $cap $chamber $candidate-pool)
   (let $candidate-cap (effective-candidate-cap-per-tick $cap)
     (let $bounded-pool (cap-candidate-pool $candidate-cap $candidate-pool)
       (candidate-selection
         $candidate-cap
         $bounded-pool
         (selected-candidate-from-bounded-list $chamber $bounded-pool)))))

; Expose the exact candidate selected from an external/generated pool before
; firing, while preserving the same cap and seed/tick semantics as ticking.
(= (selected-candidate-from-pool $cap $chamber $candidate-pool)
   (candidate-selection-selected
     (candidate-selection-from-pool $cap $chamber $candidate-pool)))

(= (selection-fire-record-selection
      (selection-fire-record $selection $after-chamber))
   $selection)

(= (selection-fire-record-after-chamber
      (selection-fire-record $selection $after-chamber))
   $after-chamber)

; Empty bounded pools suppress firing without inventing an event or state
; transition. Non-empty selections continue through ordinary chamber firing.
(= (chamber-tick-with-selection $chamber no-candidate)
   $chamber)

(= (chamber-tick-with-selection
      $chamber
      (candidate $tick $rule $score))
   (chamber-tick-with-candidate
     $chamber
     (candidate $tick $rule $score)))

; Candidate-pool provenance is tick-scoped independently of each candidate.
; A malformed external/scored pool whose envelope tick does not match the
; chamber cannot mutate that chamber, even if its selected candidate claims
; the current tick. Keep the complete selection visible for inspection.
(= (candidate-pool-current-for-chamber?
      (candidate-pool $pool-tick $candidates)
      (chamber $id $state $rules $events))
   (== $pool-tick (state-tick $state)))

(= (chamber-tick-with-pool-selection
      $chamber
      $candidate-pool
      $selected-candidate)
   (if (candidate-pool-current-for-chamber? $candidate-pool $chamber)
       (chamber-tick-with-selection $chamber $selected-candidate)
       $chamber))

; Keep the complete bounded-selection provenance beside the chamber produced
; by firing that exact selected candidate. Generic ticking is a projection of
; this object, so selection and firing cannot silently take separate paths.
(= (selection-fire-record-from-pool $cap $chamber $candidate-pool)
   (let $selection
        (candidate-selection-from-pool $cap $chamber $candidate-pool)
     (selection-fire-record
       $selection
       (chamber-tick-with-pool-selection
         $chamber
         $candidate-pool
         (candidate-selection-selected $selection)))))

(= (chamber-tick-candidate-pool $cap $chamber $candidate-pool)
   (selection-fire-record-after-chamber
     (selection-fire-record-from-pool $cap $chamber $candidate-pool)))

(= (generated-selection-fire-record-pool
      (generated-selection-fire-record $generated-pool $selection-fire-record))
   $generated-pool)

(= (generated-selection-fire-record-selection-fire
      (generated-selection-fire-record $generated-pool $selection-fire-record))
   $selection-fire-record)

(= (generated-selection-fire-record-bounded-pool
      (generated-selection-fire-record $generated-pool $selection-fire-record))
   (candidate-selection-bounded-pool
     (selection-fire-record-selection $selection-fire-record)))

(= (generated-selection-fire-record-selected
      (generated-selection-fire-record $generated-pool $selection-fire-record))
   (candidate-selection-selected
     (selection-fire-record-selection $selection-fire-record)))

(= (generated-selection-fire-record-after-chamber
      (generated-selection-fire-record $generated-pool $selection-fire-record))
   (selection-fire-record-after-chamber $selection-fire-record))

; Preserve the uncapped generated pool as well as the bounded selection and
; fired chamber. This makes candidate generation, capping, deterministic
; selection, and ticking one inspectable PeTTa-native provenance chain.
(= (generated-selection-fire-record-from-chamber $cap $chamber)
   (let $generated-pool (generate-candidate-pool $chamber)
     (generated-selection-fire-record
       $generated-pool
       (selection-fire-record-from-pool $cap $chamber $generated-pool))))

(= (chamber-tick-generated $cap $chamber)
   (generated-selection-fire-record-after-chamber
     (generated-selection-fire-record-from-chamber $cap $chamber)))

; ----- exp00 fixture -----

(= (exp00-rule r0)
   (rule r0 A B AB Cat))

(= (exp00-rule r1)
   (rule r1 B Cat BCat A))

(= (exp00-rule r2)
   (rule r2 A Cat ACat B))

(= (exp00-initial-state seed-7)
   (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))

(= (exp00-candidate $seed)
   (make-candidate 0 (exp00-rule r0) 1))

(= (exp00-distractor-candidate $seed)
   (make-candidate 0 (exp00-rule r1) 1))

(= (exp00-third-candidate $seed)
   (make-candidate 0 (exp00-rule r2) 1))

(= (exp00-rules)
   ((exp00-rule r1)
    (exp00-rule r0)
    (exp00-rule r2)))

(= (exp00-candidate-cap)
   (make-candidate-cap 2 1))

(= (exp00-candidate-cap-3)
   (make-candidate-cap 3 1))

(= (exp00-candidate-cap-4)
   (make-candidate-cap 4 1))

(= (exp00-candidate-cap-5)
   (make-candidate-cap 5 1))

(= (exp00-candidate-cap-6)
   (make-candidate-cap 6 1))

(= (exp00-candidate-cap-7)
   (make-candidate-cap 7 1))

(= (exp00-candidate-cap-8)
   (make-candidate-cap 8 1))

(= (exp00-generated-candidate-pool $seed)
   (generate-candidate-pool (exp00-initial-chamber $seed)))

(= (exp00-capped-candidate-pool $seed)
   (bounded-candidate-pool
     (exp00-candidate-cap)
     (exp00-initial-chamber $seed)))

(= (exp00-capped-candidates-2 $seed)
   (candidate-pool-candidates (exp00-capped-candidate-pool $seed)))

(= (exp00-sampled-candidate $seed)
   (select-candidate-2
     $seed
     0
     (exp00-distractor-candidate $seed)
     (exp00-candidate $seed)))

(= (exp00-starved-state seed-7)
   (state 0 seed-7 (mol A 0) (mol B 1) (mol AB 0) (mol Cat 1)))

(= (exp00-initial-chamber seed-7)
   (make-chamber exp00
                 (exp00-initial-state seed-7)
                 (exp00-rules)
                 ()))

(= (exp00-expected-trace seed-7)
   (trace
     (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
     (event 0 r0 A B AB Cat)))

(= (fire-exp00-r0 $state)
   (fire-binary-catalytic (exp00-rule r0) $state))

(= (exp00-run seed-7)
   (fire-exp00-r0 (exp00-initial-state seed-7)))

(= (exp00-final-state seed-7)
   (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1)))

(= (exp00-event-log seed-7)
   ((event 0 r0 A B AB Cat)))

(= (exp00-chamber-after-one-tick seed-7)
   (chamber-tick-with-candidate
     (exp00-initial-chamber seed-7)
     (exp00-candidate seed-7)))

(= (exp00-chamber-after-selected-tick seed-7)
   (chamber-tick-select-2
     (exp00-initial-chamber seed-7)
     (exp00-distractor-candidate seed-7)
     (exp00-candidate seed-7)))

(= (exp00-chamber-after-generated-tick seed-7)
   (chamber-tick-generated-2
     (exp00-candidate-cap)
     (exp00-initial-chamber seed-7)))

; Minimal analytic predicates for the first smoke.  These are deliberately
; conservative; real ACS/RAF-like logic belongs in exp01 after the atom contract
; and replay discipline are stable.
(= (exp00-product-abundance seed-7)
   (mol-abundance (mol AB 1)))

(= (exp00-product-metric seed-7)
   (make-metric product-abundance AB (exp00-product-abundance seed-7)))

(= (exp00-catalyst-preserved? seed-7)
   (== (mol-abundance (mol Cat 1)) 1))

(= (exp00-replay-ok? seed-7)
   (replay-trace-ok?
     (exp00-rule r0)
     (exp00-initial-state seed-7)
     (exp00-expected-trace seed-7)))

(= (exp00-chamber-replay-ok? seed-7)
   (replay-chamber-ok?
     (exp00-candidate seed-7)
     (exp00-initial-chamber seed-7)
     (exp00-chamber-after-generated-tick seed-7)))

(= (exp00-generated-replay-equivalent? seed-7)
   (== (exp00-chamber-after-generated-tick seed-7)
       (exp00-chamber-after-one-tick seed-7)))
