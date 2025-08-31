$ErrorActionPreference = "SilentlyContinue"
$log_file = Join-Path -Path (Split-Path -Path $drive_root -Parent) -ChildPath "logs\activity.log"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $log_file -Value "[$timestamp] $Message"
}

function Manage-Ports {
    while ($true) {
        Clear-Host
        Write-Host "======================================" -ForegroundColor Green
        Write-Host "       Network Port Manager       " -ForegroundColor Green
        Write-Host "======================================" -ForegroundColor Green
        Write-Host "1. List Open Ports"
        Write-Host "2. Close a Port"
        Write-Host "3. Back to Main Menu"
        Write-Host "======================================" -ForegroundColor Green
        $choice = Read-Host "Enter your choice (1-3)"
        
        switch ($choice) {
            "1" {
                $ports = Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" } | Select-Object LocalPort, OwningProcess
                foreach ($port in $ports) {
                    $process = Get-Process -Id $port.OwningProcess -ErrorAction SilentlyContinue
                    Write-Host "Port: $($port.LocalPort), Process: $($process.Name)"
                }
                Write-Log "Listed open ports"
                Read-Host "Press Enter to continue..."
            }
            "2" {
                $port_number = Read-Host "Enter port number to close"
                $connection = Get-NetTCPConnection | Where-Object { $_.LocalPort -eq $port_number -and $_.State -eq "Listen" }
                if ($connection) {
                    $process_id = $connection.OwningProcess
                    Stop-Process -Id $process_id -Force
                    Write-Host "Closed port $_max_number (Process ID: $process_id)" -ForegroundColor Green
                    Write-Log "Closed port $port_number (Process ID: $process_id)"
                } else {
                    Write-Host "Port $port_number not found or not open" -ForegroundColor Red
                    Write-Log "Failed to close port $port_number: Not found"
                }
                Read-Host "Press Enter to continue..."
            }
            "3" {
                return
            }
            default {
                Write-Host "Invalid choice" -ForegroundColor Red
                Read-Host "Press Enter to continue..."
            }
        }
    }
}

Manage-Ports