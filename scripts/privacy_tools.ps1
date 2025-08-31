param($DriveRoot)
$ErrorActionPreference = "SilentlyContinue"
$log_file = Join-Path -Path $DriveRoot -ChildPath "logs\activity.log"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $log_file -Value "[$timestamp] $Message"
}

# Configure Mullvad Browser
$mullvad_profile = Join-Path -Path $DriveRoot -ChildPath "apps\mullvad_browser\profile"
New-Item -ItemType Directory -Path $mullvad_profile -Force | Out-Null
$mullvad_user_js = @"
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("browser.startup.homepage", "https://www.startpage.com");
user_pref("network.trr.mode", 2);
user_pref("network.cookie.cookieBehavior", 2);
"@
Set-Content -Path (Join-Path -Path $mullvad_profile -ChildPath "user.js") -Value $mullvad_user_js
Write-Log "Configured Mullvad Browser with Startpage and privacy settings"

# Configure Brave Browser
$brave_profile = Join-Path -Path $DriveRoot -ChildPath "apps\brave\User Data\Default"
New-Item -ItemType Directory -Path $brave_profile -Force | Out-Null
$brave_prefs = @"
{
    "homepage": "https://www.startpage.com",
    "homepage_is_newtabpage": false,
    "browser": {
        "default_search_provider": {
            "enabled": true,
            "search_url": "https://www.startpage.com/search?q={searchTerms}"
        }
    }
}
"@
Set-Content -Path (Join-Path -Path $brave_profile -ChildPath "Preferences") -Value $brave_prefs
Write-Log "Configured Brave Browser with Startpage"

# Install browser extensions for Mullvad Browser
$extensions = @(
    @{ Name = "NoScript"; Url = "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi" },
    @{ Name = "HTTPS Everywhere"; Url = "https://www.eff.org/files/https-everywhere-latest.xpi" },
    @{ Name = "Decentraleyes"; Url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi" },
    @{ Name = "Privacy Badger"; Url = "https://www.eff.org/files/privacy-badger-latest.xpi" }
)
$mullvad_ext_dir = Join-Path -Path $mullvad_profile -ChildPath "extensions"
New-Item -ItemType Directory -Path $mullvad_ext_dir -Force | Out-Null
foreach ($ext in $extensions) {
    try {
        $ext_path = Join-Path -Path $mullvad_ext_dir -ChildPath "$($ext.Name).xpi"
        $web_client = New-Object System.Net.WebClient
        $web_client.DownloadFile($ext.Url, $ext_path)
        Write-Log "Installed $($ext.Name) for Mullvad Browser"
    } catch {
        Write-Log "Error installing $($ext.Name): $_"
    }
}

# Launch applications
$mullvad_vpn_path = Join-Path -Path $DriveRoot -ChildPath "apps\downloads\mullvad_vpn.exe"
$xampp_path = Join-Path -Path $DriveRoot -ChildPath "apps\downloads\xampp.exe"
$vscode_path = Join-Path -Path $DriveRoot -ChildPath "apps\downloads\vscode.zip"
$git_path = Join-Path -Path $DriveRoot -ChildPath "apps\downloads\git.exe"
foreach ($path in @($mullvad_vpn_path, $xampp_path, $vscode_path, $git_path)) {
    if (Test-Path $path) {
        if ($path -eq $vscode_path) {
            # VSCode is a zip, already extracted in Search-Application
            $vscode_exe = Join-Path -Path $DriveRoot -ChildPath "apps\vscode\Code.exe"
            if (Test-Path $vscode_exe) {
                Start-Process -FilePath $vscode_exe
                Write-Log "Launched VSCode"
            }
        } else {
            Start-Process -FilePath $path
            Write-Log "Launched $(Split-Path -Path $path -Leaf)"
        }
    }
}