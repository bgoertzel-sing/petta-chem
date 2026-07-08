#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
exec python3 "$REPO_ROOT/scripts/write_exp03_productive_cap_files.py" "$@"
