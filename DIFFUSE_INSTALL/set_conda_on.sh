#   !/bin/bash
#
# Test for CONDA and deactivate as it messes up the linker, at least on Mac
#
if [[ $DISCUS_CONDA_OFF == 1 ]]; then
  echo "CONDA environment was deactivated; "
  echo "The install script will now activate CONDA again"
  echo
  export CONDA_SHLVL=1
  conda active
fi
