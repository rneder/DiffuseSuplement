#!/bin/bash
#
# compile PGPLOT through cmake
# R.B. Neder 2023_11_02
#
################################################################################
#
set -v
#
echo "***************************************************************"
echo " PGPLOT_COMPILE_CMAKE"
echo "***************************************************************"
cd $DISCUS_INST_DIR
#
if [[ "$OPERATING" == "DISCUS_MACOS" ]]; then              # MAC OS ######
  export PGPLOT_DONE=1
else
  if [ -e $PGPLOT_ROOT_DIR/pgplot/libpgplot.so ]; then
#
    echo " PGPLOT LIBRARY: $PGPLOT_ROOT_DIR/pgplot/libpgplot.so exists"
    while true; do
            read -p " Do you want to: Use this libray / Compile freshly : [U/C] " yn
    case $yn in
      [Uu]* ) PGPLOT_DONE=0; export PGPLOT_DONE; break;;
      [Cc]* ) PGPLOT_DONE=1; export PGPLOT_DONE; break;;
      * ) echo "Please answer:  Use / Compile . ";;
    esac
    done
  else
    export PGPLOT_DONE=1
  fi
fi
#
if [[ $PGPLOT_DONE == 1 ]]; then
#
  source set_conda_off.sh
#
  PID_PGXWIN=$(pgrep pgxwin_server)
  if [ ! -z $PID_PGXWIN ]; then
     kill -9 $PID_PGXWIN
  fi
#
  mkdir -p $DISCUS_INST_DIR/src
  cd $DISCUS_INST_DIR/src
#
  rm -rf pgplot_libs
  mkdir -p pgplot_libs
#
  echo
  echo " Installation of PGPLOT from code at github"
  echo " Download may take a moment, please be patient "
  echo
  curl -k -o  DIFFUSE_CODE_PGPLOT_CMAKE.tar.gz -fSL ${PGPLOT_CODE_URL}
  echo
  echo " Download of ${PGPLOT_CODE_URL} finished "
  echo
  tar -zxf DIFFUSE_CODE_PGPLOT_CMAKE.tar.gz
#
  cd PGPLOT_CODE
#
  awk -f ./grexec.awk drivers.list > grexec.f
  cd ..
#
  rm -rf PGPLOT_BUILD
  mkdir PGPLOT_BUILD
  cd PGPLOT_BUILD
  pwd
#
  cmake -DCMAKE_INSTALL_PREFIX=. ../PGPLOT_CODE
#
  make clean
  make  -j 
#
    cd ..
#
  cp PGPLOT_CODE/grfont.dat      pgplot_libs
  cp PGPLOT_CODE/rgb.txt         pgplot_libs
  cp PGPLOT_BUILD/libpgplot.*    pgplot_libs
  cp PGPLOT_BUILD/pgxwin_server  pgplot_libs
#
  cd $DISCUS_INST_DIR
#
  if [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]] ; then
    if [[ "$OPERATING" == "DISCUS_LINUX" || "$OPERATING" == "DISCUS_WSL_LINUX" || "$OPERATING" == "DISCUS_MACOS" ]]; then
      echo sudo cp  src/pgplot_libs/*  $PGPLOT_ROOT_DIR/pgplot
      sudo      cp  src/pgplot_libs/*  $PGPLOT_ROOT_DIR/pgplot
    elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
      echo cp  src/pgplot_libs/*  $PGPLOT_ROOT_DIR/pgplot
           cp  src/pgplot_libs/*  $PGPLOT_ROOT_DIR/pgplot
    fi
  else
    echo cp  src/pgplot_libs/*  $PGPLOT_ROOT_DIR/pgplot
         cp  src/pgplot_libs/*  $PGPLOT_ROOT_DIR/pgplot
  fi
fi
#
cd $DISCUS_INST_DIR
#
echo "***************************************************************"
echo " PGPLOT_COMPILE_CMAKE is finished"
echo "***************************************************************"
