#!/bin/bash
#
#  For WSL Linux we simply run a sudo apt install
#
#
sudo apt-get update
sudo apt-get -y upgrade
#
sudo apt-get -y install dpkg
#
sudo apt-get -y install  build-essential
sudo apt-get -y install  binutils
sudo apt-get -y install  libx11-dev
sudo apt-get -y install  libxmu-dev
sudo apt-get -y install  xterm
sudo apt-get -y install  fonts-dejavu
sudo apt-get -y install  libreadline-dev
sudo apt-get -y install  libpng-dev
sudo apt-get -y install  libopenmpi-dev
sudo apt-get -y install  openmpi-bin
sudo apt-get -y install  g++
sudo apt-get -y install  gfortran
sudo apt-get -y install  cmake
sudo apt-get -y install  cmake-curses-gui
sudo apt-get -y install  curl
sudo apt-get -y install  chrpath
sudo apt-get -y install  psmisc
sudo apt-get -y install  ghostscript
sudo apt-get -y install  qpdfview
sudo apt-get -y install  dbus-x11
#sudo apt-get -y install  gnome-terminal
#sudo apt-get -y install  konsole
sudo apt-get -y install  terminator
sudo apt-get -y install  jmol
#
