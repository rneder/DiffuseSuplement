#
#  Start xlaunch for DISCUS if needed
#
################################################################################
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
################################################################################
#
#
function Find-xlaunch($key){
# read all child keys (*) from all four locations and do not emit
# errors if one of these keys does not exist:
  $is_vcxsrv_file="$HOME\AppData\Local\Temp\is_vcxsrv.txt"
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
# Write-Host " FILE " $is_vcxsrv_file
#
  $xlaunchpath = " "
  foreach($line in Get-Content "$is_vcxsrv_file") {
    $comp = $line -replace '\0'
#   Write-Host " LINE " $comp $comp.contains($key)
    If($comp.contains($key)) {
      $colon = $comp.IndexOf(":")
#     Write-Host "$type in : " $comp
#     Write-Host "$type in : " $comp.substring($colon-1, $comp.length-$colon+1)
      $xlaunchpath = $comp.substring($colon-1, $comp.length-$colon-9) + "xlaunch.exe"
#     Write-Host "XXX PATH : " $xlaunchpath
    }
  }
  return $xlaunchpath
}
#
################################################################################
#
$xlaunchpath = Find-xlaunch("vcxsrv")
#
$success = 1
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
        $success = 1
      }
      Else{
        Write-Host "XMING was stopped"
        $success = 0
      }
	}
    1{
#     Write-Host "No"
      Write-Host "DISCUS cannot run if the XMING server is active"
      Write-Host "Please stop XMING or reboot computer to use DISCUS"
      $done = (Read-Host 'Type enter to finish POWERSHELL')
      cd "$HOME"
      $success = 1
    }
  }
#
}
Else{
  $success = 0
}
#
if($success -eq "0") {
  if ($vcxsrv_active )
  {
    Write-Host "XLaunch.exe IS ALREADY  RUNNING"
  }
  else
  {
    Write-Host "XLaunch.exe will be started"
    $W_TEMP = $env:USERPROFILE + "\DISCUS_INSTALLATION\DiscusWSL\config.xlaunch"
    Start-Process "$xlaunchpath" -ArgumentList " -run `"$W_TEMP`""
  }
}
$success
