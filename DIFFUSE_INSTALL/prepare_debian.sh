#!/bin/bash
#
#  For linux we simply run a sudo apt install
#
function do_install {
    if [[ $(dpkg -l $1  | grep $1 ) == "" ]]; then
      sudo apt-get install -y $1
    else
      echo Already installed: $1
    fi
}
#
if [[ $OPERATING == "DISCUS_WSL_LINUX" ]]; then
  sudo apt-get update
  sudo apt-get -y upgrade
fi
#
if [[ $(which dpkg) == ""  ]]; then
  sudo apg-get install dpkg
fi
#
do_install ' build-essential '
do_install ' libx11-dev '
do_install ' libxmu-dev '
do_install ' xterm '
do_install ' fonts-dejavu '
do_install ' libreadline-dev '
do_install ' libpng-dev '
do_install ' libhdf5-dev '
do_install ' libopenmpi-dev '
do_install ' openmpi-bin '
do_install ' gfortran '
do_install ' g++ '
do_install ' cmake '
do_install ' cmake-curses-gui '
do_install ' curl '
do_install ' chrpath '
do_install ' psmisc '
do_install ' ghostscript '
do_install ' gmt '
do_install ' gmt-common '
do_install ' qpdfview '
do_install ' jmol '
#
