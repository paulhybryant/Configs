#!/usr/bin/env zsh

# Finder
cp ~/Library/Preferences/com.apple.finder.plist .

# iTerm2
cp ~/Library/Preferences/com.googlecode.iterm2.plist .

# Karabiner
/Applications/Karabiner.app/Contents/Library/bin/karabiner export > kbimport.sh

# Seil
/Applications/Seil.app/Contents/Library/bin/seil export > seilimport.sh

# Spectacle
# cp "$HOME/Library/Application Support/Spectacle/Shortcuts.json" .

# brew::backup > homebrew.zsh
