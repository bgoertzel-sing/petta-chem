; Run output contract for petta-chem experiments.
;
; The contract is PeTTa-shaped and intentionally small: host harnesses may later
; serialize these atoms to files, but the required record shape remains visible
; and testable from PeTTa.
;
; Required atoms, version 0.1:
;   (run-config <run-id> <experiment> <seeds> <tick-limit> <candidate-cap> <control>)
;   (run-manifest <run-id> <config-hash> <petta-ref> <swi-version> <command> <exit-status>)
;   (abundance-snapshot <tick> <molecules>)
;   (run-summary <run-id> <status> <conclusion> <replay-ok?>)
;   (run-record <run-id> <config> <manifest> <events> <abundances>
;               <metrics> <acs-candidates> <ablations> <summary>)
;
; File-level convention for consequential runs:
;   CONFIG.metta      one run-config atom plus any experiment-specific parameters
;   MANIFEST.metta    one run-manifest atom with command/runtime/provenance
;   EVENTS.metta      event atoms or an event list in firing order
;   ABUNDANCES.metta  abundance-snapshot atoms in tick order
;   METRICS.metta     metric atoms derived from events/abundances
;   ACS.metta         acs-candidate atoms, active and rejected where scanned
;   ABLATIONS.metta   ablation atoms for causal/productivity checks
;   SUMMARY.metta     one run-summary atom with replay status and conclusion

; Load chemistry/ACS definitions before this file in smoke tests or harnesses;
; direct relative imports are intentionally left to callers because PeTTa resolves
; nested imports relative to the top-level runnable.

; ----- run contract atom accessors -----

(= (make-run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control)
   (run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control))

(= (run-config-id (run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control))
   $run-id)

(= (run-config-experiment (run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control))
   $experiment)

(= (run-config-seeds (run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control))
   $seeds)

(= (run-config-tick-limit (run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control))
   $tick-limit)

(= (run-config-candidate-cap (run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control))
   $candidate-cap)

(= (run-config-control (run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control))
   $control)

(= (make-run-manifest $run-id $config-hash $petta-ref $swi-version $command $exit-status)
   (run-manifest $run-id $config-hash $petta-ref $swi-version $command $exit-status))

(= (run-manifest-id (run-manifest $run-id $config-hash $petta-ref $swi-version $command $exit-status))
   $run-id)

(= (run-manifest-config-hash (run-manifest $run-id $config-hash $petta-ref $swi-version $command $exit-status))
   $config-hash)

(= (run-manifest-exit-status (run-manifest $run-id $config-hash $petta-ref $swi-version $command $exit-status))
   $exit-status)

(= (make-abundance-snapshot $tick $molecules)
   (abundance-snapshot $tick $molecules))

(= (abundance-snapshot-tick (abundance-snapshot $tick $molecules))
   $tick)

(= (abundance-snapshot-molecules (abundance-snapshot $tick $molecules))
   $molecules)

(= (make-run-summary $run-id $status $conclusion $replay-ok?)
   (run-summary $run-id $status $conclusion $replay-ok?))

(= (run-summary-id (run-summary $run-id $status $conclusion $replay-ok?))
   $run-id)

(= (run-summary-status (run-summary $run-id $status $conclusion $replay-ok?))
   $status)

(= (run-summary-replay-ok? (run-summary $run-id $status $conclusion $replay-ok?))
   $replay-ok?)

(= (make-run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary)
   (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))

(= (run-record-id (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $run-id)

(= (run-record-config (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $config)

(= (run-record-manifest (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $manifest)

(= (run-record-events (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $events)

(= (run-record-abundances (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $abundances)

(= (run-record-metrics (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $metrics)

(= (run-record-acs-candidates (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $acs-candidates)

(= (run-record-ablations (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $ablations)

(= (run-record-summary (run-record $run-id $config $manifest $events $abundances $metrics $acs-candidates $ablations $summary))
   $summary)

(= (run-record-ids-consistent?
      (run-record $run-id
                  (run-config $run-id $experiment $seeds $tick-limit $candidate-cap $control)
                  (run-manifest $run-id $config-hash $petta-ref $swi-version $command $exit-status)
                  $events
                  $abundances
                  $metrics
                  $acs-candidates
                  $ablations
                  (run-summary $run-id $status $conclusion $replay-ok?)))
   True)

(= (run-record-passed?
      (run-record $run-id
                  $config
                  (run-manifest $run-id $config-hash $petta-ref $swi-version $command 0)
                  $events
                  $abundances
                  $metrics
                  $acs-candidates
                  $ablations
                  (run-summary $run-id passed $conclusion True)))
   True)

; ----- exp01 fixture projected into the contract -----

(= (exp01-contract-config)
   (make-run-config exp01-contract exp01 (seed-7) 2 (candidate-cap 2 1) planted-acs))

(= (exp01-contract-manifest)
   (make-run-manifest exp01-contract config-hash-exp01-contract petta-local swi-9-3-36 scripts-run-exp01-sh 0))

(= (exp01-contract-events)
   ((event 0 rp0 Food X Y Z)
    (event 1 rp1 Food W Z Y)))

(= (exp01-contract-abundances)
   ((make-abundance-snapshot
      0
      ((mol Food 2) (mol X 1) (mol Y 0) (mol Z 1)))
    (make-abundance-snapshot
      1
      ((mol Food 1) (mol X 0) (mol Y 1) (mol Z 1)))
    (make-abundance-snapshot
      2
      ((mol Food 0) (mol W 0) (mol Z 1) (mol Y 1)))))

(= (exp01-contract-metrics)
   ((metric productivity-trace-count exp01-planted 2)
    (metric ablation-drop exp01-planted 1)))

(= (exp01-contract-acs-candidates)
   (exp01-scanned-pairs))

(= (exp01-contract-ablations)
   ((ablation exp01-planted rp0 2 1 1)))

(= (exp01-contract-summary)
   (make-run-summary exp01-contract passed planted-acs-recovered True))

(= (exp01-contract-run-record)
   (make-run-record
     exp01-contract
     (exp01-contract-config)
     (exp01-contract-manifest)
     (exp01-contract-events)
     (exp01-contract-abundances)
     (exp01-contract-metrics)
     (exp01-contract-acs-candidates)
     (exp01-contract-ablations)
     (exp01-contract-summary)))

(= (exp01-contract-complete?)
   (and (run-record-ids-consistent? (exp01-contract-run-record))
        (run-record-passed? (exp01-contract-run-record))))
