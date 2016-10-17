export ZPLUG_HOME="$BREWHOME/opt/zplug"
export ZPLUG_REPOS="$HOME/.zplug/repos"
source ${ZPLUG_HOME}/init.zsh

zplug "paulhybryant/dotfiles", as:command, use:"misc/.local/bin/{xclipper,save2tmp}", nice:0

zstyle ":prezto:environment:termcap" "color" "yes"
zplug "modules/environment", from:prezto, nice:0
zplug "modules/directory", from:prezto, nice:1
zplug "modules/helper", from:prezto, nice:1
# zstyle ":prezto:module:editor" "key-bindings" "vi"
# zplug "modules/editor", from:prezto, nice:1
# zplug "modules/ssh", from:prezto, nice:1
zplug "modules/history", from:prezto, nice:1
zplug "modules/osx", from:prezto, nice:1, if:"[[ $OSTYPE == *darwin* ]]"

# For unknown reason, zplug clear && zplug load will cause zsh to exit if
# autosuggestions and zsh-syntax-highlighting are enabled at the same time.
zplug "zsh-users/zsh-autosuggestions", nice:5
zplug "zsh-users/zsh-history-substring-search", nice:5

zplug "RobSis/zsh-completion-generator", nice:6
zplug "psprint/ztrace", nice:6
zplug "psprint/zsnapshot", nice:6
zplug "jocelynmallon/zshmarks", nice:6
zplug "sharat87/zsh-vim-mode", nice:6
zplug "seebi/dircolors-solarized", nice:6
zplug "paulhybryant/powerline-shell", nice:6
zplug "junegunn/fzf", use:"shell/*.zsh", nice:6
zplug "zlsun/solarized-man", nice:6
# zplug "andrewferrier/fzf-z", nice:6
zplug "unixorn/tumult.plugin.zsh", nice:6, if:"[[ $OSTYPE == *darwin* ]]"
# zplug "b4b4r07/enhancd", use:"init.sh", nice:7
zplug "paulhybryant/myzsh", use:"enabled", nice:8

# zplug "zsh-users/zsh-syntax-highlighting", nice:10
# zplug "trapd00r/zsh-syntax-highlighting-filetypes", nice:11
