#!/usr/bin/env python3
"""Frozen hand-fixture gate for the independent exhaustive RAF oracle."""

from __future__ import annotations

import copy
import unittest

from oracle.raf_oracle import exhaustive_raf, load_system


def system(
    reactions: list[tuple[str, list[str], list[str]]],
    catalysis: list[tuple[str, str]],
    food: list[str] | None = None,
):
    return {
        "model": "neutral-crs-v1",
        "system_id": "fixture",
        "food": sorted(food or ["0", "1"]),
        "reactions": [
            {"id": rid, "reactants": sorted(reactants), "products": sorted(products)}
            for rid, reactants, products in sorted(reactions)
        ],
        "catalysis": [
            {"catalyst": catalyst, "reaction": rid}
            for catalyst, rid in sorted(catalysis)
        ],
    }


class RafOracleFixtures(unittest.TestCase):
    def result(self, payload):
        return exhaustive_raf(load_system(payload))

    def test_food_closure_chain(self):
        result = self.result(system(
            [("r1", ["0", "1"], ["01"]), ("r2", ["01", "1"], ["011"])],
            [("0", "r1"), ("011", "r2")],
        ))
        self.assertEqual(result.raf_subsets, {("r1",), ("r1", "r2")})
        self.assertNotIn(("r2",), result.raf_subsets)
        self.assertEqual(result.maximal_raf, ("r1", "r2"))

    def test_multiple_products_catalysts_and_multiple_irrafs(self):
        result = self.result(system(
            [
                ("cleave", ["01"], ["0", "1"]),
                ("left", ["0", "0"], ["00"]),
                ("right", ["1", "1"], ["11"]),
            ],
            [("0", "cleave"), ("1", "cleave"), ("0", "left"), ("1", "right")],
            ["0", "1", "01"],
        ))
        self.assertEqual(
            result.irreducible_rafs,
            {("cleave",), ("left",), ("right",)},
        )
        self.assertEqual(result.maximal_raf, ("cleave", "left", "right"))

    def test_food_catalyst(self):
        result = self.result(system(
            [("r", ["0", "1"], ["01"])],
            [("0", "r")],
        ))
        self.assertEqual(result.raf_subsets, {("r",)})

    def test_degenerate_self_catalysis(self):
        result = self.result(system(
            [("r", ["0", "1"], ["01"])],
            [("01", "r")],
        ))
        self.assertEqual(result.raf_subsets, {("r",)})

    def test_unreachable_cycle(self):
        result = self.result(system(
            [("r1", ["x"], ["y"]), ("r2", ["y"], ["x"])],
            [("y", "r1"), ("x", "r2")],
        ))
        self.assertEqual(result.raf_subsets, frozenset())

    def test_edge_addition_monotonicity(self):
        base = system(
            [("r1", ["0"], ["00"]), ("r2", ["1"], ["11"])],
            [("0", "r1")],
        )
        added = copy.deepcopy(base)
        added["catalysis"].append({"catalyst": "1", "reaction": "r2"})
        old, new = self.result(base), self.result(added)
        self.assertLessEqual(old.raf_subsets, new.raf_subsets)
        self.assertLessEqual(len(old.maximal_raf), len(new.maximal_raf))

    def test_deletion_sensitivity(self):
        positive = system(
            [("r1", ["0"], ["00"]), ("r2", ["00", "1"], ["001"])],
            [("0", "r1"), ("001", "r2")],
        )
        self.assertEqual(self.result(positive).maximal_raf, ("r1", "r2"))
        edge_deleted = copy.deepcopy(positive)
        edge_deleted["catalysis"] = edge_deleted["catalysis"][:1]
        self.assertEqual(self.result(edge_deleted).maximal_raf, ("r1",))
        reaction_deleted = copy.deepcopy(positive)
        reaction_deleted["reactions"] = reaction_deleted["reactions"][1:]
        reaction_deleted["catalysis"] = reaction_deleted["catalysis"][1:]
        self.assertEqual(self.result(reaction_deleted).maximal_raf, ())

    def test_canonical_boundary_rejects_order_duplicates_and_unknown_edges(self):
        valid = system([("r", ["0"], ["00"])], [("0", "r")])
        for mutation in (
            lambda p: p["food"].reverse(),
            lambda p: p["food"].append("0"),
            lambda p: p["catalysis"].append({"catalyst": "0", "reaction": "missing"}),
        ):
            payload = copy.deepcopy(valid)
            mutation(payload)
            with self.assertRaises(ValueError):
                load_system(payload)

    def test_serialized_fact_order_normalizes_to_same_logical_result(self):
        payload = system(
            [("r1", ["0"], ["00"]), ("r2", ["1"], ["11"])],
            [("0", "r1"), ("1", "r2")],
        )
        permuted = copy.deepcopy(payload)
        permuted["reactions"].reverse()
        permuted["catalysis"].reverse()
        # The interface is canonical and fail-closed; canonicalizing the same
        # logical facts before loading must preserve the exact result.
        with self.assertRaises(ValueError):
            load_system(permuted)
        permuted["reactions"].sort(key=lambda row: row["id"])
        permuted["catalysis"].sort(key=lambda row: (row["catalyst"], row["reaction"]))
        self.assertEqual(self.result(payload), self.result(permuted))


if __name__ == "__main__":
    unittest.main()
