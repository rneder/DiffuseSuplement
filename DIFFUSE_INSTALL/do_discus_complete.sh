    export DIFFEV_MPI_FLAG=OFF
    source   ./compile_discus.sh clean
    if [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]; then
      cp /usr/local/bin/discus_suite /usr/local/bin/discus_suite_noparallel
    else
      sudo cp /usr/local/bin/discus_suite /usr/local/bin/discus_suite_noparallel
    fi
    export DIFFEV_MPI_FLAG=ON
    source   ./compile_discus.sh noclean
#
    cd $DISCUS_INST_DIR
    if [[ $DISCUS_INSTALL == $DISCUS_LOCAL ]]; then
      cp SHELLS/discus_suite_ubuntu.sh     /usr/local/bin
      cp SHELLS/discus_suite_run_ubuntu.sh /usr/local/bin
      cp SHELLS/terminal_wrapper.sh        /usr/local/bin
    else
      sudo cp SHELLS/discus_suite_ubuntu.sh     /usr/local/bin
      sudo cp SHELLS/discus_suite_run_ubuntu.sh /usr/local/bin
      sudo cp SHELLS/terminal_wrapper.sh        /usr/local/bin
    fi
