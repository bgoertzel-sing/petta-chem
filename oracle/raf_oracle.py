#!/usr/bin/env python3
"""Independent exhaustive RAF oracle for neutral-crs-v1 serialized systems.

This module deliberately consumes only plain serialized facts.  It does not
import PeTTa chemistry or detector code and does not infer chemistry from IDs.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations
from typing import Any, Iterable, Mapping, Sequence


@dataclass(frozen=True)
class Reaction:
    reaction_id: str
    reactants: tuple[str, ...]
    products: tuple[str, ...]


@dataclass(frozen=True)
class System:
    system_id: str
    food: frozenset[str]
    reactions: tuple[Reaction, ...]
    catalysis: frozenset[tuple[str, str]]


@dataclass(frozen=True)
class OracleResult:
    raf_subsets: frozenset[tuple[str, ...]]
    maximal_raf: tuple[str, ...]
    irreducible_rafs: frozenset[tuple[str, ...]]


def _canonical_strings(
    value: Any,
    field: str,
    *,
    nonempty: bool = False,
    allow_duplicates: bool = False,
) -> tuple[str, ...]:
    if not isinstance(value, list) or any(not isinstance(item, str) or not item for item in value):
        raise ValueError(f"{field} must be a list of nonempty strings")
    items = tuple(value)
    if nonempty and not items:
        raise ValueError(f"{field} must not be empty")
    expected = tuple(sorted(items if allow_duplicates else set(items)))
    if items != expected:
        qualifier = "sorted" if allow_duplicates else "sorted and duplicate-free"
        raise ValueError(f"{field} must be {qualifier}")
    return items


def load_system(payload: Mapping[str, Any]) -> System:
    """Validate and load the canonical neutral CRS JSON boundary."""
    if payload.get("model") != "neutral-crs-v1":
        raise ValueError("model must be neutral-crs-v1")
    system_id = payload.get("system_id")
    if not isinstance(system_id, str) or not system_id:
        raise ValueError("system_id must be a nonempty string")
    food = _canonical_strings(payload.get("food"), "food", nonempty=True)

    raw_reactions = payload.get("reactions")
    if not isinstance(raw_reactions, list):
        raise ValueError("reactions must be a list")
    reactions: list[Reaction] = []
    for index, raw in enumerate(raw_reactions):
        if not isinstance(raw, Mapping):
            raise ValueError(f"reactions[{index}] must be an object")
        reaction_id = raw.get("id")
        if not isinstance(reaction_id, str) or not reaction_id:
            raise ValueError(f"reactions[{index}].id must be a nonempty string")
        reactions.append(
            Reaction(
                reaction_id,
                _canonical_strings(
                    raw.get("reactants"),
                    f"reactions[{index}].reactants",
                    nonempty=True,
                    allow_duplicates=True,
                ),
                _canonical_strings(
                    raw.get("products"),
                    f"reactions[{index}].products",
                    nonempty=True,
                    allow_duplicates=True,
                ),
            )
        )
    reaction_ids = tuple(reaction.reaction_id for reaction in reactions)
    if reaction_ids != tuple(sorted(set(reaction_ids))):
        raise ValueError("reactions must be sorted by unique id")

    raw_catalysis = payload.get("catalysis")
    if not isinstance(raw_catalysis, list):
        raise ValueError("catalysis must be a list")
    edges: list[tuple[str, str]] = []
    known_ids = set(reaction_ids)
    for index, raw in enumerate(raw_catalysis):
        if not isinstance(raw, Mapping):
            raise ValueError(f"catalysis[{index}] must be an object")
        catalyst, reaction_id = raw.get("catalyst"), raw.get("reaction")
        if not isinstance(catalyst, str) or not catalyst:
            raise ValueError(f"catalysis[{index}].catalyst must be a nonempty string")
        if reaction_id not in known_ids:
            raise ValueError(f"catalysis[{index}] names unknown reaction")
        edges.append((catalyst, reaction_id))
    if tuple(edges) != tuple(sorted(set(edges))):
        raise ValueError("catalysis must be sorted and duplicate-free")

    if len(reactions) > 12:
        raise ValueError("exhaustive oracle accepts at most 12 reactions")
    return System(system_id, frozenset(food), tuple(reactions), frozenset(edges))


def closure(food: Iterable[str], reactions: Sequence[Reaction]) -> frozenset[str]:
    closed = set(food)
    changed = True
    while changed:
        changed = False
        for reaction in reactions:
            if set(reaction.reactants) <= closed:
                before = len(closed)
                closed.update(reaction.products)
                changed |= len(closed) != before
    return frozenset(closed)


def is_raf(system: System, reactions: Sequence[Reaction]) -> bool:
    if not reactions:
        return False
    closed = closure(system.food, reactions)
    return all(
        set(reaction.reactants) <= closed
        and any(
            edge_reaction == reaction.reaction_id and catalyst in closed
            for catalyst, edge_reaction in system.catalysis
        )
        for reaction in reactions
    )


def exhaustive_raf(system: System) -> OracleResult:
    rafs: set[tuple[str, ...]] = set()
    reactions = system.reactions
    for size in range(1, len(reactions) + 1):
        for subset in combinations(reactions, size):
            if is_raf(system, subset):
                rafs.add(tuple(reaction.reaction_id for reaction in subset))

    maximal = tuple(sorted({reaction_id for subset in rafs for reaction_id in subset}))
    irreducible = {
        subset
        for subset in rafs
        if not any(set(other) < set(subset) for other in rafs)
    }
    return OracleResult(frozenset(rafs), maximal, frozenset(irreducible))
