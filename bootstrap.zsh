#!/usr/bin/env zsh

# set -o nounset                  # Treat unset variables as an error.
set -o errexit                  # Exit script when run into the first error.

MYCONFIGS=${0:h}
source $MYCONFIGS/shlib/init.zsh
source $MYCONFIGS/shlib/base.zsh
source $MYCONFIGS/shlib/os.zsh
source $MYCONFIGS/shlib/io.zsh
base::bootstrap

# Bootstrap util functions {{{
function backup_and_link() {
  local _src_=$1
  local _target_=$2

  if [[ -h "$_target_" ]]; then
    rm "$_target_"
  elif [[ -f "$_target_" ]]; then
    echo "Please rename or backup $_target_."
    return
  fi

  if [[ -d "$_target_" ]]; then
    echo "Directory $_target_ already exists."
    return
  fi
  ln -s "$_src_" "$_target_"
}

function link_bash() {
  [[ "$#" == 1 ]] || return 1
  local _bashconf_="$1"
  _bashconf_="${_bashconf_%/}"

  [[ -z "$__BASH_CUSTOM__" ]] && echo "source $HOME/.bashrc.custom" >> "$HOME/.bashrc"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ ! -f "$HOME/.bash_profile" ]]; then
      echo "if [[ -f \"$HOME/.bashrc\" ]]; then source \"$HOME/.bashrc;\" fi" > "$HOME/.bash_profile"
    fi
  fi

  backup_and_link "$_bashconf_/.bashrc.custom" "$HOME/.bashrc.custom"
}

function link_misc() {
  [[ "$#" == 1 ]] || return 1
  local _miscfong_="$1"
  _miscfong_="${_miscfong_%/}"

  mkdir -p "$HOME/.config/terminator" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/terminator_config" "$HOME/.config/terminator/config"

  mkdir -p "$HOME/.config/pip" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/pip.conf" "$HOME/.config/pip/pip.conf"

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/.inputrc" "$HOME/.inputrc"
  backup_and_link "$_miscfong_/.gitconfig-linux" "$HOME/.gitconfig"
  backup_and_link "$_miscfong_/.gitignore" "$HOME/.gitignore"
  backup_and_link "$_miscfong_/git-new-workdir" "$HOME/.local/bin/git-new-workdir"
  backup_and_link "$_miscfong_/assh.config" "$HOME/.ssh/config.advanced"
}

function link_tmux() {
  [[ "$#" == 1 ]] || return 1
  local _tmuxconf_="$1"
  _tmuxconf_="${_tmuxconf_%/}"

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    backup_and_link "$_tmuxconf_/.tmux.conf.linux" "$HOME/.tmux.conf.local"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    backup_and_link "$_tmuxconf_/.tmux.conf.mac" "$HOME/.tmux.conf.local"
  fi

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  backup_and_link "$_tmuxconf_/.tmux-default.conf" "$HOME/.tmux-default.conf"
  backup_and_link "$_tmuxconf_/.tmux.conf" "$HOME/.tmux.conf"
  backup_and_link "$_tmuxconf_/.tmux.extra.conf" "$HOME/.tmux.extra.conf"
  backup_and_link "$_tmuxconf_/muxcfg" "$HOME/.local/bin/muxcfg"

  mkdir -p "$HOME/.tmuxinator" > /dev/null 2>/dev/null
  backup_and_link "$_tmuxconf_/project.yml.template" "$HOME/.tmuxinator/project.yml.template"

  mkdir -p "$HOME/.tmux"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function link_utils() {
  [[ "$#" == 1 ]] || return 1
  local _utilsconf_="$1"
  _utilsconf_="${_utilsconf_%/}"

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  backup_and_link "$_utilsconf_/bash/winmove.sh" "$HOME/.local/bin/winmove.sh"
  backup_and_link "$_utilsconf_/bash/winresize.sh" "$HOME/.local/bin/winresize.sh"
}

function link_vim() {
  [[ "$#" == 1 ]] || return 1
  local _vimconf_="$1"
  _vimconf_="${_vimconf_%/}"

  backup_and_link "$_vimconf_/.gvim.sh" "$HOME/.gvim.sh"
  backup_and_link "$_vimconf_/.gvimrc" "$HOME/.gvimrc"
  backup_and_link "$_vimconf_/.vimrc" "$HOME/.vimrc"
}

function link_zsh() {
  [[ "$#" == 1 ]] || return 1
  local _zshconf_="$1"
  _zshconf_="${_zshconf_%/}"

  if [[ ! -d "$HOME/.zprezto" ]]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  fi

  # if [[ -d "$HOME/.zshcustom" ]]; then
    # echo "$HOME/.zshcustom exists! Nothing done."
    # return
  # fi

  # _zshcustom_="$HOME/.zshcustom"
  # mkdir -p "$_zshcustom_" > /dev/null 2>/dev/null

  backup_and_link "$_zshconf_/.zshrc.common" "$HOME/.zshrc.common"

  # if [[ ! -h "$_zshcustom_/themes" ]]; then
    # ln -s "$_zshconf_/themes" "$_zshcustom_/themes"
  # fi
}

function link_x11() {
  [[ "$#" == 1 ]] || return 1
  local _x11conf_="$1"
  _x11conf_="${_x11conf_%/}"

  # backup_and_link "$_x11conf_/.xinitrc" "$HOME/.xinitrc"
  backup_and_link "$_x11conf_/.xinitrc" "$HOME/.xsessionrc"
  backup_and_link "$_x11conf_/.xbindkeysrc" "$HOME/.xbindkeysrc"
}

function link_ctags() {
  [[ "$#" == 1 ]] || return 1
  local _ctagsconf_="$1"
  _ctagsconf_="${_ctagsconf_%/}"

  backup_and_link "$_ctagsconf_" "$HOME/.ctagscnf"
}

function link_all() {
  [[ "$#" == 1 ]] || return 1
  local _scriptpath_="$1"
  link_misc "$_scriptpath_/misc"
  link_tmux "$_scriptpath_/tmux"
  link_vim "$_scriptpath_/vim"
  link_bash "$_scriptpath_/bash"
  link_utils "$_scriptpath_/utils"
  link_zsh "$_scriptpath_/zsh"
  link_x11 "$_scriptpath_/x11"
  link_ctags "$_scriptpath_/ctags"
}
# }}}

io::msg "Creating dir $BREWHOME"
mkdir -p "$BREWHOME"
io::msg "Cloning ${BREWVERSION}"
git clone https://github.com/Homebrew/${BREWVERSION} $BREWHOME

brew install coreutils
io::msg "Creating symlinks from ${MYCONFIGS}"
link_all "${MYCONFIGS}"

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
brew gem install tmuxinator
brew install vimdoc vroom

io::msg "Installing extra stuff for OSX"
os::mac && brew install brew-cask clipper macvim

io::msg "All Done!"
