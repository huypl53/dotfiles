
# If you come from bash you might have to change your $PATH.

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="awesomepanda"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting z fzf)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

export PATH="$HOME/.bin:$PATH"
export EDITOR=nvim
unalias gg

alias t-paste=wl-paste -n
export QT_QUICK_BACKEND=software
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=100000
alias cca="SHELL=/bin/bash CLAUDE_CODE_NO_FLICKER=1 claude --dangerously-skip-permissions"
alias ccg="CLAUDE_CONFIG_DIR=~/.claude-work SHELL=/bin/bash CLAUDE_CODE_NO_FLICKER=1 claude --dangerously-skip-permissions"

export PATH=/Users/lee/.opencode/bin:$PATH
alias lg=lazygit

. "$HOME/.local/bin/env"
#
# opencode
export PATH=$HOME/.opencode/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/code/tools/:$PATH
export PATH="$BUN_INSTALL/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
