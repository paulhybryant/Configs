#!/bin/bash

for module in bash misc vim tmux zsh; do
  stow $module -t ~
done

if [[ $OSTYPE == linux* ]]; then
  stow linux -t ~
else
  stow osx -t ~
fi
