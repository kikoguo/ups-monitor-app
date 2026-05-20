@echo off
chcp 65001 >nul
echo ========================================
echo   上传 iOS 文件到 GitHub
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] 添加 iOS 文件...
git add ios/

echo [2/3] 提交更改...
git commit -m "添加 iOS 平台支持"

echo [3/3] 上传到 GitHub...
git push

echo.
echo ========================================
echo   上传完成！
echo ========================================
echo.
pause
