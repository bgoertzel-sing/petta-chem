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

!(test (acs-status-for-pair
         (exp01-planted-rule rp0)
         (exp01-planted-rule rp1))
       active)

!(test (acs-status-for-pair
         (exp01-distractor-rule rd0)
         (exp01-distractor-rule rd1))
       rejected)

!(test (scan-rule-pair pair-1-3
                        (exp01-planted-rule rp0)
                        (exp01-planted-rule rp1))
       (acs-candidate
         pair-1-3
         ((rule rp0 Food X Y Z) (rule rp1 Food W Z Y))
         (Y Z)
         (Z Y)
         active))

!(test (candidate-rule-set-closed-2?
         ((exp01-planted-rule rp0) (exp01-planted-rule rp1)))
       True)

!(test (scan-rule-set-2 planted-set
                         ((exp01-planted-rule rp0)
                          (exp01-planted-rule rp1)))
       (acs-candidate
         planted-set
         ((rule rp0 Food X Y Z) (rule rp1 Food W Z Y))
         (Y Z)
         (Z Y)
         active))

!(test (exp01-scanned-pairs)
       ((acs-candidate
          pair-0-1
          ((rule rd0 Food X Waste W) (rule rp0 Food X Y Z))
          (Waste Y)
          (W Z)
          rejected)
        (acs-candidate
          pair-0-2
          ((rule rd0 Food X Waste W) (rule rd1 Waste X Food W))
          (Waste Food)
          (W W)
          rejected)
        (acs-candidate
          pair-0-3
          ((rule rd0 Food X Waste W) (rule rp1 Food W Z Y))
          (Waste Z)
          (W Y)
          rejected)
        (acs-candidate
          pair-1-2
          ((rule rp0 Food X Y Z) (rule rd1 Waste X Food W))
          (Y Food)
          (Z W)
          rejected)
        (acs-candidate
          pair-1-3
          ((rule rp0 Food X Y Z) (rule rp1 Food W Z Y))
          (Y Z)
          (Z Y)
          active)
        (acs-candidate
          pair-2-3
          ((rule rd1 Waste X Food W) (rule rp1 Food W Z Y))
          (Food Z)
          (W Y)
          rejected)))

!(test (exp01-recovered-acs)
       (acs-candidate
         exp01-planted
         ((rule rp0 Food X Y Z) (rule rp1 Food W Z Y))
         (Y Z)
         (Z Y)
         active))

!(test (acs-id (exp01-recovered-acs)) exp01-planted)

!(test (exp01-recovered-rules)
       ((rule rp0 Food X Y Z) (rule rp1 Food W Z Y)))

!(test (acs-products (exp01-recovered-acs)) (Y Z))

!(test (acs-catalysts (exp01-recovered-acs)) (Z Y))

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

!(test (exp01-rp0-replay-state)
       (state 0 seed-7 (mol Food 2) (mol X 1) (mol Y 0) (mol Z 1)))

!(test (exp01-rp1-replay-state)
       (state 1 seed-7 (mol Food 1) (mol W 1) (mol Z 0) (mol Y 1)))

!(test (exp01-baseline-productivity-trace)
       (productivity-trace
         exp01-planted-baseline
         ((trace
            (state 1 seed-7 (mol Food 1) (mol X 0) (mol Y 1) (mol Z 1))
            (event 0 rp0 Food X Y Z))
          (trace
            (state 2 seed-7 (mol Food 0) (mol W 0) (mol Z 1) (mol Y 1))
            (event 1 rp1 Food W Z Y)))))

!(test (productivity-trace-count (exp01-baseline-productivity-trace)) 2)

!(test (exp01-ablate-rp0-productivity-trace)
       (productivity-trace
         exp01-planted-ablate-rp0
         ((trace
            (state 2 seed-7 (mol Food 0) (mol W 0) (mol Z 1) (mol Y 1))
            (event 1 rp1 Food W Z Y)))))

!(test (productivity-trace-count (exp01-ablate-rp0-productivity-trace)) 1)

!(test (exp01-baseline-productivity) 2)

!(test (exp01-ablate-rp0)
       (ablation exp01-planted rp0 2 1 1))

!(test (ablation-drop (exp01-ablate-rp0)) 1)

!(test (exp01-ablation-drop-positive?) True)

; ----- 3-rule catalytic cycle scanner smoke tests -----

!(test (product-catalyst-closed-3?
         (exp01-planted-triple-rule tc0)
         (exp01-planted-triple-rule tc1)
         (exp01-planted-triple-rule tc2))
       True)

!(test (exp01-triple-closure-ok?) True)

!(test (acs-status-for-triple
         (exp01-planted-triple-rule tc0)
         (exp01-planted-triple-rule tc1)
         (exp01-planted-triple-rule tc2))
       active)

!(test (acs-status-for-triple
         (exp01-planted-triple-rule tc0)
         (exp01-planted-triple-rule tc1)
         (exp01-triple-distractor-rule td0))
       rejected)

!(test (exp01-triple-distractor-rejected?) True)

!(test (scan-rule-triple triple-0-1-2
                         (exp01-planted-triple-rule tc0)
                         (exp01-planted-triple-rule tc1)
                         (exp01-planted-triple-rule tc2))
       (acs-candidate
         triple-0-1-2
         ((rule tc0 TF0 TB0 TC1 TC0)
          (rule tc1 TF1 TB1 TC2 TC1)
          (rule tc2 TF2 TB2 TC0 TC2))
         (TC1 TC2 TC0)
         (TC0 TC1 TC2)
         active))

!(test (exp01-scanned-triples)
       ((acs-candidate
          triple-0-1-2
          ((rule tc0 TF0 TB0 TC1 TC0)
           (rule tc1 TF1 TB1 TC2 TC1)
           (rule td0 TF3 TB3 TNone TNone))
          (TC1 TC2 TNone)
          (TC0 TC1 TNone)
          rejected)
        (acs-candidate
          triple-0-1-3
          ((rule tc0 TF0 TB0 TC1 TC0)
           (rule tc1 TF1 TB1 TC2 TC1)
           (rule tc2 TF2 TB2 TC0 TC2))
          (TC1 TC2 TC0)
          (TC0 TC1 TC2)
          active)
        (acs-candidate
          triple-0-2-3
          ((rule tc0 TF0 TB0 TC1 TC0)
           (rule td0 TF3 TB3 TNone TNone)
           (rule tc2 TF2 TB2 TC0 TC2))
          (TC1 TNone TC0)
          (TC0 TNone TC2)
          rejected)
        (acs-candidate
          triple-1-2-3
          ((rule tc1 TF1 TB1 TC2 TC1)
           (rule td0 TF3 TB3 TNone TNone)
           (rule tc2 TF2 TB2 TC0 TC2))
          (TC2 TNone TC0)
          (TC1 TNone TC2)
          rejected)))

!(test (exp01-recovered-triple-active-count) 1)

!(test (exp01-triple-recovered?) True)

; ----- 4-rule catalytic cycle scanner smoke tests -----

!(test (product-catalyst-closed-4?
         (exp01-planted-quadruple-rule qc0)
         (exp01-planted-quadruple-rule qc1)
         (exp01-planted-quadruple-rule qc2)
         (exp01-planted-quadruple-rule qc3))
       True)

!(test (exp01-quadruple-closure-ok?) True)

!(test (acs-status-for-quadruple
         (exp01-planted-quadruple-rule qc0)
         (exp01-planted-quadruple-rule qc1)
         (exp01-planted-quadruple-rule qc2)
         (exp01-planted-quadruple-rule qc3))
       active)

!(test (acs-status-for-quadruple
         (exp01-planted-quadruple-rule qc0)
         (exp01-planted-quadruple-rule qc1)
         (exp01-quadruple-distractor-rule qd0)
         (exp01-planted-quadruple-rule qc3))
       rejected)

!(test (exp01-quadruple-distractor-rejected?) True)

!(test (scan-rule-quadruple quadruple-0-1-2-3
                         (exp01-planted-quadruple-rule qc0)
                         (exp01-planted-quadruple-rule qc1)
                         (exp01-planted-quadruple-rule qc2)
                         (exp01-planted-quadruple-rule qc3))
       (acs-candidate
         quadruple-0-1-2-3
         ((rule qc0 QF0 QB0 QC1 QC0)
          (rule qc1 QF1 QB1 QC2 QC1)
          (rule qc2 QF2 QB2 QC3 QC2)
          (rule qc3 QF3 QB3 QC0 QC3))
         (QC1 QC2 QC3 QC0)
         (QC0 QC1 QC2 QC3)
         active))

!(test (exp01-scanned-quadruples)
       ((acs-candidate
          quadruple-0-1-2-3
          ((rule qc0 QF0 QB0 QC1 QC0)
           (rule qc1 QF1 QB1 QC2 QC1)
           (rule qd0 QF4 QB4 QNone QNone)
           (rule qc2 QF2 QB2 QC3 QC2))
          (QC1 QC2 QNone QC3)
          (QC0 QC1 QNone QC2)
          rejected)
        (acs-candidate
          quadruple-0-1-2-4
          ((rule qc0 QF0 QB0 QC1 QC0)
           (rule qc1 QF1 QB1 QC2 QC1)
           (rule qd0 QF4 QB4 QNone QNone)
           (rule qc3 QF3 QB3 QC0 QC3))
          (QC1 QC2 QNone QC0)
          (QC0 QC1 QNone QC3)
          rejected)
        (acs-candidate
          quadruple-0-1-3-4
          ((rule qc0 QF0 QB0 QC1 QC0)
           (rule qc1 QF1 QB1 QC2 QC1)
           (rule qc2 QF2 QB2 QC3 QC2)
           (rule qc3 QF3 QB3 QC0 QC3))
          (QC1 QC2 QC3 QC0)
          (QC0 QC1 QC2 QC3)
          active)
        (acs-candidate
          quadruple-0-2-3-4
          ((rule qc0 QF0 QB0 QC1 QC0)
           (rule qd0 QF4 QB4 QNone QNone)
           (rule qc2 QF2 QB2 QC3 QC2)
           (rule qc3 QF3 QB3 QC0 QC3))
          (QC1 QNone QC3 QC0)
          (QC0 QNone QC2 QC3)
          rejected)
        (acs-candidate
          quadruple-1-2-3-4
          ((rule qc1 QF1 QB1 QC2 QC1)
           (rule qd0 QF4 QB4 QNone QNone)
           (rule qc2 QF2 QB2 QC3 QC2)
           (rule qc3 QF3 QB3 QC0 QC3))
          (QC2 QNone QC3 QC0)
          (QC1 QNone QC2 QC3)
          rejected)))

!(test (exp01-recovered-quadruple-active-count) 1)

!(test (exp01-quadruple-recovered?) True)

; ----- 5-rule catalytic cycle (quintuple) scanner tests -----

; The planted 5-cycle should be detected as closed.
!(test (exp01-quintuple-closure-ok?) True)

; A quintuple containing the distractor should not be a useful ACS.
!(test (acs-status-for-quintuple
         (exp01-planted-quintuple-rule qc0)
         (exp01-planted-quintuple-rule qc1)
         (exp01-quintuple-distractor-rule qd0)
         (exp01-planted-quintuple-rule qc3)
         (exp01-planted-quintuple-rule qc4))
       rejected)

; Distractor rejection check.
!(test (exp01-quintuple-distractor-rejected?) True)

; Single scan-rule-quintuple on the active 5-cycle produces correct structure.
!(test (scan-rule-quintuple quintuple-active
                          (exp01-planted-quintuple-rule qc0)
                          (exp01-planted-quintuple-rule qc1)
                          (exp01-planted-quintuple-rule qc2)
                          (exp01-planted-quintuple-rule qc3)
                          (exp01-planted-quintuple-rule qc4))
       (acs-candidate
         quintuple-active
         ((exp01-planted-quintuple-rule qc0)
          (exp01-planted-quintuple-rule qc1)
          (exp01-planted-quintuple-rule qc2)
          (exp01-planted-quintuple-rule qc3)
          (exp01-planted-quintuple-rule qc4))
         (QC1 QC2 QC3 QC4 QC0)
         (QC0 QC1 QC2 QC3 QC4)
         active))

; Exactly 1 active quintuple among the 6.
!(test (exp01-recovered-quintuple-active-count) 1)

!(test (exp01-quintuple-recovered?) True)
