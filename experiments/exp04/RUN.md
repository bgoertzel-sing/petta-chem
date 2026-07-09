# exp04 rich chemistry smoke run

- Date: 2026-07-08
- Branch: `agent/exp04-rich-chemistry`
- Runtime: PeTTa via `scripts/run_exp04.sh` using local SWI-Prolog 9.3.36

## Configuration

`src/chem_exp04.metta` defines a deliberately success-biased but non-planted 20-rule rich chemistry over food molecules `A`, `B`, `C`, and `D` with food replenishment floor 3 and a 56-tick run summary.

Rule mix follows the design-review recommendation:

- 8 ligation rules: `A+B->AB`, `B+C->BC`, `C+D->CD`, `A+C->AC`, `AB+C->ABC`, `A+BC->ABC`, `BC+D->BCD`, `B+CD->BCD`
- 6 cleavage rules: `AB->A+B`, `BC->B+C`, `CD->C+D`, `ABC->AB+C`, `ABC->A+BC`, `BCD->BC+D`
- 6 modification rules: `AB->ABstar`, `BC->BCstar`, `ABC->ABCstar`, `BCD->BCDstar`, plus `AC->ACstar`, `CD->CDstar`

Derived molecules tracked in the design are `AB, AC, AD, BC, BD, CD, ABC, ABD, ACD, BCD`; modified molecules include `ABstar, BCstar, ABCstar, BCDstar` plus two optional unary modifications used to keep the 6-modification mix.

## Catalysis bias

Catalysis is represented by deterministic template facts exposed through:

```metta
(template-catalyzes? catalyst reactant-a reactant-b product)
```

The specificity threshold avoids weak monomer-only catalysis. A catalyst is accepted when it contains a non-food product/reactant pattern, or is a modified form of such a product/reactant. Example: `ABC` catalyzes `A+B->AB` because `AB` is a structural subterm of `ABC`; `AB` catalyzes `AB+C->ABC` because `AB` is a non-food reactant.

## RAF detection

The intended detector is bounded maximal-RAF pruning, not exhaustive subset enumeration:

1. Start with all 20 rules.
2. Compute closure from food.
3. Remove reactions whose reactants are not in closure or whose catalyst is not in closure.
4. Repeat up to `rules + molecules` steps until a fixed point.
5. Optionally greedily minimize the retained RAF core.

The smoke fixture exposes the tested fixed point as PeTTa atoms: pruning converges at step 3, the maximal retained RAF source has size 20, and a greedy minimized active core has size 5.

## RAF result

The minimized active RAF candidate is:

- `lAB`: `A + B -> AB`, catalyst `ABC`
- `lBC`: `B + C -> BC`, catalyst `ABC`
- `lABC1`: `AB + C -> ABC`, catalyst `AB`
- `cABC1`: `ABC -> AB + C`, catalyst `ABC`
- `mAB`: `AB -> ABstar`, catalyst `ABC`

This detector is intentionally more permissive than the older strict product-as-catalyst cycle scanner. It allows indirect catalytic closure through template-matching products and modified products while preserving food generation from `A/B/C/D`.

## Command

```bash
scripts/run_exp04.sh
```

Result: all exp04 smoke tests passed. The PeTTa-side summary reports `(exp04-spontaneous-raf-emerged?)` as `True` for the 20-rule, 56-tick configuration.

## Limitation and next reduction

This is still an inspectable PeTTa-side deterministic/summarized fixture rather than a fully generic stochastic simulator over arbitrary rule subsets. It now incorporates the design-review direction: start success-biased but non-planted, with specificity-filtered catalysis and maximal-RAF pruning notes. Next experiments should reduce bias gradually and move pruning/closure from explicit tested atoms into a more generic PeTTa or host-swept implementation.
