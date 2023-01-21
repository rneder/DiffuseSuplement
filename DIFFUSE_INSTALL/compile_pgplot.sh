#  !/bin/bash
#
# Prepare directories, check for old PGPLOT installations
#
# 2022_12 Forced compilation on MAC, as gcc is changing, and png library location is changing
#
#set -v
#
if [[ "$OPERATING" == "DISCUS_MACOS" ]]; then              # MAC OS ######
  export PGPLOT_DONE=1
else
if [ -e $PGPLOT_ROOT_DIR/pgplot/libpgplot.a ]; then
#
  echo " PGPLOT LIBRARY: $PGPLOT_ROOT_DIR/pgplot/libpgplot.a exists"
  while true; do
	  read -p " Do you want to: Use this libray / Compile freshly : [U/C] " yn
  case $yn in
    [Uu]* ) PGPLOT_DONE=0; export PGPLOT_DONE; break;;
    [Cc]* ) PGPLOT_DONE=1; export PGPLOT_DONE; break;;
    * ) echo "Please answer:  Use / Compile . ";;
  esac
  done
else
  export PGPLOT_DONE=1
fi
fi
#
if [[ $PGPLOT_DONE == 1 ]]; then
#
  rm    -rf $PGPLOT_INST_DIR
  rm    -rf $PGPLOT_SRC_DIR
#
# if [[ ! -e DIFFUSE_CODE_pgplot.tar.gz ]]; then
  echo
  echo " Installation of PGPLOT from code at github"
  echo " Download may take a moment, please be patient "
  echo
  curl -k -o  DIFFUSE_CODE_pgplot.tar.gz -fSL ${PGPLOT_CODE_URL}
  echo
  echo " Download of ${PGPLOT_CODE_URL} finished "
  echo
# fi
  tar -zxf DIFFUSE_CODE_pgplot.tar.gz
# mv pgplot $PGPLOT_INST_DIR
# mkdir -p $PGPLOT_SRC_DIR
# mv src/pgplot $PGPLOT_SRC_DIR
#
  cd $PGPLOT_INST_DIR
  make lib grfont.dat pgxwin_server
#  make cpg
  make clean
#
  cd $DISCUS_INST_DIR
#
  if [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]] ; then
    if [[ "$OPERATING" == "DISCUS_LINUX" || "$OPERATING" == "DISCUS_WSL_LINUX" || "$OPERATING" == "DISCUS_MACOS" ]]; then
      echo sudo cp -r $PGPLOT_INST_DIR $PGPLOT_ROOT_DIR
      sudo cp -r $PGPLOT_INST_DIR $PGPLOT_ROOT_DIR
    elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
      echo cp -r $PGPLOT_INST_DIR $PGPLOT_ROOT_DIR
      cp -r $PGPLOT_INST_DIR $PGPLOT_ROOT_DIR
    fi
  else
    echo cp -r $PGPLOT_INST_DIR $PGPLOT_ROOT_DIR
    cp -r $PGPLOT_INST_DIR $PGPLOT_ROOT_DIR
  fi
#
fi
#
cd $DISCUS_INST_DIR
#
#echo PGPLOT FINISHED
#echo
#echo $PGPLOT_ROOT_DIR
#echo $PGPLOT_INST_DIR
#echo $PGPLOT_SRC_DIR
#pwd
#echo
#source set_pgplot_bash.sh
#echo did set_pgplot_bash.sh
#
