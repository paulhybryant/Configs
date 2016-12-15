# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

if [[ ${OSTYPE} == *linux* ]]; then
  alias cdtrash='pushd ~/.local/share/Trash/files'
  alias dpkg-cleanup-config=\
    'dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge'
  alias sysprefs='unity-control-center'
  alias sourcepkg='dpkg -S'
  alias clogout='cinnamon-session-quit --logout'
  alias xrebindkeys='killall xbindkeys 2>&1 > /dev/null; xbindkeys'
  alias xunbindkeys='killall xbindkeys 2>&1 > /dev/null'
  alias xkbmapclear="setxkbmap -option ''"
  alias xkbmapreload="~/.xsessionrc"
  alias resetxkbmap='sudo dpkg-reconfigure xkb-data'
elif [[ $OSTYPE == *darwin* ]]; then
  unalias vi
  unalias vim
fi

if (( ${+commands[grc]} )); then
  alias colorify='command grc -es --colour=auto'
  alias ps='colorify ps'
  alias netstat='colorify netstat'
  alias ping='colorify ping'
  alias tail='colorify tail'
  alias head='colorify head'
  alias df='colorify df'
fi

# alias trash-restore='restore-trash'
alias aga='ag -a --hidden'
alias cdlink='file::cdlink'
alias cdr='cd-gitroot'
alias gitfind='file::find-ignore-dir ".git"'
alias grepc='command grep -C 5 '
alias gyank='util::yank'
# alias gvim='util::gvim'
alias info='command info --vi-keys'
alias l='file::ls'
alias la='file::ls -a'
alias lad='file::ld -a'
alias laf='file::lf -a'
alias lal='file::ll -a'
alias ldir='file::ld'
alias lf='file::lf'
alias ll='file::ls -l'
alias lla='file::ls -la'
alias llad='file::ld -la'
alias llaf='file::lf -la'
alias llal='file::ll -la'
alias lld='file::ld -l'
alias llf='file::lf -l'
alias llink='file::ll'
alias lll='file::ll -l'
alias mank='command man -K'
alias npm='command npm -g'
alias rm='\trash -v'
alias run='zsh::run'
alias stow='command stow -v'
alias vartype='declare -p'
# This is not needed by puting homebrew.pth in the site-packges of xonsh
# alias xonsh="PYTHONPATH=$(brew --prefix)/lib/python3.5/site-packages xonsh"
# alias vi='util::vim'
# alias vi='vi -p'
# alias vim='util::vim'
# alias vim='vim -p'
alias zunbindkey='bindkey -r'
alias ec2='command ssh -i ~/.ssh/paulhybryant.pem ubuntu@ec2'
[[ -n ${aliases[run-help]+1} ]] && unalias run-help                             # Use built-in run-help for online help
autoload run-help                                                               # Unset previous run-help alias
