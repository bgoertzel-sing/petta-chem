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

; Pathway-independent calibration-graph catalysis.  f-twice represents 2f,
; so draw < f-twice out of 2*|R_L| implements Bernoulli
; p = min(1, f/|R_L|) without floating point.  Molecule and reaction indexes
; come only from their frozen canonical lists.  The output edge shape is the
; one consumed directly by neutral-ssa-catalyst-count.
(= (neutral-ssa-list-length $items)
   (if (== $items ())
       0
       (+ 1 (neutral-ssa-list-length (cdr-atom $items)))))

(= (neutral-ssa-reaction-id
      (ligation $rule-id $left $right $product))
   $rule-id)
(= (neutral-ssa-reaction-id
      (cleavage $rule-id $polymer $left $right))
   $rule-id)

(= (neutral-ssa-catalysis-draw
      $graph-seed $molecule-index $reaction-index $denominator)
   (#mod
     (+ (* 1664525 $graph-seed)
        (+ (* 1013904223 $molecule-index)
           (* 69069 $reaction-index)))
     $denominator))

(= (neutral-ssa-sample-catalysis-reactions
      $graph-seed $f-twice $denominator $molecule $molecule-index
      $reaction-index $reactions)
   (if (== $reactions ())
       ()
       (let $reaction (car-atom $reactions)
         (if (< (neutral-ssa-catalysis-draw
                  $graph-seed $molecule-index $reaction-index $denominator)
                $f-twice)
             (cons-atom
               ($molecule (neutral-ssa-reaction-id $reaction))
               (neutral-ssa-sample-catalysis-reactions
                 $graph-seed $f-twice $denominator $molecule $molecule-index
                 (+ $reaction-index 1) (cdr-atom $reactions)))
             (neutral-ssa-sample-catalysis-reactions
               $graph-seed $f-twice $denominator $molecule $molecule-index
               (+ $reaction-index 1) (cdr-atom $reactions))))))

(= (neutral-ssa-sample-catalysis-molecules
      $graph-seed $f-twice $denominator $molecule-index
      $molecules $reactions)
   (if (== $molecules ())
       ()
       (neutral-ssa-list-append
         (neutral-ssa-sample-catalysis-reactions
           $graph-seed $f-twice $denominator
           (car-atom $molecules) $molecule-index 0 $reactions)
         (neutral-ssa-sample-catalysis-molecules
           $graph-seed $f-twice $denominator (+ $molecule-index 1)
           (cdr-atom $molecules) $reactions))))

(= (neutral-ssa-sample-catalysis
      $graph-seed $f-twice $molecules $reactions)
   (if (== $reactions ())
       ()
       (let $denominator (* 2 (neutral-ssa-list-length $reactions))
         (neutral-ssa-sample-catalysis-molecules
           $graph-seed
           (if (> $f-twice $denominator) $denominator $f-twice)
           $denominator 0 $molecules $reactions))))

; Frozen causal ablation: delete every catalysis edge whose target reaction
; belongs to the selected maximal RAF.  Molecules, reactions, and basal
; chemistry remain unchanged; this is not a rule or molecule deletion.
(= (neutral-ssa-delete-catalysis-into $raf-rule-ids $catalysis)
   (if (== $catalysis ())
       ()
       (let $edge (car-atom $catalysis)
         (if (neutral-ssa-member?
               (car-atom (cdr-atom $edge)) $raf-rule-ids)
             (neutral-ssa-delete-catalysis-into
               $raf-rule-ids (cdr-atom $catalysis))
             (cons-atom
               $edge
               (neutral-ssa-delete-catalysis-into
                 $raf-rule-ids (cdr-atom $catalysis)))))))

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

; Project realized draws to cumulative simulated event times inside PeTTa.
; This is the frozen boundary needed by burn-in and persistence-bin endpoints:
; host artifact glue must not reconstruct the stochastic trajectory clock.
(= (neutral-ssa-timed-events-loop $event-index $time $draws)
   (if (== $draws ())
       ()
       (let $draw (car-atom $draws)
         (let $next-time
           (+ $time (neutral-ssa-draw-waiting-time $draw))
           (cons-atom
             (ssa-timed-event
               index $event-index
               time $next-time
               event (neutral-ssa-draw-event $draw))
             (neutral-ssa-timed-events-loop
               (+ $event-index 1) $next-time (cdr-atom $draws)))))))

(= (neutral-ssa-timed-events $draws)
   (neutral-ssa-timed-events-loop 0 0.0 $draws))

(= (neutral-ssa-run-events
      (ssa-run
        seed $seed
        events $events
        final-counts $counts
        stop $stop))
   $events)
(= (neutral-ssa-run-events
      (ssa-run
        seed $seed
        events $events
        final-counts $counts
        final-time $time
        stop $stop))
   $events)

(= (neutral-ssa-run-timed-events $run)
   (neutral-ssa-timed-events (neutral-ssa-run-events $run)))

; Pair every realized event time with its PeTTa-computed post-event resource
; state.  Endpoint code can consume this trajectory directly; host glue must
; not replay chemistry or infer abundance histories from serialized events.
(= (neutral-ssa-timed-states-loop $event-index $time $counts $draws)
   (if (== $draws ())
       ()
       (let $draw (car-atom $draws)
         (let $event (neutral-ssa-draw-event $draw)
           (let $next-time
             (+ $time (neutral-ssa-draw-waiting-time $draw))
             (let $next-counts
               (neutral-ssa-apply-event $event $counts)
               (cons-atom
                 (ssa-timed-state
                   index $event-index
                   time $next-time
                   event $event
                   counts $next-counts)
                 (neutral-ssa-timed-states-loop
                   (+ $event-index 1) $next-time $next-counts
                   (cdr-atom $draws)))))))))

(= (neutral-ssa-timed-states $initial-counts $draws)
   (neutral-ssa-timed-states-loop 0 0.0 $initial-counts $draws))

(= (neutral-ssa-run-timed-states $initial-counts $run)
   (neutral-ssa-timed-states
     $initial-counts (neutral-ssa-run-events $run)))

; Preserve both sides of every realized resource transition.  Post-event-only
; rows are insufficient for endpoint evaluation when an enabled reaction
; consumes the last copy of a required reactant.  This generic projection
; records no RAF membership or endpoint truth.
(= (neutral-ssa-timed-transitions-loop $event-index $time $counts $draws)
   (if (== $draws ())
       ()
       (let $draw (car-atom $draws)
         (let $event (neutral-ssa-draw-event $draw)
           (let $next-time
             (+ $time (neutral-ssa-draw-waiting-time $draw))
             (let $next-counts
               (neutral-ssa-apply-event $event $counts)
               (cons-atom
                 (ssa-timed-transition
                   index $event-index
                   time $next-time
                   event $event
                   before-counts $counts
                   after-counts $next-counts)
                 (neutral-ssa-timed-transitions-loop
                   (+ $event-index 1) $next-time $next-counts
                   (cdr-atom $draws)))))))))

(= (neutral-ssa-timed-transitions $initial-counts $draws)
   (neutral-ssa-timed-transitions-loop 0 0.0 $initial-counts $draws))

(= (neutral-ssa-run-timed-transitions $initial-counts $run)
   (neutral-ssa-timed-transitions
     $initial-counts (neutral-ssa-run-events $run)))

; Assign timed trajectory rows to half-open persistence bins.  The frozen
; calibration uses burn-in 100, width 10, and 40 bins, but these arguments
; remain explicit so hand controls can test boundary behavior without running
; calibration chemistry.  Rows before burn-in and at/after the final boundary
; are excluded.
(= (neutral-ssa-time-bin-index-loop
      $time $bin-start $bin-width $bin-index $remaining)
   (if (== $remaining 0)
       outside-persistence-window
       (if (< $time (+ $bin-start $bin-width))
           $bin-index
           (neutral-ssa-time-bin-index-loop
             $time (+ $bin-start $bin-width) $bin-width
             (+ $bin-index 1) (- $remaining 1)))))

(= (neutral-ssa-time-bin-index $time $burn-in $bin-width $bin-count)
   (if (< $time $burn-in)
       outside-persistence-window
       (neutral-ssa-time-bin-index-loop
         $time $burn-in $bin-width 0 $bin-count)))

(= (neutral-ssa-timed-state-time
      (ssa-timed-state
        index $index time $time event $event counts $counts))
   $time)

(= (neutral-ssa-bin-timed-states
      $timed-states $burn-in $bin-width $bin-count)
   (if (== $timed-states ())
       ()
       (let $timed-state (car-atom $timed-states)
         (let $bin
           (neutral-ssa-time-bin-index
             (neutral-ssa-timed-state-time $timed-state)
             $burn-in $bin-width $bin-count)
           (if (== $bin outside-persistence-window)
               (neutral-ssa-bin-timed-states
                 (cdr-atom $timed-states)
                 $burn-in $bin-width $bin-count)
               (cons-atom
                 (ssa-binned-state bin $bin state $timed-state)
                 (neutral-ssa-bin-timed-states
                   (cdr-atom $timed-states)
                   $burn-in $bin-width $bin-count)))))))

; Endpoint-safe persistence input.  Unlike post-event-only states, each row
; preserves the resources present when its event fired.
(= (neutral-ssa-timed-transition-time
      (ssa-timed-transition
        index $index time $time event $event
        before-counts $before-counts after-counts $after-counts))
   $time)

(= (neutral-ssa-bin-timed-transitions
      $timed-transitions $burn-in $bin-width $bin-count)
   (if (== $timed-transitions ())
       ()
       (let $timed-transition (car-atom $timed-transitions)
         (let $bin
           (neutral-ssa-time-bin-index
             (neutral-ssa-timed-transition-time $timed-transition)
             $burn-in $bin-width $bin-count)
           (if (== $bin outside-persistence-window)
               (neutral-ssa-bin-timed-transitions
                 (cdr-atom $timed-transitions)
                 $burn-in $bin-width $bin-count)
               (cons-atom
                 (ssa-binned-transition
                   bin $bin transition $timed-transition)
                 (neutral-ssa-bin-timed-transitions
                   (cdr-atom $timed-transitions)
                   $burn-in $bin-width $bin-count)))))))

; Frozen active/persistence endpoint evidence is evaluated from the
; pre-event resource state.  Influx and dilution are never RAF reactions.
(= (neutral-ssa-event-reaction-id
      (ligation $rule-id $left $right $product))
   $rule-id)
(= (neutral-ssa-event-reaction-id
      (cleavage $rule-id $polymer $left $right))
   $rule-id)
(= (neutral-ssa-event-reaction-id (influx $molecule))
   no-reaction)
(= (neutral-ssa-event-reaction-id (dilution $molecule))
   no-reaction)

(= (neutral-ssa-all-positive? $molecules $counts)
   (if (== $molecules ())
       True
       (and
         (> (neutral-ssa-count (car-atom $molecules) $counts) 0)
         (neutral-ssa-all-positive? (cdr-atom $molecules) $counts))))

(= (neutral-ssa-transition-raf-evidence?
      (ssa-binned-transition
        bin $bin
        transition
          (ssa-timed-transition
            index $index time $time event $event
            before-counts $before-counts after-counts $after-counts))
      $raf-rule-ids $required-molecules)
   (and
     (neutral-ssa-member?
       (neutral-ssa-event-reaction-id $event) $raf-rule-ids)
     (neutral-ssa-all-positive? $required-molecules $before-counts)))

; Aggregate the frozen active/persistence endpoint without host-side
; chemistry.  Binned transitions arrive in time order, so equal bin indexes
; are contiguous.  A bin contributes at most once even when several
; qualifying RAF reactions fire in it; the raw qualifying event count is
; retained separately.
(= (neutral-ssa-binned-transition-bin
      (ssa-binned-transition bin $bin transition $transition))
   $bin)

(= (neutral-ssa-raf-event-count
      $binned-transitions $raf-rule-ids $required-molecules)
   (if (== $binned-transitions ())
       0
       (let $transition (car-atom $binned-transitions)
         (+ (if (neutral-ssa-transition-raf-evidence?
                  $transition $raf-rule-ids $required-molecules)
                1
                0)
            (neutral-ssa-raf-event-count
              (cdr-atom $binned-transitions)
              $raf-rule-ids $required-molecules)))))

(= (neutral-ssa-raf-evidence-bin-count-from
      $binned-transitions $raf-rule-ids $required-molecules $last-bin)
   (if (== $binned-transitions ())
       0
       (let $transition (car-atom $binned-transitions)
         (let $bin (neutral-ssa-binned-transition-bin $transition)
           (let $new-evidence-bin
             (and
               (neutral-ssa-transition-raf-evidence?
                 $transition $raf-rule-ids $required-molecules)
               (not (== $bin $last-bin)))
             (+ (if $new-evidence-bin 1 0)
                (neutral-ssa-raf-evidence-bin-count-from
                  (cdr-atom $binned-transitions)
                  $raf-rule-ids $required-molecules
                  (if $new-evidence-bin $bin $last-bin))))))))

(= (neutral-ssa-raf-evidence-bin-count
      $binned-transitions $raf-rule-ids $required-molecules)
   (neutral-ssa-raf-evidence-bin-count-from
     $binned-transitions $raf-rule-ids $required-molecules no-bin))

(= (neutral-ssa-raf-persistence-summary
      $binned-transitions $raf-rule-ids $required-molecules
      $bin-count $persistent-bin-threshold)
   (let $event-count
     (neutral-ssa-raf-event-count
       $binned-transitions $raf-rule-ids $required-molecules)
     (let $evidence-bin-count
       (neutral-ssa-raf-evidence-bin-count
         $binned-transitions $raf-rule-ids $required-molecules)
       (raf-persistence-summary
         qualifying-events $event-count
         evidence-bins $evidence-bin-count
         total-bins $bin-count
         persistent
           (>= $evidence-bin-count $persistent-bin-threshold)))))

; Frozen dynamic-reachability endpoint.  A RAF is reached at the first
; realized transition after which every molecule in its selected closure is
; simultaneously positive and every RAF reaction has fired at least once.
; Event identity and state evolution remain PeTTa-native; callers provide the
; already selected structural RAF and its closure.
(= (neutral-ssa-timed-transition-event
      (ssa-timed-transition
        index $index time $time event $event
        before-counts $before-counts after-counts $after-counts))
   $event)

(= (neutral-ssa-timed-transition-after-counts
      (ssa-timed-transition
        index $index time $time event $event
        before-counts $before-counts after-counts $after-counts))
   $after-counts)

(= (neutral-ssa-add-unique $item $items)
   (if (neutral-ssa-member? $item $items)
       $items
       (neutral-ssa-list-append $items ($item))))

(= (neutral-ssa-all-members? $required $observed)
   (if (== $required ())
       True
       (and
         (neutral-ssa-member? (car-atom $required) $observed)
         (neutral-ssa-all-members? (cdr-atom $required) $observed))))

(= (neutral-ssa-raf-reachability-loop
      $timed-transitions $raf-rule-ids $closure-molecules $fired-rule-ids)
   (if (== $timed-transitions ())
       (raf-reachability-summary reachable False first-time censored)
       (let $transition (car-atom $timed-transitions)
         (let $reaction-id
           (neutral-ssa-event-reaction-id
             (neutral-ssa-timed-transition-event $transition))
           (let $next-fired-rule-ids
             (if (neutral-ssa-member? $reaction-id $raf-rule-ids)
                 (neutral-ssa-add-unique $reaction-id $fired-rule-ids)
                 $fired-rule-ids)
             (if
               (and
                 (neutral-ssa-all-members?
                   $raf-rule-ids $next-fired-rule-ids)
                 (neutral-ssa-all-positive?
                   $closure-molecules
                   (neutral-ssa-timed-transition-after-counts $transition)))
               (raf-reachability-summary
                 reachable True
                 first-time
                   (neutral-ssa-timed-transition-time $transition))
               (neutral-ssa-raf-reachability-loop
                 (cdr-atom $timed-transitions)
                 $raf-rule-ids $closure-molecules
                 $next-fired-rule-ids)))))))

(= (neutral-ssa-raf-reachability-summary
      $timed-transitions $raf-rule-ids $closure-molecules)
   (neutral-ssa-raf-reachability-loop
     $timed-transitions $raf-rule-ids $closure-molecules ()))

; Time-integrated nonfood population for the frozen causal/productive
; endpoint.  Counts are piecewise constant between timed transitions.  The
; integration window is half-open [burn-in, horizon), so events exactly on
; either boundary cannot create an ambiguous contribution.
(= (neutral-ssa-nonfood-count $counts $food)
   (if (== $counts ())
       0
       (let $row (car-atom $counts)
         (+
           (if (neutral-ssa-member? (car-atom $row) $food)
               0
               (car-atom (cdr-atom $row)))
           (neutral-ssa-nonfood-count (cdr-atom $counts) $food)))))

(= (neutral-ssa-window-duration $left $right $burn-in $horizon)
   (if (or (<= $right $burn-in) (>= $left $horizon))
       0.0
       (-
         (if (< $right $horizon) $right $horizon)
         (if (> $left $burn-in) $left $burn-in))))

(= (neutral-ssa-integrated-nonfood-loop
      $timed-transitions $food $burn-in $horizon
      $left-time $counts $total)
   (if (== $timed-transitions ())
       (+
         $total
         (*
           (neutral-ssa-nonfood-count $counts $food)
           (neutral-ssa-window-duration
             $left-time $horizon $burn-in $horizon)))
       (let $transition (car-atom $timed-transitions)
         (let $right-time
           (neutral-ssa-timed-transition-time $transition)
           (neutral-ssa-integrated-nonfood-loop
             (cdr-atom $timed-transitions) $food $burn-in $horizon
             $right-time
             (neutral-ssa-timed-transition-after-counts $transition)
             (+
               $total
               (*
                 (neutral-ssa-nonfood-count $counts $food)
                 (neutral-ssa-window-duration
                   $left-time $right-time $burn-in $horizon))))))))

(= (neutral-ssa-integrated-nonfood
      $initial-counts $timed-transitions $food $burn-in $horizon)
   (neutral-ssa-integrated-nonfood-loop
     $timed-transitions $food $burn-in $horizon
     0.0 $initial-counts 0.0))

; Compose the frozen causal/productive measurements for one completed run.
; Chemistry replay, transition timing, binning, and endpoint aggregation all
; remain PeTTa-native; a host harness may serialize only this returned atom.
(= (neutral-ssa-run-causal-endpoints
      $run $initial-counts $food $raf-rule-ids $required-molecules
      $burn-in $horizon $bin-width $bin-count $persistence-threshold)
   (let $transitions
     (neutral-ssa-run-timed-transitions $initial-counts $run)
     (let $persistence
       (neutral-ssa-raf-persistence-summary
         (neutral-ssa-bin-timed-transitions
           $transitions $burn-in $bin-width $bin-count)
         $raf-rule-ids $required-molecules
         $bin-count $persistence-threshold)
       (neutral-causal-endpoints
         raf-events
           (neutral-ssa-persistence-qualifying-events $persistence)
         evidence-bins
           (neutral-ssa-persistence-evidence-bins $persistence)
         integrated-nonfood
           (neutral-ssa-integrated-nonfood
             $initial-counts $transitions $food $burn-in $horizon)))))

(= (neutral-ssa-persistence-qualifying-events
      (raf-persistence-summary
        qualifying-events $events evidence-bins $bins
        total-bins $total persistent $persistent))
   $events)

(= (neutral-ssa-persistence-evidence-bins
      (raf-persistence-summary
        qualifying-events $events evidence-bins $bins
        total-bins $total persistent $persistent))
   $bins)

(= (neutral-ssa-causal-endpoint-delta
      (neutral-causal-endpoints
        raf-events $baseline-events
        evidence-bins $baseline-bins
        integrated-nonfood $baseline-nonfood)
      (neutral-causal-endpoints
        raf-events $ablated-events
        evidence-bins $ablated-bins
        integrated-nonfood $ablated-nonfood))
   (neutral-causal-endpoint-delta
     raf-events (- $baseline-events $ablated-events)
     evidence-bins (- $baseline-bins $ablated-bins)
     integrated-nonfood (- $baseline-nonfood $ablated-nonfood)))

; Compose both arms of the matched catalysis intervention without allowing
; host glue to replay chemistry or recompute endpoint values.  Structural RAF
; selection remains an explicit upstream input, and reachability is reported
; separately from active/persistent and causal/productive measurements.
(= (neutral-ssa-ablation-pair-baseline
      (neutral-catalysis-ablation-pair
        model $model graph-seed $graph-seed dynamics-seed $dynamics-seed
        raf-rule-ids $raf-rule-ids
        baseline-catalysis $baseline-catalysis
        ablated-catalysis $ablated-catalysis
        baseline $baseline ablated $ablated))
   $baseline)

(= (neutral-ssa-ablation-pair-ablated
      (neutral-catalysis-ablation-pair
        model $model graph-seed $graph-seed dynamics-seed $dynamics-seed
        raf-rule-ids $raf-rule-ids
        baseline-catalysis $baseline-catalysis
        ablated-catalysis $ablated-catalysis
        baseline $baseline ablated $ablated))
   $ablated)

(= (neutral-ssa-ablation-pair-endpoints
      $pair $initial-counts $food $raf-rule-ids
      $persistence-molecules $closure-molecules
      $burn-in $horizon $bin-width $bin-count $persistence-threshold)
   (let $baseline (neutral-ssa-ablation-pair-baseline $pair)
     (let $ablated (neutral-ssa-ablation-pair-ablated $pair)
       (let $baseline-causal
         (neutral-ssa-run-causal-endpoints
           $baseline $initial-counts $food $raf-rule-ids $persistence-molecules
           $burn-in $horizon $bin-width $bin-count $persistence-threshold)
         (let $ablated-causal
           (neutral-ssa-run-causal-endpoints
             $ablated $initial-counts $food $raf-rule-ids $persistence-molecules
             $burn-in $horizon $bin-width $bin-count $persistence-threshold)
           (neutral-ablation-endpoints
             baseline-reachability
               (neutral-ssa-raf-reachability-summary
                 (neutral-ssa-run-timed-transitions
                   $initial-counts $baseline)
                 $raf-rule-ids $closure-molecules)
             ablated-reachability
               (neutral-ssa-raf-reachability-summary
                 (neutral-ssa-run-timed-transitions
                   $initial-counts $ablated)
                 $raf-rule-ids $closure-molecules)
             baseline-causal $baseline-causal
             ablated-causal $ablated-causal
             delta
               (neutral-ssa-causal-endpoint-delta
                 $baseline-causal $ablated-causal)))))))

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

; End-to-end neutral-system execution boundary. Canonical molecule and
; reaction lists are explicit inputs: PeTTa samples the pathway-independent
; catalysis graph, constructs the population-scaled initial state, and passes
; both directly into the time/event-bounded SSA. Graph and dynamics seeds
; remain separate so nested dynamics replicates cannot overwrite the graph
; stream.
(= (neutral-ssa-run-system
      $graph-seed $dynamics-seed $f-twice
      $event-count $time-limit
      $food $molecules $reactions $volume)
   (let $catalysis
     (neutral-ssa-sample-catalysis
       $graph-seed $f-twice $molecules $reactions)
     (neutral-system-run
       model neutral-crs-v1
       graph-seed $graph-seed
       dynamics-seed $dynamics-seed
       f-twice $f-twice
       volume $volume
       catalysis $catalysis
       result
         (neutral-ssa-run-until
           $dynamics-seed $event-count $time-limit
           $food $molecules $reactions $volume $catalysis
           (neutral-ssa-initial-counts $molecules $food $volume)))))

; Matched causal/productive pair for one already-selected maximal RAF.
; Both arms reuse the exact sampled graph, initial counts, dynamics seed,
; horizon, and event bound.  Only catalysis edges into RAF reactions differ.
(= (neutral-ssa-run-catalysis-ablation-pair
      $graph-seed $dynamics-seed $f-twice
      $event-count $time-limit
      $food $molecules $reactions $volume $raf-rule-ids)
   (let $catalysis
     (neutral-ssa-sample-catalysis
       $graph-seed $f-twice $molecules $reactions)
     (let $ablated-catalysis
       (neutral-ssa-delete-catalysis-into $raf-rule-ids $catalysis)
       (neutral-catalysis-ablation-pair
         model neutral-crs-v1
         graph-seed $graph-seed
         dynamics-seed $dynamics-seed
         raf-rule-ids $raf-rule-ids
         baseline-catalysis $catalysis
         ablated-catalysis $ablated-catalysis
         baseline
           (neutral-ssa-run-until
             $dynamics-seed $event-count $time-limit
             $food $molecules $reactions $volume $catalysis
             (neutral-ssa-initial-counts $molecules $food $volume))
         ablated
           (neutral-ssa-run-until
             $dynamics-seed $event-count $time-limit
             $food $molecules $reactions $volume $ablated-catalysis
             (neutral-ssa-initial-counts $molecules $food $volume))))))

; Complete PeTTa-native execution/measurement seam for one preregistered
; calibration row.  The maximal RAF and its two molecule projections remain
; explicit structural-detector inputs; chemistry execution and all dynamic
; endpoint composition stay inside PeTTa.
(= (neutral-ssa-run-catalysis-ablation-endpoints
      $graph-seed $dynamics-seed $f-twice
      $event-count $time-limit
      $food $molecules $reactions $volume $raf-rule-ids
      $persistence-molecules $closure-molecules
      $burn-in $bin-width $bin-count $persistence-threshold)
   (let $pair
     (neutral-ssa-run-catalysis-ablation-pair
       $graph-seed $dynamics-seed $f-twice
       $event-count $time-limit
       $food $molecules $reactions $volume $raf-rule-ids)
     (neutral-ssa-ablation-pair-endpoints
       $pair
       (neutral-ssa-initial-counts $molecules $food $volume)
       $food $raf-rule-ids $persistence-molecules $closure-molecules
       $burn-in $time-limit $bin-width $bin-count $persistence-threshold)))

; Convert the SSA reaction/edge representation to the canonical structural
; RAF interface.  These projections contain no pathway or endpoint inputs.
(= (neutral-ssa-raf-reactions $reactions)
   (if (== $reactions ())
       ()
       (let $reaction (car-atom $reactions)
         (cons-atom
           (if (== (car-atom $reaction) ligation)
               (raf-reaction neutral-calibration
                 (neutral-ssa-reaction-id $reaction)
                 reactants
                   ((car-atom (cdr-atom (cdr-atom $reaction)))
                    (car-atom (cdr-atom (cdr-atom (cdr-atom $reaction)))))
                 products
                   ((car-atom
                      (cdr-atom
                        (cdr-atom (cdr-atom (cdr-atom $reaction)))))))
               (raf-reaction neutral-calibration
                 (neutral-ssa-reaction-id $reaction)
                 reactants
                   ((car-atom (cdr-atom (cdr-atom $reaction))))
                 products
                   ((car-atom (cdr-atom (cdr-atom (cdr-atom $reaction))))
                    (car-atom
                      (cdr-atom
                        (cdr-atom (cdr-atom (cdr-atom $reaction))))))))
           (neutral-ssa-raf-reactions (cdr-atom $reactions))))))

(= (neutral-ssa-raf-catalysis $catalysis)
   (if (== $catalysis ())
       ()
       (let $edge (car-atom $catalysis)
         (cons-atom
           (raf-catalysis neutral-calibration
             (car-atom $edge) (car-atom (cdr-atom $edge)))
           (neutral-ssa-raf-catalysis (cdr-atom $catalysis))))))

(= (neutral-ssa-add-molecules $molecules $available)
   (if (== $molecules ())
       $available
       (neutral-ssa-add-molecules
         (cdr-atom $molecules)
         (neutral-raf-add-unique (car-atom $molecules) $available))))

(= (neutral-ssa-raf-reactant-molecules $raf-reactions $available)
   (if (== $raf-reactions ())
       $available
       (neutral-ssa-raf-reactant-molecules
         (cdr-atom $raf-reactions)
         (neutral-ssa-add-molecules
           (raf-reaction-reactants (car-atom $raf-reactions))
           $available))))

(= (neutral-ssa-raf-catalyst-molecules
      $catalysis $raf-rule-ids $closure $available)
   (if (== $catalysis ())
       $available
       (let $edge (car-atom $catalysis)
         (neutral-ssa-raf-catalyst-molecules
           (cdr-atom $catalysis) $raf-rule-ids $closure
           (if (and
                 (neutral-ssa-member?
                   (car-atom (cdr-atom $edge)) $raf-rule-ids)
                 (neutral-ssa-member? (car-atom $edge) $closure))
               (neutral-raf-add-unique (car-atom $edge) $available)
               $available)))))

(= (neutral-ssa-run-detected-raf-endpoints
      $graph-seed $dynamics-seed $f-twice
      $event-count $time-limit
      $food $molecules $reactions $volume
      $burn-in $bin-width $bin-count $persistence-threshold)
   (let $catalysis
     (neutral-ssa-sample-catalysis
       $graph-seed $f-twice $molecules $reactions)
     (let $raf-reactions
       (neutral-raf-maximal-reactions
         $food
         (neutral-ssa-raf-reactions $reactions)
         (neutral-ssa-raf-catalysis $catalysis))
       (let $raf-rule-ids (neutral-raf-reaction-ids $raf-reactions)
         (let $closure-molecules
           (neutral-raf-closure $food $raf-reactions)
           (let $persistence-molecules
             (neutral-ssa-raf-catalyst-molecules
               $catalysis $raf-rule-ids $closure-molecules
               (neutral-ssa-raf-reactant-molecules $raf-reactions ()))
             (neutral-ssa-run-catalysis-ablation-endpoints
               $graph-seed $dynamics-seed $f-twice
               $event-count $time-limit
               $food $molecules $reactions $volume $raf-rule-ids
               $persistence-molecules $closure-molecules
               $burn-in $bin-width $bin-count $persistence-threshold)))))))

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
