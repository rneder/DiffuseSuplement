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
$UBUNTU_EXE