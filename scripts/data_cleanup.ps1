$ErrorActionPreference = "SilentlyContinue"
$log_file = Join-Path -Path (Split-Path -Path $drive_root -Parent) -ChildPath "logs\activity.log"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $log_file -Value "[$timestamp] $Message"
}

# Clear Event Logs
Get-EventLog -LogName * | ForEach-Object { Clear-EventLog -LogName $_.Log }
Write-Log "Cleared event logs"

# Delete temporary files
Remove-Item -Path "$env:TEMP\*" -Recurse -Force
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force
Write-Log "Deleted temporary files"

# Clear recent files and jump lists
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Recurse -Force
Write-Log "Cleared recent files and jump lists"