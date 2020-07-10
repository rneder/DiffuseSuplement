#
# Create the PGPLOT environment variable entries into 
#     .profile.local
# or /etc/profile.d/profile.local
#
#set -v
cd $DISCUS_INST_DIR
#
rm -f discus.profile.local
rm -f   user.profile.local
rm -f system.profile.local
rm -f        profile.local
#
rm -f PROFILE.txt
#
# Copy relevant lines from $HOME/.profile.local
#
if [[ -e $HOME/.profile.local ]]; then
  echo "#" > user.profile.local
  source process_profile.local.sh $HOME/.profile.local user.profile.local
else
  echo "#" > user.profile.local
fi
rm  -f $DISCUS_INST_DIR/profile.local
#
# Copy relevant lines from etc/profile.d/profile.local
#
if [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]] && [[ ! $OPERATING == "DISCUS_CYGWIN" ]]; then
  if [[ -e /etc/profile.d/profile.local ]]; then
    echo "#" > system.profile.local
    source process_profile.local.sh /etc/profile.d/profile.local system.profile.local
  else
    echo "#" > system.profile.local
  fi
else
  echo "#" > system.profile.local
fi
#
# Copy all DISCUS specific lines into a local profile.local
#
echo "export PGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot"             >> discus.profile.local
echo "export PGPLOT_FONT=$PGPLOT_ROOT_DIR/pgplot/grfont.dat" >> discus.profile.local
echo "export PGPLOT_DEV=/XSERVE"                             >> discus.profile.local
if [[ "$OPERATING" == "DISCUS_LINUX"  || "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
   echo "export DISCUS_NCPU=$(grep --count ^processor /proc/cpuinfo)" >> discus.profile.local
   echo "export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5"  >> discus.profile.local
elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
   echo "export DISCUS_NCPU=$(grep --count ^processor /proc/cpuinfo)" >> discus.profile.local
elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
   echo "export DISCUS_NCPU=$(sysctl -n hw.ncpu)"                     >> discus.profile.local
fi
#
echo "source $HOME/.profile.local" > PROFILE.txt 
#
# create combined user profile.local and copy into $HOME
#
cat user.profile.local discus.profile.local > profile.local
if [[ -e $HOME/.profile.local ]]; then
  cp profile.local $HOME/.profile.local
else
  cp profile.local $HOME/.profile.local
fi
#
# create combined system profile.local and copy into /etc/profile.d
#
#
if [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]] && [[ ! $OPERATING == "DISCUS_CYGWIN" ]]; then
  if [[ -e /etc/profile.d/profile.local ]]; then
    cat system.profile.local discus.profile.local > profile.local
    sudo cp profile.local /etc/profile.d/
  fi
fi
#
# cleanup
#
#rm -f discus.profile.local
#rm -f   user.profile.local
#rm -f system.profile.local
#rm -f        profile.local
#
rm -f bashrc
if [[ -e $HOME/${MY_SHELL_RC} ]]; then
  if fgrep  "source" $HOME/${MY_SHELL_RC} | fgrep -q "profile.local"; then
    echo
#   echo "$HOME/${MY_SHELL_RC} already contains a line source ..profile.local"
  else
    cat ~/${MY_SHELL_RC} ./PROFILE.txt > bashrc
    mv bashrc ~/${MY_SHELL_RC}
  fi
else
  cat ./PROFILE.txt > bashrc
  mv bashrc ~/${MY_SHELL_RC}
fi
# MACOS uses .bash_profile
if [[ "$OPERATING" == "DISCUS_MAC" ]]; then
  if fgrep  "source" $HOME/.bash_profile | fgrep -q "profile.local"; then
    echo "$HOME/.bash_profile already contains a line source ..profile.local"
  else
    echo "source $HOME/.profile.local" >> $HOME/.bash_profile
  fi
else
  echo "source $HOME/.profile.local" >> $HOME/.bash_profile
fi
#rm -rf ./src
source $HOME/.profile.local
#
