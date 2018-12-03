#!/bin/bash
set -e

function install_common() {
  cd "${HOME}"
  echo 'Creating directories...'
  mkdir -p ~/.pip ~/.ssh/assh.d ~/.config/ranger ~/.local/bin \
    ~/.tmux/plugins ~/.vim/bundle

  echo 'Cloning zplug, dotfiles, tpm, and neobundle...'
  git clone https://github.com/zplug/zplug ~/.zplug
  mkdir -p ~/.zplug/repos/paulhybryant/
  git clone https://github.com/paulhybryant/dotfiles \
    ~/.zplug/repos/paulhybryant/dotfiles
  git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  git clone https://github.com/Shougo/vimproc.vim.git ~/.vim/bundle/vimproc.vim
  cd ~/.vim/bundle/vimproc.vim
  make
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  cd ~/.zplug/repos/paulhybryant/dotfiles
  git remote set-url origin git@github.com:paulhybryant/dotfiles.git
  echo 'Stowing dotfiles...'
  for module in misc tmux vim zsh; do
    stow "${module}" -t ~
  done

  echo 'Installing tmux plugins...'
  ~/.tmux/plugins/tpm/bin/install_plugins

  # echo 'Installing vim plugins...'
  # vim -c 'set nomore' -c 'NeoBundleInstall' -c 'q'
  # pip
  # gem
  # npm
  # js-beautify, bundle-id-cli
}

function install_linux() {
  # sudo apt-get install linuxbrew-wrapper
  # Prefer the user-space brew
  if [ ! -x "$(command -v brew)" ]; then
    echo 'Installing brew...'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" < /dev/null
    export PATH="${HOME}/.linuxbrew/bin:$PATH"
  fi
  cd ~/.zplug/repos/paulhybryant/dotfiles
  stow linux -t ~

  # curl -L https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb -o /tmp/bat.deb
  # sudo dpkg -i /tmp/bat.deb
  # curl -L http://www.paulhybryant.tk:8002/index.php/s/opmXFhdHJ3PLP5G/download -o /tmp/fsqlf.deb
  # sudo dpkg -i /tmp/fsqlf.deb
}

function install_osx() {
  if [ ! -x "$(command -v brew)" ]; then
    echo 'Installing brew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  fi
  cd ~/.zplug/repos/paulhybryant/dotfiles
  stow osx -t ~
}

install_common
if [[ "${OSTYPE}" == *darwin* ]]; then
  install_osx
else
  install_linux
fi
