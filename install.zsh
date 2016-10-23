#!/usr/bin/env zsh

local -a dryrun
zparseopts -D -K -M -E -- n=dryrun -dryrun=dryrun

local logfile brewtap brewhome brewjson
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
  brewjson=$(cat "$PWD/blob/config/brew.linux.json")
  stows+=(linux)
else
  brewhome="~/.homebrew"
  brewtap="PWD/blob/config/brew.osx.tap"
  brewjson=$(cat "$PWD/blob/config/brew.osx.json")
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

run "brew install jq"
log "Brew formulae: \n"
# brew info --json=v1 --installed | jq '.[] | select(.installed[0].used_options!=[]) | { name: .name, used_options: .installed[0].used_options}' >! brew.linux.json
# brew info --json=v1 --installed | jq '.[] | { name: .name, used_options: .installed[0].used_options}' >! brew.linux.json
# brew info --json=v1 --installed | jq '.[] | if (.installed[0].used_options != []) then { name: .name, used_options: .installed[0].used_options } else { name: .name }' >! brew.linux.json
while read formula; do
  local used_options
  if [[ $formula != "jq" ]]; then
    used_options=$(echo $brewoptions | jq 'select(.name == "$formula") | .used_options')
    run "brew install $used_options $formula"
  fi
done < $brewjson

printf "Installation logs to ${logfile}\n"
popd
