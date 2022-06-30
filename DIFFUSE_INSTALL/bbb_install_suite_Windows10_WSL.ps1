#
#  bbb_install_suite_Windows10_WSL.ps1
#  2022_06_30
#  Installation script for DISCUS_SUITE as WSL within Windows 10 / 11
#
#  To enable the Windows Sub System for Linux, open a powershelA or
#  Windows terminal as administrator and type the following lines:
#
#  wsl -l -v
#  If you get a lengthy help text, WSL is not installed
#  If WSL is installed you get something like:
#  NAME		    STATE   VERSION
# *Ubuntu-20.04 Stopped 2
#
#  If WSL is not installed , please install with:
#  wsl --install -d Ubuntu
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
# Install vcxsrv function 
#
function Vcxsrv-Installation {
$IS_VCXSRV = "C:\Program Files\VcXsrv\xlaunch.exe"
If (-Not (Test-Path $IS_VCXSRV -PathType leaf)) {
  curl.exe -k -o vcxsrv_installer.exe -L 'https://sourceforge.net/projects/vcxsrv/files/latest/download/vcxsrv-*.installer.exe'
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
#
# Test if this powershell instance has Admin rights
#
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Host "This powershell has administrator rights"
  $IS_ELEVATED_SHELL = $true
  Vcxsrv-Installation
 }
else {
  Write-Host "This powershell has no admin rights"
  $IS_ELEVATED_SHELL = $false
 }
#
# Test if User has Admin rights
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
#  Test if wsl -l -v contains words "NAME VERSION STATE"
#  If yes assume wsl is installed
#  If wsl is installed, check the following lines for "Ubuntu"
#
$is_wsl_file="$HOME\AppData\Local\Temp\is_wsl.txt"
$wsl_installed = $false
$wsl_ubuntu    = $false
$is_wsl = wsl -l -v 2>&1 |out-file  -encoding ASCII "$is_wsl_file" 
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
#  At this point we know:
#    if wsl is installed or not ($wsl_installed)
#    if an ubuntu is installed  ($wsl_ubuntu)
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
        wsl --install -d Ubuntu
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
       Write-Host "Install wsl manually: wsl --install -d Ubuntu"
       Write-Host "or start powershell with admin rights and "
       Write-Host "run this script :  bbb_install_suite_Windows10_WSL.bat    again "
       Write-Host "from the users Download folder"
       Exit
    }
    else {
    Write-Host "Normal USER " $IS_ELEVATED_USER
       Write-Host "DISCUS needs wsl"
       Write-Host "Please ask your admin to install wsl for your account:"
       Write-Host "Your Admin should temporarily make your user account an admin"
	   Write-Host "While in this elevated state your admin should please:"
       Write-Host "Install wsl manually: wsl --install -d Ubuntu"
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
#Write-Host "After test for WSL "
#
# At this point wsl will have been installed
# Check for Ubuntu version 
#
$is_wsl_file="$HOME\AppData\Local\Temp\is_wsl.txt"
$is_wsl = wsl -l -v 2>&1 |out-file  -encoding ASCII "$is_wsl_file" 
if($wsl_ubuntu) {
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
      If (Test-Path $IS_UBUNTU2004 -PathType leaf) {
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
$DISCUS_RAW_VERSION = curl.exe -k --silent --location "https://github.com/tproffen/DiffuseCode/releases/latest" | Select-String "Release" | Out-String
$pos_v = $DISCUS_RAW_VERSION.IndexOf("v.6")
$cut_v = $DISCUS_RAW_VERSION.Substring($pos_v)
$pos_s = $cut_v.IndexOf(" ")
$DISCUS_VERSION = $cut_v.Substring(0, $pos_s)
#Write-Host "DISCUS_VERSION IS : "$DISCUS_VERSION
$DISCUS_INST_SCRIPT = "https://github.com/tproffen/DiffuseCode/releases/download/" + $DISCUS_VERSION + "/bbb_install_script.sh"
#Write-Host "DISCUS_INST_SCRIPT URL : " $DISCUS_INST_SCRIPT

curl.exe -k -L -o bbb_install_script.sh $DISCUS_INST_SCRIPT

$DISCUS_INST_PATH = "`"'/mnt/c/Users/" + "$W_USER" + "/$DISCUS_INST_NAME/bbb_install_script.sh' started=powershell `""

#Write-Host " DISCUS_INST_PATH "  $DISCUS_INST_PATH
#ls
#Write-Host "+++++++++++++++++++++++"


& $UBUNTU_EXE     -c $DISCUS_INST_PATH
#
#
Write-Host " A desktop icon will be placed."
#
$ShortcutLocation=[Environment]::GetFolderPath('DesktopDirectory')+"\DiscusSUITE_WSL.lnk"
$SourceFileLocation = "$DISCUS_INST_FOLDER" + "\DiscusWSL\discus_suite_ps1.bat"
#
Write-Host "W_USER             " $W_USER
Write-Host "SourceFileLocation " $SourceFileLocation
Write-Host "ShortcutLocation   " $ShortcutLocation
$WScriptShell = New-Object -ComObject Wscript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
$Shortcut.TargetPath = $SourceFileLocation
$Shortcut.IconLocation = "C:\Program Files (x86)\DiscusWSL\discus_suite_128.ico"
$Shortcut.Save()
#
& "$SourceFileLocation"
