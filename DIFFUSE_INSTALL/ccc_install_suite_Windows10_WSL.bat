REM  
REM  ccc_install_suite_Windows10_WSL.ps1
REM  Search for latest powershell; run with explicit path and exit
REM  Some DISCUS users do not have the PATH set up all that well
REM  BAT does not have an "elseif"
REM  Copy of bbb_install_suite_Windows10_WSL.bat that is run by discus 'update' command
REM  
cd %USERPROFILE%\DISCUS_INSTALLATION\
if exist "C:\Program Files\Powershell\8" (
  REM Might be the new version in 20xx??
  "C:\Program Files\Powershell\8\pwsh.exe" -File "bbb_install_suite_Windows10_WSL.ps1"
  exit
)
if exist "C:\Program Files\Powershell\7" (
  REM Currently (2022/2023) the proper version
  "C:\Program Files\Powershell\7\pwsh.exe" -File "bbb_install_suite_Windows10_WSL.ps1"
  exit
)
if exist "C:\Program Files\Powershell\6" (
  REM May still exist on older computer ???
  "C:\Program Files\Powershell\6\pwsh.exe" -File "bbb_install_suite_Windows10_WSL.ps1"
  exit
)
REM Default if no pwsh.exe is detected 
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "bbb_install_suite_Windows10_WSL.ps1"
