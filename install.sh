#!/bin/sh

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
if [ $OSTYPE == *darwin* ]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ./osx/homebrew.zsh
else
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  ./linux/linuxbrew.zsh
fi

echo 'Stowing dotfiles...'
for module in bash misc tmux vim zsh; do
  stow $module -t ~
done

if [ $OSTYPE == *darwin* ]; then
  stow osx -t ~
else
  stow linux -t ~
fi

echo 'Installing vim plugins...'
vim -c 'NeoBundleInstall' -c 'q'

echo 'Installing tmux plugins...'
~/.tmux/plugins/tpm/bin/install_plugins

echo 'Reloading zsh...'
exec zsh
