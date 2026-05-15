# MSYS2 package installation (sourced by install.sh)

install_packages() {
  # Core tools from msys repo
  pacman -Sy --noconfirm zsh tmux curl git

  # These are only in mingw repos, not msys
  pacman -S --noconfirm mingw-w64-x86_64-fzf mingw-w64-x86_64-fd || \
    log "Could not install fzf/fd from mingw repo. Skipping."
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
