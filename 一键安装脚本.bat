@echo off
setlocal enabledelayedexpansion
@REM chcp 65001 >nul

set "download_dir=%~dp0silk2mp3-easy"
if not exist "%download_dir%" mkdir "%download_dir%"

:: 下载列表
set "files[1]=https://github.com/foyoux/silk-codec/releases/latest/download/silk-decoder-x64.exe"
set "files[2]=https://raw.githubusercontent.com/XTsat/silk2mp3-easy/main/单文件test.bat"
set "files[3]=https://raw.githubusercontent.com/XTsat/silk2mp3-easy/main/多文件copy.bat"
set "files[4]=https://github.com/GyanD/codexffmpeg/releases/download/7.1.1/ffmpeg-7.1.1-essentials_build.zip"

:: 遍历所有文件并下载
for /f "tokens=2 delims==" %%i in ('set files[') do (
    set "url=%%i"
    
    :: 自动从URL提取文件名（兼容带参数的链接）
    for /f "delims=" %%f in ('
        powershell -noprofile -command ^
        "$u='!url!'; $u=$u.split('?')[0]; [System.IO.Path]::GetFileName($u)"
    ') do set "filename=%%f"

    :: 下载文件
    echo 正在下载: !filename!
    curl -L -o "%download_dir%\!filename!" "!url!" --progress-bar --ssl-no-revoke
)

echo 所有文件下载完成！

:: 提取ffmpeg.exe
set "root_dir=%~dp0"
set "zip_file=silk2mp3-easy/ffmpeg-7.1.1-essentials_build.zip"
set "target_file=ffmpeg-7.1.1-essentials_build/bin/ffmpeg.exe"

:: 使用 PowerShell 解压并复制到脚本目录
powershell -Command ^
    "$rootDir = '%root_dir%';" ^
    "Expand-Archive -Path ($rootDir + '%zip_file%') -DestinationPath ($rootDir + '_temp');" ^
    "Copy-Item ($rootDir + '_temp/%target_file%') -Destination $rootDir/silk2mp3-easy/;" ^
    "Remove-Item ($rootDir + '_temp') -Recurse -Force"

:: 检查是否成功
if exist "%~dp0silk2mp3-easy/ffmpeg.exe" (
    echo 成功！ffmpeg.exe 已提取到脚本目录。
    del "silk2mp3-easy\ffmpeg-7.1.1-essentials_build.zip"

    powershell -command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms') | Out-Null; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.BalloonTipTitle = '所有文件下载完成！'; $notify.BalloonTipText = '文件保存在: "%download_dir%"'; $notify.Visible = $true; $notify.ShowBalloonTip(3);"

) else (
    echo 提取失败，请检查路径或 ZIP 文件。
    pause
)