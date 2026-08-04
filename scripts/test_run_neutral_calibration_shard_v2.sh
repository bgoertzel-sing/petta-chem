#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH="$SCRIPT_DIR" \
  python3 "$SCRIPT_DIR/test_run_neutral_calibration_shard_v2.py"
