#!/bin/sh
#
# This shell is called from /suite.sh if it is the first instance of kuplot.
# It calls /bin/kuplot_run.sh,  which contains an error check upon exit.
# /bin/xrdb  allows to merge X-terminal setting with /share/.Xresources  

/bin/xrdb -merge /share/.Xresources
/bin/xterm -fa "DejaVu Sans Mono" -fs 12 -rightbar -sb -pob -title "Discus_Suite primary window exit last" -e /bin/kuplot_run.sh
