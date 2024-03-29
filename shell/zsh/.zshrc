# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# export PATH="/home/$USER/.bin:$PATH"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="agnoster"
# ZSH_THEME="robbyrussell"
#ZSH_THEME_RANDOM_CANDIDATES=(
#  "robbyrussell"
#  "agnoster"
#)

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    github
    zsh-syntax-highlighting
    zsh-autosuggestions
    colored-man-pages
    python
    fzf
    vscode
    command-not-found
    web-search
    history
    extract
    copyfile
    zsh-z
    # vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias labelimg="python /mnt/01D322563C532490/dev_project/Python/Labeling/labelimg/labelImg.py"
alias labeleva="cd /mnt/01D322563C532490/dev_project/Python/Labeling/eva/ && ./start.sh"
alias labelvott="/snap/vott/current/vott"
alias model_vis_netron="/media/huy/Data/dev_project/Python/Visualization/Netron-4.0.9.AppImage"
alias android_studio="/home/huy/android-studio/bin/studio.sh"
alias subpenguin="~/.bin/PenguinSubtitlePlayer"
alias vfzf="nvim \$(fzf --height 70%)"
# alias lazygit="/home/huy/.bin/lazygit"
export PATH="$PYENV_ROOT/bin:$PATH"


export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XMODIFIERS="@im=ibus"



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/huy/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/huy/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/huy/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/huy/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# https://github.com/sindresorhus/pure
#
# fpath+=$HOME/.zsh/pure
#
# autoload -U promptinit; promptinit
#
## optionally define some options
#PURE_CMD_MAX_EXEC_TIME=10
#
## # turn on git stash status
# zstyle :prompt:pure:git:stash show yes
# prompt pure

# zsh vi mode
bindkey -v

# zsh fzf
export FZF_DEFAULT_OPTS='--height 70% --border'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
# export TERM=xterm

# # Theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k-lean-8colors.zsh ]] || source ~/.p10k-lean-8colors.zsh
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
alias lg='lazygit'
alias pbcopy="xclip -sel clip"
alias pimg="xclip -selection clipboard -t image/png -o > "
alias cheat="/home/huy/.bin/cheat-linux-386"
alias burp="cd ~/Downloads/setup/BurpSuite\ Pro\ v2.1.04 && java -noverify -Xbootclasspath/p:burp-loader-keygen-2_1_04.jar -jar burpsuite_pro_v2.1.04.jar"
alias mclang="clang++ -I \`gnustep-config --variable=GNUSTEP_SYSTEM_HEADERS\` \\
                       -L \`gnustep-config --variable=GNUSTEP_SYSTEM_LIBRARIES\` \\
                       -lgnustep-base -fconstant-string-class=NSConstantString \\
                       -D_NATIVE_OBJC_EXCEPTIONS "
                       # -lobjc "

alias lmak="rm -rf build && mkdir build && cd build && cmake .. && make -j4 && cd .."
alias lvim="~/.local/bin/lvim"
alias cheat='~/.bin/cheat-linux-amd64'
alias codetran='code --unity-launch && devilspie &'
alias anemulator='/home/huy/Android/Sdk/emulator/emulator -avd Galaxy_Nexus_API_30'
alias reactron='/home/huy/Downloads/setup/Reactotron-2.17.1.AppImage'
# alias deno='~/.deno/bin/deno'
# fpath+=${ZDOTDIR:-~}/.zsh_functions


# BEGIN_KITTY_SHELL_INTEGRATION
# if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION

# Disable webcam `blacklist uvcvideo`
# /etc/modprobe.d/blacklist.conf
export PATH=/home/huy/.meteor:$PATH
export REACT_EDITOR=vim
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export ANDROID_SDK_ROOT=$HOME/Android/sdk
