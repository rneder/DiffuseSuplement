#!/bin/bash
#
# prepares the operating system
#
#  Currently avaliable for UBUNTU, CYGWIN, MACOS
echo $OPERATING
#
if [[ "$OPERATING" == "DISCUS_LINUX" ]]; then
#
  if [[ "$OPERATING_ID_LIKE" == "arch" ]]; then
    source prepare_arch.sh
  elif [[ "$OPERATING_ID_LIKE" == "debian" ]]; then
    source prepare_debian.sh
  elif [[ "$OPERATING_ID_LIKE" == "fedora" ]]; then
    source prepare_fedora.sh
  else
    source prepare_linux.sh
  fi
#
elif [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
#
  source prepare_wsl_linux.sh
#
elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
#
  source prepare_cygwin.sh
#
elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
#
  source  prepare_macos.sh
#
fi
