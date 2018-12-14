# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

abbrev-alias -c tl='tmux list-sessions'
abbrev-alias -c ta='command tmux attach -d -t'
abbrev-alias -c tl='command tmux list-sessions'
abbrev-alias -c ts='command tmux start-server; command tmux attach'
abbrev-alias -c gcm='git commit -a -m'

if [[ ${OSTYPE} == *linux* ]]; then
  abbrev-alias -c cdtrash='pushd ~/.local/share/Trash/files'
  abbrev-alias -c dpkg-cleanup-config=\
    'dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge'
  abbrev-alias -c sysprefs='unity-control-center'
  abbrev-alias -c sourcepkg='dpkg -S'
  abbrev-alias -c clogout='cinnamon-session-quit --logout'
  abbrev-alias -c xrebindkeys='killall xbindkeys 2>&1 > /dev/null; xbindkeys'
  abbrev-alias -c xunbindkeys='killall xbindkeys 2>&1 > /dev/null'
  abbrev-alias -c xkbmapclear="setxkbmap -option ''"
  abbrev-alias -c xkbmapreload="~/.xsessionrc"
  abbrev-alias -c resetxkbmap='sudo dpkg-reconfigure xkb-data'
else
  abbrev-alias -c vi='mvim -v'
  abbrev-alias -c vim='mvim -v'
  abbrev-alias -c doc2pdf='/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to pdf'
fi

if (( ${+commands[grc]} )); then
  abbrev-alias -c colorify='command grc -es --colour=auto'
  abbrev-alias -c ps='colorify ps'
  abbrev-alias -c netstat='colorify netstat'
  abbrev-alias -c ping='colorify ping'
  abbrev-alias -c tail='colorify tail'
  abbrev-alias -c head='colorify head'
  abbrev-alias -c df='colorify df'
fi

if (( ${+commands[bat]} )); then
  abbrev-alias -c bat='PAGER= bat'
fi

# abbrev-alias -c trash-restore='restore-trash'
abbrev-alias -c aga='ag -a --hidden'
abbrev-alias -c cdlink='file::cdlink'
abbrev-alias -c cdr='cd-gitroot'
abbrev-alias -c gitfind='file::find-ignore-dir ".git"'
abbrev-alias -c grepc='command grep -C 5 '
abbrev-alias -c gyank='util::yank'
# abbrev-alias -c gvim='util::gvim'
abbrev-alias -c info='command info --vi-keys'
abbrev-alias -c l='file::ls'
abbrev-alias -c la='file::ls -a'
abbrev-alias -c lad='file::ld -a'
abbrev-alias -c laf='file::lf -a'
abbrev-alias -c lal='file::ll -a'
abbrev-alias -c ldir='file::ld'
abbrev-alias -c lf='file::lf'
abbrev-alias -c ll='file::ls -l'
abbrev-alias -c lla='file::ls -la'
abbrev-alias -c llad='file::ld -la'
abbrev-alias -c llaf='file::lf -la'
abbrev-alias -c llal='file::ll -la'
abbrev-alias -c lld='file::ld -l'
abbrev-alias -c llf='file::lf -l'
abbrev-alias -c llink='file::ll'
abbrev-alias -c lll='file::ll -l'
abbrev-alias -c mank='command man -K'
abbrev-alias -c npm='command npm -g'
abbrev-alias -c rm='command trash'
abbrev-alias -c run='zsh::run'
abbrev-alias -c t='todo.sh'
abbrev-alias -c stow='command stow -v'
abbrev-alias -c vartype='declare -p'
# This is not needed by puting homebrew.pth in the site-packges of xonsh
# abbrev-alias -c xonsh="PYTHONPATH=$(brew --prefix)/lib/python3.5/site-packages xonsh"
# abbrev-alias -c vi='util::vim'
# abbrev-alias -c vi='vi -p'
# abbrev-alias -c vim='util::vim'
# abbrev-alias -c vim='vim -p'
abbrev-alias -c zunbindkey='bindkey -r'
abbrev-alias -c pi='command ssh -i ~/.ssh/paulhybryant pi@pi'
abbrev-alias -c miwifi='command ssh -i ~/.ssh/paulhybryant root@mifiwi'
abbrev-alias -c vps='command ssh -i ~/.ssh/paulhybryant root@www.paulhybryant.tk'
abbrev-alias -c nas='command ssh -i ~/.ssh/paulhybryant admin@paulhybryant.myqnapcloud.cn'
abbrev-alias -c workenv='docker run -it --hostname paulhybryant paulhybryant/docker-base:v0.1 /home/linuxbrew/.linuxbrew/bin/zsh'
abbrev-alias -c combine_pdf='"/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" -o '
[[ -n ${aliases[run-help]+1} ]] && unalias run-help                             # Use built-in run-help for online help
autoload run-help                                                               # Unset previous run-help alias
