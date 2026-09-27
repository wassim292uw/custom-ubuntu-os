#!/bin/bash

# ============================================
# Download ISO Helper Script
# سكريبت مساعد لتحميل وحرق ISO
# ============================================

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    Custom Ubuntu OS - ISO Download Helper Tool             ║"
echo "║     أداة تحميل حرق نظام التشغيل المخصص                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "اختر خيار:"
echo ""
echo "1) تحميل ملف ISO من GitHub"
echo "2) حرق ISO على فلاشة USB (Linux)"
echo "3) عرض معلومات النظام"
echo "4) فحص سرعة الإنترنت"
echo "5) إظهار الروابط المهمة"
echo ""

read -p "أدخل رقم الخيار (1-5): " choice

case $choice in
    1)
        echo ""
        echo "📥 روابط التحميل:"
        echo ""
        echo "الخيار 1: GitHub Releases (موصى به)"
        echo "https://github.com/wassim292uw/custom-ubuntu-os/releases"
        echo ""
        echo "الخيار 2: التحميل المباشر"
        echo "https://github.com/wassim292uw/custom-ubuntu-os/releases/download/v1.0.0/custom-ubuntu-os-1.0.0.iso"
        echo ""
        echo "اضغط على الرابط واختر Download ISO"
        echo ""
        ;;
    2)
        echo ""
        echo "🔥 حرق ISO على USB:"
        echo ""
        echo "الخطوة 1: احصل على قائمة الأجهزة"
        echo "  lsblk"
        echo ""
        echo "الخطوة 2: افصل الفلاشة"
        echo "  sudo umount /dev/sdX*"
        echo ""
        echo "الخطوة 3: احرق الملف"
        echo "  sudo dd if=custom-ubuntu-os-1.0.0.iso of=/dev/sdX bs=4M status=progress"
        echo ""
        echo "الخطوة 4: انتظر حتى ينتهي ثم:"
        echo "  sync"
        echo "  sudo eject /dev/sdX"
        echo ""
        ;;
    3)
        echo ""
        echo "📊 معلومات النظام:"
        echo ""
        echo "اسم النظام: Custom Ubuntu OS"
        echo "الإصدار: 1.0.0"
        echo "القاعدة: Ubuntu 22.04 LTS (Jammy)"
        echo "حجم ISO: ~2.5 GB"
        echo "الواجهة: XFCE4"
        echo ""
        echo "المميزات:"
        echo "  ✓ Live ISO"
        echo "  ✓ مثبت تفاعلي"
        echo "  ✓ دعم BIOS و UEFI"
        echo "  ✓ Firefox و Chromium"
        echo "  ✓ LibreOffice و Thunderbird"
        echo "  ✓ VLC و GIMP"
        echo "  ✓ Waydroid (Android APK)"
        echo "  ✓ Python و Node.js و Git"
        echo ""
        ;;
    4)
        echo ""
        echo "⚡ فحص سرعة الإنترنت:"
        echo ""
        if command -v speedtest-cli &> /dev/null; then
            speedtest-cli
        else
            echo "أداة speedtest-cli غير مثبتة."
            echo "تثبيت:"
            echo "  pip install speedtest-cli"
            echo "  speedtest-cli"
        fi
        echo ""
        ;;
    5)
        echo ""
        echo "🔗 الروابط المهمة:"
        echo ""
        echo "📌 المستودع الرئيسي:"
        echo "   https://github.com/wassim292uw/custom-ubuntu-os"
        echo ""
        echo "📌 تحميل ISO:"
        echo "   https://github.com/wassim292uw/custom-ubuntu-os/releases"
        echo ""
        echo "📌 دليل التثبيت:"
        echo "   https://github.com/wassim292uw/custom-ubuntu-os/blob/main/INSTALLATION_COMPLETE.md"
        echo ""
        echo "📌 أداة حرق Balena Etcher:"
        echo "   https://www.balena.io/etcher/"
        echo ""
        echo "📌 أداة Rufus (Windows):"
        echo "   https://rufus.ie/"
        echo ""
        echo "📌 GitHub Issues (الدعم):"
        echo "   https://github.com/wassim292uw/custom-ubuntu-os/issues"
        echo ""
        ;;
    *)
        echo "❌ خيار غير صحيح"
        exit 1
        ;;
esac

echo ""
