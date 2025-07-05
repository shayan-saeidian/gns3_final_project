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