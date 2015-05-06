#!/usr/bin/env bash

set -o nounset                  # Treat unset variables as an error.
set -o errexit                  # Exit script when run into the first error.

# realpath is not available on osx
# to install:
# brew tap iveney/mocha
# brew install realpath
# http://blog.ivansiu.com/blog/2014/05/01/os-x-get-full-path-of-file-using-realpath/

SCRIPT_PATH=$(dirname "$0")
which realpath > /dev/null 2>/dev/null
if [[ $? -ne 0 ]]; then
  [[ "$OSTYPE" != "darwin"* ]] && sudo apt-get install realpath
  [[ "$OSTYPE" == "darwin"* ]] && brew tap iveney/mocha && brew install realpath
fi

echo $SCRIPT_PATH
which pip > /dev/null 2>/dev/null
if [[ $? -ne 0 ]]; then
  [[ "$OSTYPE" != "darwin"* ]] && sudo apt-get install python-pip && sudo pip install toposort
  [[ "$OSTYPE" == "darwin"* ]] && brew install pip
fi

source "$SCRIPT_PATH/shlib/common.sh"

current_script_path "$0" "SCRIPT_PATH"
link_misc "$SCRIPT_PATH/misc"
link_tmux "$SCRIPT_PATH/tmux"
link_vim "$SCRIPT_PATH/vim"
link_bash "$SCRIPT_PATH/bash"
link_utils "$SCRIPT_PATH/utils"
link_zsh "$SCRIPT_PATH/zsh"
link_x11 "$SCRIPT_PATH/x11"
link_ctags "$SCRIPT_PATH/ctags"

ssh-add -L | grep "github"
if [[ $? -ne 0 ]]; then
  echo "Need to add ssh identity."
fi

python "$SCRIPT_PATH/pylib/install.py"
