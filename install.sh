#!/bin/bash

function install_common() {
  cd "${HOME}"
  echo 'Creating directories...'
  mkdir -p ~/.pip ~/.ssh/assh.d ~/.config/ranger ~/.local/bin \
    ~/.tmux/plugins ~/.vim/bundle

  echo 'Cloning zplug, dotfiles, tpm, and neobundle...'
  git clone https://github.com/zplug/zplug ~/.zplug
  mkdir -p ~/.zplug/repos/paulhybryant/
  git clone --recurse-submodules https://github.com/paulhybryant/dotfiles \
    ~/.zplug/repos/paulhybryant/dotfiles
  git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  git clone https://github.com/Shougo/vimproc.vim.git ~/.vim/bundle/vimproc.vim
  cd ~/.vim/bundle/vimproc.vim
  make
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  cd ~/.zplug/repos/paulhybryant/dotfiles
  git remote set-url origin git@github.com:paulhybryant/dotfiles.git
  echo 'Stowing dotfiles...'
  for module in misc tmux vim zsh private; do
    stow "${module}" -t ~
  done
  chmod 400 ~/.ssh/paulhybryant

  echo 'Installing vim plugins...'
  vim -c 'NeoBundleInstall' -c 'q'

  echo 'Installing tmux plugins...'
  ~/.tmux/plugins/tpm/bin/install_plugins

  # pip

  # gem

  # npm
  # js-beautify, bundle-id-cli
}

function install_linux() {
  if [ ! -x "$(command -v brew)" ]; then
    echo 'Installing brew...'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" < /dev/null
    export PATH="${HOME}/.linuxbrew/bin:$PATH"
  fi
  stow linux -t ~

  echo 'Restoring brew...'
  ./linux/linuxbrew.zsh
}

function install_osx() {
  if [ ! -x "$(command -v brew)" ]; then
    echo 'Installing brew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  fi
  stow osx -t ~

  echo 'Restoring brew...'
  ./osx/homebrew.zsh
}

install_common
if [[ "${OSTYPE}" == *darwin* ]]; then
  install_osx
else
  install_linux
fi

echo 'Reloading zsh...'
exec zsh
