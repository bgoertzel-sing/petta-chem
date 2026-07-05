# exp02 — random polymer controls

First systematic deterministic exp02 sweep.  The PeTTa kernel defines explicit `exp02-sweep-point` atoms for seed-7/four rules, seed-11/six rules, component-generated seed-13/eight rules, seed-to-component seed-17/eight rules, and seed-to-component generated non-planted seed-19/seed-23 points plus factored-template seed-29/seed-31/seed-37/seed-41/seed-43/seed-47/seed-53/seed-59/seed-61/seed-67/seed-71/seed-73/seed-79/seed-83/seed-89/seed-97/seed-101/seed-103/seed-107/seed-109/seed-113/seed-127/seed-131/seed-137/seed-139/seed-149/seed-151/seed-157/seed-163/seed-167/seed-173/seed-179 eight-rule points. It compares each with two controls (shuffled catalysts and no catalysis), scans all rule pairs with the conservative exp01 ACS scanner, records each run in the v0.1 run-contract atom shape, and now folds sweep-kind summaries from tested run-record lists and derives report rows from those summaries rather than hand-maintaining active-pair totals.

This is a plumbing/control smoke test, not an emergence claim. Seeds 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, and 163 are intentionally generated negative-control points with zero active reciprocal pairs in every family, beginning the separation between planted-by-seed reciprocal-pair controls and broader generated sweeps.

Run:

```bash
scripts/run_exp02.sh
```
