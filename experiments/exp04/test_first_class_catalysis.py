#!/usr/bin/env python3
"""Regression gate for exp04's first-class PeTTa catalysis relation."""

from __future__ import annotations

import run_rich_raf as rich


def main() -> None:
    catalysis = rich.load_petta_catalysis(rich.DEFAULT_CATALYSIS_SOURCE)
    assert len(catalysis) == 18
    assert ("ABC", "lAB") in catalysis
    assert ("CD", "lBCD2") in catalysis
    assert ("AB", "mABC") not in catalysis

    maximal, _trace = rich.maximal_raf_prune(rich.RULES, catalysis)
    core = rich.greedy_minimize(maximal, catalysis)
    ablated, _trace = rich.maximal_raf_prune(rich.RULES, frozenset())

    assert [rule.rid for rule in maximal] == [
        "lAB", "lBC", "lCD", "lABC1", "lABC2", "lBCD1", "lBCD2",
        "cAB", "cBC", "cCD", "cABC1", "cBCD", "mAB", "mBC", "mCD",
    ]
    assert [rule.rid for rule in core] == ["lCD", "lBCD2"]
    assert rich.is_raf(core, catalysis)
    assert ablated == []
    print("first-class catalysis: 18 edges, maximal RAF 15, core 2, ablation 0")


if __name__ == "__main__":
    main()
