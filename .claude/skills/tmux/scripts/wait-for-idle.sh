#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: wait-for-idle.sh -t target [options]

Options:
  -t TARGET   tmux target pane (e.g. %12 or session:window.pane)
  -i SECONDS  poll interval in seconds (default: 1)
  -n COUNT    stable hash checks needed (default: 5)
  -s SECONDS  unchanged duration threshold (default: 10)
  -l LINES    capture tail lines (default: 200)
  -T SECONDS  timeout in seconds, 0 disables timeout (default: 0)
  -L NAME     tmux socket name
  -S PATH     tmux socket path
      --status-only  print only status payload
  -h          show this help
USAGE
}

print_error_and_exit() {
  echo "ERROR: $1" >&2
  exit 2
}

print_idle_and_exit() {
  local tail_text="$1"
  if [[ "$status_only" == true ]]; then
    echo "IDLE: idle"
  else
    echo "IDLE:"
    printf '%s\n' "$tail_text"
  fi
  exit 0
}

print_timeout_and_exit() {
  local tail_text="$1"
  printf 'TIMEOUT: no idle state detected within %ss\n' "$timeout"
  printf '%s\n' "$tail_text"
  exit 1
}

build_tmux_cmd() {
  tmux_cmd=(tmux)
  if [[ -n "$socket_name" && -n "$socket_path" ]]; then
    print_error_and_exit "use either -L or -S, not both"
  fi
  if [[ -n "$socket_name" ]]; then
    tmux_cmd+=(-L "$socket_name")
  elif [[ -n "$socket_path" ]]; then
    tmux_cmd+=(-S "$socket_path")
  fi
}

resolve_pane_meta() {
  local meta
  if ! meta="$(${tmux_cmd[@]} display-message -p -t "$target" '#{pane_id} #{pane_pid}' 2>/dev/null)"; then
    print_error_and_exit "target pane not found: $target"
  fi

  read -r pane_id pane_pid <<<"$meta"
  if [[ -z "$pane_id" || -z "$pane_pid" || "$pane_id" != %* || ! "$pane_pid" =~ ^[0-9]+$ ]]; then
    print_error_and_exit "target pane not found: $target"
  fi
}

pick_hash_cmd() {
  if command -v shasum >/dev/null 2>&1; then
    hash_cmd=(shasum -a 256)
  elif command -v sha256sum >/dev/null 2>&1; then
    hash_cmd=(sha256sum)
  else
    print_error_and_exit "no SHA-256 utility found"
  fi
}

capture_tail() {
  ${tmux_cmd[@]} capture-pane -p -J -t "$pane_id" -S "-$lines"
}

hash_text() {
  local text="$1"
  printf '%s' "$text" | "${hash_cmd[@]}" | awk '{print $1}'
}

target=""
interval=1
stable_count_threshold=5
idle_seconds_threshold=10
lines=200
timeout=0
status_only=false
socket_name=""
socket_path=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -t)
      target="${2:-}"
      shift 2
      ;;
    -i)
      interval="${2:-}"
      shift 2
      ;;
    -n)
      stable_count_threshold="${2:-}"
      shift 2
      ;;
    -s)
      idle_seconds_threshold="${2:-}"
      shift 2
      ;;
    -l)
      lines="${2:-}"
      shift 2
      ;;
    -T)
      timeout="${2:-}"
      shift 2
      ;;
    -L)
      socket_name="${2:-}"
      shift 2
      ;;
    -S)
      socket_path="${2:-}"
      shift 2
      ;;
    --status-only)
      status_only=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      print_error_and_exit "unknown argument: $1"
      ;;
  esac
done

if [[ -z "$target" ]]; then
  print_error_and_exit "target is required"
fi

build_tmux_cmd
resolve_pane_meta
pick_hash_cmd

start_epoch=$(date +%s)
baseline_text="$(capture_tail)"
baseline_hash="$(hash_text "$baseline_text")"
baseline_epoch="$start_epoch"
stable_count=1

while true; do
  now_epoch=$(date +%s)
  if (( timeout > 0 )) && (( now_epoch - start_epoch >= timeout )); then
    print_timeout_and_exit "$baseline_text"
  fi

  current_text="$(capture_tail)"
  current_hash="$(hash_text "$current_text")"

  if [[ "$current_hash" == "$baseline_hash" ]]; then
    stable_count=$((stable_count + 1))
  else
    baseline_hash="$current_hash"
    baseline_epoch="$now_epoch"
    stable_count=1
    baseline_text="$current_text"
  fi

  unchanged_elapsed=$((now_epoch - baseline_epoch))
  if (( stable_count >= stable_count_threshold )) && (( unchanged_elapsed >= idle_seconds_threshold )); then
    print_idle_and_exit "$current_text"
  fi

  sleep "$interval"
done
