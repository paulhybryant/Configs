export ZPLUG_HOME="$BREWHOME/opt/zplug"
source ${ZPLUG_HOME}/init.zsh

zplug "zsh-users/zsh-history-substring-search"
zplug "paulhybryant/powerline-shell", use:"powerline-shell.zsh"
zplug "junegunn/fzf", use:"shell/*.zsh"
# zplug "andrewferrier/fzf-z"
# zplug "modules/fasd", from:prezto
