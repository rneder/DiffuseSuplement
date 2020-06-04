#!/bin/bash
#
# Installation for native LINUX UBUNTU 
#              or  WINDOWS_WSL  UBUNTU 
#
source ./set_pgplot_bash.sh
source ./get_diffuse_ubuntu.sh
if [[ -e ${DIFFUSE_PRE}.tar.gz && ! ${DISCUS_DO_COMPILE} == "COMPILE" ]]; then
#
#   Precompiled file exists for this Ubuntu
#
  tar -zxf ${DIFFUSE_PRE}.tar.gz
  cd ${OPERATING_TYPE}_${OPERATING_NAME}_${OPERATING_VERSION}
  source ${DISCUS_INST_DIR}/modify_chrpath.sh
  if [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]; then
    mkdir -p ${DISCUS_BIN_PREFIX}/bin
    cp -r bin/discus_suite    ${DISCUS_BIN_PREFIX}/bin/
    cp -r pgplot ${DISCUS_BIN_PREFIX}
    cp -r share  ${DISCUS_BIN_PREFIX}
  else
    sudo mkdir -p ${DISCUS_BIN_PREFIX}/bin
    sudo cp -r bin/discus_suite    ${DISCUS_BIN_PREFIX}/bin/
    sudo cp -r pgplot ${DISCUS_BIN_PREFIX}
    sudo cp -r share  ${DISCUS_BIN_PREFIX}
  fi
else
#
#   Precompiled file does not exist, do full installation, pass down argument 1
#
  source set_source.sh 
  source  ./compile_pgplot.sh
  source do_discus_complete.sh
#
fi
#