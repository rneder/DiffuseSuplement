#!/bin/bash
#
if [ ! -e DIFFUSE_${OPERATING_NAME}_${OPERATING_VERSION}.tar.gz ]; then
#
#  File does not exist, obtain
#
  export DISCUS_SUPPLEMENT=$(curl --silent "https://github.com/rneder/DiffuseSuplement/releases/latest" | grep -Poe 'v.[0-9]*.[0-9]*.[0-9]*')
  export DISCUS_UBUNTU_URL='https://github.com/rneder/DiffuseSuplement/releases/download/'${DISCUS_SUPPLEMENT}'/DIFFUSE_${OPERATING_NAME}_'${OPERATING_VERSION}'.tar.gz'
  if curl --output /dev/null --silent --head --fail "${DISCUS_UBUNTU_URL}"; then
    curl -o DIFFUSE_${OPERATING_NAME}_${OPERATING_VERSION}.tar.gz -SL ${DISCUS_UBUNTU_URL}
  else
    echo ${DISCUS_UBUNTU_URL} does not exist exists
  fi
fi
