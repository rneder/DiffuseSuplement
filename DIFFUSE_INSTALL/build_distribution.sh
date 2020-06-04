#!/bin/bash
#
# Build a DISCUS precompiled distribution after full compilation
#
cd ${DISCUS_INST_DIR}
#
mkdir -p ${DIFFUSE_PRE}/bin
mkdir -p ${DIFFUSE_PRE}/share
mkdir -p ${DIFFUSE_PRE}/pgplot
#
cp -r ${DISCUS_BIN_PREFIX}/pgplot/pgxwin_server           ${DIFFUSE_PRE}/pgplot  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/pgplot/rgb.txt                 ${DIFFUSE_PRE}/pgplot  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/pgplot/grfont.dat              ${DIFFUSE_PRE}/pgplot  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/pgplot/libpgplot.a             ${DIFFUSE_PRE}/pgplot  > /dev/null || :
#
if [[ "$OPERATING" == "DISCUS_LINUX" ]]; then                # Native Linux
  cp  ${DISCUS_BIN_PREFIX}/bin/discus_suite               ${DIFFUSE_PRE}/bin  > /dev/null || :
elif [[ "$OPERATING" == "DISCUS_WSL_LINUX" ]]; then          # WINDOWS WSL
  cp  ${DISCUS_BIN_PREFIX}/bin/discus_suite               ${DIFFUSE_PRE}/bin  > /dev/null || :
  cp  ${DISCUS_BIN_PREFIX}/bin/discus_suite_noparallel    ${DIFFUSE_PRE}/bin  > /dev/null || :
  cp  ${DISCUS_BIN_PREFIX}/bin/discus_suite_run_ubuntu.sh ${DIFFUSE_PRE}/bin  > /dev/null || :
  cp  ${DISCUS_BIN_PREFIX}/bin/discus_suite_ubuntu.sh     ${DIFFUSE_PRE}/bin  > /dev/null || :
  cp  ${DISCUS_BIN_PREFIX}/bin/terminal_wrapper.sh        ${DIFFUSE_PRE}/bin  > /dev/null || :
  cp  ${DISCUS_BIN_PREFIX}/pgplot/pgxwin_server           ${DIFFUSE_PRE}/bin  > /dev/null || :
elif  [[ "$OPERATING" == "DISCUS_MACOS" ]]; then              # MAC OS
  cp  ${DISCUS_BIN_PREFIX}/bin/discus_suite               ${DIFFUSE_PRE}/bin  > /dev/null || :
fi
#
cp    ${DISCUS_BIN_PREFIX}/share/AAA_INSTALL*.pdf         ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/discus_man.pdf           ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/diffev_man.pdf           ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/kuplot_man.pdf           ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/refine_man.pdf           ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/suite_man.pdf            ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/package_man.pdf          ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/color.map                ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/DiscusSuite.txt          ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/suite.hlp                ${DIFFUSE_PRE}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/grfont.dat               ${DIFFUSE_PRE}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/discus/                  ${DIFFUSE_PRE}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/diffev/                  ${DIFFUSE_PRE}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/kuplot/                  ${DIFFUSE_PRE}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/refine/                  ${DIFFUSE_PRE}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/suite/                   ${DIFFUSE_PRE}/share  > /dev/null || :
#
tar -zcf ${DIFFUSE_PRE}.tar.gz ${DIFFUSE_PRE}
