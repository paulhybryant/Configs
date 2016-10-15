export ZPLUG_HOME="$BREWHOME/opt/zplug"
export ZPLUG_REPOS="$HOME/.zplug/repos"
source ${ZPLUG_HOME}/init.zsh

zstyle ":prezto:environment:termcap" "color" "yes"
zplug "modules/environment", from:prezto, nice:0
zplug "modules/directory", from:prezto, nice:1
zplug "modules/helper", from:prezto, nice:1
zstyle ":prezto:module:editor" "key-bindings" "vi"
zplug "modules/editor", from:prezto, nice:1
zplug "modules/git", from:prezto, nice:1
zplug "modules/homebrew", from:prezto, nice:1
zplug "modules/fasd", from:prezto, nice:1
zplug "modules/history", from:prezto, nice:1
zplug "modules/tmux", from:prezto, nice:1
zplug "modules/dpkg", from:prezto, nice:1

# For unknown reason, zplug clear && zplug load will cause zsh to exit if
# autosuggestions and zsh-syntax-highlighting are enabled at the same time.
zplug "zsh-users/zsh-autosuggestions", nice:5
zplug "zsh-users/zsh-history-substring-search", nice:5

zplug "RobSis/zsh-completion-generator", nice:7
zplug "psprint/ztrace", nice:7
zplug "psprint/zsnapshot", nice:7
zplug "jocelynmallon/zshmarks", nice:7
# zplug "sharat87/zsh-vim-mode", nice:7
zplug "seebi/dircolors-solarized", nice:7
zplug "paulhybryant/powerline-shell", nice:7
zplug "junegunn/fzf", use:"shell/*.zsh", nice:7
zplug "zlsun/solarized-man", nice:7
zplug "andrewferrier/fzf-z", nice:7
zplug "paulhybryant/myzsh", use:"enabled/*.zsh", nice:8

zplug "zsh-users/zsh-syntax-highlighting", nice:10
# zplug "trapd00r/zsh-syntax-highlighting-filetypes", nice:11

zplug "modules/osx", from:prezto, nice:0, if:"[[ $OSTYPE == *darwin* ]]"
zplug "unixorn/tumult.plugin.zsh", nice:7, if:"[[ $OSTYPE == *darwin* ]]"
