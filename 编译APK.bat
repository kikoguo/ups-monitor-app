@echo off
chcp 65001 >nul
echo ========================================
echo   编译 Android Release APK
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] 清理旧构建...
flutter clean >nul 2>&1
echo   已清理

echo.
echo [2/3] 获取依赖...
flutter pub get
echo   依赖完成

echo.
echo [3/3] 编译 Release APK...
flutter build apk --release

echo.
echo ========================================
echo   编译完成！
echo ========================================
echo.
echo APK 位置:
echo %~dp0build\app\outputs\flutter-apk\app-release.apk
echo.
pause
