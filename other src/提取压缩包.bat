@echo off
:: ��ȡ��ǰ�ű�����Ŀ¼����Ŀ¼��
set "root_dir=%~dp0"
set "zip_file=ffmpeg-7.1.1-essentials_build.zip"
set "target_file=ffmpeg-7.1.1-essentials_build/bin/ffmpeg.exe"

:: ʹ�� PowerShell ��ѹ�����Ƶ��ű�Ŀ¼
powershell -Command ^
    "$rootDir = '%root_dir%';" ^
    "Expand-Archive -Path ($rootDir + '%zip_file%') -DestinationPath ($rootDir + '_temp');" ^
    "Copy-Item ($rootDir + '_temp/%target_file%') -Destination $rootDir;" ^
    "Remove-Item ($rootDir + '_temp') -Recurse -Force"

:: ����Ƿ�ɹ�
if exist "%~dp0ffmpeg.exe" (
    echo �ɹ���ffmpeg.exe ����ȡ���ű�Ŀ¼��
) else (
    echo ��ȡʧ�ܣ�����·���� ZIP �ļ���
    pause
)