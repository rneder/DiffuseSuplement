#
#  discus_create_startup.ps1
#
#  Copy discus_startup.bat  into Startup folder
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
$wsl_use = & "$DISCUS_INST_FOLDER\get_wsl_ver.ps1"
$win_ver = & "$DISCUS_INST_FOLDER\get_win_ver.ps1"
#
#
Write-Host "                                                                                "  -ForegroundColor $ColorHigh
Write-Host "                                                                                "  -ForegroundColor $ColorHigh
Write-Host "On some windows system the very first start of DISCUS can be extremly slow after" -ForegroundColor $ColorHigh
Write-Host "a reboot of the computer. To avoid this long wait, a startup script is available"  -ForegroundColor $ColorHigh
Write-Host "that will start DISCUS during the login procedure on your computer and basically"  -ForegroundColor $ColorHigh
Write-Host "run in the background. A first DISCUS window will appear and will automatically "  -ForegroundColor $ColorHigh
Write-Host "be closed.                                                                      "  -ForegroundColor $ColorHigh
Write-Host "Thereafter new DISCUS windows will start much faster.                           "  -ForegroundColor $ColorHigh
Write-Host "At Windows 10 or WSL version 1 the DISCUS X-window server (VcXserver) will      "  -ForegroundColor $ColorHigh
Write-Host "collide with the RMCprofile X-Window server (xming). If you use RMCprofile the  "  -ForegroundColor $ColorHigh
Write-Host "startup procedure should only be installed for Windows 11 in combination with   "  -ForegroundColor $ColorHigh
Write-Host "WSL 2, as DISCUS does not need a separate X-window server for this combination  "  -ForegroundColor $ColorHigh
Write-Host "Your operation system / WSL version is Windows: " $win_ver " WSL Version: " $wsl_use -ForegroundColor $ColorHigh
Write-Host "                                                                                "  -ForegroundColor $ColorHigh
Write-Host "                                                                                "  -ForegroundColor $ColorHigh
$title = "This installation script can create the startup batch file "
$message = "Shall this script copy the startup batch file into the Windows startup folder ?  "
$result = $host.ui.PromptForChoice($title, $message, $YN_options, 1)
switch ($result) {
  0{
    $is_start = Test-Path -Path "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    if(-Not $is_start) {
       New-Item -Path "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -ItemType "directory"
       
    }
    copy DiscusWSL\discus_startup.bat "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
  }
}
#
