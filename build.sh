#!/bin/bash

# ============================================
# Custom Ubuntu OS - ISO Build System
# نظام بناء ISO للنظام المخصص
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║     Custom Ubuntu OS - ISO Build System                ║"
echo "║         نظام بناء صورة النظام المخصص                   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Configuration
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${BASE_DIR}/build-workspace"
ROOTFS_DIR="${WORK_DIR}/rootfs"
ISO_ROOT_DIR="${WORK_DIR}/iso_root"
OUTPUT_ISO="${BASE_DIR}/custom-ubuntu-os.iso"
UBUNTU_VERSION="jammy"  # Ubuntu 22.04 LTS
ARCHITECTURE="amd64"

echo -e "${YELLOW}[تهيئة المتغيرات]${NC}"
echo "  مجلد العمل: $WORK_DIR"
echo "  نسخة Ubuntu: $UBUNTU_VERSION"
echo "  المعمارية: $ARCHITECTURE"
echo ""

# Check prerequisites
echo -e "${YELLOW}[التحقق من المتطلبات]${NC}"
for cmd in debootstrap xorriso grub-mkrescue mksquashfs; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}❌ $cmd غير مثبت${NC}"
        exit 1
    fi
done
echo -e "${GREEN}✓ جميع المتطلبات موجودة${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ يجب تشغيل البرنامج بصلاحيات root (sudo)${NC}"
    exit 1
fi

# Cleanup and prepare directories
echo -e "${YELLOW}[1/10] تنظيف وتحضير المجلدات${NC}"
rm -rf "$WORK_DIR"
mkdir -p "$ROOTFS_DIR" "$ISO_ROOT_DIR"/{boot/{grub,isolinux,EFI/BOOT},casper}
echo -e "${GREEN}✓ تم إعداد المجلدات${NC}"
echo ""

# Bootstrap Ubuntu rootfs
echo -e "${YELLOW}[2/10] تنزيل وتثبيت نظام الملفات الأساسي${NC}"
echo "  هذه قد تستغرق 5-10 دقائق..."
debootstrap --arch=$ARCHITECTURE --variant=minbase $UBUNTU_VERSION "$ROOTFS_DIR" http://archive.ubuntu.com/ubuntu/
echo -e "${GREEN}✓ تم تنزيل rootfs${NC}"
echo ""

# Copy chroot script
echo -e "${YELLOW}[3/10] نسخ سكريبت التهيئة${NC}"
cp "${BASE_DIR}/chroot_script.sh" "$ROOTFS_DIR/tmp/"
chmod +x "$ROOTFS_DIR/tmp/chroot_script.sh"
echo -e "${GREEN}✓ تم نسخ السكريبت${NC}"
echo ""

# Prepare chroot
echo -e "${YELLOW}[4/10] ربط المجلدات الحيوية${NC}"
for dir in dev dev/pts proc sys; do
    mount -B /$dir "$ROOTFS_DIR/$dir" 2>/dev/null || true
done
echo -e "${GREEN}✓ تم ربط المجلدات${NC}"
echo ""

# Execute chroot script
echo -e "${YELLOW}[5/10] تنفيذ تهيئة النظام الداخلية${NC}"
chroot "$ROOTFS_DIR" /tmp/chroot_script.sh
echo -e "${GREEN}✓ تم التهيئة${NC}"
echo ""

# Cleanup chroot
echo -e "${YELLOW}[6/10] فصل المجلدات${NC}"
for dir in dev/pts dev proc sys; do
    umount -l "$ROOTFS_DIR/$dir" 2>/dev/null || true
done
echo -e "${GREEN}✓ تم الفصل${NC}"
echo ""

# Create squashfs filesystem
echo -e "${YELLOW}[7/10] ضغط نظام الملفات${NC}"
echo "  هذا قد يستغرق 5-15 دقيقة..."
mksquashfs "$ROOTFS_DIR" "$ISO_ROOT_DIR/casper/filesystem.squashfs" -e "proc" -e "sys" -e "dev" -e "tmp/*" -comp xz
echo -e "${GREEN}✓ تم الضغط${NC}"
echo ""

# Copy kernel and initrd
echo -e "${YELLOW}[8/10] نسخ نواة النظام وملفات الإقلاع${NC}"
cp "$ROOTFS_DIR/boot/vmlinuz-"* "$ISO_ROOT_DIR/casper/vmlinuz" 2>/dev/null || echo "  تحذير: لم يتم العثور على vmlinuz"
cp "$ROOTFS_DIR/boot/initrd.img-"* "$ISO_ROOT_DIR/casper/initrd.img" 2>/dev/null || echo "  تحذير: لم يتم العثور على initrd"
echo -e "${GREEN}✓ تم نسخ ملفات الإقلاع${NC}"
echo ""

# Copy grub and boot configuration
echo -e "${YELLOW}[9/10] نسخ ملفات GRUB والإقلاع${NC}"
cp "${BASE_DIR}/grub.cfg" "$ISO_ROOT_DIR/boot/grub/"
cp "${BASE_DIR}/isolinux.cfg" "$ISO_ROOT_DIR/boot/isolinux/" 2>/dev/null || true
echo -e "${GREEN}✓ تم نسخ ملفات الإقلاع${NC}"
echo ""

# Create ISO image
echo -e "${YELLOW}[10/10] إنشاء صورة ISO النهائية${NC}"
echo "  هذا قد يستغرق 5-10 دقائق..."
grub-mkrescue -o "$OUTPUT_ISO" "$ISO_ROOT_DIR/" 2>&1 | grep -v "warning"
echo -e "${GREEN}✓ تم إنشاء الـ ISO${NC}"
echo ""

# Final summary
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗"
echo "║           ✓ تم بناء الـ ISO بنجاح!                        ║"
echo "╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📁 ملف الـ ISO:${NC}"
ls -lh "$OUTPUT_ISO"
echo ""
echo -e "${BLUE}💾 الخطوات التالية:${NC}"
echo "1. حرق على USB: sudo dd if=$OUTPUT_ISO of=/dev/sdX bs=4M"
echo "2. أو استخدم Etcher: https://www.balena.io/etcher/"
echo ""
