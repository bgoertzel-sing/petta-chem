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
scripts/run_exp04.sh
scripts/run_exp04_first_class_catalysis.sh
scripts/run_exp05.sh
scripts/run_exp06.sh
scripts/test_exp06_bridge_path_files.sh
scripts/run_exp07.sh
```

`experiments/exp00/smoke.metta` is a deliberately tiny deterministic chemistry spike. It establishes initial molecule/rule/state/candidate/candidate-pool/candidate-cap/event/chamber/metric atom contracts plus a generic bounded binary catalytic transition, candidate applicability checks, nonnegative abundance invariants, chamber-rule-based candidate generation, per-tick candidate caps, and a seed/tick deterministic candidate selector wired directly from bounded generated or externally scored candidate pools into chamber ticking before larger stochastic/harness work is added.

`experiments/exp01/smoke.metta` validates the first planted ACS recovery seam: a two-rule catalytic closure is recovered from a rule list with distractors, non-catalytic cycles are rejected, and single-rule ablation produces a productivity drop derived from replayed PeTTa productivity traces. It also validates a 3-rule catalytic cycle scanner (`product-catalyst-closed-3?`, `scan-rule-triple`, `scan-rule-triples-4`) that generalizes RAF-like closure detection beyond pairs to triples, with a planted 3-cycle fixture and distractor rejection tests.

`experiments/run_contract/smoke.metta` defines the version-0.1 consequential-run output contract in PeTTa-shaped atoms before exp02 sweeps: config, manifest/provenance, events, abundance snapshots, metrics, ACS candidates, ablations, and summary/replay status.

`experiments/exp02/smoke.metta` runs the first systematic deterministic random-polymer control sweep in PeTTa: seed-7/four-rule, seed-11/six-rule, component-generated seed-13/eight-rule, seed-to-component seed-17/eight-rule, generated non-planted seed-19/seed-23, and factored-template seed-29/seed-31/seed-37/seed-41/seed-43/seed-47/seed-53/seed-59/seed-61/seed-67/seed-71/seed-73/seed-79/seed-83/seed-89/seed-97/seed-101/seed-103/seed-107/seed-109/seed-113/seed-127/seed-131/seed-137/seed-139/seed-149/seed-151/seed-157/seed-163/seed-167/seed-173/seed-179/seed-181/seed-191 eight-rule points are represented as explicit `exp02-sweep-point` atoms, compared with shuffled-catalyst and no-catalysis controls, scanned by the conservative ACS detector, recorded as run-contract records, and summarized by tested `exp02-sweep-kind-summary-report` atoms whose rows derive from folded run-record summaries.

`scripts/write_exp02_contract_files.sh` is a thin host harness that serializes all one hundred twenty PeTTa-tested exp02 run-contract records into the v0.1 per-run file convention under `experiments/exp02_small_sweep_20260630/runs/`; it does not drive chemistry logic.

`experiments/exp03/smoke.metta` adds deterministic multi-tick soup dynamics over exp00 contracts: a bounded chamber runner accumulates events across ticks, advances through blocked/no-op steps, exercises a selectable two-rule pool with one productive rule and one distractor, and includes exp02-style random/shuffled/no-catalysis dynamic bridges where random families produce events while controls remain no-op. The seed-11 bridge is recorded in v0.1 run-contract atoms; seed-7/four-rule and seed-13/seed-17 eight-rule full-source chambers keep all source rules visible while candidate caps bound ticking to the deterministic two-candidate selector with replay checks, run-export projections, and a compact dynamic aggregate report over the tested full-source exports. Cap-4 rich bridge smoke tests now cover seed-7, seed-11, seed-13, and seed-17 multi-rule productive state shapes; cap-5 seed-11 smoke runs 15 ticks with five bounded candidates, run-records, replay, and controls; cap-6, cap-7, and cap-8 smoke include productive bridges over fixed multi-tick runs with bounded full-source candidate selection. PeTTa-side run-export and run-file-bundle query hooks expose productive cap fixture config, manifest, events, abundance snapshots, metrics, ACS candidates, ablations, and summaries without host-side chemistry logic, and the thin artifact writer covers cap-5/cap-6/cap-7/cap-8 productive-cap bundles.

`experiments/exp04/smoke.metta` is a deliberately success-biased rich RAF fixture over ligation, cleavage, and modification templates. Its RAF checks now consume an explicit binary PeTTa `(catalyzes Molecule RuleId)` relation; `experiments/exp04/run_rich_raf.py` loads those materialized PeTTa facts rather than reconstructing catalysis from molecule names, and empty-relation ablation uses the identical closure path. `scripts/run_exp04_first_class_catalysis.sh` validates the 18-edge relation and reproduces maximal RAF 15, core 2 (`lCD`, `lBCD2`), and ablation 0. `experiments/exp04/run_reduction_sweep.py` is a host-side reduction harness that compares hand-designed versus mechanically generated rule pools under specificity-filtered, broad, shuffled, and no-catalysis modes plus different basal intervals; it writes `experiments/exp04_reduction_sweep_20260708/` via `scripts/run_exp04_reduction_sweep.sh`. `scripts/write_exp04_offset_report_files.sh` is a thin host harness that serializes the PeTTa-tested offset-sensitivity report bundle into `OFFSET_SENSITIVITY_REPORT.metta`, `SUMMARY.metta`, and `RUN.md` without driving chemistry logic.

`experiments/exp05/smoke.metta` starts a soft-biased ecological autocatalysis scaffold in PeTTa. It assigns catalysts from generic token-overlap affinity with a positive baseline and a rotated-weight control, then projects assigned source rules into ordinary exp00 `candidate`/`candidate-pool` atoms so bounded caps can be reused by later chamber-ticking slices. It is plumbing only: no RAF scan or emergence claim is made.

`experiments/exp06/smoke.metta` starts the bridge-to-ACS favorable-conditions analysis. It names an ACS-negative exp04 no-catalysis source row, the exp04 RAF-rich terminal row/core, intervention variables spanning exp05 affinity assignment, basal replenishment, candidate-pool cap, and catalysis-map offset, plus a first deterministic one-step shortest-path witness. It also exposes a bounded cost/path-search table over these variables and candidate-cap dynamic probes: cap-1 and cap-2 both feed the exp05 affinity-assigned treatment and rotated-control pools through ordinary exp00 chamber ticking for matched productive first ticks, and a refreshed tick-4 sweep shows cap-2 deterministically exposing the second source rule while cap-1 stays pinned to the first. A stateful sweep now carries tick-3 output into ticks 4 and 5, showing cap-1 repeating `e5r0`, cap-2 exposing `e5r1`, and then both arms hitting a bounded no-op tick after A is exhausted. The current boundary scan checks the selected tick-3/tick-4 rule pairs for two-rule product-catalyst closure and rejects both cap arms; this is an ACS boundary diagnostic, not RAF enumeration or spontaneous-emergence evidence. `scripts/write_exp06_bridge_path_files.sh` is a thin host-side Dijkstra/bookkeeping harness that queries those PeTTa-exposed rows and serializes CONFIG, NODE_EVALUATIONS, PATHS, SUMMARY, and RUN.md artifacts without implementing chemistry.

`experiments/exp07/smoke.metta` frames the bridge/Doob diagnostic family and executes the frozen rich shared-pool ensemble. A PeTTa-native 24-tick constructor regenerates the exact cap-8 pool at each tick, applies scheduled food resets at ticks 11 and 19, advances blocked draws, and preserves event history for exact replay. Across seeds 11--18, rolling eight-event three-rule RAF incidence is 5/8 unguided, 7/8 weak Doob-h, and 3/8 shuffled guidance; completed persistence, diversity, matched-cost, and causal-ablation endpoints show that the cycle is structurally necessary but guidance is not. The ordered-bootstrap successor uses held-out seeds 19--26 and executable PeTTa-local cap-8 generation, applicability, state-aware selection, and firing across ticks 3--26. Its corrected ordered-cycle result is 0/8 unguided, 6/8 weak Doob-h, and 0/8 shuffled; all 24 trajectories replay, persistence totals are 0/41/0, and every prespecified guidance/bootstrap/catalyst/rule ablation collapses the weak result. This supports bounded guided causal RAF uplift, not spontaneous emergence.
