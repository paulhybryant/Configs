#!/bin/sh

usage() {
  cat <<EOF
Usage: install.sh [arguments]

Arguments:
  -h          Print the usage information
  -d          Directory name
EOF
}

dir=".mycfg"
while getopts ":hd:" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    d)
      dir=$OPTARG
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

if [ ! -d "$HOME/${dir}" ]; then
  echo "Dryrun..."
  echo "Cloning to ${dir}..."
  git clone --recursive git@github.com:paulhybryant/Config.git "$HOME/${dir}"
  "$HOME/${dir}/zsh/.zutils/bin/bootstrap -n"

  echo "Continue [y/n]? "
  read -r reply
  case $reply in
    Y*|y*)
      echo "Installing..."
      "$HOME/${dir}/zsh/.zutils/bin/bootstrap"
      ;;
    *)
      exit 1
      ;;
  esac
else
  echo "Already installed. Nothing done."
fi
