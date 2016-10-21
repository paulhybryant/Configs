#!/usr/bin/env zsh

local -a dryrun
zparseopts -D -K -M -E -- n=dryrun -dryrun=dryrun

local logfile brewtap brewhome brewformula
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

log 'Sourcing zplug.zsh...\n'
run "source <(curl -sL https://raw.githubusercontent.com/paulhybryant/dotfiles/master/zsh/.zplug.zsh)"

pushd $ZPLUG_REPOS/paulhybryant/dotfiles
stows=(vim zsh tmux misc)
if [[ $OSTYPE == *linux* ]]; then
  brewhome="~/.linuxbrew"
  brewtap="$PWD/blob/config/brew.linux.tap"
  brewformula="$PWD/blob/config/brew.linux.leaves"
  stows+=(linux)
else
  brewhome="~/.homebrew"
  brewtap="PWD/blob/config/brew.osx.tap"
  brewformula="$PWD/blob/config/brew.osx.leaves"
  stows+=(osx)
fi

log "Stowing...\n"
for module in $stows; do
  run "stow $module -t ~ -v | tee -a \"${logfile}\""
done

log "Installing brew to $brewhome...\n"
run "git clone https://github.com/Homebrew/brew.git $brewhome"
run "path+=($brewhome)"

log "Brew taps: $brewtap\n"
while read tap; do
  run "brew tap $tap"
done < $brewtap

log "Brew formulae: $brewformula\n"
while read formula; do
  run "brew install $formula"
done < $brewformula

printf "Installation logs to ${logfile}\n"
popd
