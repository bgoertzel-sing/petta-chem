#!/usr/bin/env python3
"""Durable, outcome-blind execution of one prepared neutral shard attempt."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import subprocess
import uuid
from datetime import datetime, timezone
from pathlib import Path

from run_neutral_calibration_shard import load_prepared_manifest


ATTEMPT_SCHEMA = "neutral-calibration-raw-attempt-v2"
RECEIPT_SCHEMA = "neutral-calibration-row-receipt-v2"
RUN_SCHEMA = "neutral-calibration-raw-shard-v2"


class SyntheticInterruption(RuntimeError):
    """Test-only stand-in for process termination at a durability boundary."""


def now() -> str:
    return datetime.now(timezone.utc).isoformat()


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def fsync_directory(path: Path) -> None:
    descriptor = os.open(path, os.O_RDONLY)
    try:
        os.fsync(descriptor)
    finally:
        os.close(descriptor)


def atomic_json(path: Path, value: dict) -> None:
    temporary = path.with_name(f".{path.name}.{uuid.uuid4().hex}.tmp")
    with temporary.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2, sort_keys=True)
        handle.write("\n")
        handle.flush()
        os.fsync(handle.fileno())
    os.replace(temporary, path)
    fsync_directory(path.parent)


def safe_relative(root: Path, relative: str) -> Path:
    candidate = root / relative
    try:
        candidate.resolve().relative_to(root.resolve())
    except ValueError as exc:
        raise ValueError("path escapes its declared root") from exc
    return candidate


def row_stem(row: dict) -> str:
    return f"{row['index']:03d}-{row['id']}"


def identity_for(
    manifest_path: Path,
    manifest: dict,
    runner: Path,
    attempt_id: str,
    source_commit: str,
    runtime_identity: str,
) -> dict:
    return {
        "schema": ATTEMPT_SCHEMA,
        "status": "running-unanalysed",
        "attempt_id": attempt_id,
        "source_manifest_sha256": sha256(manifest_path),
        "source_commit": source_commit,
        "runner_path": str(runner.resolve()),
        "runner_sha256": sha256(runner),
        "runtime_identity": runtime_identity,
        "planned_run_count": manifest["run_count"],
        "query_sha256": [
            sha256(safe_relative(manifest_path.parent, row["query"]))
            for row in manifest["rows"]
        ],
    }


def refuse_v1_attempt_artifacts(attempt_dir: Path) -> None:
    if not attempt_dir.exists():
        return
    forbidden = ["RECOVERY_PLAN.json"] if (attempt_dir / "RECOVERY_PLAN.json").exists() else []
    forbidden.extend(path.name for path in attempt_dir.glob("raw-interrupted-*"))
    run_manifest = attempt_dir / "RUN_MANIFEST.json"
    if run_manifest.is_file():
        try:
            schema = json.loads(run_manifest.read_text(encoding="utf-8")).get("schema")
        except (json.JSONDecodeError, OSError):
            schema = "unreadable"
        if schema != RUN_SCHEMA:
            forbidden.append("RUN_MANIFEST.json")
    if forbidden:
        raise ValueError("v1 or foreign artifacts are not a resumable v2 attempt")


def validate_identity(attempt_path: Path, expected: dict) -> dict:
    actual = json.loads(attempt_path.read_text(encoding="utf-8"))
    for key, value in expected.items():
        if key == "status":
            continue
        if actual.get(key) != value:
            raise ValueError(f"attempt identity mismatch: {key}")
    if actual.get("status") != "running-unanalysed":
        raise ValueError("attempt is not resumable")
    return actual


def expected_receipt(row: dict, attempt: dict, shard_dir: Path, attempt_dir: Path) -> dict:
    stem = row_stem(row)
    query = safe_relative(shard_dir, row["query"])
    stdout = attempt_dir / "raw" / f"{stem}.stdout"
    stderr = attempt_dir / "raw" / f"{stem}.stderr"
    return {
        "schema": RECEIPT_SCHEMA,
        "attempt_id": attempt["attempt_id"],
        "source_manifest_sha256": attempt["source_manifest_sha256"],
        "source_commit": attempt["source_commit"],
        "runner_sha256": attempt["runner_sha256"],
        "runtime_identity": attempt["runtime_identity"],
        "index": row["index"],
        "id": row["id"],
        "query": row["query"],
        "query_sha256": sha256(query),
        "stdout": str(stdout.relative_to(attempt_dir)),
        "stdout_sha256": sha256(stdout),
        "stderr": str(stderr.relative_to(attempt_dir)),
        "stderr_sha256": sha256(stderr),
        "exit_code": 0,
    }


def validate_prefix(manifest: dict, shard_dir: Path, attempt_dir: Path, attempt: dict) -> int:
    receipt_dir = attempt_dir / "receipts"
    raw_dir = attempt_dir / "raw"
    receipt_files = sorted(receipt_dir.iterdir())
    if any(not path.is_file() or path.suffix != ".json" for path in receipt_files):
        raise ValueError("unexpected receipt artifact")
    if len(receipt_files) > manifest["run_count"]:
        raise ValueError("too many receipts")

    expected_raw = set()
    for position, receipt_path in enumerate(receipt_files):
        row = manifest["rows"][position]
        if receipt_path.name != f"{row_stem(row)}.json":
            raise ValueError("receipt gap, duplicate, or ordering mismatch")
        receipt = json.loads(receipt_path.read_text(encoding="utf-8"))
        if receipt.get("exit_code") != 0:
            raise ValueError("nonzero receipt invalidates attempt")
        expected = expected_receipt(row, attempt, shard_dir, attempt_dir)
        for key, value in expected.items():
            if receipt.get(key) != value:
                raise ValueError(f"receipt mismatch: {key}")
        if not isinstance(receipt.get("completed_utc"), str):
            raise ValueError("receipt lacks completion timestamp")
        expected_raw.update({receipt["stdout"], receipt["stderr"]})

    actual_raw = {
        str(path.relative_to(attempt_dir))
        for path in raw_dir.iterdir()
        if path.is_file()
    }
    unexpected_types = [path for path in raw_dir.iterdir() if not path.is_file()]
    if unexpected_types:
        raise ValueError("unexpected raw artifact type")
    extras = actual_raw - expected_raw
    if extras:
        next_index = len(receipt_files)
        if next_index >= manifest["run_count"]:
            raise ValueError("unexpected raw file after complete prefix")
        next_stem = row_stem(manifest["rows"][next_index])
        allowed = {f"raw/{next_stem}.stdout", f"raw/{next_stem}.stderr"}
        if not extras <= allowed:
            raise ValueError("unexpected raw file outside next unreceipted row")
        quarantine = attempt_dir / "quarantine" / f"row-{next_index:03d}-{uuid.uuid4().hex}"
        quarantine.mkdir(parents=True)
        for relative in sorted(extras):
            os.replace(attempt_dir / relative, quarantine / Path(relative).name)
        fsync_directory(raw_dir)
        fsync_directory(quarantine)
    return len(receipt_files)


def run_shard_v2(
    shard_dir: Path,
    runner: Path,
    attempt_dir: Path,
    attempt_id: str,
    source_commit: str,
    runtime_identity: str,
    *,
    interrupt_after_receipt: int | None = None,
    interrupt_before_receipt: int | None = None,
) -> dict:
    shard_dir = shard_dir.resolve()
    attempt_dir = attempt_dir.resolve()
    if shard_dir == attempt_dir:
        raise ValueError("v1 shard directory cannot be used as a v2 attempt")
    manifest_path, manifest = load_prepared_manifest(shard_dir)
    if [row.get("index") for row in manifest["rows"]] != list(range(manifest["run_count"])):
        raise ValueError("manifest rows must have unique contiguous indices in order")
    if len({row.get("id") for row in manifest["rows"]}) != manifest["run_count"]:
        raise ValueError("manifest row IDs must be unique")
    runner = runner.resolve()
    expected_identity = identity_for(
        manifest_path, manifest, runner, attempt_id, source_commit, runtime_identity
    )
    refuse_v1_attempt_artifacts(attempt_dir)

    attempt_path = attempt_dir / "ATTEMPT.json"
    if not attempt_dir.exists():
        attempt_dir.mkdir(parents=True)
        (attempt_dir / "raw").mkdir()
        (attempt_dir / "receipts").mkdir()
        atomic_json(attempt_path, {**expected_identity, "created_utc": now()})
    else:
        if not attempt_path.is_file():
            raise ValueError("existing directory is not a v2 attempt")
        for required in (attempt_dir / "raw", attempt_dir / "receipts"):
            if not required.is_dir():
                raise ValueError("v2 attempt layout is incomplete")
    attempt = validate_identity(attempt_path, expected_identity)
    if (attempt_dir / "FAILED.json").exists():
        raise ValueError("failed attempt cannot be resumed")
    if (attempt_dir / "RUN_MANIFEST.json").exists():
        raise ValueError("completed attempt cannot be resumed")

    prefix = validate_prefix(manifest, shard_dir, attempt_dir, attempt)
    for index, expected_hash in enumerate(attempt["query_sha256"]):
        if sha256(safe_relative(shard_dir, manifest["rows"][index]["query"])) != expected_hash:
            raise ValueError("query hash mismatch")

    for row in manifest["rows"][prefix:]:
        stem = row_stem(row)
        output = attempt_dir / "raw" / f"{stem}.stdout"
        error = attempt_dir / "raw" / f"{stem}.stderr"
        with output.open("xb") as stdout, error.open("xb") as stderr:
            proc = subprocess.run(
                ["sh", str(runner), str(safe_relative(shard_dir, row["query"]))],
                stdout=stdout,
                stderr=stderr,
                check=False,
            )
            stdout.flush()
            stderr.flush()
            os.fsync(stdout.fileno())
            os.fsync(stderr.fileno())
        fsync_directory(attempt_dir / "raw")
        if proc.returncode != 0:
            atomic_json(
                attempt_dir / "FAILED.json",
                {
                    "schema": "neutral-calibration-failed-attempt-v2",
                    "attempt_id": attempt_id,
                    "row_index": row["index"],
                    "row_id": row["id"],
                    "exit_code": proc.returncode,
                    "failed_utc": now(),
                },
            )
            raise RuntimeError(f"row {row['index']} exited nonzero; attempt invalidated")
        if interrupt_before_receipt == row["index"]:
            raise SyntheticInterruption("interrupted before receipt publication")
        receipt = expected_receipt(row, attempt, shard_dir, attempt_dir)
        receipt["completed_utc"] = now()
        atomic_json(attempt_dir / "receipts" / f"{stem}.json", receipt)
        if interrupt_after_receipt == row["index"]:
            raise SyntheticInterruption("interrupted after receipt publication")

    receipts = sorted((attempt_dir / "receipts").glob("*.json"))
    run_manifest = {
        "schema": RUN_SCHEMA,
        "status": "raw-complete-unanalysed",
        "attempt_id": attempt_id,
        "source_manifest_sha256": attempt["source_manifest_sha256"],
        "source_commit": source_commit,
        "runner_sha256": attempt["runner_sha256"],
        "runtime_identity": runtime_identity,
        "graph_seed": manifest["graph_seed"],
        "planned_run_count": manifest["run_count"],
        "completed_run_count": len(receipts),
        "receipt_sha256": [sha256(path) for path in receipts],
        "finished_utc": now(),
    }
    atomic_json(attempt_dir / "RUN_MANIFEST.json", run_manifest)
    return run_manifest


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shard-dir", required=True, type=Path)
    parser.add_argument("--runner", required=True, type=Path)
    parser.add_argument("--attempt-dir", required=True, type=Path)
    parser.add_argument("--attempt-id", required=True)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--runtime-identity", required=True)
    args = parser.parse_args()
    result = run_shard_v2(**vars(args))
    print(f"{result['status']}: {result['completed_run_count']}/{result['planned_run_count']} raw rows")


if __name__ == "__main__":
    main()
