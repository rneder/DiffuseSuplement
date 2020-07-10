#!/bin/bash
#
#  Analyzes profile.local if it contains an "export PATH" line after "PATH="
#
ILINE=$((0))
IEXPO=$((0))
IPATH=$((0))
while IFS='' read -r LINE || [ -n "${LINE}" ]; do
#   echo "processing line: ${LINE}"
  ILINE=$((ILINE+1))
  if [[ ${LINE} == "PATH="* ]]; then
       IPATH=$((ILINE))
  elif [[ ${LINE} == "export PATH"* ]]; then
       IEXPO=$((ILINE))
  fi
done < $1
#
if [[ ${IEXPO} < ${IPATH} ]]; then
  echo "export PATH" >> $1
fi

