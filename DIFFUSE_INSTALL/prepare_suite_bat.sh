echo 'REM  Search for latest powershell; run with explicit path and exit' > DiscusWSL/discus_suite_ps1.bat
echo 'REM  Some DISCUS users do not have the PATH set up all that well'  >> DiscusWSL/discus_suite_ps1.bat
echo 'REM  BAT does not have an "elseif"'                   >> DiscusWSL/discus_suite_ps1.bat
#
echo 'if exist "C:\Program Files\Powershell\8" ('           >> DiscusWSL/discus_suite_ps1.bat
echo '  REM  echo PWSH Version 8; sometime in the future ?' >> DiscusWSL/discus_suite_ps1.bat
WSL_BAT='"C:\Program Files\Powershell\8\pwsh.exe" -File "'
WSL_BAT+=${WSL_USER_PROFILE}
WSL_BAT+='\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"'
echo '  '${WSL_BAT}                                         >> DiscusWSL/discus_suite_ps1.bat
echo '  exit'                                               >> DiscusWSL/discus_suite_ps1.bat
echo ')'                                                    >> DiscusWSL/discus_suite_ps1.bat
#
echo 'if exist "C:\Program Files\Powershell\7" ('           >> DiscusWSL/discus_suite_ps1.bat
echo '  REM  echo PWSH Version 7; sometime in the future ?' >> DiscusWSL/discus_suite_ps1.bat
WSL_BAT='"C:\Program Files\Powershell\7\pwsh.exe" -File "'
WSL_BAT+=${WSL_USER_PROFILE}
WSL_BAT+='\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"'
echo '  '${WSL_BAT}                                         >> DiscusWSL/discus_suite_ps1.bat
echo '  exit'                                               >> DiscusWSL/discus_suite_ps1.bat
echo ')'                                                    >> DiscusWSL/discus_suite_ps1.bat
#
echo 'if exist "C:\Program Files\Powershell\6" ('           >> DiscusWSL/discus_suite_ps1.bat
echo '  REM  echo PWSH Version 6; sometime in the future ?' >> DiscusWSL/discus_suite_ps1.bat
WSL_BAT='"C:\Program Files\Powershell\6\pwsh.exe" -File "'
WSL_BAT+=${WSL_USER_PROFILE}
WSL_BAT+='\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"'
echo '  '${WSL_BAT}                                         >> DiscusWSL/discus_suite_ps1.bat
echo '  exit'                                               >> DiscusWSL/discus_suite_ps1.bat
echo ')'                                                    >> DiscusWSL/discus_suite_ps1.bat
echo 'REM Default if no pwsh.exe is detected'               >> DiscusWSL/discus_suite_ps1.bat
WSL_BAT='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "'
WSL_BAT+=${WSL_USER_PROFILE}
WSL_BAT+='\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"'
echo ${WSL_BAT}                                             >> DiscusWSL/discus_suite_ps1.bat
#
echo
cat DiscusWSL/discus_suite_ps1.bat
