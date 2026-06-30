# run_contract smoke

Defines and tests the version-0.1 consequential-run output contract before exp02 sweeps.

Required PeTTa-shaped record sections:

- `run-config`: run id, experiment, seeds, tick limit, candidate cap, control mode.
- `run-manifest`: config hash, PeTTa/SWI provenance, command, exit status.
- events: ordered `event` atoms.
- abundances: tick-indexed `abundance-snapshot` atoms.
- metrics: derived `metric` atoms.
- ACS candidates: active and rejected `acs-candidate` atoms where a scanner is run.
- ablations: `ablation` atoms for causal/productivity checks.
- summary: `run-summary` status, conclusion, replay flag.

Run:

```bash
scripts/run_contract.sh
```
