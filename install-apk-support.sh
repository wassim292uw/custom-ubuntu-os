#!/bin/bash

# ============================================
# Install Android APK Support
# تثبيت دعم تطبيقات Android
# ============================================

set -e

echo "📱 تثبيت دعم تطبيقات Android APK..."

# تثبيت المتطلبات الأساسية
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -q

# إضافة مستودع Waydroid
echo "🔧 إعداد مستودع Waydroid..."

# تحميل مفتاح GPG
if ! command -v waydroid &> /dev/null; then
    curl -fsSL https://repo.waydro.id/waydroid.gpg | sudo apt-key add - 2>/dev/null || true
    
    # إضافة مستودع Waydroid
    echo "deb https://repo.waydro.id jammy main" | tee /etc/apt/sources.list.d/waydroid.list > /dev/null
    
    # تحديث المستودعات
    apt-get update -q
    
    # تثبيت Waydroid
    echo "⏳ تثبيت Waydroid (قد يستغرق بعض الوقت)..."
    apt-get install -y waydroid 2>/dev/null || {
        echo "⚠️  فشل تثبيت Waydroid، سيتم محاولة البديل..."
        
        # محاولة تثبيت Anbox
        apt-get install -y snapd -q 2>/dev/null || true
        snap install anbox --classic 2>/dev/null || echo "⚠️  فشل تثبيت Anbox"
    }
fi

# إنشاء مجلدات Android
echo "📁 إنشاء مجلدات Android..."
mkdir -p /opt/custom-os/android/apks
mkdir -p /opt/custom-os/android/apps
mkdir -p /home/${SUDO_USER}/.local/share/waydroid 2>/dev/null || true

# إنشاء ملف README
cat > /opt/custom-os/android/README.md << 'EOF'
# دعم تطبيقات Android على نظام Ubuntu المخصص
# Android APK Support on Custom Ubuntu OS

## تثبيت تطبيق Android:

### باستخدام Waydroid:
```bash
# تهيئة Waydroid
waydroid init

# بدء جلسة Waydroid
waydroid session start

# تثبيت تطبيق APK
waydroid app install /path/to/app.apk

# تشغيل تطبيق
waydroid app launch com.package.name

# إيقاف Waydroid
waydroid session stop
```

### باستخدام Anbox:
```bash
# تثبيت تطبيق
adb install /path/to/app.apk

# قائمة التطبيقات المثبتة
adb shell pm list packages
```

## المتطلبات:
- Ubuntu 22.04 أو أحدث
- 2GB RAM على الأقل (موصى به 4GB)
- 5GB مساحة حرة لـ Waydroid

## الميزات:
- تثبيت وتشغيل تطبيقات Android الأصلية
- الوصول الكامل إلى Google Play Store
- الإشعارات والتكاملات
- معالج ملفات يدعم سحب وإفلات

## استكشاف الأخطاء:
1. تأكد من تثبيت Waydroid بشكل صحيح
2. قد تحتاج إلى إعادة تشغيل النظام
3. تحقق من اتصال الإنترنت

---
آخر تحديث: 2026-09-26
EOF

chown -R ${SUDO_USER}:${SUDO_USER} /opt/custom-os/android

# إنشاء اختصار سطح المكتب
cat > /usr/share/applications/waydroid.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Waydroid
Comment=Run Android apps on Ubuntu
Exec=waydroid session start
Icon=android
Categories=Utility;
Terminal=false
EOF

echo ""
echo -e "✅ تم تثبيت دعم Android APK"
echo ""
echo "📋 الخطوات التالية:"
echo "1. أعد تشغيل النظام"
echo "2. شغل: waydroid init"
echo "3. شغل: waydroid session start"
echo "4. ثبت التطبيقات: waydroid app install app.apk"
echo ""
