!(import! &self ../../src/chem_neutral_ssa.metta)

!(test (neutral-ssa-count "0" (("0" 20) ("1" 20))) 20)
!(test (neutral-ssa-count "01" (("0" 20) ("1" 20))) 0)
!(test (neutral-ssa-member? "01" ("0" "1" "01")) True)
!(test (neutral-ssa-member? "10" ("0" "1" "01")) False)
!(test (neutral-ssa-list-length (r0 r1 r2)) 3)
!(test
  (neutral-ssa-reaction-id (ligation lig-01 "0" "1" "01"))
  lig-01)
!(test
  (neutral-ssa-reaction-id (cleavage cleave-01 "01" "0" "1"))
  cleave-01)
!(test
  (neutral-ssa-sample-catalysis
    1001 0
    ("0" "1")
    ((ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1")))
  ())
!(test
  (neutral-ssa-sample-catalysis
    1001 4
    ("0" "1")
    ((ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1")))
  (("0" lig-01) ("0" cleave-01)
   ("1" lig-01) ("1" cleave-01)))
!(test
  (neutral-ssa-sample-catalysis
    1001 2
    ("0" "1")
    ((ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1")))
  (("0" lig-01) ("1" lig-01) ("1" cleave-01)))
!(test
  (neutral-ssa-sample-catalysis
    1001 2
    ("0" "1")
    ((ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1")))
  (neutral-ssa-sample-catalysis
    1001 2
    ("0" "1")
    ((ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1"))))
!(test
  (neutral-ssa-sample-catalysis 1001 2 ("0") ())
  ())
!(test
  (neutral-ssa-initial-counts
    ("0" "1" "00" "01" "10" "11" "000")
    ("0" "1" "00" "01" "10" "11")
    50)
  (("0" 10) ("1" 10) ("00" 10) ("01" 10)
   ("10" 10) ("11" 10) ("000" 0)))
!(test
  (neutral-ssa-initial-counts
    ("0" "1" "00" "01" "10" "11" "000")
    ("0" "1" "00" "01" "10" "11")
    100)
  (("0" 20) ("1" 20) ("00" 20) ("01" 20)
   ("10" 20) ("11" 20) ("000" 0)))
!(test
  (neutral-ssa-initial-counts
    ("0" "1" "00" "01" "10" "11" "000")
    ("0" "1" "00" "01" "10" "11")
    200)
  (("0" 40) ("1" 40) ("00" 40) ("01" 40)
   ("10" 40) ("11" 40) ("000" 0)))
!(test
  (neutral-ssa-catalyst-count
    r (("0" 20) ("1" 7) ("01" 3))
    (("0" r) ("01" r) ("1" other)))
  23)
!(test
  (neutral-ssa-g-numerator
    r 100 (("0" 20) ("01" 3)) (("0" r) ("01" r)))
  2300100)
!(test
  (neutral-ssa-ligation-h-numerator
    "0" "1" (("0" 20) ("1" 20)))
  400)
!(test
  (neutral-ssa-ligation-h-numerator
    "0" "0" (("0" 20)))
  190)
!(test
  (neutral-ssa-ligation-propensity-numerator
    r "0" "1" 100 (("0" 20) ("1" 20)) ())
  40000)
!(test
  (neutral-ssa-ligation-propensity-numerator
    r "0" "1" 100 (("0" 20) ("1" 20)) (("0" r)))
  800040000)
!(test
  (neutral-ssa-cleavage-propensity-numerator
    r "01" 100 (("01" 4)) ())
  400)
!(test
  (neutral-ssa-ligation-enabled? "0" "0" (("0" 1))) False)
!(test
  (neutral-ssa-ligation-enabled? "0" "0" (("0" 2))) True)
!(test
  (neutral-ssa-ligation-enabled? "0" "1" (("0" 1) ("1" 0))) False)
!(test
  (neutral-ssa-adjust-count "1" -1 (("0" 2) ("1" 3) ("01" 0)))
  (("0" 2) ("1" 2) ("01" 0)))
!(test
  (neutral-ssa-event-enabled?
    (ligation lig-01 "0" "1" "01") (("0" 1) ("1" 1) ("01" 0)))
  True)
!(test
  (neutral-ssa-event-enabled?
    (cleavage cleave-01 "01" "0" "1") (("0" 1) ("1" 1) ("01" 0)))
  False)
!(test
  (neutral-ssa-apply-event
    (ligation lig-01 "0" "1" "01") (("0" 2) ("1" 2) ("01" 0)))
  (("0" 1) ("1" 1) ("01" 1)))
!(test
  (neutral-ssa-apply-event
    (cleavage cleave-01 "01" "0" "1") (("0" 1) ("1" 1) ("01" 1)))
  (("0" 2) ("1" 2) ("01" 0)))
!(test
  (neutral-ssa-apply-trace
    ((influx "0")
     (ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1")
     (dilution "0"))
    (("0" 2) ("1" 2) ("01" 0)))
  (("0" 2) ("1" 2) ("01" 0)))
!(test
  (neutral-ssa-apply-trace
    ((influx "0")
     (ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1")
     (dilution "0"))
    (("0" 2) ("1" 2) ("01" 0)))
  (neutral-ssa-apply-trace
    ((influx "0")
     (ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1")
     (dilution "0"))
    (("0" 2) ("1" 2) ("01" 0))))
!(test (neutral-ssa-influx-weight 100) 20000000)
!(test (neutral-ssa-influx-weight 50) 2500000)
!(test (neutral-ssa-influx-weight 200) 160000000)
!(test
  (neutral-ssa-dilution-weight "0" 100 (("0" 2) ("1" 0) ("01" 1)))
  2000000)
!(test
  (neutral-ssa-enumerate-events
    ("0" "1")
    ("0" "1" "01")
    ((cleavage cleave-01 "01" "0" "1")
     (ligation lig-01 "0" "1" "01"))
    100
    (("0" 2) ("1" 1) ("01" 0))
    ())
  (((influx "0") 20000000)
   ((influx "1") 20000000)
   ((dilution "0") 2000000)
   ((dilution "1") 1000000)
   ((ligation lig-01 "0" "1" "01") 200)))
!(test
  (neutral-ssa-enumerate-events
    ("0")
    ("0" "1" "01")
    ((cleavage cleave-01 "01" "0" "1")
     (ligation lig-01 "0" "1" "01"))
    100
    (("0" 1) ("1" 0) ("01" 2))
    (("01" cleave-01)))
  (((influx "0") 20000000)
   ((dilution "0") 1000000)
   ((dilution "01") 2000000)
   ((cleavage cleave-01 "01" "0" "1") 40020000)))
!(test
  (neutral-ssa-enumerate-events
    () ("0") () 100 (("0" 0)) ())
  ())
!(test (neutral-ssa-weight-total ((influx-0 20) (lig-01 5) (cleave-01 3))) 28)
!(test
  (neutral-ssa-select-threshold 0 ((influx-0 20) (lig-01 5) (cleave-01 3)))
  influx-0)
!(test
  (neutral-ssa-select-threshold 20 ((influx-0 20) (lig-01 5) (cleave-01 3)))
  lig-01)
!(test
  (neutral-ssa-select-threshold 27 ((influx-0 20) (lig-01 5) (cleave-01 3)))
  cleave-01)
!(test (neutral-ssa-seeded-draw 2001 0 100 ()) no-enabled-event)
!(test
  (neutral-ssa-seeded-draw
    2001 0 100 ((influx-0 20) (lig-01 5) (cleave-01 3)))
  (neutral-ssa-seeded-draw
    2001 0 100 ((influx-0 20) (lig-01 5) (cleave-01 3))))
!(test
  (neutral-ssa-waiting-uniform-numerator 2001 0)
  438717)
!(test (neutral-ssa-waiting-time 1000000 1 100) 0.0)
!(test
  (> (neutral-ssa-waiting-time 500000 10000 1) 0)
  True)
!(test
  (neutral-ssa-step
    1 0
    () ()
    ((ligation lig-01 "0" "1" "01"))
    100 () (("0" 1) ("1" 1) ("01" 0)))
  (ssa-step
    draw
      (ssa-draw
        event (ligation lig-01 "0" "1" "01")
        waiting-uniform (40717 1000000)
        total-weight 100
        propensity-denominator 100000000
        waiting-time
          (neutral-ssa-waiting-time 40717 100 100))
    counts (("0" 0) ("1" 0) ("01" 1))))
!(test
  (neutral-ssa-run
    1 2
    () ()
    ((ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1"))
    100 () (("0" 1) ("1" 1) ("01" 0)))
  (ssa-run
    seed 1
    events
      ((ssa-draw
         event (ligation lig-01 "0" "1" "01")
         waiting-uniform (40717 1000000)
         total-weight 100
         propensity-denominator 100000000
         waiting-time
           (neutral-ssa-waiting-time 40717 100 100))
       (ssa-draw
         event (cleavage cleave-01 "01" "0" "1")
         waiting-uniform (106254 1000000)
         total-weight 10000
         propensity-denominator 100000000
         waiting-time
           (neutral-ssa-waiting-time 106254 10000 100)))
    final-counts (("0" 1) ("1" 1) ("01" 0))
    stop event-bound))
!(test
  (neutral-ssa-draw-waiting-time
    (neutral-ssa-seeded-draw 1 0 100 ((only-event 100))))
  (neutral-ssa-waiting-time 40717 100 100))
!(test
  (neutral-ssa-timed-events
    ((ssa-draw
       event first
       waiting-uniform (500000 1000000)
       total-weight 1
       propensity-denominator 10000
       waiting-time 1.25)
     (ssa-draw
       event second
       waiting-uniform (250000 1000000)
       total-weight 1
       propensity-denominator 10000
       waiting-time 2.5)))
  ((ssa-timed-event index 0 time 1.25 event first)
   (ssa-timed-event index 1 time 3.75 event second)))
!(test
  (neutral-ssa-run-timed-events
    (neutral-ssa-run
      1 2
      () ()
      ((ligation lig-01 "0" "1" "01")
       (cleavage cleave-01 "01" "0" "1"))
      100 () (("0" 1) ("1" 1) ("01" 0))))
  (neutral-ssa-timed-events
    (neutral-ssa-run-events
      (neutral-ssa-run
        1 2
        () ()
        ((ligation lig-01 "0" "1" "01")
         (cleavage cleave-01 "01" "0" "1"))
        100 () (("0" 1) ("1" 1) ("01" 0))))))
!(test
  (neutral-ssa-timed-states
    (("0" 1) ("1" 1) ("01" 0))
    ((ssa-draw
       event (ligation lig-01 "0" "1" "01")
       waiting-uniform (500000 1000000)
       total-weight 1
       propensity-denominator 10000
       waiting-time 1.25)
     (ssa-draw
       event (cleavage cleave-01 "01" "0" "1")
       waiting-uniform (250000 1000000)
       total-weight 1
       propensity-denominator 10000
       waiting-time 2.5)))
  ((ssa-timed-state
     index 0 time 1.25
     event (ligation lig-01 "0" "1" "01")
     counts (("0" 0) ("1" 0) ("01" 1)))
   (ssa-timed-state
     index 1 time 3.75
     event (cleavage cleave-01 "01" "0" "1")
     counts (("0" 1) ("1" 1) ("01" 0)))))
!(test
  (neutral-ssa-run-timed-states
    (("0" 1) ("1" 1) ("01" 0))
    (neutral-ssa-run
      1 2
      () ()
      ((ligation lig-01 "0" "1" "01")
       (cleavage cleave-01 "01" "0" "1"))
      100 () (("0" 1) ("1" 1) ("01" 0))))
  (neutral-ssa-timed-states
    (("0" 1) ("1" 1) ("01" 0))
    (neutral-ssa-run-events
      (neutral-ssa-run
        1 2
        () ()
        ((ligation lig-01 "0" "1" "01")
         (cleavage cleave-01 "01" "0" "1"))
        100 () (("0" 1) ("1" 1) ("01" 0))))))
!(test
  (neutral-ssa-timed-transitions
    (("0" 1) ("1" 1) ("01" 0))
    ((ssa-draw
       event (ligation lig-01 "0" "1" "01")
       waiting-uniform (500000 1000000)
       total-weight 1
       propensity-denominator 10000
       waiting-time 1.25)
     (ssa-draw
       event (cleavage cleave-01 "01" "0" "1")
       waiting-uniform (250000 1000000)
       total-weight 1
       propensity-denominator 10000
       waiting-time 2.5)))
  ((ssa-timed-transition
     index 0 time 1.25
     event (ligation lig-01 "0" "1" "01")
     before-counts (("0" 1) ("1" 1) ("01" 0))
     after-counts (("0" 0) ("1" 0) ("01" 1)))
   (ssa-timed-transition
     index 1 time 3.75
     event (cleavage cleave-01 "01" "0" "1")
     before-counts (("0" 0) ("1" 0) ("01" 1))
     after-counts (("0" 1) ("1" 1) ("01" 0)))))
!(test
  (neutral-ssa-run-timed-transitions
    (("0" 1) ("1" 1) ("01" 0))
    (neutral-ssa-run
      1 2
      () ()
      ((ligation lig-01 "0" "1" "01")
       (cleavage cleave-01 "01" "0" "1"))
      100 () (("0" 1) ("1" 1) ("01" 0))))
  (neutral-ssa-timed-transitions
    (("0" 1) ("1" 1) ("01" 0))
    (neutral-ssa-run-events
      (neutral-ssa-run
        1 2
        () ()
        ((ligation lig-01 "0" "1" "01")
         (cleavage cleave-01 "01" "0" "1"))
        100 () (("0" 1) ("1" 1) ("01" 0))))))
!(test
  (neutral-ssa-time-bin-index 99.999 100 10 40)
  outside-persistence-window)
!(test (neutral-ssa-time-bin-index 100.0 100 10 40) 0)
!(test (neutral-ssa-time-bin-index 109.999 100 10 40) 0)
!(test (neutral-ssa-time-bin-index 110.0 100 10 40) 1)
!(test (neutral-ssa-time-bin-index 499.999 100 10 40) 39)
!(test
  (neutral-ssa-time-bin-index 500.0 100 10 40)
  outside-persistence-window)
!(test
  (neutral-ssa-bin-timed-states
    ((ssa-timed-state index 0 time 99.0 event before counts (("0" 1)))
     (ssa-timed-state index 1 time 100.0 event start counts (("0" 2)))
     (ssa-timed-state index 2 time 109.0 event same-bin counts (("0" 3)))
     (ssa-timed-state index 3 time 110.0 event next-bin counts (("0" 4)))
     (ssa-timed-state index 4 time 500.0 event after counts (("0" 5))))
    100 10 40)
  ((ssa-binned-state
     bin 0
     state
       (ssa-timed-state index 1 time 100.0 event start counts (("0" 2))))
   (ssa-binned-state
     bin 0
     state
       (ssa-timed-state index 2 time 109.0 event same-bin counts (("0" 3))))
   (ssa-binned-state
     bin 1
     state
       (ssa-timed-state index 3 time 110.0 event next-bin counts (("0" 4))))))
!(test
  (neutral-ssa-run-until
    1 2 0.0
    () ()
    ((ligation lig-01 "0" "1" "01"))
    100 () (("0" 1) ("1" 1) ("01" 0)))
  (ssa-run
    seed 1 events ()
    final-counts (("0" 1) ("1" 1) ("01" 0))
    final-time 0.0
    stop time-bound))
!(test
  (neutral-ssa-run-until
    1 2 1.0
    () ()
    ((ligation lig-01 "0" "1" "01"))
    100 () (("0" 1) ("1" 1) ("01" 0)))
  (ssa-run
    seed 1 events ()
    final-counts (("0" 1) ("1" 1) ("01" 0))
    final-time 1.0
    stop time-bound))
!(test
  (neutral-ssa-run-until
    1 1 4000000.0
    () ()
    ((ligation lig-01 "0" "1" "01"))
    100 () (("0" 1) ("1" 1) ("01" 0)))
  (ssa-run
    seed 1
    events
      ((ssa-draw
         event (ligation lig-01 "0" "1" "01")
         waiting-uniform (40717 1000000)
         total-weight 100
         propensity-denominator 100000000
         waiting-time
           (neutral-ssa-waiting-time 40717 100 100)))
    final-counts (("0" 0) ("1" 0) ("01" 1))
    final-time (neutral-ssa-waiting-time 40717 100 100)
    stop event-bound))
!(test
  (neutral-ssa-run
    1 2
    () ()
    ((ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1"))
    100 () (("0" 1) ("1" 1) ("01" 0)))
  (neutral-ssa-run
    1 2
    () ()
    ((ligation lig-01 "0" "1" "01")
     (cleavage cleave-01 "01" "0" "1"))
    100 () (("0" 1) ("1" 1) ("01" 0))))
!(test
  (neutral-ssa-run
    1 3 () ("0") () 100 () (("0" 0)))
  (ssa-run
    seed 1 events () final-counts (("0" 0)) stop no-enabled-event))
!(test
  (neutral-ssa-run-system
    1001 2001 0 2 0.0
    ("0" "1") ("0" "1" "01")
    ((ligation lig-01 "0" "1" "01"))
    100)
  (neutral-system-run
    model neutral-crs-v1
    graph-seed 1001
    dynamics-seed 2001
    f-twice 0
    volume 100
    catalysis ()
    result
      (ssa-run
        seed 2001
        events ()
        final-counts (("0" 20) ("1" 20) ("01" 0))
        final-time 0.0
        stop time-bound)))
!(test
  (neutral-ssa-run-system
    1001 2001 2 2 0.0
    ("0" "1") ("0" "1" "01")
    ((ligation lig-01 "0" "1" "01"))
    100)
  (neutral-ssa-run-system
    1001 2001 2 2 0.0
    ("0" "1") ("0" "1" "01")
    ((ligation lig-01 "0" "1" "01"))
    100))
!(test
  (neutral-ssa-counts-nonnegative?
    (neutral-ssa-step-counts
      (neutral-ssa-step
        1 0
        () ()
        ((ligation lig-01 "0" "1" "01"))
        100 () (("0" 1) ("1" 1) ("01" 0)))))
  True)
!(test
  (neutral-ssa-tiny-step 0 (("0" 1) ("1" 1) ("01" 0)))
  (("0" 0) ("1" 0) ("01" 1)))
!(test
  (neutral-ssa-tiny-run (("0" 1) ("1" 1) ("01" 0)))
  (("0" 1) ("1" 1) ("01" 0)))
!(test
  (neutral-ssa-tiny-run (("0" 1) ("1" 1) ("01" 0)))
  (neutral-ssa-tiny-run (("0" 1) ("1" 1) ("01" 0))))
!(test
  (neutral-ssa-tiny-control-record)
  (neutral-ssa-control
    model neutral-crs-v1
    initial (("0" 1) ("1" 1) ("01" 0))
    event-stream (ligation cleavage)
    final (("0" 1) ("1" 1) ("01" 0))
    replay exact
    calibration-endpoints uninspected))
