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

; Independent PeTTa structural predicate.  It consumes only the canonical
; logical fields above.  Closure is iterated once per candidate reaction,
; which is sufficient because each productive pass adds at least one molecule
; and no reaction can first become enabled after more than |R'| passes.

(= (neutral-raf-member? $wanted $items)
   (if (== $items ())
       False
       (if (== $wanted (car-atom $items))
           True
           (neutral-raf-member? $wanted (cdr-atom $items)))))

(= (neutral-raf-all-members? $wanted $available)
   (if (== $wanted ())
       True
       (and (neutral-raf-member? (car-atom $wanted) $available)
            (neutral-raf-all-members? (cdr-atom $wanted) $available))))

(= (neutral-raf-add-unique $molecule $available)
   (if (neutral-raf-member? $molecule $available)
       $available
       (cons-atom $molecule $available)))

(= (neutral-raf-add-products $products $available)
   (if (== $products ())
       $available
       (neutral-raf-add-products
         (cdr-atom $products)
         (neutral-raf-add-unique (car-atom $products) $available))))

(= (neutral-raf-closure-pass $reactions $available)
   (if (== $reactions ())
       $available
       (let $reaction (car-atom $reactions)
         (let $next
           (if (neutral-raf-all-members?
                 (raf-reaction-reactants $reaction) $available)
               (neutral-raf-add-products
                 (raf-reaction-products $reaction) $available)
               $available)
           (neutral-raf-closure-pass (cdr-atom $reactions) $next)))))

(= (neutral-raf-list-length $items)
   (if (== $items ())
       0
       (+ 1 (neutral-raf-list-length (cdr-atom $items)))))

(= (neutral-raf-closure-iterations $remaining $reactions $available)
   (if (== $remaining 0)
       $available
       (neutral-raf-closure-iterations
         (- $remaining 1)
         $reactions
         (neutral-raf-closure-pass $reactions $available))))

(= (neutral-raf-closure $food $reactions)
   (neutral-raf-closure-iterations
     (neutral-raf-list-length $reactions) $reactions $food))

(= (neutral-raf-has-catalyst? $rule-id $available $catalysis)
   (if (== $catalysis ())
       False
       (let $edge (car-atom $catalysis)
         (if (and (== (raf-catalysis-rule-id $edge) $rule-id)
                  (neutral-raf-member?
                    (raf-catalysis-catalyst $edge) $available))
             True
             (neutral-raf-has-catalyst?
               $rule-id $available (cdr-atom $catalysis))))))

(= (neutral-raf-all-reactions-valid? $reactions $available $catalysis)
   (if (== $reactions ())
       True
       (let $reaction (car-atom $reactions)
         (and
           (neutral-raf-all-members?
             (raf-reaction-reactants $reaction) $available)
           (and
             (neutral-raf-has-catalyst?
               (raf-reaction-id $reaction) $available $catalysis)
             (neutral-raf-all-reactions-valid?
               (cdr-atom $reactions) $available $catalysis))))))

(= (neutral-raf-is-raf? $food $reactions $catalysis)
   (if (== $reactions ())
       False
       (let $available (neutral-raf-closure $food $reactions)
         (neutral-raf-all-reactions-valid?
           $reactions $available $catalysis))))

; Exhaustive subset enumeration for the tiny-system oracle gate.  This is
; intentionally exponential and belongs only on the frozen <=12-reaction
; validation boundary, never on sampled calibration systems.

(= (neutral-raf-append $left $right)
   (if (== $left ())
       $right
       (cons-atom
         (car-atom $left)
         (neutral-raf-append (cdr-atom $left) $right))))

(= (neutral-raf-prepend-to-each $item $subsets)
   (if (== $subsets ())
       ()
       (cons-atom
         (cons-atom $item (car-atom $subsets))
         (neutral-raf-prepend-to-each $item (cdr-atom $subsets)))))

(= (neutral-raf-subsets $items)
   (if (== $items ())
       (())
       (let $tail-subsets (neutral-raf-subsets (cdr-atom $items))
         (neutral-raf-append
           $tail-subsets
           (neutral-raf-prepend-to-each
             (car-atom $items) $tail-subsets)))))

(= (neutral-raf-filter-subsets $food $subsets $catalysis)
   (if (== $subsets ())
       ()
       (let $subset (car-atom $subsets)
         (if (neutral-raf-is-raf? $food $subset $catalysis)
             (cons-atom
               $subset
               (neutral-raf-filter-subsets
                 $food (cdr-atom $subsets) $catalysis))
             (neutral-raf-filter-subsets
               $food (cdr-atom $subsets) $catalysis)))))

(= (neutral-raf-exhaustive-subsets $food $reactions $catalysis)
   (neutral-raf-filter-subsets
     $food (neutral-raf-subsets $reactions) $catalysis))

(= (neutral-raf-reaction-ids $reactions)
   (if (== $reactions ())
       ()
       (cons-atom
         (raf-reaction-id (car-atom $reactions))
         (neutral-raf-reaction-ids (cdr-atom $reactions)))))

(= (neutral-raf-subset-ids $subsets)
   (if (== $subsets ())
       ()
       (cons-atom
         (neutral-raf-reaction-ids (car-atom $subsets))
         (neutral-raf-subset-ids (cdr-atom $subsets)))))

(= (neutral-raf-exhaustive-subset-ids $food $reactions $catalysis)
   (neutral-raf-subset-ids
     (neutral-raf-exhaustive-subsets $food $reactions $catalysis)))

(= (neutral-raf-reaction-member? $wanted $reactions)
   (if (== $reactions ())
       False
       (if (== (raf-reaction-id $wanted)
               (raf-reaction-id (car-atom $reactions)))
           True
           (neutral-raf-reaction-member? $wanted (cdr-atom $reactions)))))

(= (neutral-raf-reaction-in-any-subset? $wanted $subsets)
   (if (== $subsets ())
       False
       (if (neutral-raf-reaction-member? $wanted (car-atom $subsets))
           True
           (neutral-raf-reaction-in-any-subset?
             $wanted (cdr-atom $subsets)))))

(= (neutral-raf-maximal-from-subsets $reactions $subsets)
   (if (== $reactions ())
       ()
       (let $reaction (car-atom $reactions)
         (if (neutral-raf-reaction-in-any-subset? $reaction $subsets)
             (cons-atom
               $reaction
               (neutral-raf-maximal-from-subsets
                 (cdr-atom $reactions) $subsets))
             (neutral-raf-maximal-from-subsets
               (cdr-atom $reactions) $subsets)))))

(= (neutral-raf-maximal-ids $food $reactions $catalysis)
   (neutral-raf-reaction-ids
     (neutral-raf-maximal-from-subsets
       $reactions
       (neutral-raf-exhaustive-subsets $food $reactions $catalysis))))

(= (neutral-raf-reaction-subset? $left $right)
   (if (== $left ())
       True
       (and (neutral-raf-reaction-member? (car-atom $left) $right)
            (neutral-raf-reaction-subset? (cdr-atom $left) $right))))

(= (neutral-raf-proper-reaction-subset? $left $right)
   (and (neutral-raf-reaction-subset? $left $right)
        (< (neutral-raf-list-length $left)
           (neutral-raf-list-length $right))))

(= (neutral-raf-has-proper-raf-subset? $wanted $raf-subsets)
   (if (== $raf-subsets ())
       False
       (if (neutral-raf-proper-reaction-subset?
             (car-atom $raf-subsets) $wanted)
           True
           (neutral-raf-has-proper-raf-subset?
             $wanted (cdr-atom $raf-subsets)))))

(= (neutral-raf-filter-irreducible $remaining $all-raf-subsets)
   (if (== $remaining ())
       ()
       (let $subset (car-atom $remaining)
         (if (neutral-raf-has-proper-raf-subset? $subset $all-raf-subsets)
             (neutral-raf-filter-irreducible
               (cdr-atom $remaining) $all-raf-subsets)
             (cons-atom
               $subset
               (neutral-raf-filter-irreducible
                 (cdr-atom $remaining) $all-raf-subsets))))))

(= (neutral-raf-irreducible-subset-ids $food $reactions $catalysis)
   (let $raf-subsets
     (neutral-raf-exhaustive-subsets $food $reactions $catalysis)
     (neutral-raf-subset-ids
       (neutral-raf-filter-irreducible $raf-subsets $raf-subsets))))

; Canonical full R_3 universe for the generated tiny-system gate.  The order
; is frozen by (kind, reactants, products): cleavages first, then ordered
; ligations.  Sampling must select eight entries from this PeTTa-owned list;
; the host oracle must never reconstruct it.

(= (neutral-raf-l3-molecules)
   ("0" "00" "000" "001" "01" "010" "011"
    "1" "10" "100" "101" "11" "110" "111"))

(= (neutral-raf-l3-food)
   ("0" "00" "01" "1" "10" "11"))

(= (neutral-raf-l3-reactions $system-id)
   ((raf-reaction $system-id "cleave:00:1" reactants ("00") products ("0" "0"))
    (raf-reaction $system-id "cleave:000:1" reactants ("000") products ("0" "00"))
    (raf-reaction $system-id "cleave:000:2" reactants ("000") products ("00" "0"))
    (raf-reaction $system-id "cleave:001:1" reactants ("001") products ("0" "01"))
    (raf-reaction $system-id "cleave:001:2" reactants ("001") products ("00" "1"))
    (raf-reaction $system-id "cleave:01:1" reactants ("01") products ("0" "1"))
    (raf-reaction $system-id "cleave:010:1" reactants ("010") products ("0" "10"))
    (raf-reaction $system-id "cleave:010:2" reactants ("010") products ("01" "0"))
    (raf-reaction $system-id "cleave:011:1" reactants ("011") products ("0" "11"))
    (raf-reaction $system-id "cleave:011:2" reactants ("011") products ("01" "1"))
    (raf-reaction $system-id "cleave:10:1" reactants ("10") products ("1" "0"))
    (raf-reaction $system-id "cleave:100:1" reactants ("100") products ("1" "00"))
    (raf-reaction $system-id "cleave:100:2" reactants ("100") products ("10" "0"))
    (raf-reaction $system-id "cleave:101:1" reactants ("101") products ("1" "01"))
    (raf-reaction $system-id "cleave:101:2" reactants ("101") products ("10" "1"))
    (raf-reaction $system-id "cleave:11:1" reactants ("11") products ("1" "1"))
    (raf-reaction $system-id "cleave:110:1" reactants ("110") products ("1" "10"))
    (raf-reaction $system-id "cleave:110:2" reactants ("110") products ("11" "0"))
    (raf-reaction $system-id "cleave:111:1" reactants ("111") products ("1" "11"))
    (raf-reaction $system-id "cleave:111:2" reactants ("111") products ("11" "1"))
    (raf-reaction $system-id "lig:0:0" reactants ("0" "0") products ("00"))
    (raf-reaction $system-id "lig:0:00" reactants ("0" "00") products ("000"))
    (raf-reaction $system-id "lig:0:01" reactants ("0" "01") products ("001"))
    (raf-reaction $system-id "lig:0:1" reactants ("0" "1") products ("01"))
    (raf-reaction $system-id "lig:0:10" reactants ("0" "10") products ("010"))
    (raf-reaction $system-id "lig:0:11" reactants ("0" "11") products ("011"))
    (raf-reaction $system-id "lig:00:0" reactants ("00" "0") products ("000"))
    (raf-reaction $system-id "lig:00:1" reactants ("00" "1") products ("001"))
    (raf-reaction $system-id "lig:01:0" reactants ("01" "0") products ("010"))
    (raf-reaction $system-id "lig:01:1" reactants ("01" "1") products ("011"))
    (raf-reaction $system-id "lig:1:0" reactants ("1" "0") products ("10"))
    (raf-reaction $system-id "lig:1:00" reactants ("1" "00") products ("100"))
    (raf-reaction $system-id "lig:1:01" reactants ("1" "01") products ("101"))
    (raf-reaction $system-id "lig:1:1" reactants ("1" "1") products ("11"))
    (raf-reaction $system-id "lig:1:10" reactants ("1" "10") products ("110"))
    (raf-reaction $system-id "lig:1:11" reactants ("1" "11") products ("111"))
    (raf-reaction $system-id "lig:10:0" reactants ("10" "0") products ("100"))
    (raf-reaction $system-id "lig:10:1" reactants ("10" "1") products ("101"))
    (raf-reaction $system-id "lig:11:0" reactants ("11" "0") products ("110"))
    (raf-reaction $system-id "lig:11:1" reactants ("11" "1") products ("111"))))

(= (neutral-raf-l3-reaction-count)
   (neutral-raf-list-length
     (neutral-raf-l3-reactions generated-l3-catalog)))

(= (neutral-raf-l3-reaction-ids)
   (neutral-raf-reaction-ids
     (neutral-raf-l3-reactions generated-l3-catalog)))

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
                          subset-predicate implemented
                          exhaustive-enumeration implemented
                          maximal-and-irrraf implemented))
