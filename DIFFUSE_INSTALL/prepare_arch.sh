#!/bin/bash
#
sudo pacman -Sy
#
function do_install {
   check="$(sudo pacman -Qs --color always "$1" | grep "local" | grep "$1" )"
   if [ -n "${check}" ]; then
     echo "$1 is installed; doing nothing"
   elif [ -z "${check}" ]; then
     echo "$1 is not installed Will do"
     sudo pacman --sync --noconfirm "$1"
   fi
}
#
do_install readline
do_install libx11
do_install libxmu
do_install gcc
do_install gcc-fortran
do_install hdf5
do_install cmake
do_install openmpi
do_install curl
do_install chrpath
do_install psmisc
do_install ghostscript
do_install qpdfview
do_install jmol
