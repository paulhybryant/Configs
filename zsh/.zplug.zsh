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

zplug "zsh-users/zsh-autosuggestions", defer:0
zplug "bhilburn/powerlevel9k", use:"powerlevel9k.zsh-theme", defer:1
zplug "zsh-users/zsh-completions", defer:1
zplug "zsh-users/zsh-history-substring-search", defer:1
zplug "willghatch/zsh-snippets", defer:1
zplug "junegunn/fzf", use:"shell/*.zsh", defer:1
zplug "zlsun/solarized-man", defer:1
zplug "hlissner/zsh-autopair", defer:1
zplug "urbainvaes/fzf-marks", defer:1
zplug "unixorn/tumult.plugin.zsh", if:"[[ $OSTYPE == *darwin* ]]", defer:1
zplug "paulhybryant/dotfiles", defer:1
# zplug "psprint/zsh-syntax-highlighting", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:3

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
