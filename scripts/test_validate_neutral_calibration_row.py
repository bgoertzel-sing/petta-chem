#!/usr/bin/env python3
"""Unit tests for scripts/validate_neutral_calibration_row.py (v3 per-row gate).

Fixtures live in scripts/fixtures/neutral_row_validator/.  The negative
fixture v2_unevaluated_032.stdout is a byte copy of the real v2 raw row
experiments/neutral_calibration_v2/graph-seed-1001/attempt-001/raw/
032-primary-transition-L5-f2-8-V100-g1001-d2001.stdout (sha256 recorded in
the fixture README) exhibiting the exact unevaluated neutral-raf-* defect.
Good-row fixtures are synthetic or real v3 smoke rows; v1/v2 rows are NEVER
positive fixtures (they all carry the defect).
Run: python3 scripts/test_validate_neutral_calibration_row.py
"""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import validate_neutral_calibration_row as v  # noqa: E402

FIX = Path(__file__).resolve().parent / "fixtures" / "neutral_row_validator"
PREAMBLE = ("--> metta runnable  -->\n!(neutral-ssa-run-calibration-row 5 1001 2001 16 1000000 500.0 100 "
            "100.0 10.0 40 32)\n-->  prolog goal  --> \n:- findall(A, x(A), _).\n^^^^^^^^\n")
EXPECT = {"L": 5, "f_twice": 16, "volume": 100, "graph_seed": 1001, "dynamics_seed": 2001}


def row(ids='("lig:0:0" "cleave:00:1" "lig:01:10")', reach_b="true 12.5", reach_a="false censored",
        base=(40, 33, "812.5"), abl=(3, 2, "100.25"), delta=(37, 31, "712.25"), L=5, g=1001, d=2001,
        f=16, V=100, mc=62, rc=392):
    rb, fb = reach_b.split()
    ra, fa = reach_a.split()
    return (f"(neutral-calibration-row model neutral-crs-v1 max-length {L} graph-seed {g} "
            f"dynamics-seed {d} f-twice {f} volume {V} molecule-count {mc} reaction-count {rc} "
            f"maximal-raf-rule-ids {ids} endpoints (neutral-ablation-endpoints "
            f"baseline-reachability (raf-reachability-summary reachable {rb} first-time {fb}) "
            f"ablated-reachability (raf-reachability-summary reachable {ra} first-time {fa}) "
            f"baseline-causal (neutral-causal-endpoints raf-events {base[0]} evidence-bins {base[1]} "
            f"integrated-nonfood {base[2]}) "
            f"ablated-causal (neutral-causal-endpoints raf-events {abl[0]} evidence-bins {abl[1]} "
            f"integrated-nonfood {abl[2]}) "
            f"delta (neutral-causal-endpoint-delta raf-events {delta[0]} evidence-bins {delta[1]} "
            f"integrated-nonfood {delta[2]})))\n")


def check(text, expect=EXPECT, stderr="", exit_code=0):
    return v.validate_text(text, stderr, expect, exit_code)


class GoodRows(unittest.TestCase):
    def test_good_row_passes(self):
        r = check(PREAMBLE + row())
        self.assertEqual(r["verdict"], "pass", r["reasons"])
        self.assertEqual(r["summary"]["raf_size"], 3)

    def test_good_empty_raf_row_passes(self):
        r = check(PREAMBLE + row(ids="()", reach_b="false censored", base=(0, 0, "7.5"),
                                 abl=(0, 0, "7.5"), delta=(0, 0, "0.0"), f=0),
                  expect={**EXPECT, "f_twice": 0})
        self.assertEqual(r["verdict"], "pass", r["reasons"])

    def test_universe_sizes(self):
        self.assertEqual([v.molecule_count(L) for L in (4, 5, 6)], [30, 62, 126])
        self.assertEqual(v.reaction_count(5), 392)

    def test_real_v3_smoke_rows_pass_if_present(self):
        for path in sorted(FIX.glob("v3_smoke_good_*.stdout")):
            parts = path.stem.split("-")
            exp = {"L": int(parts[-6][1:]), "f_twice": int(parts[-5]), "volume": int(parts[-4][1:]),
                   "graph_seed": int(parts[-3][1:]), "dynamics_seed": int(parts[-2][1:])}
            r = v.validate_files(path, path.with_suffix(".stderr"), exp)
            self.assertEqual(r["verdict"], "pass", (path.name, r["reasons"]))


class BadRows(unittest.TestCase):
    def test_real_v2_unevaluated_defect(self):
        out = FIX / "v2_unevaluated_032.stdout"
        r = v.validate_files(out, FIX / "empty.stderr",
                             {**EXPECT, "f_twice": 8})
        self.assertEqual(r["verdict"], "fail")
        joined = " ".join(r["reasons"])
        self.assertIn("neutral-raf-reaction-ids", joined)
        self.assertIn("not a flat list", joined)
        self.assertEqual(len(r["validator_sha256"]), 64)

    def test_unevaluated_nested_call_synthetic(self):
        r = check(PREAMBLE + row(ids='(neutral-raf-reaction-ids ("x"))'))
        self.assertEqual(r["verdict"], "fail")

    def test_unevaluated_in_endpoints(self):
        r = check(PREAMBLE + row(base=(40, "(neutral-ssa-persistence-evidence-bins x)", "1.0")))
        self.assertEqual(r["verdict"], "fail")

    def test_identity_mismatch(self):
        for key, val in (("graph_seed", 1002), ("dynamics_seed", 2002), ("f_twice", 15),
                         ("L", 6), ("volume", 200)):
            r = check(PREAMBLE + row(), expect={**EXPECT, key: val})
            self.assertEqual(r["verdict"], "fail", key)
            self.assertTrue(any("identity mismatch" in s for s in r["reasons"]), key)

    def test_missing_atom(self):
        r = check(PREAMBLE)
        self.assertEqual(r["verdict"], "fail")
        self.assertIn("no (neutral-calibration-row", r["reasons"][0])

    def test_duplicate_atom(self):
        r = check(PREAMBLE + row() + row())
        self.assertEqual(r["verdict"], "fail")
        self.assertTrue(any("result atoms" in s for s in r["reasons"]))

    def test_truncated_atom(self):
        r = check(PREAMBLE + row()[:-40])
        self.assertEqual(r["verdict"], "fail")

    def test_out_of_range_bins(self):
        r = check(PREAMBLE + row(base=(40, 41, "812.5"), delta=(37, 39, "712.25")))
        self.assertEqual(r["verdict"], "fail")
        self.assertTrue(any("outside 0..40" in s for s in r["reasons"]))

    def test_negative_counts(self):
        r = check(PREAMBLE + row(abl=(-1, 2, "100.25"), delta=(41, 31, "712.25")))
        self.assertEqual(r["verdict"], "fail")

    def test_nan_and_inf(self):
        for bad in ("nan", "NaN", "inf", "1.0Inf"):
            r = check(PREAMBLE + row(base=(40, 33, bad)))
            self.assertEqual(r["verdict"], "fail", bad)

    def test_first_time_beyond_T(self):
        r = check(PREAMBLE + row(reach_b="true 500.5"))
        self.assertEqual(r["verdict"], "fail")

    def test_reachable_censored_inconsistent(self):
        self.assertEqual(check(PREAMBLE + row(reach_b="true censored"))["verdict"], "fail")
        self.assertEqual(check(PREAMBLE + row(reach_a="false 3.0"))["verdict"], "fail")

    def test_delta_inconsistent(self):
        self.assertEqual(check(PREAMBLE + row(delta=(36, 31, "712.25")))["verdict"], "fail")
        self.assertEqual(check(PREAMBLE + row(delta=(37, 30, "712.25")))["verdict"], "fail")
        self.assertEqual(check(PREAMBLE + row(delta=(37, 31, "712.0")))["verdict"], "fail")

    def test_empty_raf_but_reachable(self):
        r = check(PREAMBLE + row(ids="()", base=(0, 0, "7.5"), abl=(0, 0, "7.5"), delta=(0, 0, "0.0")))
        self.assertEqual(r["verdict"], "fail")
        self.assertTrue(any("maximal RAF is empty" in s for s in r["reasons"]))

    def test_empty_raf_with_raf_events(self):
        r = check(PREAMBLE + row(ids="()", reach_b="false censored"))
        self.assertEqual(r["verdict"], "fail")

    def test_f0_with_nonempty_raf(self):
        r = check(PREAMBLE + row(f=0), expect={**EXPECT, "f_twice": 0})
        self.assertEqual(r["verdict"], "fail")

    def test_malformed_and_duplicate_rule_ids(self):
        self.assertEqual(check(PREAMBLE + row(ids='("lig:0:0" "lig:0:0")'))["verdict"], "fail")
        self.assertEqual(check(PREAMBLE + row(ids='("foo")'))["verdict"], "fail")
        self.assertEqual(check(PREAMBLE + row(ids='("lig:000:111")'))["verdict"], "fail")  # len 6 > L5
        self.assertEqual(check(PREAMBLE + row(ids='(("lig:0:0"))'))["verdict"], "fail")  # nested

    def test_wrong_universe_counts(self):
        self.assertEqual(check(PREAMBLE + row(rc=391))["verdict"], "fail")
        self.assertEqual(check(PREAMBLE + row(mc=61))["verdict"], "fail")

    def test_stderr_and_exit_code(self):
        self.assertEqual(check(PREAMBLE + row(), stderr="Warning: something\n")["verdict"], "fail")
        self.assertEqual(check(PREAMBLE + row(), exit_code=1)["verdict"], "fail")
        self.assertEqual(check("ERROR: Unknown procedure foo/2\n" + row())["verdict"], "fail")

    def test_trailing_garbage(self):
        self.assertEqual(check(PREAMBLE + row() + "extra\n")["verdict"], "fail")


if __name__ == "__main__":
    unittest.main(verbosity=2)
