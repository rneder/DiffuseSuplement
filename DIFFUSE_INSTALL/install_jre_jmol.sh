#!/bin/bash
#
#  Installs open jave run time environment and JMOL from the 
#  scripts provided in the DISCUS_SUITE package
#
########################################################################
#
export JRE_DONE=0
export JRE_INST=0
if [ -e /usr/bin/java ]; then
#
#  Java exists 
#
  echo " JAVA is installed "
  export JRE_DONE=1
else
  echo " JMOL requires a JAVA Run Time Environment"
  while true; do
    read -p " Install OpenJava yes/no ?" yn
  case $yn in
    [Yy]* ) JMOL_INST=1; export JMOL_INST; break;;
    [Nn]* ) JMOL_INST=0; export JMOL_INST; break;;
  esac
  done
fi

if [[ $JMOL_INST == 1 ]]; then
set -v
  curl -o OpenJava.pkg -fSL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.5+10/OpenJDK11U-jre_x64_mac_hotspot_11.0.5_10.pkg 
  echo
  sudo installer -pkg OpenJava.pkg -target /
  export JRE_DONE=1
fi
#
if [[ $JRE_DONE == 1 ]]; then
 curl -o JmolLatest.zip -fSL https://sourceforge.net/projects/jmol/files/latest/download
  unzip -oq JmolLatest.zip
  export VERSION=$(ls | grep "jmol-")
  echo $VERSION
  rm -rf $HOME/Downloads/$VERSION
  cp -r $VERSION $HOME/Downloads
  rm -rf $VERSION
  source ./jmol_prepare.sh $VERSION
fi
#
