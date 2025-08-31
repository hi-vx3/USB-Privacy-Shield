import os

# المسار الأساسي
base_path = "apps"

# قائمة المجلدات الفرعية
folders = [
    "powershell",
    "mullvad_browser",
    "brave",
    "mullvad_vpn",
    "xampp",
    "vscode",
    "git",
    "downloads"
]

# إنشاء المجلد الأساسي إن لم يكن موجوداً
os.makedirs(base_path, exist_ok=True)

# إنشاء كل مجلد فرعي داخل apps/
for folder in folders:
    path = os.path.join(base_path, folder)
    os.makedirs(path, exist_ok=True)
    print(f"Created: {path}")

print("تم إنشاء جميع المجلدات بنجاح.")
