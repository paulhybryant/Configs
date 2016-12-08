#!/usr/bin/env bash

if [[ $OSTYPE == *darwin* ]]; then
  alias dircolors=gdircolors
  alias ls='gls --color=auto'
fi

pkg_path=$(basher package-path seebi/dircolors-solarized)
eval $(dircolors $pkg_path/dircolors.256dark)
