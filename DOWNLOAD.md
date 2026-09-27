# 📥 دليل التحميل والتثبيت
# Download and Installation Guide

## 🔗 روابط التحميل المباشر

### الملف الرئيسي
- **اسم الملف:** `custom-ubuntu-os.iso`
- **الحجم:** ~2.5 GB
- **نوع النظام:** Live ISO قابل للتشغيل والتثبيت
- **المسار:** `/output/custom-ubuntu-os.iso`

## 💾 تحميل الملف

### الطريقة 1: من الجهاز المحلي
```bash
cd /path/to/custom-ubuntu-os
ls -lh output/custom-ubuntu-os.iso
```

### الطريقة 2: عبر GitHub
```bash
# انسخ المشروع
git clone https://github.com/wassim292uw/custom-ubuntu-os.git
cd custom-ubuntu-os

# بناء النظام
sudo bash build-iso.sh

# سيجد الملف في
ls -lh output/custom-ubuntu-os.iso
```

### الطريقة 3: التحميل المباشر
- سيتم توفير رابط مباشر بعد نشر الإصدارة الأولى

---

## 🔧 متطلبات البناء

### النظام المطلوب
- **OS:** Ubuntu 22.04 LTS أو Debian 11+
- **RAM:** 4 GB على الأقل (8 GB موصى به)
- **Storage:** 50 GB مساحة حرة
- **CPU:** Dual-core بحد أدنى

### البرامج المطلوبة
```bash
sudo apt-get update
sudo apt-get install -y \
    debootstrap \
    xorriso \
    grub-pc \
    grub-efi-amd64 \
    squashfs-tools \
    mtools \
    bc
```

---

## 🚀 خطوات البناء من الصفر

### 1. تحضير البيئة
```bash
# تنزيل المشروع
git clone https://github.com/wassim292uw/custom-ubuntu-os.git
cd custom-ubuntu-os

# جعل السكريبتات قابلة للتنفيذ
chmod +x build-iso.sh chroot-build.sh
```

### 2. بناء ISO
```bash
# تشغيل البناء (قد يستغرق 45-90 دقيقة)
sudo bash build-iso.sh

# ستجد الملف النهائي في:
# output/custom-ubuntu-os.iso
```

### 3. التحقق من الملف
```bash
# التحقق من الحجم والوجود
ls -lh output/custom-ubuntu-os.iso

# حساب MD5 Checksum
md5sum output/custom-ubuntu-os.iso
```

---

## 🔥 حرق الملف على فلاشة USB

### المتطلبات
- فلاشة USB سعة 8 GB على الأقل
- محو البيانات (سيتم حذف كل شيء)

### الطريقة 1: dd Command (Linux/Mac)
```bash
# 1. احصل على قائمة الأجهزة
lsblk
# أو
df -h

# 2. افصل الفلاشة
sudo umount /dev/sdX*

# 3. احرق الملف (استبدل X برقم الجهاز)
sudo dd if=output/custom-ubuntu-os.iso of=/dev/sdX bs=4M status=progress

# 4. تزامن البيانات
sync

# 5. استخرج الفلاشة
sudo eject /dev/sdX
```

### الطريقة 2: GNOME Disks (GUI)
1. افتح **GNOME Disks**
2. اختر الفلاشة من القائمة اليسرى
3. اضغط الثلاث نقاط (⋮) → **Restore Disk Image**
4. اختر ملف `custom-ubuntu-os.iso`
5. اضغط **Start Restoring**
6. انتظر حتى ينتهي

### الطريقة 3: Balena Etcher (الأفضل)
1. حمل [Balena Etcher](https://www.balena.io/etcher/)
2. افتح البرنامج
3. اختر **Flash from file** → `custom-ubuntu-os.iso`
4. اختر الفلاشة
5. اضغط **Flash**

### الطريقة 4: Rufus (Windows)
1. حمل [Rufus](https://rufus.ie/)
2. اختر الفلاشة
3. اختر ملف ISO
4. اضغط **Start**

---

## 💻 تثبيت النظام على الحاسوب

### الإعدادات المسبقة
1. **أدخل الفلاشة USB** في المنفذ
2. **أعد تشغيل الكمبيوتر**
3. **اضغط F12 / F2 / Del** أثناء الإقلاع (يختلف حسب المصنع)
4. **اختر USB كخيار الإقلاع الأول**
5. **اضغط Enter**

### خطوات التثبيت
1. **اختر** "Custom Ubuntu OS (Install)" من القائمة
2. **انتظر** حتى يقلع النظام (2-3 دقائق)
3. **انقر** على أيقونة "Install" على سطح المكتب
4. **اتبع** خطوات المثبت:
   - اختر اللغة والموقع
   - اختر القرص (احذر من اختيار القرص الخاطئ!)
   - اختر نوع التثبيت (擦除 أو ثنائي التمهيد)
   - أنشئ حساب مستخدم
   - انتظر حتى ينتهي التثبيت (10-20 دقيقة)
5. **أعد التشغيل**
6. **أخرج الفلاشة** عند الطلب

---

## 🎨 التخصيص بعد التثبيت

### تغيير اسم النظام
```bash
# تعديل os-release
sudo nano /etc/os-release

# تعديل lsb-release
sudo nano /etc/lsb-release

# تعديل hostname
sudo hostnamectl set-hostname "My Custom OS"
```

### تثبيت تطبيقات إضافية
```bash
sudo apt-get update
sudo apt-get install -y \
    vlc \
    gimp \
    blender \
    code  # Visual Studio Code
```

### تغيير الثيم والخلفية
```bash
# افتح إعدادات XFCE
xfce4-settings-manager
```

### استخدام تطبيقات Android
```bash
# تهيئة Waydroid
waydroid init
waydroid session start

# تثبيت تطبيق
waydroid app install /path/to/app.apk
```

---

## 🐛 استكشاف الأخطاء

### المشكلة: الفلاشة لا تقلع
**الحل:**
1. جرب حرق الملف مرة أخرى
2. استخدم Balena Etcher بدلاً من dd
3. تأكد من أن BIOS يدعم USB boot
4. جرب منفذ USB آخر

### المشكلة: الشاشة سوداء بعد الإقلاع
**الحل:**
1. اختر "Safe Mode" من قائمة GRUB
2. أضف `nomodeset` لتعطيل GPU acceleration
3. جرب بدون الرسومات أولاً

### المشكلة: بطء التثبيت
**الحل:**
1. تأكد من سرعة اتصال الإنترنت
2. جرب مرآة مختلفة لـ apt repository
3. قد يستغرق على الأقراص الميكانيكية وقتاً أطول

### المشكلة: Waydroid لا يعمل
**الحل:**
```bash
# أعد التهيئة
waydroid init --system-only
waydroid session start

# أو استخدم Anbox بدلاً منه
sudo apt-get install anbox
```

---

## 📊 معلومات إضافية

### الميزات الرئيسية
- ✅ Live ISO قابل للتشغيل المباشر
- ✅ مثبت تفاعلي سهل
- ✅ دعم BIOS و UEFI
- ✅ واجهة رسومية XFCE4
- ✅ دعم تطبيقات Android عبر Waydroid
- ✅ متصفحات Firefox و Chromium
- ✅ تطبيقات إنتاجية (LibreOffice، Thunderbird)
- ✅ أدوات تطوير (Python، Node.js، Git)

### المتطلبات الدنيا للتشغيل
- CPU: 1 GHz (Dual-core موصى به)
- RAM: 512 MB (1 GB موصى به)
- Storage: 20 GB (للتثبيت الكامل)
- Display: 1024x768 (1920x1080 موصى به)

### الدعم والمساعدة
- 📧 البريد: wassimgamer346@gmail.com
- 🐙 GitHub: https://github.com/wassim292uw/custom-ubuntu-os
- 💬 Discussions: GitHub Discussions
- 🐛 Issues: للإبلاغ عن الأخطاء

---

**آخر تحديث:** 2026-09-27
**الإصدارة:** 1.0.0
**الحالة:** جاهز للاستخدام ✅
