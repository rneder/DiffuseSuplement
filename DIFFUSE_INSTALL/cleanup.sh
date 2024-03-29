#!/bin/bash
#
rm -f  DIFFUSE_INSTALL.tar.gz
rm -rf DIFFUSE_INSTALL/pgplot
rm -rf DIFFUSE_INSTALL/src
rm -rf DIFFUSE_INSTALL/develop
rm -rf DIFFUSE_INSTALL/Ubuntu_1804
rm -rf DIFFUSE_INSTALL/Ubuntu_2004
rm -rf DIFFUSE_INSTALL/HDF5
rm -rf DIFFUSE_INSTALL/HDF_Group
rm -f  DIFFUSE_INSTALL/DIFFUSE_WSL_*.tar.gz
rm -f  DIFFUSE_INSTALL/DIFFUSE_LINUX_*.tar.gz
rm -f  DIFFUSE_INSTALL/DIFFUSE_MAC_*.tar.gz
rm -f  DIFFUSE_INSTALL/DIFFUSE_CODE.tar.gz
rm -rf  DIFFUSE_INSTALL/DIFFUSE_WSL_*
rm -rf  DIFFUSE_INSTALL/DIFFUSE_LINUX_*
rm -rf  DIFFUSE_INSTALL/DIFFUSE_MAC_*
rm -f  DIFFUSE_INSTALL/HDF*.tar.gz
rm -f  DIFFUSE_INSTALL/DIFFUSE_CODE*.tar.gz
rm -rf DIFFUSE_INSTALL/CMake-hdf5-1.12.0/
rm -f  DIFFUSE_INSTALL/CMake-hdf5-1.12.0.tar.gz
rm -f  DIFFUSE_INSTALL/OpenJava.pkg
rm -f  DIFFUSE_INSTALL/JmolLatest.zip
rm -f  DIFFUSE_INSTALL/vcxsrv_installer.exe
rm -f  DIFFUSE_INSTALL/profile.local
rm -f  DIFFUSE_INSTALL/discus.profile.local
rm -f  DIFFUSE_INSTALL/user.profile.local
rm -f  DIFFUSE_INSTALL/system.profile.local
rm -rf DIFFUSE_INSTALL/DiscusWSL
#
tar -zcf DIFFUSE_INSTALL.tar.gz DIFFUSE_INSTALL
#
cp DIFFUSE_INSTALL.tar.gz DIFFUSE_INSTALL_local.tar.gz
#rm -rf DIFFUSE_INSTALL
