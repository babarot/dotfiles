#!/bin/bash

trap "exit 0" INT EXIT ERR TERM KILL

read -p "Power-up your OS X by defaults commands (y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit 0
fi

# Show Hidden Files
#defaults write com.apple.finder AppleShowAllFiles -bool yes

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool yes

# Display the full path in the title of the Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool yes

# Allow you to select and copy string in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool yes

# Disable 2D Dock
defaults write com.apple.dock no-glass -bool yes

# Suck animation in Dock
defaults write com.apple.dock mineffect suck

# Change the destination to a local from icloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool no

# Add surrounded double-quotation to title of screencapture file
defaults write com.apple.screencapture name ""

# Save screencapture to
defaults write com.apple.screencapture location "~/Desktop"

# Add a pop-up notification feature in iTunes
defaults write com.apple.dock itunes-notifications -bool yes

# Clear ~/Desktop; Hidden desctop files' icon
defaults write com.apple.finder CreateDesktop -bool no

# Do not create .DS_Store wherever
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool yes

# Disable help forefront; Deal with help window as normal window
defaults write com.apple.helpviewer DevMode -bool yes

# No warning when executing download files
defaults write com.apple.LaunchServices LSQuarantine -bool no

# Display contents in folder when QuickLook
defaults write com.apple.Finder QLEnableXRayFolders -bool yes

# Add 'Quit' to Fider menu
defaults write com.apple.finder QuitMenuItem -bool YES

# Display default path when 'go-to-folder'
defaults write com.apple.finder GoToField -string "~/.bash.d"

# Hide QuickLook window when switching apps
defaults write com.apple.finder QLHidePanelOnDeactivate -bool true

killall Finder
killall Dock
killall SystemUIServer
