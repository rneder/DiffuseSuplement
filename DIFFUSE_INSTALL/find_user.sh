#!/bin/bash
#
#  Determine operating system and user 
#  If Linux, test if WSL -Linux
#
################################################################################
#
mkdir -p ${HOME}/.DISCUS
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
#   export WINDOWS_USER=$(/mnt/c/WINDOWS/system32/cmd.exe /c echo %username%)
#   export WINDOWS_USER_DIR=$(/mnt/c/WINDOWS/system32/cmd.exe /c echo %userprofile%)
  fi
  export OPERATING_NAME=$(cat /etc/os-release | grep '^NAME=' | sed 's:NAME=::' | sed 's:"::g' | sed 's: ::g')
  if [[ "${OPERATING_NAME}" == "Fedora" ]]; then
    export OPERATING_MAJOR=$(cat /etc/os-release | grep '^REDHAT_SUPPORT_PRODUCT_VERSION' | sed 's:REDHAT_SUPPORT_PRODUCT_VERSION=::')
    export OPERATING_VERSION=$(cat /etc/os-release | grep '^REDHAT_SUPPORT_PRODUCT_VERSION' | sed 's:REDHAT_SUPPORT_PRODUCT_VERSION=::')
    export OPERATING_ID_LIKE="fedora"
  else
    export OPERATING_MAJOR=$(lsb_release -r | sed "s.Release:.." | sed "s:\..*::" | sed "s:\t::" )
    export OPERATING_VERSION=$(lsb_release -r | sed "s.Release:.." | sed "s:\.::" | sed "s:\t::" )
    export OPERATING_ID_LIKE=$(cat /etc/os-release | grep 'ID_LIKE=' | sed 's:ID_LIKE=::')
  fi
  if [[ "$(groups $DISCUS_USER | grep ' sudo ')" || "$DISCUS_USER" == "root" ]]; then
    export DISCUS_SUDO="TRUE"
  else
    export DISCUS_SUDO="FALSE"
  fi
elif [[ "$OSTYPE" == "cygwin" ]]; then
  export OPERATING=DISCUS_CYGWIN
  export OPERATING_TYPE="CYGWIN"
  export DISCUS_USER=$USER
  export WINDOWS_USER=$(env | grep "PATH=" | sed -nr '0,/.*Users\/(\w+).*/ s//\1/p' )  
  export OPERATING_MAJOR="00"
  export OPERATING_VERSION="CYGWIN"
  export OPERATING_ID_LIKE=$(cat /etc/os-release | grep 'ID_LIKE=' | sed 's:ID_LIKE=::')
elif [[ "$OSTYPE" == *"darwin"* ]]; then
  export OPERATING=DISCUS_MACOS
  export OPERATING_TYPE="MAC"
  export OPERATING_NAME=$(sw_vers -productName    | sed 's,ProductName:,,'    | sed 's, ,,g')
  export OPERATING_MAJOR=$(sw_vers -productVersion | sed 's,ProductVersion:,,' | sed 's, ,,' | sed "s:\..*::")
  export OPERATING_VERSION=$(sw_vers -productVersion | sed 's,ProductVersion:,,' | sed 's, ,,' | sed "s:\.::" | sed "s:\..*::")
  export DISCUS_USER=$USER
  export WINDOWS_USER=""
  export OPERATING_ID_LIKE="darwin"
  if [[ "$(groups $DISCUS_USER | grep ' admin ')" ]]; then
    export DISCUS_SUDO="TRUE"
  else
    export DISCUS_SUDO="FALSE"
  fi
fi
export MY_SHELL=$(echo $SHELL | sed 's/\/bin\///')
export MY_SHELL_RC=$(echo ${MY_SHELL} | sed "s:${MY_SHELL}:.${MY_SHELL}rc:")
#
#  Test if major new operating system, store current major version into "${HOME}/.DISCUS/DISCUS_op_major"
export DISCUS_OPERATING_NEW="FALSE"
if [[  -e ${HOME}/.DISCUS/DISCUS.op_major ]]; then
   export OPERATING_PREVIOUS=$(cat ${HOME}/.DISCUS/DISCUS.op_major)
   if [[ $OPERATING_PREVIOUS != $OPERATING_MAJOR ]]; then
      export DISCUS_OPERATING_NEW="TRUE"
   fi
fi
#
echo 'Operating type: ' $OPERATING_TYPE
echo 'Operating is  : ' $OPERATING
echo 'Operating Name: ' $OPERATING_NAME
echo 'Operating Like: ' $OPERATING_ID_LIKE
echo 'Version   is  : ' $OPERATING_VERSION  ' New major version since last DISCUS Installation' $DISCUS_OPERATING_NEW
echo 'Shell     is  : ' $SHELL
echo 'My_Shell  is  : ' $MY_SHELL
echo 'My_ShellRC    : ' $MY_SHELL_RC
echo 'USER      is  : ' $DISCUS_USER
echo 'WINDOW USER   : ' $WINDOWS_USER
echo 'User has sudo : ' $DISCUS_SUDO
#
