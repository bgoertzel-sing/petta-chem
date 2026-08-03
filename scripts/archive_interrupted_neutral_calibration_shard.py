#!/usr/bin/env python3
"""Archive an interrupted raw shard and authorize only a whole-shard restart."""

from __future__ import annotations

import argparse
import json
import os
import stat
from datetime import datetime, timezone
from pathlib import Path

from run_neutral_calibration_shard import load_prepared_manifest, sha256


RECOVERY_SCHEMA = "neutral-calibration-whole-shard-recovery-v1"
RECOVERY_POLICY = "restart-entire-shard-no-prefix-reuse"


def metadata_inventory(raw_dir: Path) -> list[dict]:
    inventory = []
    for path in sorted(raw_dir.rglob("*")):
        info = path.lstat()
        if stat.S_ISDIR(info.st_mode):
            kind = "directory"
        elif stat.S_ISREG(info.st_mode):
            kind = "file"
        elif stat.S_ISLNK(info.st_mode):
            kind = "symlink"
        else:
            raise ValueError(f"unsupported raw entry type: {path}")
        inventory.append(
            {
                "path": str(path.relative_to(raw_dir)),
                "kind": kind,
                "size_bytes": info.st_size,
            }
        )
    return inventory


def archive_interrupted_shard(shard_dir: Path, archive_name: str) -> dict:
    manifest_path, manifest = load_prepared_manifest(shard_dir)
    if not archive_name.startswith("raw-interrupted-") or archive_name in {
        "raw-interrupted-",
        "raw-interrupted-.",
        "raw-interrupted-..",
    }:
        raise ValueError("archive name must be a unique raw-interrupted-* basename")
    if Path(archive_name).name != archive_name:
        raise ValueError("archive name must not contain a path")
    if (shard_dir / "RUN_MANIFEST.json").exists():
        raise FileExistsError("RUN_MANIFEST.json exists; recovery is not authorized")

    raw_dir = shard_dir / "raw"
    archive_dir = shard_dir / archive_name
    if not raw_dir.is_dir():
        raise FileNotFoundError("interrupted raw/ directory is absent")
    if archive_dir.exists():
        raise FileExistsError(f"archive target already exists: {archive_dir}")

    inventory = metadata_inventory(raw_dir)
    os.rename(raw_dir, archive_dir)
    plan = {
        "schema": RECOVERY_SCHEMA,
        "policy": RECOVERY_POLICY,
        "status": "whole-shard-restart-authorized-unrun",
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "source_manifest_sha256": sha256(manifest_path),
        "graph_seed": manifest["graph_seed"],
        "planned_run_count": manifest["run_count"],
        "archived_directory": archive_name,
        "raw_content_opened": False,
        "inventory_basis": "lstat-only-no-file-content-read",
        "inventory": inventory,
    }
    (shard_dir / "RECOVERY_PLAN.json").write_text(
        json.dumps(plan, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    return plan


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shard-dir", required=True, type=Path)
    parser.add_argument("--archive-name", required=True)
    args = parser.parse_args()
    plan = archive_interrupted_shard(args.shard_dir, args.archive_name)
    print(
        f"{plan['status']}: {plan['archived_directory']}; "
        f"restart all {plan['planned_run_count']} rows"
    )


if __name__ == "__main__":
    main()
