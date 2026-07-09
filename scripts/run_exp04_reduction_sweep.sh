#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
OUT_DIR=${1:-$REPO_ROOT/experiments/exp04_reduction_sweep_20260708}

exec python3 "$REPO_ROOT/experiments/exp04/run_reduction_sweep.py" --out-dir "$OUT_DIR"
