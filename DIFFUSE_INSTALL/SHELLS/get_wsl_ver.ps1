#
# Test for WSL version 1 / 2
#
C:\Windows\System32\wsl.exe -l -v  | Out-File "$HOME\AppData\Local\Temp\wsl.neu"
(Get-Content "$HOME\AppData\Local\Temp\wsl.neu") -replace "`0", "" | Set-Content "$HOME\AppData\Local\Temp\wsl.neu" 
#wsl -l -v  | Out-File "$HOME\AppData\Local\Temp\wsl.version" -Encoding ASCII
$wsl_comp = Select-String -Path "$HOME\AppData\Local\Temp\wsl.neu" -Pattern ' 2'
if($wsl_comp) {
  echo 2  | Out-File "$HOME\DISCUS_INSTALLATION\discus_wsl_ver.txt" -Encoding ASCII
  $wsl_ver = 2
}
Else {
  echo 1  | Out-File "$HOME\DISCUS_INSTALLATION\discus_wsl_ver.txt" -Encoding ASCII
  $wsl_ver = 1
}
return $wsl_ver
