# exp02 small random-polymer sweep — 2026-06-30/2026-07-01

## Purpose

First small deterministic exp02 plumbing/control sweep. This is not an emergence claim; it verifies that random-polymer, shuffled-catalyst, and no-catalysis runs can be represented in PeTTa and recorded under the v0.1 run-contract shape across multiple seed/rule-count points, including component-generated and seed-to-component eight-rule families.

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
- `src/chem_exp02.metta` SHA-256: `ee13658748eb453b973523f057317ec2e0d9ad89b2481402b68870d024da2257`
- `experiments/exp02/smoke.metta` SHA-256: `73dcdc99bf4fe1c95163311958645c17749dda1f0151528db7ae5d1b2bbd3388`
- `scripts/write_exp02_contract_files.py` SHA-256: `8ad5865448b3c99f79e64efe2fb30f43823277d900f93820b25e96263e065f47`
- `scripts/test_exp02_contract_files.sh` SHA-256: `9f0d161eefcf58f9f4843d2710d7ca56541681447ad83cae9ee633102ff57f7d`

## Seed list

- `seed-7` / four rules
- `seed-11` / six rules
- `seed-13` / eight component-generated rules
- `seed-17` / eight seed-to-component-generated rules

## Run records

- `exp02-small-random`: seed-7/four-rule random-polymer fixture, active ACS pairs = 1.
- `exp02-small-shuffled`: seed-7/four-rule shuffled-catalyst control, active ACS pairs = 0.
- `exp02-small-no-catalysis`: seed-7/four-rule no-catalysis control, active ACS pairs = 0.
- `exp02-seed-11-rules-6-random`: seed-11/six-rule random-polymer fixture, active ACS pairs = 2.
- `exp02-seed-11-rules-6-shuffled`: seed-11/six-rule shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-11-rules-6-no-catalysis`: seed-11/six-rule no-catalysis control, active ACS pairs = 0.
- `exp02-seed-13-rules-8-random`: seed-13/eight-rule component-generated random-polymer family, active ACS pairs = 2.
- `exp02-seed-13-rules-8-shuffled`: seed-13/eight-rule shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-13-rules-8-no-catalysis`: seed-13/eight-rule no-catalysis control, active ACS pairs = 0.
- `exp02-seed-17-rules-8-random`: seed-17/eight-rule seed-to-component random-polymer family, active ACS pairs = 2.
- `exp02-seed-17-rules-8-shuffled`: seed-17/eight-rule shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-17-rules-8-no-catalysis`: seed-17/eight-rule no-catalysis control, active ACS pairs = 0.

## Exit status

- `scripts/run_exp02.sh`: `0`

## Conclusion

The small exp02 sweep passed across seed-7/four-rule, seed-11/six-rule, component-generated seed-13/eight-rule, and seed-to-component seed-17/eight-rule parameter points. The seed-derived polymer fixtures contain conservative reciprocal product-as-catalyst pairs, while shuffled-catalyst and no-catalysis controls contain zero active ACS pairs. This validates broader exp02 control/run-record plumbing only; larger less-fixture-like sweeps are still needed before making any spontaneous-ACS claim.
## Serialized run-contract files

After the PeTTa smoke passed, `scripts/write_exp02_contract_files.sh` serializes all twelve tested run-contract records into per-run directories:

- `runs/exp02-small-random/`
- `runs/exp02-small-shuffled/`
- `runs/exp02-small-no-catalysis/`
- `runs/exp02-seed-11-rules-6-random/`
- `runs/exp02-seed-11-rules-6-shuffled/`
- `runs/exp02-seed-11-rules-6-no-catalysis/`
- `runs/exp02-seed-13-rules-8-random/`
- `runs/exp02-seed-13-rules-8-shuffled/`
- `runs/exp02-seed-13-rules-8-no-catalysis/`
- `runs/exp02-seed-17-rules-8-random/`
- `runs/exp02-seed-17-rules-8-shuffled/`
- `runs/exp02-seed-17-rules-8-no-catalysis/`

Each directory follows the v0.1 file convention: `CONFIG.metta`, `MANIFEST.metta`, `EVENTS.metta`, `ABUNDANCES.metta`, `METRICS.metta`, `ACS.metta`, `ABLATIONS.metta`, and `SUMMARY.metta`. The host script only serializes atoms already represented/tested in PeTTa; chemistry and ACS detection remain in `.metta` files.
