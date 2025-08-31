#Requires -RunAsAdministrator
$ErrorActionPreference = "SilentlyContinue"
$drive_root = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$log_file = Join-Path -Path $drive_root -ChildPath "logs\activity.log"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    New-Item -ItemType Directory -Path (Join-Path -Path $drive_root -ChildPath "logs") -Force | Out-Null
    Add-Content -Path $log_file -Value "[$timestamp] $Message"
}

function Load-Config {
    $config_path = Join-Path -Path $drive_root -ChildPath "config.json"
    try {
        return Get-Content -Path $config_path -Raw | ConvertFrom-Json
    } catch {
        Write-Log "Error loading config: $_"
        Write-Host "Failed to load configuration" -ForegroundColor Red
        return $null
    }
}

function Search-Application {
    param($AppName, $Config)
    foreach ($app in $Config.applications) {
        if ($app.name -eq $AppName) {
            if ($app.type -eq "portable") {
                $full_path = Join-Path -Path $drive_root -ChildPath $app.source
                if (Test-Path $full_path) {
                    Start-Process -FilePath $full_path
                    Write-Log "Launched portable app: $AppName"
                    return "Launching $($app.name)..."
                } else {
                    try {
                        Write-Log "Downloading $($app.name) from $($app.url)"
                        $web_client = New-Object System.Net.WebClient
                        $download_path = Join-Path -Path $drive_root -ChildPath $app.download_path
                        New-Item -ItemType Directory -Path (Split-Path -Path $download_path -Parent) -Force | Out-Null
                        $web_client.DownloadFile($app.url, $download_path)
                        Write-Log "Downloaded $($app.name) to $download_path"
                        if ($app.name -eq "vscode") {
                            # Extract VSCode zip
                            Expand-Archive -Path $download_path -DestinationPath (Join-Path -Path $drive_root -ChildPath "apps\vscode") -Force
                            Write-Log "Extracted VSCode to apps\vscode"
                        }
                        Start-Process -FilePath $download_path
                        return "Downloaded and launched $($app.name)..."
                    } catch {
                        Write-Log "Error downloading $($app.name): $_"
                        Start-Process $app.url
                        return "Failed to download $($app.name). Opening URL..."
                    }
                }
            } elseif ($app.type -eq "url") {
                Start-Process $app.source
                Write-Log "Opened URL: $AppName"
                return "Opening $($app.name) in default browser..."
            }
        }
    }
    Write-Log "Application not found: $AppName"
    return "Application '$AppName' not found in config."
}

function Main-Menu {
    $config = Load-Config
    if (-not $config) { exit 1 }
    
    # Run initial privacy setup
    Write-Host "Applying privacy settings..." -ForegroundColor Green
    & (Join-Path -Path $drive_root -ChildPath "scripts\ads_removal.ps1")
    & (Join-Path -Path $drive_root -ChildPath "scripts\data_cleanup.ps1")
    & (Join-Path -Path $drive_root -ChildPath "scripts\background_apps.ps1")
    & (Join-Path -Path $drive_root -ChildPath "scripts\disable_security.ps1")
    & (Join-Path -Path $drive_root -ChildPath "scripts\privacy_tools.ps1") -DriveRoot $drive_root
    Write-Log "Initial privacy setup completed"
    
    while ($true) {
        Clear-Host
        Write-Host "======================================" -ForegroundColor Green
        Write-Host "       USB Privacy Shield       " -ForegroundColor Green
        Write-Host "======================================" -ForegroundColor Green
        Write-Host "1. Launch Application"
        Write-Host "2. Manage Network Ports"
        Write-Host "3. Re-run Privacy Setup"
        Write-Host "4. Exit"
        Write-Host "======================================" -ForegroundColor Green
        Write-Host "Available Applications:"
        foreach ($app in $config.applications) {
            Write-Host "- $($app.name)"
        }
        Write-Host "======================================" -ForegroundColor Green
        $choice = Read-Host "Enter your choice (1-4)"
        
        switch ($choice) {
            "1" {
                $app_name = Read-Host "Enter application name"
                $result = Search-Application -AppName $app_name -Config $config
                Write-Host $result -ForegroundColor Yellow
                Write-Log "User launched app: $app_name, Result: $result"
                Read-Host "Press Enter to continue..."
            }
            "2" {
                & (Join-Path -Path $drive_root -ChildPath "scripts\port_manager.ps1")
                Write-Log "User accessed port manager"
                Read-Host "Press Enter to continue..."
            }
            "3" {
                Write-Host "Re-running privacy setup..." -ForegroundColor Green
                & (Join-Path -Path $drive_root -ChildPath "scripts\ads_removal.ps1")
                & (Join-Path -Path $drive_root -ChildPath "scripts\data_cleanup.ps1")
                & (Join-Path -Path $drive_root -ChildPath "scripts\background_apps.ps1")
                & (Join-Path -Path $drive_root -ChildPath "scripts\disable_security.ps1")
                & (Join-Path -Path $drive_root -ChildPath "scripts\privacy_tools.ps1") -DriveRoot $drive_root
                Write-Log "Privacy setup re-run"
                Read-Host "Press Enter to continue..."
            }
            "4" {
                Write-Log "User exited the launcher"
                exit
            }
            default {
                Write-Host "Invalid choice" -ForegroundColor Red
                Read-Host "Press Enter to continue..."
            }
        }
    }
}

Main-Menu