# vim: ft=zsh sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell
#
source ~/.zplugin/bin/zplugin.zsh
zcompile ~/.zplugin/bin/zplugin.zsh
autoload -Uz compinit
compinit

zplugin load "paulhybryant/myzsh"
zplugin load "paulhybryant/powerline-shell"
zplugin load "psprint/zsh-syntax-highlighting"
zplugin load "sharat87/zsh-vim-mode"
zplugin load "willghatch/zsh-snippets"
zplugin load "zlsun/solarized-man"
zplugin load "zsh-users/zsh-autosuggestions"
zplugin load "zsh-users/zsh-completions"
zplugin load "zsh-users/zsh-history-substring-search"
zplugin snippet 'https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh'

if [[ $OSTYPE == *darwin* ]]; then
  zplugin load "unixorn/tumult.plugin.zsh"
fi
zplugin cdreplay -q
