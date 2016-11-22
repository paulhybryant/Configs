#!/usr/bin/env bash

pkg_path=$(basher package-path seebi/dircolors-solarized)
eval $(dircolors $pkg_path/dircolors.256dark)
