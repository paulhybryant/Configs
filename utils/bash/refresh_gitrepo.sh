#!/usr/bin/env bash

for d in $(find "$HOME/.gitrepo" -type d -name "\.git" -print0 | xargs -0 dirname)
do
  pushd "$d";
  git pull;
  popd;
done
