#!/bin/bash
#
# top level DISCUS installation script.
# Local version no downloads of archives from GITHUB
# starts the actual installation script
#   install_discus_suite.sh
#
cd $HOME
#
export DISCUS_WEB=0
export DISCUS_LOCAL=1
#
export DISCUS_INST_TYPE=$DISCUS_WEB
export DISCUS_VERSION=$(curl --silent "https://github.com/tproffen/DiffuseCode/releases/latest" | grep -Poe 'v.[0-9]*.[0-9]*.[0-9]*')
export DISCUS_CODE_URL='https://github.com/tproffen/DiffuseCode/archive/'${DISCUS_VERSION}'.tar.gz'
export DISCUS_INSTALL_URL='https://github.com/tproffen/DiffuseCode/releases/download/'${DISCUS_VERSION}'/DIFFUSE_INSTALL.tar.gz'
export PGPLOT_CODE_URL='https://github.com/tproffen/DiffuseCode/releases/download/'${DISCUS_VERSION}'/DIFFUSE_CODE_pgplot.tar.gz'
#
#echo Starting to download the DISCUS_SUITE installation parts
#echo This may take a moment, please be patient
#curl -o DIFFUSE_INSTALL_local.tar.gz -fsSL ${DISCUS_INSTALL_URL}
#echo Initial download is complete, starting the installation
#
tar -zxf DIFFUSE_INSTALL_local.tar.gz
#mkdir -p DIFFUSE_INSTALL
cp DIFFUSE_CODE.tar.gz DIFFUSE_INSTALL/DIFFUSE_CODE.tar.gz
cp HDF_1.12.0_2004.tar.gz DIFFUSE_INSTALL
cp HDF_1.12.0_1804.tar.gz DIFFUSE_INSTALL
cp CMake-hdf5-1.12.0.tar.gz DIFFUSE_INSTALL
cp DIFFUSE_UBUNTU_*.tar.gz  DIFFUSE_INSTALL
#
cd DIFFUSE_INSTALL
#
source ./install_discus_suite.sh DIFFUSE_CODE.tar.gz
#

