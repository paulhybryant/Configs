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

curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > /tmp/antigen.zsh
source /tmp/antigen.zsh
local url="$(-antigen-resolve-bundle-url "paulhybryant/Configs")"
-antigen-ensure-repo "${url}"
$(-antigen-get-clone-dir "${url}")/zsh/.zsh/bin/bootstrap -n
echo "Continue [y/n]? "
read -r reply
case $reply in
  Y*|y*)
    echo "Installing..."
    "${install_dir}/zsh/.zsh/bin/bootstrap"
    ;;
  *)
    exit 1
    ;;
esac
