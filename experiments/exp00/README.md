# exp00 deterministic smoke

Purpose: establish the smallest executable PeTTa-native chemistry kernel shape before stochastic sampling or larger ACS detection.

This is not yet an emergence experiment. It is a deterministic replay test:

```text
A + B --Cat--> AB
```

Expected state transition:

```metta
(state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
=>
(state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
(event 0 r0 A B AB Cat)
```

Run:

```bash
scripts/run_exp00.sh
```

Passing this smoke means the repo has a working PeTTa runtime path, first atom accessors, event construction, replay equality, a bounded generic binary-catalytic state transformer, candidate atoms, chamber-rule-based candidate generation, candidate-pool/candidate-cap atoms, chamber atoms, metric atoms, applicability checks, nonnegative abundance checks, and a seed/tick deterministic candidate selector wired directly into generated chamber ticking. The generic `candidate-selection-from-pool` seam records the exact bounded list and deterministic selected candidate. `selection-fire-record-from-pool` keeps that full selection provenance beside the chamber produced by firing the exact choice, and generic chamber ticking projects its result from this combined object; `selected-candidate-from-pool` remains a selection-only projection. Candidate generation is evaluated once per bounded pool. Chamber firing validates that an external/scored candidate preserves the source rule's stable ID, reactants, and product while allowing catalyst reassignment; rejected choices remain inspectable in selection provenance. All cap-specific candidate-pool and generated-tick compatibility operations are aliases of the generic provenance-backed path, so capping, deterministic selection, and firing have one implementation. Caps are maxima, so a requested cap of eight can safely preserve and select from a smaller three-candidate pool. It does **not** claim ACS emergence.
