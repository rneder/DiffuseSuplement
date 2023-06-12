#!/bin/bash
if [[ "$1" == "1" ]]; then
# FIRST is WSL 1
  export DISPLAY=:0
else
# Second is WSL 2
  if [[ "$2" == "11" ]]; then
    export DISPLAY=:0
  else
    export DISPLAY=$(awk '/nameserver / { print $2; exit}' /etc/resolv.conf 2>/dev/null):0
  fi
fi
terminator --execute discus_suite -macro $HOME/.DISCUS/discus_auto.mac 
