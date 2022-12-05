autoload -U select-word-style
select-word-style bash

autoload -Uz colors compinit promptinit
colors
compinit
promptinit

# Emacs style keybindings
bindkey -e

# VCS info {{{
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%F{3}(%b)%f'
precmd() {
    vcs_info
}

setopt PROMPT_SUBST
# }}}

## Prompt
# ➔ ➤
# PROMPT="
# # %{$fg_bold[red]%} » %{$reset_color%}"
# RPROMPT="%{$fg_bold[blue]%}%~%{$reset_color%}"
PROMPT='
%F{9} » %f'
RPROMPT='%F{12}%~%f ${vcs_info_msg_0_}'

## Completions

setopt AUTO_CD
setopt CORRECT
setopt COMPLETE_ALIASES

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors 'reply=( "=(#b)(*$VAR)(?)*=00=$color[green]=$color[bg-green]" )'
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=30;41'
zstyle ':completion:*:*:*:*:users' list-colors '=*=$color[green]=$color[red]'
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

## History

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
export HISTFILE="${HOME}"/.zsh_history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

## Aliases

# Easy access to dotfile repo.
alias dots='/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

alias ls='ls -hF --color=always'
alias ll='ls -l --group-directories-first'
alias la='ll -A'

alias cp='cp -i -v'
alias mv='mv -i -v'
alias grep='grep -i'
alias mkdir='mkdir -p -v'

alias ..='cd ..'
alias ....='cd ../..'
alias ......='cd ../../..'

# Use nvim as man pager
if [ -x "$(command -v nvim)" ]; then
    export MANPAGER='nvim +Man!'
fi

## Functions

gdb-tmux() {
    local tty="$(tmux split-pane -hPF "#{pane_tty}" "tail -f /dev/null")"
    tmux last-pane
    gdb-multiarch -ex "dashboard -output $tty" "$@"
}

## GCC Colorization
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

## Syntax Highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Use ripgrep for FZF if installed.
if [ -x "$(command -v rg)" ]; then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/*'"
fi

export FZF_DEFAULT_OPTS="--multi --inline-info --reverse"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
