#!/usr/bin/env zsh

# Finder
cp ~/Library/Preferences/com.apple.finder.plist .config/
# iTerm2
cp ~/Library/Preferences/com.googlecode.iterm2.plist .config/
# Scroll-reverser
cp ~/Library/Preferences/com.pilotmoon.scroll-reverser.plist .config/
# Hyperswitch
cp ~/Library/Preferences/com.bahoom.HyperSwitch.plist .config/
# Spectacle
cp ~/Library/Preferences/com.divisiblebyzero.Spectacle.plist .config/
# Global shortcut
defaults read NSGlobalDomain NSUserKeyEquivalents >! .config/global.pref

# App shortcut
# defaults read com.google.chrome NSUserKeyEquivalents >! .config/chrome.pref
# defaults read com.googlecode.iterm2 NSUserKeyEquivalents > iterm2.pref

# brew::backup >! homebrew.zsh
