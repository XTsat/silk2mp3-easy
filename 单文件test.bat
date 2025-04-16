@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 获取当前脚本所在目录
set "script_dir=%~dp0"

:: =============== 软件检测 ===============
:: 定义可能的程序路径（按优先级排序）
set "app1=%script_dir%silk-decoder-x64.exe"
set "app2=%script_dir%silk-decoder-x86.exe"
set "app3=%script_dir%silk-decoder.exe"
set "app4=%script_dir%ffmpeg.exe"

:: 检查silk-decoder存在
set "decoder_found="
if exist "%app1%" set "decoder_found=1" & echo ✓ 找到: silk-decoder-x64.exe
if exist "%app2%" set "decoder_found=1" & echo ✓ 找到: silk-decoder-x86.exe
if exist "%app3%" set "decoder_found=1" & echo ✓ 找到: silk-decoder.exe

if not defined decoder_found (
    echo ❌ 错误：未找到任何silk-decoder（需至少一个存在）
    if not exist "%app4%" (
    echo ❌ 错误：未找到ffmpeg！
) else (
    echo ✓ 找到: ffmpeg.exe
)
    pause
    exit /b 1
)

:: 检查ffmpeg
if not exist "%app4%" (
    echo ❌ 错误：未找到ffmpeg！
    pause
    exit /b 1
) else (
    echo ✓ 找到: ffmpeg.exe
)

echo 所有必需软件检测通过！

for %%a in ("%app1%" "%app2%" "%app3%") do (
    if exist %%a (
        "%%a" %~s1 %~n1.pcm
        %script_dir%ffmpeg -y -f s16le -ar 24000 -ac 1 -i %~n1.pcm %~n1.mp3
        del %~n1.pcm
    )
)

echo 转码成功！转码文件位于"%~dp0"
pause