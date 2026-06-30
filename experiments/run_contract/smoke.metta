!(import! &self ../../src/chem_exp01.metta)
!(import! &self ../../src/run_contract.metta)

!(test (exp01-contract-config)
       (run-config exp01-contract exp01 (seed-7) 2 (candidate-cap 2 1) planted-acs))

!(test (run-config-id (exp01-contract-config)) exp01-contract)

!(test (run-config-experiment (exp01-contract-config)) exp01)

!(test (run-config-seeds (exp01-contract-config)) (seed-7))

!(test (run-config-tick-limit (exp01-contract-config)) 2)

!(test (run-config-candidate-cap (exp01-contract-config)) (candidate-cap 2 1))

!(test (run-config-control (exp01-contract-config)) planted-acs)

!(test (exp01-contract-manifest)
       (run-manifest exp01-contract config-hash-exp01-contract petta-local swi-9-3-36 scripts-run-exp01-sh 0))

!(test (run-manifest-id (exp01-contract-manifest)) exp01-contract)

!(test (run-manifest-config-hash (exp01-contract-manifest)) config-hash-exp01-contract)

!(test (run-manifest-exit-status (exp01-contract-manifest)) 0)

!(test (exp01-contract-events)
       ((event 0 rp0 Food X Y Z)
        (event 1 rp1 Food W Z Y)))

!(test (abundance-snapshot-tick
         (make-abundance-snapshot 2 ((mol Food 0) (mol W 0) (mol Z 1) (mol Y 1))))
       2)

!(test (abundance-snapshot-molecules
         (make-abundance-snapshot 2 ((mol Food 0) (mol W 0) (mol Z 1) (mol Y 1))))
       ((mol Food 0) (mol W 0) (mol Z 1) (mol Y 1)))

!(test (exp01-contract-metrics)
       ((metric productivity-trace-count exp01-planted 2)
        (metric ablation-drop exp01-planted 1)))

!(test (exp01-contract-acs-candidates)
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

!(test (exp01-contract-ablations)
       ((ablation exp01-planted rp0 2 1 1)))

!(test (exp01-contract-summary)
       (run-summary exp01-contract passed planted-acs-recovered True))

!(test (run-summary-status (exp01-contract-summary)) passed)

!(test (run-summary-replay-ok? (exp01-contract-summary)) True)

!(test (run-record-id (exp01-contract-run-record)) exp01-contract)

!(test (run-record-events (exp01-contract-run-record))
       ((event 0 rp0 Food X Y Z)
        (event 1 rp1 Food W Z Y)))

!(test (run-record-ablations (exp01-contract-run-record))
       ((ablation exp01-planted rp0 2 1 1)))

!(test (run-record-ids-consistent? (exp01-contract-run-record)) True)

!(test (run-record-passed? (exp01-contract-run-record)) True)

!(test (exp01-contract-complete?) True)
