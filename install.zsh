#!/usr/bin/env zsh

usage() {
  cat <<EOF
Usage: install.sh [arguments]

Arguments:
  -h or --help    Print the usage information
EOF
}

local -a verbose help
zparseopts -D -K -M -E -- h=help v=verbose \
  -help=help -verbose=verbose

[[ -n ${help} ]] && usage && return 0

local log
log=$(mktemp)

printf 'Sourcing antigen...\n' | tee "${log}"
source <(curl -sL https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh) || return 1

[[ -n ${verbose} ]] && setopt verbose
local url="$(-antigen-resolve-bundle-url 'https://github.com/paulhybryant/dotfiles.git')"
-antigen-ensure-repo "${url}"
pushd $(-antigen-get-clone-dir "${url}")
git remote set-url origin 'git@github.com:paulhybryant/dotfiles.git'
./zsh/.zsh/bin/bootstrap --dryrun | tee -a "${log}"
printf 'Continue [y/n]? '
read -r reply
case $reply in
  Y*|y*)
    printf 'Bootstraping...\n' | tee -a "${log}"
    ./zsh/.zsh/bin/bootstrap --log "${log}" | tee -a "${log}"
    ;;
  *)
    exit 1
    ;;
esac
popd
