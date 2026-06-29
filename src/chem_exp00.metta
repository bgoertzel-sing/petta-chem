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

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3))
   $tick)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3))
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

(= (cap-candidate-pool 0 (candidate-pool $tick $candidates))
   ())

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0))

(= (cap-candidate-pool 1 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 2 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 3 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1 $candidate-2))

(= (cap-candidate-pool 4 (candidate-pool $tick ($candidate-0 $candidate-1 $candidate-2 $candidate-3)))
   ($candidate-0 $candidate-1 $candidate-2 $candidate-3))

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

(= (chamber-tick-generated-2 $cap $chamber)
   (let $candidate-pool (bounded-candidate-pool $cap $chamber)
     (chamber-tick-with-candidate
       $chamber
       (selected-candidate-from-list-2
         $chamber
         (candidate-pool-candidates $candidate-pool)))))

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
