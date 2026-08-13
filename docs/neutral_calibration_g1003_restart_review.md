# Neutral calibration graph-1003 stopped-lifecycle restart review

Status: separately reviewed and resumed; raw outcomes embargoed

Date: 2026-08-12

Attempt: `neutral-v2-g1003-a001`

## Reviewed restart boundary

The stopped attempt was preserved through review. Receipts 0 through 72 were
exactly contiguous, zero-exit, and mechanically query/stdout/stderr
SHA-256-valid against the frozen 276-row manifest. Row 73 had the only
unreceipted raw pair. `FAILED.json` and `RUN_MANIFEST.json` were absent, and no
tmux session, v2 runner, or PeTTa child was live. No endpoint content was
opened or interpreted.

The source manifest, neutral SSA and RAF sources, v2 runner, PeTTa commit and
entrypoints, SWI-Prolog 9.3.36 runtime, and absent-MORK identity all matched
the graph-1003 launch review. The focused durable-v2 synthetic gate, all nine
independent RAF-oracle fixtures, and `git diff --check` passed.

## Restart action and stop rule

The exact reviewed graph-1003 command restarted the same attempt and attempt
ID at the receipt boundary. The v2 runner quarantined only row 73's
unreceipted stdout/stderr pair and resumed at row 73. Initial lifecycle
metadata showed the tmux session, runner, and PeTTa child live, with no failure
or completion manifest.

Continue metadata-only monitoring. Preserve the attempt at
`raw-complete-unanalysed`; do not inspect endpoint content or run partial
analysis. Any identity mismatch, receipt/hash gap, nonzero exit, or unexpected
artifact freezes the attempt for another separate review.

## Second stopped-lifecycle review

At 2026-08-12 12:33 PDT, a second separate review found receipts 0 through 159
exactly contiguous, zero-exit, and mechanically query/stdout/stderr
SHA-256-valid. Row 160 had the sole unreceipted raw pair. Frozen identities
matched, no lifecycle process or terminal manifest existed, and the focused
durable-v2 synthetic gate, all nine RAF-oracle tests, and `git diff --check`
passed. No endpoint content was opened.

The same reviewed command resumed the same attempt at row 160, quarantining
only its unreceipted pair. Tmux, runner, and PeTTa child were live at handoff.
The original stop rule remains binding.

## Third stopped-lifecycle review

At 2026-08-13 00:41 PDT, a third separate review found receipts 0 through 193
exactly contiguous, zero-exit, and mechanically query/stdout/stderr
SHA-256-valid. There was no unreceipted raw pair. Frozen identities matched,
no lifecycle process or terminal manifest existed, and the focused durable-v2
synthetic gate, all nine RAF-oracle tests, and `git diff --check` passed. No
endpoint content was opened.

The same reviewed command resumed the same attempt at row 194 without
quarantining any artifact. Tmux, runner, and PeTTa child were live at handoff.
The original stop rule remains binding.
