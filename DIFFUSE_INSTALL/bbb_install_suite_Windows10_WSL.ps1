#
#  bbb_install_suite_Windows10_WSL.ps1
#  2022_05_05
#  Installation script for DISCUS_SUITE as WSL within Windows 10
#
#  To enable the Windows Sub System for Linux, open a powder shell 
#  as administrator and type the followin lines:
#
#  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
#  You will need to reboot your Computer. 
#
#  After reboot, open the power shell as administrator and run this script.
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
    curl.exe -L -o ubuntu-2004.appx https://aka.ms/wslubuntu2004
#
    Add-AppxPackage .\ubuntu-2004.appx
    ubuntu2004.exe -c "sudo apt-get update; sudo apt-get upgrade; exit"
    $UBUNTU_EXE = "ubuntu2004.exe"
  }
  Else
  {
    $UBUNTU_EXE = "ubuntu1804.exe"
    Write-host "Ubuntu1804 is already installed"
    Write-host "Best consider an upgrade to Ubuntu2004"
    Write-host "Both distributions can be used in parallel"
    Write-host "Best make a backup of user data from Ubuntu1804 first"
    Write-host "As usual, the first installation of Ubuntu2004 takes time"
    do { $UbuntuUpgrade = (Read-Host 'Upgrade to Ubuntu2004? (Y/N)').ToLower() } while ($UbuntuUpgrade -notin @('y','n'))
    if ($UbuntuUpgrade -eq 'y') {
      curl.exe -L -o ubuntu-2004.appx https://aka.ms/wslubuntu2004
#
      Add-AppxPackage .\ubuntu-2004.appx
      ubuntu2004.exe -c "sudo apt-get update; sudo apt-get upgrade; exit"
      $UBUNTU_EXE = "ubuntu2004.exe"
    }
  }
}
Else
{
  Write-host "Ubuntu2004 is already installed"
  $UBUNTU_EXE = "ubuntu2004.exe"
}
#
$W_TEMP = $env:USERPROFILE -split "\\"
$W_USER = $W_TEMP[2]

#
# Determine current DISCUS Version on GIThub
#
#write-host "+++++++++++++++++++++++"
$DISCUS_RAW_VERSION = curl.exe --silent --location "https://github.com/tproffen/DiffuseCode/releases/latest" | Select-String "Release"
$DISCUS_VERSION = ($DISCUS_RAW_VERSION -split ' ')[3]
#$POS = $DISCUS_RAW_VERSION.IndexOf("tag")
#$RightPart =$DISCUS_RAW_VERSION.Substring($POS+4)
#write-host " RIGHT PART is : "$RightPart
#$POS = $RightPart.IndexOf("""")
#$DISCUS_VERSION = $RightPart.Substring(0, $POS)
write-host "DISCUS_VERSION IS : "$DISCUS_VERSION
$DISCUS_INST_SCRIPT = "https://github.com/tproffen/DiffuseCode/releases/download/" + $DISCUS_VERSION + "/bbb_install_script.sh"
write-host "DISCUS_INST_SCRIPT URL : " $DISCUS_INST_SCRIPT

curl.exe -L -o bbb_install_script.sh $DISCUS_INST_SCRIPT

$DISCUS_INST_PATH = "/mnt/c/Users/" + $DISCUS_INST_NAME +"/bbb_install_script.sh started=powershell"

Write-host " DISCUS_INST_PATH "  $DISCUS_INST_PATH
ls
write-host "+++++++++++++++++++++++"

& $UBUNTU_EXE     -c $DISCUS_INST_PATH
#
# Copy DiscusWSL 
#
Write-host " COPY DiscusWsl"
Copy-item -Recurse -Force DiscusWSL\ -Destination "C:\Program Files (x86)\"
#
$SourceFileLocation = "C:\Program Files (x86)\DiscusWSL\discus_suite_ps1.bat"
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
  curl.exe -o vcxsrv_installer.exe -L 'https://sourceforge.net/projects/vcxsrv/files/latest/download/vcxsrv-*.installer.exe'
  .\vcxsrv_installer.exe 
#  $VCXSRV_INST_SOURCE = "https://github.com/tproffen/DiffuseCode/releases/download/" + $DISCUS_VERSION + "/vcxsrv-64.1.20.8.1.installer.exe"
#Write-Host $VCXSRV_INST_SOURCE
#  curl.exe -L -o vcxsrv-64.1.20.8.1.installer.exe $VCXSRV_INST_SOURCE
#  .\vcxsrv-64.1.20.8.1.installer.exe 
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
& "C:\Program Files (x86)\DiscusWSL\discus_suite_ps1.bat"
