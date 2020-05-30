#
#  bbb_install_suite_Windows10_WSL.ps1
#
#  Installation script for DISCUS_SUITE as WSL within Windows 10
#
#  To enable the Windows Sub System for Linux, open a powder shell 
#  as administrator and type the followin lines:
#
#  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
#
#  You will need to reboot your Computer. 
#
#  After reboot, open the powder shell as administrator and run this script.
#  In the powershell type:
#
#     Set-executionPolicy Unrestricted
#     cd $HOME\Downloads
#     .\bbb_install_suite_Windows10_WSL.ps1
#
################################################################################
#  
cd $HOME
cd Downloads
#
$DISCUS_INST_FOLDER = "C:\Users\DISCUS_INSTALLATION"
$DISCUS_INST_NAME = "DISCUS_INSTALLATION"
mkdir -Force $DISCUS_INST_FOLDER
cd $DISCUS_INST_FOLDER
#
$IS_UBUNTU1804 = $HOME + "\AppData\Local\Microsoft\WindowsApps\Ubuntu1804.exe"
$IS_UBUNTU2004 = $HOME + "\AppData\Local\Microsoft\WindowsApps\Ubuntu2004.exe"
#Write-host $IS_UBUNTU1804
If (-Not (Test-Path $IS_UBUNTU2004 -PathType leaf))
{
  If (-Not (Test-Path $IS_UBUNTU1804 -PathType leaf))
  {
    curl.exe -L -o ubuntu-1804.appx https://aka.ms/wsl-ubuntu-1804
#
    Add-AppxPackage .\ubuntu-1804.appx
    ubuntu1804.exe -c "sudo apt-get update; sudo apt-get upgrade; exit"
  }
  Else
  {
    Write-host "Ubuntu1804 is already installed"
  }
  $UBUNTU_EXE = "ubuntu1804.exe"
}
Else
{
  Write-host "Ubuntu1804 is already installed"
  $UBUNTU_EXE = "ubuntu2004.exe"
}
#
$W_TEMP = $env:USERPROFILE -split "\\"
$W_USER = $W_TEMP[2]

#
# Determine current DISCUS Version on GIThub
#
#write-host "+++++++++++++++++++++++"
$DISCUS_RAW_VERSION = curl.exe "https://github.com/tproffen/DiffuseCode/releases/latest"
$POS = $DISCUS_RAW_VERSION.IndexOf("tag")
$RightPart =$DISCUS_RAW_VERSION.Substring($POS+4)
#write-host " RIGHT PART is : "$RightPart
$POS = $RightPart.IndexOf("""")
$DISCUS_VERSION = $RightPart.Substring(0, $POS)
#write-host "DISCUS_VERSION IS : "$DISCUS_VERSION
$DISCUS_INST_SCRIPT = "https://github.com/tproffen/DiffuseCode/releases/download/" + $DISCUS_VERSION + "/bbb_install_script.sh"
#write-host "DISCUS_INST_SCRIPT URL : " $DISCUS_INST_SCRIPT

curl.exe -L -o bbb_install_script.sh $DISCUS_INST_SCRIPT

$DISCUS_INST_PATH = "/mnt/c/Users/" + $DISCUS_INST_NAME +"/bbb_install_script.sh"

#Write-host " DISCUS_INST_PATH "  $DISCUS_INST_PATH
#ls
#write-host "+++++++++++++++++++++++"

& $UBUNTU_EXE     -c $DISCUS_INST_PATH
#
# Copy DiscusWSL 
#
Write-host " COPY DiscusWsl"
Copy-item -Recurse -Force DiscusWSL\ -Destination "C:\Program Files (x86)\"
#
$SourceFileLocation = "C:\Program Files (x86)\DiscusWSL\discus_suite.bat"
$ShortcutLocation = "C:\Users\" + $W_USER + "\Desktop\DiscusSUITE_WSL.lnk"
write-host "W_USER             " $W_USER
write-host "SourceFileLocation " $SourceFileLocation
write-host "ShortcutLocation   " $ShortcutLocation
$WScriptShell = New-Object -ComObject Wscript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
$Shortcut.TargetPath = $SourceFileLocation
$Shortcut.IconLocation = "C:\Program Files (x86)\DiscusWSL\discus_suite_128.ico"
$Shortcut.Save()
#
#
# Install vcxsrv 
#
$IS_VCXSRV = "C:\Program Files\VcXsrv\xlaunch.exe"
If (-Not (Test-Path $IS_VCXSRV -PathType leaf))
{
  $VCXSRV_INST_SOURCE = "https://github.com/tproffen/DiffuseCode/releases/download/" + $DISCUS_VERSION + "/vcxsrv-64.1.20.8.1.installer.exe"
Write-Host $VCXSRV_INST_SOURCE
  curl.exe -L -o vcxsrv-64.1.20.8.1.installer.exe $VCXSRV_INST_SOURCE
  .\vcxsrv-64.1.20.8.1.installer.exe 
  Write-host "Please wait for the vcxsrv installer to finish"
  Write-Host -NoNewLine 'Once the VcXsrv Installation is finished, press any key to continue...';
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
  Write-Host " "
}
Else
{
  write "VcXsrv is already installed"
}
#
& "C:\Program Files (x86)\DiscusWSL\discus_suite.bat"