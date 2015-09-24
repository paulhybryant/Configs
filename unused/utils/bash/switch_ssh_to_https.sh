#!/usr/bin/env bash

while read d
do
  pushd "$d"
  git remote show -n origin | grep "git@github"
  if [[ $? -ne 1 ]]; then
    PLUGIN=$(basename "$PWD")
    git remote set-url origin "https://github.com/paulhybryant/${PLUGIN}.git"
  fi
  popd
done < <(find "$HOME/.vim/bundle/" -maxdepth 1 -type d)
