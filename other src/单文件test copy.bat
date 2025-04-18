@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: 获取当前脚本所在目录并确保路径结尾有反斜杠
set "script_dir=%~dp0"
if not "%script_dir:~-1%"=="\" set "script_dir=%script_dir%\"

:: 定义程序路径
set "decoders[1]=%script_dir%silk-decoder-x64.exe"
set "decoders[2]=%script_dir%silk-decoder-x86.exe"
set "decoders[3]=%script_dir%silk-decoder.exe"
set "ffmpeg_path=%script_dir%ffmpeg.exe"

:: 检查silk-decoder
set "selected_decoder="
for /f "tokens=2 delims==" %%i in ('set decoders[') do (
    if exist "%%i" (
        set "selected_decoder=%%i"
        echo ✓ 找到: %%~nxi
        goto :decoder_found
    )
)

:decoder_found
if not defined selected_decoder (
    echo ❌ 错误：未找到任何silk-decoder（需至少一个存在）
    echo 请确保以下文件之一存在于 %script_dir% 目录：
    echo - silk-decoder-x64.exe
    echo - silk-decoder-x86.exe
    echo - silk-decoder.exe
    pause
    exit /b 1
)

:: 检查ffmpeg
if not exist "%ffmpeg_path%" (
    echo ❌ 错误：未找到ffmpeg！

    echo 请确保ffmpeg.exe存在于 %script_dir% 目录
    pause
    exit /b 1
)
echo ✓ 找到: ffmpeg.exe

:: 检查输入文件
if "%~1"=="" (
    echo ❌ 错误：请将.silk文件拖放到此脚本上
    pause
    exit /b 1
)

if not exist "%~1" (
    echo ❌ 错误：输入文件不存在
    echo 文件路径：%~1
    pause
    exit /b 1
)

:: 执行转换

echo.
echo ████████████████████████████████████████

echo           开始转换 SILK -> MP3
echo ████████████████████████████████████████

echo [1/2] 正在解码 SILK 文件...
"%selected_decoder%" "%~s1" "%~n1.pcm"
if errorlevel 1 (
    echo ❌ SILK解码失败！
    pause
    exit /b 1
)

echo [2/2] 正在转换 PCM -> MP3...
"%ffmpeg_path%" -y -f s16le -ar 24000 -ac 1 -i "%~n1.pcm" "%~n1.mp3"
if errorlevel 1 (
    echo ❌ MP3转换失败！
    del "%~n1.pcm" 2>nul
    pause
    exit /b 1
)

:: 清理临时文件
del "%~n1.pcm" 2>nul

echo.
echo ✔ 转换成功！输出文件：
echo %~dpn1.mp3
echo.
pause
exit /b 0