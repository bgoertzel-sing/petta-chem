#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)

python3 -m py_compile \
  "$REPO_ROOT/experiments/exp04/run_rich_raf.py" \
  "$REPO_ROOT/experiments/exp04/test_first_class_catalysis.py"
python3 "$REPO_ROOT/experiments/exp04/test_first_class_catalysis.py"
"$REPO_ROOT/scripts/run_exp04.sh"
git -C "$REPO_ROOT" diff --check
