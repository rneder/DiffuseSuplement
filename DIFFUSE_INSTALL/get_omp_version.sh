#!/bin/bash
# Replace the current omp library version in SUPPORT/make.inc.macosx_clang
pwd
if [[ -e /opt/homebrew/Cellar/libomp ]]; then
  OMPINC=$(find /opt/homebrew/Cellar/libomp -name include)
  echo $OMPINC
#
  rm -f SUPPORT/make.inc.macosx_clang
  VERS=$(echo $OMPINC| sed -e "s/\/opt\/homebrew\/Cellar\/libomp\///" | sed -e "s/\/include//" )
  echo VERSION $VERS
  cat SUPPORT/make.inc.macosx_clang_TEMPLATE | sed -e "s/OMPVERSION/$VERS/" >> SUPPORT/make.inc.macosx_clang
fi
