# exp02 sweep-kind summary — 2026-07-05

This is a concise report over the current deterministic PeTTa exp02 sweep. It is **not** a spontaneous-emergence claim; the scanner is still the conservative reciprocal product-as-catalyst pair criterion.

| Sweep kind | Sweep points | Family records | Family records with active pairs | Total active pairs | Random-polymer points active | Active-family-record rate |
|---|---:|---:|---:|---:|---:|---|
| planted-reciprocal-pair-control | 4 | 12 | 4 | 7 | 4 | 4/12 |
| generated-unplanted-control | 40 | 120 | 0 | 0 | 0 | 0/120 |

## Interpretation

- The planted reciprocal-pair controls still discriminate random-polymer fixtures from shuffled-catalyst and no-catalysis controls.
- The generated-unplanted seed-to-component controls, seed-19/seed-23, and factored-template seed-29/seed-31/seed-37/seed-41/seed-43/seed-47/seed-53/seed-59/seed-61/seed-67/seed-71/seed-73/seed-79/seed-83/seed-89/seed-97/seed-101/seed-103/seed-107/seed-109/seed-113/seed-127/seed-131/seed-137/seed-139/seed-149/seed-151/seed-157/seed-163/seed-167, seed-173, seed-179, seed-181, seed-191, seed-193, seed-197, seed-199, and seed-211 remain negative across random-polymer, shuffled-catalyst, and no-catalysis families.
- Larger generated sweeps with still more compact seed schemas are still needed before claiming non-planted ACS emergence.

## 3-rule catalytic cycle (triple) scanning

The 3-rule scanner (`product-catalyst-closed-3?`) checks product(r0)=catalyst(r1), product(r1)=catalyst(r2), product(r2)=catalyst(r0). This generalizes the pair scanner to RAF-like 3-cycles that reciprocal-pair scanning would miss.

| Sweep kind | Seeds scanned | Family records | Active triples |
|---|---:|---:|---:|
| planted-reciprocal-pair-control | 1 | 3 (seed-13) | 0 |
| planted-3-cycle fixture | 1 | 1 | 1 |
| generated-unplanted-control | 40 | 120 | 0 |

- The planted 3-cycle fixture (ptc0→ptc1→ptc2) validates the scanner recovers exactly 1 active triple out of C(8,3)=56 candidates.
- Seed-13 planted reciprocal-pair control has 2 active pairs but 0 active triples, confirming pair closure does not imply 3-cycle closure.
- All 40 generated-unplanted seeds × 3 families = 120 family records scan to 0 active triples, confirming the conservative pair scanner's zero-active result extends to 3-rule catalytic cycles.

## 4-rule catalytic cycle (quadruple) scanning

The 4-rule scanner (`product-catalyst-closed-4?`) checks product(r0)=catalyst(r1), product(r1)=catalyst(r2), product(r2)=catalyst(r3), product(r3)=catalyst(r0). This generalizes the triple scanner to RAF-like 4-cycles.

| Sweep kind | Seeds scanned | Family records | Active quadruples |
|---|---:|---:|---:|
| planted-4-cycle fixture | 1 | 1 | 1 |
| generated-unplanted-control | 40 | 120 | 0 |

- The planted 4-cycle fixture (pqc0→pqc1→pqc2→pqc3) validates the scanner recovers exactly 1 active quadruple out of C(8,4)=70 candidates.
- All 40 generated-unplanted seeds × 3 families = 120 family records scan to 0 active quadruples, confirming the pair/triple scanner's zero-active result extends to 4-rule catalytic cycles.

## 5-rule catalytic cycle (quintuple) scanning

The 5-rule scanner (`product-catalyst-closed-5?`) checks product(r0)=catalyst(r1), product(r1)=catalyst(r2), product(r2)=catalyst(r3), product(r3)=catalyst(r4), product(r4)=catalyst(r0). This generalizes the quadruple scanner to RAF-like 5-cycles.

| Sweep kind | Seeds scanned | Family records | Active quintuples |
|---|---:|---:|---:|
| planted-5-cycle fixture | 1 | 1 | 1 |
| generated-unplanted-control | 40 | 120 | 0 |

- The planted 5-cycle fixture (pqq0→pqq1→pqq2→pqq3→pqq4) validates the scanner recovers exactly 1 active quintuple out of C(8,5)=56 candidates.
- All 40 generated-unplanted seeds × 3 families = 120 family records scan to 0 active quintuples, confirming the pair/triple/quadruple scanner's zero-active result extends to 5-rule catalytic cycles.

## 6-rule catalytic cycle (sextuple) scanning

The 6-rule scanner (`product-catalyst-closed-6?`) checks product(r0)=catalyst(r1), product(r1)=catalyst(r2), product(r2)=catalyst(r3), product(r3)=catalyst(r4), product(r4)=catalyst(r5), product(r5)=catalyst(r0). This generalizes the quintuple scanner to RAF-like 6-cycles.

| Sweep kind | Seeds scanned | Family records | Active sextuples |
|---|---:|---:|---:|
| planted-6-cycle fixture | 1 | 1 | 1 |
| generated-unplanted-control | 40 | 120 | 0 |

- The planted 6-cycle fixture (psq0→psq1→psq2→psq3→psq4→psq5) validates the scanner recovers exactly 1 active sextuple out of C(8,6)=28 candidates.
- All 40 generated-unplanted seeds × 3 families = 120 family records scan to 0 active sextuples, confirming the pair/triple/quadruple/quintuple scanner's zero-active result extends to 6-rule catalytic cycles.

## 7-rule catalytic cycle (septuple) scanning

The 7-rule scanner (`product-catalyst-closed-7?`) checks product(r0)=catalyst(r1), product(r1)=catalyst(r2), product(r2)=catalyst(r3), product(r3)=catalyst(r4), product(r4)=catalyst(r5), product(r5)=catalyst(r6), product(r6)=catalyst(r0). This generalizes the sextuple scanner to RAF-like 7-cycles, completing the full cycle-size coverage for 8-rule families (k=2..7).

| Sweep kind | Seeds scanned | Family records | Active septuples |
|---|---:|---:|---:|
| planted-7-cycle fixture | 1 | 1 | 1 |
| generated-unplanted-control | 40 | 120 | 0 |

- The planted 7-cycle fixture (psp0→psp1→psp2→psp3→psp4→psp5→psp6) validates the scanner recovers exactly 1 active septuple out of C(8,7)=8 candidates.
- All 40 generated-unplanted seeds × 3 families = 120 family records scan to 0 active septuples, confirming the pair/triple/quadruple/quintuple/sextuple scanner's zero-active result extends to 7-rule catalytic cycles.
- This completes systematic cycle-size coverage for 8-rule families: all cycle sizes k=2 through k=7 produce zero active cycles across all 120 generated-unplanted family records.

## PeTTa provenance

The table mirrors tested PeTTa atoms in `src/chem_exp02.metta`: `exp02-fold-sweep-kind-summary` folds over `run-record` lists to derive family-record counts, active-family counts, active-pair totals, active random-polymer points, and `exp02-sweep-kind-summary`; `exp02-sweep-kind-summary-report` now builds its rows from those folded summaries. Triple-scan summaries use `exp02-triple-scan-summary`, `exp02-generated-unplanted-triple-summary`, and `exp02-planted-triple-summary`. Quadruple-scan summaries use `exp02-quadruple-scan-summary`, `exp02-generated-unplanted-quadruple-summary`, and `exp02-planted-quadruple-summary`. Quintuple-scan summaries use `exp02-quintuple-scan-summary`, `exp02-generated-unplanted-quintuple-summary`, and `exp02-planted-quintuple-summary`. Sextuple-scan summaries use `exp02-sextuple-scan-summary`, `exp02-generated-unplanted-sextuple-summary`, and `exp02-planted-sextuple-summary`. Septuple-scan summaries use `exp02-septuple-scan-summary`, `exp02-generated-unplanted-septuple-summary`, and `exp02-planted-septuple-summary`.
