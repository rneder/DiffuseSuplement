#
#
set -e
#
cd $DISCUS_DEVELOP/DiffuseBuild
export FC=$(which gfortran)
#
if [[ "$OPERATING" == "DISCUS_LINUX" || "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then
#
#
  cmake -DDIFFEV_MPI=$DIFFEV_MPI_FLAG  -DDEBUG=OFF -DDIFFUSE_PYTHON=OFF -DDISCUS_CUDA=OFF -DDISCUS_OMP=ON -DPGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot -DPGPLOT_INCLUDE_DIR=$PGPLOT_ROOT_DIR/pgplot -DPGPLOT_PGPLOT_LIBRARY=$PGPLOT_ROOT_DIR/pgplot/libpgplot.a -DPGPLOT_CPGPLOT_LIBRARY=$PGPLOT_ROOT_DIR/pgplot/libcpgplot.a -DCMAKE_INSTALL_PREFIX=$DISCUS_BIN_PREFIX ../DiffuseCode
#  cmake -DDIFFEV_MPI=$DIFFEV_MPI_FLAG  -DDEBUG=OFF -DDIFFUSE_PYTHON=OFF -DDISCUS_CUDA=OFF -DDISCUS_OMP=OFF -DHDF5_DIR=$HDF5_DIR -DPGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot -DPGPLOT_INCLUDE_DIR=$PGPLOT_ROOT_DIR/pgplot -DPGPLOT_PGPLOT_LIBRARY=$PGPLOT_ROOT_DIR/pgplot/libpgplot.a -DPGPLOT_CPGPLOT_LIBRARY=$PGPLOT_ROOT_DIR/pgplot/libcpgplot.a -DCMAKE_INSTALL_PREFIX=$DISCUS_BIN_PREFIX ../DiffuseCode
#
elif [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
#
# Temporarily while phasing out the standalone programs DISCUS, DIFFEV, KUPLOT, REFINE, MIXSCAT
  rm -f $DISCUS_BIN_PREFIX/bin/discus.exe
  rm -f $DISCUS_BIN_PREFIX/bin/diffev.exe
  rm -f $DISCUS_BIN_PREFIX/bin/kuplot.exe
  rm -f $DISCUS_BIN_PREFIX/bin/refine.exe
  cmake -DDIFFEV_MPI=$DIFFEV_MPI_FLAG  -DDEBUG=OFF -DDIFFUSE_PYTHON=OFF -DDISCUS_CUDA=OFF -DDISCUS_OMP=ON -DHDF5_DIR=$HDF5_DIR -DPGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot -DPGPLOT_INCLUDE_DIR=$PGPLOT_ROOT_DIR/pgplot -DPGPLOT_PGPLOT_LIBRARY=$PGPLOT_ROOT_DIR/pgplot/libpgplot.a -DPGPLOT_CPGPLOT_LIBRARY=$PGPLOT_ROOT_DIR/pgplot/libcpgplot.a -DCMAKE_INSTALL_PREFIX=$DISCUS_BIN_PREFIX ../DiffuseCode
#
elif  [[ "$OPERATING" == "DISCUS_MACOS" ]]; then
#
  cmake -DDIFFEV_MPI=$DIFFEV_MPI_FLAG  -DDEBUG=OFF -DDIFFUSE_PYTHON=OFF -DDISCUS_CUDA=OFF -DDISCUS_OMP=ON -DHDF5_DIR=$HDF5_DIR -DPGPLOT_DIR=$PGPLOT_ROOT_DIR/pgplot -DPGPLOT_INCLUDE_DIR=$PGPLOT_ROOT_DIR/pgplot -DPGPLOT_PGPLOT_LIBRARY=$PGPLOT_ROOT_DIR/pgplot/libpgplot.a -DPGPLOT_CPGPLOT_LIBRARY=$PGPLOT_ROOT_DIR/pgplot/libcpgplot.a -DCMAKE_INSTALL_PREFIX=$DISCUS_BIN_PREFIX ../DiffuseCode
#
fi
#
if [[ "$1" == "clean" ]]; then
  make clean
fi
#
# Temporarily while phasing out the standalone programs DISCUS, DIFFEV, KUPLOT, REFINE, MIXSCAT
if  [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]  || [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
  rm -f $DISCUS_BIN_PREFIX/bin/discus
  rm -f $DISCUS_BIN_PREFIX/bin/diffev
  rm -f $DISCUS_BIN_PREFIX/bin/kuplot
  rm -f $DISCUS_BIN_PREFIX/bin/refine
  rm -f $DISCUS_BIN_PREFIX/bin/mixscat
  rm -f $DISCUS_BIN_PREFIX/share/discus.hlp
  rm -f $DISCUS_BIN_PREFIX/share/diffev.hlp
  rm -f $DISCUS_BIN_PREFIX/share/kuplot.hlp
  rm -f $DISCUS_BIN_PREFIX/share/refine.hlp
  rm -f $DISCUS_BIN_PREFIX/share/mixscat.hlp
elif  [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]]; then
  sudo rm -f $DISCUS_BIN_PREFIX/bin/discus
  sudo rm -f $DISCUS_BIN_PREFIX/bin/diffev
  sudo rm -f $DISCUS_BIN_PREFIX/bin/kuplot
  sudo rm -f $DISCUS_BIN_PREFIX/bin/refine
  sudo rm -f $DISCUS_BIN_PREFIX/bin/mixscat
  sudo rm -f $DISCUS_BIN_PREFIX/share/discus.hlp
  sudo rm -f $DISCUS_BIN_PREFIX/share/diffev.hlp
  sudo rm -f $DISCUS_BIN_PREFIX/share/kuplot.hlp
  sudo rm -f $DISCUS_BIN_PREFIX/share/refine.hlp
  sudo rm -f $DISCUS_BIN_PREFIX/share/mixscat.hlp
fi
#
if  [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]  || [[ "$OPERATING" == "DISCUS_CYGWIN" ]]; then
  make -j install
  cp suite/prog/discus_suite $DISCUS_BIN_PREFIX/bin
elif  [[ $DISCUS_INSTALL == $DISCUS_GLOBAL ]]; then
  sudo make -j install
  sudo cp suite/prog/discus_suite $DISCUS_BIN_PREFIX/bin
fi
####make clean
#
cd $DISCUS_INST_DIR
echo finished compilation
