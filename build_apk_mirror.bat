@echo off
chcp 65001 >nul
echo ========================================
echo   UPS Monitor - Build APK (Mirror)
echo ========================================
echo.

cd /d "C:\Users\13628\CodeBuddy\20260512141904\ups-project\flutter_app\ups_monitor_app"

echo Setting China mirror...
set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

echo.
echo Building APK (this may take 5-10 minutes)...
echo.

"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" pub get
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" build apk --release

echo.
echo ========================================
echo Build process completed!
echo.
echo APK location:
echo %cd%\build\app\outputs\flutter-apk\app-release.apk
echo.
pause
