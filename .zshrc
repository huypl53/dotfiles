plugins=(z fzf)

export PATH="/home/shen/.cargo/bin:$PATH"
export PATH="/home/shen/.npm-global/bin:$PATH"

export PATH="/home/shen/.bin:$PATH"
export EDITOR=nvim
unalias gg

alias t-paste=wl-paste -n
export QT_QUICK_BACKEND=software
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=100000
alias claude="SHELL=/bin/bash claude --dangerously-skip-permissions"
