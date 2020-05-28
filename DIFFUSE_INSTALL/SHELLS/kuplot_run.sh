#
# This is /bin/kuplot_run.sh
# It is called from /bin/kuplot_primary.sh or /bin/kuplot_secondary.sh
# Starts the actual kuplot.exe  
# and performs an error halt upon exit
#
/bin/kuplot.exe 
#
if [ $? -ne 0 ]; then 
   read -p " Error hit ENTER to finish " -n 1
fi 
echo " "
echo "Program Kuplot is finished"
echo "Press any key to close the window"
read -n 1 -s 
