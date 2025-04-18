@echo off
setlocal
chcp 65001 >nul

:: 设置 GitHub 文件 Raw 链接
set "file_url=https://github.com/foyoux/silk-codec/releases/latest/download/silk-decoder-x64.exe"

:: 自动提取文件名（如 README.md）
for /f "delims=" %%a in ('powershell -Command "[System.IO.Path]::GetFileName('%file_url%')"') do set "filename=%%a"

:: 下载到当前 bat 所在目录
set "save_path=%~dp0%filename%"

:: 使用 curl 下载
curl -L -o "%save_path%" "%file_url%" --ssl-no-revoke --progress-bar --show-error

echo 文件已下载到: %save_path%
pause
