@echo off
set DRIVE=%~d0
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as admin
    %DRIVE%\apps\powershell\pwsh.exe -Command "Set-ExecutionPolicy Unrestricted -Force"
    %DRIVE%\apps\powershell\pwsh.exe -File "%DRIVE%\privacy_shield.ps1"
) else (
    echo Please run this script as administrator
    pause
)