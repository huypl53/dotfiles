# Dotfiles Setup (Linux)

This repo contains personal dotfiles plus a small installer that bootstraps the essentials on most Linux distributions.

## What the installer does

- Installs required packages: `tmux`, `zsh`, `curl`, `git` (via your system package manager when possible)
- Installs Oh My Zsh using the official curl installer
- Installs tmux plugin manager (TPM)

Supported package managers: `apt-get`, `apt`, `dnf`, `yum`, `pacman`, `apk`, `zypper`, `brew`.

## Install

```sh
./install.sh
```

Notes:
- The Oh My Zsh installer runs with `RUNZSH=no`, `CHSH=no`, `KEEP_ZSHRC=yes` to avoid changing your default shell or overwriting your `.zshrc`.
- If you want to make `zsh` your default shell, run:

```sh
chsh -s "$(command -v zsh)"
```

## Apply dotfiles (optional)

If you want to use the configs from this repo, symlink them into your home directory:

```sh
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/.vimrc" "$HOME/.vimrc"
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
```

If you want to use the `.config` directory, consider backing up your existing `$HOME/.config` first.

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
