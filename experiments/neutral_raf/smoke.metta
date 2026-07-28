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
!(test (neutral-raf-hand-fixture-serialization-status)
       (neutral-raf-interface neutral-crs-v1 hand-fixtures 7
                              sampled-calibration embargoed
                              subset-predicate implemented
                              exhaustive-enumeration pending))
