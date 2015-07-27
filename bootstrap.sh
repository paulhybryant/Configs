#!/usr/bin/env zsh

# set -o nounset                  # Treat unset variables as an error.
# set -o errexit                  # Exit script when run into the first error.

# realpath is not available on osx
# to install:
# brew tap iveney/mocha
# brew install realpath
# http://blog.ivansiu.com/blog/2014/05/01/os-x-get-full-path-of-file-using-realpath/
# or
# brew install coreutils

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
link_all "$SCRIPT_PATH"

function brew_all() {
  brew tap paulhybryant/myformulae
  brew tap homebrew/x11
  brew tap homebrew/dupes
  brew tap homebrew/completions

  brew install --HEAD paulhybryant/myformulae/powerline-shell
  brew install --HEAD paulhybryant/myformulae/zsh-completions
  brew install --with-gssapi --with-libssh2 --with-rtmpdump curl
  brew install --disable-nls --override-system-vi --with-client-server --with-lua --with-luajit --with-gui vim
  brew install brew-gem cmake ctags git htop python python3 the_silver_searcher tmux vimpager zsh
  brew gem install tmuxinator
  brew install vimdoc vroom

  [[ "$OSTYPE" == "darwin"* ]] && brew install brew-cask clipper macvim
}
brew_all

# python "$SCRIPT_PATH/pylib/install.py"
