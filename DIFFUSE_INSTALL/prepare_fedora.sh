#!/bin/bash
#
#
function do_install {
   check="$(sudo rpm -qa "$1" )"
   if [ -n "${check}" ]; then
     echo "$1 is installed; doing nothing"
   elif [ -z "${check}" ]; then
     echo "$1 is not installed Will do"
     sudo dnf install --assumeyes "$1"
   fi
}
#
do_install readline
do_install readline-devel
do_install libX11
do_install libX11-devel
do_install libXmu
do_install make
do_install gcc
do_install gcc-g++
do_install gcc-gfortran
do_install libpng
do_install libpng-devel
do_install hdf5
do_install cmake
do_install openmpi
do_install curl
do_install chrpath
do_install psmisc
do_install ghostscript
do_install gmt
do_install gmt-common
do_install qpdfview
do_install jmol
