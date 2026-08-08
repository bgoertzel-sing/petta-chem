# Neutral calibration graph-1002 launch review

Status: materialized and launched; raw outcomes embargoed

Date: 2026-08-07

Plan version: `neutral-calibration-v2-g1002-attempt-001`

## Reviewed boundary

This action materialized only the frozen outcome-blind query shard for
`graph_seed=1002` and launched one isolated v2 attempt. It did not open any
raw stdout or stderr, parse an endpoint, analyze a partial batch, or touch the
frozen exp08, scratch-catalysis, or constructed-pathway material.

The prepared manifest has SHA-256
`eed88a91ee92d48b902cc248c5f993334c18c2ff1b7af4834ff1c51f862bf242`.
It declares `prepared-unrun`, `endpoint_results_present=false`, 276 contiguous
rows, and 276 unique frozen row keys. Every query imports only the tracked
neutral SSA source and calls `neutral-ssa-run-calibration-row` once.

## Identity review

The launch recomputed and matched the graph-1001 reviewed identities:

- neutral SSA: `ebdcf0449bd783cab6c924f1c455d51141d1d74ff59251237a5e7596908f2ca3`;
- neutral RAF: `0ed75203fff2b9d31c0dac054290aeb5c29fac890ddcda13be6af528c0b26073`;
- v2 runner: `423e2862d650389057bd4f7fdd0821d6666fa75fcc57a2a9a13dc0080fe8d09d`;
- PeTTa commit: `4ce1d0ea58855abb772b911278312c8846e5cc08`;
- PeTTa `run.sh`: `b0ee9930c7fbca5d221ff2e31a7cce30bc8e8902f463c5f80be2a971414e3aae`;
- PeTTa `src/main.pl`: `cc381df25e778edd0a355ef945a9675f7f3d79ebd5fc5124a2d67bf8d02bc99c`;
- SWI-Prolog: `9.3.36` for `x86_64-linux`; MORK FFI absent.

The focused query-preparation and durable-v2-runner synthetic gates and the
independent RAF-oracle fixtures passed before launch.

## Attempt and stop rule

Attempt `neutral-v2-g1002-a001` runs in tmux session
`petta-neutral-v2-g1002-a001`, using
`experiments/neutral_calibration_v2/graph-seed-1002/attempt-001`. Initial
metadata inspection found the v2 runner and PeTTa child live, a valid
`ATTEMPT.json`, and zero receipts at the start of row zero.

Monitor metadata only. Preserve the attempt at
`raw-complete-unanalysed`; do not inspect any endpoint until every graph seed
1001--1032 is receipt-complete and a separate real-adapter authorization
passes. Any identity mismatch, receipt/hash gap, nonzero exit, or unexpected
artifact freezes this attempt for review.
