@echo off
REM Restart FreeLLMAPI: stop the running instance (if any), then delegate the
REM one-shot start + dashboard opening to start-freellmapi.cmd in this folder.
REM Works with the autostart task DISABLED (Enable->Run->Disable inside start).
echo Stopping FreeLLMAPI...
schtasks /End /TN FreeLLMAPI >nul 2>&1
%SystemRoot%\System32\timeout.exe /t 2 /nobreak >nul
call "%~dp0start-freellmapi.cmd"
