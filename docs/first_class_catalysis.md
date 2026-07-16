# First-class catalysis contract

## Question

How should exp04 represent catalysis so RAF detection measures an explicit
chemistry relation instead of reconstructing catalysis from host-side molecule
name heuristics?

## Contract

1. Catalysis is a binary PeTTa relation, `(catalyzes Molecule RuleId)`.
2. The relation is inspectable independently of rule firing and RAF detection.
3. RAF reflexive-autocatalysis checks use only this relation. They must not
   infer catalysis from structural containment, affinity weights, or firing
   statistics.
4. The existing template matcher may remain as provenance for how the initial
   exp04 relation was materialized, but it is not the detector interface.
5. The host maximal-RAF reference may parse materialized PeTTa catalysis facts
   as a thin validation harness; it must not recreate them.
6. No-catalysis ablation passes an empty relation through the same closure,
   pruning, core-minimization, and dynamics code paths.
7. The first fidelity gate is the existing seeded exp04 fixture: maximal RAF
   size 15, greedy core size 2 (`lCD`, `lBCD2`), core RAF true, and ablated
   maximal RAF size 0.

## Scientific boundary

Passing this gate establishes a first-class catalysis interface and a faithful
port of the seeded RAF reference. It is not evidence of unseeded ACS emergence.
Graded catalysis and threshold sweeps are deferred until the binary reference
is validated.
