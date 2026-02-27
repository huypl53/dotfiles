# Common installation (sourced by install.sh)

if ! need_cmd curl; then
  die "curl is required for installation"
fi

# Rust and cargo
if need_cmd cargo; then
  log "cargo already installed"
else
  log "Installing rustup and cargo"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
fi

# grip-grab
if need_cmd gg; then
  log "grip-grab already installed"
else
  log "Installing grip-grab"
  cargo install grip-grab
fi

# zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
if [ -d "$AUTOSUGGESTIONS_DIR/.git" ]; then
  log "Updating zsh-autosuggestions"
  git -C "$AUTOSUGGESTIONS_DIR" pull --ff-only
elif [ -d "$AUTOSUGGESTIONS_DIR" ]; then
  log "zsh-autosuggestions directory exists but is not a git repo: $AUTOSUGGESTIONS_DIR"
else
  log "Installing zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
fi

SYNTAX_HIGHLIGHTING_DIR="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
if [ -d "$SYNTAX_HIGHLIGHTING_DIR/.git" ]; then
  log "Updating zsh-syntax-highlighting"
  git -C "$SYNTAX_HIGHLIGHTING_DIR" pull --ff-only
elif [ -d "$SYNTAX_HIGHLIGHTING_DIR" ]; then
  log "zsh-syntax-highlighting directory exists but is not a git repo: $SYNTAX_HIGHLIGHTING_DIR"
else
  log "Installing zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$SYNTAX_HIGHLIGHTING_DIR"
fi

ZSH_Z_DIR="$ZSH_CUSTOM/plugins/zsh-z"
if [ -d "$ZSH_Z_DIR/.git" ]; then
  log "Updating zsh-z"
  git -C "$ZSH_Z_DIR" pull --ff-only
elif [ -d "$ZSH_Z_DIR" ]; then
  log "zsh-z directory exists but is not a git repo: $ZSH_Z_DIR"
else
  log "Installing zsh-z"
  git clone https://github.com/agkozak/zsh-z "$ZSH_Z_DIR"
fi

# tmux plugin manager
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
