@echo off
chcp 65001 >nul
echo ========================================
echo   UPS Monitor - APK编译脚本 v2
echo ========================================
echo.

REM 检查Android SDK
echo [1/5] 检查Android SDK配置...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" doctor -v | findstr /i "android"

echo.
echo [2/5] 设置环境变量...
set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

echo [3/5] 进入项目目录...
cd /d "C:\Users\13628\CodeBuddy\20260512141904\ups-project\flutter_app\ups_monitor_app"

echo [4/5] 下载依赖...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" pub get

echo.
echo [5/5] 编译APK...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" build apk --release

echo.
echo ========================================
echo 编译完成！
echo.
echo APK文件: %cd%\build\app\outputs\flutter-apk\app-release.apk
echo.
pause
