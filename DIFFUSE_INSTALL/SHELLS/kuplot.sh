#!/bin/sh
if( /bin/ps | /bin/grep XWin ); then
   export DISPLAY=':0';
   /bin/xterm -rightbar -sb -pob -title "kuplot secondary window" -e /bin/kuplot.exe;
else
   /bin/rm -f /tmp/.X*-lock
   /bin/xinit "/bin/xterm" -rightbar -sb -pob -title "kuplot primary window exit last" -e /bin/kuplot.exe -- "/usr/bin/XWin" :0 -multiwindow -logfile /dev/null;
fi

