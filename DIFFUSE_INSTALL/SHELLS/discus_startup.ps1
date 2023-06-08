#REM DISCUS_SUITE VIA UBUNTU; Powershell version for Windows 11
#
#
cd "$HOME"
cd DISCUS_INSTALLATION
$dis_inst = get-Location | Select-Object Path -ExpandProperty Path
cd DISCUS_INSTALLATION\DiscusWSL
$cwd = get-Location | Select-Object Path -ExpandProperty Path
#
$wsl_use = & $dis_inst\get_wsl_ver.ps1
$win_ver = & $dis_inst\get_win_ver.ps1
$UBUNTU_EXE = & $dis_inst\get_ubuntu.ps1
#
if( -not ($wsl_use -eq "2" -And $win_ver -eq "11")) {
  & .\xlaunch.ps1
}
#
cd "$HOME"
#
Start-Process "$UBUNTU_EXE" -WindowStyle Hidden -ArgumentList "-c `"cd ; source .profile.local; export DISPLAY=:0; $HOME/DIFFUSE_INSTALLATION/SHELLS/start_pgxwin.sh; exit`""

$done = (Read-Host 'Type enter to finish POWERSHELL')
exit
#
