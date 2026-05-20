@echo off
chcp 65001 >nul
echo ========================================
echo   构建 Web 版本
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
echo [3/3] 构建 Web 版本...
flutter build web

echo.
echo ========================================
echo   构建完成！
echo ========================================
echo.
echo Web 版本位置:
echo %~dp0build\web
echo.
echo 可以用以下命令启动本地服务器测试:
echo   flutter run -d chrome
echo.
pause
