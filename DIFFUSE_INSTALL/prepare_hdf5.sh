#!/bin/bash
#
#  Unpack and install HDF5
#
#curl -o q.tar.gz -fL https://www.hdfgroup.org/package/cmake-hdf5-1-12-0-tar-gz
export HDF5_Version="1.12.0"
#
#  Test if old HDF5 version exists
#
if [ -e $DISCUS_BIN_PREFIX/HDF_Group ]; then
   export HDF5_OldVersion=$(ls ${DISCUS_BIN_PREFIX}/HDF_Group/HDF5)
   export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_OldVersion}/share/cmake/hdf5
   echo "HDF Version ${DISCUS_BIN_PREFIX}/HDF_Group/${HDF5_OldVersion} exists"
   while true; do
          read -p " Do you want to: Use this libray / Replace with  $HDF5_Version : [U/R] " yn
    case $yn in
      [Uu]* ) HDF_DONE=0; export HDF_DONE; break;;
      [Rr]* ) HDF_DONE=1; export HDF_DONE; break;;
      * ) echo "Please answer:  Use / Replace . ";;
    esac
  done
else
  HDF_DONE=1; export HDF_DONE
fi
#
################################################################################
#
if [[ $HDF_DONE == 1 ]]; then
  if [[ "$OPERATING" == "DISCUS_LINUX" || "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
#
# unpack precompiled HDF5 version
#
    tar -zxf HDF_${HDF5_Version}_${OPERATING_VERSION}.tar.gz
    if [[ "$DISCUS_INSTALL" == "$DISCUS_GLOBAL" ]]; then
      sudo cp -r HDF_Group ${DISCUS_BIN_PREFIX}
      cd $DISCUS_BIN_PREFIX/HDF_Group/HDF5/${HDF5_Version}/lib
      sudo rm -f libz.so*
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1      libz.so
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1.2.11
    else
      cp -r HDF_Group ${DISCUS_BIN_PREFIX}
      cd $DISCUS_BIN_PREFIX/HDF_Group/HDF5/${HDF5_Version}/lib
      rm -f libz.so*
      ln -s /lib/x86_64-linux-gnu/libz.so.1      libz.so
      ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1
      ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1.2.11
    fi
  export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5
  fi
#
else
  if [[ "$OPERATING" == "DISCUS_LINUX" || "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
    cd $DISCUS_BIN_PREFIX/HDF_Group/HDF5/${HDF5_Version}/lib
    if [[ "$DISCUS_INSTALL" == "$DISCUS_GLOBAL" ]]; then
      sudo rm -f libz.so*
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1      libz.so
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1.2.11
    else
      rm -f libz.so*
      ln -s /lib/x86_64-linux-gnu/libz.so.1      libz.so
      ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1
      ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1.2.11
    fi
#   cd $DISCUS_INST_DIR
    cd ${HOME}/DIFFUSE_INSTALL/
  fi
  export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5
fi
echo "DONE WITH HDF5 INSTALLATION "