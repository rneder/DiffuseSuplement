#!/bin/sh
#
# This shell is called from /xenv_suite.sh if it is the first instance of discus_suite.
# It calls /bin/xterm.exe.
# /bin/xrdb  allows to merge X-terminal setting with /share/.Xresources  
#
# prior to the -e a -hold could be inserted, is not needed any longer

/bin/xrdb -merge ~/.Xresources
/bin/xterm -fa "DejaVu Sans Mono" -fs 12 -rightbar -sb -pob -title "Discus_Suite primary window exit last" -e /bin/xterm.exe
