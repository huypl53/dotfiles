# macOS package installation (sourced by install.sh)

install_packages() {
  if ! need_cmd brew; then
    die "Homebrew is required on macOS. Install from https://brew.sh"
  fi

  log "Installing packages via Homebrew"
  brew install tmux zsh curl git fzf fd gnu-sed go
}

missing=""
for cmd in tmux zsh curl git; do
  if ! need_cmd "$cmd"; then
    missing="$missing $cmd"
  fi
done
