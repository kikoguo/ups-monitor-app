@echo off
chcp 65001 >nul
echo ========================================
echo   检查Flutter和Android SDK配置
echo ========================================
echo.

echo [1] 检查Flutter版本...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" --version >> config_log.txt 2>&1
echo. >> config_log.txt

echo [2] 检查Flutter doctor详情...
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" doctor -v >> config_log.txt 2>&1

echo.
echo 已保存到: %cd%\config_log.txt
echo 请打开查看并发送给我
pause
