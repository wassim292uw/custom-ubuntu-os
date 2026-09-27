#!/bin/bash

# ============================================
# Custom Ubuntu OS - Main Setup Script
# نظام التشغيل المخصص - سكريبت التثبيت الرئيسي
# ============================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║     Custom Ubuntu OS - نظام التشغيل المخصص            ║"
echo "║                 Setup & Installation                   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ يجب تشغيل هذا السكريبت بصلاحيات المسؤول (sudo)${NC}"
    echo "Run: sudo bash setup.sh"
    exit 1
fi

# Log file
LOG_FILE="/var/log/custom-ubuntu-setup.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2>&1

echo -e "${YELLOW}[1/10] تحديث قائمة المستودعات...${NC}"
apt-get update -y

echo -e "${YELLOW}[2/10] تحديث النظام...${NC}"
apt-get upgrade -y
apt-get dist-upgrade -y

echo -e "${YELLOW}[3/10] تثبيت الأدوات الأساسية...${NC}"
apt-get install -y \
    build-essential \
    curl wget git \
    vim nano \
    htop neofetch \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    ubuntu-restricted-extras

echo -e "${YELLOW}[4/10] تثبيت سطح المكتب GNOME...${NC}"
apt-get install -y \
    gnome-shell \
    gnome-terminal \
    gnome-control-center \
    gnome-tweaks \
    dconf-cli

echo -e "${YELLOW}[5/10] تثبيت التطبيقات الأساسية...${NC}"
bash install-apps.sh

echo -e "${YELLOW}[6/10] تثبيت تطبيقات الإنتاجية...${NC}"
apt-get install -y \
    libreoffice \
    libreoffice-writer \
    libreoffice-calc \
    libreoffice-impress \
    thunderbird \
    gnome-calendar

echo -e "${YELLOW}[7/10] تثبيت تطبيقات الوسائط...${NC}"
apt-get install -y \
    vlc \
    audacious \
    gimp \
    shotwell \
    imagemagick \
    ffmpeg

echo -e "${YELLOW}[8/10] تثبيت أدوات التطوير...${NC}"
apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    nodejs \
    npm \
    git

echo -e "${YELLOW}[9/10] تخصيص سطح المكتب...${NC}"
bash customize-desktop.sh

echo -e "${YELLOW}[10/10] تثبيت دعم تطبيقات Android APK...${NC}"
bash install-apk-support.sh

# Create necessary directories
echo -e "${YELLOW}إنشاء المجلدات المطلوبة...${NC}"
mkdir -p /opt/custom-os/{wallpapers,themes,apps,config,docs}
mkdir -p /home/${SUDO_USER}/.local/share/applications
mkdir -p /home/${SUDO_USER}/.config/custom-os

# Set permissions
chown -R ${SUDO_USER}:${SUDO_USER} /opt/custom-os
chown -R ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/.config/custom-os

# Install pip packages
echo -e "${YELLOW}تثبيت حزم Python...${NC}"
pip3 install --upgrade pip 2>/dev/null || true
pip3 install -r requirements.txt 2>/dev/null || true

# Clean up
echo -e "${YELLOW}تنظيف النظام...${NC}"
apt-get autoremove -y
apt-get autoclean -y

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗"
echo "║        ✅ تم التثبيت بنجاح! Installation Complete!       ║"
echo "╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 الخطوات التالية:${NC}"
echo "1️⃣  أعد تشغيل النظام: ${YELLOW}sudo reboot${NC}"
echo "2️⃣  لحرق على فلاشة USB: ${YELLOW}sudo bash burn-to-usb.sh /dev/sdX${NC}"
echo "3️⃣  للمزيد من المعلومات: ${YELLOW}cat INSTALLATION.md${NC}"
echo ""
echo -e "${BLUE}📁 ملف السجل:${NC} ${YELLOW}$LOG_FILE${NC}"
echo ""
