# exp04 reduction sweep

Deterministic host-side sweep around the PeTTa exp04 rich RAF fixture.
It varies catalysis controls, basal interval, and hand-designed versus mechanically generated template pools.

| pool | catalysis | basal interval | maximal RAF | core | events | diversity | catalyzed | basal |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| hand-designed | specific | 0 | 15 | 2 | 0 | 0 | 0 | 0 |
| hand-designed | specific | 4 | 15 | 2 | 56 | 15 | 42 | 14 |
| hand-designed | specific | 8 | 15 | 2 | 56 | 18 | 49 | 7 |
| hand-designed | broad | 0 | 15 | 2 | 0 | 0 | 0 | 0 |
| hand-designed | broad | 4 | 15 | 2 | 56 | 15 | 42 | 14 |
| hand-designed | broad | 8 | 15 | 2 | 56 | 18 | 49 | 7 |
| hand-designed | shuffled | 0 | 10 | 3 | 0 | 0 | 0 | 0 |
| hand-designed | shuffled | 4 | 10 | 3 | 53 | 16 | 39 | 14 |
| hand-designed | shuffled | 8 | 10 | 3 | 49 | 13 | 42 | 7 |
| hand-designed | none | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| hand-designed | none | 4 | 0 | 0 | 14 | 11 | 0 | 14 |
| hand-designed | none | 8 | 0 | 0 | 7 | 7 | 0 | 7 |
| mechanically-generated-template | specific | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| mechanically-generated-template | specific | 4 | 0 | 0 | 14 | 11 | 0 | 14 |
| mechanically-generated-template | specific | 8 | 0 | 0 | 7 | 7 | 0 | 7 |
| mechanically-generated-template | broad | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| mechanically-generated-template | broad | 4 | 0 | 0 | 53 | 14 | 39 | 14 |
| mechanically-generated-template | broad | 8 | 0 | 0 | 49 | 11 | 42 | 7 |
| mechanically-generated-template | shuffled | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| mechanically-generated-template | shuffled | 4 | 1 | 1 | 56 | 12 | 42 | 14 |
| mechanically-generated-template | shuffled | 8 | 1 | 1 | 56 | 7 | 49 | 7 |
| mechanically-generated-template | none | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| mechanically-generated-template | none | 4 | 0 | 0 | 14 | 11 | 0 | 14 |
| mechanically-generated-template | none | 8 | 0 | 0 | 7 | 7 | 0 | 7 |
| mechanically-generated-cross-template | specific | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| mechanically-generated-cross-template | specific | 4 | 0 | 0 | 14 | 11 | 0 | 14 |
| mechanically-generated-cross-template | specific | 8 | 0 | 0 | 7 | 7 | 0 | 7 |
| mechanically-generated-cross-template | broad | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| mechanically-generated-cross-template | broad | 4 | 0 | 0 | 14 | 11 | 0 | 14 |
| mechanically-generated-cross-template | broad | 8 | 0 | 0 | 7 | 7 | 0 | 7 |
| mechanically-generated-cross-template | shuffled | 0 | 5 | 1 | 0 | 0 | 0 | 0 |
| mechanically-generated-cross-template | shuffled | 4 | 5 | 1 | 48 | 12 | 34 | 14 |
| mechanically-generated-cross-template | shuffled | 8 | 5 | 1 | 36 | 9 | 29 | 7 |
| mechanically-generated-cross-template | none | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| mechanically-generated-cross-template | none | 4 | 0 | 0 | 14 | 11 | 0 | 14 |
| mechanically-generated-cross-template | none | 8 | 0 | 0 | 7 | 7 | 0 | 7 |

Interpretation: the original hand-designed/specific run remains a positive RAF artifact, while the none/shuffled controls expose how much the result depends on the catalysis map and basal trickle.
