#!/bin/bash

# ============================================
# Chroot Setup Script
# سكريبت التهيئة داخل Chroot
# ============================================

set -e

export DEBIAN_FRONTEND=noninteractive

echo "[تهيئة النظام الداخلية]"

# Update repositories
echo "تحديث المستودعات..."
apt-get update
apt-get upgrade -y

# Install base packages
echo "تثبيت الحزم الأساسية..."
apt-get install -y \
    linux-generic \
    linux-headers-generic \
    grub-pc \
    grub-efi-amd64-signed \
    shim-signed \
    casper \
    lupin-casper \
    live-boot \
    live-config \
    initramfs-tools

# Install desktop environment
echo "تثبيت بيئة سطح المكتب..."
apt-get install -y \
    xorg \
    lightdm \
    xfce4 \
    xfce4-terminal \
    firefox \
    chromium-browser \
    vlc \
    gimp \
    libreoffice

# Install Android support
echo "تثبيت دعم Android APK..."
apt-get install -y \
    waydroid \
    python3 \
    python3-pip

# Install system tools
echo "تثبيت أدوات النظام..."
apt-get install -y \
    sudo \
    openssh-client \
    openssh-server \
    curl \
    wget \
    git \
    htop \
    neofetch \
    gnupg \
    ca-certificates

# Configure system
echo "ضبط إعدادات النظام..."

# Set hostname
echo "custom-ubuntu-os" > /etc/hostname

# Create os-release
cat > /etc/os-release << 'EOF'
NAME="Custom Ubuntu OS"
VERSION="1.0"
ID=custom-ubuntu
ID_LIKE=ubuntu
PRETTY_NAME="Custom Ubuntu OS 1.0"
VERSION_ID=1.0
HOME_URL="https://github.com/wassim292uw/custom-ubuntu-os"
BUG_REPORT_URL="https://github.com/wassim292uw/custom-ubuntu-os/issues"
LOGO=custom-ubuntu
EOF

# Create lsb-release
cat > /etc/lsb-release << 'EOF'
DISTRIB_ID=CustomUbuntuOS
DISTRIB_RELEASE=1.0
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="Custom Ubuntu OS 1.0"
EOF

# Configure network
echo "ضبط الشبكة..."
cat > /etc/network/interfaces << 'EOF'
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

# Configure GRUB
echo "ضبط GRUB..."
echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"' >> /etc/default/grub
echo 'GRUB_TIMEOUT=10' >> /etc/default/grub
echo 'GRUB_GFXMODE=1024x768' >> /etc/default/grub

# Create default user
echo "إنشاء مستخدم افتراضي..."
useradd -m -s /bin/bash -G sudo ubuntu || true
echo 'ubuntu:ubuntu' | chpasswd

# Configure LightDM
echo "ضبط واجهة الدخول..."
cat > /etc/lightdm/lightdm.conf << 'EOF'
[General]
session=xfce
user-session=xfce
allowguest=false
EOF

# Cleanup
echo "تنظيف النظام..."
apt-get autoremove -y
apt-get autoclean -y
rm -rf /tmp/* /var/tmp/*

echo "[تم إنهاء التهيئة]"
