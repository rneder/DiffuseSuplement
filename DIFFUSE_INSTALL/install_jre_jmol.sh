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
  export JDK_VERSION=$(curl -k --silent --location "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/latest" | grep "Release" | grep -m 1 -oe '11.[0-9].[0-9].[0-9]+[0-9]')
#  echo " JDK VERS $JDK_VERSION" 
  export JDK_BASE="$(cut -d'+' -f1 <<<"$JDK_VERSION")"
  export JDK_EXTE="$(cut -d'+' -f2 <<<"$JDK_VERSION")"
#  echo " JDK BASE $JDK_BASE"
#  echo " JDK EXTE $JDK_EXTE"
  export JDK_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/tag/jdk-'${JDK_BASE}'%2B'${JDK_EXTE}/'OpenJDK11U-jdk_x64_mac_hotspot_'${JDK_BASE}'_'${JDK_EXTE}'.pkg'
#  echo " JDK URL  $JDK_URL "
  curl -k -o OpenJDK.pkg -fsSL ${JDK_URL}
#  curl -k --location -o ./OpenJava.pkg -fSL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/latest/OpenJDK11U-jdk_x64_mac_hotspot_11.09.1_1.pkg
#  curl -k --location -o OpenJava.pkg -fSL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9.1%2B1/OpenJDK11U-jre_x64_mac_hotspot_11.0.9.1_1.pkg 
  echo
  sudo installer -package ./OpenJava.pkg -target /
  export JRE_DONE=1
fi
#
if [[ $JRE_DONE == 1 ]]; then
  if [ ! -e JmolLatest.zip ]; then
    curl -k --location -o JmolLatest.zip -fSL https://sourceforge.net/projects/jmol/files/latest/download
  fi
  unzip -oq JmolLatest.zip
  export VERSION=$(ls | grep "jmol-")
  rm -rf $HOME/Downloads/$VERSION
  cp -r $VERSION $HOME/Downloads
  rm -rf $VERSION
  source ./jmol_prepare.sh $VERSION
fi
#
