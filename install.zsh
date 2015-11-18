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

echo "Sourcing antigen..."
source <(curl -sL https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh) || return 1

[[ -n ${verbose} ]] && setopt verbose
local url="$(-antigen-resolve-bundle-url "https://github.com/paulhybryant/Configs.git")"
-antigen-ensure-repo "${url}"
pushd $(-antigen-get-clone-dir "${url}")
git remote set-url origin "git@github.com:paulhybryant/Configs.git"
./zsh/.zsh/bin/bootstrap --dryrun
echo "Continue [y/n]? "
read -r reply
case $reply in
  Y*|y*)
    echo "Installing..."
    ./zsh/.zsh/bin/bootstrap
    ;;
  *)
    exit 1
    ;;
esac
popd
