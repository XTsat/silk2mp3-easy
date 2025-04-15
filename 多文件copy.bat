@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: 初始化文件夹路径(均在A文件夹内)
set "input_dir=%~dp01.输入文件"
set "output_dir=%~dp02.输出文件"

:: 创建目录(如果不存在)
@REM if not exist "!input_dir!" mkdir "!input_dir!"
@REM if not exist "!output_dir!" mkdir "!output_dir!"
if not exist "!input_dir!" (
    mkdir "!input_dir!"
    if !errorlevel! neq 0 (
        echo [错误] 无法创建输入目录：!input_dir!
        pause
    )
)
if not exist "!output_dir!" (
    mkdir "!output_dir!"
    if !errorlevel! neq 0 (
        echo [错误] 无法创建输入目录：!output_dir!
        pause
    )
)
echo 当前脚本路径：%~dp0
echo 输入目录：!input_dir!
echo 输出目录：!output_dir!

:: 检查是否有文件拖入
if "%~1"=="" (
    echo 错误：请将文件拖拽到此bat上！
    pause
    exit /b
)

:: 遍历所有拖入的文件
for %%a in (%*) do (
    echo 正在处理文件：%%a

    :: Step 1: 复制文件到A文件夹的临时输入目录
    set "source_file=%%a"
    set "target_file=!input_dir!\%%~nxa"
    copy /Y "!source_file!" "!target_file!" >nul
    if !errorlevel! neq 0 (
        echo [错误] 复制文件失败：%%a
        continue
    )

    :: Step 2: 在A文件夹内处理文件
    "%~dp0silk-decoder-x64.exe" "!target_file!" "!target_file!.pcm"
    if !errorlevel! neq 0 (
        echo [错误] 解码失败：%%a
        del "!target_file!.pcm" 2>nul
        continue
    )

    :: Step 3: 转换为MP3
    "%~dp0ffmpeg.exe" -y -f s16le -ar 24000 -ac 1 -i "!target_file!.pcm" "!target_file!.mp3"
    if !errorlevel! neq 0 (
        echo [错误] 转换失败：%%a
        del "!target_file!.*" 2>nul
        continue
    )

    :: Step 4: 移动输出文件到输出目录
    set "final_output=!output_dir!\%%~na.mp3"
    if exist "!final_output!" (
        echo 检测到重名文件，自动重命名...
        set "counter=1"
        :rename_loop
        set "final_output=!output_dir!\%%~na_!counter!.mp3"
        if exist "!final_output!" (
            set /a counter+=1
            goto rename_loop
        )
    )
    move "!target_file!.mp3" "!final_output!" >nul

    :: 清理临时文件
    del "!target_file!.pcm" 2>nul
    @REM del "!target_file!" "!target_file!.pcm" 2>nul
    echo [成功] 输出文件：!final_output!

    :: 移动原始文件
    move /Y "!source_file!" "!target_file!" >nul
    :: 删除原始文件(危险操作)
    @REM del "!source_file!" 2>nul
)

:: 删除空临时输入目录
@REM rmdir "!input_dir!" 2>nul

powershell -command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms') | Out-Null; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.BalloonTipTitle = '导出成功'; $notify.BalloonTipText = '所有文件处理完成，结果保存在：!output_dir!'; $notify.Visible = $true; $notify.ShowBalloonTip(5000);"
echo 所有文件处理完成，结果保存在：!output_dir!