chcp 65001
@echo off
echo ========================================
echo   Build with China Mirror
echo ========================================

cd /d "C:\Users\13628\CodeBuddy\20260512141904\ups-project\flutter_app\ups_monitor_app"

set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

echo Building with mirror...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" build apk --release

pause
