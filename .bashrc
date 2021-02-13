if [ -e "${HOME}/.bashrc.precall" ]
then
   . "${HOME}/.bashrc.precall"
fi
if [ ! -z "${SOURCED_DOT_BASHRC}" ]; then
  return
fi
SOURCED_DOT_BASHRC=1

source ~/.profile

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

# Autocomplete
# Autocomplete Hostnames for SSH etc.
# by Jean-Sebastien Morisset (http://surniaulula.com/)
_complete_hosts () {
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    host_list=`{
        for c in /etc/ssh_config /etc/ssh/ssh_config ~/.ssh/config
        do [ -r $c ] && sed -n -e 's/^Host[[:space:]]//p' -e 's/^[[:space:]]*HostName[[:space:]]//p' $c
        done
        for k in /etc/ssh_known_hosts /etc/ssh/ssh_known_hosts ~/.ssh/known_hosts
        do [ -r $k ] && egrep -v '^[#\[]' $k|cut -f 1 -d ' '|sed -e 's/[,:].*//g'
        done
        sed -n -e 's/^[0-9][0-9\.]*//p' /etc/hosts; }|tr ' ' '\n'|grep -v '*'`
    COMPREPLY=( $(compgen -W "${host_list}" -- $cur))
    return 0
}
complete -F _complete_hosts ssh
complete -F _complete_hosts host
complete -F _complete_hosts ping
complete -F _complete_hosts vncviewer

# dircolors
eval `dircolors ~/.dir_colors`

# autojump support
if [ -z "${DF_AUTOJUMP}" ] && [ -e ~/.autojump.sh ]; then
  DF_AUTOJUMP=~/.autojump.sh
fi
if [ ! -z "${DF_AUTOJUMP}" ] && [ -e "${DF_AUTOJUMP}" ]; then
  . ${DF_AUTOJUMP}
fi

# powerline support
if [ -z "${DF_POWERLINE}" ] && [ -e ~/.powerline ]; then
  DF_POWERLINE=~/.powerline
fi
if [ -z "${DF_POWERLINE_BASH}" ] && [ -e ~/.powerline.sh ]; then
  DF_POWERLINE_BASH=~/.powerline.sh
fi
if [ ! -z "${DF_POWERLINE}" ] && [ -e "${DF_POWERLINE}" ]; then
  if [ ! -z "${DF_POWERLINE_BASH}" ]; then
    BASH_POWERLINE=${DF_POWERLINE_BASH}
  else
    BASH_POWERLINE=${DF_POWERLINE}/bindings/bash/powerline.sh
  fi
fi
if [ ! -z "${BASH_POWERLINE}" ] && [ -e ${BASH_POWERLINE} ]; then
  export PATH="${PATH}:${DF_POWERLINE}/../../../../bin"
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . ${BASH_POWERLINE}
else
  # no powerline support for bash
  export PS1="\u@\h:\w: "
fi

# de-dup PATH. Note: OrderedDict preserves input order.
PATH=$(python3 -c 'import os; from collections import OrderedDict; \
    l=os.environ["PATH"].split(":"); print(":".join(OrderedDict.fromkeys(l)))' )

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
