#!/usr/bin/env sh
set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; exit 1 ;;
  esac
done

log() {
  printf '%s\n' "$*"
}

# Create a symlink, backing up existing non-symlink targets first.
#   $1 = source (inside repo)
#   $2 = destination (under $HOME)
ensure_link() {
  src="$1"
  dest="$2"

  if [ -L "$dest" ]; then
    current_target="$(readlink "$dest")"
    if [ "$current_target" = "$src" ]; then
      log "  ok  $dest -> $src (already linked)"
      return
    fi
    # Symlink pointing elsewhere — remove it so we can relink.
    if [ "$DRY_RUN" = true ]; then
      log "  [dry-run] would remove old symlink $dest -> $current_target"
      log "  [dry-run] would link $dest -> $src"
      return
    fi
    rm "$dest"
  elif [ -e "$dest" ]; then
    # Real file or directory — back it up.
    if [ "$DRY_RUN" = true ]; then
      log "  [dry-run] would backup $dest to ${dest}.bak"
      log "  [dry-run] would link $dest -> $src"
      return
    fi
    log "  backup $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  else
    if [ "$DRY_RUN" = true ]; then
      log "  [dry-run] would link $dest -> $src"
      return
    fi
  fi

  ln -s "$src" "$dest"
  log "  link $dest -> $src"
}

# ---------------------------------------------------------------------------

if [ "$DRY_RUN" = true ]; then
  log "=== dry-run mode — no changes will be made ==="
  log ""
fi

log "Syncing dotfiles from $REPO_DIR to $HOME"
log ""

# --- Top-level dotfiles ---------------------------------------------------
log "Top-level dotfiles:"
for f in .zshrc .vimrc .tmux.conf; do
  ensure_link "$REPO_DIR/$f" "$HOME/$f"
done
log ""

# --- .config directories --------------------------------------------------
log ".config directories:"
mkdir -p "$HOME/.config" 2>/dev/null || true

for d in ghostty kitty lazygit; do
  ensure_link "$REPO_DIR/.config/$d" "$HOME/.config/$d"
done
log ""

log "Sync complete."
