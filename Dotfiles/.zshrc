# ===== History =====
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ===== Completion =====
autoload -Uz compinit
compinit

# ===== Prompt =====
autoload -Uz colors
colors

PROMPT='%F{green}%n@%m%f %F{blue}%~%f %# '

# ===== Useful Options =====
setopt AUTO_CD
setopt CORRECT
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt NO_BEEP

# ===== Aliases =====
if [[ -f ~/.alias/zsh/zsh-alias ]];then
    source ~/.alias/zsh/zsh-alias
fi
