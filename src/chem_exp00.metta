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
;   (event <tick> <rule-id> <reactant-a> <reactant-b> <product> <catalyst>)
;   (trace <state-after> <event>...)
;
; exp00 remains deliberately bounded: one binary catalytic rule over a compact
; four-molecule state.  The transition is now expressed by generic accessors and
; a generic state transformer instead of one fully hard-coded replay clause.

; ----- Atom contracts / accessors -----

(= (mol-name (mol $name $abundance))
   $name)

(= (mol-abundance (mol $name $abundance))
   $abundance)

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

(= (state-tick (state $tick $seed $m0 $m1 $m2 $m3))
   $tick)

(= (state-seed (state $tick $seed $m0 $m1 $m2 $m3))
   $seed)

(= (make-event $tick (rule $id $a $b $product $catalyst))
   (event $tick $id $a $b $product $catalyst))

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

; ----- exp00 fixture -----

(= (exp00-rule r0)
   (rule r0 A B AB Cat))

(= (exp00-initial-state seed-7)
   (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))

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

; Minimal analytic predicates for the first smoke.  These are deliberately
; conservative; real ACS/RAF-like logic belongs in exp01 after the atom contract
; and replay discipline are stable.
(= (exp00-product-abundance seed-7)
   (mol-abundance (mol AB 1)))

(= (exp00-catalyst-preserved? seed-7)
   (== (mol-abundance (mol Cat 1)) 1))

(= (exp00-replay-ok? seed-7)
   (replay-trace-ok?
     (exp00-rule r0)
     (exp00-initial-state seed-7)
     (exp00-expected-trace seed-7)))
