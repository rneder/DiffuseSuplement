#
# test_imagemagick_linux.sh
#  Linux may NOT have a blank at the end of the first sed line!
#
# Test if "policy.xml" exists. 
#   If so, check for line with read/write policy for $1
#     If not insert prior to end of policy block
#   Else copy template from SUPPORT
#
if [[ -e ${HOME}/.config/ImageMagick/policy.xml ]]; then
   set +e
   TEST=$(fgrep  "<policy domain=\"coder\" rights=\"read | write\" pattern=\"$1\"" ${HOME}/.config/ImageMagick/policy.xml)
   if [[ $? != 0 ]]; then
#
sed "/<\/policymap>/ i\
\ \ <policy domain=\"coder\" rights=\"read | write\" pattern=\"$1\" \/>  
" ${HOME}/.config/ImageMagick/policy.xml > $DISCUS_INST_DIR/temp.temp
      cp $DISCUS_INST_DIR/temp.temp ${MAGICK_CONFIGURE_PATH}/policy.xml
      rm $DISCUS_INST_DIR/temp.temp
#
   fi
   set -e
else
   cp $DISCUS_INST_DIR/SUPPORT/policy.xml ${MAGICK_CONFIGURE_PATH}
fi
