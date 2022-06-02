#!/bin/bash
#
#
#  If called without parameters, install DISCUS from GITHUB
#
if [[ "${DISCUS_TAR_SOURCE}" == "GITHUB"  ]]; then
  echo 
  echo " Installation of DISCUS_SUITE from code at github"
  echo " Download may take a moment, please be patient "
  echo
  curl -k -o DIFFUSE_CODE.tar.gz -fSL ${DISCUS_CODE_URL}
  export DISCUS_TAR_SOURCE=DIFFUSE_CODE.tar.gz
  echo
  echo " Download of ${DISCUS_TAR_SOURCE} Version ${DISCUS_VERSION} is complete "
  echo
elif [[ "${DISCUS_TAR_SOURCE}" == "CURRENT" ]]; then
  echo
  echo " Installation from current code"
  echo
else
# export DISCUS_TAR_SOURCE=$1
  echo
  echo " Installation from local archive " ${DISCUS_TAR_SOURCE}
  echo
fi
#
if [[ ! "${DISCUS_TAR_SOURCE}" == "CURRENT" ]]; then
  mkdir -p $DISCUS_DEVELOP
#
  cp $DISCUS_TAR_SOURCE $DISCUS_DEVELOP
  cd $DISCUS_DEVELOP
  export DISCUS_CODE_DIR=$(tar -ztf $DISCUS_TAR_SOURCE | head -1 | cut -d "/" -f 1)
  tar -zxf $DISCUS_TAR_SOURCE
  if ! [ $DISCUS_CODE_DIR ==  'DiffuseCode' ]; then
     rm -rf $DISCUS_DEVELOP/DiffuseCode
     mv $DISCUS_DEVELOP/$DISCUS_CODE_DIR $DISCUS_DEVELOP/DiffuseCode
  fi
#
  rm -rf   $DISCUS_DEVELOP/DiffuseBuild
  mkdir -p $DISCUS_DEVELOP/DiffuseBuild
  cd       $DISCUS_DEVELOP/DiffuseBuild
  rm -f    $DISCUS_DEVELOP/$DISCUS_CODE_DIR/lib_f90/date.inc
#
fi
#
cd $DISCUS_INST_DIR
