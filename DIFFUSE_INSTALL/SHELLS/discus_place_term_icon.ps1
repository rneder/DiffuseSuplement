#
#  discus_place_term_icon.ps1
#
#  Create a desktop icon for a terminal
#
###########################################################################################
#
#  Create Y/N choice
#
###########################################################################################
#
$yes = New-Object System.Management.Automation.Host.ChoiceDescription `
     "&Yes","Answering Yes will carry out the action prompted for."
$no  = New-Object System.Management.Automation.Host.ChoiceDescription `
     "&No","Answering No will instruct the shell NOT to carry out the action."
$YN_options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
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
$W_USER_DIR = $env:USERPROFILE
$DISCUS_INST_NAME   = "DISCUS_INSTALLATION"
$DISCUS_INST_FOLDER = "$W_USER_DIR" + "\$DISCUS_INST_NAME"
#
#
Write-Host "                                                                                "
Write-Host "                                                                                "
Write-Host "A desktop icon that allows direct access to your linux distribution is available"  -ForegroundColor $ColorHigh
Write-Host "This icon will open a Linux terminal at which you have access to the files and  "  -ForegroundColor $ColorHigh
Write-Host "programs of the linux distribution                                              "  -ForegroundColor $ColorHigh
Write-Host "                                                                                "
Write-Host "                                                                                "
$title = "This installation script can create this dektop icon "
$message = "Shall this script place the desktop icon ?  "
$result = $host.ui.PromptForChoice($title, $message, $YN_options, 1)
switch ($result) {
  0{
    $ShortcutLocation=[Environment]::GetFolderPath('DesktopDirectory')+"\DiscusTERMINAL_WSL.lnk"
    $SourceFileLocation = "$DISCUS_INST_FOLDER" + "\DiscusWSL\discus_terminal_ps1.bat"
##
#    Write-Host "W_USER             " $W_USER
#    Write-Host "SourceFileLocation " $SourceFileLocation
#    Write-Host "ShortcutLocation   " $ShortcutLocation
    $WScriptShell = New-Object -ComObject Wscript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation)
    $Shortcut.TargetPath = $SourceFileLocation
    $Shortcut.IconLocation = "$DISCUS_INST_FOLDER" + "\DiscusWSL\discus_terminal.ico"
    $Shortcut.Save()
    if (-not $?) {
      Write-Host ""
      Write-Host " The terminal desktop icon was not placed successfully "
      Write-Host " Check the error messages and try to correct"
      Write-Host ""
      $done = (Read-Host 'Type enter to finish POWERSHELL')
      exit
    }
  }
  1{
    Write-Host ""
    Write-Host " The terminal desktop icon will not be placed."
    Write-Host ""
  }
}
##
