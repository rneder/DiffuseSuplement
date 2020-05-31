#!/bin/bash
#
if [ ! -e DIFFUSE_${OPERATING_NAME}_${OPERATING_VERSION}.tar.gz ]; then
#
#  File does not exist, obtain
#
  export DISCUS_SUP_DOWN='https://github.com/rneder/DiffuseSuplement/releases/download/'
  export DISCUS_SUPPLEMENT=$(curl --silent "https://github.com/rneder/DiffuseSuplement/releases/latest" | grep -Poe 'v.[0-9]*.[0-9]*.[0-9]*')
  export DISCUS_UBUNTU_URL=${DISCUS_SUP_DOWN}${DISCUS_SUPPLEMENT}'/DIFFUSE_'${OPERATING_NAME}'_'${OPERATING_VERSION}'.tar.gz'
  if curl --output /dev/null --silent --head --fail "${DISCUS_UBUNTU_URL}"; then
    echo
    echo "Downloading ${DISCUS_UBUNTU_URL}"
    echo
    curl -o DIFFUSE_${OPERATING_NAME}_${OPERATING_VERSION}.tar.gz -SL ${DISCUS_UBUNTU_URL}
    echo
  else
    echo ${DISCUS_UBUNTU_URL} does not exist exists
  fi
fi
