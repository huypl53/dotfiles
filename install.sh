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

if [ -n "$missing" ]; then
  log "Installing missing packages:$missing"
  install_packages || true
else
  log "All required packages already installed"
fi

if ! need_cmd curl; then
  die "curl is required to install oh-my-zsh"
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
  log "oh-my-zsh already installed: $HOME/.oh-my-zsh"
else
  log "Installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/install-common.sh"

"$SCRIPT_DIR/install-tmux.sh"

log "Done."
