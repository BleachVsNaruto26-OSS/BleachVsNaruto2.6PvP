@echo off
title BVN 2.6 Netplay Server
cd /d "%~dp0"
node server.js --port 9000
pause
