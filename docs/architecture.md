# Architecture

## Overview

This dotfiles repo has two main entry points:

1. **`install.sh`** — Installs required packages and tools (tmux, zsh, oh-my-zsh, TPM). Delegates to OS-specific scripts (`install-linux.sh`, `install-macos.sh`) and shared setup (`install-common.sh`, `install-tmux.sh`).
2. **`sync.sh`** — Symlinks config files from the repo into `$HOME`. Intentionally kept separate from install so the user can review before applying.

## Config sync mechanism (`sync.sh`)

The sync script handles two categories of config files:

### Top-level dotfiles
Files at the repo root (`.zshrc`, `.vimrc`, `.tmux.conf`) are symlinked directly into `$HOME`.

### .config directories
Entire directories under `.config/` (`ghostty`, `kitty`, `lazygit`) are symlinked as directory symlinks into `$HOME/.config/`. This means each directory is a single symlink rather than individual file symlinks — any new files added to the repo directory are automatically picked up.

### Backup and idempotency
- If the destination is already a symlink pointing to the correct repo path, no action is taken.
- If the destination is a symlink pointing elsewhere, it is replaced.
- If the destination is a real file or directory, it is moved to `<name>.bak` before creating the symlink.
- The `--dry-run` flag previews all actions without making changes.

### Design decisions
- POSIX sh with `set -eu` for portability and safety.
- `sync.sh` is not called automatically by `install.sh` — a log message suggests running it separately. This avoids surprises when the user just wants to install packages.
- Directory-level symlinks for `.config/*` rather than file-level: simpler, and any config file additions are automatically visible without re-running sync.
