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
   (candidate-pool
     (candidate-pool-tick (generate-candidate-pool $chamber))
     (cap-candidate-pool
       (candidate-cap-per-tick $cap)
       (generate-candidate-pool $chamber))))

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
      (candidate $tick (rule $id $a $b $product $catalyst) $score)
      (state $tick $seed
             (mol $a $a-count)
             (mol $b $b-count)
             (mol $product $product-count)
             (mol $catalyst $catalyst-count)))
   (and (> $a-count 0)
        (and (> $b-count 0)
             (> $catalyst-count 0))))

(= (safe-fire-candidate $candidate $state)
   (if (candidate-applicable? $candidate $state)
       (fire-candidate $candidate $state)
       (blocked $candidate $state not-applicable)))

(= (trace-nonnegative? $trace)
   (state-nonnegative? (trace-state $trace)))

(= (chamber-tick-with-candidate
      (chamber $id $state $rules $events)
      $candidate)
   (let $trace (fire-candidate $candidate $state)
     (chamber $id
              (trace-state $trace)
              $rules
              ((trace-event $trace)))))

; 1-candidate deterministic selection from a bounded pool.
(= (selected-candidate-from-list-1
      (chamber $id $state $rules $events)
      ($candidate-0))
   $candidate-0)

(= (chamber-tick-candidate-pool-1 $cap $chamber $candidate-pool)
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-list-1
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

(= (chamber-tick-generated-1 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-candidate-pool-1 $cap $chamber $candidate-pool)))

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
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-list-2
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

(= (chamber-tick-generated-2 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-candidate-pool-2 $cap $chamber $candidate-pool)))

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
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-list-3
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

(= (chamber-tick-generated-3 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-candidate-pool-3 $cap $chamber $candidate-pool)))

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
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-list-4
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

(= (chamber-tick-generated-4 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-candidate-pool-4 $cap $chamber $candidate-pool)))

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
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-list-5
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

(= (chamber-tick-generated-5 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-candidate-pool-5 $cap $chamber $candidate-pool)))

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
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-list-6
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

(= (chamber-tick-generated-6 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-candidate-pool-6 $cap $chamber $candidate-pool)))

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
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-list-7
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

(= (chamber-tick-generated-7 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-candidate-pool-7 $cap $chamber $candidate-pool)))

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
   (chamber-tick-with-candidate
     $chamber
     (selected-candidate-from-list-8
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

(= (chamber-tick-generated-8 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-candidate-pool-8 $cap $chamber $candidate-pool)))

; Generic bounded candidate-pool tick. Dispatch on the actual bounded pool
; cardinality, so a requested cap may safely exceed a smaller source pool.
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

(= (candidate-selection-from-pool $cap $chamber $candidate-pool)
   (candidate-selection
     (candidate-cap-per-tick $cap)
     (cap-candidate-pool
       (candidate-cap-per-tick $cap)
       $candidate-pool)
     (selected-candidate-from-bounded-list
       $chamber
       (cap-candidate-pool
         (candidate-cap-per-tick $cap)
         $candidate-pool))))

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

; Keep the complete bounded-selection provenance beside the chamber produced
; by firing that exact selected candidate. Generic ticking is a projection of
; this object, so selection and firing cannot silently take separate paths.
(= (selection-fire-record-from-pool $cap $chamber $candidate-pool)
   (selection-fire-record
     (candidate-selection-from-pool $cap $chamber $candidate-pool)
     (chamber-tick-with-candidate
       $chamber
       (candidate-selection-selected
         (candidate-selection-from-pool $cap $chamber $candidate-pool)))))

(= (chamber-tick-candidate-pool $cap $chamber $candidate-pool)
   (selection-fire-record-after-chamber
     (selection-fire-record-from-pool $cap $chamber $candidate-pool)))

(= (chamber-tick-generated $cap $chamber)
   (chamber-tick-candidate-pool
     $cap
     $chamber
     (generate-candidate-pool $chamber)))

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
