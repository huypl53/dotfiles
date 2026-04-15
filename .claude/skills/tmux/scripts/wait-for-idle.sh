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
      echo "ERROR: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$target" ]]; then
  echo "ERROR: target is required" >&2
  usage >&2
  exit 2
fi

if [[ "$status_only" == true ]]; then
  echo "IDLE: idle"
else
  echo "IDLE:"
fi
exit 0
