#!/bin/bash
#
set +e 
DISCUS_GCC=$(find /usr/local -name 'gcc-??' | fgrep Cellar | fgrep bin)
# echo $DISCUS_GCC
if [[ -z ${DISCUS_GCC} ]]; then
  DISCUS_GCC=$(find /opt -name 'gcc-??' | fgrep Cellar | fgrep bin)
fi
DISCUS_GXX=${DISCUS_GCC/gcc-/g++-}
# echo $DISCUS_GCC
# echo $DISCUS_GXX
set -e 
