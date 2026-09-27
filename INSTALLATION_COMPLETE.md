# 📥 شرح التحميل والتثبيت - ملف ISO جاهز للتحميل

## 🎯 ما تريده بالضبط:

### ✅ ملف ISO قابل للتحميل المباشر
```
حجم الملف: ~2.5 GB
اسم الملف: custom-ubuntu-os-1.0.0.iso
صيغة: ISO 9660 (قابل للحرق على USB)
```

---

## 📌 الخيار 1: تحميل ملف ISO جاهز (الأسهل)

### أين تجد الملف؟

**رابط التحميل المباشر:**
```
https://github.com/wassim292uw/custom-ubuntu-os/releases/download/v1.0.0/custom-ubuntu-os-1.0.0.iso
```

### خطوات التحميل:

1. **اضغط على الرابط أعلاه** ⬇️
2. **سيبدأ التحميل تلقائياً**
3. **انتظر حتى ينتهي التحميل** (قد يستغرق 5-30 دقيقة حسب سرعة الإنترنت)
4. **الملف سيكون في مجلد "Downloads"**

```
/Users/username/Downloads/custom-ubuntu-os-1.0.0.iso
أو
C:\\Users\\username\\Downloads\\custom-ubuntu-os-1.0.0.iso
```

---

## 📌 الخيار 2: بناء ISO من الصفر (للمتقدمين)

### المتطلبات:
- جهاز كمبيوتر يعمل بـ **Ubuntu 22.04 LTS** أو **Debian 11+**
- صلاحيات **sudo/root**
- **50 GB** مساحة حرة
- **4 GB RAM** على الأقل

### الخطوات:

#### 1️⃣ تحضير البيئة
```bash
# تثبيت البرامج المطلوبة
sudo apt-get update
sudo apt-get install -y debootstrap xorriso grub-pc grub-efi-amd64 squashfs-tools mtools

# تنزيل المشروع
git clone https://github.com/wassim292uw/custom-ubuntu-os.git
cd custom-ubuntu-os

# جعل السكريبتات قابلة للتنفيذ
chmod +x build-iso.sh chroot-build.sh
```

#### 2️⃣ بناء ISO (يستغرق 45-90 دقيقة)
```bash
# ابدأ البناء
sudo bash build-iso.sh

# سيظهر التقدم في الشاشة
# انتظر حتى ينتهي البناء
```

#### 3️⃣ الملف النهائي
```bash
# سيكون في
output/custom-ubuntu-os-1.0.0.iso

# تحقق من الحجم
ls -lh output/custom-ubuntu-os-1.0.0.iso
```

---

## 🔥 حرق ملف ISO على فلاشة USB

### الخطوة 1: احصل على الملف
```
ملف ISO من التحميل أعلاه
حجم: ~2.5 GB
```

### الخطوة 2: حرق الملف

#### الطريقة الأولى: **Balena Etcher** (الأسهل)

1. **حمل Balena Etcher:**
   - اذهب إلى: https://www.balena.io/etcher/
   - اختر نظامك (Windows/Mac/Linux)
   - حمل واثبت البرنامج

2. **استخدم البرنامج:**
   ```
   1. فتح Balena Etcher
   2. اضغط "Flash from file"
   3. اختر ملف custom-ubuntu-os-1.0.0.iso
   4. اختر فلاشتك USB (احذر - سيحذف كل البيانات!)
   5. اضغط "Flash"
   6. انتظر حتى ينتهي
   ```

#### الطريقة الثانية: **GNOME Disks** (Linux)

```bash
# فتح GNOME Disks من التطبيقات

# أو من الطرفية:
gnome-disks

# ثم:
# 1. اختر الفلاشة من اليسار
# 2. اضغط القائمة (⋮)
# 3. اختر "Restore Disk Image"
# 4. اختر الملف ISO
# 5. اضغط "Start Restoring"
```

#### الطريقة الثالثة: **dd Command** (Linux/Mac - خطر!)

```bash
# تحذير: تأكد من اختيار الجهاز الصحيح!

# 1. احصل على قائمة الأجهزة
lsblk
# أو
df -h

# 2. افصل الفلاشة
sudo umount /dev/sdX*
# (استبدل X برقم جهازك مثل b أو c)

# 3. احرق الملف
sudo dd if=custom-ubuntu-os-1.0.0.iso of=/dev/sdX bs=4M status=progress

# 4. انتظر حتى ينتهي ثم:
sync

# 5. استخرج الفلاشة
sudo eject /dev/sdX
```

#### الطريقة الرابعة: **Rufus** (Windows)

```
1. حمل Rufus من: https://rufus.ie/
2. افتح Rufus
3. اختر الفلاشة USB
4. اختر ملف ISO
5. اضغط "Start"
6. انتظر حتى ينتهي
```

---

## 💻 تشغيل النظام على الكمبيوتر

### الخطوة 1: تحضير الكمبيوتر
```
1. أدخل فلاشة USB في منفذ USB
2. أعد تشغيل الكمبيوتر
3. أثناء التشغيل اضغط F12 أو F2 أو Delete
   (يختلف حسب الشركة المصنعة)
```

### الخطوة 2: تغيير ترتيب الإقلاع
```
1. اختر Boot Options أو Boot Order
2. ضع USB في المقام الأول
3. احفظ الإعدادات واخرج
4. سيقلع من USB
```

### الخطوة 3: قائمة الإقلاع
```
عندما يظهر:
  ✓ Custom Ubuntu OS (Live)
  ○ Custom Ubuntu OS (Install)
  ○ Safe Mode
  ○ Boot from Hard Disk

اختر الخيار الأول واضغط Enter
```

### الخطوة 4: الانتظا�� والتشغيل
```
1. الشاشة قد تكون سوداء لمدة 1-2 دقيقة (عادي)
2. سيظهر شعار النظام
3. سيقلع سطح المكتب (2-3 دقائق)
4. سيظهر شاشة التسجيل (LightDM)

بيانات الدخول الافتراضية:
Username: custom
Password: custom

أو
Username: root
Password: root
```

---

## 💾 تثبيت النظام على القرص الصلب

### بعد ظهور سطح المكتب:

```
1. اضغط على أيقونة "Install" على سطح المكتب
2. اختر اللغة والموقع
3. اختر القرص الصلب (احذر - سيمسح كل البيانات!)
4. اختر نوع التثبيت:
   - Erase Disk (أسهل)
   - Custom Partitioning (متقدم)
5. أنشئ حساب مستخدم
6. انتظر حتى ينتهي التثبيت (10-20 دقيقة)
7. أعد التشغيل عند الطلب
8. أخرج الفلاشة عند الطلب
```

---

## 🎨 تخصيص النظام بعد التثبيت

### تغيير اسم النظام
```bash
# تعديل اسم النظام
sudo nano /etc/os-release

# غير:
# NAME="Custom Ubuntu OS"
# إلى اسمك

# احفظ بـ Ctrl+O ثم Enter ثم Ctrl+X
```

### تغيير اسم الكمبيوتر
```bash
sudo hostnamectl set-hostname "My-Custom-OS"
```

### تثبيت تطبيقات إضافية
```bash
sudo apt-get install -y \
    vlc \
    gimp \
    blender \
    audacity
```

### تشغيل تطبيقات Android
```bash
# تهيئة Waydroid
waydroid init
waydroid session start

# تثبيت تطبيق
waydroid app install ~/Downloads/app.apk
```

---

## ⚠️ استكشاف الأخطاء

### المشكلة: الفلاشة لا تقلع
**الحل:**
```
1. تأكد من اختيار USB في Boot Menu
2. جرب منفذ USB آخر
3. جرب Balena Etcher بدل dd
4. تأكد من أن BIOS يدعم USB Boot
5. جرب تحديث BIOS
```

### المشكلة: الشاشة سوداء بعد الإقلاع
**الحل:**
```
1. اختر "Safe Mode" من قائمة GRUB
2. أضف nomodeset لتعطيل GPU
3. جرب monitor مختلف
4. استخدم مفتاح HDMI مختلف
```

### المشكلة: بطء التثبيت
**الحل:**
```
1. تأكد من سرعة الإنترنت
2. استخدم مرآة Ubuntu أقرب
3. جرب تثبيت بدون اتصال إنترنت (Offline Install)
```

---

## 📊 معلومات النظام

### الميزات:
- ✅ Live ISO قابل للتشغيل المباشر
- ✅ مثبت تفاعلي سهل
- ✅ دعم BIOS و UEFI
- ✅ واجهة XFCE4 خفيفة
- ✅ متصفحات Firefox و Chromium
- ✅ LibreOffice و Thunderbird
- ✅ VLC و GIMP و Audacious
- ✅ Python و Node.js و Git
- ✅ Waydroid لتطبيقات Android

### الحد الأدنى للمتطلبات:
- CPU: 1 GHz (Dual-core موصى به)
- RAM: 512 MB (1 GB موصى به)
- Storage: 20 GB (للتثبيت الكامل)
- USB: 8 GB (للـ Live)

---

## 🔗 الروابط المهمة

| الخدمة | الرابط |
|--------|--------|
| **تحميل ISO** | https://github.com/wassim292uw/custom-ubuntu-os/releases |
| **المستودع** | https://github.com/wassim292uw/custom-ubuntu-os |
| **Balena Etcher** | https://www.balena.io/etcher/ |
| **Rufus** | https://rufus.ie/ |
| **Ubuntu Docs** | https://help.ubuntu.com |

---

## 💡 نصائح مهمة

1. **أثناء الحرق:**
   - لا تقطع الاتصال أو تفصل الفلاشة
   - استخدم منفذ USB 3.0 إن أمكن (أسرع)
   - تأكد من 8 GB مساحة فارغة على الفلاشة

2. **أثناء التثبيت:**
   - احفظ نسخة من البيانات المهمة
   - استخدم اتصال إنترنت مستقر
   - لا تطفئ الكمبيوتر أثناء التثبيت

3. **بعد التثبيت:**
   - حدّث النظام: `sudo apt-get update && sudo apt-get upgrade`
   - ثبّت التعريفات: `ubuntu-drivers autoinstall`
   - استخدم Timeshift للنسخ الاحتياطية

---

## 📞 الدعم والمساعدة

- 🐛 **الإبلاغ عن الأخطاء:** https://github.com/wassim292uw/custom-ubuntu-os/issues
- 💬 **النقاش:** https://github.com/wassim292uw/custom-ubuntu-os/discussions
- 📧 **البريد:** wassimgamer346@gmail.com

---

**آخر تحديث:** 2026-09-27
**الإصدار:** 1.0.0
**الحالة:** جاهز للاستخدام ✅
