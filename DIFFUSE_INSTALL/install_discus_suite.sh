#!/bin/bash
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
source prepare_os.sh
#
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
#
if [[ "$OPERATING_NAME" == "Ubuntu" ]]; then
#
  source ./set_pgplot_bash.sh
  source ./get_diffuse_ubuntu.sh
  if [ -e DIFFUSE_${OPERATING_NAME}_${OPERATING_VERSION}.tar.gz ]; then
#
#   Precompiled file exists for this Ubuntu
#
    tar -zxf DIFFUSE_${OPERATING_NAME}_${OPERATING_VERSION}.tar.gz
    cd ${OPERATING_NAME}_${OPERATING_VERSION}
    source ../modify_chrpath.sh
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
#   Precompiled file does not exist, do full installation
#
#
#  If called without parameters, install DISCUS from GITHUB
#
    if [ "$#" -ne 1 ]; then
      echo 
      echo " Installation of DISCUS_SUITE from code at github"
      echo " Download may take a moment, please be patient "
      echo
      curl -o DIFFUSE_CODE.tar.gz -fSL ${DISCUS_CODE_URL}
      export DISCUS_TAR_SOURCE=DIFFUSE_CODE.tar.gz
      echo
      echo " Download of ${DISCUS_TAR_SOURCE} Version ${DISCUS_VERSION} is complete "
      echo
    else
      export DISCUS_TAR_SOURCE=$1
      echo
      echo " Installation from local archive " ${DISCUS_TAR_SOURCE}
      echo
    fi
#
    source set_source.sh
#
    source  ./compile_pgplot.sh
#
    if [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
      export DIFFEV_MPI_FLAG=OFF
      source   ./compile_discus.sh
      sudo cp /usr/local/bin/discus_suite /usr/local/bin/discus_suite_noparallel
      export DIFFEV_MPI_FLAG=ON
      source   ./compile_discus.sh
#
      cd $DISCUS_INST_DIR
      sudo cp SHELLS/discus_suite_ubuntu.sh     /usr/local/bin
      sudo cp SHELLS/discus_suite_run_ubuntu.sh /usr/local/bin
      sudo cp SHELLS/terminal_wrapper.sh        /usr/local/bin
    else
      export DIFFEV_MPI_FLAG=ON
      echo ABOUT TO COMPILE DISCUS
      source   ./compile_discus.sh
    fi
#
  fi
  cd ..
#
elif [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
#
  source ./set_pgplot_bash.sh
  source ./get_diffuse_ubuntu.sh
  tar -zxf DIFFUSE_${OPERATING_NAME}_${OPERATING_VERSION}.tar.gz
  cd ${OPERATING_NAME}_${OPERATING_VERSION}
  source ./set_pgplot_bash.sh
  source ../modify_chrpath.sh
  if [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]; then
    cp -r pgplot ${DISCUS_BIN_PREFIX}
    cp -r bin    ${DISCUS_BIN_PREFIX}
    cp -r share  ${DISCUS_BIN_PREFIX}
  else
    sudo cp -r pgplot ${DISCUS_BIN_PREFIX}
    sudo cp -r bin    ${DISCUS_BIN_PREFIX}
    sudo cp -r share  ${DISCUS_BIN_PREFIX}
  fi
  cd ..
#
#Q#  source  ./compile_pgplot.sh
#
#Q#  export DIFFEV_MPI_FLAG=OFF
#Q#  source   ./compile_discus.sh
#Q#  sudo cp /usr/local/bin/discus_suite /usr/local/bin/discus_suite_noparallel
#Q#  export DIFFEV_MPI_FLAG=ON
#Q#  source   ./compile_discus.sh
#
#Q#  cd $DISCUS_INST_DIR
#Q#  sudo cp SHELLS/discus_suite_ubuntu.sh     /usr/local/bin
#Q#  sudo cp SHELLS/discus_suite_run_ubuntu.sh /usr/local/bin
#Q#  sudo cp SHELLS/terminal_wrapper.sh        /usr/local/bin
#
else
#
#  NOT Ubuntu or WSL, do complete installation
#
#  If called without parameters, install DISCUS from GITHUB
#
  if [ "$#" -ne 1 ]; then
    echo 
    echo " Installation of DISCUS_SUITE from code at github"
    echo " Download may take a moment, please be patient "
    echo
    curl -o DIFFUSE_CODE.tar.gz -fSL ${DISCUS_CODE_URL}
    export DISCUS_TAR_SOURCE=DIFFUSE_CODE.tar.gz
    echo
    echo " Download of ${DISCUS_TAR_SOURCE} Version ${DISCUS_VERSION} is complete "
    echo
  else
    export DISCUS_TAR_SOURCE=$1
    echo
    echo " Installation from local archive " ${DISCUS_TAR_SOURCE}
    echo
  fi
#
  source set_source.sh
#
  if [[ "$OPERATING" == "DISCUS_LINUX" ]]; then
#
    source  ./compile_pgplot.sh
#
    export DIFFEV_MPI_FLAG=ON
    source   ./compile_discus.sh
#
  elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
#
    source  ./compile_pgplot.sh
    export DIFFEV_MPI_FLAG=ON
    source  ./compile_discus.sh
    cp $DISCUS_BIN_PREFIX/bin/discus_suite.exe $DISCUS_BIN_PREFIX/bin/discus_suite_parallel.exe
    cp $DISCUS_BIN_PREFIX/bin/discus_suite.exe                   /bin/discus_suite_parallel.exe
    export DIFFEV_MPI_FLAG=OFF
    source  ./compile_discus.sh
    cp $DISCUS_BIN_PREFIX/bin/kuplot.exe /bin
    cp $DISCUS_BIN_PREFIX/bin/discus_suite.exe /bin
#
    cd $DISCUS_INST_DIR
    cp SHELLS/* /usr/local/bin
    cp SHELLS/*           /bin
    source  ./set_pgplot_bash.sh
#
  elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
#
    source  ./compile_pgplot.sh
    export DIFFEV_MPI_FLAG=ON
    source  ./compile_discus.sh
    source ./install_jre_jmol.sh
#
  fi
fi
#
if [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]] && [[ ! "$OPERATING" == "DISCUS_CYGWIN" ]]; then
  if [[ "$(cat $HOME/.profile.local | grep 'PATH=' | grep $HOME'/bin' | grep \$PATH)" == "" ]]; then
    echo "PATH=$DISCUS_BIN_PREFIX/bin:\$PATH" >> $HOME/.profile.local
  fi
fi
#
if [[ $OPERATING == "DISCUS_WSL_LINUX" ]]; then
  if [[ "$OPERATING_VERSION" == "1804" ]]; then
    cp SHELLS/discus_suite1804.bat DiscusWSL/discus_suite.bat
  elif [[ "$OPERATING_VERSION" == "2004" ]]; then
    cp SHELLS/discus_suite2004.bat DiscusWSL/discus_suite.bat
  fi
  cd $DISCUS_INST_DIR
  mkdir -p $HOME/.config/terminator
  cp SHELLS/terminator.config $HOME/.config/terminator/config
  export WSL_DIR='/mnt/c/Users/DISCUS_INSTALLATION/'
  sudo rm -rf /mnt/c/Users/DISCUS_INSTALLATION/DiscusWSL
  cp -r DiscusWSL $WSL_DIR
  cd SHELLS
  cp -r ./.DISCUS $HOME
  cd ..
# source ./install_vcxsrv.sh
fi
#
# Do cleanup
#
cd $DISCUS_INST_DIR
rm -f PROFILE.txt
#rm -rf src/
#rm -rf develop/
#rm -rf $PGPLOT_SRC_DIR/pgplot
