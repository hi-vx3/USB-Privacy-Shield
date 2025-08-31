$ErrorActionPreference = "SilentlyContinue"
$log_file = Join-Path -Path (Split-Path -Path $drive_root -Parent) -ChildPath "logs\activity.log"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $log_file -Value "[$timestamp] $Message"
}

# Disable background apps
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
Get-AppxPackage | Where-Object { $_.NonRemovable -eq $false } | ForEach-Object {
    Stop-Process -Name $_.Name -Force -ErrorAction SilentlyContinue
}
Write-Log "Disabled background apps"