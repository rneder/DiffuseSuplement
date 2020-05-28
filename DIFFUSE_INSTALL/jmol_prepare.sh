#!/bin/bash
#
# Prepares a jmol installation for use with discus_suite
# MAC OS version
# Creates a directory  $HOME/JMOL
# Copies $HOME/Downloads/jmol-14.29.29 to $HOME/JMOL
# Copies $HOME/JMOL/jmol to /usr/local/bin
# Makes an environment variable JMOL_HOME to ensure that
# /usr/local/bin/jmol find the correct Jmol.jar.
# On a MAC the user does not have privileges to copy
# Jmol.jar into /usr/share/java
# 
#set -e
#
JMOL_SOURCE=$1
 
mkdir -p $HOME/JMOL
if [ "$#" -eq 1 ]; then
  cp -r  $HOME/Downloads/$JMOL_SOURCE $HOME/JMOL
  chmod ugo+x $HOME/JMOL/$VERSION/jmol.sh
  ln -sf $HOME/JMOL/$JMOL_SOURCE/jmol.sh $HOME/bin/jmol
  chmod ugo+x $HOME/bin/jmol

#  sudo cp $HOME/JMOL/$JMOL_SOURCE/jmol /usr/local/bin

  rm -f profile_jmol.sh
  echo 'JMOL_HOME=$HOME/JMOL/'$JMOL_SOURCE >> profile_jmol.sh
  echo 'export JMOL_HOME' >> profile_jmol.sh 
  echo 'alias jmol=$JMOL_HOME/jmol.sh' >> profile_jmol.sh

  if [ -e $HOME/${MY_SHELL_RC}]; then
     PROFILE_FILE=$HOME/${MY_SHELL_RC}
  elif [ -e $HOME/.bash_profile ]; then
     PROFILE_FILE=$HOME/.bash_profile
  elif [ -e $HOME/.bash_login ]; then
     PROFILE_FILE=$HOME/.bash_login
  elif [ -e $HOME/.profile ]; then
     PROFILE_FILE=$HOME/.profile
  else
     PROFILE_FILE=$HOME/${MY_SHELL_RC}
     cat template_source >> $HOME/.profile
  fi

  HAS_SOURCE=$(fgrep 'source' $PROFILE_FILE | fgrep 'profile.local')
  if [ -z "$HAS_SOURCE" ]; then
     cat template_source >> $PROFILE_FILE
  fi

  if [ -e $HOME/.profile.local ]; then
     cat profile_jmol.sh >> $HOME/.profile.local
  else
     cp profile_jmol.sh $HOME/.profile.local
  fi
fi

