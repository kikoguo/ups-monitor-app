@echo off
chcp 65001 >nul
echo ========================================
echo   配置Flutter + 编译APK
echo ========================================
echo.

echo [1] 配置Flutter使用Android SDK...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" config --android-sdk D:\SDK
echo.

echo [2] 设置国内镜像...
set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
echo.

echo [3] 进入项目目录...
cd /d "C:\Users\13628\CodeBuddy\20260512141904\ups-project\flutter_app\ups_monitor_app"

echo [4] 下载依赖...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" pub get
echo.

echo [5] 编译APK...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" build apk --release

echo.
echo ========================================
echo 编译完成！
echo.
echo APK文件位置:
echo %cd%\build\app\outputs\flutter-apk\app-release.apk
echo.
pause
