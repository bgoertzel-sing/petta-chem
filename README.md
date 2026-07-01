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
```

`experiments/exp00/smoke.metta` is a deliberately tiny deterministic chemistry spike. It establishes initial molecule/rule/state/candidate/candidate-pool/candidate-cap/event/chamber/metric atom contracts plus a generic bounded binary catalytic transition, candidate applicability checks, nonnegative abundance invariants, chamber-rule-based candidate generation, per-tick candidate caps, and a seed/tick deterministic candidate selector wired into generated chamber ticking before larger stochastic/harness work is added.

`experiments/exp01/smoke.metta` validates the first planted ACS recovery seam: a two-rule catalytic closure is recovered from a rule list with distractors, non-catalytic cycles are rejected, and single-rule ablation produces a productivity drop derived from replayed PeTTa productivity traces.

`experiments/run_contract/smoke.metta` defines the version-0.1 consequential-run output contract in PeTTa-shaped atoms before exp02 sweeps: config, manifest/provenance, events, abundance snapshots, metrics, ACS candidates, ablations, and summary/replay status.

`experiments/exp02/smoke.metta` runs the first tiny deterministic random-polymer control sweep in PeTTa: one seed-derived rule set is compared with shuffled-catalyst and no-catalysis controls, all rule pairs are scanned by the conservative ACS detector, and each run is represented as a run-contract record.

`scripts/write_exp02_contract_files.sh` is a thin host harness that serializes those PeTTa-tested exp02 run-contract atoms into the v0.1 per-run file convention under `experiments/exp02_small_sweep_20260630/runs/`; it does not implement chemistry logic.
