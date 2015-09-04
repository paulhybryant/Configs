#!/usr/bin/env zsh

# set -o nounset                  # Treat unset variables as an error.
# set -o errexit                  # Exit script when run into the first error.

export __MYZSHLIB__=$(dirname "${0:a}")

source ${__MYZSHLIB__}/*.zsh

mkdir -p "$BREWHOME"
git clone https://github.com/Homebrew/${BREWVERSION} $BREWHOME

brew install coreutils
link_all "${__MYZSHLIB__}"

brew tap paulhybryant/myformulae
brew tap homebrew/x11
brew tap homebrew/dupes
brew tap homebrew/completions
brew tap iveney/mocha

brew install --HEAD paulhybryant/myformulae/powerline-shell
brew install --HEAD paulhybryant/myformulae/zsh-completions
brew install --with-gssapi --with-libssh2 --with-rtmpdump curl
brew install --disable-nls --override-system-vi --with-client-server --with-lua --with-luajit --with-gui vim
brew install brew-gem cmake ctags git htop python python3 the_silver_searcher tmux vimpager zsh
brew gem install tmuxinator
brew install vimdoc vroom

os::mac && brew install brew-cask clipper macvim
