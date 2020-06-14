#!/bin/bash
#
#  Installs open jave run time environment and JMOL from the 
#  scripts provided in the DISCUS_SUITE package
#
########################################################################
#
export JRE_DONE=0
export JRE_INST=0
DD=$(/usr/libexec/java_home)
if [[ "${DD}" == "/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jre/Contents/Home" ]]; then
  echo "JAVA ${DD}"
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
  curl -o OpenJava.pkg -fSL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7+10/OpenJDK11U-jre_x64_mac_hotspot_11.0.7_10.pkg 
  echo
  sudo installer -pkg OpenJava.pkg -target /
  export JRE_DONE=1
fi
#
if [[ $JRE_DONE == 1 ]]; then
  if [ ! -e JmolLatest.zip ]; then
    curl -o JmolLatest.zip -fSL https://sourceforge.net/projects/jmol/files/latest/download
  fi
  unzip -oq JmolLatest.zip
  export VERSION=$(ls | grep "jmol-")
  rm -rf $HOME/Downloads/$VERSION
  cp -r $VERSION $HOME/Downloads
  rm -rf $VERSION
  source ./jmol_prepare.sh $VERSION
fi
#
