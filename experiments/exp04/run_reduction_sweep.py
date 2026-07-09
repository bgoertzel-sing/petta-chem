#!/usr/bin/env python3
"""Deterministic exp04 reduction sweep harness.

This is host-side experiment logistics around the PeTTa exp04 fixture: it varies
catalysis controls, basal interval, and the rule-pool construction, then writes
compact JSON/Markdown artifacts for inspection.  It does not implement the PeTTa
chemistry kernel used by exp00-exp03.
"""
from __future__ import annotations

import argparse
import json
from dataclasses import asdict
from pathlib import Path
from typing import Iterable

import run_rich_raf as rich


CATALYSIS_MODES = (
    "specific", "broad",
    "shuffled", "shuffled-1", "shuffled-2", "shuffled-3", "shuffled-4",
    "shuffled-6", "shuffled-7", "shuffled-8", "shuffled-9",
    "none",
)
SHUFFLED_CATALYST_OFFSETS = {
    "shuffled": 5,
    "shuffled-1": 1,
    "shuffled-2": 2,
    "shuffled-3": 3,
    "shuffled-4": 4,
    "shuffled-6": 6,
    "shuffled-7": 7,
    "shuffled-8": 8,
    "shuffled-9": 9,
}
BASAL_INTERVALS = (0, 4, 8)
RULE_POOLS = ("hand-designed", "mechanically-generated-template", "mechanically-generated-cross-template")


def rotate_catalysts(rules: list[rich.Rule], offset: int = 5) -> list[rich.Rule]:
    catalysts = [r.catalyst for r in rules]
    n = len(catalysts)
    return [
        rich.Rule(r.rid, r.kind, r.a, r.b, r.product, r.secondary, catalysts[(i + offset) % n])
        for i, r in enumerate(rules)
    ]


def no_catalysis_rules(rules: list[rich.Rule]) -> list[rich.Rule]:
    return [rich.Rule(r.rid, r.kind, r.a, r.b, r.product, r.secondary, "None") for r in rules]


PAIR_SPECS = (
    ("A", "B", "AB"), ("A", "C", "AC"), ("A", "D", "AD"),
    ("B", "C", "BC"), ("B", "D", "BD"), ("C", "D", "CD"),
)


def generated_template_rules() -> list[rich.Rule]:
    """A deterministic non-hand-picked 20-rule template pool over A/B/C/D.

    The pool is generated mechanically from food-pair ligations, matching
    cleavages, and pair-to-star modifications; catalysts are local products or
    adjacent pair products, not manually tuned to the exp04 RAF core.
    """
    rules: list[rich.Rule] = []
    for i, (a, b, product) in enumerate(PAIR_SPECS):
        catalyst = PAIR_SPECS[(i + 1) % len(PAIR_SPECS)][2]
        rules.append(rich.Rule(f"gl{product}", "ligation", a, b, product, None, catalyst))
    for i, (_a, _b, product) in enumerate(PAIR_SPECS):
        catalyst = PAIR_SPECS[(i + 2) % len(PAIR_SPECS)][2]
        rules.append(rich.Rule(f"gc{product}", "cleavage", product, None, product[0], product[1], catalyst))
    for i, (_a, _b, product) in enumerate(PAIR_SPECS):
        catalyst = PAIR_SPECS[(i + 3) % len(PAIR_SPECS)][2]
        rules.append(rich.Rule(f"gm{product}", "modification", product, None, f"{product}star", None, catalyst))
    rules.extend([
        rich.Rule("glABC", "ligation", "AB", "C", "ABC", None, "BC"),
        rich.Rule("glBCD", "ligation", "BC", "D", "BCD", None, "CD"),
    ])
    return rules


def generated_cross_template_rules() -> list[rich.Rule]:
    """A stricter mechanically generated 20-rule decoy pool.

    Pair-level catalysts are assigned to disjoint/cross pair products when
    possible, reducing direct motif matches relative to `generated_template_rules`.
    This probes how much the exp04 RAF signal depends on local template bias and
    whether shuffled catalysis can itself manufacture RAF-like closure.
    """
    cross = {"AB": "CD", "AC": "BD", "AD": "BC", "BC": "AD", "BD": "AC", "CD": "AB"}
    rules: list[rich.Rule] = []
    for a, b, product in PAIR_SPECS:
        rules.append(rich.Rule(f"xgl{product}", "ligation", a, b, product, None, cross[product]))
    for a, b, product in PAIR_SPECS:
        rules.append(rich.Rule(f"xgc{product}", "cleavage", product, None, a, b, cross[product]))
    for _a, _b, product in PAIR_SPECS:
        rules.append(rich.Rule(f"xgm{product}", "modification", product, None, f"{product}star", None, cross[product]))
    rules.extend([
        rich.Rule("xglABC", "ligation", "AB", "C", "ABC", None, "BD"),
        rich.Rule("xglBCD", "ligation", "BC", "D", "BCD", None, "AC"),
    ])
    return rules


def rule_pool(name: str) -> list[rich.Rule]:
    if name == "hand-designed":
        return list(rich.RULES)
    if name == "mechanically-generated-template":
        return generated_template_rules()
    if name == "mechanically-generated-cross-template":
        return generated_cross_template_rules()
    raise ValueError(f"unknown rule pool: {name}")


def template_ok(catalyst: str, rule: rich.Rule, mode: str) -> bool:
    if mode == "none" or catalyst == "None":
        return False
    if mode == "broad":
        return rich.template_catalyzes(catalyst, rule, require_non_food=False)
    return rich.template_catalyzes(catalyst, rule)


def closure_from_food(rules: Iterable[rich.Rule]) -> set[str]:
    return rich.closure_from_food(rules)


def rules_for_catalysis_mode(rules: list[rich.Rule], mode: str) -> list[rich.Rule]:
    if mode in SHUFFLED_CATALYST_OFFSETS:
        return rotate_catalysts(rules, SHUFFLED_CATALYST_OFFSETS[mode])
    if mode == "none":
        return no_catalysis_rules(rules)
    return list(rules)


def maximal_raf_prune_variant(rules: list[rich.Rule], mode: str) -> tuple[list[rich.Rule], list[dict]]:
    active = rules_for_catalysis_mode(rules, mode)
    trace = []
    for step in range(len(active) + len(rich.STRUCTURAL_CONTAINS)):
        closure = closure_from_food(active)
        products = {p for r in active for p in r.products}
        next_active = []
        removed = []
        for r in active:
            fg = all(x in closure for x in r.reactants)
            ra = r.catalyst in closure and r.catalyst in products and template_ok(r.catalyst, r, mode)
            if fg and ra:
                next_active.append(r)
            else:
                removed.append({"rule": r.rid, "food_generated": fg, "reflexively_autocatalytic": ra})
        trace.append({"step": step, "size": len(active), "closure_size": len(closure), "removed_count": len(removed)})
        if [r.rid for r in next_active] == [r.rid for r in active]:
            return active, trace
        active = next_active
    return active, trace


def is_raf_variant(rules: list[rich.Rule], mode: str) -> bool:
    if not rules:
        return False
    closure = closure_from_food(rules)
    products = {p for r in rules for p in r.products}
    return all(
        all(x in closure for x in r.reactants)
        and r.catalyst in closure
        and r.catalyst in products
        and template_ok(r.catalyst, r, mode)
        for r in rules
    )


def greedy_minimize_variant(rules: list[rich.Rule], mode: str) -> list[rich.Rule]:
    core = list(rules)
    changed = True
    while changed:
        changed = False
        for r in list(core):
            candidate = [x for x in core if x != r]
            if is_raf_variant(candidate, mode):
                core = candidate
                changed = True
                break
    return core


def simulate_variant(rules: list[rich.Rule], mode: str, basal_interval: int, ticks: int) -> tuple[dict[str, int], list[dict]]:
    active_rules = rules_for_catalysis_mode(rules, mode)
    abundance = {m: rich.FOOD_FLOOR for m in rich.FOOD}
    events = []
    for tick in range(ticks):
        for f in rich.FOOD:
            abundance[f] = max(abundance.get(f, 0), rich.FOOD_FLOOR)
        catalyzed = []
        basal = []
        for r in active_rules:
            if not all(abundance.get(x, 0) > 0 for x in r.reactants):
                continue
            if abundance.get(r.catalyst, 0) > 0 and template_ok(r.catalyst, r, mode):
                catalyzed.append(r)
            else:
                basal.append(r)
        if basal_interval > 0 and tick % basal_interval == 0 and basal:
            applicable = basal
            selected = applicable[(tick // basal_interval) % len(applicable)]
            selected_mode = "basal"
        elif catalyzed:
            applicable = catalyzed
            selected = applicable[(31 + tick) % len(applicable)]
            selected_mode = "catalyzed"
        else:
            continue
        for x in selected.reactants:
            if x not in rich.FOOD:
                abundance[x] = abundance.get(x, 0) - 1
        for p in selected.products:
            abundance[p] = abundance.get(p, 0) + 1
        events.append({"tick": tick, "rule": selected.rid, "kind": selected.kind, "mode": selected_mode})
    return dict(sorted(abundance.items())), events


def summarize_variant(pool_name: str, mode: str, basal_interval: int, ticks: int) -> dict:
    rules = rule_pool(pool_name)
    maximal, prune_trace = maximal_raf_prune_variant(rules, mode)
    core = greedy_minimize_variant(maximal, mode)
    final_abundance, events = simulate_variant(rules, mode, basal_interval, ticks)
    return {
        "pool": pool_name,
        "catalysis_mode": mode,
        "basal_interval": basal_interval,
        "rule_count": len(rules),
        "maximal_raf_size": len(maximal),
        "minimal_core_size": len(core),
        "minimal_core_is_raf": is_raf_variant(core, mode),
        "minimal_core_rule_ids": [r.rid for r in core],
        "event_count": len(events),
        "event_diversity": len({e["rule"] for e in events}),
        "catalyzed_event_count": sum(1 for e in events if e["mode"] == "catalyzed"),
        "basal_event_count": sum(1 for e in events if e["mode"] == "basal"),
        "food_floor_ok": all(final_abundance.get(f, 0) >= rich.FOOD_FLOOR for f in rich.FOOD),
        "first_8_events": events[:8],
        "fixed_point_step": prune_trace[-1]["step"] if prune_trace else 0,
    }


def write_summary(out_dir: Path, rows: list[dict]) -> None:
    lines = [
        "# exp04 reduction sweep",
        "",
        "Deterministic host-side sweep around the PeTTa exp04 rich RAF fixture.",
        "It varies catalysis controls, basal interval, and hand-designed versus mechanically generated template pools.",
        "",
        "| pool | catalysis | basal interval | maximal RAF | core | events | diversity | catalyzed | basal |",
        "|---|---:|---:|---:|---:|---:|---:|---:|---:|",
    ]
    for row in rows:
        lines.append(
            f"| {row['pool']} | {row['catalysis_mode']} | {row['basal_interval']} | "
            f"{row['maximal_raf_size']} | {row['minimal_core_size']} | {row['event_count']} | "
            f"{row['event_diversity']} | {row['catalyzed_event_count']} | {row['basal_event_count']} |"
        )
    lines.extend([
        "",
        "Interpretation: the original hand-designed/specific run remains a positive RAF artifact, while no-catalysis and multiple rotated-shuffle controls expose how much the result depends on the catalysis map and basal trickle.",
    ])
    (out_dir / "SUMMARY.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--ticks", type=int, default=56)
    ap.add_argument("--out-dir", type=Path, required=True)
    args = ap.parse_args()

    args.out_dir.mkdir(parents=True, exist_ok=True)
    rows = [
        summarize_variant(pool, mode, basal_interval, args.ticks)
        for pool in RULE_POOLS
        for mode in CATALYSIS_MODES
        for basal_interval in BASAL_INTERVALS
    ]
    payload = {
        "config": {
            "ticks": args.ticks,
            "food": sorted(rich.FOOD),
            "food_floor": rich.FOOD_FLOOR,
            "catalysis_modes": list(CATALYSIS_MODES),
            "basal_intervals": list(BASAL_INTERVALS),
            "rule_pools": list(RULE_POOLS),
        },
        "rows": rows,
    }
    (args.out_dir / "REDUCTION_SWEEP.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    write_summary(args.out_dir, rows)
    print(json.dumps({
        "rows": len(rows),
        "positive_specific_hand_designed": next(
            r for r in rows
            if r["pool"] == "hand-designed" and r["catalysis_mode"] == "specific" and r["basal_interval"] == 4
        ),
    }, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
