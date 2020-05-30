#!/bin/bash
#
#  Determine operating system and user 
#  If Linux, test if WSL -Linux
#
################################################################################
#
if [[ "$OSTYPE" == *"linux"* ]]; then
  export IS_WINDOWS=$(env | grep "PATH=" | grep "/mnt/c/WINDOWS" )
#  echo $IS_WINDOWS
  if [[ "$IS_WINDOWS" == "" ]]; then
    export OPERATING=DISCUS_LINUX
    export DISCUS_USER=$USER
    export WINDOWS_USER=""
  else
    export OPERATING=DISCUS_WSL_LINUX
    export DISCUS_USER=$USER
    export WINDOWS_USER=$(env | grep "PATH=" | sed -nr '0,/.*Users\/(\w+).*/ s//\1/p' )
  fi
  export OPERATING_VERSION=$(lsb_release -r | sed "s.Release:.." | sed "s:\.::" | sed "s:\t::" )
elif [[ "$OSTYPE" == "cygwin" ]]; then
  export OPERATING=DISCUS_CYGWIN
  export DISCUS_USER=$USER
  export WINDOWS_USER=$(env | grep "PATH=" | sed -nr '0,/.*Users\/(\w+).*/ s//\1/p' )  
  export OPERATING_VERSION="CYGWIN"
elif [[ "$OSTYPE" == *"darwin"* ]]; then
  export OPERATING=DISCUS_MACOS
  export DISCUS_USER=$USER
  export WINDOWS_USER=""
  export OPERATING_VERSION="DARWIN"
fi
export MY_SHELL=$(echo $SHELL | sed 's/\/bin\///')
export MY_SHELL_RC=$(echo ${MY_SHELL} | sed "s:${MY_SHELL}:.${MY_SHELL}rc:")
echo 'Operating is  : ' $OPERATING
echo 'Version   is  : ' $OPERATING_VERSION
echo 'Shell     is  : ' $SHELL
echo 'My_Shell  is  : ' $MY_SHELL
echo 'My_ShellRC    : ' $MY_SHELL_RC
echo 'USER      is  : ' $DISCUS_USER
echo 'WINDOW USER   : ' $WINDOWS_USER
#