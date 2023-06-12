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
return $win_ver
