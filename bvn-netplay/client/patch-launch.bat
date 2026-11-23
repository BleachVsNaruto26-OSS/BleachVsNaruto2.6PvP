@echo off
setlocal
title Patch launch.swf - BVN 2.6 Online 2P

set "GAME_DIR=D:\BleackVsNaruto\bvn2.6sieuvip\bvn2.6sieuvip"
set "TARGET_SWF=%GAME_DIR%\launch.swf"
set "BACKUP_SWF=%GAME_DIR%\launch.original.swf"
set "PATCH_DIR=%~dp0patch_scripts"
set "FFDEC_CLI=C:\Program Files (x86)\FFDec\ffdec-cli.exe"
set "FFDEC_BAT=C:\Program Files (x86)\FFDec\ffdec.bat"

echo ============================================================
echo   BVN 2.6 ONLINE 2P - AUTO PATCHER (JPEXS FFDec)
echo ============================================================

if not exist "%TARGET_SWF%" (
  echo [LOI] Khong tim thay file: %TARGET_SWF%
  pause
  exit /b 1
)

echo [1/3] Tao lai bo script patch tu ma nguon...
node "%~dp0build-patch-scripts.js"
if errorlevel 1 (
  echo [LOI] Khong tao duoc patch_scripts!
  pause
  exit /b 1
)

if not exist "%BACKUP_SWF%" (
  echo [2/3] Sao luu file goc -> launch.original.swf
  copy /Y "%TARGET_SWF%" "%BACKUP_SWF%" >nul
) else (
  echo [2/3] Da co ban sao luu launch.original.swf (giu nguyen ban goc).
)

echo [3/3] Dang nhung 12 script vao launch.swf bang JPEXS FFDec...
if exist "%FFDEC_CLI%" (
  "%FFDEC_CLI%" -importScript "%BACKUP_SWF%" "%TARGET_SWF%" "%PATCH_DIR%"
) else if exist "%FFDEC_BAT%" (
  call "%FFDEC_BAT%" -importScript "%BACKUP_SWF%" "%TARGET_SWF%" "%PATCH_DIR%"
) else (
  echo [LOI] Khong tim thay JPEXS FFDec tai C:\Program Files (x86)\FFDec\
  echo Ban co the mo JPEXS va dan thu cong 10 file trong %PATCH_DIR%
  pause
  exit /b 1
)

if errorlevel 1 (
  echo [LOI] FFDec bao loi khi importScript! File goc van an toan tai launch.original.swf
  pause
  exit /b 1
)

if exist "%~dp0launch.test.swf" del /Q "%~dp0launch.test.swf" >nul 2>&1

echo.
echo ============================================================
echo   HOAN TAT! Da patch xong: %TARGET_SWF%
echo   - Chay server:   D:\BleackVsNaruto\bvn-netplay\server\start-server.bat
echo   - Chay game:     %GAME_DIR%\Bleach vs. Naruto.exe
echo   - Trong Menu:    Bam nut [ONLINE 2P (F2)] o goc tren phai!
echo ============================================================
pause
