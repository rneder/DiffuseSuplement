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

  echo "DOING HDF INSTALLATION, please be extra patient this is a large package "   
  source prepare_cmake.sh
  curl -o "CMake-hdf5-"${HDF5_Version}.tar.gz -fL "https://www.hdfgroup.org/package/cmake-hdf5-1-12-0-tar-gz/?wpdmdl=14580&refresh=5ecb7f43e73841590394691"
  export HDF5_gz="CMake-hdf5-"${HDF5_Version}".tar.gz"
  export HDF5_top="CMake-hdf5-"${HDF5_Version}
  cd $DISCUS_INST_DIR
#  cd ${HOME}/DIFFUSE_INSTALL/
  mkdir -p HDF5
  cp ${HDF5_gz} HDF5
  cd HDF5
  tar -zxf ${HDF5_gz}
  cp ../HDF5options.cmake ${HDF5_top}       

  if [[ "$OPERATING" == "DISCUS_LINUX" || "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
#   ctest -S ${HDF5_top}/HDF5config.cmake,                                       ,BUILD_GENERATOR=Unix -C Release -V -O hdf5.log
#   ctest -S ${HDF5_top}/HDF5config.cmake,INSTALLDIR=${HOME}/DIFFUSE_INSTALL/HDF5,BUILD_GENERATOR=Unix -C Release -V -O hdf5.log
    cd ${HDF5_top}
    source ./build-unix.sh

    rm -f ./build/_CPack_Packages/Linux/TGZ/HDF5-${HDF5_Version}-Linux/HDF_Group/HDF5/${HDF5_Version}/lib/libz.so*
    if [[ "$DISCUS_INSTALL" == "$DISCUS_GLOBAL" ]]; then
      sudo cp -r ./build/_CPack_Packages/Linux/TGZ/HDF5-${HDF5_Version}-Linux/HDF_Group $DISCUS_BIN_PREFIX/HDF_Group
      cd $DISCUS_BIN_PREFIX/HDF_Group/HDF5/${HDF5_Version}/lib
      sudo rm -f libz.so*
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1      libz.so
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1
      sudo ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1.2.11
    else
      cp -r ./build/_CPack_Packages/Linux/TGZ/HDF5-${HDF5_Version}-Linux/HDF_Group $DISCUS_BIN_PREFIX/
      cd $DISCUS_BIN_PREFIX/HDF_Group/HDF5/${HDF5_Version}/lib
      rm -f libz.so*
      ln -s /lib/x86_64-linux-gnu/libz.so.1      libz.so
      ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1
      ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 libz.so.1.2.11
    fi
#   cd $DISCUS_INST_DIR
    cd $DISCUS_INST_DIR
  elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
    cd ${HDF5_top}
    source ./build-unix.sh
    if [[ "$DISCUS_INSTALL" == "$DISCUS_GLOBAL" ]]; then
      sudo cp -r ./build/_CPack_Packages/Darwin/TGZ/HDF5-${HDF5_Version}-Darwin/HDF_Group $DISCUS_BIN_PREFIX/HDF_Group
    else
      cp -r ./build/_CPack_Packages/Darwin/TGZ/HDF5-${HDF5_Version}-Darwin/HDF_Group $DISCUS_BIN_PREFIX/
    fi
    cd $DISCUS_INST_DIR
  fi
  export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5
#else
#  export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}
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
    cd $DISCUS_INST_DIR
  fi
  export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5
fi
echo "DONE WITH HDF5 INSTALLATION "
