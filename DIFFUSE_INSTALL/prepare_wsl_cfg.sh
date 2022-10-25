#!/bin/bash
#
# In preparation to replace lines in wsl.conf
if [ -e /etc/wsl.conf ]; then
  cp /etc/wsl.conf .
  echo " WSL.conf exists "
  LINE_AUTO=$(fgrep -n "[automount]" wsl.conf  | cut -f1 -d: )
  LINE_ENAB=$(fgrep -n "enabled" wsl.conf  | cut -f1 -d: )
  LINE_NETW=$(fgrep -n "[network]" wsl.conf  | cut -f1 -d: )
#echo "AUTO ${LINE_AUTO}"
#echo "ENAB ${LINE_ENAB}"
#echo "NETW ${LINE_NETW}"
  if [ -z $"LINE_AUTO" ]; then
    echo "[automount]" > wsl.conf
    echo "enabled = true" >> wsl.conf
  
  fi
else
  echo " WSL.conf does NOT exist"
  echo "[automount]" > wsl.conf
  echo "enabled = true" >> wsl.conf
#  sudo cp wsl.conf /etc
fi
