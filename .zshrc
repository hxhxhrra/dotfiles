if [ ! -z "${SOURCED_DOT_ZSHRC}" ]; then
  return
fi
SOURCED_DOT_ZSHRC=1

if [ -z "${SOURCED_DOT_PROFILE}" ]; then
   source ~/.profile
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
bindkey -e

# End of lines configured by zsh-newuser-install

# custom hotkeys
# use ctrl+arrow to navigate words
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

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
alias time='/usr/bin/time'
alias open='xdg-open'
alias ls='ls --color=auto'
alias lr='ls -latrh'
alias lt='ls -tr'
alias bc='bc -l'
alias less='less -S'
alias glances='glances --theme-white'
alias ..='cd ..'
alias make='make -j -l 1'
alias g='git'

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

# powerline support
if [ -z "${DF_POWERLINE}" ] && [ -e ~/.powerline ]; then
  DF_POWERLINE=~/.powerline
fi
if [ -z "${DF_POWERLINE_ZSH}" ] && [ -e ~/.powerline.zsh ]; then
  DF_POWERLINE_ZSH=~/.powerline.zsh
fi
if [ ! -z "${DF_POWERLINE}" ] && [ -e "${DF_POWERLINE}" ]; then
  if [ ! -z "${DF_POWERLINE_ZSH}" ]; then
    ZSH_POWERLINE=${DF_POWERLINE_ZSH}
  else
    ZSH_POWERLINE=${DF_POWERLINE}/bindings/zsh/powerline.zsh
  fi
fi
if [ ! -z "${ZSH_POWERLINE}" ] && [ -e ${ZSH_POWERLINE} ]; then
  export PATH="${PATH}:${DF_POWERLINE}/../../../../bin"
  powerline-daemon -q
  POWERLINE_ZSH_CONTINUATION=1
  POWERLINE_ZSH_SELECT=1
  . ${ZSH_POWERLINE}
else
  # no powerline support for .zsh
  #export PS1="\u@\h:\w: "
fi

# de-dup PATH. Note: OrderedDict preserves input order.
PATH=$(python3 -c 'import os; from collections import OrderedDict; \
    l=os.environ["PATH"].split(":"); print(":".join(OrderedDict.fromkeys(l)))' )
