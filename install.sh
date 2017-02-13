#!/usr/bin/env bash

cd $HOME
echo 'Creating directories...'
mkdir -p ~/.pip ~/.ssh/assh.d ~/.cheat ~/.config/ranger ~/.local/bin \
  ~/.tmux/plugins ~/.vim/bundle

echo 'Cloning zplug, dotfiles, tpm, basher and neobundle...'
git clone https://github.com/zplug/zplug ~/.zplug
mkdir -p ~/.zplug/repos/paulhybryant/
git clone https://github.com/paulhybryant/dotfiles \
  ~/.zplug/repos/paulhybryant/dotfiles
git clone https://github.com/basherpm/basher.git ~/.basher
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
git clone https://github.com/Shougo/vimproc.vim.git ~/.vim/bundle/vimproc.vim
cd ~/.vim/bundle/vimproc.vim
make
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cd ~/.zplug/repos/paulhybryant/dotfiles
echo 'Installing brew...'
if [[ $OSTYPE == *darwin* ]]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install python
  brew install macvim --with-override-system-vim --with-lua --with-luajit
else
  sudo apt-get install bison flex xsltproc
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  brew install python
  brew install vim --with-override-system-vi --with-client-server --with-lua --with-luajit
fi
brew install stow tmux

echo 'Stowing dotfiles...'
for module in bash misc tmux vim zsh; do
  stow $module -t ~
done

if [[ $OSTYPE == *darwin* ]]; then
  stow osx -t ~
else
  stow linux -t ~
fi

echo 'Installing vim plugins...'
vim -c 'NeoBundleInstall' -c 'q'

echo 'Installing tmux plugins...'
~/.tmux/plugins/tpm/bin/install_plugins

read -p "Restore brew (this can take a while)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo 'Restoring brew...'
  if [[ $OSTYPE == *darwin* ]]; then
    ./osx/homebrew.zsh
  else
    ./linux/linuxbrew.zsh
  fi
fi

echo 'Reloading zsh...'
exec zsh
