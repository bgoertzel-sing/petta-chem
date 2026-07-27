#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$REPO_ROOT"

python3 -m py_compile oracle/raf_oracle.py tests/test_raf_oracle.py
python3 -m unittest -v tests.test_raf_oracle
git diff --check
