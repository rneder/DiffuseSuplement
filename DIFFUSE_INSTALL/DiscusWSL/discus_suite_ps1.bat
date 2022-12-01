REM  Search for latest powershell; run with explicit path and exit
REM  Some DISCUS users do not have the PATH set up all that well
REM  BAT does not have an "elseif"
if exist "C:\Program Files\Powershell\8" (
  REM  echo PWSH Version 8; sometime in the future ?
  "C:\Program Files\Powershell\8\pwsh.exe" -File "C:\Users\reinhard\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"
  exit
)
if exist "C:\Program Files\Powershell\7" (
  REM  echo PWSH Version 7; sometime in the future ?
  "C:\Program Files\Powershell\7\pwsh.exe" -File "C:\Users\reinhard\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"
  exit
)
if exist "C:\Program Files\Powershell\6" (
  REM  echo PWSH Version 6; sometime in the future ?
  "C:\Program Files\Powershell\6\pwsh.exe" -File "C:\Users\reinhard\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"
  exit
)
REM Default if no pwsh.exe is detected
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\Users\reinhard\DISCUS_INSTALLATION\DiscusWSL\discus_suite.ps1"
