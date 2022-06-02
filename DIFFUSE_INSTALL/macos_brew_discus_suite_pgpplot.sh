#!/bin/bash
#
# Start with XCode and Comand Line Tools
xcode-select --install
xcode-select --install
#
# Install homebrew
#
ruby -e "$(curl -k -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#
# Install XQuartz
brew cask install xquartz
#
brew install gcc
brew install cmake
brew install libpng
brew install ghostscript
brew install openmpi
brew install pstree
#
