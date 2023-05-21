REM  Search for latest powershell; run with explicit path and exit
REM  Some DISCUS users do not have the PATH set up all that well
REM  BAT does not have an "elseif"
REM
if not exist "%USERPROFILE%\DISCUS_INSTALLATION\" (
  mkdir "%USERPROFILE%\DISCUS_INSTALLATION\"
)
REM
cp "bbb_install_suite_Windows10_WSL.ps1"  "%USERPROFILE%\DISCUS_INSTALLATION\"
REM
cd %USERPROFILE%\DISCUS_INSTALLATION\  
REM 
if exist "C:\Program Files\Powershell\8" (
  REM Might be the new version in 20xx??
  "C:\Program Files\Powershell\8\pwsh.exe" -ExecutionPolicy Bypass -File "bbb_install_suite_Windows10_WSL.ps1"
  exit
)
if exist "C:\Program Files\Powershell\7" (
  REM Currently (2022/2023) the proper version
  "C:\Program Files\Powershell\7\pwsh.exe" -ExecutionPolicy Bypass -File "bbb_install_suite_Windows10_WSL.ps1"
  exit
)
if exist "C:\Program Files\Powershell\6" (
  REM May still exist on older computer ???
  "C:\Program Files\Powershell\6\pwsh.exe" -ExecutionPolicy Bypass -File "bbb_install_suite_Windows10_WSL.ps1"
  exit
)
REM Default if no pwsh.exe is detected
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "bbb_install_suite_Windows10_WSL.ps1"
