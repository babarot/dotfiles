#!/bin/sh

# Show Hidden Files
defaults write com.apple.finder AppleShowAllFiles -bool yes

# Display the full path in the title of the Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool yes

# Allow a select copy string in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool yes

# 2D Dock
defaults write com.apple.dock no-glass -bool yes

# Suck animation in Dock
defaults write com.apple.dock mineffect suck

# Change the destination to a local from icloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool no

# Add a pop-up notification feature in iTunes
defaults write com.apple.dock itunes-notifications -bool yes

killall Finder
killall Dock
