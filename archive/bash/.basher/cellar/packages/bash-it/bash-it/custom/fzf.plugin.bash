#!/usr/bin/env bash
# vim: filetype=bash sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

pkg_path=$(brew --prefix fzf)
for f in $(command ls -d1 ${pkg_path}/shell/*.bash); do
  source $f
done
