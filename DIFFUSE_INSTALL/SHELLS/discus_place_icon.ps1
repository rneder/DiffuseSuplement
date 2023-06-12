#
# discus_place_icon.ps1
#
#  Create a desktop icon for discus_suite
#
###########################################################################################
#
$W_USER_DIR = $env:USERPROFILE
$DISCUS_INST_NAME   = "DISCUS_INSTALLATION"
$DISCUS_INST_FOLDER = "$W_USER_DIR" + "\$DISCUS_INST_NAME"
#
Write-Host " A desktop icon will be placed."
#
$ShortcutLocation=[Environment]::GetFolderPath('DesktopDirectory')+"\DiscusSUITE_WSL.lnk"
$SourceFileLocation = "$DISCUS_INST_FOLDER" + "\DiscusWSL\discus_suite_ps1.bat"
#
#Write-Host "W_USER             " $W_USER
#Write-Host "SourceFileLocation " $SourceFileLocation
#Write-Host "ShortcutLocation   " $ShortcutLocation
$WScriptShell = New-Object -ComObject Wscript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
$Shortcut.TargetPath = $SourceFileLocation
$Shortcut.IconLocation = "$DISCUS_INST_FOLDER" + "\DiscusWSL\discus_suite_128.ico"
$Shortcut.Save()
if (-not $?) {
  Write-Host ""
  Write-Host " The desktop icon was not placed successfully " -ForegroundColor $ColorWarn
  Write-Host " Check the error messages and try to correct"   -ForegroundColor $ColorWarn
  Write-Host ""
  $done = (Read-Host 'Type enter to finish POWERSHELL')
  exit
}
#
