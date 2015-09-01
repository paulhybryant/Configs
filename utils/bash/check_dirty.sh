#!/usr/bin/env zsh

for dir in */; do
  pushd $dir
  git dirty
  if [[ $? -ne 0 ]]; then
    echo "dirty: " $dir
  fi
  popd
done
