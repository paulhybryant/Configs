#!/usr/bin/env zsh

usage() {
  cat <<EOF
Usage: install.sh [arguments]

Arguments:
  -h          Print the usage information
EOF
}

while getopts ":h" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

echo "Sourcing antigen..."
source <(curl -sL https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh) || exit 1
setopt verbose
local url="$(-antigen-resolve-bundle-url "git@github.com:paulhybryant/Configs.git")"
-antigen-ensure-repo "${url}"
pushd $(-antigen-get-clone-dir "${url}")
./zsh/.zsh/bin/bootstrap -n
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
unsetopt verbose
