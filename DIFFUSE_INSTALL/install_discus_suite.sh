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
#echo ${DISCUS_PREPARE}
#echo ${DISCUS_SUDO}
if [[ ${DISCUS_PREPARE} == "LIBRARIES" ]]; then    
  if [[ ${DISCUS_SUDO} == "TRUE" ]]; then
    source prepare_os.sh
  else
    echo "Please ask your admin to update the libraries at his/her convenience"
    echo "See the installation guides AAA_INSTALL_DISCUS*.pdf at github:"
    echo "https://github.com/tproffen/DiffuseCode/releases"
    echo "for further information "
    echo "The libraries can be installed with the shell script: "
#
    if [[ "$OPERATING" == "DISCUS_LINUX" ]]; then
#
      if [[ "$OPERATING_ID_LIKE" == "arch" ]]; then      # Arch-Liunx; Manjaro
        echo " prepare_arch.sh"
      elif [[ "$OPERATING_ID_LIKE" == "debian" ]]; then  # Debian; Ubuntu
        echo " prepare_debian.sh"
      elif [[ "$OPERATING_ID_LIKE" == "ubuntu" ]]; then  # Mint
        echo " prepare_debian.sh"
      elif [[ "$OPERATING_ID_LIKE" == "fedora" ]]; then  # Redhat; Fedora; CentOs (needs work in find_user.sh)
        echo " prepare_fedora.sh"
      else
        echo " prepare_linux.sh"
      fi
#
    elif [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
      echo " prepare_wsl_linux.sh"
#
#   elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
#
#     echo " prepare_cygwin.sh"
#
    elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
      echo "  prepare_macos.sh"
#
    fi
    read -p " Continue with Enter"
  fi
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
    export FC=$(which gfortran)
    export DISCUS_GFORTRAN=$(which gfortran)
    if [[ -z ${FC} ]]; then
      export FC=$(which ifort)
      export DISCUS_GFORTRAN=$(which ifort)
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
# Test for gcc and g++ compiler
#
if [[ "$OPERATING" == "DISCUS_LINUX" ]]; then                # Native Linux  ######
  export DISCUS_GCC=$(which gcc)
  export DISCUS_GXX=$(which g++)
elif [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then          # WINDOWS WSL ######
  export DISCUS_GCC=$(which gcc)
  export DISCUS_GXX=$(which g++)
elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then              # MAC OS #######
  source ./find_gcc.sh
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
    source ./install_linux.sh                   #  TEMPORARY SOLUTION NEED TO LOCATE redhat
    #source ./install_redhat.sh
#
  else                                          # Unknown Linux; try to compile
#
    source ./install_finufft.sh
    source  ./set_pgplot_bash.sh
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
    source ./install_finufft.sh
    source  ./set_pgplot_bash.sh
    source set_source.sh
    source  ./compile_pgplot.sh
    source do_discus_complete.sh
#
  fi
#
  cd $DISCUS_INST_DIR
  source prepare_wsl_cfg.sh
  sudo cp wsl.conf /etc/wsl.conf
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
#
  cd /mnt/c/Users
  export WSL_USER_PROFILE=$(cmd.exe /c echo %userprofile% | sed -nr 's///p')
  export WSL_USER_NAME=${WSL_USER_PROFILE##*\\}
  export WSL_DIR='/mnt/c/Users/'${WSL_USER_NAME}'/DISCUS_INSTALLATION/'
  cp $DISCUS_INST_DIR/SHELLS/get_win_ver.ps1 "$WSL_DIR"
  cp $DISCUS_INST_DIR/SHELLS/get_wsl_ver.ps1 "$WSL_DIR"
  cp $DISCUS_INST_DIR/SHELLS/get_ubuntu.ps1 "$WSL_DIR"
  cp $DISCUS_INST_DIR/SHELLS/xlaunch.ps1 "$WSL_DIR"
  cp $DISCUS_INST_DIR/SHELLS/discus_create_startup.ps1 "$WSL_DIR"
  cp $DISCUS_INST_DIR/SHELLS/discus_place_icon.ps1 "$WSL_DIR"
  cp $DISCUS_INST_DIR/SHELLS/discus_place_term_icon.ps1 "$WSL_DIR"
  cd "$WSL_DIR"
  powershell.exe -File get_wsl_ver.ps1
  powershell.exe -File get_win_ver.ps1
  export WIN_VER=$(cat discus_win_ver.txt | sed -nr 's///p')
  export WSL_VER=$(cat discus_wsl_ver.txt | sed -nr 's///p')
#
  cd $DISCUS_INST_DIR
#
  sudo cp SHELLS/discus_start_pgxwin.sh /usr/local/bin
  sudo chmod ugo+x /usr/local/bin/discus_start_pgxwin.sh
#
  rm -rf   DiscusWSL
  mkdir -p DiscusWSL
  mkdir -p DiscusWSL/doc
  cp ICONS/discus_suite_128.ico        DiscusWSL/
  cp ICONS/discus_terminal.ico         DiscusWSL/
#
  cp SHELLS/config.xlaunch             DiscusWSL/
  cp SHELLS/discus_suite.ps1           DiscusWSL/discus_suite.ps1
  cp SHELLS/discus_terminal.ps1        DiscusWSL/discus_terminal.ps1
  cp SHELLS/discus_startup.ps1            DiscusWSL/discus_startup.ps1
#
  source ./prepare_suite_bat.sh
  source ./prepare_terminal_bat.sh
  source ./prepare_startup_bat.sh
  chmod ugo+x DiscusWSL/discus_suite_ps1.bat
  chmod ugo+x DiscusWSL/discus_suite.ps1
  chmod ugo+x DiscusWSL/discus_terminal_ps1.bat
  chmod ugo+x DiscusWSL/discus_terminal.ps1
  chmod ugo+x DiscusWSL/discus_startup.bat
  chmod ugo+x DiscusWSL/discus_startup.ps1
#
  cp $DISCUS_BIN_PREFIX/share/suite_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/discus_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/diffev_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/kuplot_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/refine_man.pdf DiscusWSL/doc
  cp $DISCUS_BIN_PREFIX/share/package_man.pdf DiscusWSL/doc
  cd $DISCUS_INST_DIR
  mkdir -p $HOME/.config/terminator
  cp SHELLS/terminator.config $HOME/.config/terminator/config
# export WSL_DIR='/mnt/c/Users/$WINDOWS_USER/DISCUS_INSTALLATION/'
# export WSL_PATH=$(echo $WSL_USER_PROFILE | sed -nr '0,/.*Users\\(\w+).*/ s//\1/p')
# echo "WSL_PRO " $WSL_USER_PROFILE
# echo "WSL_PAT " ${WSL_PATH}    
# echo "WSL_DIR " $WSL_DIR
#
# Test if old 'bbb_install_suite.ps1" was used without "started=powershell"
  if [[ "${DISCUS_STARTED}"  == "native" ]]; then
    VERIFY=$(echo $PATH | grep 'CanonicalGroup' | sed 's:^.*CanonicalGroup::' | sed 's:Ubuntu.*::')
    if [ -z ${VERIFY} ]; then
      DISCUS_STARTED="powershell"
    fi
  fi
  if [[ "${DISCUS_STARTED}"  == "powershell" ]]; then
#   echo "REMOVING OLD DIRECTORY DiscusWSL > " "${WSL_DIR}" "<<"
    sudo rm -rf "${WSL_DIR}DiscusWSL"
#   echo "COPYING NEW  DIRECTORY DiscusWSL > " "${WSL_DIR}" "<<"
    sudo cp -r DiscusWSL "${WSL_DIR}"
  fi
  cd SHELLS
  cp -r ./.DISCUS $HOME
  cp discus_auto.mac $HOME/.DISCUS
#
#    Place Icons and startup batch file
  cd "$WSL_DIR"
  powershell.exe -File discus_place_icon.ps1
  powershell.exe -File discus_place_term_icon.ps1
  powershell.exe -File discus_create_startup.ps1
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
#
cd $DISCUS_INST_DIR
source set_conda_on.sh
rm -f PROFILE.txt
#rm -rf src/
rm -rf develop/DiffuseBuild
#rm -rf $PGPLOT_SRC_DIR/pgplot
cd $DISCUS_INST_DIR/..
#
echo
echo "DISCUS SUITE is installed into " ${DISCUS_BIN_PREFIX}/bin
echo
