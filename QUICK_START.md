# 🚀 دليل البدء السريع
# Quick Start Guide

## 📥 تحميل النظام من GitHub

```bash
git clone https://github.com/wassim292uw/custom-ubuntu-os.git
cd custom-ubuntu-os
```

**رابط المستودع:**
- GitHub: https://github.com/wassim292uw/custom-ubuntu-os
- ISO مباشر: [سيتم توليده بعد البناء]

---

## 🔨 بناء الـ ISO من الصفر

### المتطلبات:
- نظام Linux (Ubuntu/Debian)
- صلاحيات root/sudo
- 30 GB مساحة حرة
- اتصال إنترنت

### المتطلبات البرمجية:
```bash
sudo apt-get update
sudo apt-get install -y \
    debootstrap \
    xorriso \
    grub-pc \
    grub-efi-amd64 \
    squashfs-tools \
    mtools
```

### خطوات البناء:

**1. تنزيل المشروع:**
```bash
git clone https://github.com/wassim292uw/custom-ubuntu-os.git
cd custom-ubuntu-os
chmod +x build.sh chroot_script.sh
```

**2. بناء الـ ISO (هذا سيستغرق 20-40 دقيقة):**
```bash
sudo bash build.sh
```

**3. الملف النهائي:**
```bash
ls -lh custom-ubuntu-os.iso
```

---

## 💾 حرق النظام على فلاشة USB

### الطريقة 1: باستخدام dd
```bash
# قائمة الأجهزة
df -h | grep -E "/dev/sd"
lsblk

# تحديد الجهاز (مثلاً /dev/sdb)
sudo umount /dev/sdb*
sudo dd if=custom-ubuntu-os.iso of=/dev/sdb bs=4M status=progress
sync
```

### الطريقة 2: باستخدام GNOME Disks
1. فتح GNOME Disks
2. اختيار الفلاشة USB
3. Restore Disk Image
4. اختيار `custom-ubuntu-os.iso`

### الطريقة 3: Etcher (الأسهل)
```bash
# تحميل Etcher
wget https://github.com/balena-io/etcher/releases/download/v1.18.11/balena-etcher-1.18.11-x64.zip

# فتح البرنامج وحرق الـ ISO
```

---

## 🖥️ تثبيت النظام على الحاسوب

### من الفلاشة USB:
1. أدخل الفلاشة USB
2. أعد تشغيل الكمبيوتر
3. اضغط F12 أو Del للدخول لـ Boot Menu
4. اختر USB كخيار الإقلاع الأول
5. انتظر حتى تصل لسطح المكتب
6. انقر على "Install"
7. اتبع خطوات المثبت

---

## 📱 استخدام تطبيقات Android

### تهيئة Waydroid:
```bash
# تثبيت الأدوات
sudo apt-get install waydroid

# تهيئة البيئة
waydroid init

# بدء الجلسة
waydroid session start
```

### تثبيت تطبيق APK:
```bash
# تثبيت من ملف
waydroid app install /path/to/app.apk

# تثبيت من Play Store
waydroid app launch com.example.app
```

---

## 🎨 تخصيص النظام

### تغيير الثيم والخلفية:
```bash
# فتح الإعدادات
xfce4-settings-manager
```

### تثبيت تطبيقات إضافية:
```bash
sudo apt-get install -y \
    vlc \
    gimp \
    blender \
    audacity
```

---

## 📊 عرض معلومات النظام

```bash
# معلومات شاملة
bash system-info.sh

# معلومات سريعة
neofetch
uname -a
```

---

## 🔗 الروابط المهمة

| الملف | الرابط |
|------|--------|
| المستودع | https://github.com/wassim292uw/custom-ubuntu-os |
| التحميل المباشر | [يتم التحديث] |
| الوثائق | [في المستودع] |
| الدعم | GitHub Issues |

---

## ❓ الأسئلة الشائعة

**س: كم حجم الـ ISO؟**
ج: حوالي 2-3 GB (يختلف حسب التطبيقات المثبتة)

**س: هل يعمل على الأنظمة القديمة؟**
ج: نعم، يدعم BIOS و UEFI

**س: هل يمكن تثبيته على محرك أقراص بطيء؟**
ج: نعم، لكنه قد يستغرق وقتاً أطول

---

## 📞 التواصل والدعم

- GitHub Issues: https://github.com/wassim292uw/custom-ubuntu-os/issues
- Discussions: https://github.com/wassim292uw/custom-ubuntu-os/discussions
- Email: wassimgamer346@gmail.com

---

**آخر تحديث:** 2026-09-27
