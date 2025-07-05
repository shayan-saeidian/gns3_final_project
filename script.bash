#!/bin/bash

# === تنظیمات اولیه ===
set -e
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# === نمایش راهنما ===
show_help() {
    echo "Usage: $0 --source DIR --format EXT --dest DIR --days N [--dry-run] [--encrypt] [--email EMAIL]"
    echo ""
    echo "Options:"
    echo "  --source DIR      مسیر مبدأ برای جستجوی فایل‌ها"
    echo "  --format EXT      فرمت فایل‌ها برای بکاپ (مثل txt)"
    echo "  --dest DIR        مسیر ذخیره پشتیبان‌ها"
    echo "  --days N          تعداد روز نگهداری بکاپ‌ها"
    echo "  --dry-run         فقط نمایش لیست بدون اجرای بکاپ"
    echo "  --encrypt         رمزگذاری خروجی بکاپ"
    echo "  --email EMAIL     ارسال گزارش به ایمیل"
    echo "  -h, --help        نمایش این راهنما"
}

# === نوتیفیکیشن ===
notify() {
    local message="$1"
    echo -e "\n=== Notification ===\n$message\n==================="
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Backup Notification" "$message"
    fi
}

# === آرگومان‌ها ===
SOURCE=""
FORMAT=""
DEST=""
DAYS=""
DRY_RUN=0
ENCRYPT=0
EMAIL=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --source) SOURCE="$2"; shift 2 ;;
        --format) FORMAT="$2"; shift 2 ;;
        --dest) DEST="$2"; shift 2 ;;
        --days) DAYS="$2"; shift 2 ;;
        --dry-run) DRY_RUN=1; shift ;;
        --encrypt) ENCRYPT=1; shift ;;
        --email) EMAIL="$2"; shift 2 ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "خطا: آرگومان نامعتبر $1"; show_help; exit 1 ;;
    esac
done

# === بررسی مقادیر ضروری ===
if [[ -z "$SOURCE" || -z "$FORMAT" || -z "$DEST" || -z "$DAYS" ]]; then
    echo "❌ مقادیر ضروری وارد نشده‌اند."
    show_help
    exit 1
fi


# === بررسی وجود مسیرها ===
if [[ ! -d "$SOURCE" ]]; then
    notify "❌ مسیر مبدأ وجود ندارد: $SOURCE"
    exit 2
fi
mkdir -p "$DEST"