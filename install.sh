#!/bin/sh

if [ ! -d "$HOME/.myconfigs" ]; then
  echo "Installing myconfigs."
  git clone --recursive git@github.com:paulhybryant/Config.git "$HOME/.myconfigs"
  "$HOME/.myconfigs/zsh/.zutils/bin/bootstrap"
else
  echo "Already installed. Nothing done."
fi
