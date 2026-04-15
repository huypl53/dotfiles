#!/usr/bin/env bash
set -euo pipefail

run_capture() {
  local __out_var="$1"
  local __status_var="$2"
  shift 2

  local _cmd_out
  local _cmd_status

  set +e
  _cmd_out="$("$@" 2>&1)"
  _cmd_status=$?
  set -e

  printf -v "$__out_var" '%s' "$_cmd_out"
  printf -v "$__status_var" '%s' "$_cmd_status"
}

run_capture output status ./scripts/wait-for-idle.sh
if [[ "$status" -ne 2 ]]; then
  echo "expected exit 2 for missing target, got $status"
  exit 1
fi
if ! grep -q '^ERROR:' <<<"$output"; then
  echo "expected ERROR payload for missing target"
  exit 1
fi

echo "ok: missing target validation"

run_capture conflict_out conflict_status ./scripts/wait-for-idle.sh -t %1 -S /tmp/a.sock -L x
if [[ "$conflict_status" -ne 2 ]]; then
  echo "expected exit 2 for -L/-S conflict, got $conflict_status"
  exit 1
fi
if ! grep -q '^ERROR:' <<<"$conflict_out"; then
  echo "expected ERROR prefix for -L/-S conflict"
  exit 1
fi

echo "ok: socket conflict validation"

run_capture bad_out bad_status ./scripts/wait-for-idle.sh -t %999999 -T 1
if [[ "$bad_status" -ne 2 ]]; then
  echo "expected exit 2 for unknown target, got $bad_status"
  exit 1
fi
if ! grep -q '^ERROR:' <<<"$bad_out"; then
  echo "expected ERROR prefix for unknown target"
  exit 1
fi

echo "ok: unknown target validation"
