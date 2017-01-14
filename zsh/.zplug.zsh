# vim: ft=zplug sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell

export ZPLUG_HOME="$HOME/.zplug"
[[ -d $ZPLUG_HOME ]] || \
  git clone --recursive https://github.com/zplug/zplug $ZPLUG_HOME
source ${ZPLUG_HOME}/init.zsh

zstyle ":prezto:environment:termcap" "color" "yes"
zplug "modules/environment", from:prezto, defer:0
zstyle ":prezto:module:editor" "key-bindings" "vi"
zplug "modules/directory", from:prezto, defer:0
zplug "modules/helper", from:prezto, defer:0
zplug "modules/history", from:prezto, defer:0
zplug "modules/fasd", from:prezto, defer:0
zplug "modules/osx", from:prezto, defer:0, if:"[[ $OSTYPE == *darwin* ]]"

# Must load zsh-cdr before zaw
zplug "Valodim/zsh-curl-completion", defer:1
zplug "arzzen/calc.plugin.zsh", defer:1
zplug "bhilburn/powerlevel9k", use:"powerlevel9k.zsh-theme", defer:1
zplug "bric3/nice-exit-code", defer:1
# zplug "hchbaw/auto-fu.zsh", defer:1
zplug "hlissner/zsh-autopair", defer:1
zplug "jocelynmallon/zshmarks"
zplug "junegunn/fzf", use:"shell/*.zsh", defer:1
# zplug "mooz/percol", use:"tools/zsh", defer:1
# zplug "oz/safe-paste", defer:1
zplug "peterhurford/up.zsh", defer:1
zplug "psprint/zsh-navigation-tools", defer:0
zplug "seebi/dircolors-solarized", defer:1
zplug "unixorn/tumult.plugin.zsh", if:"[[ $OSTYPE == *darwin* ]]", defer:1
zplug "urbainvaes/fzf-marks", defer:1
zplug "willghatch/zsh-cdr", defer:1
zplug "willghatch/zsh-hooks", defer:1
zplug "willghatch/zsh-snippets", defer:1
zplug "zlsun/solarized-man", defer:1
zplug "zsh-users/zaw", defer:1
zplug "zsh-users/zsh-autosuggestions", defer:1
zplug "zsh-users/zsh-completions", defer:1
zplug "zsh-users/zsh-history-substring-search", defer:1

zplug "paulhybryant/dotfiles", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:3
# zplug "trapd00r/zsh-syntax-highlighting-filetypes", defer:3

# zplug "D630/fzf-fs"
# zplug "KasperChristensen/mylocation", defer:1
# zplug "RobSis/zsh-completion-generator"
# zplug "andrewferrier/fzf-z"
# zplug "arialdomartini/oh-my-git", use:"prompt.sh", defer:1
# zplug "b4b4r07/enhancd", use:"init.sh"
# zplug "huyng/bashmarks"
# zplug "joepvd/grep2awk", defer:1
# zplug "mafredri/zsh-async"
# zplug "modules/ssh", from:prezto
# zplug "nojhan/liquidprompt"
# zplug "pindexis/qfc", as:command, use:"bin/qfc", hook-load:"source $ZPLUG_REPOS/pindexis/qfc/bin/qfc.sh"
# zplug "psprint/history-search-multi-word"
# zplug "psprint/zconvey"
# zplug "psprint/zsh-cmd-architect"
# zplug "psprint/zsh-editing-workbench"
# zplug "psprint/zsh-select"
# zplug "psprint/zsnapshot"
# zplug "psprint/ztrace"
# zplug "shannonmoeller/up", use:"up.sh", defer:1
# zplug "supercrabtree/k"

[[ -f ~/.zplug.local ]] && source ~/.zplug.local                                # Local configurations

if ! zplug check --verbose; then
  zplug install
fi
zplug load --verbose
setopt MONITOR
