#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
WORKSPACE=${WORKSPACE:-/home/openclaw/research-agent}
PETTA_DIR=${PETTA_DIR:-$WORKSPACE/projects/omegaclaw/repos/PeTTa}
SWI_PREFIX=${SWI_PREFIX:-$WORKSPACE/projects/omegaclaw/local/swipl-9.3.36}
PETTA_RUNNER=${PETTA_RUNNER:-$PETTA_DIR/run.sh}

export PATH="$SWI_PREFIX/bin:$PATH"
export SWI_HOME_DIR="$SWI_PREFIX/lib/swipl"
export LD_LIBRARY_PATH="$SWI_PREFIX/lib/swipl/lib/x86_64-linux:${LD_LIBRARY_PATH:-}"

exec sh "$PETTA_RUNNER" "$REPO_ROOT/experiments/exp05/smoke.metta"
