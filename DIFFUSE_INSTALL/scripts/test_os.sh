#!/bin/bash
#
if [[ "$OSTYPE" == *"linux"* ]]; then
  echo THIS IS LINUX
elif [[ "$OSTYPE" == "cygwin" ]]; then
  echo THIS IS CYGWIN
fi
