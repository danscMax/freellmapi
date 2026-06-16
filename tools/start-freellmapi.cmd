@echo off
setlocal
REM Start FreeLLMAPI on demand and open the dashboard.
REM The autostart task stays DISABLED: we enable it only for the one-shot
REM /Run and immediately disable it again (running instance keeps going).

REM Already running? Just open the dashboard.
netstat -ano | findstr ":3001" | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 goto open

echo Starting FreeLLMAPI (one-shot, autostart stays off)...
schtasks /Change /TN FreeLLMAPI /Enable >nul
schtasks /Run /TN FreeLLMAPI >nul
schtasks /Change /TN FreeLLMAPI /Disable >nul

REM Wait for the server to come up (max ~15 s)
set /a tries=0
:wait
set /a tries+=1
%SystemRoot%\System32\timeout.exe /t 1 /nobreak >nul
netstat -ano | findstr ":3001" | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 goto open
if %tries% lss 15 goto wait

echo.
echo FreeLLMAPI did not come up on port 3001 within 15 s.
echo Check: schtasks /Query /TN FreeLLMAPI /V /FO LIST
pause
exit /b 1

:open
echo Opening dashboard...
start "" http://localhost:3001
exit /b 0
