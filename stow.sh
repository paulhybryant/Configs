#!/bin/bash

for module in misc vim tmux zsh private; do
  stow $module -t ~
done

if [[ $OSTYPE == linux* ]]; then
  stow linux -t ~
else
  stow osx -t ~
fi
