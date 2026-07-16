#!/usr/bin/env python3
"""Regression guard for exp07 per-tick RAF detector invariance.

This separately labelled seeded positive-control fixture exercises the
canonical exp04 host detector and committed PeTTa catalysis facts. It does not
load or inspect any preregistered exp07 experimental arm.
"""
from __future__ import annotations

import argparse
import ast
import importlib.util
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from types import ModuleType
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[2]
EXP04_DETECTOR = REPO_ROOT / "experiments" / "exp04" / "run_rich_raf.py"
EXP04_PETTA = REPO_ROOT / "src" / "chem_exp04.metta"
FIXTURE_ID = "exp07-seeded-dynamic-positive-control-seed-31"
FORBIDDEN_PETTA_MUTATION_FORMS = (
    "add-atom",
    "remove-atom",
    "bind!",
    "collapse!",
    "superpose",
    "new-space",
)
HOST_DETECTOR_FUNCTIONS = (
    "relation_catalyzes",
    "closure_from_food",
    "maximal_raf_prune",
    "is_raf",
    "greedy_minimize",
)


@dataclass(frozen=True)
class DetectorSnapshot:
    """Detector inputs plus path metadata that must not affect RAF output."""

    fixture_id: str
    seed: str
    tick: int
    history: tuple[int, ...]
    rules: tuple[Any, ...]
    food: frozenset[str]
    catalysis: frozenset[tuple[str, str]]


def load_exp04_detector() -> ModuleType:
    spec = importlib.util.spec_from_file_location("exp04_run_rich_raf", EXP04_DETECTOR)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load detector from {EXP04_DETECTOR}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def detector_metrics(
    detector: ModuleType,
    rules: tuple[Any, ...],
    catalysis: frozenset[tuple[str, str]],
) -> dict[str, Any]:
    maximal, _trace = detector.maximal_raf_prune(list(rules), catalysis)
    core = detector.greedy_minimize(maximal, catalysis)
    return {
        "maximal_raf_rule_ids": [rule.rid for rule in maximal],
        "maximal_raf_size": len(maximal),
        "minimal_core_rule_ids": [rule.rid for rule in core],
        "minimal_core_size": len(core),
        "minimal_core_is_raf": detector.is_raf(core, catalysis),
    }


def evaluate_snapshot(detector: ModuleType, snapshot: DetectorSnapshot) -> dict[str, Any]:
    if snapshot.food != frozenset(detector.FOOD):
        raise AssertionError("snapshot food set diverges from canonical exp04 detector input")
    return detector_metrics(detector, snapshot.rules, snapshot.catalysis)


def check_call_order_invariance(
    detector: ModuleType,
    rules: tuple[Any, ...],
    catalysis: frozenset[tuple[str, str]],
) -> dict[str, Any]:
    first_a = detector_metrics(detector, rules, catalysis)
    unrelated_b = detector_metrics(detector, rules, frozenset())
    second_a = detector_metrics(detector, rules, catalysis)
    if first_a != second_a:
        raise AssertionError("A -> unrelated B -> A changed the second A detector output")
    if unrelated_b["maximal_raf_size"] != 0:
        raise AssertionError("no-catalysis B fixture must remain RAF-negative")
    if first_a == unrelated_b:
        raise AssertionError("positive A and unrelated negative B must discriminate")
    return {
        "passed": True,
        "sequence": ["positive-A", "no-catalysis-B", "positive-A"],
        "a_outputs_identical": True,
        "positive_maximal_raf_size": first_a["maximal_raf_size"],
        "negative_maximal_raf_size": unrelated_b["maximal_raf_size"],
    }


def check_tick_path_invariance(
    detector: ModuleType,
    rules: tuple[Any, ...],
    catalysis: frozenset[tuple[str, str]],
) -> dict[str, Any]:
    direct = DetectorSnapshot(
        fixture_id=FIXTURE_ID,
        seed="seed-31",
        tick=22,
        history=(22,),
        rules=rules,
        food=frozenset(detector.FOOD),
        catalysis=catalysis,
    )
    advanced = DetectorSnapshot(
        fixture_id=FIXTURE_ID,
        seed="seed-31",
        tick=22,
        history=tuple(range(3, 23)),
        rules=rules,
        food=frozenset(detector.FOOD),
        catalysis=catalysis,
    )
    if (direct.rules, direct.food, direct.catalysis) != (
        advanced.rules,
        advanced.food,
        advanced.catalysis,
    ):
        raise AssertionError("path fixtures do not project to identical detector inputs")
    direct_metrics = evaluate_snapshot(detector, direct)
    advanced_metrics = evaluate_snapshot(detector, advanced)
    if direct_metrics != advanced_metrics:
        raise AssertionError("identical detector inputs changed with tick/history metadata")
    return {
        "passed": True,
        "seed": direct.seed,
        "tick": direct.tick,
        "direct_history": list(direct.history),
        "advanced_history": list(advanced.history),
        "outputs_identical": True,
        "metrics": direct_metrics,
    }


def equation_head_count(source: str, head: str) -> int:
    return len(re.findall(rf"(?m)^\(= \({re.escape(head)}(?:\s|\))", source))


def matching_line_numbers(source: str, pattern: str) -> list[int]:
    compiled = re.compile(pattern)
    return [
        line_number
        for line_number, line in enumerate(source.splitlines(), start=1)
        if compiled.search(line)
    ]


def protected_code_locations() -> dict[str, Any]:
    host_source = EXP04_DETECTOR.read_text(encoding="utf-8")
    host_tree = ast.parse(host_source)
    host_lines = {
        node.name: node.lineno
        for node in host_tree.body
        if isinstance(node, ast.FunctionDef) and node.name in HOST_DETECTOR_FUNCTIONS
    }
    petta_source = EXP04_PETTA.read_text(encoding="utf-8")
    return {
        "call_order_invariance": {
            "file": str(EXP04_DETECTOR.relative_to(REPO_ROOT)),
            "functions": host_lines,
        },
        "tick_path_invariance": {
            "adapter_file": str(Path(__file__).resolve().relative_to(REPO_ROOT)),
            "canonical_detector_file": str(EXP04_DETECTOR.relative_to(REPO_ROOT)),
            "functions": host_lines,
        },
        "single_result_uniqueness": {
            "file": str(EXP04_PETTA.relative_to(REPO_ROOT)),
            "exp04_raf_lines": matching_line_numbers(
                petta_source, r"^\(= \(exp04-raf\?\s"
            ),
            "exp04_raf5_ra_ok_lines": matching_line_numbers(
                petta_source, r"^\(= \(exp04-raf5-ra-ok\?\)"
            ),
            "exp04_raf5_fg_ok_lines": matching_line_numbers(
                petta_source, r"^\(= \(exp04-raf5-fg-ok\?\)"
            ),
            "catalysis_dispatch_lines": matching_line_numbers(
                petta_source, r"^\(= \(catalyzes-in-map\?\s"
            ),
            "ground_catalysis_fact_lines": matching_line_numbers(
                petta_source, r"^\(= \(catalyzes [^)]*\) True\)$"
            ),
        },
    }


def check_single_result_guards(detector: ModuleType) -> dict[str, Any]:
    petta_source = EXP04_PETTA.read_text(encoding="utf-8")
    expected_head_counts = {
        "exp04-raf?": 1,
        "exp04-raf5-ra-ok?": 1,
        "exp04-raf5-fg-ok?": 1,
    }
    observed_head_counts = {
        head: equation_head_count(petta_source, head) for head in expected_head_counts
    }
    if observed_head_counts != expected_head_counts:
        raise AssertionError(
            f"committed PeTTa detector equation heads changed: {observed_head_counts}"
        )

    specific_dispatches = len(
        re.findall(r"(?m)^\(= \(catalyzes-in-map\? exp04-specific\s", petta_source)
    )
    ablated_dispatches = len(
        re.findall(r"(?m)^\(= \(catalyzes-in-map\? exp04-none\s", petta_source)
    )
    if (specific_dispatches, ablated_dispatches) != (1, 1):
        raise AssertionError("catalysis map dispatch must have one specific and one ablated clause")

    catalysis_edges = []
    for line in petta_source.splitlines():
        match = detector.CATALYSIS_FACT_RE.fullmatch(line.strip())
        if match:
            catalysis_edges.append((match.group(1), match.group(2)))
    if len(catalysis_edges) != 18 or len(set(catalysis_edges)) != 18:
        raise AssertionError("committed catalysis facts must contain 18 unique ground edges")

    catalysis_start = petta_source.index("; ----- First-class catalysis relation -----")
    detector_end = petta_source.index("; ----- Reduction-sweep report atoms -----")
    guarded_petta_region = petta_source[catalysis_start:detector_end]
    mutable_hits = [
        form for form in FORBIDDEN_PETTA_MUTATION_FORMS if form in guarded_petta_region
    ]
    if mutable_hits:
        raise AssertionError(f"mutable PeTTa forms entered the detector region: {mutable_hits}")

    host_tree = ast.parse(EXP04_DETECTOR.read_text(encoding="utf-8"))
    host_function_nodes = [
        node for node in host_tree.body if isinstance(node, ast.FunctionDef)
    ]
    host_purity = {}
    for name in HOST_DETECTOR_FUNCTIONS:
        matches = [node for node in host_function_nodes if node.name == name]
        if len(matches) != 1:
            raise AssertionError(
                f"canonical host detector function {name} has {len(matches)} definitions"
            )
        function = matches[0]
        forbidden_nodes = [
            type(node).__name__
            for node in ast.walk(function)
            if isinstance(node, (ast.Global, ast.Nonlocal))
        ]
        if function.decorator_list or forbidden_nodes:
            raise AssertionError(
                f"host detector function {name} gained retained/global state: "
                f"decorators={len(function.decorator_list)}, nodes={forbidden_nodes}"
            )
        host_purity[name] = "one-definition-no-decorator-no-global-or-nonlocal"

    return {
        "passed": True,
        "canonical_catalysis_interface": "catalyzes ground facts + catalyzes-in-map?",
        "petta_equation_head_counts": observed_head_counts,
        "catalysis_map_dispatch_counts": {
            "exp04-specific": specific_dispatches,
            "exp04-none": ablated_dispatches,
        },
        "unique_ground_catalysis_edges": len(catalysis_edges),
        "forbidden_mutable_forms_found": mutable_hits,
        "host_detector_purity": host_purity,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    detector = load_exp04_detector()
    rules = tuple(detector.RULES)
    catalysis = detector.load_petta_catalysis(EXP04_PETTA)
    result = {
        "fixture_id": FIXTURE_ID,
        "status": "passed",
        "scope": "seeded-positive-control-only-no-exp07-experimental-arms",
        "canonical_inputs": {
            "detector": str(EXP04_DETECTOR.relative_to(REPO_ROOT)),
            "petta_facts": str(EXP04_PETTA.relative_to(REPO_ROOT)),
            "seed": "seed-31",
            "food": sorted(detector.FOOD),
            "rule_count": len(rules),
            "catalysis_edge_count": len(catalysis),
        },
        "protected_code_locations": protected_code_locations(),
        "checks": {
            "call_order_invariance": check_call_order_invariance(
                detector, rules, catalysis
            ),
            "tick_path_invariance": check_tick_path_invariance(
                detector, rules, catalysis
            ),
            "single_result_uniqueness": check_single_result_guards(detector),
        },
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(
        json.dumps(
            {
                "fixture_id": result["fixture_id"],
                "status": result["status"],
                "checks": {
                    name: check["passed"] for name, check in result["checks"].items()
                },
            },
            indent=2,
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
