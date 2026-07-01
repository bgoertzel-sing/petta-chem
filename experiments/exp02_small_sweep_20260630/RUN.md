# exp02 small random-polymer sweep — 2026-06-30

## Purpose

First tiny deterministic exp02 plumbing/control sweep. This is not an emergence claim; it verifies that random-polymer, shuffled-catalyst, and no-catalysis runs can be represented in PeTTa and recorded under the v0.1 run-contract shape.

## Commands

From repository root:

```bash
scripts/run_exp02.sh
```

## Runtime/provenance

- PeTTa runner: local `projects/omegaclaw/repos/PeTTa/run.sh`
- SWI-Prolog: local `projects/omegaclaw/local/swipl-9.3.36`
- Kernel/config source: `src/chem_exp02.metta`
- Smoke/run-record source: `experiments/exp02/smoke.metta`
- `src/chem_exp02.metta` SHA-256: `1173f3339a6470d01c1bfa5f4ae4af3a658ca236b4ac2889931e0d6f9fd69b59`
- `experiments/exp02/smoke.metta` SHA-256: `2f212704caa561bf18918e10e7ff30350bd19d4eb263021c219d0e140cc8605d`

## Seed list

- `seed-7`

## Run records

- `exp02-small-random`: random-polymer fixture, active ACS pairs = 1.
- `exp02-small-shuffled`: shuffled-catalyst control, active ACS pairs = 0.
- `exp02-small-no-catalysis`: no-catalysis control, active ACS pairs = 0.

## Exit status

- `scripts/run_exp02.sh`: `0`

## Conclusion

The first tiny exp02 sweep passed. The seed-derived polymer fixture contains one conservative reciprocal product-as-catalyst pair, while the shuffled-catalyst and no-catalysis controls contain zero active ACS pairs. This validates exp02 control/run-record plumbing only; larger parameterized sweeps are still needed before making any spontaneous-ACS claim.
## Serialized run-contract files

After the PeTTa smoke passed, `scripts/write_exp02_contract_files.sh` wrote the tested run-contract atoms into per-run directories:

- `runs/exp02-small-random/`
- `runs/exp02-small-shuffled/`
- `runs/exp02-small-no-catalysis/`

Each directory follows the v0.1 file convention: `CONFIG.metta`, `MANIFEST.metta`, `EVENTS.metta`, `ABUNDANCES.metta`, `METRICS.metta`, `ACS.metta`, `ABLATIONS.metta`, and `SUMMARY.metta`. The host script only serializes atoms already represented in PeTTa; chemistry and ACS detection remain in `.metta` files.
