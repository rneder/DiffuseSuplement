#!/bin/bash
#
# Find out if file $1 contains a line with partial string $2. 
# If so 
#    Replace line with string $2 in file $1 in all lines in which it occurs by $3
# Else
#    Append a line with string $3
#
set +e  
#
LINE_NO=$(fgrep -n "$2" $1 | cut -f1 -d:)
OLDLINE=$(fgrep "$2" $1)
#
if [ -z $LINE_NO ]; then
#
#  No line in file
#
  echo "$3" >> $1 
else
  sed -e "s:$OLDLINE:$3:" $1 > DUMMY.RBN
  mv DUMMY.RBN "$1"
fi
