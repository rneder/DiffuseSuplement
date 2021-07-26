#!/bin/bash
#
# Turn off exit upo error as which relies on this 
#
set +e   
#
# Start with XCode and Comand Line Tools if not installed already
#
if [ $(xcode-select -p >/dev/null;echo $?) != 0 ]; then
  xcode-select --install
  xcode-select --install
fi
#
# Install homebrew
#
which -s brew
if [[ $? != 0 ]] ; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
#
# Install XQuartz
#
which -s xquartz
if [[ $? != 0 ]] ; then
  brew cask install xquartz
fi
#
# Install GCC
#
which -s gfortran
if [[ $? != 0 ]] ; then
  brew install gcc
fi
#
# Install CMAKE
#
which -s cmake
if [[ $? != 0 ]] ; then
  brew install cmake
fi
#
# Install libpng
if [[ ! -e /usr/local/lib/libpng.a ]] ; then
  brew install libpng
fi
#
# Install hdf5
if [[ ! -e /usr/local/Cellar/hdf5 ]] ; then
  brew install hdf5
fi
#
# Install GHOSTSCRIPT
#
which -s ps2pdf14
if [[ $? != 0 ]] ; then
  brew install ghostscript
fi
#
# Install GMT
#
which -s gmt
if [[ $? != 0 ]] ; then
  brew install gmt
fi
#
# Install OPENMPI
#
if [[ $(brew list --formula | grep open-mpi) != 'open-mpi' ]]; then
  brew install openmpi
fi
#
# Install PSTREE
#
which -s pstree
if [[ $? != 0 ]] ; then
  brew install pstree
fi
#
set -e
