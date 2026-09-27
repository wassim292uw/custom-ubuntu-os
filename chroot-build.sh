#!/bin/bash

# ============================================
# Complete Chroot Build Script
# سكريبت البناء الشامل داخل Chroot
# ============================================

set -e

export DEBIAN_FRONTEND=noninteractive
OSNAME="${1:-Custom Ubuntu OS}"
OSVERSION="${2:-1.0.0}"

echo "[Chroot Build] Building: $OSNAME $OSVERSION"

# Update and upgrade
echo "[1/20] تحديث المستودعات..."
apt-get update
apt-get upgrade -y

# Install bootloader
echo "[2/20] تثبيت محمل الإقلاع..."
apt-get install -y --no-install-recommends \
    grub-pc grub-efi-amd64-signed shim-signed \
    grub-common grub2-common grub-efi-amd64

# Install kernel
echo "[3/20] تثبيت النواة والأدوات..."
apt-get install -y --no-install-recommends \
    linux-generic linux-headers-generic \
    casper live-boot live-config lupin-casper initramfs-tools

# Install desktop environment (XFCE4 - خفيف وسريع)
echo "[4/20] تثبيت سطح المكتب..."
apt-get install -y --no-install-recommends \
    xorg xfce4 xfce4-terminal xfce4-taskbar \
    xfce4-panel xfce4-appfinder xfce4-settings \
    lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings

# Install system utilities
echo "[5/20] تثبيت أدوات النظام..."
apt-get install -y --no-install-recommends \
    sudo openssh-client openssh-server \
    curl wget git htop neofetch \
    vim nano build-essential software-properties-common

# Install internet browsers
echo "[6/20] تثبيت المتصفحات..."
apt-get install -y --no-install-recommends \
    firefox firefox-locale-en chromium-browser

# Install applications
echo "[7/20] تثبيت التطبيقات..."
apt-get install -y --no-install-recommends \
    vlc geeqie gimp libreoffice \
    thunderbird nautilus file-roller \
    gedit transmission-gtk

# Install media codecs
echo "[8/20] تثبيت الترميزات..."
apt-get install -y --no-install-recommends \
    ffmpeg libavcodec-extra libavformat-extra \
    gstreamer1.0-libav gstreamer1.0-plugins-good

# Install development tools
echo "[9/20] تثبيت أدوات التطوير..."
apt-get install -y --no-install-recommends \
    python3 python3-pip python3-dev \
    nodejs npm git

# Install network tools
echo "[10/20] تثبيت أدوات الشبكة..."
apt-get install -y --no-install-recommends \
    net-tools openssh-client openssh-server \
    wireless-tools wpasupplicant curl wget

# Install Android support (Waydroid)
echo "[11/20] تثبيت دعم Android APK..."
echo "deb https://repo.waydro.id jammy main" > /etc/apt/sources.list.d/waydroid.list
curl -fsSL https://repo.waydro.id/waydroid.gpg | apt-key add - 2>/dev/null || true
apt-get update
apt-get install -y --no-install-recommends waydroid 2>/dev/null || echo "Waydroid installation skipped"

# Install theming
echo "[12/20] تثبيت الثيمات والأيقونات..."
apt-get install -y --no-install-recommends \
    papirus-icon-theme adwaita-icon-theme \
    humanity-icon-theme tango-icon-theme

# Create custom os-release
echo "[13/20] إنشاء ملفات الهوية المخصصة..."
cat > /etc/os-release << OSEOF
NAME="${OSNAME}"
VERSION="${OSVERSION}"
ID=custom-ubuntu
ID_LIKE=ubuntu
PRETTY_NAME="${OSNAME} ${OSVERSION}"
VERSION_ID=${OSVERSION}
HOME_URL="https://github.com/wassim292uw/custom-ubuntu-os"
BUG_REPORT_URL="https://github.com/wassim292uw/custom-ubuntu-os/issues"
LOGO=custom-ubuntu
PLATFORM_ID=custom-ubuntu
UBUNTU_CODENAME=jammy
OSEOF

cat > /etc/lsb-release << LSBEOF
DISTRIB_ID=CustomUbuntuOS
DISTRIB_RELEASE=${OSVERSION}
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="${OSNAME} ${OSVERSION}"
LSBEOF

echo "[14/20] ضبط الشبكة..."
cat > /etc/network/interfaces << NETEOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
NETEOF

# Configure GRUB
echo "[15/20] ضبط GRUB..."
cat >> /etc/default/grub << GRUBEOF
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_TIMEOUT=10
GRUB_GFXMODE=1024x768
GRUB_DISTRIBUTOR="${OSNAME}"
GRUBEOF

# Create default user
echo "[16/20] إنشاء حساب المستخدم..."
useradd -m -s /bin/bash -G sudo custom 2>/dev/null || true
echo "custom:custom" | chpasswd
echo "root:root" | chpasswd

# Configure lightdm
echo "[17/20] ضبط واجهة الدخول..."
cat > /etc/lightdm/lightdm.conf << LIGHTDMEOF
[General]
session=xfce
user-session=xfce
allowguest=false
allow-user-switch=true
EOF

# Create issue file for terminal
echo "[18/20] إنشاء رسالة الترحيب..."
cat > /etc/issue << ISSUEEOF
╔════════════════════════════════════════════╗
║  ${OSNAME} ${OSVERSION}              ║
║  Built on Ubuntu Jammy 22.04 LTS          ║
║  https://github.com/wassim292uw           ║
╚════════════════════════════════════════════╝
ISSUEEOF
cp /etc/issue /etc/issue.net

# Setup Waydroid (if installed)
echo "[19/20] إعداد Waydroid..."
mkdir -p /opt/waydroid
cat > /usr/bin/setup-waydroid << 'WAYEOF'
#!/bin/bash
waydroid init
waydroid session start
WAYEOF
chmod +x /usr/bin/setup-waydroid

# Cleanup
echo "[20/20] تنظيف النظام..."
apt-get autoremove -y
apt-get autoclean -y
rm -rf /tmp/* /var/tmp/* /var/cache/apt/archives/*

# Create launch desktop entry for customization
echo "[Post-Install] إنشاء اختصارات سطح المكتب..."
cat > /usr/share/applications/customize-system.desktop << DESKTOPEOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Customize System
Name[ar]=تخصيص النظام
Comment=Customize ${OSNAME} settings
Comment[ar]=تخصيص إعدادات النظام
Exec=xfce4-settings-manager
Icon=preferences-system
Terminal=false
Categories=System;Settings;
DESKTOPEOF

echo "[✓] تمت المرحلة الثانية من البناء"
