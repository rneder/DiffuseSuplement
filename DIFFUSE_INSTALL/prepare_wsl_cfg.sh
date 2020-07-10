#!/bin/bash
#
# In preparation to replace lines in wsl.cfg
if [ -e wsl.cfg ]; then
  echo " WSL.cfg exists "
  LINE_AUTO=$(fgrep -n "[automount]" wsl.cfg  | cut -f1 -d: )
  LINE_ENAB=$(fgrep -n "enabled" wsl.cfg  | cut -f1 -d: )
  LINE_NETW=$(fgrep -n "[network]" wsl.cfg  | cut -f1 -d: )
#echo "AUTO ${LINE_AUTO}"
#echo "ENAB ${LINE_ENAB}"
#echo "NETW ${LINE_NETW}"
  if [ -z $"LINE_AUTO" ]; then
    echo "[automount]" > wsl.cfg
    echo "enabled = true" >> wsl.cfg
  
  fi
else
  echo " WSL.cfg does NOT exist"
  echo "[automount]" > wsl.cfg
  echo "enabled = true" >> wsl.cfg
#  sudo cp wsl.cfg /etc
fi
