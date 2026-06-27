# Runtime decision: PeTTa on SWI-Prolog 9.3.x

Date: 2026-06-26
Status: accepted for version 0.1

## Decision

`petta-chem` version 0.1 uses the PeTTa implementation of MeTTa, running on SWI-Prolog 9.3.x, as the implementation runtime for the algorithmic chemistry kernel.

Python is allowed only around the kernel for experiment logistics: command launching, configs, batch runs, persistence, plotting, and report generation. The chemistry state transitions, rule selection semantics for small tests, event atom construction, and ACS logic should be expressible and testable in PeTTa.

## Evidence

The local OpenClaw workstation already has a working PeTTa/OmegaClaw stack:

- PeTTa checkout: `projects/omegaclaw/repos/PeTTa`
- Commit observed during setup: `d8d4692` (`Merge pull request #183 from AlexKalll/fix/issue-182`)
- Local SWI-Prolog: `projects/omegaclaw/local/swipl-9.3.36`
- PeTTa upstream smoke: `examples/fib.metta` passed with `is 832040, should 832040. ✅`
- OmegaClaw mock loop also initialized and ran using this stack.

This runtime is therefore the lowest-friction PeTTa-native path available locally.

## Consequences

- Start with simple PeTTa functions and `!(test ...)` checks.
- Keep initial exp00 deterministic and inspectable before introducing stochastic sampling.
- Add Python harness only after the PeTTa kernel has stable atom contracts and golden outputs.
- Record runtime commits and exact command lines in each consequential experiment run.

## Revisit triggers

Revisit this decision if:

- PeTTa cannot express or efficiently test the required exp00 kernel semantics;
- SWI/Janus behavior prevents deterministic replay;
- another Hyperon-family runtime becomes clearly more compatible while still keeping the chemistry kernel PeTTa-native.
