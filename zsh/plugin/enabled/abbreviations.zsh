# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

abbrev-alias -g tl='tmux list-sessions'
abbrev-alias -g ta='command tmux attach -d -t'
abbrev-alias -g tl='command tmux list-sessions'
abbrev-alias -g ts='command tmux start-server; command tmux attach'
abbrev-alias -g gcm='git commit -a -m'

if [[ ${OSTYPE} == *linux* ]]; then
  abbrev-alias -g cdtrash='pushd ~/.local/share/Trash/files'
  abbrev-alias -g dpkg-cleanup-config=\
    'dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge'
  abbrev-alias -g sysprefs='unity-control-center'
  abbrev-alias -g sourcepkg='dpkg -S'
  abbrev-alias -g clogout='cinnamon-session-quit --logout'
  abbrev-alias -g xrebindkeys='killall xbindkeys 2>&1 > /dev/null; xbindkeys'
  abbrev-alias -g xunbindkeys='killall xbindkeys 2>&1 > /dev/null'
  abbrev-alias -g xkbmapclear="setxkbmap -option ''"
  abbrev-alias -g xkbmapreload="~/.xsessionrc"
  abbrev-alias -g resetxkbmap='sudo dpkg-reconfigure xkb-data'
fi

if (( ${+commands[grc]} )); then
  abbrev-alias -g colorify='command grc -es --colour=auto'
  abbrev-alias -g ps='colorify ps'
  abbrev-alias -g netstat='colorify netstat'
  abbrev-alias -g ping='colorify ping'
  abbrev-alias -g tail='colorify tail'
  abbrev-alias -g head='colorify head'
  abbrev-alias -g df='colorify df'
fi

# abbrev-alias -g trash-restore='restore-trash'
abbrev-alias -g aga='ag -a --hidden'
abbrev-alias -g cdlink='file::cdlink'
abbrev-alias -g cdr='cd-gitroot'
abbrev-alias -g gitfind='file::find-ignore-dir ".git"'
abbrev-alias -g grepc='command grep -C 5 '
abbrev-alias -g gyank='util::yank'
# abbrev-alias -g gvim='util::gvim'
abbrev-alias -g info='command info --vi-keys'
abbrev-alias -g l='file::ls'
abbrev-alias -g la='file::ls -a'
abbrev-alias -g lad='file::ld -a'
abbrev-alias -g laf='file::lf -a'
abbrev-alias -g lal='file::ll -a'
abbrev-alias -g ldir='file::ld'
abbrev-alias -g lf='file::lf'
abbrev-alias -g ll='file::ls -l'
abbrev-alias -g lla='file::ls -la'
abbrev-alias -g llad='file::ld -la'
abbrev-alias -g llaf='file::lf -la'
abbrev-alias -g llal='file::ll -la'
abbrev-alias -g lld='file::ld -l'
abbrev-alias -g llf='file::lf -l'
abbrev-alias -g llink='file::ll'
abbrev-alias -g lll='file::ll -l'
abbrev-alias -g mank='command man -K'
abbrev-alias -g npm='command npm -g'
abbrev-alias -g rm='command trash -v'
abbrev-alias -g run='zsh::run'
abbrev-alias -g t='todo.sh'
abbrev-alias -g stow='command stow -v'
abbrev-alias -g vartype='declare -p'
# This is not needed by puting homebrew.pth in the site-packges of xonsh
# abbrev-alias -g xonsh="PYTHONPATH=$(brew --prefix)/lib/python3.5/site-packages xonsh"
# abbrev-alias -g vi='util::vim'
# abbrev-alias -g vi='vi -p'
# abbrev-alias -g vim='util::vim'
# abbrev-alias -g vim='vim -p'
abbrev-alias -g zunbindkey='bindkey -r'
abbrev-alias -g ec2='command ssh -i ~/.ssh/paulhybryant.pem ubuntu@ec2'
abbrev-alias -g pi='command ssh -i ~/.ssh/paulhybryant pi@pi'
abbrev-alias -g miwifi='command ssh -i ~/.ssh/paulhybryant root@mifiwi'
[[ -n ${aliases[run-help]+1} ]] && unalias run-help                             # Use built-in run-help for online help
autoload run-help                                                               # Unset previous run-help alias
