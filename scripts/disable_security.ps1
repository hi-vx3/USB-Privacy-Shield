$ErrorActionPreference = "SilentlyContinue"
$log_file = Join-Path -Path (Split-Path -Path $drive_root -Parent) -ChildPath "logs\activity.log"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $log_file -Value "[$timestamp] $Message"
}

# Disable Windows Defender
Set-MpPreference -DisableRealtimeMonitoring $true
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
Write-Log "Disabled Windows Defender"

# Disable Windows Updates
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1
Stop-Service -Name wuauserv -Force
Set-Service -Name wuauserv -StartupType Disabled
Write-Log "Disabled Windows Updates"