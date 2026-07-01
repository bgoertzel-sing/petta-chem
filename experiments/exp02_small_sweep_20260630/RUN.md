# exp02 small random-polymer sweep — 2026-06-30/2026-07-01

## Purpose

First small deterministic exp02 plumbing/control sweep. This is not an emergence claim; it verifies that random-polymer, shuffled-catalyst, and no-catalysis runs can be represented in PeTTa and recorded under the v0.1 run-contract shape across more than one seed/rule-count point.

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
- `src/chem_exp02.metta` SHA-256: `15ba5cdf297aca61273f6dcc62d8a70ff838cc5fbcd44e961fb676ce6f62f62d`
- `experiments/exp02/smoke.metta` SHA-256: `99e176311ceedbb2f8b7af5aace0999070a8cdaafee4290ff85eecb82e2d53be`

## Seed list

- `seed-7` / four rules
- `seed-11` / six rules

## Run records

- `exp02-small-random`: seed-7/four-rule random-polymer fixture, active ACS pairs = 1.
- `exp02-small-shuffled`: seed-7/four-rule shuffled-catalyst control, active ACS pairs = 0.
- `exp02-small-no-catalysis`: seed-7/four-rule no-catalysis control, active ACS pairs = 0.
- `exp02-seed-11-rules-6-random`: seed-11/six-rule random-polymer fixture, active ACS pairs = 2.
- `exp02-seed-11-rules-6-shuffled`: seed-11/six-rule shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-11-rules-6-no-catalysis`: seed-11/six-rule no-catalysis control, active ACS pairs = 0.

## Exit status

- `scripts/run_exp02.sh`: `0`

## Conclusion

The small exp02 sweep passed across seed-7/four-rule and seed-11/six-rule parameter points. The seed-derived polymer fixtures contain conservative reciprocal product-as-catalyst pairs, while shuffled-catalyst and no-catalysis controls contain zero active ACS pairs. This validates exp02 control/run-record plumbing only; larger and less fixture-like parameter sweeps are still needed before making any spontaneous-ACS claim.
## Serialized run-contract files

After the PeTTa smoke passed, `scripts/write_exp02_contract_files.sh` wrote the tested run-contract atoms into per-run directories:

- `runs/exp02-small-random/`
- `runs/exp02-small-shuffled/`
- `runs/exp02-small-no-catalysis/`

Each directory follows the v0.1 file convention: `CONFIG.metta`, `MANIFEST.metta`, `EVENTS.metta`, `ABUNDANCES.metta`, `METRICS.metta`, `ACS.metta`, `ABLATIONS.metta`, and `SUMMARY.metta`. The host script only serializes atoms already represented in PeTTa; chemistry and ACS detection remain in `.metta` files.
