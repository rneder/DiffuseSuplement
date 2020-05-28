#!/bin/bash
#
export DISPLAY=:0
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
terminator --execute terminal_wrapper.sh discus_suite_noparallel
