#!/usr/bin/env zsh

fpath+=($HOME/.zsh/functions/)
autoload -Uz osx::export-spectacle-config

local _dir=${0:a:h}

/Applications/Karabiner.app/Contents/Library/bin/karabiner export > ${_dir}/karabiner-import.sh
/Applications/Seil.app/Contents/Library/bin/seil export > ${_dir}/seil-import.sh
cp ~/Library/Preferences/org.pqrs.Seil.plist ~/Library/Preferences/org.pqrs.Karabiner.plist ${_dir}/
osx::export-spectacle-config > ${_dir}/spectacle-import.sh
