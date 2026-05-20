@echo off
chcp 65001 >nul
echo Step 1: Configure SDK > step1_log.txt
echo. >> step1_log.txt
"C:\flutter\flutter_windows_3.41.9-stable\flutter\bin\flutter.bat" config --android-sdk D:\SDK >> step1_log.txt 2>&1
echo. >> step1_log.txt
echo Done! >> step1_log.txt
start notepad step1_log.txt
