#!/bin/bash
#
#  Complete compilation of DISCUS
#
if [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then          # WINDOWS WSL 
#
#  Both nonparallel and parallel versions are needed
#
  export DIFFEV_MPI_FLAG=OFF
  if [[ "${DISCUS_TAR_SOURCE}" == "CURRENT" ]]; then
    source   ./compile_discus.sh noclean
  else
    source   ./compile_discus.sh clean
  fi
  if [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]; then
    cp /usr/local/bin/discus_suite /usr/local/bin/discus_suite_noparallel
  else
    sudo cp /usr/local/bin/discus_suite /usr/local/bin/discus_suite_noparallel
  fi
#
fi
#
#   Always do a parallel version
#
export DIFFEV_MPI_FLAG=ON
source   ./compile_discus.sh noclean
#
# Update version to the one actually compiled
#
export DISCUS_VERSION=$(cat ${DISCUS_INST_DIR}/develop/DiffuseBuild/lib_f90/version.inc)
export DIFFUSE_PRE="DIFFUSE_${OPERATING_TYPE}_${OPERATING_NAME}_${OPERATING_VERSION}_v.${DISCUS_VERSION}"
#
cd $DISCUS_INST_DIR
#
if [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then          # WINDOWS WSL
#
# We need the shellscripts to start discus_suite
#
  if [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]; then
    cp SHELLS/discus_suite_ubuntu.sh     /usr/local/bin
    cp SHELLS/discus_suite_run_ubuntu.sh /usr/local/bin
    cp SHELLS/terminal_wrapper.sh        /usr/local/bin
    cp SHELLS/discus_terminator.sh       /usr/local/bin
  else
    sudo cp SHELLS/discus_suite_ubuntu.sh     /usr/local/bin
    sudo cp SHELLS/discus_suite_run_ubuntu.sh /usr/local/bin
    sudo cp SHELLS/terminal_wrapper.sh        /usr/local/bin
    sudo cp SHELLS/discus_terminator.sh       /usr/local/bin
  fi
fi
export DISCUS_WAS_COMPILED="YES"
