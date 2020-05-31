#!/bin/bash
#
# Build a DISCUS precompiled distribution after full compilation
#
cd ${DISCUS_INST_DIR}
#
export DISCUS_COMPILED_VERSION=$(cat ${DISCUS_INST_DIR}/develop/DiffuseBuild/lib_f90/version.inc)
export DISCUS_DIST="DIFFUSE_"${OPERATING_NAME}_${OPERATING_VERSION}_${DISCUS_COMPILED_VERSION}
mkdir -p ${DISCUS_DIST}/bin
mkdir -p ${DISCUS_DIST}/share
mkdir -p ${DISCUS_DIST}/pgplot
#
cp -r ${DISCUS_BIN_PREFIX}/pgplot/pgxwin_server     ${DISCUS_DIST}/pgplot  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/pgplot/rgb.txt           ${DISCUS_DIST}/pgplot  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/pgplot/grfont.dat        ${DISCUS_DIST}/pgplot  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/pgplot/libpgplot.a       ${DISCUS_DIST}/pgplot  > /dev/null || :
#
cp    ${DISCUS_BIN_PREFIX}/bin/discus_suite*        ${DISCUS_DIST}/bin  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/bin/terminal_wrapper.sh  ${DISCUS_DIST}/bin  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/pgplot/pgxwin_server     ${DISCUS_DIST}/bin  > /dev/null || :
#
cp    ${DISCUS_BIN_PREFIX}/share/AAA_INSTALL*.pdf   ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/discus_man.pdf     ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/diffev_man.pdf     ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/kuplot_man.pdf     ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/refine_man.pdf     ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/suite_man.pdf      ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/package_man.pdf    ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/color.map          ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/DiscusSuite.txt    ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/suite.hlp          ${DISCUS_DIST}/share  > /dev/null || :
cp    ${DISCUS_BIN_PREFIX}/share/grfont.dat         ${DISCUS_DIST}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/discus/            ${DISCUS_DIST}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/diffev/            ${DISCUS_DIST}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/kuplot/            ${DISCUS_DIST}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/refine/            ${DISCUS_DIST}/share  > /dev/null || :
cp -r ${DISCUS_BIN_PREFIX}/share/suite/             ${DISCUS_DIST}/share  > /dev/null || :
#
tar -zcf ${DISCUS_DIST}.tar.gz ${DISCUS_DIST}
