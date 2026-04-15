#!/usr/bin/env bash
set -euo pipefail

set +e
output="$(./scripts/wait-for-idle.sh 2>&1)"
status=$?
set -e

if [[ $status -ne 2 ]]; then
  echo "expected exit 2 for missing target, got $status"
  exit 1
fi
if ! grep -q '^ERROR:' <<<"$output"; then
  echo "expected ERROR payload for missing target"
  exit 1
fi

echo "ok: missing target validation"
