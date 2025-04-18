@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "download_dir=%~dp0"
if not exist "%download_dir%" mkdir "%download_dir%"

set "file_url[1]=https://raw.githubusercontent.com/user/repo/main/file1.txt"
set "file_name[1]=file1.txt"

set "file_url[2]=https://github.com/kn007/silk-v3-decoder/releases/download/win/silk2mp3-full.zip"
set "file_name[2]=silk2mp3-full.zip"

set "file_url[3]=https://github.com/user/repo2/releases/download/v1.0/app.zip"
set "file_name[3]=app.zip"

set "file_count=3"

echo 正在下载文件...
for /l %%i in (1,1,%file_count%) do (
    echo 正在下载: !file_name[%%i]!
    curl -L -o "%download_dir%\!file_name[%%i]!" "!file_url[%%i]!" --ssl-no-revoke --show-error
    if errorlevel 1 (
        echo 错误：下载失败 - !file_name[%%i]!
    ) else (
        echo 下载成功 - !file_name[%%i]!
    )
)

echo 所有文件下载完成！
echo 文件保存在: "%download_dir%"
pause