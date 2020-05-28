#!/bin/bash
#
# prepares the operating system
#
#  Currently avaliable for UBUNTU, CYGWIN, MACOS
echo $OPERATING
#
if [[ "$OPERATING" == "DISCUS_LINUX" ]]; then
#
  source prepare_linux.sh
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
