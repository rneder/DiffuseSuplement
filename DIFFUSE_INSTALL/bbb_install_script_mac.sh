#!/bin/bash
# 2022_12_01
# top level DISCUS installation script.
# Downloads the installation archive, expands this and
# starts the actual installation script
#   install_discus_suite.sh
#
# Initially run through arguments to determine optional parameters
#
# Options are:
#   code=a_local_archive.tar.gz    ! where "a_local_archive" is a local file at $HOME
#   code=git                       ! Use current GIThub release
#   code=current                   ! Use current source code
#   code=pre                       ! Use a precompiled version  DEFAULT
#
#   install=fetch                  ! Get current installer from GIHUB at supplements DEFAULT
#   install=local                  ! Use current install archive
#   install=a_local_archive.tar.gz    ! where "a_local_archive" is a local file at $HOME
#
#   prepare=libraries              ! Install / update operating system libraries
#   prepare=none                   ! Do not install / update operating system libraries
#
DISCUS_TAR_SOURCE="GITHUB"
DISCUS_DO_COMPILE="PRE"
DISCUS_STARTED="native"
DISCUS_INSTALLER="FETCH"
DISCUS_PREPARE="LIBRARIES"
export GITHUB_SITE="github.com"
for var in "$@"
do
  current=$(echo $var | sed 's:=.*::')
  if [[ "${current}" == "code" ]]; then
    CODE_ARG=$(echo ${var} | sed 's:^.*=::')
    if [[ "${CODE_ARG}" == "pre" ]]; then
      DISCUS_TAR_SOURCE="GITHUB"
      DISCUS_DO_COMPILE="PRE"
    elif [[ "${CODE_ARG}" == "git" ]]; then
      DISCUS_TAR_SOURCE="GITHUB"
      DISCUS_DO_COMPILE="COMPILE"
    elif [[ "${CODE_ARG}" == "current" ]]; then
      DISCUS_TAR_SOURCE="CURRENT"
      DISCUS_DO_COMPILE="COMPILE"
    else
      DISCUS_TAR_SOURCE=$(echo ${var} | sed 's:^.*=::')
      DISCUS_DO_COMPILE="COMPILE"
    fi
  elif [[ "${current}" == "started" ]]; then
    DISCUS_STARTED=$(echo ${var} | sed 's:^.*=::')
  elif [[ "${current}" == "install" ]]; then
    inst_arg=$(echo ${var} | sed 's:^.*=::')
    if [[ "${inst_arg}" == "fetch" ]]; then
      DISCUS_INSTALLER="FETCH"
    elif [[ "${inst_arg}" == "local" ]]; then
      DISCUS_INSTALLER="LOCAL"
    else
      DISCUS_INSTALLER=$(echo ${var} | sed 's:^.*=::')
    fi
  elif [[ "${current}" == "prepare" ]]; then
    PREP_ARG=$(echo ${var} | sed 's:^.*=::')
    if [[ "${PREP_ARG}" == "libraries" ]]; then
      DISCUS_PREPARE="LIBRARIES"
    elif [[ "${PREP_ARG}" == "none" ]]; then
      DISCUS_PREPARE="NONE"
    fi
  fi
done
#
################################################################################
#  Test internet connection 
################################################################################
  ping -c 1 -q 1.1.1.1 > /dev/null

  if [ $? -ne 0 ]; then
    echo 
    echo " MacOS does not have access to the internet"
    echo " Check your network setting and make sure that"
    echo " the firewall allows internet access for MacOS"
    echo 
    exit 1
  else
    echo ""
    ping -c 1 -q $GITHUB_SITE > /dev/null
    if [ $? -ne 0 ]; then
      export GITHUB_SITE=140.82.121.4
      ping -c 1 -q $GITHUB_SITE > /dev/null
      if [ $? -ne 0 ]; then
        echo 
        echo " MacOS has access to the internet"
        echo " but cannot open the IP address 140.82.121.4 for github.com"
        echo " Check your network setting and make sure that"
        echo " the firewall allows internet access for MacOS"
        echo 
        exit 1
      else
        echo 
        echo " MacOS has access to the internet"
        echo " but cannot resolve the ip address:  github.com"
        echo " Check your network setting and make sure that"
        echo " the firewall allows internet access for MacOS"
        echo " DISCUS installation will use 140.82.121.4 for github.com"
        echo 
      fi
    fi
  fi
  echo "Internet access SUCCESS"
#
#
cd $HOME
#
export DISCUS_WEB=0
export DISCUS_LOCAL=1
#
export DISCUS_INST_TYPE=$DISCUS_WEB
export DISCUS_RAW_SITE="https://"$GITHUB_SITE"/tproffen/DiffuseCode/releases/latest"
export DISCUS_VERSION=$(curl -k --silent --location $DISCUS_RAW_SITE | grep "Release " | grep -m 1 -oe 'v\.[0-9]*\.[0-9]*\.[0-9]*')
export DISCUS_CODE_URL='https://'$GITHUB_SITE'/tproffen/DiffuseCode/archive/'${DISCUS_VERSION}'.tar.gz'
#
export DISCUS_SUPP_RAW="https://"$GITHUB_SITE"/rneder/DiffuseSuplement/releases/latest"
export DISCUS_SUPPLEMENT=$(curl -k --silent --location $DISCUS_SUPP_RAW | grep "Release " | grep -m 1 -oe 'v\.[0-9]*\.[0-9]*\.[0-9]*')
export DISCUS_INSTALL_URL='https://'$GITHUB_SITE'/rneder/DiffuseSuplement/releases/download/'${DISCUS_SUPPLEMENT}'/DIFFUSE_INSTALL.tar.gz'
export PGPLOT_CODE_URL='https://'$GITHUB_SITE'/rneder/DiffuseSuplement/releases/download/'${DISCUS_SUPPLEMENT}'/DIFFUSE_CODE_pgplot.tar.gz'
#echo "GITHUB_SITE        " $GITHUB_SITE    
#echo "DISCUS_RAW_SITE    " $DISCUS_RAW_SITE
#echo "DISCUS_VERSION     " $DISCUS_VERSION
#echo "DISCUS_CODE_URL    " $DISCUS_CODE_URL
#echo "DISCUS_SUPP_RAW    " $DISCUS_SUPP_RAW
#echo "DISCUS_SUPPLEMENT  " $DISCUS_SUPPLEMENT
#echo "DISCUS_INSTALL_URL " $DISCUS_INSTALL_URL
#echo "PGPLOT_CODE_URL    " $PGPLOT_CODE_URL
#echo
#echo "############################################################################"
#echo
#
if [[ "${DISCUS_INSTALLER}"  ==  "FETCH" ]]; then
  echo Starting to download the DISCUS_SUITE installation parts
  echo This may take a moment, please be patient
  rm -rf DIFFUSE_INSTALL
  rm -rf DIFFUSE_INSTALL.tar.gz
  rm -rf DIFFUSE_INSTALL_local.tar.gz
  curl -k -o DIFFUSE_INSTALL_local.tar.gz -fsSL ${DISCUS_INSTALL_URL}
  echo Initial download is complete, starting the installation
#
  tar -zxf DIFFUSE_INSTALL_local.tar.gz
  rm -rf DIFFUSE_INSTALL/develop/DiffuseBuild
elif [[ "${DISCUS_INSTALLER}"  ==  "LOCAL" ]]; then
  rm -rf DIFFUSE_INSTALL/develop/DiffuseBuild
  mkdir -p DIFFUSE_INSTALL/develop/DiffuseBuild
else
  tar -zxf ${DISCUS_INSTALLER}
  rm -rf DIFFUSE_INSTALL/develop/DiffuseBuild
  mkdir -p DIFFUSE_INSTALL/develop/DiffuseBuild
fi
#
if [[ "${DISCUS_DO_COMPILE}" == "COMPILE" ]]; then
  if [[ ! "${DISCUS_TAR_SOURCE}" == "CURRENT" ]]; then
    rm -rf DIFFUSE_INSTALL/develop
    cp ${DISCUS_TAR_SOURCE} DIFFUSE_INSTALL
  fi
fi
#
cd DIFFUSE_INSTALL
#
source ./install_discus_suite.sh
#

