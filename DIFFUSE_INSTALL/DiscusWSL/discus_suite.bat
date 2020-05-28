REM DISCUS_SUITE VIA UBUNTU
tasklist.exe | findstr "vcxsrv.exe" 
if errorlevel 1 (
REM   echo START XLaunch via config.xlaunch
   "C:\Program Files\vcxsrv\xlaunch.exe" -run "C:\Program Files (X86)\DiscusWSL\config.xlaunch"
) ELSE (
   ECHO XLaunch.exe IS ALREADY  RUNNING 
)
REM config.xlaunch
REM ubuntu1804 -c "export DISPLAY=:0;xterm"
REM wsl  "pwd; echo $HOME; echo $PATH"
REM wsl  "bash -c source $HOME/.profile.local; echo $PATH; discus_suite_ubuntu.sh"

start /MIN ubuntu1804 -c "source $HOME/.profile.local; discus_suite_ubuntu.sh"

