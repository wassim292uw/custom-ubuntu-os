#!/bin/bash

# ============================================
# GNOME Desktop Customization
# تخصيص سطح المكتب GNOME
# ============================================

set -e

echo "🎨 بدء تخصيص سطح المكتب GNOME..."

# الحصول على معلومات المستخدم
CURRENT_USER="${SUDO_USER:-$USER}"
HOME_DIR="/home/$CURRENT_USER"

if [ ! -d "$HOME_DIR" ]; then
    echo "❌ مجلد المستخدم غير موجود: $HOME_DIR"
    exit 1
fi

echo "👤 المستخدم الحالي: $CURRENT_USER"
echo "🏠 مجلد المنزل: $HOME_DIR"

# تثبيت الأدوات المطلوبة
echo "🔧 تثبيت أدوات التخصيص..."
apt-get install -y dconf-cli gsettings-desktop-schemas -q

# إنشاء ملف gsettings
mkdir -p "$HOME_DIR/.config/dconf"

# تطبيق الثيم والألوان
echo "🎨 تطبيق الثيم والألوان..."

# تفعيل الثيم الداكن
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'"
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'"

# إعدادات الخط
echo "🔤 ضبط إعدادات الخطوط..."
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'"
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu 11'"
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 11'"

# تعيين الخلفية
echo "🖼️  تعيين الخلفية..."
if [ -f "wallpapers/default-wallpaper.png" ]; then
    WALLPAPER_PATH="file://$(cd wallpapers && pwd)/default-wallpaper.png"
    su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.background picture-uri '$WALLPAPER_PATH'"
    su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.background picture-uri-dark '$WALLPAPER_PATH'"
    echo "✅ تم تعيين الخلفية المخصصة"
else
    # استخدام خلفية افتراضية
    su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/xfce/xfce-teal.jpg'"
    echo "ℹ️  استخدام الخلفية الافتراضية"
fi

# خيارات الخلفية
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.background picture-options 'scaled'"

# تفعيل الرسوم المتحركة
echo "✨ تفعيل الرسوم المتحركة..."
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface enable-animations true"

# إعدادات شريط المهام (Taskbar/Dock)
echo "📍 ضبط شريط المهام في الأسفل..."

# تثبيت Dash to Dock إذا لم تكن مثبتة
apt-get install -y gnome-shell-extensions -q 2>/dev/null || true

# ضبط Dash to Dock
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'" 2>/dev/null || true
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false" 2>/dev/null || true
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'" 2>/dev/null || true
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell.extensions.dash-to-dock opacity 0.95" 2>/dev/null || true
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode 'FOCUSED'" 2>/dev/null || true

# التطبيقات المفضلة
echo "⭐ تعيين التطبيقات المفضلة..."
su - "$CURRENT_USER" -c "gsettings set org.gnome.shell favorite-apps \"['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Evolution.desktop', 'vlc.desktop', 'libreoffice-writer.desktop']\""

# إعدادات الشاشة
echo "🖥️  ضبط إعدادات الشاشة..."
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface scaling-factor 'uint32 1'"

# Hot Corners
echo "🔥 تفعيل Hot Corners..."
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface enable-hot-corners true"

# إعدادات الطاقة
echo "🔋 ضبط إعدادات الطاقة..."
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.screensaver idle-activation-enabled true"
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.session idle-delay 'uint32 300'"

# إعدادات ملفات تعريف الألوان
echo "🌈 تطبيق ملفات تعريف الألوان..."
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.interface show-battery-percentage true" 2>/dev/null || true

# اختصارات لوحة المفاتيح
echo "⌨️  إضافة اختصارات لوحة المفاتيح..."

# إنشاء ملف اختصارات
cat > "$HOME_DIR/.config/custom-keybindings.conf" << 'EOF'
# اختصارات لوحة المفاتيح المخصصة
# Custom Keyboard Shortcuts

# فتح محطة الطرفية
<Super>t=gnome-terminal

# فتح مدير الملفات
<Super>e=nautilus $HOME

# فتح Firefox
<Super>f=firefox

# فتح LibreOffice Writer
<Super>w=libreoffice --writer

# لقطة الشاشة
Print=gnome-screenshot

# قفل الشاشة
<Super>l=gnome-screensaver-command -l

EOF

chown $CURRENT_USER:$CURRENT_USER "$HOME_DIR/.config/custom-keybindings.conf"

# إعدادات إضافية
echo "⚙️  تطبيق إعدادات إضافية..."
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'"
su - "$CURRENT_USER" -c "gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'toggle-shade'"

# تحديث قاعدة بيانات dconf
dconf update

echo ""
echo -e "✅ تم تخصيص سطح المكتب بنجاح"
echo ""
