# vim: ft=zplug sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell

export ZPLUG_HOME="$HOME/.zplug"
[[ -d $ZPLUG_HOME ]] || \
  git clone --recursive https://github.com/zplug/zplug $ZPLUG_HOME
source ${ZPLUG_HOME}/init.zsh

zplug "zplug/zplug", nice:0

zstyle ":prezto:environment:termcap" "color" "yes"
zplug "modules/environment", from:prezto, nice:0
zplug "modules/directory", from:prezto, nice:1
zplug "modules/helper", from:prezto, nice:1
zplug "modules/history", from:prezto, nice:1
zplug "modules/osx", from:prezto, nice:1, if:"[[ $OSTYPE == *darwin* ]]"
zplug "bhilburn/powerlevel9k", use:"powerlevel9k.zsh-theme", nice:2
zplug "zsh-users/zsh-autosuggestions", nice:5
zplug "zsh-users/zsh-completions", nice:5
zplug "zsh-users/zsh-history-substring-search", nice:5
zplug "willghatch/zsh-snippets", nice:5
zplug "sharat87/zsh-vim-mode", nice:6
zplug "junegunn/fzf", use:"shell/*.zsh", nice:6
zplug "zlsun/solarized-man", nice:6
zplug "unixorn/tumult.plugin.zsh", nice:6, if:"[[ $OSTYPE == *darwin* ]]"
zplug "paulhybryant/dotfiles", nice:8
zplug "psprint/zsh-syntax-highlighting", nice:10

# zstyle ":prezto:module:editor" "key-bindings" "vi"
# zplug "modules/editor", from:prezto, nice:1
# zplug "modules/ssh", from:prezto, nice:1
# zplug "mafredri/zsh-async", nice:3
# zplug "supercrabtree/k", nice:5
# zplug "pindexis/qfc", as:command, use:"bin/qfc", nice:5, hook-load:"source $ZPLUG_REPOS/pindexis/qfc/bin/qfc.sh"
# zplug "aphelionz/strerror.plugin.zsh", nice:5
# zplug "psprint/zsh-navigation-tools", nice:5
# zplug "psprint/zsh-cmd-architect", nice:5
# zplug "psprint/zsh-editing-workbench", nice:5
# zplug "psprint/zsh-select", nice:5
# zplug "psprint/zconvey", nice:5
# zplug "psprint/history-search-multi-word", nice:5
# zplug "psprint/ztrace", nice:5
# zplug "psprint/zsnapshot", nice:5
# zplug "zsh-users/zaw", nice:5
# zplug "mooz/percol", use:"tools/zsh", nice:5
# zplug "RobSis/zsh-completion-generator", nice:6
# zplug "jocelynmallon/zshmarks", nice:6
# zplug "paulhybryant/powerline-shell", nice:6
# zplug "andrewferrier/fzf-z", nice:6
# zplug "b4b4r07/enhancd", use:"init.sh", nice:7
# zplug "zsh-users/zsh-syntax-highlighting", nice:10
# zplug "trapd00r/zsh-syntax-highlighting-filetypes", nice:11

[[ -f ~/.zplug.local ]] && source ~/.zplug.local                                # Local configurations

if ! zplug check --verbose; then
  zplug install
fi
zplug load --verbose
