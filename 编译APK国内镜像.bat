@echo off
chcp 65001 >nul
echo ========================================
echo   编译 Android APK (国内镜像)
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] 设置国内镜像...
set PUB_HOSTED_URL=https://pub.flutter-io.cn
echo   镜像设置完成

echo.
echo [2/4] 清理旧构建...
flutter clean >nul 2>&1
echo   已清理

echo.
echo [3/4] 获取依赖...
flutter pub get
echo   依赖完成

echo.
echo [4/4] 编译 Release APK...
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
