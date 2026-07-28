#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
WORKSPACE=${WORKSPACE:-/home/openclaw/research-agent}
SWI_PREFIX=${SWI_PREFIX:-$WORKSPACE/projects/omegaclaw/local/swipl-9.3.36}

export PATH="$SWI_PREFIX/bin:$PATH"
export SWI_HOME_DIR="$SWI_PREFIX/lib/swipl"
export LD_LIBRARY_PATH="$SWI_PREFIX/lib/swipl/lib/x86_64-linux:${LD_LIBRARY_PATH:-}"
export PYTHONPATH="$REPO_ROOT${PYTHONPATH:+:$PYTHONPATH}"

exec python3 "$REPO_ROOT/scripts/compare_generated_raf_oracle.py" "$@"
