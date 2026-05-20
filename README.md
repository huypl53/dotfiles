# Dotfiles Setup

This repo contains personal dotfiles plus a small installer that bootstraps the essentials on Linux, macOS, and MSYS2 (Windows).

## What the installer does

- Installs required packages: `tmux`, `zsh`, `curl`, `git` (via your system package manager when possible)
- Installs Oh My Zsh using the official curl installer
- Installs tmux plugin manager (TPM)
- Installs `lazygit` (via `go install`) and `git-delta` (via `cargo install`)

Supported platforms: Linux (`apt-get`, `apt`, `dnf`, `yum`, `pacman`, `apk`, `zypper`), macOS (`brew`), MSYS2 (`pacman`).

## Install

```sh
./install.sh
```

Notes:
- The Oh My Zsh installer runs with `RUNZSH=no`, `CHSH=no`, `KEEP_ZSHRC=yes` to avoid changing your default shell or overwriting your `.zshrc`.
- If you want to make `zsh` your default shell:
  - **Linux/macOS**: `chsh -s "$(command -v zsh)"`
  - **MSYS2**: edit `/etc/passwd` or change the shell in your MSYS2 launcher shortcut.

## Apply dotfiles (optional)

Use `sync.sh` to symlink all config files from this repo into your home directory:

```sh
./sync.sh
```

Preview what would happen without making changes:

```sh
./sync.sh --dry-run
```

The script symlinks the following:

- **Top-level dotfiles** to `$HOME`: `.zshrc`, `.zshrc_utils`, `.vimrc`, `.tmux.conf`
- **Config directories** to `$HOME/.config/`: `ghostty`, `kitty`, `lazygit`

If an existing file or directory would be overwritten, it is backed up with a `.bak` suffix first. The script is idempotent — running it multiple times is safe.

**MSYS2 note**: MSYS2 defaults to copying files instead of creating real symlinks. To get real symlinks, enable Windows Developer Mode or set `MSYS=winsymlinks:nativestrict` before running `sync.sh`.

## tmux plugins

Inside tmux, press `prefix + I` to install plugins (prefix is `Ctrl+a` in this config).

## Oh My Zsh

This repo's `.zshrc` is minimal and does not load Oh My Zsh by default. If you want to use it, add the standard Oh My Zsh block to your `.zshrc`, for example:

```sh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"
```
