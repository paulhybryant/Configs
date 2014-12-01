#!/bin/bash

for d in `ls -d $HOME/.vim/bundle/*/`;
do
  pushd "$d"
  git remote show -n origin | grep "git@github"
  if [[ $? -ne 1 ]]; then
    git remote set-url origin "https://github.com/paulhybryant/`basename \"$PWD\"`.git"
  fi
  popd
done
