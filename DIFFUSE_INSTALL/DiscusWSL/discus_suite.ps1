#REM DISCUS_SUITE VIA UBUNTU; Powershell version
cd "C:\Program Files (X86)\DiscusWSL"
$vcxsrv_active = Get-Process vcxsrv -ErrorAction SilentlyContinue
if ($vcxsrv_active)
{
  Write-Host "XLaunch.exe IS ALREADY  RUNNING"
}
else
{
  Write-Host "XLaunch.exe will be started"
  Start-Process "C:\Program Files\vcxsrv\xlaunch.exe" -ArgumentList " -run `"C:\Program Files (X86)\DiscusWSL\config.xlaunch`""
}
#
cd $HOME
#
# Test for WSL version 1 / 2
#
wsl -l -v  | Out-File "$HOME\AppData\Local\Temp\wsl.neu"
(Get-Content "$HOME\AppData\Local\Temp\wsl.neu") -replace "`0", "" | Set-Content "$HOME\AppData\Local\Temp\wsl.neu" 
#wsl -l -v  | Out-File "$HOME\AppData\Local\Temp\wsl.version" -Encoding ASCII
$wsl_ver = Select-String -Path "$HOME\AppData\Local\Temp\wsl.neu" -Pattern ' 2'
#
#
cd $HOME
#
if ($wsl_ver)
{ 
  'This is Version 2'
  $wsl_use = 2
}
else
{
  'This is Version 1'
  $wsl_use = 1
}
Start-Process ubuntu2004 -WindowStyle Hidden -ArgumentList "-c `"cd ; source .profile.local; discus_suite_ubuntu.sh $wsl_use`""

#$done = (Read-Host 'Type enter to finish POWERSHELL')
#exit
#