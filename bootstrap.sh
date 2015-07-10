#!/usr/bin/env zsh

# set -o nounset                  # Treat unset variables as an error.
# set -o errexit                  # Exit script when run into the first error.

# realpath is not available on osx
# to install:
# brew tap iveney/mocha
# brew install realpath
# http://blog.ivansiu.com/blog/2014/05/01/os-x-get-full-path-of-file-using-realpath/

SCRIPT_PATH=$(dirname "$0")
[[ "$OSTYPE" != "darwin"* ]] && BREWVERSION="linuxbrew"
[[ "$OSTYPE" == "darwin"* ]] && BREWVERSION="homebrew"
BREWHOME="$HOME/.${BREWVERSION}"
mkdir -p "$BREWHOME"
git clone https://github.com/Homebrew/${BREWVERSION} $BREWHOME
export PATH=$BREWHOME/bin:$PATH

brew install coreutils

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

# python "$SCRIPT_PATH/pylib/install.py"
