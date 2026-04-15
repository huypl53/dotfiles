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

time_to_seconds() {
  local raw="$1"
  local cleaned
  local fractionless

  cleaned="$(echo "$raw" | tr -d '[:space:]')"
  fractionless="${cleaned%%.*}"

  local days=0
  local rest="$fractionless"
  if [[ "$rest" == *-* ]]; then
    days="${rest%%-*}"
    rest="${rest#*-}"
  fi

  local h=0
  local m=0
  local s=0

  IFS=':' read -r a b c <<<"$rest"
  if [[ -n "${c:-}" ]]; then
    h="$a"
    m="$b"
    s="$c"
  elif [[ -n "${b:-}" ]]; then
    m="$a"
    s="$b"
  else
    s="$a"
  fi

  echo $((10#$days * 86400 + 10#$h * 3600 + 10#$m * 60 + 10#$s))
}

collect_descendants() {
  local root_pid="$1"
  local queue=()
  local seen=()

  queue+=("$root_pid")
  seen+=("$root_pid")

  while [[ ${#queue[@]} -gt 0 ]]; do
    local current="${queue[0]}"
    queue=("${queue[@]:1}")

    while IFS= read -r child; do
      [[ -z "$child" ]] && continue
      if [[ " ${seen[*]} " != *" $child "* ]]; then
        seen+=("$child")
        queue+=("$child")
      fi
    done < <(pgrep -P "$current" 2>/dev/null || true)
  done

  printf '%s\n' "${seen[@]}"
}

cpu_total_seconds() {
  local pids=("$@")
  [[ ${#pids[@]} -gt 0 ]] || {
    echo 0
    return
  }

  local pid_csv
  pid_csv="$(IFS=,; echo "${pids[*]}")"

  local total=0
  while IFS= read -r t; do
    [[ -z "$t" ]] && continue
    local sec
    sec="$(time_to_seconds "$t")"
    total=$((total + sec))
  done < <(ps -o time= -p "$pid_csv" 2>/dev/null || true)

  echo "$total"
}

current_cpu_total() {
  local descendants
  descendants="$(collect_descendants "$pane_pid")"

  local pid_list=()
  while IFS= read -r pid; do
    [[ -z "$pid" ]] && continue
    pid_list+=("$pid")
  done <<<"$descendants"

  cpu_total_seconds "${pid_list[@]}"
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
baseline_cpu="$(current_cpu_total)"
stable_count=1

while true; do
  now_epoch=$(date +%s)
  if (( timeout > 0 )) && (( now_epoch - start_epoch >= timeout )); then
    print_timeout_and_exit "$baseline_text"
  fi

  current_text="$(capture_tail)"
  current_hash="$(hash_text "$current_text")"
  cpu_now="$(current_cpu_total)"

  if [[ "$current_hash" == "$baseline_hash" ]]; then
    stable_count=$((stable_count + 1))
    unchanged_elapsed=$((now_epoch - baseline_epoch))
    cpu_delta=$((cpu_now - baseline_cpu))
  else
    baseline_hash="$current_hash"
    baseline_epoch="$now_epoch"
    baseline_cpu="$cpu_now"
    stable_count=1
    unchanged_elapsed=0
    cpu_delta=0
    baseline_text="$current_text"
  fi

  if (( stable_count >= stable_count_threshold )) \
    && (( unchanged_elapsed >= idle_seconds_threshold )) \
    && (( cpu_delta <= 0 )); then
    print_idle_and_exit "$current_text"
  fi

  sleep "$interval"
done
