#!/usr/bin/env bash

pkg_path=$(brew --prefix fzf)
for f in $(command ls -d1 ${pkg_path}/shell/*.bash); do
  source $f
done
