#!/bin/sh

git clone https://github.com/zplug/zplug ~/.zplug
git clone https://github.com/basherpm/basher.git ~/.basher
mkdir -p ~/.pip ~/.ssh/assh.d ~/.cheat ~/.config/ranger ~/.local/bin ~/.tmux ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

for module in bash misc tmux vim zsh; do
  stow $module -t ~
done

if [[ $OSTYPE == *darwin* ]]; then
  stow osx -t ~
else
  stow linux -t ~
fi

exec zsh

vim -c 'NeoBundleInstall' -c 'q'
~/.tmux/plugins/tpm/bin/install_plugins
