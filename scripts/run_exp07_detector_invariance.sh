#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
OUTPUT=${1:-/tmp/petta-chem-exp07-detector-invariance.json}

exec python3 "$REPO_ROOT/experiments/exp07/check_detector_invariance.py" --out "$OUTPUT"
