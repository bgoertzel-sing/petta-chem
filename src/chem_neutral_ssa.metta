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

; Canonical count updates and event application. The event vocabulary is
; deliberately chemistry-shaped rather than pathway-shaped. Callers must
; enumerate events in canonical CRS order and use enabled? before apply.
(= (neutral-ssa-adjust-count $molecule $delta $counts)
   (if (== $counts ())
       ()
       (let $entry (car-atom $counts)
         (if (== $molecule (car-atom $entry))
             (cons-atom
               ((car-atom $entry)
                (+ (car-atom (cdr-atom $entry)) $delta))
               (neutral-ssa-adjust-count
                 $molecule 0 (cdr-atom $counts)))
             (cons-atom
               $entry
               (neutral-ssa-adjust-count
                 $molecule $delta (cdr-atom $counts)))))))

(= (neutral-ssa-apply-event (influx $molecule) $counts)
   (neutral-ssa-adjust-count $molecule 1 $counts))
(= (neutral-ssa-apply-event (dilution $molecule) $counts)
   (neutral-ssa-adjust-count $molecule -1 $counts))
(= (neutral-ssa-apply-event
      (ligation $rule-id $left $right $product) $counts)
   (neutral-ssa-adjust-count
     $product 1
     (neutral-ssa-adjust-count
       $right -1 (neutral-ssa-adjust-count $left -1 $counts))))
(= (neutral-ssa-apply-event
      (cleavage $rule-id $polymer $left $right) $counts)
   (neutral-ssa-adjust-count
     $right 1
     (neutral-ssa-adjust-count
       $left 1 (neutral-ssa-adjust-count $polymer -1 $counts))))

(= (neutral-ssa-event-enabled? (influx $molecule) $counts) True)
(= (neutral-ssa-event-enabled? (dilution $molecule) $counts)
   (> (neutral-ssa-count $molecule $counts) 0))
(= (neutral-ssa-event-enabled?
      (ligation $rule-id $left $right $product) $counts)
   (neutral-ssa-ligation-enabled? $left $right $counts))
(= (neutral-ssa-event-enabled?
      (cleavage $rule-id $polymer $left $right) $counts)
   (> (neutral-ssa-count $polymer $counts) 0))

(= (neutral-ssa-apply-trace $events $counts)
   (if (== $events ())
       $counts
       (neutral-ssa-apply-trace
         (cdr-atom $events)
         (neutral-ssa-apply-event (car-atom $events) $counts))))

; Replayable direct-SSA draw boundary. Events arrive in canonical order as
; ((EVENT-ID INTEGER-WEIGHT)...). The categorical draw is exact; waiting time
; remains a symbolic inverse-CDF value so no host float enters replay.
(= (neutral-ssa-weight-total $weighted-events)
   (if (== $weighted-events ())
       0
       (+ (car-atom (cdr-atom (car-atom $weighted-events)))
          (neutral-ssa-weight-total (cdr-atom $weighted-events)))))

(= (neutral-ssa-select-threshold $threshold $weighted-events)
   (let $entry (car-atom $weighted-events)
     (let $weight (car-atom (cdr-atom $entry))
       (if (< $threshold $weight)
           (car-atom $entry)
           (neutral-ssa-select-threshold
             (- $threshold $weight) (cdr-atom $weighted-events))))))

; Separate keyed draws prevent event and waiting-time streams from coupling.
; Waiting-time uniform numerators are in [1, 1000000].
(= (neutral-ssa-event-draw $seed $event-index $total)
   (#mod (+ (* $seed 48271) (* $event-index 69621)) $total))

(= (neutral-ssa-waiting-uniform-numerator $seed $event-index)
   (+ 1
      (#mod (+ (+ (* $seed 40699) (* $event-index 65537)) 17) 1000000)))

(= (neutral-ssa-seeded-draw $seed $event-index $weighted-events)
   (let $total (neutral-ssa-weight-total $weighted-events)
     (if (== $total 0)
         no-enabled-event
         (ssa-draw
           event
             (neutral-ssa-select-threshold
               (neutral-ssa-event-draw $seed $event-index $total)
               $weighted-events)
           waiting-time
             (negative-log-ratio
               (neutral-ssa-waiting-uniform-numerator $seed $event-index)
               1000000
               total-propensity $total)))))

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
