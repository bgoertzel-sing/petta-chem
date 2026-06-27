# exp00 deterministic smoke

Purpose: establish the smallest executable PeTTa-native chemistry kernel shape before stochastic sampling or larger ACS detection.

This is not yet an emergence experiment. It is a deterministic replay test:

```text
A + B --Cat--> AB
```

Expected state transition:

```metta
(state 0 seed-7 (mol A 1) (mol B 1) (mol AB 0) (mol Cat 1))
=>
(state 1 seed-7 (mol A 0) (mol B 0) (mol AB 1) (mol Cat 1))
(event 0 r0 A B AB Cat)
```

Run:

```bash
scripts/run_exp00.sh
```

Passing this smoke means the repo has a working PeTTa runtime path and first atom contracts. It does **not** claim ACS emergence.
