#
# This is /bin/discus_suite_run_ubuntu.sh
# It is called from /bin/discus_suite_primary.sh or /bin/discus_suite_secondary.sh
# Starts the actual discus_suite
# and performs an error halt upon exit
#
discus_suite_noparallel
#
if [ $? -ne 0 ]; then 
   read -p " Error hit ENTER to finish " -n 1
fi 
echo " "
echo "Program DiscusSuite is finished"
echo "Press any key to close the window"
read -n 1 -s 
