#REM DISCUS_SUITE VIA UBUNTU; Powershell version
#cd "C:\Program Files (X86)\DiscusWSL"
#
cd "$HOME"
cd DISCUS_INSTALLATION\DiscusWSL
$cwd = get-Location | Select-Object Path -ExpandProperty Path
#
### Create a Yes/No option #####################################################
#
$yes = New-Object System.Management.Automation.Host.ChoiceDescription `
     "&Yes","Answering Yes will carry out the action prompted for."
$no  = New-Object System.Management.Automation.Host.ChoiceDescription `
     "&No","Answering No will instruct the shell NOT to carry out the action."
#$cancel = New-Object System.Management.Automation.Host.ChoiceDescription `
#     "&Cancel","Description."
#$YNC_options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $cancel)
$YN_options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
#
### Usefull Powershell scripts for Discus ######################################
#
# $xlaunchpath = Find-xlaunch("vcxsrv")
#
function Find-xlaunch($key){
# read all child keys (*) from all four locations and do not emit
# errors if one of these keys does not exist:
$is_vcxsrv_file="$HOME\AppData\Local\Temp\is_vcxsrv.txt"
#$key = "vcxsrv"
#Write-Host "KEY " $key
$key1 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'+$key
$key2 = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\' + $key
$key3 = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'+$key
$key4 = 'HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'+$key
Get-ItemProperty -Path $key1, $key2, $key3, $key4 -ErrorAction Ignore |
#
# list only items with a displayname:
#
Where-Object DisplayName |
#
# show these registry values per item:
#
Select-Object -Property DisplayName, DisplayIcon |
#
# sort by displayname:
#
Sort-Object -Property DisplayName | out-file  -encoding ASCII "$is_vcxsrv_file"
#Write-Host " FILE " $is_vcxsrv_file
#
$xlaunchpath = " "
foreach($line in Get-Content "$is_vcxsrv_file") {
  $comp = $line -replace '\0'
#  Write-Host " LINE " $comp $comp.contains($key)
  If($comp.contains($key)) {
    $colon = $comp.IndexOf(":")
#    Write-Host "$type in : " $comp
#    Write-Host "$type in : " $comp.substring($colon-1, $comp.length-$colon+1)
    $xlaunchpath = $comp.substring($colon-1, $comp.length-$colon-9) + "xlaunch.exe"
#   Write-Host "XXX PATH : " $xlaunchpath
	}
  }
  return $xlaunchpath
}
#
################################################################################
#
# Link to support powershell functions Currently not used 
#$support = "$cwd" + "\discus_support.ps1"
#. $support
#
$xlaunchpath = Find-xlaunch("vcxsrv")
#
#
################################################################################
#
# Header ends; start DISCUS
#
################################################################################
#
$vcxsrv_active = Get-Process vcxsrv -ErrorAction SilentlyContinue
$xming_active = Get-Process xming -ErrorAction SilentlyContinue
if($xming_active) {
  Write-Host " "
  Write-Host "DISCUS uses the VcXsrv X-Window server"
  Write-Host "Presently the XMING server is running."
  $title = "Stopping XMING might disable other programs like RMCProfile" 
  $message = "OK to stop XMING now ?"
  $result = $host.ui.PromptForChoice($title, $message, $YN_options, 1)
  switch ($result) {
    0{
#     Write-Host "Yes"
      Stop-Process -Name xming -ErrorAction SilentlyContinue
      Get-Process | Where-Object {$_.HasExited}
      Write-Host " "
      $xming_active = ""
      $xming_active = Get-Process Xming -ErrorAction SilentlyContinue
      if($xming_active) {
        Write-Host "Could not stop XMING. Probably started by another user"
        Write-Host "Please stop XMING or reboot computer to use DISCUS"
        $done = (Read-Host 'Type enter to finish POWERSHELL')
        cd "$HOME"
        Exit
      }
      Else{
       Write-Host "XMING was stopped"
      }
	}
    1{
#     Write-Host "No"
      Write-Host "DISCUS cannot run if the XMING server is active"
      Write-Host "Please stop XMING or reboot computer to use DISCUS"
      $done = (Read-Host 'Type enter to finish POWERSHELL')
      cd "$HOME"
      Exit
    }
  }
#
}
if ($vcxsrv_active )
{
  Write-Host "XLaunch.exe IS ALREADY  RUNNING"
}
else
{
  Write-Host "XLaunch.exe will be started"
  $W_TEMP = $env:USERPROFILE + "\DISCUS_INSTALLATION\DiscusWSL\config.xlaunch"
# Start-Process "C:\Program Files\vcxsrv\xlaunch.exe" -ArgumentList " -run `"$W_TEMP`""
  Start-Process "$xlaunchpath" -ArgumentList " -run `"$W_TEMP`""
}
#
cd $HOME
#
# Test for WSL version 1 / 2
#
C:\Windows\System32\wsl.exe -l -v  | Out-File "$HOME\AppData\Local\Temp\wsl.neu"
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
$is_wsl = C:\Windows\System32\wsl.exe -l -v 2>&1 |out-file  -encoding ASCII "$is_wsl_file"

foreach($line in Get-Content "$is_wsl_file") {
  $comp = $line -replace '\0'
  If($comp.contains("Ubuntu ")) {
    $IS_UBUNTU     = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu.exe"
    If (Test-Path $IS_UBUNTU -PathType leaf) {
      $UBUNTU_EXE = "$IS_UBUNTU"
    }
  }
  Elseif($comp.contains("Ubuntu-22.04 ")) {
    $IS_UBUNTU2204 = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu2204.exe"
    if (Test-Path $IS_UBUNTU2204 -PathType leaf) {
      $UBUNTU_EXE = "$IS_UBUNTU2204"
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
