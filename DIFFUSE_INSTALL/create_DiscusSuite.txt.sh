#/bin/bash
#
#  Create the file DiscusSuite.txt
#
DISCUS_VERSION_NO=$(echo ${DISCUS_VERSION} | sed 's:v.::')
echo "Installation: ${DISCUS_BIN_PREFIX}/bin/"   >  share/DiscusSuite.txt
echo "Platform    : ${OPERATING}"                >> share/DiscusSuite.txt
echo "Manual      : ${DISCUS_BIN_PREFIX}/share/" >> share/DiscusSuite.txt
echo "Helpdir     : ${DISCUS_BIN_PREFIX}/share/" >> share/DiscusSuite.txt
echo "Version     : ${DISCUS_VERSION_NO}       " >> share/DiscusSuite.txt
