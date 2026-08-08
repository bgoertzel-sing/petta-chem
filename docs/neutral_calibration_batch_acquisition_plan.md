# Neutral calibration complete-batch acquisition plan

Status: frozen preparation gate; remaining chemistry not launched

Date: 2026-08-07

Plan version: `neutral-calibration-batch-acquisition-v1`

## Purpose and boundary

The frozen analysis requires 32 graph-seed-complete shards (1001 through
1032), but only graph seed 1001 currently has a receipt-validated v2
`raw-complete-unanalysed` attempt. This plan closes the preparation ambiguity
without authorizing endpoint inspection, partial analysis, or a sampled
emergence claim.

The unresolved `experiments/exp08/`, `experiments/scratch_cat.metta`, and
`src/chem_catalysis.metta` remain outside this work. No candidate/source-list,
arity, guidance, Doob, or constructed-pathway work is authorized.

## Complete-batch preparation gate

Before another shard is launched, generate all 32 query manifests from the
unchanged frozen ledger using `prepare_neutral_calibration_queries.py` in a
clean staging root. Preparation passes only when:

- seeds are exactly 1001--1032, once each;
- every manifest is `prepared-unrun`, contains 276 rows, and declares
  `endpoint_results_present=false`;
- the union is exactly 8,832 unique keys
  `(cohort,L,f_twice,volume,graph_seed,dynamics_seed)`;
- every query imports the tracked neutral PeTTa source and invokes only
  `neutral-ssa-run-calibration-row`; and
- an out-of-ledger seed is rejected.

The synthetic batch test exercises this contract without opening or executing
any calibration endpoint.

## Execution and preservation rule

Each remaining graph seed must use its own v2 attempt directory, attempt ID,
log, receipts, and completion manifest. The runner/runtime/source identities
must equal the reviewed graph-1001 identities unless a new identity review is
committed first. Run at most one shard at a time on the local machine; finish
and validate its receipt metadata before starting the next. A stopped shard
may resume only its exact receipt-validated prefix under the existing v2
recovery rule.

Completion of any individual shard authorizes preservation only. Raw stdout
must remain unopened until all 32 shards are complete and a separate real-
adapter authorization passes the batch metadata preflight. No partial-seed or
partial-control-point summaries may be emitted.

## Next gate

After this plan and the complete-batch synthetic preparation test pass, a
separate reviewed action may materialize the missing prepared manifests and
launch graph seed 1002. It must stop at `raw-complete-unanalysed` and report
metadata only. This plan itself launches no chemistry.
