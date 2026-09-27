#!/bin/bash

# ============================================
# Burn Custom OS to USB Drive
# حرق نظام التشغيل المخصص على فلاشة USB
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║    حرق نظام التشغيل المخصص على فلاشة USB              ║"
echo "║           Burn Custom OS to USB Drive                  ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# التحقق من صلاحيات المسؤول
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ يجب تشغيل هذا السكريبت بصلاحيات sudo${NC}"
    echo "Run: sudo bash burn-to-usb.sh /dev/sdX"
    exit 1
fi

# التحقق من المعاملات
if [ -z "$1" ]; then
    echo -e "${YELLOW}❌ الرجاء تحديد جهاز USB${NC}"
    echo ""
    echo -e "${BLUE}الاستخدام:${NC}"
    echo "  sudo bash burn-to-usb.sh /dev/sdX"
    echo ""
    echo -e "${BLUE}أجهزة USB المتاحة:${NC}"
    lsblk -d -o NAME,SIZE,TYPE | grep disk
    echo ""
    echo -e "${RED}⚠️  تحذير: تأكد من اختيار الجهاز الصحيح!${NC}"
    echo "استخدام الجهاز الخاطئ قد يؤدي لفقدان البيانات"
    exit 1
fi

DEVICE=$1
DEVICE_NAME=$(basename "$DEVICE")

# التحقق من وجود الجهاز
if [ ! -b "$DEVICE" ]; then
    echo -e "${RED}❌ الجهاز $DEVICE غير موجود${NC}"
    exit 1
fi

# عرض معلومات الجهاز
echo -e "${YELLOW}معلومات الجهاز:${NC}"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT "$DEVICE" 2>/dev/null || true
echo ""

# تحذير نهائي
echo -e "${RED}⚠️  تحذير حرج!${NC}"
echo -e "سيتم حذف جميع البيانات على الجهاز: ${YELLOW}$DEVICE${NC}"
echo -e "هذا الإجراء لا يمكن التراجع عنه!${NC}"
echo ""

read -p "هل أنت متأكد من اختيار الجهاز الصحيح؟ (اكتب 'نعم' للمتابعة): " CONFIRM

if [ "$CONFIRM" != "نعم" ] && [ "$CONFIRM" != "yes" ] && [ "$CONFIRM" != "y" ]; then
    echo -e "${BLUE}تم الإلغاء${NC}"
    exit 0
fi

# البحث عن ملف ISO
echo -e "${YELLOW}🔍 البحث عن ملف Ubuntu ISO...${NC}"

ISO_FILE=""

# البحث في المجلدات الشائعة
if [ -f "ubuntu-latest.iso" ]; then
    ISO_FILE="ubuntu-latest.iso"
elif [ -f "ubuntu-22.04-desktop-amd64.iso" ]; then
    ISO_FILE="ubuntu-22.04-desktop-amd64.iso"
elif [ -f "$HOME/ubuntu.iso" ]; then
    ISO_FILE="$HOME/ubuntu.iso"
elif [ -f "$HOME/Downloads/ubuntu-22.04-desktop-amd64.iso" ]; then
    ISO_FILE="$HOME/Downloads/ubuntu-22.04-desktop-amd64.iso"
else
    # البحث عن أي ملف ISO
    if ls *.iso 1> /dev/null 2>&1; then
        ISO_FILE=$(ls *.iso | head -n1)
    fi
fi

if [ -z "$ISO_FILE" ] || [ ! -f "$ISO_FILE" ]; then
    echo -e "${RED}❌ لم يتم العثور على ملف Ubuntu ISO${NC}"
    echo ""
    echo -e "${BLUE}الحل:${NC}"
    echo "1. قم بتنزيل Ubuntu Desktop من:"
    echo -e "   ${YELLOW}https://ubuntu.com/download/desktop${NC}"
    echo ""
    echo "2. ضع الملف في نفس المجلد:"
    echo -e "   ${YELLOW}$(pwd)${NC}"
    echo ""
    echo "3. أعد تشغيل السكريبت:"
    echo -e "   ${YELLOW}sudo bash burn-to-usb.sh $DEVICE${NC}"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ وجد: ${YELLOW}$ISO_FILE${NC}"
echo ""

# حساب حجم الملف
SIZE=$(ls -lh "$ISO_FILE" | awk '{print $5}')
echo -e "${BLUE}📊 معلومات الملف:${NC}"
echo "  الملف: $ISO_FILE"
echo "  الحجم: $SIZE"
echo "  الجهاز: $DEVICE"
echo ""

# التحضير
echo -e "${YELLOW}⏳ جاري التحضير...${NC}"

# فصل الجهاز إن كان مثبتاً
echo -e "${YELLOW}فصل التركيبات...${NC}"
for partition in "${DEVICE}"*; do
    if mountpoint -q "$partition" 2>/dev/null; then
        echo "  فصل $partition..."
        umount "$partition" 2>/dev/null || true
    fi
done

# اختيار أداة الحرق
BURN_TOOL="dd"
if command -v ddrescue &> /dev/null; then
    BURN_TOOL="ddrescue"
fi

echo ""
echo -e "${YELLOW}🔥 بدء حرق الملف على USB...${NC}"
echo -e "أداة الحرق: ${YELLOW}$BURN_TOOL${NC}"
echo "هذا قد يستغرق عدة دقائق..."
echo ""

# حرق الملف
if [ "$BURN_TOOL" = "ddrescue" ]; then
    ddrescue --force --overwrite "$ISO_FILE" "$DEVICE"
else
    dd if="$ISO_FILE" of="$DEVICE" bs=4M status=progress
    sync
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗"
echo "║        ✅ تم الحرق بنجاح! Burn Completed!             ║"
echo "╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# التعليمات النهائية
echo -e "${BLUE}📋 الخطوات التالية:${NC}"
echo "1️⃣  فصل الفلاشة:"
echo -e "   ${YELLOW}sudo eject $DEVICE${NC}"
echo ""
echo "2️⃣  إعادة تشغيل الكمبيوتر واختيار USB للإقلاع"
echo ""
echo "3️⃣  اتباع خطوات تثبيت Ubuntu"
echo ""
echo "4️⃣  بعد التثبيت، شغل:"
echo -e "   ${YELLOW}sudo bash setup.sh${NC}"
echo ""

echo -e "${YELLOW}💡 نصيحة:${NC}"
echo "إذا لم يحدث الإقلاع من USB:"
echo "- اضغط F12 أو Del أثناء التشغيل"
echo "- غير ترتيب الإقلاع (Boot Order)"
echo "- ضع USB في المقام الأول"
echo ""
