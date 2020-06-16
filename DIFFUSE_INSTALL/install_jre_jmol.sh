#!/bin/bash
#
#  Installs open jave run time environment and JMOL from the 
#  scripts provided in the DISCUS_SUITE package
#
########################################################################
#
export JRE_DONE=0
export JRE_INST=0
if [ -e "/Library/Java" ]; then
  if [ -e "/Library/Java/JavaVirtualMachines" ]; then
    LENGTH=$(ls /Library/Java/JavaVirtualMachines | wc -l | sed 's: ::g')
    if [[ ! "$LENGTH" == "0" ]]; then
      DD=$(/usr/libexec/java_home)
      export JRE_DONE=1
      if [[ "${DD}" == "/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jre/Contents/Home" ]]; then
        echo "JAVA is openjdk ${DD}"
      else
        echo "JAVA is ${DD}"
      fi
    fi
  fi
fi
#
#  Java exists 
#
if [[ "$JRE_DONE" == "1" ]]; then 
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
