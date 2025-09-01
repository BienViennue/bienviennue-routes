@echo off
REM --- generate-index.cmd ---
powershell -ExecutionPolicy Bypass -File "%~dp0generate-index.ps1"
if %ERRORLEVEL% EQU 0 (
  echo Klaar. index.html is bijgewerkt.
) else (
  echo Er is een fout opgetreden bij het genereren van index.html.
)
pause
