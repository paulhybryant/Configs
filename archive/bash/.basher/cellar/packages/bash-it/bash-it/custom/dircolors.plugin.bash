#!/usr/bin/env bash
# vim: filetype=bash sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

if [[ $OSTYPE == *darwin* ]]; then
  alias dircolors=gdircolors
  alias ls='gls --color=auto'
fi

pkg_path=$(basher package-path seebi/dircolors-solarized)
eval $(dircolors $pkg_path/dircolors.256dark)
