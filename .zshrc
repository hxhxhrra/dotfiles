if [ -z "${SOURCED_DOT_PROFILE}" ]; then
   source ~/.profile
fi


# low level version compare, used to check if we skip most of this for old zshs
# Given two version strings, returns the larger of the two.
# relies on sort -V
larger_version() {
   echo "
${1}
${2}
" | sort -V | tail -1
}

if [ "$(larger_version ${ZSH_VERSION} 5)" = "5" ]
then
   export PS1='%F%B%n%f@%m %F%~: %f%b'
   echo "Old zsh detected, using fallback config!"
   return
fi

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' menu select

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
setopt interactivecomments

# End of lines configured by zsh-newuser-install

# Edit current line in vim
autoload -U edit-command-line
# # Emacs style
# bindkey -e

# Vim style
bindkey -v

# ctrl-x-e launches ${EDITOR} to edit the current line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# custom hotkeys
# use ctrl+arrow to navigate words
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# bind alt-arrow to move-word-until-non-alpha
backward-dir () {
   local WORDCHARS=${WORDCHARS/\/}
   zle backward-word
}
zle -N backward-dir
bindkey "^[[1;3D" backward-dir
forward-dir () {
   local WORDCHARS=${WORDCHARS/\/}
   zle forward-word
}
zle -N forward-dir
bindkey "^[[1;3C" forward-dir

# bind alt-backspace to delete-word-until-non-alpha
backward-kill-dir () {
   local WORDCHARS=${WORDCHARS/\/}
   zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir

#################
# Aliases
#################
alias ..='cd ..'
alias bc='bc -l'
alias g='git'
alias glances='glances --theme-white'
alias less='less -S'
alias lr='ls -latrh'
alias ls='ls --color=auto'
alias lt='ls -tr'
alias open='xdg-open'
alias time='/usr/bin/time'
alias nv='nvim'

#################
# Functions
#################

cw() {
   cmd=$1
   cat `which ${cmd}`
}

vw() {
   cmd=$1
   vim `which ${cmd}`
}

rlf() { readlink -f ${@}; }

pushj() { pushd .; j $@; }
popj() { popd; }

cdrecent() { cd ./*(/om[1]); }

toclipboard() { xclip -selection CLIPBOARD; }

################
# Tools
################

# dircolors
eval `dircolors ~/.dir_colors`

# autojump support
if [ -z "${DF_AUTOJUMP}" ] && [ -e ~/.autojump-shell-base ]; then
  DF_AUTOJUMP=~/.autojump-shell-base
  ZSH_AUTOJUMP=${DF_AUTOJUMP}/autojump.zsh
fi
if [ ! -z "${ZSH_AUTOJUMP}" ] && [ -e "${ZSH_AUTOJUMP}" ]; then
  . ${ZSH_AUTOJUMP}
fi

# powerlevel10k
if [ -z "${DF_POWERLEVEL}" ] && [ -e ~/.powerlevel10k.zsh-theme ]; then
  DF_POWERLEVEL=~/.powerlevel10k.zsh-theme
fi
if [ ! -z "${DF_POWERLEVEL}" ] && [ -e "${DF_POWERLEVEL}" ]; then
  . ${DF_POWERLEVEL}
fi

HAS_PYTHON3=$(if [ -z "$(env python3 --version 2>/dev/null)" ]; then echo "0"; else echo "1"; fi)
if [ "${HAS_PYTHON3}" = "1" ]; then
   # de-dup PATH. Note: OrderedDict preserves input order.
   PATH=$(python3 -c 'import os; from collections import OrderedDict; \
       l=os.environ["PATH"].split(":"); print(":".join(OrderedDict.fromkeys(l)))' )
else
   echo "No python3 found, running in compat mode.."
fi # end of python block

# fzf support
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
