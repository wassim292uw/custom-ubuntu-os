#!/bin/bash

# ============================================
# System Information Monitor
# أداة عرض معلومات النظام
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

clear

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║       معلومات النظام - System Information Monitor         ║"
echo "║          Custom Ubuntu OS - نظام التشغيل المخصص           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# ==================== معلومات النظام الأساسية ====================
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}📊 معلومات النظام الأساسية${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

OS_NAME=$(lsb_release -ds)
KERNEL=$(uname -r)
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)

echo -e "  ${BLUE}اسم النظام:${NC}     $OS_NAME"
echo -e "  ${BLUE}اسم الكمبيوتر:${NC}   $HOSTNAME"
echo -e "  ${BLUE}النواة:${NC}        $KERNEL"
echo -e "  ${BLUE}وقت التشغيل:${NC}   $UPTIME"
echo ""

# ==================== المعالج ====================
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}⚙️  معلومات المعالج (CPU)${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

CPU_MODEL=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)
CPU_CORES=$(nproc)
CPU_FREQ=$(lscpu | grep "CPU max MHz" | cut -d: -f2 | xargs | cut -d. -f1)

echo -e "  ${BLUE}نوع المعالج:${NC}      $CPU_MODEL"
echo -e "  ${BLUE}عدد الأنوية:${NC}      $CPU_CORES"
if [ ! -z "$CPU_FREQ" ]; then
    echo -e "  ${BLUE}السرعة القصوى:${NC}     ${CPU_FREQ} MHz"
fi

# استخدام المعالج الحالي
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo -e "  ${BLUE}الاستخدام الحالي:${NC}  ${CPU_USAGE}%"
echo ""

# ==================== الذاكرة ====================
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}💾 معلومات الذاكرة (RAM)${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

MEM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
MEM_USED=$(free -h | grep Mem | awk '{print $3}')
MEM_FREE=$(free -h | grep Mem | awk '{print $4}')
MEM_PERCENT=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100)}')

echo -e "  ${BLUE}إجمالي الذاكرة:${NC}   $MEM_TOTAL"
echo -e "  ${BLUE}المستخدم:${NC}       $MEM_USED (${MEM_PERCENT}%)"
echo -e "  ${BLUE}المتاح:${NC}        $MEM_FREE"
echo ""

# ==================== التخزين ====================
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}💿 معلومات التخزين (Storage)${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

DISK_TOTAL=$(df -h / | tail -1 | awk '{print $2}')
DISK_USED=$(df -h / | tail -1 | awk '{print $3}')
DISK_FREE=$(df -h / | tail -1 | awk '{print $4}')
DISK_PERCENT=$(df -h / | tail -1 | awk '{print $5}')

echo -e "  ${BLUE}إجمالي المساحة:${NC}   $DISK_TOTAL"
echo -e "  ${BLUE}المستخ��مة:${NC}      $DISK_USED"
echo -e "  ${BLUE}المتاحة:${NC}       $DISK_FREE"
echo -e "  ${BLUE}النسبة المئوية:${NC}   $DISK_PERCENT"
echo ""

# عرض جميع الأقسام
echo -e "${CYAN}جميع الأقسام:${NC}"
df -h | grep -E '^/dev' | awk '{printf "  %s: %s / %s (استخدام: %s)\n", $1, $3, $2, $5}' | head -10
echo ""

# ==================== كرت الرسومات ====================
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🎮 معلومات كرت الرسومات (GPU)${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

if command -v lspci &> /dev/null; then
    GPU_INFO=$(lspci | grep -E "VGA|Display|3D" | head -1)
    if [ ! -z "$GPU_INFO" ]; then
        echo -e "  ${BLUE}كرت الرسومات:${NC}    $GPU_INFO"
    else
        echo -e "  ${YELLOW}لم يتم العثور على معلومات GPU${NC}"
    fi
else
    echo -e "  ${YELLOW}أداة lspci غير مثبتة${NC}"
fi

# معلومات NVIDIA إن وجدت
if command -v nvidia-smi &> /dev/null; then
    echo ""
    echo -e "  ${CYAN}معلومات NVIDIA GPU:${NC}"
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader | while read line; do
        echo -e "    $line"
    done
fi

echo ""

# ==================== الشبكة ====================
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🌐 معلومات الشبكة (Network)${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

HOSTNAME_IP=$(hostname -I)
if [ ! -z "$HOSTNAME_IP" ]; then
    echo -e "  ${BLUE}عنوان IP:${NC}      $HOSTNAME_IP"
fi

# اسم الشبكة
NETWORK_DEVICES=$(ip link show | grep "^[0-9]" | awk '{print $2}' | cut -d: -f1 | tr '\n' ', ')
echo -e "  ${BLUE}أجهزة الشبكة:${NC}    ${NETWORK_DEVICES%,}"
echo ""

# ==================== التطبيقات المثبتة ====================
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}📦 التطبيقات الرئيسية${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

check_app() {
    if command -v $1 &> /dev/null; then
        VERSION=$($1 --version 2>/dev/null | head -1 || echo "مثبت")
        echo -e "  ${GREEN}✓${NC} $2: $VERSION"
    else
        echo -e "  ${RED}✗${NC} $2: غير مثبت"
    fi
}

check_app "firefox" "Firefox"
check_app "chromium-browser" "Chromium"
check_app "libreoffice" "LibreOffice"
check_app "vlc" "VLC"
check_app "gimp" "GIMP"
check_app "python3" "Python 3"
check_app "node" "Node.js"
check_app "git" "Git"
echo ""

# ==================== الجهاز ====================
echo -e "${MAGENTA}══════════════════���════════════════════════════════════════${NC}"
echo -e "${GREEN}🖥️  معلومات الجهاز${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

BIOS=$(dmidecode -s system-product-name 2>/dev/null || echo "غير متاح")
MANUFACTURER=$(dmidecode -s system-manufacturer 2>/dev/null || echo "غير متاح")

echo -e "  ${BLUE}المصنع:${NC}        $MANUFACTURER"
echo -e "  ${BLUE}نموذج الجهاز:${NC}   $BIOS"
echo ""

# ==================== الملخص ====================
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}📈 الملخص والحالة${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"

if (( $(echo "$MEM_PERCENT > 80" | bc -l) )); then
    echo -e "  ${RED}⚠️  استخدام الذاكرة مرتفع!${NC}"
else
    echo -e "  ${GREEN}✓${NC} استخدام الذاكرة طبيعي"
fi

if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo -e "  ${RED}⚠️  استخدام المعالج مرتفع!${NC}"
else
    echo -e "  ${GREEN}✓${NC} استخدام المعالج طبيعي"
fi

if (( ${DISK_PERCENT%\%} > 80 )); then
    echo -e "  ${RED}⚠️  مساحة التخزين منخفضة!${NC}"
else
    echo -e "  ${GREEN}✓${NC} مساحة التخزين كافية"
fi

echo ""
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}تم إنشاء هذا التقرير في: $(date)${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════${NC}"
echo ""
