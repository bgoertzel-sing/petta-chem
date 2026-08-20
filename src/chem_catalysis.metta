; First-class catalysis relation for exp04.
;
; This module makes catalysis a first-class, queryable PeTTa relation instead
; of a host-side structural function.  It fulfils `docs/first_class_catalysis.md`:
;
;   (catalyzes <molecule> <rule-id>)
;
; is a ground binary relation, materialized once from the exp04 template
; matcher, and thereafter the *only* interface RAF reflexive-autocatalysis
; checks use.  RAF logic queries catalysis by rule identity; it no longer
; reconstructs catalysis from structural containment inside the detector.
;
; Provenance: the (catalyzes ...) facts below were materialized from
; `chem_exp04.metta`'s `template-catalyzes?` relation over the 20-rule exp04
; pool.  18 of 20 rules have a valid non-monomer catalyst; mABC and mBCD are
; deliberately absent (catalyst is monomer-adjacent only, rejected by the
; specificity threshold).  This is exactly the set that survives the RA gate.

!(import! &self chem_exp04.metta)

; ----- Materialized first-class catalysis relation -----
;
; One ground atom per (catalyst-molecule, rule-id) pair.  These are the
; substrate facts; nothing here calls a host function.

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

; ----- Queryable catalysis interface -----
;
; `catalyzes?` succeeds only when a ground (catalyzes M R) fact is present.
; It is the first-class detector interface: RAF logic asks this, and only this.
; Any (M R) pair without a materialized fact answers False (closed-world).

(= (catalyzes? $m $rid)
   (case (catalyzes $m $rid)
     ((True True)
      ($_ False))))

; Rule-level query by *rule identity*.  Extracts the rule's declared catalyst
; and rule-id, then consults the first-class relation.  This is the port of the
; old `rich-rule-template-catalyzed?`, but it queries the relation rather than
; re-deriving structural containment.
(= (rule-catalyzed-by-relation? (rich-rule $id $type $a $b $product $secondary $catalyst))
   (catalyzes? $catalyst $id))

; Catalyst molecule of a rule, for reflexive-autocatalysis membership checks.
(= (rule-catalyst-molecule (rich-rule $id $type $a $b $product $secondary $catalyst))
   $catalyst)

; ----- No-catalysis ablation as an empty relation -----
;
; The ablation passes an empty catalysis relation through the identical query
; interface.  `ablated-catalyzes?` never succeeds, so the same RA check that
; uses `catalyzes?` collapses every rule out under ablation -- no separate
; ablation code path, no host toggle.
(= (ablated-catalyzes? $m $rid) False)

(= (rule-catalyzed-under-ablation? (rich-rule $id $type $a $b $product $secondary $catalyst))
   (ablated-catalyzes? $catalyst $id))

; ----- First-class relation summary / fidelity atoms -----

(= (catalysis-relation-rule-ids)
   (lAB lBC lCD lAC lABC1 lABC2 lBCD1 lBCD2
    cAB cBC cCD cABC1 cABC2 cBCD mAB mBC mAC mCD))

(= (catalysis-relation-size) 18)

; The two exp04 rules with no first-class catalyst (monomer-adjacent, rejected).
(= (catalysis-relation-uncatalyzed-rule-ids) (mABC mBCD))

; Fidelity: the first-class relation must agree with the template provenance on
; every rule in the pool.  For each rule, relation-query == template-query.
(= (catalysis-relation-agrees-with-template?
      (rich-rule $id $type $a $b $product $secondary $catalyst))
   (== (rule-catalyzed-by-relation? (rich-rule $id $type $a $b $product $secondary $catalyst))
       (rich-rule-template-catalyzed? (rich-rule $id $type $a $b $product $secondary $catalyst))))
