#!/bin/bash

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
if [ ! -x "$(command -v brew)" ]; then
  if [[ "${OSTYPE}" == *darwin* ]]; then
    echo 'Installing brew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  else
    echo 'Installing brew...'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" < /dev/null
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  fi
fi

echo 'Stowing dotfiles...'
for module in misc tmux vim zsh; do
  stow "${module}" -t ~
done

if [[ "${OSTYPE}" == *darwin* ]]; then
  stow osx -t ~
else
  stow linux -t ~
fi

echo 'Installing vim plugins...'
vim -c 'NeoBundleInstall' -c 'q'

echo 'Installing tmux plugins...'
~/.tmux/plugins/tpm/bin/install_plugins

# echo 'Restoring brew...'
# if [[ "${OSTYPE}" == *darwin* ]]; then
  # ./osx/homebrew.zsh
# else
  # ./linux/linuxbrew.zsh
# fi

# pip

# gem

# npm
# js-beautify, bundle-id-cli

echo 'Reloading zsh...'
exec zsh
