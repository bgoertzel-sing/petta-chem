# petta-chem

PeTTa-first abstract algorithmic chemistry experiments.

The core chemistry kernel is implemented in PeTTa/MeTTa syntax from the start. Python may be added later only as thin harness/glue for configuration, batch execution, storage, plotting, and filesystem logistics.

## Runtime decision

Version 0.1 targets the locally validated PeTTa runtime:

- PeTTa checkout: `../omegaclaw/repos/PeTTa` in the surrounding research workspace, or any compatible PeTTa checkout via `PETTA_RUNNER`.
- SWI-Prolog: 9.3.x; initial local validation used SWI-Prolog 9.3.36.
- Kernel files: `.metta` under `src/` and `experiments/`.

See `docs/runtime.md` for rationale and reproduction details.

## Smoke tests

From this repository:

```bash
scripts/run_exp00.sh
scripts/run_exp01.sh
scripts/run_contract.sh
scripts/run_exp02.sh
scripts/test_exp02_contract_files.sh
scripts/run_exp03.sh
```

`experiments/exp00/smoke.metta` is a deliberately tiny deterministic chemistry spike. It establishes initial molecule/rule/state/candidate/candidate-pool/candidate-cap/event/chamber/metric atom contracts plus a generic bounded binary catalytic transition, candidate applicability checks, nonnegative abundance invariants, chamber-rule-based candidate generation, per-tick candidate caps, and a seed/tick deterministic candidate selector wired into generated chamber ticking before larger stochastic/harness work is added.

`experiments/exp01/smoke.metta` validates the first planted ACS recovery seam: a two-rule catalytic closure is recovered from a rule list with distractors, non-catalytic cycles are rejected, and single-rule ablation produces a productivity drop derived from replayed PeTTa productivity traces.

`experiments/run_contract/smoke.metta` defines the version-0.1 consequential-run output contract in PeTTa-shaped atoms before exp02 sweeps: config, manifest/provenance, events, abundance snapshots, metrics, ACS candidates, ablations, and summary/replay status.

`experiments/exp02/smoke.metta` runs the first systematic deterministic random-polymer control sweep in PeTTa: seed-7/four-rule, seed-11/six-rule, component-generated seed-13/eight-rule, seed-to-component seed-17/eight-rule, generated non-planted seed-19/seed-23, and factored-template seed-29/seed-31/seed-37/seed-41/seed-43/seed-47/seed-53/seed-59/seed-61/seed-67/seed-71/seed-73/seed-79/seed-83/seed-89/seed-97/seed-101/seed-103/seed-107/seed-109/seed-113/seed-127/seed-131/seed-137/seed-139/seed-149/seed-151 eight-rule points are represented as explicit `exp02-sweep-point` atoms, compared with shuffled-catalyst and no-catalysis controls, scanned by the conservative ACS detector, recorded as run-contract records, and summarized by tested `exp02-sweep-kind-summary-report` atoms whose rows derive from folded run-record summaries.

`scripts/write_exp02_contract_files.sh` is a thin host harness that serializes all ninety-nine PeTTa-tested exp02 run-contract records into the v0.1 per-run file convention under `experiments/exp02_small_sweep_20260630/runs/`; it does not drive chemistry logic.

`experiments/exp03/smoke.metta` adds deterministic multi-tick soup dynamics over exp00 contracts: a bounded chamber runner accumulates events across ticks, advances through blocked/no-op steps, exercises a selectable two-rule pool with one productive rule and one distractor, and includes exp02-style random/shuffled/no-catalysis dynamic bridges where random families produce events while controls remain no-op. The seed-11 bridge is recorded in v0.1 run-contract atoms; seed-7/four-rule and seed-13/seed-17 eight-rule full-source chambers keep all source rules visible while candidate caps bound ticking to the deterministic two-candidate selector with replay checks, run-export projections, and a compact dynamic aggregate report over the tested full-source exports.
