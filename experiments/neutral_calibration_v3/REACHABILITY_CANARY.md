# Neutral calibration v3 - reachability known-answer canary

Date: 2026-10-13 (America/Vancouver).  Authority: Ben Goertzel, Telegram msg
7901 (task step 3; sanity-gate rule 1, docs/EXPERIMENT_SANITY_GATE.md).

## Verdict: **POSITIVE CANARY FAILS -> probable bug in the SSA event sampler.  Pilot NOT relaunched.**

The reachability summary function itself is correct (direct known-answer test
below passes).  The failure is upstream of it: the SSA event-selection and
waiting-time "draws" are arithmetic progressions in the event index, not
pseudo-random numbers, so the simulated trajectory is a slow deterministic
sweep over the cumulative propensity list.  An obviously self-sustaining,
food-catalysed RAF whose first reaction carries 77% of the total propensity
at t=0 fires that reaction **once** in 1,338 events over T=500, and four
different dynamics seeds give nearly identical trajectories.  This is a
property of the frozen model source (identical on 6a5c0c1c and on the speedup
source), not of the v3 fixes or of the speedup.

## Network (hand-made, batch atom formats)

- food = frozen six-food set ("0" "1" "00" "01" "10" "11"); molecules =
  `(neutral-ssa-binary-polymers 4)` (30 species, so influx/dilution structure is
  the batch one); V=100 (20 copies of each food at t=0), T=500.0, event bound
  1,000,000, burn-in 100.0, bin width 10.0, 40 bins, threshold 32, dynamics
  seed 2001 (the batch's first dynamics seed).
- R1 `(ligation "lig:00:1" "00" "1" "001")` catalysed by food "0".
- R2 `(ligation "lig:001:0" "001" "0" "0010")` catalysed by "001" (R1 product).
- Catalysis `(("0" "lig:00:1") ("001" "lig:001:0"))`.

{R1, R2} is a catalysed, food-generated RAF.  At t=0 R1's weight is
400 * (100 + 100000*20) = 800,040,000 out of a total of 1,040,040,000 (77%).
Under a correct Gillespie sampler R1 fires within the first few events and the
RAF is reached (both rules fired, all closure molecules positive) at t << 1.

## Path (harness differences documented)

`queries/new-*.metta`: imports chem_neutral_raf.metta then chem_neutral_ssa.metta
(speedup worktree source) and defines `canary-row`, which mirrors
`neutral-ssa-run-calibration-row` step for step (maximal RAF via
`neutral-raf-maximal-reactions` -> `neutral-raf-reaction-ids` ->
`neutral-ssa-run-selected-raf-endpoints`, i.e. the same SSA, ablation pair,
`neutral-ssa-ablation-pair-endpoints` and `neutral-ssa-raf-reachability-summary`
used by every batch row).  Only difference: reactions/catalysis are hand-made
instead of generated from (L, graph-seed, f).
`queries/old-*.metta`: same on the 6a5c0c1c source; since the old pair
function re-samples catalysis from graph-seed, its body is inlined verbatim
with the hand catalysis.  Run with the exact batch command (`run_canary.sh`:
nice -n 10, taskset -c 1-7, SWI-Prolog 9.3.36, PeTTa-pinned-4ce1d0ea run.sh).

## Results (`out/`)

| canary | expected | observed baseline reachability | ablated | old == new |
|---|---|---|---|---|
| positive (T=500, 1e6 events) | reachable true, small finite first-time | **reachable false / censored** (raf-events 0, integrated-nonfood 4.01) | false / censored | byte-identical |
| negative: event bound 0 | false / censored | false / censored | false / censored | byte-identical |
| negative: T = 1e-6 (horizon before first event) | false / censored | false / censored | false / censored | byte-identical |

Maximal RAF detected correctly in all cases: `("lig:00:1" "lig:001:0")`,
closure `("0010" "001" "0" "1" "00" "01" "10" "11")`.

Direct known-answer test of the summary function (`queries_unit/summary_known_answer.metta`,
hand-written valid trajectory R1@0.5, R2@0.7, R1@1.25):

| input | expected | observed |
|---|---|---|
| all three transitions | reachable true first-time 1.25 | **reachable true first-time 1.25** |
| truncated after R2 ("001" = 0) | false / censored | false / censored |
| only R1 | false / censored | false / censored |

So `neutral-ssa-raf-reachability-summary` (incl. the empty-RAF guard) behaves as
specified; the canary fails because the simulated dynamics never produce a
trajectory that reaches the RAF.

## Diagnosis evidence (`debug/`)

`debug/debug_event_histogram.metta` runs `neutral-ssa-run-until` for the positive
network with dynamics seeds 2001-2004:

| seed | events | R1 fires | R2 fires | influx "00" | influx "1" | final "0" | final "1","00" |
|---|---|---|---|---|---|---|---|
| 2001 | 1338 | 1 | 1 | 0 | 0 | 70 | 0, 0 |
| 2002 | 1337 | 1 | 1 | 0 | 0 | 69 | 0, 0 |
| 2003 | 1335 | 1 | 1 | 0 | 0 | 69 | 0, 0 |
| 2004 | 1328 | 1 | 1 | 0 | 0 | 70 | 0, 0 |

Event-type histograms are nearly identical across seeds (e.g. seed 2001:
dilution "11" 308, influx "0" 307, influx "11" 288, dilution "0" 256 ...), and the
event stream consists of long runs of one event (49 x influx "10", then 288 x
influx "11", 288 x dilution "11", then alternating influx "0" / dilution "11").
Influx of "00" and "1" (each 1/6 of influx propensity) never occurs in 1,338
events.  `debug/debug_positive.metta` shows the first 20+ draws are all
`(influx "10")` with waiting-uniform numerators 438717, 504254, 569791, ...
(step 65537).

Source (src/chem_neutral_ssa.metta, unchanged since v1):

    (= (neutral-ssa-event-draw $seed $event-index $total)
       (#mod (+ (* $seed 48271) (* $event-index 69621)) $total))
    (= (neutral-ssa-waiting-uniform-numerator $seed $event-index)
       (+ 1 (#mod (+ (+ (* $seed 40699) (* $event-index 65537)) 17) 1000000)))

The event threshold advances by a constant 69,621 per event modulo the total
weight (here ~1.04e9, i.e. ~6.7e-5 of the range per event, ~15,000 events per
sweep of the cumulative list); successive seeds shift the start by only 48,271.
The waiting-time uniform is a sawtooth with period ~15.3 events.  For full L5
batch systems the total weights are larger still (catalysed terms carry a
100000 x catalyst-count factor), so the relative step is even smaller.
(Analytic statement only; no batch row outcomes were inspected.)

## Diagnostic confirmation (NOT a proposed model; `diagnostic_mixing_sampler/`)

A scratch copy of the speedup SSA source with ONLY `neutral-ssa-event-draw` and
`neutral-ssa-waiting-uniform-numerator` replaced by a nonlinear
quadratic-congruential mix of (seed, index) (`chem_neutral_ssa_DIAGNOSTIC_mixing.metta`;
everything else, incl. the RAF/reachability/causal code, unchanged) gives, for
the same positive canary query:

| arm | reachability | raf-events | evidence-bins | integrated-nonfood |
|---|---|---|---|---|
| baseline | **reachable true, first-time 2.199** | 113 | 39 | 7263.65 |
| ablated (catalysis into RAF deleted) | false / censored | 0 | 0 | 0.0 |

i.e. exactly the qualitative known answer (fast reachability with catalysis,
none without).  This isolates the failure to the two draw functions.  The mix
used here is only a diagnostic; choosing the real replacement (and its
statistical checks) is a model decision for Ben.

## Consequence / decision needed

- Every dynamic endpoint (reachability, persistence/raf-events, evidence bins,
  integrated nonfood, causal delta) in v1, v2 and v3 rows is produced by this
  sampler.  The structural maximal-RAF field is unaffected.
- Per the task brief, the pilot was **not** relaunched on the speedup source.
  The running pilot (attempt-001, 6a5c0c1c) was left untouched; whether to stop
  it is Ben's call (it is computing dynamics with the same sampler).
- A fix (e.g. a proper keyed PRNG such as a chained LCG/xorshift state or a
  nonlinear hash of (seed, index)) is a **model change**: it changes every
  dynamic endpoint and needs Ben's approval, a protocol amendment and new
  canaries (this positive canary must then report reachable true).
- Secondary, not yet assessed: `neutral-ssa-catalysis-draw` is likewise linear
  in (graph-seed, molecule-index, reaction-index) modulo 2|R|, so sampled
  catalysis graphs are lattice-structured rather than independent Bernoulli
  draws; worth reviewing together with the sampler.
