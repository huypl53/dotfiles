#!/usr/bin/env sh
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      echo "unknown" ;;
  esac
}

OS="$(detect_os)"
log "Detected OS: $OS"

case "$OS" in
  macos)
    . "$SCRIPT_DIR/install-macos.sh"
    ;;
  linux)
    . "$SCRIPT_DIR/install-linux.sh"
    ;;
  *)
    die "Unsupported OS: $(uname -s)"
    ;;
esac

. "$SCRIPT_DIR/install-common.sh"

log "Done. If you use tmux, press prefix + I to install plugins."
