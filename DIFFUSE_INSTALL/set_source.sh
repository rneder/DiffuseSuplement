#!/bin/bash
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
