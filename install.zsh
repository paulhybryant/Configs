#!/usr/bin/env zsh

local -a dryrun
zparseopts -D -K -M -E -- n=dryrun -dryrun=dryrun

local logfile brewtap brewhome brewformula brewoptions
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
  brewoptions=$(cat "$PWD/blob/config/brew.linux.options")
  stows+=(linux)
else
  brewhome="~/.homebrew"
  brewtap="PWD/blob/config/brew.osx.tap"
  brewformula="$PWD/blob/config/brew.osx.leaves"
  brewoptions=$(cat "$PWD/blob/config/brew.osx.options")
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
run "brew install jq"

# brew info --json=v1 --installed | jq '.[] | select(.installed[0].used_options!=[]) | { name: .name, used_options: .installed[0].used_options}' >! brew.linux.options
while read formula; do
  local used_options
  if [[ $formula != "jq" ]]; then
    used_options=$(echo $brewoptions | jq 'select(.name == "$formula") | .used_options')
    run "brew install $used_options $formula"
  fi
done < $brewformula

printf "Installation logs to ${logfile}\n"
popd
