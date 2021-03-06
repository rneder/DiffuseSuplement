#!/bin/bash
#
# Updata cmake to at least 3.12
#
CMakeVersion=$(cmake --version | sed "s:cmake version ::" | sed "s:C.*::" | sed "s:\.::" | sed "s:\..*::")
echo ${CMakeVersion}
if [[ "${CMakeVersion}" < "312" ]]; then
  echo "NEED CMAKE UPDATE "
  sudo apt-get update
  sudo apt-get install apt-transport-https ca-certificates gnupg software-properties-common wget
  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
  sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
  sudo apt-get update
  sudo apt-get install kitware-archive-keyring
  sudo apt-key --keyring /etc/apt/trusted.gpg del C1F34CDD40CD72DA
  sudo apt-get install cmake
fi
echo "DONE WITH CMAKE UPDATE"
