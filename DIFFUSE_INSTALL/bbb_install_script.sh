#!/bin/bash
# 2020_12_07
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
IS_CURL="$(which curl)"
if [[ -z "${IS_CURL}" ]]; then
#  Check Linux operating system as we have to install curl...
  export OPERATING_NAME=$(cat /etc/os-release | grep '^NAME=' | sed 's:NAME=::' | sed 's:"::g' | sed 's: ::g')
  if [[ "${OPERATING_NAME}" == "Ubuntu" ]]; then
    sudo apt-get install -y curl
  elif [[ "${OPERATING_NAME}" == "Fedora" ]]; then
    sudo dnf install --assumeyes curl
  elif [[ "${OPERATING_NAME}" == "Manjaro" ]]; then
    sudo pacman --sync --noconfirm curl
  fi
fi
#
cd $HOME
#
export DISCUS_WEB=0
export DISCUS_LOCAL=1
#
export DISCUS_INST_TYPE=$DISCUS_WEB
export DISCUS_VERSION=$(curl --silent "https://github.com/tproffen/DiffuseCode/releases/latest" | grep -Poe 'v.[0-9]*.[0-9]*.[0-9]*')
export DISCUS_CODE_URL='https://github.com/tproffen/DiffuseCode/archive/'${DISCUS_VERSION}'.tar.gz'
#
export DISCUS_SUPPLEMENT=$(curl --silent "https://github.com/rneder/DiffuseSuplement/releases/latest" | grep -Poe 'v.[0-9]*.[0-9]*.[0-9]*')
export DISCUS_INSTALL_URL='https://github.com/rneder/DiffuseSuplement/releases/download/'${DISCUS_SUPPLEMENT}'/DIFFUSE_INSTALL.tar.gz'
export PGPLOT_CODE_URL='https://github.com/rneder/DiffuseSuplement/releases/download/'${DISCUS_SUPPLEMENT}'/DIFFUSE_CODE_pgplot.tar.gz'
#
if [[ "${DISCUS_INSTALLER}"  ==  "FETCH" ]]; then
  echo Starting to download the DISCUS_SUITE installation parts
  echo This may take a moment, please be patient
  curl -o DIFFUSE_INSTALL_local.tar.gz -fsSL ${DISCUS_INSTALL_URL}
  echo Initial download is complete, starting the installation
#
  tar -zxf DIFFUSE_INSTALL_local.tar.gz
  rm -rf DIFFUSE_INSTALL/develop/DiffuseBuild
elif [[ "${DISCUS_INSTALLER}"  ==  "LOCAL" ]]; then
  rm -rf DIFFUSE_INSTALL/develop/DiffuseBuild
  mkdir -p DIFFUSE_INSTALL/develop/DiffuseBuild
else
  tar -xf ${DISCUS_INSTALLER}
  rm -rf DIFFUSE_INSTALL/develop/DiffuseBuild
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

