#!/bin/bash
#
#  Determine operating system and user 
#  If Linux, test if WSL -Linux
#
################################################################################
#
if [[ "$OSTYPE" == *"linux"* ]]; then
  export IS_WINDOWS=$(echo ${PATH^^} | grep "/MNT/C/WINDOWS" )
#  echo $IS_WINDOWS
  if [[ "$IS_WINDOWS" == "" ]]; then
    export OPERATING=DISCUS_LINUX
    export OPERATING_TYPE="LINUX"
    export DISCUS_USER=$USER
    export WINDOWS_USER=""
  else
    export OPERATING=DISCUS_WSL_LINUX
    export OPERATING_TYPE="WSL"
    export DISCUS_USER=$USER
    export WINDOWS_USER=$(env | grep "PATH=" | sed -nr '0,/.*Users\/(\w+).*/ s//\1/p' )
  fi
  export OPERATING_NAME=$(cat /etc/os-release | grep '^NAME=' | sed 's:NAME=::' | sed 's:"::g' | sed 's: ::g')
  if [[ "${OPERATING_NAME}" == "Fedora" ]]; then
    export OPERATING_VERSION=$(cat /etc/os-release | grep '^REDHAT_SUPPORT_PRODUCT_VERSION' | sed 's:REDHAT_SUPPORT_PRODUCT_VERSION=::')
    export OPERATING_ID_LIKE="fedora"
  else
    export OPERATING_VERSION=$(lsb_release -r | sed "s.Release:.." | sed "s:\.::" | sed "s:\t::" )
    export OPERATING_ID_LIKE=$(cat /etc/os-release | grep 'ID_LIKE=' | sed 's:ID_LIKE=::')
  fi
elif [[ "$OSTYPE" == "cygwin" ]]; then
  export OPERATING=DISCUS_CYGWIN
  export OPERATING_TYPE="CYGWIN"
  export DISCUS_USER=$USER
  export WINDOWS_USER=$(env | grep "PATH=" | sed -nr '0,/.*Users\/(\w+).*/ s//\1/p' )  
  export OPERATING_VERSION="CYGWIN"
  export OPERATING_ID_LIKE=$(cat /etc/os-release | grep 'ID_LIKE=' | sed 's:ID_LIKE=::')
elif [[ "$OSTYPE" == *"darwin"* ]]; then
  export OPERATING=DISCUS_MACOS
  export OPERATING_TYPE="MAC"
  export OPERATING_NAME=$(sw_vers -productName    | sed 's,ProductName:,,'    | sed 's, ,,g')
  export OPERATING_VERSION=$(sw_vers -productVersion | sed 's,ProductVersion:,,' | sed 's, ,,' | sed "s:\.::" | sed "s:\..*::")
  export DISCUS_USER=$USER
  export WINDOWS_USER=""
  export OPERATING_ID_LIKE="darwin"
fi
export MY_SHELL=$(echo $SHELL | sed 's/\/bin\///')
export MY_SHELL_RC=$(echo ${MY_SHELL} | sed "s:${MY_SHELL}:.${MY_SHELL}rc:")
echo 'Operating type: ' $OPERATING_TYPE
echo 'Operating is  : ' $OPERATING
echo 'Operating Name: ' $OPERATING_NAME
echo 'Operating Like: ' $OPERATING_ID_LIKE
echo 'Version   is  : ' $OPERATING_VERSION
echo 'Shell     is  : ' $SHELL
echo 'My_Shell  is  : ' $MY_SHELL
echo 'My_ShellRC    : ' $MY_SHELL_RC
echo 'USER      is  : ' $DISCUS_USER
echo 'WINDOW USER   : ' $WINDOWS_USER
#
