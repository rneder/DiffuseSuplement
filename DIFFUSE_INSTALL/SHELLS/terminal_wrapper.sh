#!/bin/sh
if [ $# -eq 0 ]; then "${SHELL:-sh}"; else "$@"; fi
echo "The DISCUS_SUITE exited with status $?. Press any key to close the terminal."
stty -icanon; dd ibs=1 count=1 >/dev/null 2>&1
#read line
