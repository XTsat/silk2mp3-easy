@echo off
setlocal enabledelayedexpansion
@REM chcp 65001 >nul

set "download_dir=%~dp0silk2mp3-easy"
if not exist "%download_dir%" mkdir "%download_dir%"

:: �����б�
set "files[1]=https://github.com/foyoux/silk-codec/releases/latest/download/silk-decoder-x64.exe"
set "files[2]=https://raw.githubusercontent.com/XTsat/silk2mp3-easy/main/���ļ�test.bat"
set "files[3]=https://raw.githubusercontent.com/XTsat/silk2mp3-easy/main/���ļ�copy.bat"
set "files[4]=https://github.com/GyanD/codexffmpeg/releases/download/7.1.1/ffmpeg-7.1.1-essentials_build.zip"

:: ���������ļ�������
for /f "tokens=2 delims==" %%i in ('set files[') do (
    set "url=%%i"
    
    :: �Զ���URL��ȡ�ļ��������ݴ����������ӣ�
    for /f "delims=" %%f in ('
        powershell -noprofile -command ^
        "$u='!url!'; $u=$u.split('?')[0]; [System.IO.Path]::GetFileName($u)"
    ') do set "filename=%%f"

    :: �����ļ�
    echo ��������: !filename!
    curl -L -o "%download_dir%\!filename!" "!url!" --progress-bar --ssl-no-revoke
)

echo �����ļ�������ɣ�

:: ��ȡffmpeg.exe
set "root_dir=%~dp0"
set "zip_file=silk2mp3-easy/ffmpeg-7.1.1-essentials_build.zip"
set "target_file=ffmpeg-7.1.1-essentials_build/bin/ffmpeg.exe"

:: ʹ�� PowerShell ��ѹ�����Ƶ��ű�Ŀ¼
powershell -Command ^
    "$rootDir = '%root_dir%';" ^
    "Expand-Archive -Path ($rootDir + '%zip_file%') -DestinationPath ($rootDir + '_temp');" ^
    "Copy-Item ($rootDir + '_temp/%target_file%') -Destination $rootDir/silk2mp3-easy/;" ^
    "Remove-Item ($rootDir + '_temp') -Recurse -Force"

:: ����Ƿ�ɹ�
if exist "%~dp0silk2mp3-easy/ffmpeg.exe" (
    echo �ɹ���ffmpeg.exe ����ȡ���ű�Ŀ¼��
    del "silk2mp3-easy\ffmpeg-7.1.1-essentials_build.zip"

    powershell -command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms') | Out-Null; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.BalloonTipTitle = '�����ļ�������ɣ�'; $notify.BalloonTipText = '�ļ�������: "%download_dir%"'; $notify.Visible = $true; $notify.ShowBalloonTip(3);"

) else (
    echo ��ȡʧ�ܣ�����·���� ZIP �ļ���
    pause
)