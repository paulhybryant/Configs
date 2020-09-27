#!/bin/bash
set -e

function install_common() {
  cd "${HOME}"
  echo 'Creating directories...'
  mkdir -p ~/.pip ~/.cache ~/.ssh/assh.d ~/.config/ranger ~/.local/bin \
    ~/.tmux/plugins ~/.vim/bundle

  echo 'Cloning zplug, dotfiles, tpm, and neobundle...'
  git clone https://github.com/zplug/zplug ~/.zplug
  mkdir -p ~/.zplug/repos/paulhybryant/
  git clone --depth=1 https://github.com/paulhybryant/dotfiles \
    ~/.zplug/repos/paulhybryant/dotfiles
}

function post_install_common() {
  git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  git clone https://github.com/Shougo/vimproc.vim.git ~/.vim/bundle/vimproc.vim
  cd ~/.vim/bundle/vimproc.vim
  make
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  cd ~/.zplug/repos/paulhybryant/dotfiles
  echo 'Stowing dotfiles...'
  for module in misc tmux vim zsh; do
    stow "${module}" -t ~
  done

  echo 'Installing tmux plugins...'
  ~/.tmux/plugins/tpm/bin/install_plugins

  echo 'Installing vim plugins...'
  vim -c 'set nomore' -c 'NeoBundleInstall' -c 'q'
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
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  fi
  cd ~/.zplug/repos/paulhybryant/dotfiles
  ./linux/linuxbrew.sh
  stow linux -t ~

  # curl -L https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb -o /tmp/bat.deb
  # sudo dpkg -i /tmp/bat.deb
  # curl -L 'http://paulhybryant.myqnapcloud.com:8880/kodexplorer/index.php?user/publicLink&fid=1a13Nx54XO5WUkiKaT9fg-iVHIAImculBfkfpcunXXynpMMZdYRQ7lVv5tEfo4pJAnf7ajS7UiJE2oVy8X8FA2hixDn6HL4n9KGYIrQJPlCzsDVPUF-NBtlMj3EEJYJwkoQd022x76byYxsTtJ4-TCtWL2lfEvZh3Q&file_name=/fsqlf_20181130-1_amd64.deb' -o /tmp/fsqlf.deb \
  # sudo dpkg -i /tmp/fsqlf.deb
}

function install_osx() {
  if [ ! -x "$(command -v brew)" ]; then
    echo 'Installing brew...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  cd ~/.zplug/repos/paulhybryant/dotfiles
  ./osx/homebrew.sh
  stow osx -t ~
}

install_common
if [[ "${OSTYPE}" == *darwin* ]]; then
  install_osx
else
  install_linux
fi
post_install_common
