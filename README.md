# 🔒 USB Privacy Shield

**USB Privacy Shield** is a project designed to configure a Windows machine for enhanced privacy and reduced digital fingerprinting, using a portable USB stick.  
It includes a complex PowerShell script that automatically applies privacy settings, installs applications from GitHub repositories, and provides an interactive interface to manage apps and network ports.  
The project is portable, requiring no permanent installation on the host machine.

---

## ✨ Key Features
- **Install Applications from GitHub**: Automatically downloads and runs apps like Mullvad Browser, Mullvad VPN, Visual Studio Code, and Git from official GitHub repositories, plus other trusted sources (Brave, XAMPP).  
- **Browser Configuration**: Configures Mullvad Browser and Brave to use **Startpage** as the default search engine, with pre-installed privacy extensions (NoScript, HTTPS Everywhere, Decentraleyes, Privacy Badger).  
- **Privacy Enhancements**:  
  - Disable Windows ads (Start menu, lock screen, settings).  
  - Stop unnecessary background apps.  
  - Clean logs and temporary data.  
  - Optionally disable Windows Defender and updates (⚠️ risky).  
- **Port Management**: Interactive tool to view and close open network ports.  
- **Interactive Menu**: Text-based interface for launching apps and managing privacy settings.  

---

## 📂 Project Structure
```

\[ root ]
│── autorun.inf            # Autorun attempt to open instructions
│── index.html             # Instruction page
│── launcher.bat           # Batch file to run portable PowerShell
│── privacy\_shield.ps1     # Main PowerShell script
│── config.json            # JSON config with apps and sources
│── apps/                  # Portable applications
│   ├── powershell/        # Portable PowerShell Core
│   ├── mullvad\_browser/   # Mullvad Browser (portable)
│   ├── brave/             # Brave Browser (portable)
│   ├── mullvad\_vpn/       # Mullvad VPN (portable)
│   ├── xampp/             # XAMPP (portable)
│   ├── vscode/            # Visual Studio Code (portable)
│   ├── git/               # Git (portable)
│   ├── downloads/         # Temporary downloads
│── scripts/               # Sub-scripts
│   ├── ads\_removal.ps1    # Disable ads
│   ├── port\_manager.ps1   # Manage ports
│   ├── privacy\_tools.ps1  # Install/run privacy tools
│   ├── data\_cleanup.ps1   # Cleanup data/logs
│   ├── background\_apps.ps1 # Stop background apps
│   ├── disable\_security.ps1 # Disable Defender/updates
│── logs/                  # Activity logs
│── data/                  # Generated data

```

---

## ⚙️ Requirements
- **USB Stick**: Formatted as NTFS.  
- **OS**: Windows 7 or later (Windows 10/11 recommended).  
- **Internet**: Required for downloading applications.  
- **Admin Privileges**: Required for applying system changes and installing some apps.  

---

## 🚀 Setup
1. **Prepare the USB**:  
   - Format the USB drive with NTFS.  
   - Create the structure shown above.  

2. **Add Portable PowerShell**:  
   - Download PowerShell Core from [GitHub](https://github.com/PowerShell/PowerShell/releases).  
   - Copy the folder into `apps/powershell`.  

3. **Copy Project Files**:  
   - Place `autorun.inf`, `index.html`, `launcher.bat`, `privacy_shield.ps1`, `config.json`, and the `scripts` folder into the root of the USB.  
   - Create folders `apps`, `logs`, and `data`.  

4. **Test the System**:  
   - Insert the USB into a Windows machine.  
   - If `index.html` opens automatically, follow the instructions.  
   - Otherwise, run `launcher.bat` manually as Administrator.  

---

## 🖥️ Usage
1. Insert the USB and run `launcher.bat` as Administrator.  
2. The script will automatically apply privacy settings (disable ads, cleanup, etc.).  
3. Use the interactive menu to:  
   - Launch apps (`mullvad_browser`, `brave`, `vscode`).  
   - Manage open ports.  
   - Re-apply privacy settings.  
   - Exit the script.  

---

## 📦 Supported Applications
- **Mullvad Browser** – Secure, privacy-focused browser with Startpage and extensions.  
- **Brave Browser** – Privacy browser, Startpage configured.  
- **Mullvad VPN** – VPN client (requires account).  
- **ProtonMail / Proton Drive** – Secure web services.  
- **XAMPP** – Portable local server.  
- **Visual Studio Code** – Portable IDE.  
- **Git** – Portable Git client.  

---

## 🌐 App Sources
| Application      | Source | Notes |
|------------------|--------|-------|
| Mullvad Browser  | [mullvad/mullvad-browser](https://github.com/mullvad/mullvad-browser) | Portable with extensions |
| Mullvad VPN      | [mullvad/mullvadvpn-app](https://github.com/mullvad/mullvadvpn-app) | Portable, account required |
| Visual Studio Code | [microsoft/vscode](https://github.com/microsoft/vscode) | Portable version |
| Git              | [git-for-windows/git](https://github.com/git-for-windows/git) | Portable |
| Brave            | [Brave Official](https://laptop-updates.brave.com/latest/winx64) | Not on GitHub |
| XAMPP            | [SourceForge](https://sourceforge.net/projects/xampp/) | Not on GitHub |
| ProtonMail       | [mail.proton.me](https://mail.proton.me) | Web service |
| Proton Drive     | [drive.proton.me](https://drive.proton.me) | Web service |

---

## ⚠️ Warnings
- **Disabling Protection**: Turning off Windows Defender or updates is risky. Use only on privacy-dedicated systems.  
- **Internet Required**: Needed for downloading apps and extensions.  
- **Permanent Changes**: Some registry edits may persist after USB removal. Always back up before use.  

---

## 📝 Additional Notes
- **Logs**: All operations are saved to `logs/activity.log`.  
- **Customization**: Modify `config.json` to add or change applications.  
- **Support**: Open an Issue for bugs, requests, or contributions.  
---

> ⚠️ **Warning**: This project is incomplete and still under development.  
> Do **not** test or run it on your main device, as it may cause system instability or security risks.  
> Use only in isolated test environments at your own risk.

---

## 📜 License
This project is licensed under the **MIT License**.  
See the [LICENSE](LICENSE) file for details.
