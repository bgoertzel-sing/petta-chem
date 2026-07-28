!(import! &self ../../src/chem_neutral_ssa.metta)

!(test (neutral-ssa-count "0" (("0" 20) ("1" 20))) 20)
!(test (neutral-ssa-count "01" (("0" 20) ("1" 20))) 0)
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
!(test (neutral-ssa-seeded-draw 2001 0 ()) no-enabled-event)
!(test
  (neutral-ssa-seeded-draw
    2001 0 ((influx-0 20) (lig-01 5) (cleave-01 3)))
  (neutral-ssa-seeded-draw
    2001 0 ((influx-0 20) (lig-01 5) (cleave-01 3))))
!(test
  (neutral-ssa-waiting-uniform-numerator 2001 0)
  438717)
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
