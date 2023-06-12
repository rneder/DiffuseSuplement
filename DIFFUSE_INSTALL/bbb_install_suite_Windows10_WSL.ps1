#
#  bbb_install_suite_Windows10_WSL.ps1
#  2022_11_30
#  Installation script for DISCUS_SUITE as WSL within Windows 10 / 11
#
#  To enable the Windows Sub System for Linux, open a powershell or
#  Windows terminal as administrator and type the following lines:
#
#  C:\Windows\System32\wsl -l -v
#  If you get a lengthy help text, WSL is not installed
#  If WSL is installed you get something like:
#  NAME		    STATE   VERSION
# *Ubuntu-20.04 Stopped 2
#
#  If WSL is not installed , please install with:
#  C:\Windows\System32\wsl --install -d Ubuntu
#  You will need to reboot your Computer. 
#
#  After reboot, open the powershell and run this script.
#  In the powershell type:
#
#     Set-executionPolicy Unrestricted
#     cd $HOME\Downloads
#     .\bbb_install_suite_Windows10_WSL.ps1
#
################################################################################
#
#$all = New-Object System.Management.Automation.Host.ChoiceDescription `
#     "&All","The DISCUS icon will be available to All users on this computer."
#$cur = New-Object System.Management.Automation.Host.ChoiceDescription `
#     "&Current","The DISCUS icon will be available just for your own Current account."
$yes = New-Object System.Management.Automation.Host.ChoiceDescription `
     "&Yes","Answering Yes will carry out the action prompted for."
$no  = New-Object System.Management.Automation.Host.ChoiceDescription `
     "&No","Answering No will instruct the shell NOT to carry out the action."
#$cancel = New-Object System.Management.Automation.Host.ChoiceDescription `
#     "&Cancel","Description."
#$YNC_options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $cancel)
$YN_options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
#$DISCUS_ICN = [System.Management.Automation.Host.ChoiceDescription[]]($all, $cur)
#
###########################################################################################
#
# Colors
#
###########################################################################################
$BackgroundColors = (get-host).ui.rawui.BackgroundColor
$ForegroundColors = (get-host).ui.rawui.ForegroundColor
$ColorHigh = $ForegroundColors
$ColorWarn = $ForegroundColors
if( $BackgroundColors -eq "Black") {
  $ColorHigh = "Yellow"
  $ColorWarn = "Red"
}
elseif( $BackgroundColors -eq "White") {
  $ColorHigh = "DarkBlue"
  $ColorWarn = "Red"
}
elseif( $BackgroundColors -eq "Blue") {
  $ColorHigh = "DarkYellow"
  $ColorWarn = "Red"
}
elseif( $BackgroundColors -eq "DarkMagenta") {
  $ColorHigh = "DarkYellow"
  $ColorWarn = "Red"
}
#
###########################################################################################
#
# Test firewall profile settings
#
###########################################################################################
#
function Fw_profile {
  $FW_LISTEN = $false
  $FW_MODIFIED = $false
  $FW_CATEGORY = (Get-NetConnectionProfile).NetworkCategory
#  echo " Category $FWCATEGORY"
  $fw_pr_file="$HOME\AppData\Local\Temp\fw_profile.txt"
  Get-NetFirewallProfile -Profile $FW_CATEGORY  |out-file  -encoding ASCII "$fw_pr_file"
  foreach($line in Get-Content "$fw_pr_file") {
    $comp = $line -replace '\0'
    if($comp.contains("NotifyOnListen")) {
      if($comp.contains("True")) {
      $FW_LISTEN = $true
      }
      Break
     }
  }
  if( -not $FW_LISTEN) {
    Write-Host " " -ForegroundColor $ColorHigh
    Write-Host "Your firewall settings for network type >>$FW_CATEGORY<< will not notify you" -ForegroundColor $ColorHigh
    Write-Host "that the firewall will block a new App" -ForegroundColor $ColorHigh
    Write-Host "VcXsrv and DISCUS will likely be blocked without notification"  -ForegroundColor $ColorHigh
    Write-Host " "
    $title = "This installation script can change the setting to notify you if new Apps are blocked"
    $message = "Shall this script change your firewall settings to notify? "
    $result = $host.ui.PromptForChoice($title, $message, $YN_options, 1)
    switch ($result) {
      0{
        Set-NetFirewallProfile -Profile $FW_CATEGORY -NotifyOnListen True
        $FW_LISTEN = $true
        Write-Host " " -ForegroundColor $ColorHigh
        Write-Host "Your firewall settings for network type >>$FW_CATEGORY<< will now inform you" -ForegroundColor $ColorHigh
        Write-Host "that the firewall will block a new App" -ForegroundColor $ColorHigh
        Write-Host "Once prompted, please make sure that you allow VcXsrv; Ubuntu and DISCUS to run" -ForegroundColor $ColorHigh
        Write-Host "Check Settings and restrictions imposed by any Virus scanner or malware check." -ForegroundColor $ColorHigh
        Write-Host " " -ForegroundColor $ColorHigh
        Write-Host " "
      }
      1{
        Write-Host " " -ForegroundColor $ColorWarn
        Write-Host "VcXsrv and DISCUS will likely be blocked without notification" -ForegroundColor $ColorWarn
        Write-Host "If DISCUS is not started sucessfully at the end of this script" -ForegroundColor $ColorWarn
        Write-Host "Check your firewall settings and restrictions imposed by any " -ForegroundColor $ColorWarn
        Write-Host "Virus scanner or malware check." -ForegroundColor $ColorWarn
        Write-Host " " -ForegroundColor $ColorWarn
        Write-Host " "
      }
    }
  }
#  return $FW_LISTEN, $FW_CATEGORY
}
#
###########################################################################################
#
# Install vcxsrv function 
#
###########################################################################################
#
function Vcxsrv-Installation {
$IS_VCXSRV = "C:\Program Files\VcXsrv\xlaunch.exe"
If (-Not (Test-Path $IS_VCXSRV -PathType leaf)) {
  & C:\Windows\System32\curl.exe -k -o vcxsrv_installer.exe -L 'https://sourceforge.net/projects/vcxsrv/files/latest/download/vcxsrv-*.installer.exe'
  Write-Host "Please follow VcXSrv installation instructions "
  Write-Host " "
  .\vcxsrv_installer.exe 
  Write-Host " "
  Write-host "Please wait for the vcxsrv installer to finish"
  Write-Host -NoNewLine 'Once the VcXsrv Installation is finished, press any key to continue...';
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
  Write-Host " "
 }
Else {
  Write-Host ""  
  write "VcXsrv is already installed"
  Write-Host ""  
 }
}
#
###########################################################################################
#
# Test Internet connection function
#
###########################################################################################
#
function TestNet {
  $IP_ACCESS = $false
  $GIT_ACCESS = $false
  $GIT_SITE = "github.com"
  C:\Windows\System32\curl.exe --silent -s -f $GIT_SITE
  if ($?) {
    $IP_ACCESS = $true
      C:\Windows\System32\curl.exe --silent -s -f $GIT_SITE
      if ($?) {
      $GIT_ACCESS = $true
    }
    else {
        C:\Windows\System32\curl.exe --silent -s -f 140.82.121.4
		if ($?) {
        $GIT_ACCESS = $true
        $GIT_SITE = "140.82.121.4"
        Write-Host " "
        Write-Host "The internet connection with curl works for 140.82.121.4"
        Write-Host "but fails for github.com"
        Write-Host "Please check your network settings and ensure"
        Write-Host "that your powershell can access web pages like"
        Write-Host "github.com"
        Write-Host "Check Firewall setting for powershell"
        Write-Host "Check the DomainNameServer setting"
        Write-Host "The installation will proceed with the IP address"
        Write-Host "140.82.121.4 for github.com"
        Write-Host " "
        $done = (Read-Host 'Type enter to continue the DISCUS installation')
      }
      else {
        $GIT_ACCESS = $false
        Write-Host " "
        Write-Host "The internet connection with curl does not seem to work"
        Write-Host "Please check your network settings and ensure"
        Write-Host "that your powershell can access web pages like"
        Write-Host "github.com"
        Write-Host "Use tests like:"
        Write-Host "C:\Windows\System32\curl.exe 140.82.121.4"
        Write-Host "C:\Windows\System32\curl.exe github.com  "
        Write-Host " "
      }
    }
  }
  else {
    $IP_ACCESS = $false
    Write-Host " "
    Write-Host "The internet connection with curl does not seem to work"
    Write-Host "Please check your network settings and ensure"
    Write-Host "that your powershell can access web pages like"
    Write-Host "github.com"
    Write-Host "Use tests like:"
    Write-Host "C:\Windows\System32\curl.exe 140.82.121.4"
    Write-Host "C:\Windows\System32\curl.exe github.com  "
    Write-Host " "
  }
#
#  Write-Host " IP ACCESS  is $IP_ACCESS"
#  Write-Host " GIT ACCESS is $GIT_ACCESS"
#  Write-Host " GIT SITE is $GIT_SITE"
  $GIT_ACCESS
  $GIT_SITE
}
#
$NETOK = TestNet
if(-Not $NETOK[0]) {
   $done = (Read-Host 'Type enter to finish POWERSHELL')
   exit 
}
$GIT_SITE = $NETOK[1]
#
###########################################################################################
#
# Test Windows version
#
###########################################################################################
#
$is_win_file="$HOME\DISCUS_INSTALLATION\discus_win_ver.txt"
If(Test-Path "$is_win_file"){
  foreach($line in Get-Content "$is_win_file") {
    $win_ver = $line -replace '\0'
    write-host " COMP $comp  $win_ver"
  }
}
Else{
  $comp = (get-ComputerInfo | Select-Object -expand OsName) -match 11
  If($comp) {
    $win_ver = 11
  }
  Else {
    $win_ver = 10
  }
  Echo $win_ver | Out-File -Encoding ASCII -File $is_win_file
}
#
#
###########################################################################################
#
# Test if this powershell instance has Admin rights
#
###########################################################################################
#
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Host "This powershell has administrator rights"
  $IS_ELEVATED_SHELL = $true
#  Fw_profile
#  Vcxsrv-Installation
 }
else {
  Write-Host "This powershell has no admin rights"
  $IS_ELEVATED_SHELL = $false
 }
#
###########################################################################################
#
# Test if User has Admin rights
#
###########################################################################################
#
$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$p  = New-Object System.Security.Principal.WindowsPrincipal($id)
if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)){ 
  Write-Host "User has Admin rights " $true 
  $IS_ELEVATED_USER = $true
 }     
else { 
  Write-Host "User has no Admin rights " $false
  $IS_ELEVATED_USER = $false
 }
#
###########################################################################################
#
#  Test if wsl -l -v contains words "NAME VERSION STATE"
#  If yes assume wsl is installed
#  If wsl is installed, check the following lines for "Ubuntu"
#
###########################################################################################
#
$is_wsl_file="$HOME\AppData\Local\Temp\is_wsl.txt"
$wsl_installed = $false
$wsl_ubuntu    = $false
$is_wsl = C:\Windows\System32\wsl -l -v 2>&1 |out-file  -encoding ASCII "$is_wsl_file" 
foreach($line in Get-Content "$is_wsl_file") {
  $comp = $line -replace '\0'
  if($comp.contains("NAME") -and $comp.contains("VERSION") -and $comp.contains("STATE")) {
    Write-Host "NAME and VERSION and STATE "
    Write-Host "WSL is installed test if Ubuntu"
    $wsl_installed = $true
   }
  if($wsl_installed) {
    if($comp.contains("Ubuntu")) {
      Write-Host "An Ubuntu is installed, checking version"
      $wsl_ubuntu = $true
	  Break
	 }
   }
 }
#
###########################################################################################
#
#  At this point we know:
#    if wsl is installed or not ($wsl_installed)
#    if an ubuntu is installed  ($wsl_ubuntu)
#
###########################################################################################
#
Write-Host "WSL_INSTALLED " $wsl_installed " " $wsl_ubuntu
if(-not $wsl_installed) {
  Write-Host "WSL is not installed"
  if($IS_ELEVATED_SHELL) {
    Write-Host "Elevated SHELL " $IS_ELEVATED_SHELL
    $title = "WSL is not enabled" 
    $message = "OK to install now ?"
    $result = $host.ui.PromptForChoice($title, $message, $YN_options, 1)
    switch ($result) {
      0{
        Write-Host "Yes"
        Write-Host "Once WSL Ubuntu installation is finished"
        Write-Host "Ubuntu will be launched. "
        Write-Host "Please provide a user name and a password."
        Write-Host "Exit the Ubuntu terminal and reboot computer."
        Write-Host "Go back to the Downloads folder "
        Write-Host "and run the installation script: bbb_install_suite_Windows10_WSL.bat  again"
        C:\Windows\System32\wsl --install -d Ubuntu
        Write-Host " "
        Write-Host "Once the initial Ubuntu setup is done, admin rights are no longer needed"
        Write-Host " "
        Exit
       }
      1{
        Write-Host "No"
        Write-Host "DISCUS needs wsl"
        Write-Host "Install wsl manually or ask admin to install wsl"
        Exit
       }
    }
  }
  else {
    Write-Host "Normal SHELL " $IS_ELEVATED_SHELL
    if($IS_ELEVATED_USER) {
       Write-Host "Elevated USER " $IS_ELEVATED_USER
       Write-Host "DISCUS needs wsl"
       Write-Host "Install wsl manually: C:\Windows\System32\wsl --install -d Ubuntu"
       Write-Host "or start powershell with admin rights and "
       Write-Host "run this script :  bbb_install_suite_Windows10_WSL.bat    again "
       Write-Host "from the users Download folder"
       Exit
    }
    else {
    Write-Host "Normal USER " $IS_ELEVATED_USER
       Write-Host "DISCUS needs wsl"
       Write-Host "Please ask your admin to install C:\Windows\System32\wsl for your account:"
       Write-Host "Your Admin should temporarily make your user account an admin"
       Write-Host "While in this elevated state your admin should please:"
       Write-Host "Install wsl manually: C:\Windows\System32\wsl --install -d Ubuntu"
       Write-Host "or start powershell with admin rights and "
       Write-Host "run this script :  bbb_install_suite_Windows10_WSL.bat    again"
       Write-Host "from the users Download folder"
       Write-Host "Once the wsl installation is complete admin rights are no longer needed"
       Write-Host " "
       Exit
    }
  }
} 
elseif($wsl_installed) {
  Write-Host "WSL is installed"
}
else {
  Write-Host "ELSE BLOCK " $wsl_installed
}
Write-Host "After test for WSL "
#
###########################################################################################
#
# At this point wsl will have been installed
# Check for Ubuntu version 
#
###########################################################################################
#
$is_wsl_file="$HOME\AppData\Local\Temp\is_wsl.txt"
$is_ubu_file="$HOME\AppData\Local\Temp\is_ubuntu.txt"
$is_wsl = C:\Windows\System32\wsl -l -v 2>&1 |out-file  -encoding ASCII "$is_wsl_file" 
if($wsl_ubuntu) {
  foreach($line in Get-Content "$is_wsl_file") {
    $comp = $line -replace '\0'
    If($comp.contains("Ubuntu ")) {
      $IS_UBUNTU     = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu.exe"
      If (Test-Path $IS_UBUNTU -PathType leaf) {
        $UBUNTU_EXE = "$IS_UBUNTU"
        "0000" | out-file  -encoding ASCII "$is_ubu_file"
      }
    }
    Elseif($comp.contains("Ubuntu-22.04 ")) {
      $IS_UBUNTU2204 = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu2204.exe"
      If (Test-Path $IS_UBUNTU2204 -PathType leaf) {
        $UBUNTU_EXE = "$IS_UBUNTU2204"
        "2204" | out-file  -encoding ASCII "$is_ubu_file"
      }
    }
    Elseif($comp.contains("Ubuntu-20.04 ")) {
      $IS_UBUNTU2004 = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu2004.exe"
      If (Test-Path $IS_UBUNTU2004 -PathType leaf) {
        $UBUNTU_EXE = "$IS_UBUNTU2004"
        "2004" | out-file  -encoding ASCII "$is_ubu_file"
        Write-Host " "
        Write-Host "You have explicitely installed Ubuntu-2004 "
        Write-Host "Usually this cannot be upgraded to the latest version 2204"
        Write-Host "If you do not use WSL for anything besides DISCUS I reccomend to: "
        Write-Host "Uninstall (all) Ubuntu versions in Windows Settings/ Apps / Apps and features"
        Write-Host "Thereafter run this script again or install Ubuntu from the Windows Store "
        Write-Host " "
        Write-Host " "
        $title = "You use an old Ubuntu version " 
        $message = "Proceed with DISCUS installation nevertheless ?"
        $result = $host.ui.PromptForChoice($title, $message, $YN_options, 1)
        switch ($result) {
          0{
            Write-Host "Yes"
            Write-Host "DISCUS Installation will proceed with Ubuntu-2004"
            Write-Host " "
		   }
          1{
            Write-Host "No"
            Write-Host "DISCUS Installation has been cancelled"
            Write-Host "Run this script again once the Ubuntu installation is ready"
            Write-Host " "
            Exit
           }
        }
      }
    }
    Elseif($comp.contains("Ubuntu-18.04 ")) {
      $IS_UBUNTU1804 = "$HOME" + "\AppData\Local\Microsoft\WindowsApps\ubuntu1804.exe"
      If (Test-Path $IS_UBUNTU1804 -PathType leaf) {
        $UBUNTU_EXE = "$IS_UBUNTU1804"
        "1804" | out-file  -encoding ASCII "$is_ubu_file"
        Write-Host " "
        Write-Host "You have explicitely installed Ubuntu-1804 "
        Write-Host "Usually this cannot be upgraded to the latest version 2204"
        Write-Host "Support for this version will end in 2023!"
        Write-Host "If you do not use WSL for anything besides DISCUS I reccomend to: "
        Write-Host "Uninstall (all) Ubuntu versions in Windows Settings/ Apps / Apps and features"
        Write-Host "Thereafter run this script again or install Ubuntu from the Windows Store "
        Write-Host " "
        Write-Host " "
        $title = "You use a very old Ubuntu version " 
        $message = "Proceed with DISCUS installation nevertheless ?"
        $result = $host.ui.PromptForChoice($title, $message, $YN_options, 1)
        switch ($result) {
          0{
            Write-Host "Yes"
            Write-Host "DISCUS Installation will proceed with Ubuntu-1804"
            Write-Host " "
		   }
          1{
            Write-Host "No"
            Write-Host "DISCUS Installation has been cancelled"
            Write-Host "Run this script again once the Ubuntu installation is ready"
            Write-Host " "
            Exit
           }
        }
      }
    }
  }
}
Else{
  Write-host "No Ubuntu is installed and no automatic"
  Write-Host "installation is provided for your WSL version"
  Write-Host "Use the instructions for a manual"
  Write-Host "installation found in the DISCUS installation guide "
  Exit
}
Write-Host " UBUNTU EXE : " $UBUNTU_EXE
#
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
$wsl_ver
################################################################################
if($IS_ELEVATED_SHELL) {
  if($wsl_ver -eq "1" -Or $win_ver -eq "10") {
    Fw_profile
    Vcxsrv-Installation   
  }
  ELSE{
    Write-Host " No need for VCXsrv"
  }
}
#
$W_TEMP = $env:USERPROFILE -split "\\"
$W_USER = $W_TEMP[2]
$W_USER_DIR = $env:USERPROFILE
#
#
$DISCUS_INST_NAME   = "DISCUS_INSTALLATION"
$DISCUS_INST_FOLDER = "$W_USER_DIR" + "\$DISCUS_INST_NAME"
$DISCUS_WSL_FOLDER = "$W_USER_DIR"  + "\$DISCUS_INST_NAME" + "\DiscusWSL"
#Write-Host "DISCUS_INST_NAME   " $DISCUS_INST_NAME
#Write-Host "DISCUS_INST_FOLDER " $DISCUS_INST_FOLDER
#Write-Host "DISCUS_WSL_FOLDER  " $DISCUS_WSL_FOLDER
#
mkdir -Force "$DISCUS_INST_FOLDER" 
mkdir -Force "$DISCUS_WSL_FOLDER"
cd "$DISCUS_INST_FOLDER"
#
# Determine current DISCUS Version on GIThub
#
#Write-Host "+++++++++++++++++++++++"
$DISCUS_RAW_SITE = "https://" + $GIT_SITE + "/tproffen/DiffuseCode/releases/latest"
Write-Host "DISCUS_RAW_SITE " $DISCUS_RAW_SITE
$DISCUS_RAW_VERSION = C:\Windows\System32\curl.exe -k --silent --location  $DISCUS_RAW_SITE | Select-String "Release" | Out-String
#Write-Host "DISCUS_RAW_SITE " $DISCUS_RAW_VERSION
#
$pos_v = $DISCUS_RAW_VERSION.IndexOf("v.6")
$cut_v = $DISCUS_RAW_VERSION.Substring($pos_v)
$pos_s = $cut_v.IndexOf(" ")
$DISCUS_VERSION = $cut_v.Substring(0, $pos_s)
#Write-Host "DISCUS_VERSION IS : "$DISCUS_VERSION
$DISCUS_INST_SCRIPT = "https://" + $GIT_SITE + "/tproffen/DiffuseCode/releases/download/" + $DISCUS_VERSION + "/bbb_install_script.sh"
Write-Host "Downloading DISCUS_INST_SCRIPT URL : " $DISCUS_INST_SCRIPT
IF(Test-Path .\bbb_install_script -PathType leaf ) {
  Remove-Item .\bbb_install_script
}
C:\Windows\System32\curl.exe -k -L -o bbb_install_script.sh $DISCUS_INST_SCRIPT

$DISCUS_INST_PATH = "`"'/mnt/c/Users/" + "$W_USER" + "/$DISCUS_INST_NAME/bbb_install_script.sh' started=powershell `""
#Write-Host " DISCUS_INST_PATH "  $DISCUS_INST_PATH
#ls
#Write-Host "+++++++++++++++++++++++"
Write-Host "Starting Ubuntu part of the installation"

& $UBUNTU_EXE     -c $DISCUS_INST_PATH
#
if (-not $?) {
  Write-Host ""
  Write-Host " The DISCUS installation failed"                -ForegroundColor $ColorWarn
  Write-Host " Check the error messages and try to correct"   -ForegroundColor $ColorWarn
  Write-Host ""
  $done = (Read-Host 'Type enter to finish POWERSHELL')
  exit
}
#
#
& "$SourceFileLocation"
#
#$done = (Read-Host 'Type enter to finish POWERSHELL')
