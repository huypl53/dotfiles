# macOS package installation (sourced by install.sh)

if ! need_cmd brew; then
  die "Homebrew is required on macOS. Install from https://brew.sh"
fi

log "Installing packages via Homebrew"
brew install tmux zsh curl git fzf fd gnu-sed go
