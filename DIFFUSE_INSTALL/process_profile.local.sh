#!/bin/bash
#
#  Copies File $1 into $2 while ignoring lines that contain entries in "IGNORES"
#
IGNORES=( "PGPLOT_DIR" "PGPLOT_DEV" "PGPLOT_FONT" "DISCUS_NCPU" "HDF5_DIR" "JAVA_HOME" "JMOL_HOME" "MAGICK_CONFIGURE_PATH")
FIXED=( '#')
while IFS='' read -r LINE || [ -n "${LINE}" ]; do
#   echo "processing line: ${LINE}"
  PRINT="TRUE"
  for i in "${IGNORES[@]}"; do
    if [[ ${LINE} == *"$i"* ]]; then
       PRINT="FALSE"
       break
    fi
  done
  for i in "${FIXED[@]}"; do
    if [[ ${LINE} == "$i" ]]; then
       PRINT="FALSE"
       break
    fi
  done
  if [[ "${PRINT}" == "TRUE" ]]; then
    echo ${LINE} >> $2
  fi
done < $1
#

