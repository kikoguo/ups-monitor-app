@echo off
chcp 65001 >nul
echo ========================================
echo   整理项目结构 - 移动 Flutter 到根目录
echo ========================================
echo.

set SOURCE_DIR=%~dp0flutter_app\ups_monitor_app
set TARGET_DIR=%~dp0
set BACKUP_DIR=%~dp0_backup_old

echo [1/5] 备份原文件到 _backup_old 文件夹...
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
xcopy /E /I "%SOURCE_DIR%" "%BACKUP_DIR%\ups_monitor_app" >nul 2>&1
echo   备份完成

echo.
echo [2/5] 复制 Flutter 项目到根目录...
xcopy /E /I /Y "%SOURCE_DIR%" "%TARGET_DIR%" >nul 2>&1
echo   复制完成

echo.
echo [3/5] 删除 build 文件夹 (不需要上传)...
if exist "%TARGET_DIR%build" rmdir /S /Q "%TARGET_DIR%build"
echo   已删除 build

echo.
echo [4/5] 删除 .gradle 缓存 (不需要上传)...
if exist "%TARGET_DIR%android\.gradle" rmdir /S /Q "%TARGET_DIR%android\.gradle"
echo   已删除 .gradle 缓存

echo.
echo [5/5] 重新初始化 Git...
cd /d "%TARGET_DIR%"
git init >nul 2>&1
git add .
git commit -m "整理项目结构 - Flutter 作为仓库根目录"
git branch -M main
git remote set-url origin https://github.com/kikoguo/ups-monitor-app.git
git push -f -u origin main

echo.
echo ========================================
echo   完成！
echo ========================================
echo.
echo 新结构：
echo   ups-project/          <- 仓库根目录
echo     lib/
echo     ios/
echo     android/
echo     pubspec.yaml
echo     ...
echo.
echo 现在去 Codemagic 重新配置，Project path 留空即可！
echo.
pause
