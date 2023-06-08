#export MAGICK_CONFIGURE_PATH=${HOME}/.config/ImageMagick
#export DISCUS_INST_DIR=$(pwd)
#
if [[ -e ${HOME}/.config/ImageMagick/policy.xml ]]; then
   if ! fgrep  "<policy domain=\"coder\" rights=\"read | write\" pattern=\"$1\"" ${HOME}/.config/ImageMagick/policy.xml; then
      sed "/<\/policymap>/i \ 
          \ \ <policy domain=\"coder\" rights=\"read | write\" pattern=\"$1\" \/>" ${HOME}/.config/ImageMagick/policy.xml > $DISCUS_INST_DIR/temp.temp
      cp $DISCUS_INST_DIR/temp.temp ${MAGICK_CONFIGURE_PATH}/policy.xml
      rm $DISCUS_INST_DIR/temp.temp
#     echo $1 did not exist
   fi
else
   cp $DISCUS_INST_DIR/SUPPORT/policy.xml ${MAGICK_CONFIGURE_PATH}
fi
