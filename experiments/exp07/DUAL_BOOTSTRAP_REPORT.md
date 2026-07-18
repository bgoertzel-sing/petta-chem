# exp07 Dual-Bootstrap Frozen Matrix Report

Executed once on 2026-07-18 with the local PeTTa/SWI stack under the exact
`PREREG_DUAL_BOOTSTRAP.md` contract. No seed, tick, pool, selector, threshold,
or endpoint was extended after outcome access. The chemistry, state evolution,
selection, detector, replay, and ablations execute in PeTTa; Python was not
used.

## Registered result

The result is negative. Rolling last-twelve-productive-event RAF incidence was
13/32 unguided, 9/32 weak Doob-h, and 0/32 shuffled-frontier guidance. Weak
therefore did not exceed either control by the required ten seeds and
underperformed unguided. Guiding-term removal retained unguided incidence of
13/32, above the allowed maximum of four. This does not support bounded guided
causal RAF uplift and makes no spontaneous-emergence claim.

All 96 trajectories replayed exactly. Removing either bootstrap, all four
cycle-catalyst edges, or any individual `dp1/dp2/dp3/dp0` rule reduced weak-arm
incidence to 0/32. The chemistry is structurally dependent on the complete
six-step pathway, but the observed closure is not guidance-caused.

## Frozen endpoints

- First-hit ticks (99 means no hit):
  - unguided: `[99,99,99,99,27,99,99,31,30,99,99,21,30,29,99,99,99,29,28,99,99,29,28,99,23,99,99,27,99,22,99,99]`
  - weak: `[99,99,99,30,29,99,99,33,99,99,99,26,99,99,99,99,99,31,99,29,99,99,30,99,99,27,99,29,99,99,99,99]`
  - shuffled: all 32 values are 99.
- Longest positive persistence:
  - unguided: `[0,0,0,0,8,0,0,4,5,0,0,12,5,6,0,0,0,6,7,0,0,6,7,0,12,0,0,8,0,9,0,0]` (total 95)
  - weak: `[0,0,0,5,6,0,0,2,0,0,0,9,0,0,0,0,0,4,0,6,0,0,5,0,0,8,0,6,0,0,0,0]` (total 51)
  - shuffled: all zero (total 0).
- Productive-event totals: unguided 549, weak 523, shuffled 396.
- Terminal rule diversity totals: unguided 336, weak 278, shuffled 219.
  - unguided per seed: `[11,10,10,10,11,10,9,12,11,8,10,12,12,10,9,11,10,12,11,9,11,11,12,11,10,10,8,11,10,12,11,11]`
  - weak per seed: `[10,7,9,9,8,10,9,10,9,6,9,9,9,9,6,10,9,10,9,8,8,8,10,10,7,10,8,8,9,8,10,7]`
  - shuffled per seed: `[7,6,7,7,7,8,7,6,8,6,7,7,7,7,6,8,7,6,7,7,7,7,7,7,5,8,7,6,7,7,7,6]`
- Exact replay: 32/32 in every arm.
- Matched intervention cost: 8,192 shifted mass units in each guided arm;
  unguided cost 0.
- Causal incidence after intervention: guiding-term removal 13/32; `db0`
  ablation 0/32; `db1` ablation 0/32; all-cycle-catalyst ablation 0/32; each
  individual `dp1`, `dp2`, `dp3`, and `dp0` ablation 0/32.

Reproduce the complete PeTTa report from the repository root with:

```bash
scripts/run_exp07_dual_report.sh
```
