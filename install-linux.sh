# Linux package installation (sourced by install.sh)

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
    as_root apt-get install -y tmux zsh curl git fzf fd-find golang
  elif need_cmd apt; then
    as_root apt update
    as_root apt install -y tmux zsh curl git fzf fd-find golang
  elif need_cmd dnf; then
    as_root dnf install -y tmux zsh curl git fzf fd-find golang
  elif need_cmd yum; then
    as_root yum install -y tmux zsh curl git fzf fd-find golang
  elif need_cmd pacman; then
    as_root pacman -Sy --noconfirm tmux zsh curl git fzf fd go
  elif need_cmd apk; then
    as_root apk add --no-cache tmux zsh curl git fzf fd go
  elif need_cmd zypper; then
    as_root zypper install -y tmux zsh curl git fzf fd go
  else
    log "No supported package manager found. Install manually: tmux zsh curl git fzf fd go"
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
