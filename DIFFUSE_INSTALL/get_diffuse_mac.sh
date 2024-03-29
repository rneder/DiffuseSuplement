#!/bin/bash
#
if [[ ! ${DISCUS_DO_COMPILE} == "COMPILE" ]]; then
if [ ! -e ${DIFFUSE_PRE}.tar.gz ]; then
#
#  File does not exist, obtain
#
  export DISCUS_SUP_DOWN='https://'$GITHUB_SITE'/rneder/DiffuseSuplement/releases/download/'
  export DISCUS_SUPP_RAW="https://"$GITHUB_SITE"/rneder/DiffuseSuplement/releases/latest"
  export DISCUS_SUPPLEMENT=$(curl -k --silent --location $DISCUS_SUPP_RAW | grep "Release " | grep -m 1 -oe 'v\.[0-9]*\.[0-9]*\.[0-9]*')
  export DISCUS_MAC_URL=${DISCUS_SUP_DOWN}${DISCUS_SUPPLEMENT}'/'${DIFFUSE_PRE}'.tar.gz'
  if curl -k --output /dev/null --silent --head --fail "${DISCUS_MAC_URL}"; then
    echo
    echo "Downloading ${DISCUS_MAC_URL}"
    echo
    curl -k -o ${DIFFUSE_PRE}.tar.gz -SL ${DISCUS_MAC_URL}
    echo
  else
    echo ${DISCUS_MAC_URL} does not exist
  fi
fi
fi
