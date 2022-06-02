#!/bin/bash
#
#  Install vcxsrv server
#
#set -v
#export DISCUS_VCX_VERSION=$(curl -k --silent "https://sourceforge.net/projects/vcxsrv/files/download" | grep -Poe '64.[0-9]*.[0-9]*.[0-9]*.[0-9]*')
#export DISCUS_VCX_URL='https://sourceforge.net/projects/vcxsrv/files/latest/download/vcxsrv-'${DISCUS_VCX_VERSION}'.installer.exe'
#echo 'VCX Version ' $DISCUS_VCX_VERSION
#echo 'VCX URL     ' $DISCUS_VCX_URL
if [[ ! -e "/mnt/c/Program Files/VcXsrv/xlaunch.exe" ]]; then
  curl -k -o vcxsrv_installer.exe -fSL 'https://sourceforge.net/projects/vcxsrv/files/latest/download/vcxsrv-*.installer.exe'
  chmod 700 vcxsrv_installer.exe
  export VCR_DIR='/mnt/c/Users/DISCUS_INSTALLATION/Downloads/'
  cp vcxsrv_installer.exe  $VCR_DIR
#./vcxsrv.installer.exe
fi
