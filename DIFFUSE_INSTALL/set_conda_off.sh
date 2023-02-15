#    !/bin/bash
#
# Test for CONDA and deactivate as it messes up the linker, at least on Mac
#
if [[ $CONDA_SHLVL == 1 ]] ; then
  echo "CONDA environment is active; "
  echo "This tends to interfere with the DISCUS compilation during install."
  echo "The install script will deactivate CONDA during compilation and "
  echo " activate once finished"
  echo
  export DISCUS_CONDA_OFF=0
  while true; do
    read -p "OK to deactivate CONDA during DISCUS installation [y/n/c]?" yn
    case $yn in
      [Yy]* ) conda deactivate; DISCUS_CONDA_OFF=1; export CONDA_SHLVL=0; break 1;;
      [Nn]* ) echo "DISCUS compilation cannot proceed";echo "deactivate CONDA and try again" ; exit 1;;
      [Cn]* ) echo "DISCUS compilation cannot proceed";echo "deactivate CONDA and try again" ; exit 1;;
    esac
  done
fi
