!(import! &self ../../src/chem_neutral_raf.metta)

!(test
  (raf-system-food (raf-system fixture model neutral-crs-v1 food ("0" "1")))
  ("0" "1"))
!(test
  (raf-reaction-reactants
    (raf-reaction fixture r reactants ("0" "0") products ("00")))
  ("0" "0"))
!(test
  (raf-reaction-products
    (raf-reaction fixture cleave reactants ("01") products ("0" "1")))
  ("0" "1"))
!(test
  (raf-catalysis-rule-id (raf-catalysis fixture "01" r))
  r)

!(test (neutral-raf-hand-fixture-family-count) 7)
!(test (neutral-raf-fixture-food-catalyst)
       ((raf-system food-catalyst model neutral-crs-v1 food ("0" "1"))
        (raf-reaction food-catalyst r reactants ("0" "1") products ("01"))
        (raf-catalysis food-catalyst "0" r)))
!(test (neutral-raf-fixture-self-catalysis)
       ((raf-system self-catalysis model neutral-crs-v1 food ("0" "1"))
        (raf-reaction self-catalysis r reactants ("0" "1") products ("01"))
        (raf-catalysis self-catalysis "01" r)))
!(test (neutral-raf-fixture-unreachable-cycle)
       ((raf-system unreachable-cycle model neutral-crs-v1 food ("0" "1"))
        (raf-reaction unreachable-cycle r1 reactants (x) products (y))
        (raf-reaction unreachable-cycle r2 reactants (y) products (x))
        (raf-catalysis unreachable-cycle x r2)
        (raf-catalysis unreachable-cycle y r1)))

; Generic PeTTa closure/RAF predicate checks against the frozen oracle truths.
!(test
  (neutral-raf-closure
    ("0" "1")
    ((raf-reaction food-chain r1 reactants ("0" "1") products ("01"))
     (raf-reaction food-chain r2 reactants ("01" "1") products ("011"))))
  ("011" "01" "0" "1"))
!(test
  (neutral-raf-is-raf?
    ("0" "1")
    ((raf-reaction food-chain r2 reactants ("01" "1") products ("011")))
    ((raf-catalysis food-chain "011" r2)))
  False)
!(test
  (neutral-raf-is-raf?
    ("0" "1")
    ((raf-reaction food-chain r1 reactants ("0" "1") products ("01"))
     (raf-reaction food-chain r2 reactants ("01" "1") products ("011")))
    ((raf-catalysis food-chain "0" r1)
     (raf-catalysis food-chain "011" r2)))
  True)
!(test
  (neutral-raf-is-raf?
    ("0" "01" "1")
    ((raf-reaction multiple-products cleave
       reactants ("01") products ("0" "1")))
    ((raf-catalysis multiple-products "0" cleave)
     (raf-catalysis multiple-products "1" cleave)))
  True)
!(test
  (neutral-raf-is-raf?
    ("0" "1")
    ((raf-reaction food-catalyst r reactants ("0" "1") products ("01")))
    ((raf-catalysis food-catalyst "0" r)))
  True)
!(test
  (neutral-raf-is-raf?
    ("0" "1")
    ((raf-reaction self-catalysis r reactants ("0" "1") products ("01")))
    ((raf-catalysis self-catalysis "01" r)))
  True)
!(test
  (neutral-raf-is-raf?
    ("0" "1")
    ((raf-reaction unreachable-cycle r1 reactants (x) products (y))
     (raf-reaction unreachable-cycle r2 reactants (y) products (x)))
    ((raf-catalysis unreachable-cycle x r2)
     (raf-catalysis unreachable-cycle y r1)))
  False)
!(test
  (neutral-raf-is-raf?
    ("0" "1")
    ((raf-reaction edge-added r1 reactants ("0") products ("00"))
     (raf-reaction edge-added r2 reactants ("1") products ("11")))
    ((raf-catalysis edge-added "0" r1)
     (raf-catalysis edge-added "1" r2)))
  True)
!(test
  (neutral-raf-is-raf?
    ("0" "1")
    ((raf-reaction deletion-edge r1 reactants ("0") products ("00"))
     (raf-reaction deletion-edge r2 reactants ("00" "1") products ("001")))
    ((raf-catalysis deletion-edge "0" r1)))
  False)
!(test
  (neutral-raf-is-raf?
    ("0" "1")
    ((raf-reaction deletion-reaction r2
       reactants ("00" "1") products ("001")))
    ((raf-catalysis deletion-reaction "001" r2)))
  False)
!(test
  (neutral-raf-exhaustive-subset-ids
    ("0" "1")
    ((raf-reaction food-chain r1 reactants ("0" "1") products ("01"))
     (raf-reaction food-chain r2 reactants ("01" "1") products ("011")))
    ((raf-catalysis food-chain "0" r1)
     (raf-catalysis food-chain "011" r2)))
  ((r1) (r1 r2)))
!(test
  (neutral-raf-exhaustive-subset-ids
    ("0" "01" "1")
    ((raf-reaction multiple-products cleave
       reactants ("01") products ("0" "1"))
     (raf-reaction multiple-products left
       reactants ("0" "0") products ("00"))
     (raf-reaction multiple-products right
       reactants ("1" "1") products ("11")))
    ((raf-catalysis multiple-products "0" cleave)
     (raf-catalysis multiple-products "0" left)
     (raf-catalysis multiple-products "1" cleave)
     (raf-catalysis multiple-products "1" right)))
  ((right) (left) (left right) (cleave) (cleave right)
   (cleave left) (cleave left right)))
!(test
  (neutral-raf-exhaustive-subset-ids
    ("0" "1")
    ((raf-reaction unreachable-cycle r1 reactants (x) products (y))
     (raf-reaction unreachable-cycle r2 reactants (y) products (x)))
    ((raf-catalysis unreachable-cycle x r2)
     (raf-catalysis unreachable-cycle y r1)))
  ())
!(test
  (neutral-raf-maximal-ids
    ("0" "1")
    ((raf-reaction food-chain r1 reactants ("0" "1") products ("01"))
     (raf-reaction food-chain r2 reactants ("01" "1") products ("011")))
    ((raf-catalysis food-chain "0" r1)
     (raf-catalysis food-chain "011" r2)))
  (r1 r2))
!(test
  (neutral-raf-irreducible-subset-ids
    ("0" "1")
    ((raf-reaction food-chain r1 reactants ("0" "1") products ("01"))
     (raf-reaction food-chain r2 reactants ("01" "1") products ("011")))
    ((raf-catalysis food-chain "0" r1)
     (raf-catalysis food-chain "011" r2)))
  ((r1)))
!(test
  (neutral-raf-maximal-ids
    ("0" "01" "1")
    ((raf-reaction multiple-products cleave
       reactants ("01") products ("0" "1"))
     (raf-reaction multiple-products left
       reactants ("0" "0") products ("00"))
     (raf-reaction multiple-products right
       reactants ("1" "1") products ("11")))
    ((raf-catalysis multiple-products "0" cleave)
     (raf-catalysis multiple-products "0" left)
     (raf-catalysis multiple-products "1" cleave)
     (raf-catalysis multiple-products "1" right)))
  (cleave left right))
!(test
  (neutral-raf-irreducible-subset-ids
    ("0" "01" "1")
    ((raf-reaction multiple-products cleave
       reactants ("01") products ("0" "1"))
     (raf-reaction multiple-products left
       reactants ("0" "0") products ("00"))
     (raf-reaction multiple-products right
       reactants ("1" "1") products ("11")))
    ((raf-catalysis multiple-products "0" cleave)
     (raf-catalysis multiple-products "0" left)
     (raf-catalysis multiple-products "1" cleave)
     (raf-catalysis multiple-products "1" right)))
  ((right) (left) (cleave)))
!(test
  (neutral-raf-maximal-ids
    ("0" "1")
    ((raf-reaction unreachable-cycle r1 reactants (x) products (y))
     (raf-reaction unreachable-cycle r2 reactants (y) products (x)))
    ((raf-catalysis unreachable-cycle x r2)
     (raf-catalysis unreachable-cycle y r1)))
  ())
!(test
  (neutral-raf-irreducible-subset-ids
    ("0" "1")
    ((raf-reaction unreachable-cycle r1 reactants (x) products (y))
     (raf-reaction unreachable-cycle r2 reactants (y) products (x)))
    ((raf-catalysis unreachable-cycle x r2)
     (raf-catalysis unreachable-cycle y r1)))
  ())
!(test (neutral-raf-list-length (neutral-raf-l3-molecules)) 14)
!(test (neutral-raf-l3-food) ("0" "00" "01" "1" "10" "11"))
!(test (neutral-raf-l3-reaction-count) 40)
!(test
  (neutral-raf-l3-reaction-ids)
  ("cleave:00:1"
   "cleave:000:1" "cleave:000:2"
   "cleave:001:1" "cleave:001:2"
   "cleave:01:1"
   "cleave:010:1" "cleave:010:2"
   "cleave:011:1" "cleave:011:2"
   "cleave:10:1"
   "cleave:100:1" "cleave:100:2"
   "cleave:101:1" "cleave:101:2"
   "cleave:11:1"
   "cleave:110:1" "cleave:110:2"
   "cleave:111:1" "cleave:111:2"
   "lig:0:0" "lig:0:00" "lig:0:01" "lig:0:1" "lig:0:10" "lig:0:11"
   "lig:00:0" "lig:00:1" "lig:01:0" "lig:01:1"
   "lig:1:0" "lig:1:00" "lig:1:01" "lig:1:1" "lig:1:10" "lig:1:11"
   "lig:10:0" "lig:10:1" "lig:11:0" "lig:11:1"))
!(test (neutral-raf-hand-fixture-serialization-status)
       (neutral-raf-interface neutral-crs-v1 hand-fixtures 7
                              sampled-calibration embargoed
                              subset-predicate implemented
                              exhaustive-enumeration implemented
                              maximal-and-irrraf implemented))
