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

; Frozen exp07 ordered-replication cohorts.  Keeping these names explicit
; makes registered draw arithmetic reducible and auditable in PeTTa.
(= (seed-number seed-101) 101)
(= (seed-number seed-102) 102)
(= (seed-number seed-103) 103)
(= (seed-number seed-104) 104)
(= (seed-number seed-105) 105)
(= (seed-number seed-106) 106)
(= (seed-number seed-107) 107)
(= (seed-number seed-108) 108)
(= (seed-number seed-109) 109)
(= (seed-number seed-110) 110)
(= (seed-number seed-111) 111)
(= (seed-number seed-112) 112)
(= (seed-number seed-113) 113)
(= (seed-number seed-114) 114)
(= (seed-number seed-115) 115)
(= (seed-number seed-116) 116)
(= (seed-number seed-117) 117)
(= (seed-number seed-118) 118)
(= (seed-number seed-119) 119)
(= (seed-number seed-120) 120)
(= (seed-number seed-121) 121)
(= (seed-number seed-122) 122)
(= (seed-number seed-123) 123)
(= (seed-number seed-124) 124)
(= (seed-number seed-125) 125)
(= (seed-number seed-126) 126)
(= (seed-number seed-127) 127)
(= (seed-number seed-128) 128)
(= (seed-number seed-129) 129)
(= (seed-number seed-130) 130)
(= (seed-number seed-131) 131)
(= (seed-number seed-132) 132)
(= (seed-number seed-201) 201)
(= (seed-number seed-202) 202)
(= (seed-number seed-203) 203)
(= (seed-number seed-204) 204)
(= (seed-number seed-205) 205)
(= (seed-number seed-206) 206)
(= (seed-number seed-207) 207)
(= (seed-number seed-208) 208)
(= (seed-number seed-209) 209)
(= (seed-number seed-210) 210)
(= (seed-number seed-211) 211)
(= (seed-number seed-212) 212)
(= (seed-number seed-213) 213)
(= (seed-number seed-214) 214)
(= (seed-number seed-215) 215)
(= (seed-number seed-216) 216)
(= (seed-number seed-217) 217)
(= (seed-number seed-218) 218)
(= (seed-number seed-219) 219)
(= (seed-number seed-220) 220)
(= (seed-number seed-221) 221)
(= (seed-number seed-222) 222)
(= (seed-number seed-223) 223)
(= (seed-number seed-224) 224)
(= (seed-number seed-225) 225)
(= (seed-number seed-226) 226)
(= (seed-number seed-227) 227)
(= (seed-number seed-228) 228)
(= (seed-number seed-229) 229)
(= (seed-number seed-230) 230)
(= (seed-number seed-231) 231)
(= (seed-number seed-232) 232)

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

; A named molecule list is the extensible state shape used when matched
; chemistry needs more than the legacy fixed-position smoke fixtures.
(= (state-tick (state $tick $seed (molecules $molecules)))
   $tick)

(= (state-seed (state $tick $seed (molecules $molecules)))
   $seed)

(= (molecule-abundance-7 $name
      ((mol $n0 $a0) (mol $n1 $a1) (mol $n2 $a2) (mol $n3 $a3)
       (mol $n4 $a4) (mol $n5 $a5) (mol $n6 $a6)))
   (if (== $name $n0) $a0
       (if (== $name $n1) $a1
           (if (== $name $n2) $a2
               (if (== $name $n3) $a3
                   (if (== $name $n4) $a4
                       (if (== $name $n5) $a5
                           (if (== $name $n6) $a6 0))))))))

; Ordered-bootstrap exp07 uses twelve named species.  Keep this on the same
; generic named-molecule seam as the seven- and thirteen-species chambers.
(= (molecule-abundance-7 $name
      ((mol $n0 $a0) (mol $n1 $a1) (mol $n2 $a2) (mol $n3 $a3)
       (mol $n4 $a4) (mol $n5 $a5) (mol $n6 $a6) (mol $n7 $a7)
       (mol $n8 $a8) (mol $n9 $a9) (mol $n10 $a10) (mol $n11 $a11)))
   (if (== $name $n0) $a0
       (if (== $name $n1) $a1
           (if (== $name $n2) $a2
               (if (== $name $n3) $a3
                   (if (== $name $n4) $a4
                       (if (== $name $n5) $a5
                           (if (== $name $n6) $a6
                               (if (== $name $n7) $a7
                                   (if (== $name $n8) $a8
                                       (if (== $name $n9) $a9
                                           (if (== $name $n10) $a10
                                               (if (== $name $n11) $a11 0)))))))))))))

; Keep the named-molecule kernel total for the preregistered exp07 rich
; chamber.  The operation name is retained for compatibility with the original
; seven-species seam; dispatch is by the concrete list shape.
(= (molecule-abundance-7 $name
      ((mol $n0 $a0) (mol $n1 $a1) (mol $n2 $a2) (mol $n3 $a3)
       (mol $n4 $a4) (mol $n5 $a5) (mol $n6 $a6) (mol $n7 $a7)
       (mol $n8 $a8) (mol $n9 $a9) (mol $n10 $a10) (mol $n11 $a11)
       (mol $n12 $a12)))
   (if (== $name $n0) $a0
       (if (== $name $n1) $a1
           (if (== $name $n2) $a2
               (if (== $name $n3) $a3
                   (if (== $name $n4) $a4
                       (if (== $name $n5) $a5
                           (if (== $name $n6) $a6
                               (if (== $name $n7) $a7
                                   (if (== $name $n8) $a8
                                       (if (== $name $n9) $a9
                                           (if (== $name $n10) $a10
                                               (if (== $name $n11) $a11
                                                   (if (== $name $n12) $a12 0))))))))))))))

; The dual-bootstrap exp07 chemistry has seventeen named species.  Keep the
; state transition on the same PeTTa-native named-molecule kernel.
(= (molecule-abundance-7 $name
      ((mol $n0 $a0) (mol $n1 $a1) (mol $n2 $a2) (mol $n3 $a3)
       (mol $n4 $a4) (mol $n5 $a5) (mol $n6 $a6) (mol $n7 $a7)
       (mol $n8 $a8) (mol $n9 $a9) (mol $n10 $a10) (mol $n11 $a11)
       (mol $n12 $a12) (mol $n13 $a13) (mol $n14 $a14)
       (mol $n15 $a15) (mol $n16 $a16)))
   (if (== $name $n0) $a0
       (if (== $name $n1) $a1
           (if (== $name $n2) $a2
               (if (== $name $n3) $a3
                   (if (== $name $n4) $a4
                       (if (== $name $n5) $a5
                           (if (== $name $n6) $a6
                               (if (== $name $n7) $a7
                                   (if (== $name $n8) $a8
                                       (if (== $name $n9) $a9
                                           (if (== $name $n10) $a10
                                               (if (== $name $n11) $a11
                                                   (if (== $name $n12) $a12
                                                       (if (== $name $n13) $a13
                                                           (if (== $name $n14) $a14
                                                               (if (== $name $n15) $a15
                                                                   (if (== $name $n16) $a16 0))))))))))))))))))

(= (reaction-abundance-delta $name $a $b $product)
   (if (== $name $a)
       -1
       (if (== $name $b)
           -1
           (if (== $name $product) 1 0))))

(= (update-reaction-molecule (mol $name $abundance) $a $b $product)
   (mol $name (+ $abundance
                 (reaction-abundance-delta $name $a $b $product))))

(= (update-reaction-molecules-7
      ((mol $n0 $a0) (mol $n1 $a1) (mol $n2 $a2) (mol $n3 $a3)
       (mol $n4 $a4) (mol $n5 $a5) (mol $n6 $a6))
      $a $b $product)
   ((update-reaction-molecule (mol $n0 $a0) $a $b $product)
    (update-reaction-molecule (mol $n1 $a1) $a $b $product)
    (update-reaction-molecule (mol $n2 $a2) $a $b $product)
    (update-reaction-molecule (mol $n3 $a3) $a $b $product)
    (update-reaction-molecule (mol $n4 $a4) $a $b $product)
    (update-reaction-molecule (mol $n5 $a5) $a $b $product)
    (update-reaction-molecule (mol $n6 $a6) $a $b $product)))

(= (update-reaction-molecules-7
      ((mol $n0 $a0) (mol $n1 $a1) (mol $n2 $a2) (mol $n3 $a3)
       (mol $n4 $a4) (mol $n5 $a5) (mol $n6 $a6) (mol $n7 $a7)
       (mol $n8 $a8) (mol $n9 $a9) (mol $n10 $a10) (mol $n11 $a11))
      $a $b $product)
   ((update-reaction-molecule (mol $n0 $a0) $a $b $product)
    (update-reaction-molecule (mol $n1 $a1) $a $b $product)
    (update-reaction-molecule (mol $n2 $a2) $a $b $product)
    (update-reaction-molecule (mol $n3 $a3) $a $b $product)
    (update-reaction-molecule (mol $n4 $a4) $a $b $product)
    (update-reaction-molecule (mol $n5 $a5) $a $b $product)
    (update-reaction-molecule (mol $n6 $a6) $a $b $product)
    (update-reaction-molecule (mol $n7 $a7) $a $b $product)
    (update-reaction-molecule (mol $n8 $a8) $a $b $product)
    (update-reaction-molecule (mol $n9 $a9) $a $b $product)
    (update-reaction-molecule (mol $n10 $a10) $a $b $product)
    (update-reaction-molecule (mol $n11 $a11) $a $b $product)))

(= (update-reaction-molecules-7
      ((mol $n0 $a0) (mol $n1 $a1) (mol $n2 $a2) (mol $n3 $a3)
       (mol $n4 $a4) (mol $n5 $a5) (mol $n6 $a6) (mol $n7 $a7)
       (mol $n8 $a8) (mol $n9 $a9) (mol $n10 $a10) (mol $n11 $a11)
       (mol $n12 $a12))
      $a $b $product)
   ((update-reaction-molecule (mol $n0 $a0) $a $b $product)
    (update-reaction-molecule (mol $n1 $a1) $a $b $product)
    (update-reaction-molecule (mol $n2 $a2) $a $b $product)
    (update-reaction-molecule (mol $n3 $a3) $a $b $product)
    (update-reaction-molecule (mol $n4 $a4) $a $b $product)
    (update-reaction-molecule (mol $n5 $a5) $a $b $product)
    (update-reaction-molecule (mol $n6 $a6) $a $b $product)
    (update-reaction-molecule (mol $n7 $a7) $a $b $product)
    (update-reaction-molecule (mol $n8 $a8) $a $b $product)
    (update-reaction-molecule (mol $n9 $a9) $a $b $product)
    (update-reaction-molecule (mol $n10 $a10) $a $b $product)
    (update-reaction-molecule (mol $n11 $a11) $a $b $product)
    (update-reaction-molecule (mol $n12 $a12) $a $b $product)))

(= (update-reaction-molecules-7
      ((mol $n0 $a0) (mol $n1 $a1) (mol $n2 $a2) (mol $n3 $a3)
       (mol $n4 $a4) (mol $n5 $a5) (mol $n6 $a6) (mol $n7 $a7)
       (mol $n8 $a8) (mol $n9 $a9) (mol $n10 $a10) (mol $n11 $a11)
       (mol $n12 $a12) (mol $n13 $a13) (mol $n14 $a14)
       (mol $n15 $a15) (mol $n16 $a16))
      $a $b $product)
   ((update-reaction-molecule (mol $n0 $a0) $a $b $product)
    (update-reaction-molecule (mol $n1 $a1) $a $b $product)
    (update-reaction-molecule (mol $n2 $a2) $a $b $product)
    (update-reaction-molecule (mol $n3 $a3) $a $b $product)
    (update-reaction-molecule (mol $n4 $a4) $a $b $product)
    (update-reaction-molecule (mol $n5 $a5) $a $b $product)
    (update-reaction-molecule (mol $n6 $a6) $a $b $product)
    (update-reaction-molecule (mol $n7 $a7) $a $b $product)
    (update-reaction-molecule (mol $n8 $a8) $a $b $product)
    (update-reaction-molecule (mol $n9 $a9) $a $b $product)
    (update-reaction-molecule (mol $n10 $a10) $a $b $product)
    (update-reaction-molecule (mol $n11 $a11) $a $b $product)
    (update-reaction-molecule (mol $n12 $a12) $a $b $product)
    (update-reaction-molecule (mol $n13 $a13) $a $b $product)
    (update-reaction-molecule (mol $n14 $a14) $a $b $product)
    (update-reaction-molecule (mol $n15 $a15) $a $b $product)
    (update-reaction-molecule (mol $n16 $a16) $a $b $product)))

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

; Candidate caps are bounded by the base kernel's explicit eight-rule pool.
; Generic generation emits at most one candidate for each source rule, so a
; nonpositive value on either side closes the selection boundary and an
; oversized per-tick allowance clamps to eight rather than leaving an
; unsupported cap irreducible.
(= (effective-candidate-cap-per-tick $cap)
   (if (> (candidate-cap-per-tick $cap) 0)
       (if (> (candidate-cap-per-rule $cap) 0)
           (if (> (candidate-cap-per-tick $cap) 8)
               8
               (candidate-cap-per-tick $cap))
           0)
       0))

; Generic generation emits at most one candidate per source-rule occurrence,
; so every positive per-rule allowance has the same supported effective value.
; A closed per-tick boundary also closes the complete cap rather than retaining
; a misleading positive per-rule allowance in provenance.
(= (effective-candidate-cap-per-rule $cap)
   (if (> (candidate-cap-per-tick $cap) 0)
       (if (> (candidate-cap-per-rule $cap) 0) 1 0)
       0))

(= (effective-candidate-cap $cap)
   (candidate-cap
     (effective-candidate-cap-per-tick $cap)
     (effective-candidate-cap-per-rule $cap)))

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

; The base kernel admits at most eight candidates per generated pool.  Keep
; oversized chamber rule lists total by taking the stable first-eight prefix;
; the ordinary candidate cap may then impose a smaller per-tick bound.
(= (generate-candidate-pool
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7 $rule-8) $events))
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
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7 $rule-8 $rule-9) $events))
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
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7 $rule-8 $rule-9 $rule-10) $events))
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
      (chamber $id (state $tick $seed $m0 $m1 $m2 $m3) ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7 $rule-8 $rule-9 $rule-10 $rule-11) $events))
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

; Extensible named-molecule chambers use the same stable eight-rule generation
; boundary as fixed-position fixtures.  This is the exp07 rich-pool entry point
; and keeps chemistry construction inside PeTTa.
(= (generate-candidate-pool
      (chamber $id (state $tick $seed (molecules $molecules))
               ($rule-0 $rule-1 $rule-2 $rule-3
                $rule-4 $rule-5 $rule-6 $rule-7)
               $events))
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

(= (bounded-candidate-pool-from-generated
      $cap (candidate-pool $tick $candidates))
   (candidate-pool
     $tick
     (cap-candidate-pool
       (effective-candidate-cap-per-tick $cap)
       (candidate-pool $tick $candidates))))

(= (bounded-candidate-pool $cap $chamber)
   (bounded-candidate-pool-from-generated
     $cap (generate-candidate-pool $chamber)))

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
             (mol $state-a $a-count)
             (mol $state-b $b-count)
             (mol $state-product $product-count)
             (mol $state-catalyst $catalyst-count)))
   (and (== $a $state-a)
        (and (== $b $state-b)
             (and (== $product $state-product)
                  (and (== $catalyst $state-catalyst)
                       (and (== $candidate-tick $state-tick)
                            (and (> $a-count 0)
                                 (and (> $b-count 0)
                                      (> $catalyst-count 0)))))))))

(= (candidate-applicable?
      (candidate $candidate-tick (rule $id $a $b $product $catalyst) $score)
      (state $state-tick $seed (molecules $molecules)))
   (and (== $candidate-tick $state-tick)
        (and (> (molecule-abundance-7 $a $molecules) 0)
             (and (> (molecule-abundance-7 $b $molecules) 0)
                  (> (molecule-abundance-7 $catalyst $molecules) 0)))))

(= (fire-binary-catalytic
      (rule $id $a $b $product $catalyst)
      (state $tick $seed (molecules $molecules)))
   (trace
     (state (+ $tick 1) $seed
            (molecules
              (update-reaction-molecules-7 $molecules $a $b $product)))
     (make-event $tick (rule $id $a $b $product $catalyst))))

(= (safe-fire-candidate $candidate $state)
   (if (candidate-applicable? $candidate $state)
       (fire-candidate $candidate $state)
       (blocked $candidate $state not-applicable)))

; External/scored pools may only fire rewrites that belong to the chamber.
; Keep rejected selections visible in provenance at the same safety boundary as
; stale or starved candidates. Generated pools remain bounded to eight even
; when the chamber retains a ninth source rule as provenance.
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

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7 $rule-8))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (or (same-rule-rewrite? $candidate-rule $rule-3)
                   (or (same-rule-rewrite? $candidate-rule $rule-4)
                       (or (same-rule-rewrite? $candidate-rule $rule-5)
                           (or (same-rule-rewrite? $candidate-rule $rule-6)
                               (or (same-rule-rewrite? $candidate-rule $rule-7)
                                   (same-rule-rewrite? $candidate-rule $rule-8))))))))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7 $rule-8 $rule-9))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (or (same-rule-rewrite? $candidate-rule $rule-3)
                   (or (same-rule-rewrite? $candidate-rule $rule-4)
                       (or (same-rule-rewrite? $candidate-rule $rule-5)
                           (or (same-rule-rewrite? $candidate-rule $rule-6)
                               (or (same-rule-rewrite? $candidate-rule $rule-7)
                                   (or (same-rule-rewrite? $candidate-rule $rule-8)
                                       (same-rule-rewrite? $candidate-rule $rule-9)))))))))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7 $rule-8 $rule-9 $rule-10))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (or (same-rule-rewrite? $candidate-rule $rule-3)
                   (or (same-rule-rewrite? $candidate-rule $rule-4)
                       (or (same-rule-rewrite? $candidate-rule $rule-5)
                           (or (same-rule-rewrite? $candidate-rule $rule-6)
                               (or (same-rule-rewrite? $candidate-rule $rule-7)
                                   (or (same-rule-rewrite? $candidate-rule $rule-8)
                                       (or (same-rule-rewrite? $candidate-rule $rule-9)
                                           (same-rule-rewrite? $candidate-rule $rule-10))))))))))))

(= (rule-rewrite-in-chamber-rules? $candidate-rule
      ($rule-0 $rule-1 $rule-2 $rule-3 $rule-4 $rule-5 $rule-6 $rule-7 $rule-8 $rule-9 $rule-10 $rule-11))
   (or (same-rule-rewrite? $candidate-rule $rule-0)
       (or (same-rule-rewrite? $candidate-rule $rule-1)
           (or (same-rule-rewrite? $candidate-rule $rule-2)
               (or (same-rule-rewrite? $candidate-rule $rule-3)
                   (or (same-rule-rewrite? $candidate-rule $rule-4)
                       (or (same-rule-rewrite? $candidate-rule $rule-5)
                           (or (same-rule-rewrite? $candidate-rule $rule-6)
                               (or (same-rule-rewrite? $candidate-rule $rule-7)
                                   (or (same-rule-rewrite? $candidate-rule $rule-8)
                                       (or (same-rule-rewrite? $candidate-rule $rule-9)
                                           (or (same-rule-rewrite? $candidate-rule $rule-10)
                                               (same-rule-rewrite? $candidate-rule $rule-11)))))))))))))

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

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event-19) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event-19 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event-19 $event-20) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event-19 $event-20 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event-19 $event-20 $event-21) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event-19 $event-20 $event-21 $event))

(= (append-chamber-event ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event-19 $event-20 $event-21 $event-22) $event)
   ($event-0 $event-1 $event-2 $event-3 $event-4 $event-5 $event-6 $event-7 $event-8 $event-9 $event-10 $event-11 $event-12 $event-13 $event-14 $event-15 $event-16 $event-17 $event-18 $event-19 $event-20 $event-21 $event-22 $event))

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
(= (candidate-selection-cap
      (candidate-selection $cap $bounded-pool $selected-candidate))
   $cap)

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
      (generated-selection-fire-record $requested-cap $generated-pool $selection-fire-record))
   $generated-pool)

(= (generated-selection-fire-record-requested-cap
      (generated-selection-fire-record $requested-cap $generated-pool $selection-fire-record))
   $requested-cap)

(= (generated-selection-fire-record-requested-per-tick $record)
   (candidate-cap-per-tick
     (generated-selection-fire-record-requested-cap $record)))

(= (generated-selection-fire-record-requested-per-rule $record)
   (candidate-cap-per-rule
     (generated-selection-fire-record-requested-cap $record)))

(= (generated-selection-fire-record-selection-fire
      (generated-selection-fire-record $requested-cap $generated-pool $selection-fire-record))
   $selection-fire-record)

(= (generated-selection-fire-record-bounded-pool
      (generated-selection-fire-record $requested-cap $generated-pool $selection-fire-record))
   (candidate-selection-bounded-pool
     (selection-fire-record-selection $selection-fire-record)))

; Candidate pools are deliberately bounded at eight in the base kernel, so
; their cardinalities can remain explicit and PeTTa-native.
(= (bounded-candidate-list-count ()) 0)
(= (bounded-candidate-list-count ($c0)) 1)
(= (bounded-candidate-list-count ($c0 $c1)) 2)
(= (bounded-candidate-list-count ($c0 $c1 $c2)) 3)
(= (bounded-candidate-list-count ($c0 $c1 $c2 $c3)) 4)
(= (bounded-candidate-list-count ($c0 $c1 $c2 $c3 $c4)) 5)
(= (bounded-candidate-list-count ($c0 $c1 $c2 $c3 $c4 $c5)) 6)
(= (bounded-candidate-list-count ($c0 $c1 $c2 $c3 $c4 $c5 $c6)) 7)
(= (bounded-candidate-list-count ($c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7)) 8)

; Chamber sources may be wider than the base generator's eight-candidate
; boundary. Keep that upstream truncation directly auditable rather than
; conflating it with the later per-tick selection cap.
(= (bounded-chamber-rule-count ()) 0)
(= (bounded-chamber-rule-count ($r0)) 1)
(= (bounded-chamber-rule-count ($r0 $r1)) 2)
(= (bounded-chamber-rule-count ($r0 $r1 $r2)) 3)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3)) 4)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3 $r4)) 5)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3 $r4 $r5)) 6)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3 $r4 $r5 $r6)) 7)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3 $r4 $r5 $r6 $r7)) 8)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3 $r4 $r5 $r6 $r7 $r8)) 9)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3 $r4 $r5 $r6 $r7 $r8 $r9)) 10)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3 $r4 $r5 $r6 $r7 $r8 $r9 $r10)) 11)
(= (bounded-chamber-rule-count ($r0 $r1 $r2 $r3 $r4 $r5 $r6 $r7 $r8 $r9 $r10 $r11)) 12)

(= (chamber-source-rule-count (chamber $id $state $rules $events))
   (bounded-chamber-rule-count $rules))

; The base generator materializes at most the first eight source rules. Expose
; that boundary directly so audit consumers do not have to infer it from a
; truncated fixture or duplicate the kernel constant.
(= (generated-selection-fire-record-generation-cap $record) 8)

; Report unused generator capacity separately from omitted source rules. A
; complete narrow source has open slots, while a source at or beyond the
; first-eight boundary has none.
(= (generated-selection-fire-record-generation-remaining-count $record)
   (- (generated-selection-fire-record-generation-cap $record)
      (generated-selection-fire-record-generated-count $record)))

; Make capacity exhaustion directly queryable without requiring audit
; consumers to compare the generated count with the fixed boundary.
(= (generated-selection-fire-record-generation-capacity-disposition $record)
   (if (== (generated-selection-fire-record-generation-remaining-count $record)
           0)
       saturated
       open))

(= (generated-selection-fire-record-generation-omitted-count $chamber $record)
   (- (chamber-source-rule-count $chamber)
      (generated-selection-fire-record-generated-count $record)))

; Distinguish the generator's fixed first-eight boundary from the later
; candidate-selection cap without requiring audit consumers to compare counts.
(= (generated-selection-fire-record-generation-disposition $chamber $record)
   (if (== (generated-selection-fire-record-generation-omitted-count
             $chamber $record)
           0)
       complete
       truncated))

(= (generated-selection-fire-record-generated-count $record)
   (bounded-candidate-list-count
     (candidate-pool-candidates
       (generated-selection-fire-record-pool $record))))

(= (generated-selection-fire-record-bounded-count $record)
   (bounded-candidate-list-count
     (generated-selection-fire-record-bounded-pool $record)))

(= (generated-selection-fire-record-dropped-count $record)
   (- (generated-selection-fire-record-generated-count $record)
      (generated-selection-fire-record-bounded-count $record)))

; Expose complete source-to-selection attrition in one PeTTa-native scalar.
; This includes candidates omitted at the fixed generator boundary and those
; subsequently dropped by the effective per-tick selection cap.
(= (generated-selection-fire-record-total-omitted-count $chamber $record)
   (- (chamber-source-rule-count $chamber)
      (generated-selection-fire-record-bounded-count $record)))

; Classify the complete source-to-selection boundary without requiring audit
; consumers to inspect either intermediate stage. A source is preserved only
; when every source rule reaches the bounded pool.
(= (generated-selection-fire-record-total-disposition $chamber $record)
   (if (== (generated-selection-fire-record-total-omitted-count
             $chamber $record)
           0)
       preserved
       truncated))

; Attribute end-to-end truncation to the fixed generator boundary, the
; effective selection cap, both stages, or neither stage. This keeps audit
; consumers from reconstructing the cause by comparing two omission counts.
(= (generated-selection-fire-record-attrition-stage $chamber $record)
   (if (== (generated-selection-fire-record-generation-omitted-count
             $chamber $record)
           0)
       (if (== (generated-selection-fire-record-dropped-count $record) 0)
           none
           selection)
       (if (== (generated-selection-fire-record-dropped-count $record) 0)
           generation
           both)))

; Package the complete bounded-candidate accounting into one PeTTa-native
; audit atom. Consumers can persist or compare this record without separately
; querying counts and reconstructing the stage attribution in host code.
(= (generated-selection-fire-record-attrition-summary $chamber $record)
   (candidate-attrition
     (chamber-source-rule-count $chamber)
     (generated-selection-fire-record-generated-count $record)
     (generated-selection-fire-record-bounded-count $record)
     (generated-selection-fire-record-generation-omitted-count $chamber $record)
     (generated-selection-fire-record-dropped-count $record)
     (generated-selection-fire-record-total-omitted-count $chamber $record)
     (generated-selection-fire-record-attrition-stage $chamber $record)))

; Keep the compact audit atom directly queryable in PeTTa. Persistence and
; report consumers should not need host-side positional destructuring.
(= (candidate-attrition-source-count
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   $source)

(= (candidate-attrition-generated-count
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   $generated)

(= (candidate-attrition-bounded-count
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   $bounded)

(= (candidate-attrition-generation-omitted-count
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   $generation-omitted)

(= (candidate-attrition-selection-omitted-count
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   $selection-omitted)

(= (candidate-attrition-total-omitted-count
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   $total-omitted)

(= (candidate-attrition-stage
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   $stage)

; Validate the three conservation identities carried by the compact audit
; atom. Persisted provenance can therefore reject internally inconsistent
; generation/selection accounting without reconstructing the checks in a
; host harness.
(= (candidate-attrition-consistent?
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   (and (== $source (+ $generated $generation-omitted))
        (and (== $generated (+ $bounded $selection-omitted))
             (== $source (+ $bounded $total-omitted)))))

; Validate that the attributed loss stage agrees with the two stage-specific
; omission counts. This is separate from arithmetic conservation so a
; persisted record cannot carry correct counts with a misleading label.
(= (candidate-attrition-stage-consistent?
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   (== $stage
       (if (== $generation-omitted 0)
           (if (== $selection-omitted 0) none selection)
           (if (== $selection-omitted 0) generation both))))

; Conservation identities alone can also hold for impossible negative
; cardinalities. Keep the compact provenance domain check inside PeTTa.
(= (candidate-attrition-counts-nonnegative?
      (candidate-attrition $source $generated $bounded $generation-omitted $selection-omitted $total-omitted $stage))
   (and (>= $source 0)
        (and (>= $generated 0)
             (and (>= $bounded 0)
                  (and (>= $generation-omitted 0)
                       (and (>= $selection-omitted 0)
                            (>= $total-omitted 0)))))))

; Give persistence/report consumers one complete validity gate. A compact
; record is valid only when its counts are possible, conservation arithmetic
; holds, and stage attribution agrees; no check is duplicated in host glue.
(= (candidate-attrition-valid? $attrition)
   (and (candidate-attrition-counts-nonnegative? $attrition)
        (and (candidate-attrition-consistent? $attrition)
             (candidate-attrition-stage-consistent? $attrition))))

; Let chamber-tick audit consumers validate the live complete provenance
; directly. The chamber is required because source width is intentionally not
; duplicated inside the generated-selection/fire record.
(= (generated-selection-fire-record-attrition-valid? $chamber $record)
   (candidate-attrition-valid?
     (generated-selection-fire-record-attrition-summary $chamber $record)))

; State whether the effective bound preserved the complete generated pool or
; truncated it. Audit consumers need not count or destructure candidate lists.
(= (generated-selection-fire-record-cap-disposition $record)
   (if (== (candidate-pool-candidates
             (generated-selection-fire-record-pool $record))
           (generated-selection-fire-record-bounded-pool $record))
       preserved
       truncated))

(= (generated-selection-fire-record-cap
      (generated-selection-fire-record $requested-cap $generated-pool $selection-fire-record))
   (candidate-selection-cap
     (selection-fire-record-selection $selection-fire-record)))

(= (generated-selection-fire-record-effective-cap
      (generated-selection-fire-record $requested-cap $generated-pool $selection-fire-record))
   (effective-candidate-cap $requested-cap))

(= (generated-selection-fire-record-effective-per-tick $record)
   (candidate-cap-per-tick
     (generated-selection-fire-record-effective-cap $record)))

(= (generated-selection-fire-record-effective-per-rule $record)
   (candidate-cap-per-rule
     (generated-selection-fire-record-effective-cap $record)))

; Validate the two explicit candidate boundaries carried by complete live
; provenance. Attrition conservation alone cannot detect a persisted record
; whose bounded pool exceeds the requested/effective per-tick cap, or whose
; embedded scalar cap disagrees with that normalized request.
(= (generated-selection-fire-record-bounds-valid? $record)
   (and (<= (generated-selection-fire-record-generated-count $record)
            (generated-selection-fire-record-generation-cap $record))
        (and (<= (generated-selection-fire-record-bounded-count $record)
                 (generated-selection-fire-record-effective-per-tick $record))
             (== (generated-selection-fire-record-cap $record)
                 (generated-selection-fire-record-effective-per-tick $record)))))

; Counts and cap boundaries cannot detect a forged generated pool with the
; right cardinality. Reconstruct generation from the input chamber so the
; complete record is tied to the chamber's exact stable source-rule prefix.
(= (generated-selection-fire-record-generation-valid? $chamber $record)
   (== (generated-selection-fire-record-pool $record)
       (generate-candidate-pool $chamber)))

; Counts and scalar caps cannot detect a forged record that substitutes a
; different bounded pool or selected candidate while preserving cardinality.
; Reconstruct both values from the generated pool, normalized cap, and chamber
; so complete provenance is tied to the deterministic selector it claims.
(= (generated-selection-fire-record-selection-valid? $chamber $record)
   (and (== (generated-selection-fire-record-bounded-pool $record)
            (cap-candidate-pool
              (generated-selection-fire-record-effective-per-tick $record)
              (generated-selection-fire-record-pool $record)))
        (== (generated-selection-fire-record-selected $record)
            (selected-candidate-from-bounded-list
              $chamber
              (generated-selection-fire-record-bounded-pool $record)))))

; A correct bounded pool and deterministic choice are still insufficient if
; persisted provenance substitutes an unrelated output chamber. Recompute the
; firing projection from the input chamber, generated pool envelope, and
; selected candidate so the recorded transition is tied to the same path.
(= (generated-selection-fire-record-firing-valid? $chamber $record)
   (== (generated-selection-fire-record-after-chamber $record)
       (chamber-tick-with-pool-selection
         $chamber
         (generated-selection-fire-record-pool $record)
         (generated-selection-fire-record-selected $record))))

; One gate for consumers of the complete chamber-tick provenance: source and
; stage attrition must be valid, both caps must hold, and the bounded pool and
; deterministic choice and fired chamber must match the generated source.
(= (generated-selection-fire-record-valid? $chamber $record)
   (and (generated-selection-fire-record-attrition-valid? $chamber $record)
        (and (generated-selection-fire-record-bounds-valid? $record)
             (and (generated-selection-fire-record-generation-valid? $chamber $record)
                  (and (generated-selection-fire-record-selection-valid? $chamber $record)
                       (generated-selection-fire-record-firing-valid? $chamber $record))))))

; Attribute complete-record rejection to the first failed boundary. This keeps
; persisted audit/report consumers in PeTTa while retaining one deterministic
; precedence: accounting, caps, generation, selection, then firing.
(= (generated-selection-fire-record-validity $chamber $record)
   (if (generated-selection-fire-record-attrition-valid? $chamber $record)
       (if (generated-selection-fire-record-bounds-valid? $record)
           (if (generated-selection-fire-record-generation-valid? $chamber $record)
               (if (generated-selection-fire-record-selection-valid? $chamber $record)
                   (if (generated-selection-fire-record-firing-valid? $chamber $record)
                       valid
                       invalid-firing)
                   invalid-selection)
               invalid-generation)
           invalid-bounds)
       invalid-attrition))

(= (generated-selection-fire-record-selected
      (generated-selection-fire-record $requested-cap $generated-pool $selection-fire-record))
   (candidate-selection-selected
     (selection-fire-record-selection $selection-fire-record)))

(= (generated-selection-fire-record-after-chamber
      (generated-selection-fire-record $requested-cap $generated-pool $selection-fire-record))
   (selection-fire-record-after-chamber $selection-fire-record))

; Preserve the uncapped generated pool as well as the bounded selection and
; fired chamber. This makes candidate generation, capping, deterministic
; selection, and ticking one inspectable PeTTa-native provenance chain.
(= (generated-selection-fire-record-from-chamber $cap $chamber)
   (let $generated-pool (generate-candidate-pool $chamber)
     (generated-selection-fire-record
       $cap
       $generated-pool
       (selection-fire-record-from-pool $cap $chamber $generated-pool))))

; Chamber ticking consumes only a complete valid provenance record. This
; keeps generation, bounded deterministic selection, and firing on the same
; checked path and fails closed if a persisted or externally supplied record
; violates either candidate boundary.
(= (chamber-tick-result-from-generated-record $chamber $record)
   (let $validity (generated-selection-fire-record-validity $chamber $record)
     (chamber-tick-result
       $validity
       (if (== $validity valid)
           (generated-selection-fire-record-after-chamber $record)
           $chamber))))

(= (chamber-tick-result-chamber
      (chamber-tick-result $validity $after-chamber))
   $after-chamber)

(= (chamber-tick-result-validity
      (chamber-tick-result $validity $after-chamber))
   $validity)

(= (chamber-tick-result-valid? $result)
   (== (chamber-tick-result-validity $result) valid))

; Distinguish productive checked ticks from valid or invalid no-ops without
; requiring audit/report glue to destructure and compare result chambers.
(= (chamber-tick-result-changed? $before-chamber $result)
   (not (== $before-chamber
            (chamber-tick-result-chamber $result))))

; Collapse the two checked-result queries into one loop-facing outcome. Keep
; the exact invalid boundary when validation fails, while distinguishing a
; valid productive transition from a valid bounded no-op.
(= (chamber-tick-result-outcome $before-chamber $result)
   (if (chamber-tick-result-valid? $result)
       (if (chamber-tick-result-changed? $before-chamber $result)
           productive
           no-op)
       (chamber-tick-result-validity $result)))

(= (chamber-tick-from-generated-record $chamber $record)
   (chamber-tick-result-chamber
     (chamber-tick-result-from-generated-record $chamber $record)))

(= (chamber-tick-generated-result $cap $chamber)
   (let $record
        (generated-selection-fire-record-from-chamber $cap $chamber)
     (chamber-tick-result-from-generated-record $chamber $record)))

; Let tick-loop consumers classify a live generated tick without manually
; composing the checked-result constructor and outcome accessor.
(= (chamber-tick-generated-outcome $cap $chamber)
   (chamber-tick-result-outcome
     $chamber
     (chamber-tick-generated-result $cap $chamber)))

; Return the loop-facing outcome and projected chamber from one evaluated
; checked result, avoiding duplicate live generation/selection work when a
; caller needs both values to advance and audit a tick.
(= (chamber-tick-generated-step $cap $chamber)
   (let $result (chamber-tick-generated-result $cap $chamber)
     (chamber-tick-step
       (chamber-tick-result-outcome $chamber $result)
       (chamber-tick-result-chamber $result))))

(= (chamber-tick-step-outcome
      (chamber-tick-step $outcome $after-chamber))
   $outcome)

(= (chamber-tick-step-chamber
      (chamber-tick-step $outcome $after-chamber))
   $after-chamber)

; Exercise the loop-facing step as an actual state handoff: the second live
; tick receives exactly the projected chamber returned by the first. This
; fixed two-tick seam keeps the initial loop contract bounded and inspectable
; while retaining both outcomes beside the final chamber.
(= (chamber-tick-generated-steps-2 $cap $chamber)
   (let $step-0 (chamber-tick-generated-step $cap $chamber)
     (let $step-1
          (chamber-tick-generated-step
            $cap
            (chamber-tick-step-chamber $step-0))
       (chamber-tick-steps
         ((chamber-tick-step-outcome $step-0)
          (chamber-tick-step-outcome $step-1))
         (chamber-tick-step-chamber $step-1)))))

; Extend the same live checked handoff by one bounded step. Keeping an exact
; three-step constructor avoids introducing an unbounded recursive loop while
; proving regenerated selection can repeatedly consume projected chambers.
(= (chamber-tick-generated-steps-3 $cap $chamber)
   (let $steps-2 (chamber-tick-generated-steps-2 $cap $chamber)
     (let $step-2
          (chamber-tick-generated-step
            $cap
            (chamber-tick-steps-chamber $steps-2))
       (chamber-tick-steps
         ((chamber-tick-steps-outcome-0 $steps-2)
          (chamber-tick-steps-outcome-1 $steps-2)
          (chamber-tick-step-outcome $step-2))
         (chamber-tick-step-chamber $step-2)))))

; Extend the bounded checked handoff once more without host-side iteration.
; The fourth live tick consumes exactly the three-step final chamber and
; retains the complete outcome sequence beside its projected state.
(= (chamber-tick-generated-steps-4 $cap $chamber)
   (let $steps-3 (chamber-tick-generated-steps-3 $cap $chamber)
     (let $step-3
          (chamber-tick-generated-step
            $cap
            (chamber-tick-steps-chamber $steps-3))
       (chamber-tick-steps
         ((chamber-tick-steps-outcome-0 $steps-3)
          (chamber-tick-steps-outcome-1 $steps-3)
          (chamber-tick-steps-outcome-2 $steps-3)
          (chamber-tick-step-outcome $step-3))
         (chamber-tick-step-chamber $step-3)))))

; Extend the bounded checked handoff to five live ticks. The fifth tick
; consumes the exact four-step projected chamber and retains every outcome.
(= (chamber-tick-generated-steps-5 $cap $chamber)
   (let $steps-4 (chamber-tick-generated-steps-4 $cap $chamber)
     (let $step-4
          (chamber-tick-generated-step
            $cap
            (chamber-tick-steps-chamber $steps-4))
       (chamber-tick-steps
         ((chamber-tick-steps-outcome-0 $steps-4)
          (chamber-tick-steps-outcome-1 $steps-4)
          (chamber-tick-steps-outcome-2 $steps-4)
          (chamber-tick-steps-outcome-3 $steps-4)
          (chamber-tick-step-outcome $step-4))
         (chamber-tick-step-chamber $step-4)))))

; Extend the bounded checked handoff to six live ticks. The sixth tick
; consumes the exact five-step projected chamber and retains every outcome.
(= (chamber-tick-generated-steps-6 $cap $chamber)
   (let $steps-5 (chamber-tick-generated-steps-5 $cap $chamber)
     (let $step-5
          (chamber-tick-generated-step
            $cap
            (chamber-tick-steps-chamber $steps-5))
       (chamber-tick-steps
         ((chamber-tick-steps-outcome-0 $steps-5)
          (chamber-tick-steps-outcome-1 $steps-5)
          (chamber-tick-steps-outcome-2 $steps-5)
          (chamber-tick-steps-outcome-3 $steps-5)
          (chamber-tick-steps-outcome-4 $steps-5)
          (chamber-tick-step-outcome $step-5))
         (chamber-tick-step-chamber $step-5)))))

; Extend the bounded checked handoff to seven live ticks. The seventh tick
; consumes the exact six-step projected chamber and retains every outcome.
(= (chamber-tick-generated-steps-7 $cap $chamber)
   (let $steps-6 (chamber-tick-generated-steps-6 $cap $chamber)
     (let $step-6
          (chamber-tick-generated-step
            $cap
            (chamber-tick-steps-chamber $steps-6))
       (chamber-tick-steps
         ((chamber-tick-steps-outcome-0 $steps-6)
          (chamber-tick-steps-outcome-1 $steps-6)
          (chamber-tick-steps-outcome-2 $steps-6)
          (chamber-tick-steps-outcome-3 $steps-6)
          (chamber-tick-steps-outcome-4 $steps-6)
          (chamber-tick-steps-outcome-5 $steps-6)
          (chamber-tick-step-outcome $step-6))
         (chamber-tick-step-chamber $step-6)))))

; Complete the bounded checked handoff at the stable eight-candidate
; generation boundary. The eighth tick consumes the exact seven-step
; projected chamber and retains every outcome.
(= (chamber-tick-generated-steps-8 $cap $chamber)
   (let $steps-7 (chamber-tick-generated-steps-7 $cap $chamber)
     (let $step-7
          (chamber-tick-generated-step
            $cap
            (chamber-tick-steps-chamber $steps-7))
       (chamber-tick-steps
         ((chamber-tick-steps-outcome-0 $steps-7)
          (chamber-tick-steps-outcome-1 $steps-7)
          (chamber-tick-steps-outcome-2 $steps-7)
          (chamber-tick-steps-outcome-3 $steps-7)
          (chamber-tick-steps-outcome-4 $steps-7)
          (chamber-tick-steps-outcome-5 $steps-7)
          (chamber-tick-steps-outcome-6 $steps-7)
          (chamber-tick-step-outcome $step-7))
         (chamber-tick-step-chamber $step-7)))))

(= (chamber-tick-steps-outcomes
      (chamber-tick-steps $outcomes $after-chamber))
   $outcomes)

(= (chamber-tick-steps-chamber
      (chamber-tick-steps $outcomes $after-chamber))
   $after-chamber)

(= (chamber-tick-steps-outcome-0
      (chamber-tick-steps ($outcome-0 $outcome-1) $after-chamber))
   $outcome-0)

(= (chamber-tick-steps-outcome-1
      (chamber-tick-steps ($outcome-0 $outcome-1) $after-chamber))
   $outcome-1)

(= (chamber-tick-steps-outcome-0
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2)
        $after-chamber))
   $outcome-0)

(= (chamber-tick-steps-outcome-1
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2)
        $after-chamber))
   $outcome-1)

(= (chamber-tick-steps-outcome-2
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2)
        $after-chamber))
   $outcome-2)

(= (chamber-tick-steps-outcome-0
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3)
        $after-chamber))
   $outcome-0)

(= (chamber-tick-steps-outcome-1
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3)
        $after-chamber))
   $outcome-1)

(= (chamber-tick-steps-outcome-2
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3)
        $after-chamber))
   $outcome-2)

(= (chamber-tick-steps-outcome-3
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3)
        $after-chamber))
   $outcome-3)

(= (chamber-tick-steps-outcome-0
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4)
        $after-chamber))
   $outcome-0)

(= (chamber-tick-steps-outcome-1
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4)
        $after-chamber))
   $outcome-1)

(= (chamber-tick-steps-outcome-2
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4)
        $after-chamber))
   $outcome-2)

(= (chamber-tick-steps-outcome-3
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4)
        $after-chamber))
   $outcome-3)

(= (chamber-tick-steps-outcome-4
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4)
        $after-chamber))
   $outcome-4)

(= (chamber-tick-steps-outcome-0
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   $outcome-0)

(= (chamber-tick-steps-outcome-1
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   $outcome-1)

(= (chamber-tick-steps-outcome-2
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   $outcome-2)

(= (chamber-tick-steps-outcome-3
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   $outcome-3)

(= (chamber-tick-steps-outcome-4
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   $outcome-4)

(= (chamber-tick-steps-outcome-5
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   $outcome-5)

(= (chamber-tick-steps-outcome-0
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   $outcome-0)

(= (chamber-tick-steps-outcome-1
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   $outcome-1)

(= (chamber-tick-steps-outcome-2
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   $outcome-2)

(= (chamber-tick-steps-outcome-3
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   $outcome-3)

(= (chamber-tick-steps-outcome-4
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   $outcome-4)

(= (chamber-tick-steps-outcome-5
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   $outcome-5)

(= (chamber-tick-steps-outcome-6
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   $outcome-6)

; Make the bounded loop width directly auditable without requiring host-side
; list destructuring.
(= (chamber-tick-steps-count
      (chamber-tick-steps ($outcome-0 $outcome-1) $after-chamber))
   2)

(= (chamber-tick-steps-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2)
        $after-chamber))
   3)

(= (chamber-tick-steps-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3)
        $after-chamber))
   4)

(= (chamber-tick-steps-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4)
        $after-chamber))
   5)

(= (chamber-tick-steps-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   6)

(= (chamber-tick-steps-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   7)

(= (chamber-tick-steps-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6 $outcome-7)
        $after-chamber))
   8)

; Summarize the bounded loop's chemistry outcomes inside PeTTa so harnesses
; need not parse the outcome list to distinguish progress from valid no-ops.
(= (productive-outcome-count-2 $outcome-0 $outcome-1)
   (if (== $outcome-0 productive)
       (if (== $outcome-1 productive) 2 1)
       (if (== $outcome-1 productive) 1 0)))

(= (no-op-outcome-count-2 $outcome-0 $outcome-1)
   (if (== $outcome-0 no-op)
       (if (== $outcome-1 no-op) 2 1)
       (if (== $outcome-1 no-op) 1 0)))

(= (chamber-tick-steps-productive-count
      (chamber-tick-steps ($outcome-0 $outcome-1) $after-chamber))
   (productive-outcome-count-2 $outcome-0 $outcome-1))

(= (chamber-tick-steps-no-op-count
      (chamber-tick-steps ($outcome-0 $outcome-1) $after-chamber))
   (no-op-outcome-count-2 $outcome-0 $outcome-1))

(= (chamber-tick-steps-productive-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2)
        $after-chamber))
   (+ (productive-outcome-count-2 $outcome-0 $outcome-1)
      (if (== $outcome-2 productive) 1 0)))

(= (chamber-tick-steps-no-op-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2)
        $after-chamber))
   (+ (no-op-outcome-count-2 $outcome-0 $outcome-1)
      (if (== $outcome-2 no-op) 1 0)))

(= (chamber-tick-steps-productive-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3)
        $after-chamber))
   (+ (productive-outcome-count-2 $outcome-0 $outcome-1)
      (productive-outcome-count-2 $outcome-2 $outcome-3)))

(= (chamber-tick-steps-no-op-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3)
        $after-chamber))
   (+ (no-op-outcome-count-2 $outcome-0 $outcome-1)
      (no-op-outcome-count-2 $outcome-2 $outcome-3)))

(= (chamber-tick-steps-productive-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4)
        $after-chamber))
   (+ (+ (productive-outcome-count-2 $outcome-0 $outcome-1)
         (productive-outcome-count-2 $outcome-2 $outcome-3))
      (if (== $outcome-4 productive) 1 0)))

(= (chamber-tick-steps-no-op-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4)
        $after-chamber))
   (+ (+ (no-op-outcome-count-2 $outcome-0 $outcome-1)
         (no-op-outcome-count-2 $outcome-2 $outcome-3))
      (if (== $outcome-4 no-op) 1 0)))

(= (chamber-tick-steps-productive-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   (+ (+ (productive-outcome-count-2 $outcome-0 $outcome-1)
         (productive-outcome-count-2 $outcome-2 $outcome-3))
      (productive-outcome-count-2 $outcome-4 $outcome-5)))

(= (chamber-tick-steps-no-op-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5)
        $after-chamber))
   (+ (+ (no-op-outcome-count-2 $outcome-0 $outcome-1)
         (no-op-outcome-count-2 $outcome-2 $outcome-3))
      (no-op-outcome-count-2 $outcome-4 $outcome-5)))

(= (chamber-tick-steps-productive-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   (+ (+ (+ (productive-outcome-count-2 $outcome-0 $outcome-1)
            (productive-outcome-count-2 $outcome-2 $outcome-3))
         (productive-outcome-count-2 $outcome-4 $outcome-5))
      (if (== $outcome-6 productive) 1 0)))

(= (chamber-tick-steps-no-op-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6)
        $after-chamber))
   (+ (+ (+ (no-op-outcome-count-2 $outcome-0 $outcome-1)
            (no-op-outcome-count-2 $outcome-2 $outcome-3))
         (no-op-outcome-count-2 $outcome-4 $outcome-5))
      (if (== $outcome-6 no-op) 1 0)))

(= (chamber-tick-steps-productive-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6 $outcome-7)
        $after-chamber))
   (+ (+ (+ (productive-outcome-count-2 $outcome-0 $outcome-1)
            (productive-outcome-count-2 $outcome-2 $outcome-3))
         (productive-outcome-count-2 $outcome-4 $outcome-5))
      (productive-outcome-count-2 $outcome-6 $outcome-7)))

(= (chamber-tick-steps-no-op-count
      (chamber-tick-steps
        ($outcome-0 $outcome-1 $outcome-2 $outcome-3 $outcome-4 $outcome-5
         $outcome-6 $outcome-7)
        $after-chamber))
   (+ (+ (+ (no-op-outcome-count-2 $outcome-0 $outcome-1)
            (no-op-outcome-count-2 $outcome-2 $outcome-3))
         (no-op-outcome-count-2 $outcome-4 $outcome-5))
      (no-op-outcome-count-2 $outcome-6 $outcome-7)))

; A bounded loop is fully classified only when every retained checked outcome
; is either productive or a valid no-op. This catches malformed/unknown
; outcomes without host-side list inspection and works for every supported
; loop width because the three count accessors share the same exact shapes.
(= (chamber-tick-steps-unaccounted-count $steps)
   (- (chamber-tick-steps-count $steps)
      (+ (chamber-tick-steps-productive-count $steps)
         (chamber-tick-steps-no-op-count $steps))))

(= (chamber-tick-steps-outcome-accounting-valid? $steps)
   (== (chamber-tick-steps-unaccounted-count $steps) 0))

; Give bounded-loop consumers one fail-closed disposition. Histories with any
; unclassified outcome are invalid; otherwise at least one productive tick
; distinguishes chemistry progress from a completely valid quiescent path.
(= (chamber-tick-steps-disposition $steps)
   (if (chamber-tick-steps-outcome-accounting-valid? $steps)
       (if (> (chamber-tick-steps-productive-count $steps) 0)
           productive
           quiescent)
       invalid-outcomes))

; Turn the complete bounded-history disposition into an explicit loop-control
; decision. A productive sweep may continue from its projected chamber, while
; a full quiescent sweep or malformed retained outcomes stop fail-closed.
(= (chamber-tick-steps-next-action $steps)
   (if (== (chamber-tick-steps-disposition $steps) productive)
       continue
       (if (== (chamber-tick-steps-disposition $steps) quiescent)
           stop-quiescent
           stop-invalid)))

; Package one complete live bounded sweep with the control decision derived
; from that exact history. Loop drivers can therefore advance from the
; projected chamber without separately regenerating ticks or reclassifying
; outcomes in host glue.
(= (chamber-tick-sweep-action
      (chamber-tick-sweep $action $steps))
   $action)

(= (chamber-tick-sweep-steps
      (chamber-tick-sweep $action $steps))
   $steps)

(= (chamber-tick-sweep-chamber $sweep)
   (chamber-tick-steps-chamber
     (chamber-tick-sweep-steps $sweep)))

(= (chamber-tick-generated-sweep $cap $chamber)
   (let $steps (chamber-tick-generated-steps-8 $cap $chamber)
     (chamber-tick-sweep
       (chamber-tick-steps-next-action $steps)
       $steps)))

; Consume a sweep's control action inside PeTTa. A productive first sweep
; advances from its exact projected chamber into one more bounded sweep;
; quiescent or invalid first sweeps stop without regenerating chemistry.
(= (chamber-tick-sweeps-action
      (chamber-tick-sweeps $action $sweeps $chamber))
   $action)

(= (chamber-tick-sweeps-count
      (chamber-tick-sweeps $action ($sweep-0) $chamber))
   1)

(= (chamber-tick-sweeps-count
      (chamber-tick-sweeps $action ($sweep-0 $sweep-1) $chamber))
   2)

(= (chamber-tick-sweeps-first
      (chamber-tick-sweeps $action ($sweep-0) $chamber))
   $sweep-0)

(= (chamber-tick-sweeps-first
      (chamber-tick-sweeps $action ($sweep-0 $sweep-1) $chamber))
   $sweep-0)

(= (chamber-tick-sweeps-second
      (chamber-tick-sweeps $action ($sweep-0 $sweep-1) $chamber))
   $sweep-1)

(= (chamber-tick-sweeps-chamber
      (chamber-tick-sweeps $action $sweeps $chamber))
   $chamber)

(= (chamber-tick-generated-sweeps-2 $cap $chamber)
   (let $sweep-0 (chamber-tick-generated-sweep $cap $chamber)
     (if (== (chamber-tick-sweep-action $sweep-0) continue)
         (let $sweep-1
              (chamber-tick-generated-sweep
                $cap
                (chamber-tick-sweep-chamber $sweep-0))
           (chamber-tick-sweeps
             (chamber-tick-sweep-action $sweep-1)
             ($sweep-0 $sweep-1)
             (chamber-tick-sweep-chamber $sweep-1)))
         (chamber-tick-sweeps
           (chamber-tick-sweep-action $sweep-0)
           ($sweep-0)
           (chamber-tick-sweep-chamber $sweep-0)))))

(= (chamber-tick-generated $cap $chamber)
   (chamber-tick-result-chamber
     (chamber-tick-generated-result $cap $chamber)))

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
