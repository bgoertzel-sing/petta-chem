# exp02 — random polymer controls

First systematic deterministic exp02 sweep.  The PeTTa kernel defines explicit `exp02-sweep-point` atoms for seed-7/four rules, seed-11/six rules, and a component-generated seed-13/eight-rule family, compares each with two controls (shuffled catalysts and no catalysis), scans all rule pairs with the conservative exp01 ACS scanner, and records each run in the v0.1 run-contract atom shape.

This is a plumbing/control smoke test, not an emergence claim.

Run:

```bash
scripts/run_exp02.sh
```
