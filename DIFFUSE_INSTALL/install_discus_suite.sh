#!/bin/bash
#
# Installation script for DISCUS_SUITE at various operating systems
#
# Supported for:
#
# UBUNTU 18.04 and 20.04 Precompiled Versions
# UBUNTU 18.04 and 20.04 Full Compilation
# WINDOWS SUBSYSTEM LINUX: UBUNTU 18.04 and 20.04 Precompiled Versions
# WINDOWS SUBSYSTEM LINUX: UBUNTU 18.04 and 20.04 Full Compilation
# MAC OS Full Compilation
#
# For other systems a full compilation is attempted
#
# if the variable DISCUS_DO_COMPILE is set to "COMPILE", full 
#    compilation is forced
#
set -e
#set -v
# Determine operating system and User name
source ./find_user.sh
export DISCUS_INST_DIR=$(pwd)
#
#  Define a name for a global installation run
#
export DISCUS_GLOBAL=0
export DISCUS_LOCAL=1
export DISCUS_WAS_COMPILED="NO"   # Assume precompiled version
if [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
  export DISCUS_SHARED=".dylib"     # Assume MacOS style
else
  export DISCUS_SHARED=".so"        # Assume Unix style
fi
#
# For Linux and MACOS ask for installation type, 
# for WSL_Linux and Cygwin do a global installation
#
if [[ "$OPERATING" == "DISCUS_LINUX" ]] || [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
  echo
  echo " DISCUS INSTALLATION"
  echo
  echo " The suite can be installed globally into /usr/local/bin"
  echo " or locally into $HOME/bin"
  echo
#
  export DISCUS_INSTALL=-1
  while true; do
    read -p "How you want to install the suite: Globally / Locally / Cancel [G/L/C] " yn
    case $yn in
      [Gg]* ) DISCUS_INSTALL=$DISCUS_GLOBAL; export DISCUS_INSTALL ; break;;
      [Ll]* ) DISCUS_INSTALL=$DISCUS_LOCAL;  export DISCUS_INSTALL ; break;;
      [Cc]* ) DISCUS_INSTALL=-1; exit 1;;
      * ) echo "Please answer globally or locally or cancel. ";;
    esac
  done
else
  export DISCUS_INSTALL=$DISCUS_GLOBAL
fi
#
#  Prepare operating system
#
if [[ ${DISCUS_PREPARE} == "LIBRARIES" ]]; then    
  source prepare_os.sh
fi
#
# Test for fortran compiler
# 
if [[ ${DISCUS_DO_COMPILE} == "COMPILE" ]]; then    
#
  if [[ -z ${FC} ]]; then
#
#   Fortran compiler is not defined
#
    FC=$(which gfortran)
    if [[ -z ${FC} ]]; then
      FC=$(which ifort)
      if [[ -z ${FC} ]]; then
        echo
        echo "The environment variable FC is not set"
        echo "and neither gfortan nor ifort was found"
        echo 
        echo  "Please set FC to the full path to you fortran compiler before running CMake/ccmake"
        echo  "For example use: export FC=\$(which your_fortran_compiler) "
        exit 1
      fi
    fi
    export FC
  fi
fi
# 
echo
echo " DISCUS_SUITE INSTALLATION"
echo
#
# Set global variables for directories etc, will depend on DISCUS_INSTALL
#
source set_generic.sh
source prepare_hdf5.sh
#
cd $DISCUS_INST_DIR
export DIFFUSE_PRE="DIFFUSE_${OPERATING_TYPE}_${OPERATING_NAME}_${OPERATING_VERSION}_${DISCUS_VERSION}"
#
if [[ "$OPERATING" == "DISCUS_LINUX" ]]; then                # Native Linux  ######
#
  if [[ "$OPERATING_NAME" == "Ubuntu" ]]; then  # Ubuntu ; use script for installation
#
    source ./install_linux.sh
  elif [[ "$OPERATING_ID_LIKE" == "arch" ]]; then  # arch Linux (arch/ manjaro) ; use script for installation
#
    source ./install_linux.sh
# 
  elif [[ "$OPERATING" == "CentOSLinux" ]]; then
#
    source ./install_redhat.sh
#
  else                                          # Unknown Linux; try to compile
#
    source set_source.sh
    source  ./compile_pgplot.sh
    source do_discus_complete.sh
#
  fi
#
#
elif [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then          # WINDOWS WSL ######
#
  if [[ "$OPERATING_NAME" == "Ubuntu" ]]; then  # Ubuntu ; use script for installation
#
    source ./install_linux.sh
#
  else                                          # Unknown Linux; try to compile
#
    source set_source.sh
    source  ./compile_pgplot.sh
    source do_discus_complete.sh
#
  fi
#
  cd $DISCUS_INST_DIR
  source prepare_wsl_cfg.sh
  sudo cp wsl.cfg /etc/wsl.cfg
  if [[ "${OPERATING_VERSION}" == "2004" ]]; then
    sudo strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5 
  fi
#
#
elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then             # CYGWIN ######
#
    source set_source.sh
    source  ./compile_pgplot.sh
    export DIFFEV_MPI_FLAG=ON
    source  ./compile_discus.sh clean
    cp $DISCUS_BIN_PREFIX/bin/discus_suite.exe $DISCUS_BIN_PREFIX/bin/discus_suite_parallel.exe
    cp $DISCUS_BIN_PREFIX/bin/discus_suite.exe                   /bin/discus_suite_parallel.exe
    export DIFFEV_MPI_FLAG=OFF
    source  ./compile_discus.sh noclean
#   cp $DISCUS_BIN_PREFIX/bin/kuplot.exe /bin
    cp $DISCUS_BIN_PREFIX/bin/discus_suite.exe /bin
#
    cd $DISCUS_INST_DIR
    cp SHELLS/* /usr/local/bin
    cp SHELLS/*           /bin
    source  ./set_pgplot_bash.sh
#
elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then              # MAC OS ######
#
    source install_mac.sh
#   source set_source.sh
#   source  ./compile_pgplot.sh
#   export DIFFEV_MPI_FLAG=ON
#   source  ./compile_discus.sh clean
#   source ./install_jre_jmol.sh
#
fi
#
if [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]] && [[ ! "$OPERATING" == "DISCUS_CYGWIN" ]]; then
  if [[ "$(cat $HOME/.profile.local | grep 'PATH=' | grep $HOME'/bin' | grep \$PATH)" == "" ]]; then
    echo "export PATH=$DISCUS_BIN_PREFIX/bin:\$PATH" >> $HOME/.profile.local
  else
    source process_path.sh $HOME/.profile.local
  fi
fi
#
cd $DISCUS_INST_DIR
if [[ $OPERATING == "DISCUS_WSL_LINUX" ]]; then
  if [[ "$OPERATING_VERSION" == "1804" ]]; then
    cp SHELLS/discus_suite_1804.ps1    DiscusWSL/discus_suite.ps1
  elif [[ "$OPERATING_VERSION" == "2004" ]]; then
    cp SHELLS/discus_suite_2004.ps1    DiscusWSL/discus_suite.ps1
  fi
  cp SHELLS/discus_suite_ps1.bat  DiscusWSL/
  cp $DISCUS_BIN_PREFIX/share/suite_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/discus_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/diffev_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/kuplot_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/refine_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/package_man.pdf DiscusWSL/doc
  cd $DISCUS_INST_DIR
  mkdir -p $HOME/.config/terminator
  cp SHELLS/terminator.config $HOME/.config/terminator/config
  export WSL_DIR='/mnt/c/Users/DISCUS_INSTALLATION/'
#
# Test if old 'bbb_install_suite.ps1" was used without "started=powershell"
  if [[ "${DISCUS_STARTED}"  == "native" ]]; then
    VERIFY=$(echo $PATH | grep 'CanonicalGroup' | sed 's:^.*CanonicalGroup::' | sed 's:Ubuntu.*::')
    if [ -z ${VERIFY} ]; then
      DISCUS_STARTED="powershell"
    fi
  fi
  if [[ "${DISCUS_STARTED}"  == "powershell" ]]; then
    sudo rm -rf /mnt/c/Users/DISCUS_INSTALLATION/DiscusWSL
    sudo cp -r DiscusWSL $WSL_DIR
  fi
  cd SHELLS
  cp -r ./.DISCUS $HOME
# source ./install_vcxsrv.sh
fi
#
# If complete compilation, build a distribution
#
if [[ "${DISCUS_WAS_COMPILED}" == "YES" ]]; then
  cd ${DISCUS_INST_DIR}
  source build_distribution.sh
fi
#
# Do cleanup
#
cd $DISCUS_INST_DIR
rm -f PROFILE.txt
#rm -rf src/
rm -rf develop/DiffuseBuild
#rm -rf $PGPLOT_SRC_DIR/pgplot
cd $DISCUS_INST_DIR/..
echo
echo "DISCUS SUITE is installed into " ${DISCUS_BIN_PREFIX}/bin
echo
