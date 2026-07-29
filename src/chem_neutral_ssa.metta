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

(= (neutral-ssa-member? $item $items)
   (if (== $items ())
       False
       (if (== $item (car-atom $items))
           True
           (neutral-ssa-member? $item (cdr-atom $items)))))

; Population-scaling controls start every food species at V/5 molecules and
; every nonfood species at zero, matching 20 food molecules at V=100.
; Molecules and food arrive in their frozen canonical order.
(= (neutral-ssa-initial-counts $molecules $food $volume)
   (if (== $molecules ())
       ()
       (let $molecule (car-atom $molecules)
         (cons-atom
           ($molecule
            (if (neutral-ssa-member? $molecule $food)
                (/ $volume 5)
                0))
           (neutral-ssa-initial-counts
             (cdr-atom $molecules) $food $volume)))))

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

(= (neutral-ssa-list-append $left $right)
   (if (== $left ())
       $right
       (cons-atom
         (car-atom $left)
         (neutral-ssa-list-append (cdr-atom $left) $right))))

; All weights below share the exact denominator 10000*V^2.  Food influx is
; delta*(V/5) = V/500 because the frozen initial food count 20 at V=100 scales
; linearly with volume.  Its exact common-denominator weight is therefore
; 20*V^3.  The caller supplies food, molecules, and reactions in their frozen
; canonical order, so the resulting influx/dilution/reaction list is a stable
; sampling boundary.
(= (neutral-ssa-influx-weight $volume)
   (* 20 (* $volume (* $volume $volume))))
(= (neutral-ssa-dilution-weight $molecule $volume $counts)
   (* 100
      (* (neutral-ssa-count $molecule $counts)
         (* $volume $volume))))

(= (neutral-ssa-enumerate-influx $food $volume)
   (if (== $food ())
       ()
       (cons-atom
         ((influx (car-atom $food))
          (neutral-ssa-influx-weight $volume))
         (neutral-ssa-enumerate-influx (cdr-atom $food) $volume))))

(= (neutral-ssa-enumerate-dilution $molecules $volume $counts)
   (if (== $molecules ())
       ()
       (let $molecule (car-atom $molecules)
         (let $weight
           (neutral-ssa-dilution-weight $molecule $volume $counts)
           (if (== $weight 0)
               (neutral-ssa-enumerate-dilution
                 (cdr-atom $molecules) $volume $counts)
               (cons-atom
                 ((dilution $molecule) $weight)
                 (neutral-ssa-enumerate-dilution
                   (cdr-atom $molecules) $volume $counts)))))))

(= (neutral-ssa-reaction-weight
      (ligation $rule-id $left $right $product)
      $volume $counts $catalysis)
   (neutral-ssa-ligation-propensity-numerator
     $rule-id $left $right $volume $counts $catalysis))
(= (neutral-ssa-reaction-weight
      (cleavage $rule-id $polymer $left $right)
      $volume $counts $catalysis)
   (* $volume
      (neutral-ssa-cleavage-propensity-numerator
        $rule-id $polymer $volume $counts $catalysis)))

(= (neutral-ssa-enumerate-reactions
      $reactions $volume $counts $catalysis)
   (if (== $reactions ())
       ()
       (let $reaction (car-atom $reactions)
         (let $weight
           (neutral-ssa-reaction-weight
             $reaction $volume $counts $catalysis)
           (if (== $weight 0)
               (neutral-ssa-enumerate-reactions
                 (cdr-atom $reactions) $volume $counts $catalysis)
               (cons-atom
                 ($reaction $weight)
                 (neutral-ssa-enumerate-reactions
                   (cdr-atom $reactions)
                   $volume $counts $catalysis)))))))

(= (neutral-ssa-enumerate-events
      $food $molecules $reactions $volume $counts $catalysis)
   (neutral-ssa-list-append
     (neutral-ssa-enumerate-influx $food $volume)
     (neutral-ssa-list-append
       (neutral-ssa-enumerate-dilution $molecules $volume $counts)
       (neutral-ssa-enumerate-reactions
         $reactions $volume $counts $catalysis))))

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

; Every enumerated event weight uses the common denominator 10000*V^2.
; Realizing tau here keeps Gillespie time, the T=500 stop, and persistence
; bins inside the PeTTa chemistry boundary.  log-math is the PeTTa/SWI
; deterministic floating-point primitive; counts and event selection remain
; exact integers.
(= (neutral-ssa-waiting-time $uniform-numerator $total-weight $volume)
   (/ (* (- 0
            (log-math
              2.718281828459045
              (/ $uniform-numerator 1000000)))
         (* 10000 (* $volume $volume)))
      $total-weight))

(= (neutral-ssa-seeded-draw
      $seed $event-index $volume $weighted-events)
   (let $total (neutral-ssa-weight-total $weighted-events)
     (if (== $total 0)
         no-enabled-event
         (let $uniform-numerator
           (neutral-ssa-waiting-uniform-numerator $seed $event-index)
           (ssa-draw
             event
               (neutral-ssa-select-threshold
                 (neutral-ssa-event-draw $seed $event-index $total)
                 $weighted-events)
             waiting-uniform ($uniform-numerator 1000000)
             total-weight $total
             propensity-denominator
               (* 10000 (* $volume $volume))
             waiting-time
               (neutral-ssa-waiting-time
                 $uniform-numerator $total $volume))))))

; One bounded SSA transition re-enumerates propensities from the current
; resource state, draws from the keyed stream, and applies only that selected
; enabled event.  The complete draw is retained for exact replay/audit.
(= (neutral-ssa-draw-event
      (ssa-draw
        event $event
        waiting-uniform $waiting-uniform
        total-weight $total-weight
        propensity-denominator $propensity-denominator
        waiting-time $waiting-time))
   $event)

(= (neutral-ssa-draw-waiting-time
      (ssa-draw
        event $event
        waiting-uniform $waiting-uniform
        total-weight $total-weight
        propensity-denominator $propensity-denominator
        waiting-time $waiting-time))
   $waiting-time)

(= (neutral-ssa-step
      $seed $event-index $food $molecules $reactions $volume $catalysis $counts)
   (let $weighted-events
     (neutral-ssa-enumerate-events
       $food $molecules $reactions $volume $counts $catalysis)
     (let $draw
       (neutral-ssa-seeded-draw
         $seed $event-index $volume $weighted-events)
       (if (== $draw no-enabled-event)
           (ssa-step no-enabled-event counts $counts)
           (let $event (neutral-ssa-draw-event $draw)
             (ssa-step
               draw $draw
               counts (neutral-ssa-apply-event $event $counts)))))))

(= (neutral-ssa-step-counts
      (ssa-step no-enabled-event counts $counts))
   $counts)
(= (neutral-ssa-step-counts
      (ssa-step draw $draw counts $counts))
   $counts)

(= (neutral-ssa-step-record
      (ssa-step no-enabled-event counts $counts))
   no-enabled-event)
(= (neutral-ssa-step-record
      (ssa-step draw $draw counts $counts))
   $draw)

(= (neutral-ssa-run-loop
      $seed $event-index $remaining
      $food $molecules $reactions $volume $catalysis $counts $records)
   (if (== $remaining 0)
       (ssa-run
         seed $seed
         events $records
         final-counts $counts
         stop event-bound)
       (let $step
         (neutral-ssa-step
           $seed $event-index
           $food $molecules $reactions $volume $catalysis $counts)
         (let $record (neutral-ssa-step-record $step)
           (if (== $record no-enabled-event)
               (ssa-run
                 seed $seed
                 events $records
                 final-counts $counts
                 stop no-enabled-event)
               (neutral-ssa-run-loop
                 $seed (+ $event-index 1) (- $remaining 1)
                 $food $molecules $reactions $volume $catalysis
                 (neutral-ssa-step-counts $step)
                 (neutral-ssa-list-append $records ($record))))))))

(= (neutral-ssa-run
      $seed $event-count
      $food $molecules $reactions $volume $catalysis $initial-counts)
   (neutral-ssa-run-loop
     $seed 0 $event-count
     $food $molecules $reactions $volume $catalysis $initial-counts ()))

; Calibration runner with both frozen stopping conditions.  A sampled event
; whose waiting time would cross the time horizon is not applied; the process
; is observed at the exact horizon with its pre-event state.  Records contain
; only realized events, while final-time makes the censoring boundary explicit.
(= (neutral-ssa-run-until-loop
      $seed $event-index $remaining $time $time-limit
      $food $molecules $reactions $volume $catalysis $counts $records)
   (if (>= $time $time-limit)
       (ssa-run
         seed $seed
         events $records
         final-counts $counts
         final-time $time-limit
         stop time-bound)
       (if (== $remaining 0)
           (ssa-run
             seed $seed
             events $records
             final-counts $counts
             final-time $time
             stop event-bound)
           (let $step
             (neutral-ssa-step
               $seed $event-index
               $food $molecules $reactions $volume $catalysis $counts)
             (let $record (neutral-ssa-step-record $step)
               (if (== $record no-enabled-event)
                   (ssa-run
                     seed $seed
                     events $records
                     final-counts $counts
                     final-time $time
                     stop no-enabled-event)
                   (let $next-time
                     (+ $time (neutral-ssa-draw-waiting-time $record))
                     (if (> $next-time $time-limit)
                         (ssa-run
                           seed $seed
                           events $records
                           final-counts $counts
                           final-time $time-limit
                           stop time-bound)
                         (neutral-ssa-run-until-loop
                           $seed (+ $event-index 1) (- $remaining 1)
                           $next-time $time-limit
                           $food $molecules $reactions $volume $catalysis
                           (neutral-ssa-step-counts $step)
                           (neutral-ssa-list-append
                             $records ($record)))))))))))

(= (neutral-ssa-run-until
      $seed $event-count $time-limit
      $food $molecules $reactions $volume $catalysis $initial-counts)
   (neutral-ssa-run-until-loop
     $seed 0 $event-count 0.0 $time-limit
     $food $molecules $reactions $volume $catalysis $initial-counts ()))

(= (neutral-ssa-counts-nonnegative? $counts)
   (if (== $counts ())
       True
       (and
         (>= (car-atom (cdr-atom (car-atom $counts))) 0)
         (neutral-ssa-counts-nonnegative? (cdr-atom $counts)))))

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
