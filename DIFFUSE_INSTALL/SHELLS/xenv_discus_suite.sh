#!/bin/bash
# Top level Setup script for DISCUS_SUITE package, x-environment 
#
# 

export CYGWIN="nodosfilewarning"

export DISCUS=/bin
export KUPLOT=/bin
export DIFFEV=/bin
export MIXSCAT=/bin
export SUITE=/bin
export DISCUS_SUITE=/bin

export PGPLOT_FONT=/usr/local/share/grfont.dat
export PGPLOT_DIR=/usr/local/pgplot
export PGPLOT_DEV=/XSERVE

export PATH=$PATH:/bin
echo "Windows setup done .."
echo "Starting DISCUS_SUITE .."

if( /bin/ps | /bin/grep XWin ); then
   export DISPLAY=':0';
   /bin/xenv_xterm_secondary.sh;
else
   /bin/rm -f /tmp/.X*-lock;
   /bin/xinit "/bin/xenv_xterm_primary.sh" -- "/usr/bin/XWin" :0 -multiwindow -logfile /dev/null;
fi
