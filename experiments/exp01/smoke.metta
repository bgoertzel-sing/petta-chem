!(import! &self ../../src/chem_exp01.metta)

!(test (exp01-planted-rule rp0)
       (rule rp0 Food X Y Z))

!(test (exp01-planted-rule rp1)
       (rule rp1 Food W Z Y))

!(test (exp01-distractor-rule rd0)
       (rule rd0 Food X Waste W))

!(test (exp01-rules-with-distractors)
       ((rule rd0 Food X Waste W)
        (rule rp0 Food X Y Z)
        (rule rd1 Waste X Food W)
        (rule rp1 Food W Z Y)))

!(test (product-catalyst-closed-2?
         (exp01-planted-rule rp0)
         (exp01-planted-rule rp1))
       True)

!(test (exp01-planted-closure-ok?) True)

!(test (exp01-recovered-acs)
       (acs-candidate
         exp01-planted
         ((rule rp0 Food X Y Z) (rule rp1 Food W Z Y))
         (Y Z)
         (Y Z)
         active))

!(test (acs-id (exp01-recovered-acs)) exp01-planted)

!(test (exp01-recovered-rules)
       ((rule rp0 Food X Y Z) (rule rp1 Food W Z Y)))

!(test (acs-products (exp01-recovered-acs)) (Y Z))

!(test (acs-catalysts (exp01-recovered-acs)) (Y Z))

!(test (acs-status (exp01-recovered-acs)) active)

!(test (useful-acs-2?
         (exp01-distractor-rule rd0)
         (exp01-distractor-rule rd1))
       False)

!(test (exp01-distractor-pair-rejected?) True)

!(test (non-catalytic-cycle-2?
         (exp01-noncatalytic-cycle-rule rc0)
         (exp01-noncatalytic-cycle-rule rc1))
       True)

!(test (exp01-noncatalytic-cycle-rejected?) True)

!(test (exp01-baseline-productivity) 2)

!(test (exp01-ablate-rp0)
       (ablation exp01-planted rp0 2 1 1))

!(test (ablation-drop (exp01-ablate-rp0)) 1)

!(test (exp01-ablation-drop-positive?) True)
