#!/usr/bin/env python3
"""Compare PeTTa RAF truth with the independent oracle on the frozen tiny gate."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

from oracle.raf_oracle import exhaustive_raf, load_system


REPO = Path(__file__).resolve().parents[1]
WORKSPACE = Path(os.environ.get("WORKSPACE", "/home/openclaw/research-agent"))
DEFAULT_RUNNER = WORKSPACE / "projects/omegaclaw/repos/PeTTa/run.sh"
TOKEN = re.compile(r'"(?:[^"\\]|\\.)*"|[()]|[^\s()]+')


def parse_sexpr(text: str):
    tokens = TOKEN.findall(text)

    def parse(index: int):
        token = tokens[index]
        if token == "(":
            result = []
            index += 1
            while tokens[index] != ")":
                item, index = parse(index)
                result.append(item)
            return result, index + 1
        if token.startswith('"'):
            return json.loads(token), index + 1
        try:
            return int(token), index + 1
        except ValueError:
            return token, index + 1

    value, end = parse(0)
    if end != len(tokens):
        raise ValueError("trailing tokens in PeTTa record")
    return value


def canonical_subsets(rows) -> frozenset[tuple[str, ...]]:
    return frozenset(tuple(sorted(row)) for row in rows)


def payload_from_record(record):
    _, seed, f_value, food, reactions, catalysis, _, _, _ = record
    return {
        "model": "neutral-crs-v1",
        "system_id": f"generated-l3-{seed}-{f_value}",
        "food": sorted(food),
        "reactions": sorted(
            (
                {
                    "id": row[2],
                    "reactants": sorted(row[4]),
                    "products": sorted(row[6]),
                }
                for row in reactions
            ),
            key=lambda row: row["id"],
        ),
        "catalysis": sorted(
            (
                {"catalyst": row[2], "reaction": row[3]}
                for row in catalysis
            ),
            key=lambda row: (row["catalyst"], row["reaction"]),
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--petta-runner", type=Path, default=DEFAULT_RUNNER)
    parser.add_argument(
        "--manifest",
        type=Path,
        default=REPO / "artifacts/neutral_raf_generated_gate_manifest.json",
    )
    parser.add_argument("--seed-start", type=int, default=1)
    parser.add_argument("--seed-end", type=int, default=100)
    args = parser.parse_args()

    queries = "\n".join(
        f"!(neutral-raf-l3-generated-record {seed} {f_value})"
        for seed in range(args.seed_start, args.seed_end + 1)
        for f_value in (0, 1, 2, 4)
    )
    source = f"!(import! &self {REPO / 'src/chem_neutral_raf.metta'})\n{queries}\n"
    with tempfile.NamedTemporaryFile("w", suffix=".metta", delete=False) as handle:
        handle.write(source)
        query_path = Path(handle.name)
    try:
        completed = subprocess.run(
            ["sh", str(args.petta_runner), str(query_path)],
            cwd=REPO,
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    finally:
        query_path.unlink(missing_ok=True)

    records = []
    for line in completed.stdout.splitlines():
        line = line.strip()
        if line.startswith("(generated-raf-record "):
            records.append(parse_sexpr(line))
        elif line.startswith("[(generated-raf-record ") and line.endswith("]"):
            records.append(parse_sexpr(line[1:-1]))

    expected_count = (args.seed_end - args.seed_start + 1) * 4
    if len(records) != expected_count:
        raise RuntimeError(
            f"expected {expected_count} PeTTa records, received {len(records)}"
        )

    digest_rows = []
    for record in records:
        payload = payload_from_record(record)
        oracle = exhaustive_raf(load_system(payload))
        petta_rafs = canonical_subsets(record[6])
        petta_maximal = tuple(sorted(record[7]))
        petta_irrafs = canonical_subsets(record[8])
        if (
            petta_rafs != oracle.raf_subsets
            or petta_maximal != oracle.maximal_raf
            or petta_irrafs != oracle.irreducible_rafs
        ):
            raise AssertionError(
                f"RAF mismatch at seed={record[1]} f={record[2]}"
            )
        digest_rows.append(
            {
                "seed": record[1],
                "f": record[2],
                "system_sha256": hashlib.sha256(
                    json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
                ).hexdigest(),
                "truth_sha256": hashlib.sha256(
                    repr(
                        (
                            sorted(oracle.raf_subsets),
                            oracle.maximal_raf,
                            sorted(oracle.irreducible_rafs),
                        )
                    ).encode()
                ).hexdigest(),
            }
        )

    source_commit = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=REPO,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    ).stdout.strip()
    runtime_dir = args.petta_runner.resolve().parent
    runtime_commit = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=runtime_dir,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    ).stdout.strip()
    detector_source = REPO / "src/chem_neutral_raf.metta"
    manifest = {
        "protocol": "neutral-crs-v1",
        "gate": "generated-l3-exhaustive-raf-oracle",
        "status": "pass",
        "seed_range": [args.seed_start, args.seed_end],
        "catalysis_f": [0, 1, 2, 4],
        "reactions_per_system": 8,
        "comparison_count": len(records),
        "subset_classifications_per_system": 255,
        "exact_fields": ["all_subsets", "maximal_raf", "all_irreducible_rafs"],
        "source_commit_before_gate_artifact": source_commit,
        "detector_source_sha256": hashlib.sha256(
            detector_source.read_bytes()
        ).hexdigest(),
        "petta_runtime_commit": runtime_commit,
        "outcome_embargo": "structural incidence and calibration endpoints not reported",
        "comparisons_sha256": hashlib.sha256(
            json.dumps(digest_rows, sort_keys=True, separators=(",", ":")).encode()
        ).hexdigest(),
    }
    args.manifest.parent.mkdir(parents=True, exist_ok=True)
    args.manifest.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    try:
        manifest_label = args.manifest.relative_to(REPO)
    except ValueError:
        manifest_label = args.manifest
    print(
        f"PASS: {len(records)} PeTTa/oracle comparisons; "
        f"manifest={manifest_label}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
