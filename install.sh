#!/bin/sh

print 'Creating directories...'
mkdir -p ~/.pip ~/.ssh/assh.d ~/.cheat ~/.config/ranger ~/.local/bin ~/.tmux \
  ~/.vim/bundle ~/.zplug/repos/paulhybryant/

print '\nCloning zplug, dotfiles, basher and neobundle...'
git clone https://github.com/zplug/zplug ~/.zplug
git clone https://github.com/paulhybryant/dotfiles \
  ~/.zplug/repos/paulhybryant/dotfiles
git clone https://github.com/basherpm/basher.git ~/.basher
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

print '\nStowing dotfiles...'
pushd ~/.zplug/repos/paulhybryant/dotfiles
for module in bash misc tmux vim zsh; do
  stow $module -t ~
done

if [[ $OSTYPE == *darwin* ]]; then
  stow osx -t ~
else
  stow linux -t ~
fi

print '\nInstalling vim plugins...'
vim -c 'NeoBundleInstall' -c 'q'

print '\nInstalling tmux plugins...'
~/.tmux/plugins/tpm/bin/install_plugins

print '\nReloading zsh...'
exec zsh
