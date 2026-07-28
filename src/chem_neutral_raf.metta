; Canonical PeTTa fact boundary for the frozen neutral-crs-v1 RAF gate.
;
; This file owns chemistry-facing facts only.  It does not contain Python
; chemistry logic, sampled calibration results, or the exhaustive detector.

(= (raf-system-id
      (raf-system $system-id model neutral-crs-v1 food $food))
   $system-id)

(= (raf-system-food
      (raf-system $system-id model neutral-crs-v1 food $food))
   $food)

(= (raf-reaction-id
      (raf-reaction $system-id $rule-id reactants $reactants products $products))
   $rule-id)

(= (raf-reaction-reactants
      (raf-reaction $system-id $rule-id reactants $reactants products $products))
   $reactants)

(= (raf-reaction-products
      (raf-reaction $system-id $rule-id reactants $reactants products $products))
   $products)

(= (raf-catalysis-catalyst
      (raf-catalysis $system-id $catalyst $rule-id))
   $catalyst)

(= (raf-catalysis-rule-id
      (raf-catalysis $system-id $catalyst $rule-id))
   $rule-id)

; Frozen hand-fixture facts.  Lists preserve stoichiometric duplicates and
; canonical lexical order.  These atoms are the PeTTa side of the interface;
; expected RAF classifications remain independently computed by the oracle.

(= (neutral-raf-fixture-food-chain)
   ((raf-system food-chain model neutral-crs-v1 food ("0" "1"))
    (raf-reaction food-chain r1 reactants ("0" "1") products ("01"))
    (raf-reaction food-chain r2 reactants ("01" "1") products ("011"))
    (raf-catalysis food-chain "0" r1)
    (raf-catalysis food-chain "011" r2)))

(= (neutral-raf-fixture-multiple-products-catalysts)
   ((raf-system multiple-products model neutral-crs-v1 food ("0" "01" "1"))
    (raf-reaction multiple-products cleave reactants ("01") products ("0" "1"))
    (raf-reaction multiple-products left reactants ("0" "0") products ("00"))
    (raf-reaction multiple-products right reactants ("1" "1") products ("11"))
    (raf-catalysis multiple-products "0" cleave)
    (raf-catalysis multiple-products "0" left)
    (raf-catalysis multiple-products "1" cleave)
    (raf-catalysis multiple-products "1" right)))

(= (neutral-raf-fixture-food-catalyst)
   ((raf-system food-catalyst model neutral-crs-v1 food ("0" "1"))
    (raf-reaction food-catalyst r reactants ("0" "1") products ("01"))
    (raf-catalysis food-catalyst "0" r)))

(= (neutral-raf-fixture-self-catalysis)
   ((raf-system self-catalysis model neutral-crs-v1 food ("0" "1"))
    (raf-reaction self-catalysis r reactants ("0" "1") products ("01"))
    (raf-catalysis self-catalysis "01" r)))

(= (neutral-raf-fixture-unreachable-cycle)
   ((raf-system unreachable-cycle model neutral-crs-v1 food ("0" "1"))
    (raf-reaction unreachable-cycle r1 reactants (x) products (y))
    (raf-reaction unreachable-cycle r2 reactants (y) products (x))
    (raf-catalysis unreachable-cycle x r2)
    (raf-catalysis unreachable-cycle y r1)))

(= (neutral-raf-fixture-edge-monotonic-base)
   ((raf-system edge-base model neutral-crs-v1 food ("0" "1"))
    (raf-reaction edge-base r1 reactants ("0") products ("00"))
    (raf-reaction edge-base r2 reactants ("1") products ("11"))
    (raf-catalysis edge-base "0" r1)))

(= (neutral-raf-fixture-edge-monotonic-added)
   ((raf-system edge-added model neutral-crs-v1 food ("0" "1"))
    (raf-reaction edge-added r1 reactants ("0") products ("00"))
    (raf-reaction edge-added r2 reactants ("1") products ("11"))
    (raf-catalysis edge-added "0" r1)
    (raf-catalysis edge-added "1" r2)))

(= (neutral-raf-fixture-deletion-positive)
   ((raf-system deletion-positive model neutral-crs-v1 food ("0" "1"))
    (raf-reaction deletion-positive r1 reactants ("0") products ("00"))
    (raf-reaction deletion-positive r2 reactants ("00" "1") products ("001"))
    (raf-catalysis deletion-positive "0" r1)
    (raf-catalysis deletion-positive "001" r2)))

(= (neutral-raf-fixture-deletion-edge)
   ((raf-system deletion-edge model neutral-crs-v1 food ("0" "1"))
    (raf-reaction deletion-edge r1 reactants ("0") products ("00"))
    (raf-reaction deletion-edge r2 reactants ("00" "1") products ("001"))
    (raf-catalysis deletion-edge "0" r1)))

(= (neutral-raf-fixture-deletion-reaction)
   ((raf-system deletion-reaction model neutral-crs-v1 food ("0" "1"))
    (raf-reaction deletion-reaction r2 reactants ("00" "1") products ("001"))
    (raf-catalysis deletion-reaction "001" r2)))

(= (neutral-raf-hand-fixture-family-count) 7)
(= (neutral-raf-hand-fixture-serialization-status)
   (neutral-raf-interface neutral-crs-v1 hand-fixtures 7
                          sampled-calibration embargoed
                          exhaustive-comparison pending))
