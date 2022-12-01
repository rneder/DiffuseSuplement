#!/bin/bash
#
if [[ ! ${DISCUS_DO_COMPILE} == "COMPILE" ]]; then
if [ ! -e ${DIFFUSE_PRE}.tar.gz ]; then
#
#  File does not exist, obtain
#
  export DISCUS_SUP_DOWN='https://'$GITHUB_SITE'/rneder/DiffuseSuplement/releases/download/'
  export DISCUS_SUPP_RAW='https://'$GITHUB_SITE'/rneder/DiffuseSuplement/releases/latest'
  export DISCUS_SUPPLEMENT=$(curl -k --silent --location $DISCUS_SUPP_RAW | grep "Release " | grep -m 1 -Poe 'v\.[0-9]*\.[0-9]*\.[0-9]*')
  export DISCUS_UBUNTU_URL=${DISCUS_SUP_DOWN}${DISCUS_SUPPLEMENT}'/'${DIFFUSE_PRE}'.tar.gz'
  if curl -k --output /dev/null --silent --head --fail "${DISCUS_UBUNTU_URL}"; then
    echo
    echo "Downloading ${DISCUS_UBUNTU_URL}"
    echo
    curl -k -o ${DIFFUSE_PRE}.tar.gz -SL ${DISCUS_UBUNTU_URL}
    echo
  else
    echo ${DISCUS_UBUNTU_URL} does not exist
  fi
fi
fi
