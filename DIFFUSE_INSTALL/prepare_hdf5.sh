#!/bin/bash
#
if [[ "${OPERATING}" == "DISCUS_LINUX" ]]; then
#
  if [[ "${OPERATING_ID_LIKE}"  == "arch" ]]; then      # Arch-Liunx; Manjaro
#
    export HDF5_LIB_DIR="/usr/lib/"
    export HDF5_LIB_VER="libhdf5_fortran.so"
    export HDF5_INC_DIR="/usr/include/"
#
  elif [[ "${OPERATING_ID_LIKE}"  == "debian" ]]; then  # Debian; Ubuntu
#
    export HDF5_LIB_DIR="/usr/lib/x86_64-linux-gnu/hdf5/serial/"
    export HDF5_LIB_VER="libhdf5_fortran.so"
    export HDF5_INC_DIR="/usr/include/hdf5/serial/"
#
  elif [[ "$OPERATING_ID_LIKE" == "fedora" ]]; then     # Redhat; Fedora; CentOs (needs work in find_user.sh)
#
    export HDF5_LIB_DIR="/usr/lib64/"
    export HDF5_LIB_VER="libhdf5_fortran.so"
    export HDF5_INC_DIR="/usr/lib64/gfortran/modules/"
#
  fi
#
elif [[ "${OPERATING}" == "DISCUS_WSL_LINUX" ]]; then
#
    export HDF5_LIB_DIR="/usr/lib/x86_64-linux-gnu/hdf5/serial/"
    export HDF5_LIB_VER="libhdf5_fortran.so"
    export HDF5_INC_DIR="/usr/include/hdf5/serial/"

elif [[ "${OPERATING}"  == "DISCUS_MACOS" ]]; then
#
  export HDF5_LIB_BAS="/usr/local/Cellar/hdf5/"
  export HDF5_LIB_NUM=$(ls /usr/local/Cellar/hdf5)
  export HDF5_LIB_DIR=${HDF5_LIB_BAS}${HDF5_LIB_NUM}/lib/
  export HDF5_LIB_VER="libhdf5_fortran.dylib"
  export HDF5_INC_DIR=${HDF5_LIB_BAS}${HDF5_LIB_NUM}/include/
#
fi
#echo " BAS " ${HDF5_LIB_BAS}
#echo " PTH " ${HDF5_LIB_NUM}
#echo " DIR " ${HDF5_LIB_DIR}
#echo " VER " ${HDF5_LIB_VER}
#echo " INC " ${HDF5_INC_DIR}
export HDF5_FORTRAN_SHARED_LIBRARY=${HDF5_LIB_DIR}${HDF5_LIB_VER}
export HDF5_FORTRAN_INCLUDE_DIR=${HDF5_INC_DIR}
#
