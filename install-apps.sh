#!/bin/bash

# ============================================
# Install Applications Script
# سكريبت تثبيت التطبيقات
# ============================================

set -e

echo "📲 تثبيت التطبيقات الأساسية والمتقدمة..."

# تحديث المستودعات
apt-get update -y

# قائمة التطبيقات المراد تثبيتها
APPS=(
    # المتصفحات
    "firefox"
    "firefox-locale-ar"
    "chromium-browser"
    
    # أدوات النظام
    "gnome-system-monitor"
    "gnome-terminal"
    "nautilus"
    "file-roller"
    
    # الإنتاجية والمكتب
    "libreoffice"
    "libreoffice-l10n-ar"
    "gnome-calendar"
    "gnome-tasks"
    
    # الوسائط والرسومات
    "vlc"
    "audacious"
    "gimp"
    "shotwell"
    "imagemagick"
    "ffmpeg"
    "mpv"
    
    # الأدوات المساعدة
    "curl"
    "wget"
    "git"
    "unzip"
    "7zip"
    "p7zip-full"
    "zip"
    
    # محرران النصوص
    "gedit"
    "gedit-plugins"
    
    # أدوات التطوير
    "build-essential"
    "git"
    "python3"
    "python3-pip"
    "python3-dev"
    "nodejs"
    "npm"
    
    # الشبكات والإنترنت
    "openssh-client"
    "openssh-server"
    "curl"
    "wget"
    "net-tools"
    "traceroute"
    "nmap"
    
    # أدوات النظام والأمان
    "gnupg"
    "pass"
    "sudo"
    "htop"
    "neofetch"
    
    # تطبيقات إضافية
    "cups"
    "simple-scan"
    "ibus"
    "ibus-pinyin"
    "fcitx"
    
    # ألعاب خفيفة
    "gnome-games"
    "gnome-tetravex"
)

echo "📦 عدد التطبيقات المراد تثبيتها: ${#APPS[@]}"
echo ""

# تثبيت كل تطبيق
INSTALLED=0
FAILED=0

for app in "${APPS[@]}"; do
    if apt-cache search "^${app}$" &>/dev/null; then
        echo -n "⏳ تثبيت $app... "
        if apt-get install -y "$app" &>/dev/null; then
            echo -e "✅"
            ((INSTALLED++))
        else
            echo -e "⚠️ فشل"
            ((FAILED++))
        fi
    else
        echo "⚠️  $app غير متاح في المستودعات"
        ((FAILED++))
    fi
done

echo ""
echo "📊 النتائج:"
echo "  ✅ تم تثبيت: $INSTALLED تطبيق"
echo "  ⚠️  فشل: $FAILED تطبيق"
echo ""

# تثبيت حزم Python إضافية
echo "🐍 تثبيت حزم Python..."
pip3 install --upgrade pip wheel setuptools -q 2>/dev/null || true

# قائمة الحزم
PYTHON_PACKAGES=(
    "requests"
    "beautifulsoup4"
    "pillow"
    "psutil"
    "pyyaml"
)

for package in "${PYTHON_PACKAGES[@]}"; do
    echo -n "  📦 $package... "
    pip3 install "$package" -q 2>/dev/null && echo "✅" || echo "⚠️"
done

echo ""
echo -e "✅ تم تثبيت التطبيقات"
echo ""
