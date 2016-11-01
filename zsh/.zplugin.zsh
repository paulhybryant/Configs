# vim: ft=zsh sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell

[[ -d ~/.zplugin ]] || \
  (mkdir ~/.zplugin && \
  git clone --recursive https://github.com/psprint/zplugin.git ~/.zplugin/bin)
source ~/.zplugin/bin/zplugin.zsh
zcompile ~/.zplugin/bin/zplugin.zsh

zplugin load "bhilburn/powerlevel9k"
zplugin load "psprint/zsh-syntax-highlighting"
zplugin load "willghatch/zsh-snippets"
zplugin load "zlsun/solarized-man"
zplugin load "zsh-users/zsh-autosuggestions"
zplugin load "zsh-users/zsh-completions"
zplugin load "zsh-users/zsh-history-substring-search"
zplugin snippet \
  'https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh'

# zplugin load "mafredri/zsh-async"

if [[ $OSTYPE == *darwin* ]]; then
  zplugin load "unixorn/tumult.plugin.zsh"
fi

# Put my zsh configs at the end as it 'fixes' some known 'bad' settings in previous
# loaded plugins.
zplugin load "paulhybryant/dotfiles"

[[ -f ~/.zplugin.local ]] && source ~/.zplugin.local                            # Local configurations
autoload -Uz compinit
compinit
# zplugin cdreplay -q
