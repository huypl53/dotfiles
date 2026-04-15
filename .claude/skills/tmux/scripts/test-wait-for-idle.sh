#!/usr/bin/env bash
set -euo pipefail

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux is required for tests"
  exit 1
fi

SCRIPT="./scripts/wait-for-idle.sh"
SOCKET_DIR="${CLAUDE_TMUX_SOCKET_DIR:-${TMPDIR:-/tmp}/claude-tmux-sockets}"
mkdir -p "$SOCKET_DIR"
SOCKET="$SOCKET_DIR/test-wait-for-idle-$$.sock"

cleanup() {
  tmux -S "$SOCKET" kill-server >/dev/null 2>&1 || true
  rm -f "$SOCKET"
}
trap cleanup EXIT

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

new_session() {
  local name="$1"
  local cmd="$2"
  tmux -S "$SOCKET" new-session -d -s "$name" -n shell "$cmd"
}

# missing target validation
run_capture output status "$SCRIPT"
[[ "$status" -eq 2 ]] || { echo "expected exit 2 for missing target, got $status"; exit 1; }
grep -q '^ERROR:' <<<"$output" || { echo "expected ERROR payload for missing target"; exit 1; }
echo "ok: missing target validation"

# socket arg conflict
run_capture conflict_out conflict_status "$SCRIPT" -t %1 -S /tmp/a.sock -L x
[[ "$conflict_status" -eq 2 ]] || { echo "expected exit 2 for -L/-S conflict, got $conflict_status"; exit 1; }
grep -q '^ERROR:' <<<"$conflict_out" || { echo "expected ERROR prefix for -L/-S conflict"; exit 1; }
echo "ok: socket conflict validation"

# unknown target on isolated socket
new_session known "sleep 60"
run_capture bad_out bad_status "$SCRIPT" -S "$SOCKET" -t %999999 -T 1
[[ "$bad_status" -eq 2 ]] || { echo "expected exit 2 for unknown target, got $bad_status"; exit 1; }
grep -q '^ERROR:' <<<"$bad_out" || { echo "expected ERROR prefix for unknown target"; exit 1; }
echo "ok: unknown target validation"

# help output
help_out="$($SCRIPT -h)"
grep -q 'Usage:' <<<"$help_out" || { echo "expected usage"; exit 1; }
echo "ok: help output"

# timeout prefix should be TIMEOUT: for changing pane text
new_session busy 'sh -c "while true; do date +%s%N; sleep 0.2; done"'
busy_target="busy:0.0"
run_capture timeout_out timeout_status "$SCRIPT" -S "$SOCKET" -t "$busy_target" -n 3 -s 2 -i 1 -T 4 --status-only
[[ "$timeout_status" -eq 1 ]] || { echo "expected exit 1 timeout for busy target, got $timeout_status"; exit 1; }
grep -q '^TIMEOUT:' <<<"$timeout_out" || { echo "expected TIMEOUT prefix"; exit 1; }
echo "ok: timeout prefix"

# silent CPU-bound process should not be considered idle
new_session cpu_busy 'sh -c "while :; do :; done"'
cpu_target="cpu_busy:0.0"
run_capture cpu_out cpu_status "$SCRIPT" -S "$SOCKET" -t "$cpu_target" -n 5 -s 3 -i 1 -T 6 --status-only
[[ "$cpu_status" -eq 1 ]] || { echo "expected timeout exit 1 for CPU-busy pane, got $cpu_status"; exit 1; }
grep -q '^TIMEOUT:' <<<"$cpu_out" || { echo "expected TIMEOUT prefix for CPU-busy pane"; exit 1; }
echo "ok: CPU-busy pane is not idle"

# quiet pane should report deterministic idle payloads
new_session quiet 'sh -c "printf ready\\n; sleep 60"'
quiet_target="quiet:0.0"

run_capture quiet_status_out quiet_status "$SCRIPT" -S "$SOCKET" -t "$quiet_target" --status-only -n 3 -s 2 -i 1 -T 10
[[ "$quiet_status" -eq 0 ]] || { echo "expected idle exit 0 for quiet pane status-only, got $quiet_status"; exit 1; }
[[ "$quiet_status_out" == "IDLE: idle" ]] || { echo "unexpected status-only payload: $quiet_status_out"; exit 1; }
echo "ok: quiet pane status-only idle payload"

run_capture quiet_default_out quiet_default_status "$SCRIPT" -S "$SOCKET" -t "$quiet_target" -l 20 -n 3 -s 2 -i 1 -T 10
[[ "$quiet_default_status" -eq 0 ]] || { echo "expected idle exit 0 for quiet pane default output, got $quiet_default_status"; exit 1; }
grep -q '^IDLE: pane became idle' <<<"$quiet_default_out" || { echo "missing deterministic idle header"; exit 1; }
grep -q 'ready' <<<"$quiet_default_out" || { echo "expected pane tail text in default idle output"; exit 1; }
echo "ok: quiet pane default idle payload"

echo "all wait-for-idle checks passed"
