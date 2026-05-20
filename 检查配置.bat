@echo off
chcp 65001 >nul
echo ========================================
echo   检查Flutter和Android SDK配置
echo ========================================
echo.

echo [1] 检查Flutter版本...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" --version
echo.

echo [2] 检查Flutter doctor...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" doctor -v

echo.
echo ========================================
echo 请把上面的输出发给我
echo ========================================
pause
