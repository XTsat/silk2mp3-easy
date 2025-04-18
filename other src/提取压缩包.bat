@echo off
:: 获取当前脚本所在目录（根目录）
set "root_dir=%~dp0"
set "zip_file=ffmpeg-7.1.1-essentials_build.zip"
set "target_file=ffmpeg-7.1.1-essentials_build/bin/ffmpeg.exe"

:: 使用 PowerShell 解压并复制到脚本目录
powershell -Command ^
    "$rootDir = '%root_dir%';" ^
    "Expand-Archive -Path ($rootDir + '%zip_file%') -DestinationPath ($rootDir + '_temp');" ^
    "Copy-Item ($rootDir + '_temp/%target_file%') -Destination $rootDir;" ^
    "Remove-Item ($rootDir + '_temp') -Recurse -Force"

:: 检查是否成功
if exist "%~dp0ffmpeg.exe" (
    echo 成功！ffmpeg.exe 已提取到脚本目录。
) else (
    echo 提取失败，请检查路径或 ZIP 文件。
    pause
)