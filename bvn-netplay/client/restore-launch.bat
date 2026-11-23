@echo off
setlocal
set "GAME_DIR=D:\BleackVsNaruto\bvn2.6sieuvip\bvn2.6sieuvip"
set "TARGET_SWF=%GAME_DIR%\launch.swf"
set "BACKUP_SWF=%GAME_DIR%\launch.original.swf"

if not exist "%BACKUP_SWF%" (
  echo [LOI] Khong tim thay ban sao luu: %BACKUP_SWF%
  pause
  exit /b 1
)

copy /Y "%BACKUP_SWF%" "%TARGET_SWF%" >nul
echo [OK] Da khoi phuc launch.swf goc thanh cong!
pause
