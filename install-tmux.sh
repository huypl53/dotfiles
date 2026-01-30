#!/usr/bin/env sh
set -eu

log() {
  printf '%s\n' "$*"
}

# Install TPM (Tmux Plugin Manager)
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR/.git" ]; then
  log "Updating tmux plugin manager"
  git -C "$TPM_DIR" pull --ff-only
elif [ -d "$TPM_DIR" ]; then
  log "TPM directory exists but is not a git repo: $TPM_DIR"
  log "Delete it and re-run to install TPM."
else
  log "Installing tmux plugin manager"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install Catppuccin tmux theme
CATPPUCCIN_DIR="$HOME/.config/tmux/plugins/catppuccin/tmux"
if [ -d "$CATPPUCCIN_DIR/.git" ]; then
  log "Catppuccin tmux theme already installed"
elif [ -d "$CATPPUCCIN_DIR" ]; then
  log "Catppuccin directory exists but is not a git repo: $CATPPUCCIN_DIR"
  log "Delete it and re-run to install."
else
  log "Installing Catppuccin tmux theme"
  mkdir -p ~/.config/tmux/plugins/catppuccin
  git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$CATPPUCCIN_DIR"
fi

log "Tmux setup complete. Press prefix + I inside tmux to install plugins."
