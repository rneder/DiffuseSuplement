#!/bin/bash
#  Shell script to start the "terminator" terminal emulation program.
#  No further programs are started, besides the pgplot x-window server
#
#echo "ARGUMENT x> $1 <"
#export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
if [[ "$1" == "1" ]]; then
# FIRST is WSL 1
  export DISPLAY=:0
else
# Second is WSL 2
  export DISPLAY=$(awk '/nameserver / { print $2; exit}' /etc/resolv.conf 2>/dev/null):0
fi
#echo $DISPLAY

PGXSRV_ACT=$(ps aux | fgrep -v grep | fgrep pgxwin_server | grep -oE '[^ ]+$')
if [[ "$PGXSRV_ACT" == "pgxwin_server" ]]; then
  echo
else
   pgxwin_server &
fi
cd /mnt/c/Users
#xterm -fa "DejaVu Sans Mono" -fs 12 -rightbar -sb -pob -title "DISCUS_SUITE"  -e discus_suite_run_ubuntu.sh
#konsole --profile $HOME/.DISCUS/DISCUS.profile --hold -e discus_suite_noparallel
#gnome-terminal -- terminal_wrapper.sh discus_suite_noparallel
terminator --execute terminal_wrapper.sh 
#read ENTER
