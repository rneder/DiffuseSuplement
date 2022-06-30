#REM DISCUS_SUITE VIA UBUNTU; Powershell version
cd "C:\Program Files (X86)\DiscusWSL"
$vcxsrv_active = Get-Process vcxsrv -ErrorAction SilentlyContinue
$xming_active = Get-Process Xming -ErrorAction SilentlyContinue
if($xming_active) {
  Write-Host " "
  Write-Host "DISCUS uses the VcXsrv X-Window server"
  Write-Host "Presently the xming server is running."
  Write-Host "Please stop xming process and start DISCUS again"
  $done = (Read-Host 'Type enter to finish POWERSHELL')
  Exit
}
if ($vcxsrv_active )
{
  Write-Host "XLaunch.exe IS ALREADY  RUNNING"
}
else
{
  Write-Host "XLaunch.exe will be started"
  $W_TEMP = $env:USERPROFILE + "\DISCUS_INSTALLATION\DiscusWSL\config.xlaunch"
  Start-Process "C:\Program Files\vcxsrv\xlaunch.exe" -ArgumentList " -run `"$W_TEMP`""
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

$is_wsl_file="$HOME\AppData\Local\Temp\is_wsl.txt"
$is_wsl = wsl -l -v 2>&1 |out-file  -encoding ASCII "$is_wsl_file"

foreach($line in Get-Content "$is_wsl_file") {
  $comp = $line -replace '\0'
  If($comp.contains("Ubuntu ")) {
    $IS_UBUNTU     = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu.exe"
    If (Test-Path $IS_UBUNTU -PathType leaf) {
      $UBUNTU_EXE = "$IS_UBUNTU"
    }
  }
  Elseif($comp.contains("Ubuntu-20.04 ")) {
    $IS_UBUNTU2004 = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu2004.exe"
    if (Test-Path $IS_UBUNTU2004 -PathType leaf) {
      $UBUNTU_EXE = "$IS_UBUNTU2004"
    }
  }
  Elseif($comp.contains("Ubuntu-18.04 ")) {
    $IS_UBUNTU1804 = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu1804.exe"
    If (Test-Path $IS_UBUNTU1804 -PathType leaf) {
      $UBUNTU_EXE = "$IS_UBUNTU1804"
    }
  }
}
Start-Process "$UBUNTU_EXE" -WindowStyle Hidden -ArgumentList "-c `"cd ; source .profile.local; discus_suite_ubuntu.sh $wsl_use`""

#$done = (Read-Host 'Type enter to finish POWERSHELL')
#exit
#
