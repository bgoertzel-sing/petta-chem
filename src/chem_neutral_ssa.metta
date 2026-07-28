; PeTTa-native arithmetic and resource boundary for neutral-crs-v1 SSA.
; Rates are represented in exact integer units of 1/10000.  This avoids
; host-float/RNG dependencies while preserving the frozen propensities:
; g = 1e-4 + 10 * catalyst_count / V.

(= (neutral-ssa-count $molecule $counts)
   (if (== $counts ())
       0
       (let $entry (car-atom $counts)
         (if (== $molecule (car-atom $entry))
             (car-atom (cdr-atom $entry))
             (neutral-ssa-count $molecule (cdr-atom $counts))))))

(= (neutral-ssa-catalyst-count $rule-id $counts $catalysis)
   (if (== $catalysis ())
       0
       (let $edge (car-atom $catalysis)
         (if (== $rule-id (car-atom (cdr-atom $edge)))
             (+ (neutral-ssa-count (car-atom $edge) $counts)
                (neutral-ssa-catalyst-count
                  $rule-id $counts (cdr-atom $catalysis)))
             (neutral-ssa-catalyst-count
               $rule-id $counts (cdr-atom $catalysis))))))

; Exact g numerator with denominator 10000*V.
(= (neutral-ssa-g-numerator $rule-id $volume $counts $catalysis)
   (+ $volume
      (* 100000
         (neutral-ssa-catalyst-count $rule-id $counts $catalysis))))

; Exact mass-action numerator with denominator V for ligation.
(= (neutral-ssa-ligation-h-numerator $left $right $counts)
   (if (== $left $right)
       (/ (* (neutral-ssa-count $left $counts)
             (- (neutral-ssa-count $left $counts) 1))
          2)
       (* (neutral-ssa-count $left $counts)
          (neutral-ssa-count $right $counts))))

; Reaction propensity numerator.  Its denominator is 10000*V^2 for ligation
; and 10000*V for cleavage.  Zero reactant inventory therefore gives zero.
(= (neutral-ssa-ligation-propensity-numerator
      $rule-id $left $right $volume $counts $catalysis)
   (* (neutral-ssa-ligation-h-numerator $left $right $counts)
      (neutral-ssa-g-numerator
        $rule-id $volume $counts $catalysis)))

(= (neutral-ssa-cleavage-propensity-numerator
      $rule-id $polymer $volume $counts $catalysis)
   (* (neutral-ssa-count $polymer $counts)
      (neutral-ssa-g-numerator
        $rule-id $volume $counts $catalysis)))

; Resource updates are total only for enabled events.  Tests check the guard
; before applying an event; no clause silently creates negative inventory.
(= (neutral-ssa-ligation-enabled? $left $right $counts)
   (if (== $left $right)
       (>= (neutral-ssa-count $left $counts) 2)
       (and (> (neutral-ssa-count $left $counts) 0)
            (> (neutral-ssa-count $right $counts) 0))))

(= (neutral-ssa-tiny-step $event-index (($a $na) ($b $nb) ($ab $nab)))
   (if (== (neutral-ssa-tiny-choice $event-index) ligation)
       (($a (- $na 1)) ($b (- $nb 1)) ($ab (+ $nab 1)))
       (($a (+ $na 1)) ($b (+ $nb 1)) ($ab (- $nab 1)))))

; Exact two-event tiny-state control stream.  The selector is deliberately
; state-aware: cleavage is excluded at zero product count.
(= (neutral-ssa-tiny-choice 0) ligation)
(= (neutral-ssa-tiny-choice 1) cleavage)
(= (neutral-ssa-tiny-run $initial)
   (neutral-ssa-tiny-step 1 (neutral-ssa-tiny-step 0 $initial)))

(= (neutral-ssa-tiny-control-record)
   (neutral-ssa-control
     model neutral-crs-v1
     initial (("0" 1) ("1" 1) ("01" 0))
     event-stream (ligation cleavage)
     final (("0" 1) ("1" 1) ("01" 0))
     replay exact
     calibration-endpoints uninspected))
