#
# Create the PGPLOT environment variable entries into 
#     .profil.local
# or /etc/profile.d/profile.local
#
#set -v
cd $DISCUS_INST_DIR
#
rm  -f $DISCUS_INST_DIR/profile.local
#
echo "PGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot"              > profile.local
echo "PGPLOT_FONT=$PGPLOT_ROOT_DIR/pgplot/grfont.dat" >> profile.local
echo "PGPLOT_DEV=/XSERVE"                             >> profile.local
echo "export PGPLOT_DIR"                              >> profile.local
echo "export PGPLOT_DEV"                              >> profile.local
echo "export PGPLOT_FONT"                             >> profile.local
if [[ "$OPERATING" == "DISCUS_LINUX"  || "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
   echo "DISCUS_NCPU=$(grep --count ^processor /proc/cpuinfo)" >> profile.local
   echo "export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5"  >> profile.local
elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
   echo "DISCUS_NCPU=$(grep --count ^processor /proc/cpuinfo)" >> profile.local
elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
   echo "DISCUS_NCPU=$(sysctl -n hw.ncpu)"                     >> profile.local
fi
echo "export DISCUS_NCPU"                             >> profile.local
#
rm -f PROFILE.txt
#
echo "source $HOME/.profile.local" > PROFILE.txt 
#
if [[ -e $HOME/.profile.local ]]; then
  source substitute.sh $HOME/.profile.local PGPLOT_DIR= PGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot
  source substitute.sh $HOME/.profile.local PGPLOT_FONT= PGPLOT_FONT=$PGPLOT_ROOT_DIR/pgplot/grfont.dat
  source substitute.sh $HOME/.profile.local "PGPLOT_DEV=" "PGPLOT_DEV=/XSERVE"
  source substitute.sh $HOME/.profile.local "export PGPLOT_DIR" "export PGPLOT_DIR"
  source substitute.sh $HOME/.profile.local "export PGPLOT_DEV" "export PGPLOT_DEV"
  source substitute.sh $HOME/.profile.local "export PGPLOT_FONT" "export PGPLOT_FONT"
  if [[ "$OPERATING" == "DISCUS_LINUX"  || "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
    source substitute.sh $HOME/.profile.local "DISCUS_NCPU=" 'DISCUS_NCPU=$(grep --count ^processor /proc/cpuinfo)'
    echo "export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5"  >> $HOME/.profile.local
  elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
     source substitute.sh $HOME/.profile.local "DISCUS_NCPU=" 'DISCUS_NCPU=$(grep --count ^processor /proc/cpuinfo)'
  elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
    source substitute.sh $HOME/.profile.local "DISCUS_NCPU=" 'DISCUS_NCPU=$(sysctl -n hw.ncpu)'
    echo "export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5"  >> $HOME/.profile.local
  fi
  source substitute.sh $HOME/.profile.local "export DISCUS_NCPU" "export DISCUS_NCPU"
#  cat $HOME/.profile.local profile.local > profile.new
#  mv profile.new $HOME/.profile.local
else
  cp profile.local $HOME/.profile.local
fi
#
if [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]] && [[ ! $OPERATING == "DISCUS_CYGWIN" ]]; then
  if [[ -e /etc/profile.d/profile.local ]]; then
    cp /etc/profile.d/profile.local profile.local
    source substitute.sh profile.local PGPLOT_DIR= PGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot
    source substitute.sh profile.local PGPLOT_FONT= PGPLOT_FONT=$PGPLOT_ROOT_DIR/pgplot/grfont.dat
    source substitute.sh profile.local "PGPLOT_DEV=" "PGPLOT_DEV=/XSERVE"
    source substitute.sh profile.local "export PGPLOT_DIR" "export PGPLOT_DIR"
    source substitute.sh profile.local "export PGPLOT_DEV" "export PGPLOT_DEV"
    source substitute.sh profile.local "export PGPLOT_FONT" "export PGPLOT_FONT"
    if [[ "$OPERATING" == "DISCUS_LINUX"  || "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
      source substitute.sh profile.local "DISCUS_NCPU=" 'DISCUS_NCPU=$(grep --count ^processor /proc/cpuinfo)'
      echo "export HDF5_DIR=${DISCUS_BIN_PREFIX}/HDF_Group/HDF5/${HDF5_Version}/share/cmake/hdf5"  >> profile.local
    elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
       source substitute.sh profile.local "DISCUS_NCPU=" 'DISCUS_NCPU=$(grep --count ^processor /proc/cpuinfo)'
    elif [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
      source substitute.sh profile.local "DISCUS_NCPU=" 'DISCUS_NCPU=$(sysctl -n hw.ncpu)'
    fi
    source substitute.sh profile.local "export DISCUS_NCPU" "export DISCUS_NCPU"
    sudo cp profile.local /etc/profile.d/
#    cat /etc/profile/profile.local profile.local > profile.new
#    mv profile.new /etc/profile/profile.local
  fi
#elif [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]] && [[ $OPERATING == "DISCUS_CYGWIN" ]]; then
#  if [[ -e /etc/profile.d/profile.local ]]; then
#    source substitute.sh /etc/profile.d/profile.local PGPLOT_DIR= PGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot
#    source substitute.sh /etc/profile.d/profile.local PGPLOT_FONT= PGPLOT_FONT=$PGPLOT_ROOT_DIR/pgplot/grfont.dat
#    source substitute.sh /etc/profile.d/profile.local "PGPLOT_DEV=" "PGPLOT_DEV=/XSERVE"
#    source substitute.sh /etc/profile.d/profile.local "export PGPLOT_DIR" "export PGPLOT_DIR"
#    source substitute.sh /etc/profile.d/profile.local "export PGPLOT_DEV" "export PGPLOT_DEV"
#    source substitute.sh /etc/profile.d/profile.local "export PGPLOT_FONT" "export PGPLOT_FONT"
##  fi
fi
#cp $DISCUS_INST_DIR/profile.local /etc/profile.d/
#
rm -rf bashrc
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
