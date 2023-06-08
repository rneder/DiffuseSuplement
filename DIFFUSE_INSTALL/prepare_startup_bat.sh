echo 'REM  Search for latest powershell; run with explicit path and exit' > DiscusWSL/discus_startup.bat
echo 'REM  Some DISCUS users do not have the PATH set up all that well'  >> DiscusWSL/discus_startup.bat
echo 'REM  BAT does not have an "elseif"'                   >> DiscusWSL/discus_startup.bat
#
echo 'if exist "C:\Program Files\Powershell\8" ('           >> DiscusWSL/discus_startup.bat
echo '  REM  echo PWSH Version 8; sometime in the future ?' >> DiscusWSL/discus_startup.bat
WSL_BAT='"C:\Program Files\Powershell\8\pwsh.exe" -ExecutionPolicy Bypass -File "'
WSL_BAT+=${WSL_USER_PROFILE}
WSL_BAT+='\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"'
echo '  '${WSL_BAT}                                         >> DiscusWSL/discus_startup.bat
echo '  exit'                                               >> DiscusWSL/discus_startup.bat
echo ')'                                                    >> DiscusWSL/discus_startup.bat
#
echo 'if exist "C:\Program Files\Powershell\7" ('           >> DiscusWSL/discus_startup.bat
echo '  REM  echo PWSH Version 7; current powershell      ' >> DiscusWSL/discus_startup.bat
WSL_BAT='"C:\Program Files\Powershell\7\pwsh.exe" -ExecutionPolicy Bypass -File "'
WSL_BAT+=${WSL_USER_PROFILE}
WSL_BAT+='\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"'
echo '  '${WSL_BAT}                                         >> DiscusWSL/discus_startup.bat
echo '  exit'                                               >> DiscusWSL/discus_startup.bat
echo ')'                                                    >> DiscusWSL/discus_startup.bat
#
echo 'if exist "C:\Program Files\Powershell\6" ('           >> DiscusWSL/discus_startup.bat
echo '  REM  echo PWSH Version 6; may exist on older     ?' >> DiscusWSL/discus_startup.bat
WSL_BAT='"C:\Program Files\Powershell\6\pwsh.exe" -ExecutionPolicy Bypass -File "'
WSL_BAT+=${WSL_USER_PROFILE}
WSL_BAT+='\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"'
echo '  '${WSL_BAT}                                         >> DiscusWSL/discus_startup.bat
echo '  exit'                                               >> DiscusWSL/discus_startup.bat
echo ')'                                                    >> DiscusWSL/discus_startup.bat
echo 'REM Default if no pwsh.exe is detected'               >> DiscusWSL/discus_startup.bat
WSL_BAT='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "'
WSL_BAT+=${WSL_USER_PROFILE}
WSL_BAT+='\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"'
echo ${WSL_BAT}                                             >> DiscusWSL/discus_startup.bat
#
echo
#cat DiscusWSL/discus_startup.bat
