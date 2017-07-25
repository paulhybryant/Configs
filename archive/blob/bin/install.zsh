#!/usr/bin/env zsh

local -a dryrun
zparseopts -D -K -M -E -- n=dryrun -dryrun=dryrun

local logfile brewhome
local -a stows
logfile=$(mktemp)

function log() {
  printf "$*" | tee -a "${logfile}"
}

function run() {
  if [[ -n ${dryrun} ]]; then
    printf "Running: $*\n"
  else
    eval "$*"
  fi
}

log 'Sourcing .zplug.zsh...\n'
run "source <(curl -sL https://raw.githubusercontent.com/paulhybryant/dotfiles/master/zsh/.zplug.zsh)"
pushd $ZPLUG_REPOS/paulhybryant/dotfiles

# log 'Sourcing .zplugin.zsh...\n'
# run "source <(curl -sL https://raw.githubusercontent.com/paulhybryant/dotfiles/master/zsh/.zplugin.zsh)"
# pushd $ZPLG_PLUGINS_DIR/paulhybryant---dotfiles

stows=(vim zsh tmux misc)
if [[ $OSTYPE == *linux* ]]; then
  brewhome="~/.linuxbrew"
  stows+=(linux)
else
  brewhome="~/.homebrew"
  stows+=(osx)
fi

log "Installing brew to $brewhome...\n"
run "git clone https://github.com/Homebrew/brew.git $brewhome"
run "path+=($brewhome)"

if [[ $OSTYPE == *linux* ]]; then
  run "./blob/bin/brew-import-linux.zsh"
else
  run "./blob/bin/brew-import-osx.zsh"
fi

log "Stowing...\n"
run "mkdir -p ~/.local/bin"
for module in $stows; do
  run "stow $module -t ~ -v | tee -a \"${logfile}\""
done

# Note that pipdeptree can only be installed for one python version.
# Installation runs later will overwrite the binary of previous installation.
run "pip2 install pipdeptree powerline-status pyclewn trash-cli neovim jedi pip-autoremove"
run "pip3 install gnureadline xonsh-apt-tabcomplete xonsh-autoxsh xontrib-prompt-ret-code xontrib-z"j

run "npm install js-beautify"

printf "Installation logs at ${logfile}\n"
popd
