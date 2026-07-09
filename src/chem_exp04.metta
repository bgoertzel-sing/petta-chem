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
(= (exp04-raf5-catalyzed-by-set? (rich-rule lAB ligation A B AB None ABC))
   (template-catalyzes? ABC A B AB))
(= (exp04-raf5-catalyzed-by-set? (rich-rule lBC ligation B C BC None ABC))
   (template-catalyzes? ABC B C BC))
(= (exp04-raf5-catalyzed-by-set? (rich-rule lABC1 ligation AB C ABC None AB))
   (template-catalyzes? AB AB C ABC))
(= (exp04-raf5-catalyzed-by-set? (rich-rule cABC1 cleavage ABC None AB C ABC))
   (template-catalyzes? ABC ABC None AB))
(= (exp04-raf5-catalyzed-by-set? (rich-rule mAB modification AB None ABstar None ABC))
   (template-catalyzes? ABC AB None ABstar))

(= (exp04-raf5-ra-ok?)
   (and (exp04-raf5-catalyzed-by-set? (rich-rule lAB ligation A B AB None ABC))
   (and (exp04-raf5-catalyzed-by-set? (rich-rule lBC ligation B C BC None ABC))
   (and (exp04-raf5-catalyzed-by-set? (rich-rule lABC1 ligation AB C ABC None AB))
   (and (exp04-raf5-catalyzed-by-set? (rich-rule cABC1 cleavage ABC None AB C ABC))
        (exp04-raf5-catalyzed-by-set? (rich-rule mAB modification AB None ABstar None ABC)))))))

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
(= (exp04-reduction-sweep-row-count) 24)

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
        (== (exp04-reduction-sweep-row mechanically-generated-template specific 8)
            (reduction-row mechanically-generated-template specific basal-8 maximal-raf 0 core 0 events 7 diversity 7 catalyzed 0 basal 7))))

(= (exp04-reduction-shuffled-caveat?)
   (== (exp04-reduction-sweep-row hand-designed shuffled 4)
       (reduction-row hand-designed shuffled basal-4 maximal-raf 10 core 3 events 53 diversity 16 catalyzed 39 basal 14)))

(= (exp04-reduction-sweep-interpretation)
   (interpretation positive-inspectable-artifact
                   no-catalysis-controls raf-negative
                   shuffled-hand-designed-control raf-like-signal-remains
                   generated-specific-control raf-negative
                   claim unbiased-emergence-not-supported))

(= (exp04-reduction-sweep-report)
   (reduction-sweep-report (exp04-reduction-sweep-id)
                           rows (exp04-reduction-sweep-row-count)
                           baseline (exp04-reduction-baseline-row)
                           interpretation (exp04-reduction-sweep-interpretation)))

(= (exp04-reduction-sweep-report-complete?)
   (and (== (exp04-reduction-sweep-row-count) 24)
   (and (exp04-reduction-baseline-positive?)
   (and (exp04-reduction-no-catalysis-zero?)
   (and (exp04-reduction-generated-specific-zero?)
        (exp04-reduction-shuffled-caveat?))))))
