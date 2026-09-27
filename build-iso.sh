#!/bin/bash

# ============================================
# Complete ISO Build System - كامل النظام
# نظام بناء ISO الشامل والقابل للتحميل
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Custom Ubuntu OS - ISO Build & Download System         ║"
echo "║   نظام بناء ISO قابل للتحميل على الكمبيوتر               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Configuration
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${BASE_DIR}/build-workspace"
ROOTFS_DIR="${WORK_DIR}/rootfs"
ISO_ROOT_DIR="${WORK_DIR}/iso_root"
OUTPUT_DIR="${BASE_DIR}/output"
OUTPUT_ISO="${OUTPUT_DIR}/custom-ubuntu-os.iso"
UBUNTU_VERSION="jammy"
ARCHITECTURE="amd64"

# Custom OS Info
OS_NAME="Custom Ubuntu OS"
OS_VERSION="1.0.0"
OS_CODENAME="Custom Edition"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📋 معلومات النظام:${NC}"
echo -e "  اسم النظام: ${YELLOW}${OS_NAME}${NC}"
echo -e "  النسخة: ${YELLOW}${OS_VERSION}${NC}"
echo -e "  الإصدارة الأساسية: ${YELLOW}Ubuntu ${UBUNTU_VERSION}${NC}"
echo -e "  المعمارية: ${YELLOW}${ARCHITECTURE}${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ يجب تشغيل هذا البرنامج بصلاحيات root (sudo)${NC}"
    echo "Run: sudo bash build-iso.sh"
    exit 1
fi

# Check prerequisites
echo -e "${YELLOW}[1/12] التحقق من المتطلبات...${NC}"
for cmd in debootstrap xorriso grub-mkrescue mksquashfs; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}❌ $cmd غير مثبت${NC}"
        echo "Install with: sudo apt-get install -y $cmd"
        exit 1
    fi
done
echo -e "${GREEN}✓ جميع المتطلبات موجودة${NC}"
echo ""

# Cleanup and prepare
echo -e "${YELLOW}[2/12] تنظيف وتحضير المجلدات...${NC}"
rm -rf "$WORK_DIR" "$OUTPUT_DIR"
mkdir -p "$ROOTFS_DIR" "$OUTPUT_DIR"
mkdir -p "$ISO_ROOT_DIR"/{boot/{grub,isolinux,EFI/BOOT},casper,preseed}
echo -e "${GREEN}✓ تم التحضير${NC}"
echo ""

# Bootstrap
echo -e "${YELLOW}[3/12] تنزيل وتثبيت نظام الملفات الأساسي (قد يستغرق 10-15 دقيقة)...${NC}"
debootstrap --arch=$ARCHITECTURE --variant=minbase --include=ubuntu-standard $UBUNTU_VERSION "$ROOTFS_DIR" http://archive.ubuntu.com/ubuntu/
echo -e "${GREEN}✓ تم التنزيل والتثبيت${NC}"
echo ""

# Copy customization scripts
echo -e "${YELLOW}[4/12] نسخ ملفات التخصيص...${NC}"
cp "${BASE_DIR}/chroot-build.sh" "$ROOTFS_DIR/tmp/"
cp "${BASE_DIR}/config/os-release-template" "$ROOTFS_DIR/tmp/"
cp "${BASE_DIR}/config/lsb-release-template" "$ROOTFS_DIR/tmp/" 2>/dev/null || true
chmod +x "$ROOTFS_DIR/tmp/chroot-build.sh"
echo -e "${GREEN}✓ تم النسخ${NC}"
echo ""

# Mount essential filesystems for chroot
echo -e "${YELLOW}[5/12] ربط المجلدات الحيوية...${NC}"
for dir in dev dev/pts proc sys run; do
    mkdir -p "$ROOTFS_DIR/$dir"
    mount -B /$dir "$ROOTFS_DIR/$dir" 2>/dev/null || true
done
echo -e "${GREEN}✓ تم الربط${NC}"
echo ""

# Execute chroot build script
echo -e "${YELLOW}[6/12] تنفيذ التهيئة الداخلية (قد يستغرق 15-30 دقيقة)...${NC}"
echo "  تثبيت الحزم والتطبيقات والواجهة الرسومية..."
chroot "$ROOTFS_DIR" bash /tmp/chroot-build.sh "$OS_NAME" "$OS_VERSION"
echo -e "${GREEN}✓ تمت التهيئة${NC}"
echo ""

# Cleanup chroot
echo -e "${YELLOW}[7/12] فصل المجلدات...${NC}"
for dir in run sys proc dev/pts dev; do
    umount -l "$ROOTFS_DIR/$dir" 2>/dev/null || true
done
echo -e "${GREEN}✓ تم الفصل${NC}"
echo ""

# Create filesystem manifest
echo -e "${YELLOW}[8/12] إنشاء قائمة النظام...${NC}"
chroot "$ROOTFS_DIR" dpkg-query -W --showformat='${Package} ${Version}\\n' > "$ISO_ROOT_DIR/casper/filesystem.manifest"
cp "$ISO_ROOT_DIR/casper/filesystem.manifest" "$ISO_ROOT_DIR/casper/filesystem.manifest-desktop"
echo -e "${GREEN}✓ تم الإنشاء${NC}"
echo ""

# Create squashfs
echo -e "${YELLOW}[9/12] ضغط نظام الملفات (قد يستغرق 10-20 دقيقة)...${NC}"
echo "  هذه خطوة حرجة... الرجاء عدم إيقاف البرنامج"
mksquashfs "$ROOTFS_DIR" "$ISO_ROOT_DIR/casper/filesystem.squashfs" \
    -e "proc" -e "sys" -e "dev" -e "tmp/*" -e "var/cache/apt/*" \
    -comp xz -wildcards -progress 2>&1 | tail -20
echo -e "${GREEN}✓ تم الضغط${NC}"
echo ""

# Get filesystem size
FILESYSTEM_SIZE=$(du -s "$ROOTFS_DIR" | cut -f1)
echo "$FILESYSTEM_SIZE" > "$ISO_ROOT_DIR/casper/filesystem.size"

# Copy kernel and initrd
echo -e "${YELLOW}[10/12] نسخ نواة النظام وملفات الإقلاع...${NC}"
KERNEL=$(ls -1t "$ROOTFS_DIR/boot/vmlinuz-"* 2>/dev/null | head -1)
INITRD=$(ls -1t "$ROOTFS_DIR/boot/initrd.img-"* 2>/dev/null | head -1)

if [ -f "$KERNEL" ] && [ -f "$INITRD" ]; then
    cp "$KERNEL" "$ISO_ROOT_DIR/casper/vmlinuz"
    cp "$INITRD" "$ISO_ROOT_DIR/casper/initrd.img"
    echo -e "${GREEN}✓ تم النسخ${NC}"
else
    echo -e "${RED}⚠️ تحذير: لم يتم العثور على vmlinuz أو initrd${NC}"
fi
echo ""

# Copy boot files
echo -e "${YELLOW}[11/12] نسخ ملفات الإقلاع والتكوين...${NC}"
cp "${BASE_DIR}/config/grub.cfg" "$ISO_ROOT_DIR/boot/grub/"
cp "${BASE_DIR}/config/isolinux.cfg" "$ISO_ROOT_DIR/boot/isolinux/" 2>/dev/null || true

# Create MD5 checksum
cd "$ISO_ROOT_DIR"
find . -type f -exec md5sum {} \; > md5sum.txt
cd "$BASE_DIR"

echo -e "${GREEN}✓ تم النسخ${NC}"
echo ""

# Build ISO
echo -e "${YELLOW}[12/12] بناء صورة ISO النهائية (قد يستغرق 5-10 دقائق)...${NC}"
echo "  إنشاء ملف قابل للتحميل والحرق على USB..."

grub-mkrescue -o "$OUTPUT_ISO" "$ISO_ROOT_DIR/" 2>&1 | grep -v "warning" || true

if [ -f "$OUTPUT_ISO" ]; then
    echo -e "${GREEN}✓ تم البناء بنجاح${NC}"
else
    echo -e "${RED}❌ فشل بناء ISO${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗"
echo "║        ✅ تم بناء النظام بنجاح - Ready for Download!        ║"
echo "╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Show file info
echo -e "${BLUE}📊 معلومات الملف النهائي:${NC}"
ls -lh "$OUTPUT_ISO"
echo ""

# Generate download link
echo -e "${BLUE}📥 رابط التحميل:${NC}"
echo -e "${YELLOW}File: ${OUTPUT_ISO}${NC}"
echo -e "Size: $(du -h "$OUTPUT_ISO" | cut -f1)"
echo -e "MD5: $(md5sum "$OUTPUT_ISO" | awk '{print $1}')"
echo ""

# Show USB burning instructions
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🔥 خطوات حرق النظام على فلاشة USB:${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}الطريقة 1: استخدام dd${NC}"
echo "  1. حدد الفلاشة: lsblk أو df -h"
echo "  2. افصل الفلاشة: sudo umount /dev/sdX*"
echo "  3. احرق الملف:"
echo -e "     ${GREEN}sudo dd if=${OUTPUT_ISO} of=/dev/sdX bs=4M status=progress${NC}"
echo "  4. استخرج الفلاشة: sudo eject /dev/sdX"
echo ""
echo -e "${YELLOW}الطريقة 2: استخدام GNOME Disks (أسهل)${NC}"
echo "  1. افتح GNOME Disks"
echo "  2. حدد الفلاشة"
echo "  3. اختر 'Restore Disk Image'"
echo "  4. اختر الملف ISO"
echo ""
echo -e "${YELLOW}الطريقة 3: استخدام Etcher${NC}"
echo "  1. حمل Balena Etcher"
echo "  2. افتح البرنامج"
echo "  3. اختر الملف ISO"
echo "  4. اختر الفلاشة"
echo "  5. اضغط Flash"
echo ""

# Show installation instructions
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}💻 خطوات التثبيت على الحاسوب:${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "1️⃣  أدخل الفلاشة في الكمبيوتر"
echo "2️⃣  أعد التشغيل"
echo "3️⃣  اضغط F12 أو Del أثناء الإقلاع"
echo "4️⃣  اختر USB كخيار الإقلاع الأول"
echo "5️⃣  اضغط Enter لتشغيل Live System"
echo "6️⃣  اختر Install من سطح المكتب"
echo "7️⃣  اتبع خطوات المثبت"
echo ""

echo -e "${GREEN}✅ النظام جاهز للتحميل والتثبيت!${NC}"
echo ""
