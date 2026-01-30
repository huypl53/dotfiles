#!/usr/bin/env sh
set -eu

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

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif need_cmd sudo; then
    sudo "$@"
  else
    die "sudo not found; run as root to install packages"
  fi
}

install_packages() {
  if need_cmd apt-get; then
    as_root apt-get update
    as_root apt-get install -y tmux zsh curl git
  elif need_cmd apt; then
    as_root apt update
    as_root apt install -y tmux zsh curl git
  elif need_cmd dnf; then
    as_root dnf install -y tmux zsh curl git
  elif need_cmd yum; then
    as_root yum install -y tmux zsh curl git
  elif need_cmd pacman; then
    as_root pacman -Sy --noconfirm tmux zsh curl git
  elif need_cmd apk; then
    as_root apk add --no-cache tmux zsh curl git
  elif need_cmd zypper; then
    as_root zypper install -y tmux zsh curl git
  elif need_cmd brew; then
    brew install tmux zsh curl git
  else
    log "No supported package manager found. Install manually: tmux zsh curl git"
    return 1
  fi
}

missing=""
for cmd in tmux zsh curl git; do
  if ! need_cmd "$cmd"; then
    missing="$missing $cmd"
  fi
done

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
"$SCRIPT_DIR/install-tmux.sh"

log "Done."
