#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

"$REPO_ROOT/scripts/write_exp06_bridge_path_files.sh" --output-root "$TMP_DIR/out"

test -f "$TMP_DIR/out/CONFIG.metta"
test -f "$TMP_DIR/out/NODE_EVALUATIONS.metta"
test -f "$TMP_DIR/out/PATHS.metta"
test -f "$TMP_DIR/out/SUMMARY.metta"
test -f "$TMP_DIR/out/RUN.md"

grep -F "(exp06-bridge-path-config" "$TMP_DIR/out/CONFIG.metta" >/dev/null
grep -F "host-role path-search-bookkeeping-and-serialization-only" "$TMP_DIR/out/CONFIG.metta" >/dev/null
grep -F "(node-evaluation catalyst-assignment:specific-template cost 1 status reaches-raf-positive-territory" "$TMP_DIR/out/NODE_EVALUATIONS.metta" >/dev/null
grep -F "(node-evaluation candidate-pool-cap:cap-2 cost 1 status dynamic-test-required" "$TMP_DIR/out/NODE_EVALUATIONS.metta" >/dev/null
grep -F "(winning-path cost 1 nodes (initial catalyst-assignment:specific-template) status reaches-raf-positive-territory" "$TMP_DIR/out/PATHS.metta" >/dev/null
grep -F "(alternate-path cost 1 node catalyst-assignment:broad-template status reaches-raf-positive-territory)" "$TMP_DIR/out/PATHS.metta" >/dev/null
grep -F "(alternate-path cost 1 node catalysis-map-offset:shuffled-9 status offset-sensitive-raf-like-control)" "$TMP_DIR/out/PATHS.metta" >/dev/null
grep -F "caveat diagnostic-bridge-not-emergence-claim" "$TMP_DIR/out/SUMMARY.metta" >/dev/null
grep -F "emergence-claim none" "$TMP_DIR/out/SUMMARY.metta" >/dev/null

echo "exp06 bridge path-search artifact writer test passed"
