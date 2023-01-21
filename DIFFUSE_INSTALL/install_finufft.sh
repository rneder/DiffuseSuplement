#!/bin/bash
#
#  Install finufft library
#
#
mkdir -p develop
cd develop
rm -rf finufft
rm -rf FINUFFT.tar.gz
#
export GITHUB_SITE="github.com"
export FINUFFT_RAW_SITE="https://"$GITHUB_SITE"/flatironinstitute/finufft/releases/latest"
#
if [[ "$OPERATING" == "DISCUS_LINUX" ]] || [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
  export FINUFFT_VERSION=$(curl -k --silent --location $FINUFFT_RAW_SITE | grep "Release " | grep -m 1 -Poe '[0-9]*\.[0-9]*\.[0-9]*')
elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
  export FINUFFT_VERSION=$(curl -k --silent --location $FINUFFT_RAW_SITE | grep "Release " | grep -m 1 -oe '[0-9]*\.[0-9]*\.[0-9]*')
fi
#
#echo "FINUFFT VERSION" $FINUFFT_VERSION
#
export FINUFFT_CODE_URL='https://'$GITHUB_SITE'/flatironinstitute/finufft/archive/refs/tags/v'${FINUFFT_VERSION}'.tar.gz'
#echo "FINUFFT URL    " $FINUFFT_CODE_URL
curl -k -o FINUFFT.tar.gz -fsSL ${FINUFFT_CODE_URL}
tar -zxf FINUFFT.tar.gz
export FINUFFT_DIR='finufft-'${FINUFFT_VERSION}
mv $FINUFFT_DIR finufft
#
cd finufft
if [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
  cp ../../SUPPORT/make.inc.macosx_clang make.inc
fi
make lib
if [[ "$OPERATING" == "DISCUS_LINUX" ]] || [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
  sudo mkdir -p /usr/lib/finufft
  sudo cp lib/libfinufft.so /usr/lib/finufft/
elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
  sudo mkdir -p /usr/local/lib
  sudo cp lib/libfinufft.so /usr/local/lib/
fi
#
#  While finufft does not have a module file, use our own
cp ../../SUPPORT/finufft_mod.f90 include
cd ../..      # Back to DIFFUSE_INSTALL
#
