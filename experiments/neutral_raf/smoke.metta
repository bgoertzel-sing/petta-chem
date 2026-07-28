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
!(test (neutral-raf-hand-fixture-serialization-status)
       (neutral-raf-interface neutral-crs-v1 hand-fixtures 7
                              sampled-calibration embargoed
                              exhaustive-comparison pending))
