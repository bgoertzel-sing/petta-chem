# exp02 small random-polymer sweep — 2026-06-30/2026-07-01

## Purpose

First small deterministic exp02 plumbing/control sweep. This is not an emergence claim; it verifies that random-polymer, shuffled-catalyst, and no-catalysis runs can be represented in PeTTa and recorded under the v0.1 run-contract shape across multiple seed/rule-count points, including component-generated, planted seed-to-component, and generated non-planted eight-rule families.

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
- `src/chem_exp02.metta` SHA-256: `9d6e69885b4e7368095e31c90c0b4664ee56b665cb66f57358f438ec9fc96d7c`
- `experiments/exp02/smoke.metta` SHA-256: `082cdcd51364764931ada06c7584fdf4ce709e549777b70231471a4b8365d0ea`
- `experiments/exp02_small_sweep_20260630/SUMMARY.md` SHA-256: `356d5d0284204e7364ba5e1fadea706c09602e79b44d7e3e21709ef64c02e86f`
- `scripts/write_exp02_contract_files.py` SHA-256: `394e4ccaa3065bfefc118250dc74f969b74996186b731a3ff9df6c2a161358ff`
- `scripts/test_exp02_contract_files.sh` SHA-256: `a2e58c87549bf06830199a4754f058fb3d56f6dc0092e7a532e3f96d6c622981`

## Seed list

- `seed-7` / four rules
- `seed-11` / six rules
- `seed-13` / eight component-generated rules
- `seed-17` / eight seed-to-component-generated planted reciprocal-pair rules
- `seed-19` / eight seed-to-component-generated non-planted control rules
- `seed-23` / eight seed-to-component-generated non-planted control rules
- `seed-29` / eight factored-template generated non-planted control rules
- `seed-31` / eight factored-template generated non-planted control rules
- `seed-37` / eight factored-template generated non-planted control rules
- `seed-41` / eight factored-template generated non-planted control rules
- `seed-43` / eight factored-template generated non-planted control rules
- `seed-47` / eight factored-template generated non-planted control rules
- `seed-53` / eight factored-template generated non-planted control rules
- `seed-59` / eight factored-template generated non-planted control rules
- `seed-61` / eight factored-template generated non-planted control rules
- `seed-67` / eight factored-template generated non-planted control rules
- `seed-71` / eight factored-template generated non-planted control rules
- `seed-73` / eight factored-template generated non-planted control rules
- `seed-79` / eight factored-template generated non-planted control rules
- `seed-83` / eight factored-template generated non-planted control rules
- `seed-89` / eight factored-template generated non-planted control rules
- `seed-97` / eight factored-template generated non-planted control rules
- `seed-101` / eight factored-template generated non-planted control rules
- `seed-103` / eight factored-template generated non-planted control rules
- `seed-107` / eight factored-template generated non-planted control rules
- `seed-109` / eight factored-template generated non-planted control rules
- `seed-113` / eight factored-template generated non-planted control rules
- `seed-127` / eight factored-template generated non-planted control rules
- `seed-131` / eight factored-template generated non-planted control rules
- `seed-137` / eight factored-template generated non-planted control rules
- `seed-139` / eight factored-template generated non-planted control rules
- `seed-149` / eight factored-template generated non-planted control rules
- `seed-151` / eight factored-template generated non-planted control rules
- `seed-157` / eight factored-template generated non-planted control rules
- `seed-163` / eight factored-template generated non-planted control rules
- `seed-167` / eight factored-template generated non-planted control rules

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
- `exp02-seed-19-rules-8-random`: seed-19/eight-rule generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-19-rules-8-shuffled`: seed-19/eight-rule shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-19-rules-8-no-catalysis`: seed-19/eight-rule no-catalysis control, active ACS pairs = 0.
- `exp02-seed-23-rules-8-random`: seed-23/eight-rule generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-23-rules-8-shuffled`: seed-23/eight-rule shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-23-rules-8-no-catalysis`: seed-23/eight-rule no-catalysis control, active ACS pairs = 0.
- `exp02-seed-29-rules-8-random`: seed-29/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-29-rules-8-shuffled`: seed-29/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-29-rules-8-no-catalysis`: seed-29/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-31-rules-8-random`: seed-31/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-31-rules-8-shuffled`: seed-31/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-31-rules-8-no-catalysis`: seed-31/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-37-rules-8-random`: seed-37/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-37-rules-8-shuffled`: seed-37/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-37-rules-8-no-catalysis`: seed-37/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-41-rules-8-random`: seed-41/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-41-rules-8-shuffled`: seed-41/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-41-rules-8-no-catalysis`: seed-41/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-43-rules-8-random`: seed-43/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-43-rules-8-shuffled`: seed-43/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-43-rules-8-no-catalysis`: seed-43/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-47-rules-8-random`: seed-47/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-47-rules-8-shuffled`: seed-47/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-47-rules-8-no-catalysis`: seed-47/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-53-rules-8-random`: seed-53/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-53-rules-8-shuffled`: seed-53/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-53-rules-8-no-catalysis`: seed-53/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-59-rules-8-random`: seed-59/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-59-rules-8-shuffled`: seed-59/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-59-rules-8-no-catalysis`: seed-59/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-61-rules-8-random`: seed-61/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-61-rules-8-shuffled`: seed-61/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-61-rules-8-no-catalysis`: seed-61/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-67-rules-8-random`: seed-67/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-67-rules-8-shuffled`: seed-67/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-67-rules-8-no-catalysis`: seed-67/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-71-rules-8-random`: seed-71/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-71-rules-8-shuffled`: seed-71/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-71-rules-8-no-catalysis`: seed-71/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-73-rules-8-random`: seed-73/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-73-rules-8-shuffled`: seed-73/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-73-rules-8-no-catalysis`: seed-73/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-79-rules-8-random`: seed-79/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-79-rules-8-shuffled`: seed-79/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-79-rules-8-no-catalysis`: seed-79/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-83-rules-8-random`: seed-83/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-83-rules-8-shuffled`: seed-83/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-83-rules-8-no-catalysis`: seed-83/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-89-rules-8-random`: seed-89/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-89-rules-8-shuffled`: seed-89/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-89-rules-8-no-catalysis`: seed-89/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-97-rules-8-random`: seed-97/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-97-rules-8-shuffled`: seed-97/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-97-rules-8-no-catalysis`: seed-97/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-101-rules-8-random`: seed-101/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-101-rules-8-shuffled`: seed-101/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-101-rules-8-no-catalysis`: seed-101/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-103-rules-8-random`: seed-103/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-103-rules-8-shuffled`: seed-103/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-103-rules-8-no-catalysis`: seed-103/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-107-rules-8-random`: seed-107/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-107-rules-8-shuffled`: seed-107/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-107-rules-8-no-catalysis`: seed-107/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-109-rules-8-random`: seed-109/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-109-rules-8-shuffled`: seed-109/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-109-rules-8-no-catalysis`: seed-109/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-113-rules-8-random`: seed-113/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-113-rules-8-shuffled`: seed-113/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-113-rules-8-no-catalysis`: seed-113/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-127-rules-8-random`: seed-127/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-127-rules-8-shuffled`: seed-127/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-127-rules-8-no-catalysis`: seed-127/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-131-rules-8-random`: seed-131/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-131-rules-8-shuffled`: seed-131/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-131-rules-8-no-catalysis`: seed-131/eight-rule factored-template no-catalysis control, active ACS pairs = 0.
- `exp02-seed-137-rules-8-random`: seed-137/eight-rule factored-template generated non-planted random-polymer control, active ACS pairs = 0.
- `exp02-seed-137-rules-8-shuffled`: seed-137/eight-rule factored-template shuffled-catalyst control, active ACS pairs = 0.
- `exp02-seed-137-rules-8-no-catalysis`: seed-137/eight-rule factored-template no-catalysis control, active ACS pairs = 0.

## Sweep-kind active-pair summary

PeTTa `exp02-fold-sweep-kind-summary`, `exp02-sweep-kind-summary`, and `exp02-sweep-kind-summary-report` atoms now separate planted reciprocal-pair controls from generated-unplanted controls while deriving family-record counts, active-family counts, active-pair totals, and active random-polymer points from tested `run-record` lists. The current folded summaries are unchanged scientifically: planted controls have 4/12 family records with active pairs and 7 total active pairs across four random-polymer points; generated-unplanted controls have 0/96 family records with active pairs and 0 total active pairs across seed-19, seed-23, and factored-template seed-29/seed-31/seed-37/seed-41/seed-43/seed-47/seed-53/seed-59/seed-61/seed-67/seed-71/seed-73/seed-79/seed-83/seed-89/seed-97/seed-101/seed-103/seed-107/seed-109/seed-113/seed-127/seed-131/seed-137/seed-139/seed-149/seed-151/seed-157/seed-163/seed-167. The human-readable report rows are now derived from those folded summary atoms. A concise human-readable table is recorded in `SUMMARY.md`.

## Exit status

- `scripts/run_exp02.sh`: `0`

## Conclusion

The small exp02 sweep passed across seed-7/four-rule, seed-11/six-rule, component-generated seed-13/eight-rule, seed-to-component planted seed-17/eight-rule, and seed-to-component non-planted seed-19/seed-23 and factored-template seed-29/seed-31/seed-37/seed-41/seed-43/seed-47/seed-53/seed-59/seed-61/seed-67/seed-71/seed-73/seed-79/seed-83/seed-89/seed-97/seed-101/seed-103/seed-107/seed-109/seed-113/seed-127/seed-131/seed-137/seed-139/seed-149/seed-151/seed-157/seed-163/seed-167 eight-rule parameter points. The planted seed-derived polymer fixtures contain conservative reciprocal product-as-catalyst pairs, while shuffled-catalyst, no-catalysis, and the generated seed-19, seed-23, and seed-29/seed-31/seed-37/seed-41/seed-43/seed-47/seed-53/seed-59/seed-61/seed-67/seed-71/seed-73/seed-79/seed-83/seed-89/seed-97/seed-101/seed-103/seed-107/seed-109/seed-113/seed-127/seed-131/seed-137/seed-139/seed-149/seed-151/seed-157/seed-163/seed-167 non-planted random-polymer controls contain zero active ACS pairs. This validates broader exp02 control/run-record plumbing only; larger less-fixture-like sweeps are still needed before making any spontaneous-ACS claim.

## Serialized run-contract files

After the PeTTa smoke passed, `scripts/write_exp02_contract_files.sh` serializes all ninety tested run-contract records into per-run directories:

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
- `runs/exp02-seed-19-rules-8-random/`
- `runs/exp02-seed-19-rules-8-shuffled/`
- `runs/exp02-seed-19-rules-8-no-catalysis/`
- `runs/exp02-seed-23-rules-8-random/`
- `runs/exp02-seed-23-rules-8-shuffled/`
- `runs/exp02-seed-23-rules-8-no-catalysis/`
- `runs/exp02-seed-29-rules-8-random/`
- `runs/exp02-seed-29-rules-8-shuffled/`
- `runs/exp02-seed-29-rules-8-no-catalysis/`
- `runs/exp02-seed-31-rules-8-random/`
- `runs/exp02-seed-31-rules-8-shuffled/`
- `runs/exp02-seed-31-rules-8-no-catalysis/`
- `runs/exp02-seed-37-rules-8-random/`
- `runs/exp02-seed-37-rules-8-shuffled/`
- `runs/exp02-seed-37-rules-8-no-catalysis/`
- `runs/exp02-seed-41-rules-8-random/`
- `runs/exp02-seed-41-rules-8-shuffled/`
- `runs/exp02-seed-41-rules-8-no-catalysis/`
- `runs/exp02-seed-43-rules-8-random/`
- `runs/exp02-seed-43-rules-8-shuffled/`
- `runs/exp02-seed-43-rules-8-no-catalysis/`
- `runs/exp02-seed-47-rules-8-random/`
- `runs/exp02-seed-47-rules-8-shuffled/`
- `runs/exp02-seed-47-rules-8-no-catalysis/`
- `runs/exp02-seed-53-rules-8-random/`
- `runs/exp02-seed-53-rules-8-shuffled/`
- `runs/exp02-seed-53-rules-8-no-catalysis/`
- `runs/exp02-seed-59-rules-8-random/`
- `runs/exp02-seed-59-rules-8-shuffled/`
- `runs/exp02-seed-59-rules-8-no-catalysis/`
- `runs/exp02-seed-61-rules-8-random/`
- `runs/exp02-seed-61-rules-8-shuffled/`
- `runs/exp02-seed-61-rules-8-no-catalysis/`
- `runs/exp02-seed-67-rules-8-random/`
- `runs/exp02-seed-67-rules-8-shuffled/`
- `runs/exp02-seed-67-rules-8-no-catalysis/`
- `runs/exp02-seed-71-rules-8-random/`
- `runs/exp02-seed-71-rules-8-shuffled/`
- `runs/exp02-seed-71-rules-8-no-catalysis/`
- `runs/exp02-seed-73-rules-8-random/`
- `runs/exp02-seed-73-rules-8-shuffled/`
- `runs/exp02-seed-73-rules-8-no-catalysis/`
- `runs/exp02-seed-79-rules-8-random/`
- `runs/exp02-seed-79-rules-8-shuffled/`
- `runs/exp02-seed-79-rules-8-no-catalysis/`
- `runs/exp02-seed-83-rules-8-random/`
- `runs/exp02-seed-83-rules-8-shuffled/`
- `runs/exp02-seed-83-rules-8-no-catalysis/`
- `runs/exp02-seed-89-rules-8-random/`
- `runs/exp02-seed-89-rules-8-shuffled/`
- `runs/exp02-seed-89-rules-8-no-catalysis/`
- `runs/exp02-seed-97-rules-8-random/`
- `runs/exp02-seed-97-rules-8-shuffled/`
- `runs/exp02-seed-97-rules-8-no-catalysis/`
- `runs/exp02-seed-101-rules-8-random/`
- `runs/exp02-seed-101-rules-8-shuffled/`
- `runs/exp02-seed-101-rules-8-no-catalysis/`
- `runs/exp02-seed-103-rules-8-random/`
- `runs/exp02-seed-103-rules-8-shuffled/`
- `runs/exp02-seed-103-rules-8-no-catalysis/`
- `runs/exp02-seed-107-rules-8-random/`
- `runs/exp02-seed-107-rules-8-shuffled/`
- `runs/exp02-seed-107-rules-8-no-catalysis/`
- `runs/exp02-seed-109-rules-8-random/`
- `runs/exp02-seed-109-rules-8-shuffled/`
- `runs/exp02-seed-109-rules-8-no-catalysis/`
- `runs/exp02-seed-113-rules-8-random/`
- `runs/exp02-seed-113-rules-8-shuffled/`
- `runs/exp02-seed-113-rules-8-no-catalysis/`
- `runs/exp02-seed-127-rules-8-random/`
- `runs/exp02-seed-127-rules-8-shuffled/`
- `runs/exp02-seed-127-rules-8-no-catalysis/`
- `runs/exp02-seed-131-rules-8-random/`
- `runs/exp02-seed-131-rules-8-shuffled/`
- `runs/exp02-seed-131-rules-8-no-catalysis/`
- `runs/exp02-seed-137-rules-8-random/`
- `runs/exp02-seed-137-rules-8-shuffled/`
- `runs/exp02-seed-137-rules-8-no-catalysis/`
- `runs/exp02-seed-139-rules-8-random/`
- `runs/exp02-seed-139-rules-8-shuffled/`
- `runs/exp02-seed-139-rules-8-no-catalysis/`
- `runs/exp02-seed-149-rules-8-random/`
- `runs/exp02-seed-149-rules-8-shuffled/`
- `runs/exp02-seed-149-rules-8-no-catalysis/`
- `runs/exp02-seed-151-rules-8-random/`
- `runs/exp02-seed-151-rules-8-shuffled/`
- `runs/exp02-seed-151-rules-8-no-catalysis/`
- `runs/exp02-seed-157-rules-8-random/`
- `runs/exp02-seed-157-rules-8-shuffled/`
- `runs/exp02-seed-157-rules-8-no-catalysis/`
- `runs/exp02-seed-163-rules-8-random/`
- `runs/exp02-seed-163-rules-8-shuffled/`
- `runs/exp02-seed-163-rules-8-no-catalysis/`
- `runs/exp02-seed-167-rules-8-random/`
- `runs/exp02-seed-167-rules-8-shuffled/`
- `runs/exp02-seed-167-rules-8-no-catalysis/`

Each directory follows the v0.1 file convention: `CONFIG.metta`, `MANIFEST.metta`, `EVENTS.metta`, `ABUNDANCES.metta`, `METRICS.metta`, `ACS.metta`, `ABLATIONS.metta`, and `SUMMARY.metta`. The host script only serializes atoms already represented/tested in PeTTa; chemistry and ACS detection remain in `.metta` files.

- 2026-07-04: Added factored-template generated-unplanted seed-131/eight-rule random-polymer, shuffled-catalyst, and no-catalysis records through the PeTTa token/product seam. Conservative reciprocal scanner remains zero-active for all three families; generated-unplanted folded summaries are now 0/75 family records with 0 active pairs, and serialization/testing covers eighty-seven records.

- 2026-07-04: Added factored-template generated-unplanted seed-137/eight-rule random-polymer, shuffled-catalyst, and no-catalysis records through the PeTTa token/product seam. Conservative reciprocal scanner remains zero-active for all three families; generated-unplanted folded summaries are now 0/78 family records with 0 active pairs, and serialization/testing covers ninety records.
- 2026-07-04: Added factored-template generated-unplanted seed-139/eight-rule random-polymer, shuffled-catalyst, and no-catalysis records through the PeTTa token/product seam. Conservative reciprocal scanner remains zero-active for all three families; generated-unplanted folded summaries are now 0/81 family records with 0 active pairs, and serialization/testing covers ninety-three records.

- 2026-07-04: Added factored-template generated-unplanted seed-149/eight-rule random-polymer, shuffled-catalyst, and no-catalysis records through the PeTTa token/product seam. Conservative reciprocal scanner remains zero-active for all three families; generated-unplanted folded summaries are now 0/84 family records with 0 active pairs, and serialization/testing covers ninety-six records.

- 2026-07-04: Added factored-template generated-unplanted seed-151/eight-rule random-polymer, shuffled-catalyst, and no-catalysis records through the PeTTa token/product seam. Conservative reciprocal scanner remains zero-active for all three families; generated-unplanted folded summaries are now 0/87 family records with 0 active pairs, and serialization/testing covers ninety-nine records.

- 2026-07-04: Added factored-template generated-unplanted seed-157/eight-rule random-polymer, shuffled-catalyst, and no-catalysis records through the PeTTa token/product seam. Conservative reciprocal scanner remains zero-active for all three families; generated-unplanted folded summaries are now 0/90 family records with 0 active pairs, and serialization/testing covers one hundred two records.

- 2026-07-04: Added factored-template generated-unplanted seed-163/eight-rule random-polymer, shuffled-catalyst, and no-catalysis records through the PeTTa token/product seam. Conservative reciprocal scanner remains zero-active for all three families; generated-unplanted folded summaries are now 0/93 family records with 0 active pairs, and serialization/testing covers one hundred five records.
- 2026-07-04: Added factored-template generated-unplanted seed-167/eight-rule random-polymer, shuffled-catalyst, and no-catalysis records through the PeTTa token/product seam. Conservative reciprocal scanner remains zero-active for all three families; generated-unplanted folded summaries are now 0/96 family records with 0 active pairs, and serialization/testing covers one hundred eight records.
