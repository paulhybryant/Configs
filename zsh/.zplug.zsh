export ZPLUG_HOME="$BREWHOME/opt/zplug"
source ${ZPLUG_HOME}/init.zsh

zplug "modules/directory", from:prezto, nice:0
zplug "modules/dpkg", from:prezto, nice:0
zstyle ':prezto:module:editor' 'key-bindings' 'vi'
zplug "modules/editor", from:prezto, nice:0
zstyle ':prezto:environment:termcap' 'color' 'yes'
zplug "modules/environment", from:prezto, nice:0
zplug "modules/fasd", from:prezto, nice:0
zplug "modules/helper", from:prezto, nice:0
zplug "modules/history", from:prezto, nice:0
zplug "modules/homebrew", from:prezto, nice:0
zstyle ':prezto:module:syntax-highlighting' 'color' 'yes'
zplug "modules/syntax-highlighting", from:prezto, nice:0

zplug "seebi/dircolors-solarized"
zplug "zsh-users/zsh-history-substring-search", nice:8
zplug "paulhybryant/powerline-shell", use:"powerline-shell.zsh", nice:8
zplug "junegunn/fzf", use:"shell/*.zsh", nice:8
zplug "zlsun/solarized-man", use:"solarized-man.plugin.zsh", nice:8
zplug "paulhybryant/myzsh", use:"enabled/*.zsh", nice:9

if __zplug::base::base::is_osx; then
  zplug "modules/osx", from:prezto, nice:0
  zplug "unixorn/tumult.plugin.zsh", use:"tumult.plugin.zsh", nice:8
fi

# zplug "andrewferrier/fzf-z"
