export ZPLUG_HOME="$BREWHOME/opt/zplug"
export ZPLUG_REPOS="$HOME/.zplug/repos"
source ${ZPLUG_HOME}/init.zsh

zstyle ":prezto:environment:termcap" "color" "yes"
zplug "modules/environment", from:prezto, nice:0
zstyle ":prezto:module:autosuggestions" color "yes"
zplug "modules/autosuggestions", from:prezto, nice:1
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

zplug "zsh-users/zsh-history-substring-search", nice:7

zplug "seebi/dircolors-solarized", nice:7
zplug "paulhybryant/powerline-shell", nice:7
zplug "junegunn/fzf", use:"shell/*.zsh", nice:7
zplug "zlsun/solarized-man", nice:7
zplug "paulhybryant/myzsh", use:"enabled/*.zsh", nice:8

# nice must be 10 because it has to be loaded after compinit.
# see the project page for details.
# Disabled because causing zsh to exit
# zplug "zsh-users/zsh-syntax-highlighting", nice:10

zplug "modules/osx", from:prezto, nice:0, if:"[[ $OSTYPE == *darwin* ]]"
zplug "unixorn/tumult.plugin.zsh", nice:7, if:"[[ $OSTYPE == *darwin* ]]"
# zplug "andrewferrier/fzf-z"
