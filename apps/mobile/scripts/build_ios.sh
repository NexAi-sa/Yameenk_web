#!/usr/bin/env bash
# ──────────────────────────────────────────────────
#  يمينك — iOS Release Build (مع Obfuscation)
# ──────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DEBUG_INFO_DIR="$PROJECT_DIR/build/debug-info/ios"

cd "$PROJECT_DIR"

# تأكد من وجود ملف .env
if [ ! -f .env ]; then
  echo "❌  ملف .env غير موجود — انسخ .env.example إلى .env وعبّي القيم"
  exit 1
fi

echo "🏗️  بناء iOS Release مع Obfuscation..."
flutter build ios --release \
  --obfuscate \
  --split-debug-info="$DEBUG_INFO_DIR" \
  --dart-define-from-file=.env

echo ""
echo "✅  تم البناء بنجاح!"
echo "📂  Debug symbols محفوظة في: $DEBUG_INFO_DIR"
echo ""
echo "⚠️  مهم: احفظ مجلد debug-info — تحتاجه لقراءة crash reports:"
echo "    flutter symbolize -i <crash_log> -d $DEBUG_INFO_DIR"
