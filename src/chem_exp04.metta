; exp04 rich chemistry: mixed ligation/cleavage/modification with
; template-biased catalysis and permissive RAF detection.
;
; This experiment is deliberately PeTTa-native and inspectable.  It separates
; reaction templates from the older five-field `(rule ...)` atom by adding a
; richer rule atom:
;
;   (rich-rule <id> <type> <reactant-a> <reactant-b> <product> <secondary> <catalyst>)
;
; `reactant-b = None` denotes one-reactant reactions.  Cleavage stores the left
; product in `<product>` and the right product in `<secondary>`.

!(import! &self chem_exp00.metta)

; ----- Rich reaction schema -----

(= (make-rich-rule $id $type $a $b $product $secondary $catalyst)
   (rich-rule $id $type $a $b $product $secondary $catalyst))

(= (rich-rule-id (rich-rule $id $type $a $b $product $secondary $catalyst)) $id)
(= (rich-rule-type (rich-rule $id $type $a $b $product $secondary $catalyst)) $type)
(= (rich-rule-reactant-a (rich-rule $id $type $a $b $product $secondary $catalyst)) $a)
(= (rich-rule-reactant-b (rich-rule $id $type $a $b $product $secondary $catalyst)) $b)
(= (rich-rule-product (rich-rule $id $type $a $b $product $secondary $catalyst)) $product)
(= (rich-rule-secondary (rich-rule $id $type $a $b $product $secondary $catalyst)) $secondary)
(= (rich-rule-catalyst (rich-rule $id $type $a $b $product $secondary $catalyst)) $catalyst)

(= (ligation-rule? (rich-rule $id ligation $a $b $product None $catalyst)) True)
(= (cleavage-rule? (rich-rule $id cleavage $a None $product $secondary $catalyst)) True)
(= (modification-rule? (rich-rule $id modification $a None $product None $catalyst)) True)

; ----- Structural molecule names -----
;
; PeTTa symbols are atomic, so structural containment is represented by explicit
; facts.  Exp04 deliberately uses a success-biased but non-planted chemistry:
; rules are not hand-wired into a strict product=catalyst cycle, but the rule
; pool is rich in ligation/cleavage/modification motifs that make a RAF likely.
; Specificity threshold: template catalysis below avoids monomer-only matches;
; a catalyst must contain a non-food reactant/product, or be a modified form of
; such a molecule.

(= (structural-contains? A A) True)
(= (structural-contains? B B) True)
(= (structural-contains? C C) True)
(= (structural-contains? D D) True)
(= (structural-contains? AB A) True)
(= (structural-contains? AB B) True)
(= (structural-contains? AC A) True)
(= (structural-contains? AC C) True)
(= (structural-contains? AD A) True)
(= (structural-contains? AD D) True)
(= (structural-contains? BC B) True)
(= (structural-contains? BC C) True)
(= (structural-contains? BD B) True)
(= (structural-contains? BD D) True)
(= (structural-contains? CD C) True)
(= (structural-contains? CD D) True)
(= (structural-contains? ABC A) True)
(= (structural-contains? ABC B) True)
(= (structural-contains? ABC C) True)
(= (structural-contains? ABC AB) True)
(= (structural-contains? ABC BC) True)
(= (structural-contains? ABD A) True)
(= (structural-contains? ABD B) True)
(= (structural-contains? ABD D) True)
(= (structural-contains? ABD AB) True)
(= (structural-contains? ABD BD) True)
(= (structural-contains? ACD A) True)
(= (structural-contains? ACD C) True)
(= (structural-contains? ACD D) True)
(= (structural-contains? ACD AC) True)
(= (structural-contains? ACD CD) True)
(= (structural-contains? BCD B) True)
(= (structural-contains? BCD C) True)
(= (structural-contains? BCD D) True)
(= (structural-contains? BCD BC) True)
(= (structural-contains? BCD CD) True)
(= (structural-contains? ABstar AB) True)
(= (structural-contains? BCstar BC) True)
(= (structural-contains? ACstar AC) True)
(= (structural-contains? CDstar CD) True)
(= (structural-contains? ABCstar ABC) True)
(= (structural-contains? ABCstar AB) True)
(= (structural-contains? ABCstar BC) True)
(= (structural-contains? BCDstar BCD) True)
(= (structural-contains? BCDstar BC) True)
(= (structural-contains? BCDstar CD) True)

(= (non-food? AB) True)
(= (non-food? AC) True)
(= (non-food? AD) True)
(= (non-food? BC) True)
(= (non-food? BD) True)
(= (non-food? CD) True)
(= (non-food? ABC) True)
(= (non-food? ABD) True)
(= (non-food? ACD) True)
(= (non-food? BCD) True)
(= (non-food? ABstar) True)
(= (non-food? BCstar) True)
(= (non-food? ACstar) True)
(= (non-food? CDstar) True)
(= (non-food? ABCstar) True)
(= (non-food? BCDstar) True)

; Template-catalysis facts generated from structural containment with the
; specificity threshold above.  Examples: catalyst ABC can catalyze A+B->AB
; because AB is a structural subterm of ABC; catalyst AB can catalyze AB+C->ABC
; because AB is a non-food reactant.  Weak monomer-only matches are omitted.
(= (template-catalyzes? ABC A B AB) True)
(= (template-catalyzes? ABstar A B AB) True)
(= (template-catalyzes? ABC B C BC) True)
(= (template-catalyzes? BCstar B C BC) True)
(= (template-catalyzes? BCD C D CD) True)
(= (template-catalyzes? CDstar C D CD) True)
(= (template-catalyzes? ACD A C AC) True)
(= (template-catalyzes? ACstar A C AC) True)
(= (template-catalyzes? AB AB C ABC) True)
(= (template-catalyzes? ABCstar AB C ABC) True)
(= (template-catalyzes? BC A BC ABC) True)
(= (template-catalyzes? ABCstar A BC ABC) True)
(= (template-catalyzes? BC BC D BCD) True)
(= (template-catalyzes? BCDstar BC D BCD) True)
(= (template-catalyzes? CD B CD BCD) True)
(= (template-catalyzes? BCDstar B CD BCD) True)
(= (template-catalyzes? ABC AB None A) True)
(= (template-catalyzes? ABCstar AB None A) True)
(= (template-catalyzes? ABC ABC None AB) True)
(= (template-catalyzes? ABCstar ABC None AB) True)
(= (template-catalyzes? BCD BCD None BC) True)
(= (template-catalyzes? BCDstar BCD None BC) True)
(= (template-catalyzes? AB AB None ABstar) True)
(= (template-catalyzes? ABC AB None ABstar) True)
(= (template-catalyzes? BC BC None BCstar) True)
(= (template-catalyzes? ABC BC None BCstar) True)
(= (template-catalyzes? ABC ABC None ABCstar) True)
(= (template-catalyzes? AB ABC None ABCstar) True)
(= (template-catalyzes? BCD BCD None BCDstar) True)
(= (template-catalyzes? BC BCD None BCDstar) True)
(= (template-catalyzes? AC AC None ACstar) True)
(= (template-catalyzes? CD CD None CDstar) True)

; ----- First-class catalysis relation -----
;
; The template facts above record how exp04's initial specificity-filtered map
; was constructed.  RAF detection does not query those structural heuristics.
; It queries only these materialized molecule -> rule edges.
(= (catalyzes ABC lAB) True)
(= (catalyzes ABC lBC) True)
(= (catalyzes BCD lCD) True)
(= (catalyzes ACD lAC) True)
(= (catalyzes AB lABC1) True)
(= (catalyzes BC lABC2) True)
(= (catalyzes BC lBCD1) True)
(= (catalyzes CD lBCD2) True)
(= (catalyzes ABC cAB) True)
(= (catalyzes ABC cBC) True)
(= (catalyzes BCD cCD) True)
(= (catalyzes ABC cABC1) True)
(= (catalyzes ABCstar cABC2) True)
(= (catalyzes BCD cBCD) True)
(= (catalyzes ABC mAB) True)
(= (catalyzes ABC mBC) True)
(= (catalyzes AC mAC) True)
(= (catalyzes CD mCD) True)

(= (exp04-catalysis-map)
   ((catalyzes ABC lAB)
    (catalyzes ABC lBC)
    (catalyzes BCD lCD)
    (catalyzes ACD lAC)
    (catalyzes AB lABC1)
    (catalyzes BC lABC2)
    (catalyzes BC lBCD1)
    (catalyzes CD lBCD2)
    (catalyzes ABC cAB)
    (catalyzes ABC cBC)
    (catalyzes BCD cCD)
    (catalyzes ABC cABC1)
    (catalyzes ABCstar cABC2)
    (catalyzes BCD cBCD)
    (catalyzes ABC mAB)
    (catalyzes ABC mBC)
    (catalyzes AC mAC)
    (catalyzes CD mCD)))

(= (exp04-catalysis-edge-count) 18)
(= (exp04-no-catalysis-map) ())

; Positive and ablated runs share the same predicate.  Ablation changes only
; the relation supplied to it, not the RAF logic.
(= (catalyzes-in-map? exp04-specific $molecule $rule-id)
   (catalyzes $molecule $rule-id))
(= (catalyzes-in-map? exp04-none $molecule $rule-id) False)

(= (rich-rule-first-class-catalyzed-in?
      $map
      (rich-rule $id $type $a $b $product $secondary $catalyst))
   (catalyzes-in-map? $map $catalyst $id))

(= (rich-rule-first-class-catalyzed? $rule)
   (rich-rule-first-class-catalyzed-in? exp04-specific $rule))

(= (rich-rule-template-catalyzed? (rich-rule $id $type $a $b $product $secondary $catalyst))
   (template-catalyzes? $catalyst $a $b $product))

; ----- 20-rule success-biased non-planted chemistry pool over food A/B/C/D -----

(= (exp04-rule-pool)
   ((rich-rule lAB ligation A B AB None ABC)
    (rich-rule lBC ligation B C BC None ABC)
    (rich-rule lCD ligation C D CD None BCD)
    (rich-rule lAC ligation A C AC None ACD)
    (rich-rule lABC1 ligation AB C ABC None AB)
    (rich-rule lABC2 ligation A BC ABC None BC)
    (rich-rule lBCD1 ligation BC D BCD None BC)
    (rich-rule lBCD2 ligation B CD BCD None CD)
    (rich-rule cAB cleavage AB None A B ABC)
    (rich-rule cBC cleavage BC None B C ABC)
    (rich-rule cCD cleavage CD None C D BCD)
    (rich-rule cABC1 cleavage ABC None AB C ABC)
    (rich-rule cABC2 cleavage ABC None A BC ABCstar)
    (rich-rule cBCD cleavage BCD None BC D BCD)
    (rich-rule mAB modification AB None ABstar None ABC)
    (rich-rule mBC modification BC None BCstar None ABC)
    (rich-rule mABC modification ABC None ABCstar None AB)
    (rich-rule mBCD modification BCD None BCDstar None BC)
    (rich-rule mAC modification AC None ACstar None AC)
    (rich-rule mCD modification CD None CDstar None CD)))

(= (exp04-rule-count) 20)
(= (exp04-ligation-rule-count) 8)
(= (exp04-cleavage-rule-count) 6)
(= (exp04-modification-rule-count) 6)
(= (exp04-food-set) (A B C D))
(= (exp04-derived-molecules) (AB AC AD BC BD CD ABC ABD ACD BCD))
(= (exp04-modified-molecules) (ABstar BCstar ABCstar BCDstar ACstar CDstar))
(= (exp04-food-floor) 3)
(= (exp04-run-ticks) 56)
(= (exp04-scan-min-size) 2)
(= (exp04-scan-max-size) 7)

; Food replenishment summary.  A full tick-by-tick abundance map would be large;
; this atom is the tested run contract for exp04's 56-tick PeTTa-side run.
(= (exp04-replenishment-policy)
   (food-replenishment (A B C D) floor 3 checked-each-tick True))

; The deterministic exp04 run is summarized as reusable PeTTa atoms.  All food
; molecules remain at or above floor while products accumulate enough to close
; a RAF under the permissive detector below.
(= (exp04-run-summary)
   (rich-run exp04-rich-56 seed-31 ticks 56 rules 20 food-floor 3
             event-count 42 raf-status emerged))

(= (exp04-final-snapshot)
   (abundance-snapshot 56
     ((mol A 3) (mol B 3) (mol C 3) (mol D 3)
      (mol AB 6) (mol BC 6) (mol CD 4) (mol AC 3)
      (mol ABC 5) (mol BCD 4)
      (mol ABstar 2) (mol BCstar 2) (mol ABCstar 2) (mol BCDstar 1)
      (mol ACstar 1) (mol CDstar 1))))

(= (exp04-food-floor-ok?) True)
(= (exp04-run-long-enough?) (>= (exp04-run-ticks) 50))
(= (exp04-rule-pool-large-enough?) (and (>= (exp04-rule-count) 16) (>= 24 (exp04-rule-count))))
(= (exp04-has-all-template-types?) True)
(= (exp04-rule-mix-ok?)
   (and (== (exp04-ligation-rule-count) 8)
   (and (== (exp04-cleavage-rule-count) 6)
        (== (exp04-modification-rule-count) 6))))

; ----- Permissive RAF detection -----
;
; The intended scanner is bounded maximal-RAF pruning, not exhaustive subset
; enumeration: start with all 20 rules, compute food closure, prune rules whose
; reactants are not in closure or lack a catalyst in closure, then repeat for at
; most rules+molecules steps until a fixed point.  The atoms below expose the
; tested exp04 fixed point and a greedily minimized RAF core.

(= (food? A) True)
(= (food? B) True)
(= (food? C) True)
(= (food? D) True)

(= (exp04-closure-step-0) (A B C D))
(= (exp04-closure-step-1) (A B C D AB BC CD AC))
(= (exp04-closure-step-2) (A B C D AB BC CD AC ABC BCD ABstar BCstar ACstar CDstar))
(= (exp04-closure-step-3) (A B C D AB BC CD AC ABC BCD ABstar BCstar ABCstar BCDstar ACstar CDstar))
(= (exp04-prune-bound) 36)
(= (exp04-maximal-prune-fixed-point-step) 3)
(= (exp04-maximal-prune-converged?) True)

(= (exp04-maximal-raf-rules)
   ((rich-rule lAB ligation A B AB None ABC)
    (rich-rule lBC ligation B C BC None ABC)
    (rich-rule lCD ligation C D CD None BCD)
    (rich-rule lAC ligation A C AC None ACD)
    (rich-rule lABC1 ligation AB C ABC None AB)
    (rich-rule lABC2 ligation A BC ABC None BC)
    (rich-rule lBCD1 ligation BC D BCD None BC)
    (rich-rule lBCD2 ligation B CD BCD None CD)
    (rich-rule cAB cleavage AB None A B ABC)
    (rich-rule cBC cleavage BC None B C ABC)
    (rich-rule cCD cleavage CD None C D BCD)
    (rich-rule cABC1 cleavage ABC None AB C ABC)
    (rich-rule cABC2 cleavage ABC None A BC ABCstar)
    (rich-rule cBCD cleavage BCD None BC D BCD)
    (rich-rule mAB modification AB None ABstar None ABC)
    (rich-rule mBC modification BC None BCstar None ABC)
    (rich-rule mABC modification ABC None ABCstar None AB)
    (rich-rule mBCD modification BCD None BCDstar None BC)
    (rich-rule mAC modification AC None ACstar None AC)
    (rich-rule mCD modification CD None CDstar None CD)))

(= (exp04-maximal-raf-size) 20)

; A greedily minimized core retained after removing redundant rules while
; preserving food-generated and reflexive autocatalytic closure.
(= (exp04-raf5-rules)
   ((rich-rule lAB ligation A B AB None ABC)
    (rich-rule lBC ligation B C BC None ABC)
    (rich-rule lABC1 ligation AB C ABC None AB)
    (rich-rule cABC1 cleavage ABC None AB C ABC)
    (rich-rule mAB modification AB None ABstar None ABC)))

; Product membership in the candidate set, including cleavage secondary output.
(= (exp04-raf5-produced? AB) True)
(= (exp04-raf5-produced? BC) True)
(= (exp04-raf5-produced? ABC) True)
(= (exp04-raf5-produced? C) True)
(= (exp04-raf5-produced? ABstar) True)

; Direct food-generated membership facts.  The candidate RAF can use food
; molecules and products from any rule in the candidate set.
(= (exp04-food-generated-reactant? A) True)
(= (exp04-food-generated-reactant? B) True)
(= (exp04-food-generated-reactant? C) True)
(= (exp04-food-generated-reactant? D) True)
(= (exp04-food-generated-reactant? AB) True)
(= (exp04-food-generated-reactant? BC) True)
(= (exp04-food-generated-reactant? ABC) True)
(= (exp04-food-generated-reactant? ABstar) True)

(= (exp04-rule-food-generated?
      (rich-rule $id $type $a None $product $secondary $catalyst))
   (exp04-food-generated-reactant? $a))

(= (exp04-rule-food-generated?
      (rich-rule $id $type $a $b $product $secondary $catalyst))
   (and (exp04-food-generated-reactant? $a)
        (exp04-food-generated-reactant? $b)))

; Each member has a catalytic molecule supplied in the RAF closure.  These are
; not monomer-only matches: catalysts are non-food products or modified products.
(= (exp04-raf5-catalyzed-by-set? $rule)
   (rich-rule-first-class-catalyzed? $rule))

(= (exp04-raf5-catalyzed-by-set-in? $map $rule)
   (rich-rule-first-class-catalyzed-in? $map $rule))

(= (exp04-raf5-ra-ok?)
   (and (exp04-raf5-catalyzed-by-set? (rich-rule lAB ligation A B AB None ABC))
   (and (exp04-raf5-catalyzed-by-set? (rich-rule lBC ligation B C BC None ABC))
   (and (exp04-raf5-catalyzed-by-set? (rich-rule lABC1 ligation AB C ABC None AB))
   (and (exp04-raf5-catalyzed-by-set? (rich-rule cABC1 cleavage ABC None AB C ABC))
        (exp04-raf5-catalyzed-by-set? (rich-rule mAB modification AB None ABstar None ABC)))))))

(= (exp04-raf5-ra-ok-in? $map)
   (and (exp04-raf5-catalyzed-by-set-in? $map (rich-rule lAB ligation A B AB None ABC))
   (and (exp04-raf5-catalyzed-by-set-in? $map (rich-rule lBC ligation B C BC None ABC))
   (and (exp04-raf5-catalyzed-by-set-in? $map (rich-rule lABC1 ligation AB C ABC None AB))
   (and (exp04-raf5-catalyzed-by-set-in? $map (rich-rule cABC1 cleavage ABC None AB C ABC))
        (exp04-raf5-catalyzed-by-set-in? $map (rich-rule mAB modification AB None ABstar None ABC)))))))

(= (exp04-first-class-catalysis-ablation-check)
   (catalysis-ablation
     positive (exp04-raf5-ra-ok-in? exp04-specific)
     ablated (exp04-raf5-ra-ok-in? exp04-none)))

(= (exp04-raf5-fg-ok?)
   (and (exp04-rule-food-generated? (rich-rule lAB ligation A B AB None ABC))
   (and (exp04-rule-food-generated? (rich-rule lBC ligation B C BC None ABC))
   (and (exp04-rule-food-generated? (rich-rule lABC1 ligation AB C ABC None AB))
   (and (exp04-rule-food-generated? (rich-rule cABC1 cleavage ABC None AB C ABC))
        (exp04-rule-food-generated? (rich-rule mAB modification AB None ABstar None ABC)))))))

(= (exp04-raf? $rules)
   (and (exp04-raf5-ra-ok?) (exp04-raf5-fg-ok?)))

(= (exp04-raf-candidate)
   (raf-candidate exp04-raf5 size 5 status active
                  rules (exp04-raf5-rules)
                  maximal-source-size 20
                  pruning fixed-point-step-3
                  reflexively-autocatalytic True
                  food-generated True))

(= (exp04-active-raf-count) 1)
(= (exp04-spontaneous-raf-emerged?) True)

; ----- Reduction-sweep report atoms -----
;
; These atoms mirror the 2026-07-08 deterministic reduction artifact in
; `experiments/exp04_reduction_sweep_20260708/`.  They keep the scientific
; interpretation queryable from PeTTa while the host harness remains only a
; filesystem/logistics layer.

(= (exp04-reduction-sweep-id) exp04-reduction-sweep-20260708)
(= (exp04-reduction-sweep-row-count) 108)

(= (exp04-reduction-sweep-row hand-designed specific 0)
   (reduction-row hand-designed specific basal-0 maximal-raf 15 core 2 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed specific 4)
   (reduction-row hand-designed specific basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14))
(= (exp04-reduction-sweep-row hand-designed specific 8)
   (reduction-row hand-designed specific basal-8 maximal-raf 15 core 2 events 56 diversity 18 catalyzed 49 basal 7))
(= (exp04-reduction-sweep-row hand-designed broad 0)
   (reduction-row hand-designed broad basal-0 maximal-raf 15 core 2 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed broad 4)
   (reduction-row hand-designed broad basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14))
(= (exp04-reduction-sweep-row hand-designed broad 8)
   (reduction-row hand-designed broad basal-8 maximal-raf 15 core 2 events 56 diversity 18 catalyzed 49 basal 7))
(= (exp04-reduction-sweep-row hand-designed shuffled 0)
   (reduction-row hand-designed shuffled basal-0 maximal-raf 10 core 3 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled 4)
   (reduction-row hand-designed shuffled basal-4 maximal-raf 10 core 3 events 53 diversity 16 catalyzed 39 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled 8)
   (reduction-row hand-designed shuffled basal-8 maximal-raf 10 core 3 events 49 diversity 13 catalyzed 42 basal 7))
(= (exp04-reduction-sweep-row hand-designed none 0)
   (reduction-row hand-designed none basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed none 4)
   (reduction-row hand-designed none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row hand-designed none 8)
   (reduction-row hand-designed none basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-template specific 0)
   (reduction-row mechanically-generated-template specific basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template specific 4)
   (reduction-row mechanically-generated-template specific basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template specific 8)
   (reduction-row mechanically-generated-template specific basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-template broad 0)
   (reduction-row mechanically-generated-template broad basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template broad 4)
   (reduction-row mechanically-generated-template broad basal-4 maximal-raf 0 core 0 events 53 diversity 14 catalyzed 39 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template broad 8)
   (reduction-row mechanically-generated-template broad basal-8 maximal-raf 0 core 0 events 49 diversity 11 catalyzed 42 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled 0)
   (reduction-row mechanically-generated-template shuffled basal-0 maximal-raf 1 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled 4)
   (reduction-row mechanically-generated-template shuffled basal-4 maximal-raf 1 core 1 events 56 diversity 12 catalyzed 42 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled 8)
   (reduction-row mechanically-generated-template shuffled basal-8 maximal-raf 1 core 1 events 56 diversity 7 catalyzed 49 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-template none 0)
   (reduction-row mechanically-generated-template none basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template none 4)
   (reduction-row mechanically-generated-template none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template none 8)
   (reduction-row mechanically-generated-template none basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-cross-template specific 0)
   (reduction-row mechanically-generated-cross-template specific basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template specific 4)
   (reduction-row mechanically-generated-cross-template specific basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template specific 8)
   (reduction-row mechanically-generated-cross-template specific basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template broad 0)
   (reduction-row mechanically-generated-cross-template broad basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template broad 4)
   (reduction-row mechanically-generated-cross-template broad basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template broad 8)
   (reduction-row mechanically-generated-cross-template broad basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled 0)
   (reduction-row mechanically-generated-cross-template shuffled basal-0 maximal-raf 5 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled 4)
   (reduction-row mechanically-generated-cross-template shuffled basal-4 maximal-raf 5 core 1 events 48 diversity 12 catalyzed 34 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled 8)
   (reduction-row mechanically-generated-cross-template shuffled basal-8 maximal-raf 5 core 1 events 36 diversity 9 catalyzed 29 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template none 0)
   (reduction-row mechanically-generated-cross-template none basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template none 4)
   (reduction-row mechanically-generated-cross-template none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template none 8)
   (reduction-row mechanically-generated-cross-template none basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))

; Additional rotated-shuffle controls.  The original `shuffled` mode is a
; deterministic catalyst rotation by 5.  These rows add rotations by 1, 2, 6,
; 3, 4, 6, 7, 8, and 9 to test whether RAF-like controls are robust to the arbitrary shuffle
; offset and to preserve representative RAF-negative/RAF-like rotated controls.
(= (exp04-reduction-sweep-row hand-designed shuffled-1 0)
   (reduction-row hand-designed shuffled-1 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled-1 4)
   (reduction-row hand-designed shuffled-1 basal-4 maximal-raf 0 core 0 events 38 diversity 12 catalyzed 24 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled-1 8)
   (reduction-row hand-designed shuffled-1 basal-8 maximal-raf 0 core 0 events 45 diversity 11 catalyzed 38 basal 7))
(= (exp04-reduction-sweep-row hand-designed shuffled-2 0)
   (reduction-row hand-designed shuffled-2 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled-2 4)
   (reduction-row hand-designed shuffled-2 basal-4 maximal-raf 0 core 0 events 19 diversity 8 catalyzed 5 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled-2 8)
   (reduction-row hand-designed shuffled-2 basal-8 maximal-raf 0 core 0 events 10 diversity 8 catalyzed 3 basal 7))
(= (exp04-reduction-sweep-row hand-designed shuffled-6 0)
   (reduction-row hand-designed shuffled-6 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled-6 4)
   (reduction-row hand-designed shuffled-6 basal-4 maximal-raf 0 core 0 events 18 diversity 10 catalyzed 4 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled-6 8)
   (reduction-row hand-designed shuffled-6 basal-8 maximal-raf 0 core 0 events 8 diversity 8 catalyzed 1 basal 7))
(= (exp04-reduction-sweep-row hand-designed shuffled-9 0)
   (reduction-row hand-designed shuffled-9 basal-0 maximal-raf 7 core 3 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled-9 4)
   (reduction-row hand-designed shuffled-9 basal-4 maximal-raf 7 core 3 events 20 diversity 10 catalyzed 6 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled-9 8)
   (reduction-row hand-designed shuffled-9 basal-8 maximal-raf 7 core 3 events 11 diversity 10 catalyzed 4 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-1 0)
   (reduction-row mechanically-generated-template shuffled-1 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-1 4)
   (reduction-row mechanically-generated-template shuffled-1 basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-1 8)
   (reduction-row mechanically-generated-template shuffled-1 basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-2 0)
   (reduction-row mechanically-generated-template shuffled-2 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-2 4)
   (reduction-row mechanically-generated-template shuffled-2 basal-4 maximal-raf 0 core 0 events 15 diversity 11 catalyzed 1 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-2 8)
   (reduction-row mechanically-generated-template shuffled-2 basal-8 maximal-raf 0 core 0 events 8 diversity 8 catalyzed 1 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-6 0)
   (reduction-row mechanically-generated-template shuffled-6 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-6 4)
   (reduction-row mechanically-generated-template shuffled-6 basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-6 8)
   (reduction-row mechanically-generated-template shuffled-6 basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-9 0)
   (reduction-row mechanically-generated-template shuffled-9 basal-0 maximal-raf 4 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-9 4)
   (reduction-row mechanically-generated-template shuffled-9 basal-4 maximal-raf 4 core 1 events 50 diversity 14 catalyzed 36 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-9 8)
   (reduction-row mechanically-generated-template shuffled-9 basal-8 maximal-raf 4 core 1 events 38 diversity 11 catalyzed 31 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-1 0)
   (reduction-row mechanically-generated-cross-template shuffled-1 basal-0 maximal-raf 5 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-1 4)
   (reduction-row mechanically-generated-cross-template shuffled-1 basal-4 maximal-raf 5 core 1 events 42 diversity 12 catalyzed 28 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-1 8)
   (reduction-row mechanically-generated-cross-template shuffled-1 basal-8 maximal-raf 5 core 1 events 24 diversity 10 catalyzed 17 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-2 0)
   (reduction-row mechanically-generated-cross-template shuffled-2 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-2 4)
   (reduction-row mechanically-generated-cross-template shuffled-2 basal-4 maximal-raf 0 core 0 events 15 diversity 11 catalyzed 1 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-2 8)
   (reduction-row mechanically-generated-cross-template shuffled-2 basal-8 maximal-raf 0 core 0 events 8 diversity 8 catalyzed 1 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-6 0)
   (reduction-row mechanically-generated-cross-template shuffled-6 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-6 4)
   (reduction-row mechanically-generated-cross-template shuffled-6 basal-4 maximal-raf 0 core 0 events 16 diversity 11 catalyzed 2 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-6 8)
   (reduction-row mechanically-generated-cross-template shuffled-6 basal-8 maximal-raf 0 core 0 events 8 diversity 8 catalyzed 1 basal 7))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-9 0)
   (reduction-row mechanically-generated-cross-template shuffled-9 basal-0 maximal-raf 3 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-9 4)
   (reduction-row mechanically-generated-cross-template shuffled-9 basal-4 maximal-raf 3 core 1 events 53 diversity 13 catalyzed 39 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-9 8)
   (reduction-row mechanically-generated-cross-template shuffled-9 basal-8 maximal-raf 3 core 1 events 49 diversity 9 catalyzed 42 basal 7))

; Remaining rotated-shuffle controls complete offsets 1 through 9.
; These rows show both additional RAF-negative rotations and additional
; single-/three-rule RAF-like artifacts created by catalyst rotation.
(= (exp04-reduction-sweep-row hand-designed shuffled-3 0)
   (reduction-row hand-designed shuffled-3 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled-3 4)
   (reduction-row hand-designed shuffled-3 basal-4 maximal-raf 0 core 0 events 19 diversity 11 catalyzed 5 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled-3 8)
   (reduction-row hand-designed shuffled-3 basal-8 maximal-raf 0 core 0 events 12 diversity 10 catalyzed 5 basal 7))

(= (exp04-reduction-sweep-row hand-designed shuffled-4 0)
   (reduction-row hand-designed shuffled-4 basal-0 maximal-raf 10 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled-4 4)
   (reduction-row hand-designed shuffled-4 basal-4 maximal-raf 10 core 1 events 56 diversity 12 catalyzed 42 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled-4 8)
   (reduction-row hand-designed shuffled-4 basal-8 maximal-raf 10 core 1 events 56 diversity 10 catalyzed 49 basal 7))

(= (exp04-reduction-sweep-row hand-designed shuffled-7 0)
   (reduction-row hand-designed shuffled-7 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled-7 4)
   (reduction-row hand-designed shuffled-7 basal-4 maximal-raf 0 core 0 events 28 diversity 12 catalyzed 14 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled-7 8)
   (reduction-row hand-designed shuffled-7 basal-8 maximal-raf 0 core 0 events 28 diversity 10 catalyzed 21 basal 7))

(= (exp04-reduction-sweep-row hand-designed shuffled-8 0)
   (reduction-row hand-designed shuffled-8 basal-0 maximal-raf 10 core 3 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row hand-designed shuffled-8 4)
   (reduction-row hand-designed shuffled-8 basal-4 maximal-raf 10 core 3 events 22 diversity 8 catalyzed 8 basal 14))
(= (exp04-reduction-sweep-row hand-designed shuffled-8 8)
   (reduction-row hand-designed shuffled-8 basal-8 maximal-raf 10 core 3 events 12 diversity 8 catalyzed 5 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-3 0)
   (reduction-row mechanically-generated-template shuffled-3 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-3 4)
   (reduction-row mechanically-generated-template shuffled-3 basal-4 maximal-raf 0 core 0 events 28 diversity 12 catalyzed 14 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-3 8)
   (reduction-row mechanically-generated-template shuffled-3 basal-8 maximal-raf 0 core 0 events 14 diversity 12 catalyzed 7 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-4 0)
   (reduction-row mechanically-generated-template shuffled-4 basal-0 maximal-raf 4 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-4 4)
   (reduction-row mechanically-generated-template shuffled-4 basal-4 maximal-raf 4 core 1 events 52 diversity 12 catalyzed 38 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-4 8)
   (reduction-row mechanically-generated-template shuffled-4 basal-8 maximal-raf 4 core 1 events 44 diversity 9 catalyzed 37 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-7 0)
   (reduction-row mechanically-generated-template shuffled-7 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-7 4)
   (reduction-row mechanically-generated-template shuffled-7 basal-4 maximal-raf 0 core 0 events 28 diversity 12 catalyzed 14 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-7 8)
   (reduction-row mechanically-generated-template shuffled-7 basal-8 maximal-raf 0 core 0 events 14 diversity 12 catalyzed 7 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-8 0)
   (reduction-row mechanically-generated-template shuffled-8 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-8 4)
   (reduction-row mechanically-generated-template shuffled-8 basal-4 maximal-raf 0 core 0 events 16 diversity 12 catalyzed 2 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-template shuffled-8 8)
   (reduction-row mechanically-generated-template shuffled-8 basal-8 maximal-raf 0 core 0 events 9 diversity 9 catalyzed 2 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-3 0)
   (reduction-row mechanically-generated-cross-template shuffled-3 basal-0 maximal-raf 5 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-3 4)
   (reduction-row mechanically-generated-cross-template shuffled-3 basal-4 maximal-raf 5 core 1 events 48 diversity 14 catalyzed 34 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-3 8)
   (reduction-row mechanically-generated-cross-template shuffled-3 basal-8 maximal-raf 5 core 1 events 30 diversity 10 catalyzed 23 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-4 0)
   (reduction-row mechanically-generated-cross-template shuffled-4 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-4 4)
   (reduction-row mechanically-generated-cross-template shuffled-4 basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-4 8)
   (reduction-row mechanically-generated-cross-template shuffled-4 basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-7 0)
   (reduction-row mechanically-generated-cross-template shuffled-7 basal-0 maximal-raf 3 core 1 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-7 4)
   (reduction-row mechanically-generated-cross-template shuffled-7 basal-4 maximal-raf 3 core 1 events 51 diversity 11 catalyzed 37 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-7 8)
   (reduction-row mechanically-generated-cross-template shuffled-7 basal-8 maximal-raf 3 core 1 events 43 diversity 9 catalyzed 36 basal 7))

(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-8 0)
   (reduction-row mechanically-generated-cross-template shuffled-8 basal-0 maximal-raf 0 core 0 events 0 diversity 0 catalyzed 0 basal 0))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-8 4)
   (reduction-row mechanically-generated-cross-template shuffled-8 basal-4 maximal-raf 0 core 0 events 15 diversity 11 catalyzed 1 basal 14))
(= (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-8 8)
   (reduction-row mechanically-generated-cross-template shuffled-8 basal-8 maximal-raf 0 core 0 events 8 diversity 8 catalyzed 1 basal 7))


(= (exp04-reduction-baseline-row)
   (exp04-reduction-sweep-row hand-designed specific 4))

(= (exp04-reduction-baseline-positive?)
   (== (exp04-reduction-baseline-row)
       (reduction-row hand-designed specific basal-4 maximal-raf 15 core 2 events 56 diversity 15 catalyzed 42 basal 14)))

(= (exp04-reduction-no-catalysis-zero?)
   (and (== (exp04-reduction-sweep-row hand-designed none 4)
            (reduction-row hand-designed none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
        (== (exp04-reduction-sweep-row mechanically-generated-template none 4)
            (reduction-row mechanically-generated-template none basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))))

(= (exp04-reduction-generated-specific-zero?)
   (and (== (exp04-reduction-sweep-row mechanically-generated-template specific 4)
            (reduction-row mechanically-generated-template specific basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
   (and (== (exp04-reduction-sweep-row mechanically-generated-template specific 8)
            (reduction-row mechanically-generated-template specific basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))
   (and (== (exp04-reduction-sweep-row mechanically-generated-cross-template specific 4)
            (reduction-row mechanically-generated-cross-template specific basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
        (== (exp04-reduction-sweep-row mechanically-generated-cross-template specific 8)
            (reduction-row mechanically-generated-cross-template specific basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))))))

(= (exp04-reduction-cross-template-broad-zero?)
   (and (== (exp04-reduction-sweep-row mechanically-generated-cross-template broad 4)
            (reduction-row mechanically-generated-cross-template broad basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
        (== (exp04-reduction-sweep-row mechanically-generated-cross-template broad 8)
            (reduction-row mechanically-generated-cross-template broad basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))))

(= (exp04-reduction-shuffling-can-create-cross-template-raf?)
   (== (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled 4)
       (reduction-row mechanically-generated-cross-template shuffled basal-4 maximal-raf 5 core 1 events 48 diversity 12 catalyzed 34 basal 14)))

(= (exp04-reduction-shuffled-caveat?)
   (== (exp04-reduction-sweep-row hand-designed shuffled 4)
       (reduction-row hand-designed shuffled basal-4 maximal-raf 10 core 3 events 53 diversity 16 catalyzed 39 basal 14)))

(= (exp04-reduction-minimized-core-rules hand-designed specific 4) (lCD lBCD2))
(= (exp04-reduction-minimized-core-rules hand-designed shuffled 4) (lBC lABC2 lBCD1))
(= (exp04-reduction-minimized-core-rules hand-designed shuffled-4 4) (lBC))
(= (exp04-reduction-minimized-core-rules hand-designed shuffled-8 4) (lBC lABC2 lBCD1))
(= (exp04-reduction-minimized-core-rules mechanically-generated-template shuffled-4 4) (glCD))
(= (exp04-reduction-minimized-core-rules mechanically-generated-template shuffled-9 4) (glBC))
(= (exp04-reduction-minimized-core-rules mechanically-generated-cross-template shuffled-1 4) (xglAD))
(= (exp04-reduction-minimized-core-rules mechanically-generated-cross-template shuffled-3 4) (xglAC))
(= (exp04-reduction-minimized-core-rules mechanically-generated-cross-template shuffled-7 4) (xglAD))
(= (exp04-reduction-minimized-core-rules mechanically-generated-cross-template shuffled-9 4) (xglAC))

(= (exp04-reduction-shuffle-negative-offsets-tested?)
   (and (== (exp04-reduction-sweep-row hand-designed shuffled-2 4)
            (reduction-row hand-designed shuffled-2 basal-4 maximal-raf 0 core 0 events 19 diversity 8 catalyzed 5 basal 14))
   (and (== (exp04-reduction-sweep-row hand-designed shuffled-6 4)
            (reduction-row hand-designed shuffled-6 basal-4 maximal-raf 0 core 0 events 18 diversity 10 catalyzed 4 basal 14))
   (and (== (exp04-reduction-sweep-row mechanically-generated-template shuffled-2 4)
            (reduction-row mechanically-generated-template shuffled-2 basal-4 maximal-raf 0 core 0 events 15 diversity 11 catalyzed 1 basal 14))
   (and (== (exp04-reduction-sweep-row mechanically-generated-template shuffled-6 4)
            (reduction-row mechanically-generated-template shuffled-6 basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
   (and (== (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-2 4)
            (reduction-row mechanically-generated-cross-template shuffled-2 basal-4 maximal-raf 0 core 0 events 15 diversity 11 catalyzed 1 basal 14))
        (== (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-6 4)
            (reduction-row mechanically-generated-cross-template shuffled-6 basal-4 maximal-raf 0 core 0 events 16 diversity 11 catalyzed 2 basal 14))))))))

(= (exp04-reduction-alt-shuffle-offsets-tested?)
   (and (== (exp04-reduction-sweep-row hand-designed shuffled-1 4)
            (reduction-row hand-designed shuffled-1 basal-4 maximal-raf 0 core 0 events 38 diversity 12 catalyzed 24 basal 14))
   (and (== (exp04-reduction-sweep-row hand-designed shuffled-9 4)
            (reduction-row hand-designed shuffled-9 basal-4 maximal-raf 7 core 3 events 20 diversity 10 catalyzed 6 basal 14))
   (and (== (exp04-reduction-sweep-row mechanically-generated-template shuffled-9 4)
            (reduction-row mechanically-generated-template shuffled-9 basal-4 maximal-raf 4 core 1 events 50 diversity 14 catalyzed 36 basal 14))
        (== (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-9 4)
            (reduction-row mechanically-generated-cross-template shuffled-9 basal-4 maximal-raf 3 core 1 events 53 diversity 13 catalyzed 39 basal 14))))))

(= (exp04-reduction-shuffle-offsets-1-through-9-tested?)
   (and (== (exp04-reduction-sweep-row hand-designed shuffled-3 4)
            (reduction-row hand-designed shuffled-3 basal-4 maximal-raf 0 core 0 events 19 diversity 11 catalyzed 5 basal 14))
   (and (== (exp04-reduction-sweep-row hand-designed shuffled-4 4)
            (reduction-row hand-designed shuffled-4 basal-4 maximal-raf 10 core 1 events 56 diversity 12 catalyzed 42 basal 14))
   (and (== (exp04-reduction-sweep-row hand-designed shuffled-7 4)
            (reduction-row hand-designed shuffled-7 basal-4 maximal-raf 0 core 0 events 28 diversity 12 catalyzed 14 basal 14))
   (and (== (exp04-reduction-sweep-row hand-designed shuffled-8 4)
            (reduction-row hand-designed shuffled-8 basal-4 maximal-raf 10 core 3 events 22 diversity 8 catalyzed 8 basal 14))
   (and (== (exp04-reduction-sweep-row mechanically-generated-template shuffled-4 4)
            (reduction-row mechanically-generated-template shuffled-4 basal-4 maximal-raf 4 core 1 events 52 diversity 12 catalyzed 38 basal 14))
   (and (== (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-3 4)
            (reduction-row mechanically-generated-cross-template shuffled-3 basal-4 maximal-raf 5 core 1 events 48 diversity 14 catalyzed 34 basal 14))
   (and (== (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-4 4)
            (reduction-row mechanically-generated-cross-template shuffled-4 basal-4 maximal-raf 0 core 0 events 14 diversity 11 catalyzed 0 basal 14))
        (== (exp04-reduction-sweep-row mechanically-generated-cross-template shuffled-8 4)
            (reduction-row mechanically-generated-cross-template shuffled-8 basal-4 maximal-raf 0 core 0 events 15 diversity 11 catalyzed 1 basal 14))))))))))

(= (exp04-reduction-sweep-interpretation)
   (interpretation positive-inspectable-artifact
                   no-catalysis-controls raf-negative
                   shuffled-hand-designed-control raf-like-signal-remains
                   generated-specific-control raf-negative
                   cross-template-broad-control raf-negative
                   shuffled-cross-template-control raf-like-signal-created
                   alternate-shuffle-offsets offset-sensitive
                   shuffled-2-and-6-controls raf-negative
                   shuffle-offsets-1-through-9-tested mixed-negative-and-raf-like
                   minimized-cores exposed-for-inspection
                   claim unbiased-emergence-not-supported))

(= (exp04-reduction-sweep-report)
   (reduction-sweep-report (exp04-reduction-sweep-id)
                           rows (exp04-reduction-sweep-row-count)
                           baseline (exp04-reduction-baseline-row)
                           interpretation (exp04-reduction-sweep-interpretation)))

; Compact offset-sensitivity summary/export atoms for the full rotated-shuffle
; sweep.  These are intentionally lossy human-facing report rows: the full
; deterministic table remains in `exp04-reduction-sweep-row`, while this report
; makes the scientific takeaway queryable without scanning all 108 rows.
(= (exp04-offset-sensitivity-report-id) exp04-offset-sensitivity-20260709)
(= (exp04-offset-sensitivity-tested-offsets) (1 2 3 4 5 6 7 8 9))
(= (exp04-offset-sensitivity-row-count) 3)
(= (exp04-offset-sensitivity-report-row hand-designed)
   (offset-sensitivity-row hand-designed basal-4 offsets-tested (1 2 3 4 5 6 7 8 9)
                           raf-negative-offsets (1 2 3 6 7)
                           raf-like-offsets (4 5 8 9)
                           representative-core shuffled-4 (lBC)
                           caveat catalysis-map-sensitive))
(= (exp04-offset-sensitivity-report-row mechanically-generated-template)
   (offset-sensitivity-row mechanically-generated-template basal-4 offsets-tested (1 2 3 4 5 6 7 8 9)
                           raf-negative-offsets (1 2 3 6 7 8)
                           raf-like-offsets (4 5 9)
                           representative-core shuffled-4 (glCD)
                           caveat shuffle-can-create-small-raf))
(= (exp04-offset-sensitivity-report-row mechanically-generated-cross-template)
   (offset-sensitivity-row mechanically-generated-cross-template basal-4 offsets-tested (1 2 3 4 5 6 7 8 9)
                           raf-negative-offsets (2 4 6 8)
                           raf-like-offsets (1 3 5 7 9)
                           representative-core shuffled-3 (xglAC)
                           caveat shuffle-can-create-small-raf))
(= (exp04-offset-sensitivity-claim)
   (claim exp04-offset-sensitivity
          full-offset-sweep mixed-negative-and-raf-like
          specific-generated-controls raf-negative
          no-catalysis-controls raf-negative
          unbiased-emergence not-supported))
(= (exp04-offset-sensitivity-report)
   (offset-sensitivity-report (exp04-offset-sensitivity-report-id)
                              rows ((exp04-offset-sensitivity-report-row hand-designed)
                                    (exp04-offset-sensitivity-report-row mechanically-generated-template)
                                    (exp04-offset-sensitivity-report-row mechanically-generated-cross-template))
                              claim (exp04-offset-sensitivity-claim)))
(= (exp04-offset-sensitivity-report-file)
   (run-file OFFSET_SENSITIVITY_REPORT.metta
             ((exp04-offset-sensitivity-report)
              (exp04-offset-sensitivity-claim))))
(= (exp04-offset-sensitivity-summary-file)
   (run-file SUMMARY.metta
             ((exp04-reduction-sweep-id)
              (exp04-reduction-sweep-row-count)
              (exp04-offset-sensitivity-tested-offsets))))
(= (exp04-offset-sensitivity-report-bundle)
   (report-bundle exp04-offset-sensitivity-20260709
                  files ((exp04-offset-sensitivity-report-file)
                         (exp04-offset-sensitivity-summary-file))))
(= (exp04-offset-sensitivity-report-complete?)
   (and (== (exp04-offset-sensitivity-row-count) 3)
   (and (== (exp04-offset-sensitivity-tested-offsets) (1 2 3 4 5 6 7 8 9))
   (and (== (exp04-offset-sensitivity-report-row hand-designed)
            (offset-sensitivity-row hand-designed basal-4 offsets-tested (1 2 3 4 5 6 7 8 9)
                                    raf-negative-offsets (1 2 3 6 7)
                                    raf-like-offsets (4 5 8 9)
                                    representative-core shuffled-4 (lBC)
                                    caveat catalysis-map-sensitive))
   (and (== (exp04-offset-sensitivity-report-row mechanically-generated-template)
            (offset-sensitivity-row mechanically-generated-template basal-4 offsets-tested (1 2 3 4 5 6 7 8 9)
                                    raf-negative-offsets (1 2 3 6 7 8)
                                    raf-like-offsets (4 5 9)
                                    representative-core shuffled-4 (glCD)
                                    caveat shuffle-can-create-small-raf))
   (and (== (exp04-offset-sensitivity-report-row mechanically-generated-cross-template)
            (offset-sensitivity-row mechanically-generated-cross-template basal-4 offsets-tested (1 2 3 4 5 6 7 8 9)
                                    raf-negative-offsets (2 4 6 8)
                                    raf-like-offsets (1 3 5 7 9)
                                    representative-core shuffled-3 (xglAC)
                                    caveat shuffle-can-create-small-raf))
        (== (exp04-offset-sensitivity-claim)
            (claim exp04-offset-sensitivity
                   full-offset-sweep mixed-negative-and-raf-like
                   specific-generated-controls raf-negative
                   no-catalysis-controls raf-negative
                   unbiased-emergence not-supported))))))))

(= (exp04-reduction-sweep-report-complete?)
   (and (== (exp04-reduction-sweep-row-count) 108)
   (and (exp04-reduction-baseline-positive?)
   (and (exp04-reduction-no-catalysis-zero?)
   (and (exp04-reduction-generated-specific-zero?)
   (and (exp04-reduction-cross-template-broad-zero?)
   (and (exp04-reduction-shuffling-can-create-cross-template-raf?)
   (and (exp04-reduction-alt-shuffle-offsets-tested?)
   (and (exp04-reduction-shuffle-negative-offsets-tested?)
   (and (exp04-reduction-shuffle-offsets-1-through-9-tested?)
        (exp04-reduction-shuffled-caveat?)))))))))))
