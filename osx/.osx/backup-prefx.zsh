#!/usr/bin/env zsh

local _dir=${0:a:h}

osx::export-karabiner-config ${_dir}/karabiner-import.sh
osx::export-seil-config ${_dir}/seil-import.sh
osx::export-spectacle-config > ${_dir}/spectacle-import.sh
cp ~/Library/Preferences/org.pqrs.Seil.plist ~/Library/Preferences/org.pqrs.Karabiner.plist ${_dir}/
