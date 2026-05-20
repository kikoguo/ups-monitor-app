chcp 65001
@echo off
echo ========================================
echo   UPS Monitor App - Build APK with Log
echo ========================================

cd /d "C:\Users\13628\CodeBuddy\20260512141904\ups-project\flutter_app\ups_monitor_app"

echo Build started at %date% %time% > build_log.txt
echo ======================================== >> build_log.txt

echo Building APK...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" build apk --release >> build_log.txt 2>&1

echo Build finished at %date% %time% >> build_log.txt
echo Done! Check build_log.txt
pause
