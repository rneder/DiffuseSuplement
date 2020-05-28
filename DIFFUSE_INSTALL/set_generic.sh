#
# Define the global DISCUS variables, 
# prepare and unpack the source tar file
#
# DISCUS_BIN_PREFIX   ! Final directory will be DISCUS_BIN_PREFIX/bin
# DISCUS_INST_DIR     ! Installation directory == current directory
# DISCUS_CODE_DIR     ! Directory listed in the tar file 
# DISCUS_DEVELOP      ! Source code will be in DISCUS_INST/DIR/DISCUS_DEVELOP
#
# PGPLOT_ROOT_DIR     ! Final directory for pgplot libray will be PGPLOT_ROOT_DIR/pgplot
# PGPLOT_INST_DIR     ! Installation directory == DISCUS_INST_DIR/pgplot
# PGPLOT_SRC_DIR      ! Source code pgplot     == DISCUS_INST_DIR/src/pgplot
# 
set -e
#
if [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]] || [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
#
  export DISCUS_BIN_PREFIX=/usr/local
#
  export PGPLOT_ROOT_DIR=/usr/local
#
elif [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]; then
#
  export DISCUS_BIN_PREFIX=$HOME
#
  export PGPLOT_ROOT_DIR=$HOME
#
fi
#
export PGPLOT_INST_DIR=pgplot
export PGPLOT_SRC_DIR=src/pgplot
#
export DISCUS_INST_DIR=$(pwd)
export DISCUS_DEVELOP=${DISCUS_INST_DIR}/develop
#
#DISCUS_TAR_SOURCE=$1
#export DISCUS_TAR_SOURCE
#
#
mkdir -p $DISCUS_DEVELOP
#
#if [ "$#" -eq 1 ]; then
  cp $DISCUS_TAR_SOURCE $DISCUS_DEVELOP
  cd $DISCUS_DEVELOP
  export DISCUS_CODE_DIR=$(tar -ztf $DISCUS_TAR_SOURCE | head -1 | cut -d "/" -f 1)
  tar -zxf $DISCUS_TAR_SOURCE
  if ! [ $DISCUS_CODE_DIR ==  'DiffuseCode' ]; then
     rm -rf $DISCUS_DEVELOP/DiffuseCode
     mv $DISCUS_DEVELOP/$DISCUS_CODE_DIR $DISCUS_DEVELOP/DiffuseCode
  fi
#fi
#
rm -rf   $DISCUS_DEVELOP/DiffuseBuild
mkdir -p $DISCUS_DEVELOP/DiffuseBuild
cd       $DISCUS_DEVELOP/DiffuseBuild
rm -f    $DISCUS_DEVELOP/$DISCUS_CODE_DIR/lib_f90/date.inc
#
#
cd $DISCUS_INST_DIR
#
#echo DIRECTORIES
#echo 'DISCUS_BIN_PREFIX ' $DISCUS_BIN_PREFIX   ! Final directory will be DISCUS_BIN_PREFIX/bin
#echo 'DISCUS_INST_DIR   ' $DISCUS_INST_DIR     ! Installation directory == current directory
#echo 'DISCUS_CODE_DIR   ' $DISCUS_CODE_DIR     ! Directory listed in the tar file 
#echo 'DISCUS_DEVELOP    ' $DISCUS_DEVELOP      ! Source code will be in DISCUS_INST/DIR/DISCUS_DEVELOP
#
#echo 'PGPLOT_ROOR_DIR   ' $PGPLOT_ROOT_DIR     ! Final directory for pgplot libray will be PGPLOT_ROOT_DIR/pgplot
#echo 'PGPLOT_INST_DIR   ' $PGPLOT_INST_DIR     ! Installation directory == DISCUS_INST_DIR/pgplot
#echo 'PGPLOT_SRC_DIR    ' $PGPLOT_SRC_DIR      ! Source code pgplot     == DISCUS_INST_DIR/src/pgplot
#exit
