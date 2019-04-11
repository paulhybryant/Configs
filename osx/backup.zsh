#!/usr/bin/env zsh

# Finder
cp ~/Library/Preferences/com.apple.finder.plist .
# iTerm2
cp ~/Library/Preferences/com.googlecode.iterm2.plist .
# Scroll-reverser
cp ~/Library/Preferences/com.pilotmoon.scroll-reverser.plist .
# Hyperswitch
# Spectable
# Karabiner

brew::backup >! homebrew.zsh

# defaults read NSGlobalDomain NSUserKeyEquivalents > global.pref
# defaults read com.google.chrome NSUserKeyEquivalents > chrome.pref
# defaults read com.googlecode.iterm2 NSUserKeyEquivalents > iterm2.pref
