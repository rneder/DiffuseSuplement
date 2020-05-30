#!/bin/bash
#
# Adjust library path in discus_suite to user settings
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
chrpath bin/discus_suite_noparallel --replace ${DISCUS_LIB_PATH} > /dev/null
chrpath bin/discus_suite            --replace ${DISCUS_LIB_PATH} > /dev/null
#
