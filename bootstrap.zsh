#!/usr/bin/env zsh

# set -o nounset                  # Treat unset variables as an error.
set -o errexit                  # Exit script when run into the first error.

MYCONFIGS="${0:h}"
source "${MYCONFIGS}/shlib/init.zsh"
source "${MYCONFIGS}/shlib/base.zsh"
source "${MYCONFIGS}/shlib/configs.zsh"
source "${MYCONFIGS}/shlib/file.zsh"
source "${MYCONFIGS}/shlib/io.zsh"
source "${MYCONFIGS}/shlib/os.zsh"
configs::bootstrap

# Bootstrap util functions {{{
function link_misc() {
  [[ "$#" == 1 ]] || return 1
  local _miscfong_="$1"
  _miscfong_="${_miscfong_%/}"

  mkdir -p "$HOME/.config/terminator" > /dev/null 2>/dev/null
  file::softlink "$_miscfong_/terminator_config" "$HOME/.config/terminator/config"

  mkdir -p "$HOME/.config/pip" > /dev/null 2>/dev/null
  file::softlink "$_miscfong_/pip.conf" "$HOME/.config/pip/pip.conf"

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  file::softlink "$_miscfong_/.inputrc" "$HOME/.inputrc"
  file::softlink "$_miscfong_/.gitconfig-linux" "$HOME/.gitconfig"
  file::softlink "$_miscfong_/.gitignore" "$HOME/.gitignore"
  file::softlink "$_miscfong_/git-new-workdir" "$HOME/.local/bin/git-new-workdir"
  file::softlink "$_miscfong_/assh.config" "$HOME/.ssh/config.advanced"
}
function link_tmux() {
  [[ "$#" == 1 ]] || return 1
  local _tmuxconf_="$1"
  _tmuxconf_="${_tmuxconf_%/}"

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    file::softlink "$_tmuxconf_/.tmux.conf.linux" "$HOME/.tmux.conf.local"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    file::softlink "$_tmuxconf_/.tmux.conf.mac" "$HOME/.tmux.conf.local"
  fi

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  file::softlink "$_tmuxconf_/.tmux-default.conf" "$HOME/.tmux-default.conf"
  file::softlink "$_tmuxconf_/.tmux.conf" "$HOME/.tmux.conf"
  file::softlink "$_tmuxconf_/.tmux.extra.conf" "$HOME/.tmux.extra.conf"
  file::softlink "$_tmuxconf_/muxcfg" "$HOME/.local/bin/muxcfg"

  mkdir -p "$HOME/.tmuxinator" > /dev/null 2>/dev/null
  file::softlink "$_tmuxconf_/project.yml.template" "$HOME/.tmuxinator/project.yml.template"

  mkdir -p "$HOME/.tmux"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}
function link_utils() {
  [[ "$#" == 1 ]] || return 1
  local _utilsconf_="$1"
  _utilsconf_="${_utilsconf_%/}"

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  file::softlink "$_utilsconf_/bash/winmove.sh" "$HOME/.local/bin/winmove.sh"
  file::softlink "$_utilsconf_/bash/winresize.sh" "$HOME/.local/bin/winresize.sh"
}
function link_vim() {
  [[ "$#" == 1 ]] || return 1
  local _vimconf_="$1"
  _vimconf_="${_vimconf_%/}"

  file::softlink "$_vimconf_/.gvim.sh" "$HOME/.gvim.sh"
  file::softlink "$_vimconf_/.gvimrc" "$HOME/.gvimrc"
  file::softlink "$_vimconf_/.vimrc" "$HOME/.vimrc"
}
function link_x11() {
  [[ "$#" == 1 ]] || return 1
  local _x11conf_="$1"
  _x11conf_="${_x11conf_%/}"

  # file::softlink "$_x11conf_/.xinitrc" "$HOME/.xinitrc"
  file::softlink "$_x11conf_/.xinitrc" "$HOME/.xsessionrc"
  file::softlink "$_x11conf_/.xbindkeysrc" "$HOME/.xbindkeysrc"
}
function link_ctags() {
  [[ "$#" == 1 ]] || return 1
  local _ctagsconf_="$1"
  _ctagsconf_="${_ctagsconf_%/}"

  file::softlink "$_ctagsconf_" "$HOME/.ctagscnf"
}
function link_all() {
  [[ "$#" == 1 ]] || return 1
  local _configpath="$1"
  link_misc "$_configpath/misc"
  link_tmux "$_configpath/tmux"
  link_vim "$_configpath/vim"
  # link_utils "$_configpath/utils"
  link_x11 "$_configpath/x11"
  # link_ctags "$_configpath/ctags"

  [[ ! -d "$HOME/.zprezto" ]] && return 1
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
}
# }}}

io::msg "Installing ${BREWVERSION} dependencies..."
os::LINUX && sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev trash-cli

if ! base::exists "${BREWHOME}"; then
  io::msg "Cloning ${BREWVERSION}"
  git clone https://github.com/Homebrew/${BREWVERSION} "${BREWHOME}"
fi

brew install coreutils
# io::msg "Creating symlinks from ${MYCONFIGS}"
# link_all "${MYCONFIGS}"

io::msg "Tapping extra repositories"
brew tap paulhybryant/myformulae
brew tap homebrew/x11
brew tap homebrew/dupes
brew tap homebrew/completions
brew tap iveney/mocha

io::msg "Installing softwares"
brew install --HEAD paulhybryant/myformulae/powerline-shell
brew install --HEAD paulhybryant/myformulae/zsh-completions
brew install --with-gssapi --with-libssh2 --with-rtmpdump curl
brew install --disable-nls --override-system-vi --with-client-server --with-lua --with-luajit --with-gui vim
brew install brew-gem cmake ctags git htop python python3 the_silver_searcher tmux vimpager zsh
brew gem install tmuxinator npm
brew install --HEAD vimdoc vroom
npm install -g urchin

os::OSX && io::msg "Installing extra stuff for OSX" && brew install brew-cask clipper macvim trash

io::msg "All Done!"
