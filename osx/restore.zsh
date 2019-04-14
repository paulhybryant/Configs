#!/usr/bin/env zsh

# Finder
cp .config/com.apple.finder.plist ~/Library/Preferences/
# iTerm2
cp .config/com.googlecode.iterm2.plist ~/Library/Preferences/
# Scroll-reverser
cp .config/com.pilotmoon.scroll-reverser.plist ~/Library/Preferences/
# Hyperswitch
cp .config/com.bahoom.HyperSwitch.plist ~/Library/Preferences/
# Spectacle
cp .config/com.divisiblebyzero.Spectacle.plist ~/Library/Preferences/
# Global shortcut
# defaults write NSGlobalDomain NSUserKeyEquivalents .config/global.pref

# App shortcut
# defaults read com.google.chrome NSUserKeyEquivalents >! .config/chrome.pref
# defaults read com.googlecode.iterm2 NSUserKeyEquivalents > iterm2.pref

# ./homebrew.zsh
