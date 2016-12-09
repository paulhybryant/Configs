# vim: ft=zplug sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell

export ZPLUG_HOME="$HOME/.zplug"
[[ -d $ZPLUG_HOME ]] || \
  git clone --recursive https://github.com/zplug/zplug $ZPLUG_HOME
source ${ZPLUG_HOME}/init.zsh

zstyle ":prezto:environment:termcap" "color" "yes"
zplug "modules/environment", from:prezto
zstyle ":prezto:module:editor" "key-bindings" "vi"
zplug "modules/editor", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/helper", from:prezto
zplug "modules/history", from:prezto
zplug "modules/fasd", from:prezto
zplug "modules/osx", from:prezto, if:"[[ $OSTYPE == *darwin* ]]"
zplug "bhilburn/powerlevel9k", use:"powerlevel9k.zsh-theme"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "willghatch/zsh-snippets"
zplug "junegunn/fzf", use:"shell/*.zsh"
zplug "zlsun/solarized-man"
zplug "hlissner/zsh-autopair"
zplug "urbainvaes/fzf-marks"
zplug "unixorn/tumult.plugin.zsh", if:"[[ $OSTYPE == *darwin* ]]"
zplug "paulhybryant/dotfiles"
zplug "psprint/zsh-syntax-highlighting", defer:2

# zstyle ":prezto:module:editor" "key-bindings" "vi"
# zplug "modules/editor", from:prezto
# zplug "modules/ssh", from:prezto
# zplug "nojhan/liquidprompt"
# zplug "mafredri/zsh-async"
# zplug "supercrabtree/k"
# zplug "pindexis/qfc", as:command, use:"bin/qfc", hook-load:"source $ZPLUG_REPOS/pindexis/qfc/bin/qfc.sh"
# zplug "aphelionz/strerror.plugin.zsh"
# zplug "psprint/zsh-navigation-tools"
# zplug "psprint/zsh-cmd-architect"
# zplug "psprint/zsh-editing-workbench"
# zplug "psprint/zsh-select"
# zplug "psprint/zconvey"
# zplug "psprint/history-search-multi-word"
# zplug "psprint/ztrace"
# zplug "psprint/zsnapshot"
# zplug "zsh-users/zaw"
# zplug "mooz/percol", use:"tools/zsh"
# zplug "RobSis/zsh-completion-generator"
# zplug "jocelynmallon/zshmarks"
# zplug "paulhybryant/powerline-shell"
# zplug "andrewferrier/fzf-z"
# zplug "b4b4r07/enhancd", use:"init.sh"
# zplug "zsh-users/zsh-syntax-highlighting"
# zplug "trapd00r/zsh-syntax-highlighting-filetypes"
# zplug "D630/fzf-fs"

[[ -f ~/.zplug.local ]] && source ~/.zplug.local                                # Local configurations

if ! zplug check --verbose; then
  zplug install
fi
zplug load --verbose
