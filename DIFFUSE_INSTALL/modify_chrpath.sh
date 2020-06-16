#!/bin/bash
#
# Adjust library path in discus_suite to user settings
#
if [[ "${OPERATING}" == "DISCUS_LINUX" || "${OPERATING}" == "DISCUS_WSL" ]]; then
  export DISCUS_LIB_PATH_SYS="/usr/lib/x86_64-linux-gnu/libSM.so:/usr/lib/x86_64-linux-gnu/libICE.so:/usr/lib/x86_64-linux-gnu/libX11.so:/usr/lib/x86_64-linux-gnu/libXext.so:/usr/lib/x86_64-linux-gnu/openmpi/lib:"
  export PGPLOT_LIB_PATH="$PGPLOT_DIR/libpgplot.a:"
  export HDF5_LIB_PATH=$(echo $HDF5_DIR | sed 's./share/cmake/hdf5./lib:.')
#echo $DISCUS_LIB_PATH_SYS
#echo $PGPLOT_LIB_PATH
#echo $HDF5_LIB_PATH
  export DISCUS_LIB_PATH=${DISCUS_LIB_PATH_SYS}${PGPLOT_LIB_PATH}${HDF5_LIB_PATH}
#echo
#echo $DISCUS_LIB_PATH
#echo
  if [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
    chrpath bin/discus_suite_noparallel --replace ${DISCUS_LIB_PATH} > /dev/null
  fi
  chrpath bin/discus_suite            --replace ${DISCUS_LIB_PATH} > /dev/null
#
elif [[ "${OPERATING}" == "DISCUS_MACOS" ]]; then
#
  install_name_tool -change @rpath/libhdf5_cpp.200.dylib ${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/1.12.0/lib/libhdf5_cpp.200.dylib bin/discus_suite
  install_name_tool -change @rpath/libhdf5_fortran.200.dylib ${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/1.12.0/lib/libhdf5_fortran.200.dylib bin/discus_suite
  install_name_tool -change @rpath/libhdf5_f90cstub.200.dylib ${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/1.12.0/lib/libhdf5_f90cstub.200.dylib bin/discus_suite
  install_name_tool -change @rpath/libhdf5.200.dylib ${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/1.12.0/lib/libhdf5.200.dylib bin/discus_suite
#
fi
#
