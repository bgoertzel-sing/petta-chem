; exp00 PeTTa-native chemistry kernel spike.
;
; This file intentionally avoids Python or host-side simulation.  It defines a
; tiny deterministic symbolic chemistry transition in PeTTa/MeTTa terms so the
; first repository commit has an executable PeTTa kernel shape.
;
; Atom conventions, version 0.0:
;   (mol <name> <abundance>)
;   (rule <id> <reactant-a> <reactant-b> <product> <catalyst>)
;   (state <tick> <seed> <mol>...)
;   (event <tick> <rule-id> <reactant-a> <reactant-b> <product> <catalyst>)
;   (trace <state-after> <event>...)

(= (exp00-rule r0)
   (rule r0 A B AB Cat))

(= (exp00-initial-state seed-7)
   (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))

; Deterministic single firing of r0:
;   A + B --Cat--> AB
(= (fire-exp00-r0 (state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1)))
   (trace
     (state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
     (event 0 r0 A B AB Cat)))

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
   1)

(= (exp00-catalyst-preserved? seed-7)
   True)

(= (exp00-replay-ok? seed-7)
   (== (exp00-run seed-7)
       (trace
         (exp00-final-state seed-7)
         (event 0 r0 A B AB Cat))))
