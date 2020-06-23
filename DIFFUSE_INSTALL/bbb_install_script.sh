#!/bin/bash
#
# top level DISCUS installation script.
# Downloads the installation archive, expands this and
# starts the actual installation script
#   install_discus_suite.sh
#
# Initially run through arguments to determine optional parameters
DISCUS_TAR_SOURCE="GITHUB"
DISCUS_DO_COMPILE="PRE"
DISCUS_STARTED="native"
for var in "$@"
do
  current=$(echo $var | sed 's:=.*::')
  if [[ "${current}" == "code" ]]; then
    DISCUS_TAR_SOURCE=$(echo ${var} | sed 's:^.*=::')
    DISCUS_DO_COMPILE="COMPILE"
  elif [[ "${current}" == "started" ]]; then
    DISCUS_STARTED=$(echo ${var} | sed 's:^.*=::')
  fi
done
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
echo Starting to download the DISCUS_SUITE installation parts
echo This may take a moment, please be patient
curl -o DIFFUSE_INSTALL_local.tar.gz -fsSL ${DISCUS_INSTALL_URL}
echo Initial download is complete, starting the installation
#
tar -zxf DIFFUSE_INSTALL_local.tar.gz
#
if [[ "${DISCUS_DO_COMPILE}" == "COMPILE" ]]; then
  cp ${DISCUS_TAR_SOURCE} DIFFUSE_INSTALL
fi
#
cd DIFFUSE_INSTALL
#
source ./install_discus_suite.sh
#

