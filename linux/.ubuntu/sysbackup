#!/usr/bin/env zsh

setopt localoptions err_return

local _pwd="${0:A:h}"

dconf dump /org/cinnamon/desktop/keybindings/wm/ > "${_pwd}/dconf.conf"
