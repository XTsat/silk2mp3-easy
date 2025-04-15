@echo off
chcp 65001 >nul
call silk-decoder-x64 %~s1 %~n1.pcm
call ffmpeg -y -f s16le -ar 24000 -ac 1 -i %~n1.pcm %~n1.mp3
del %~n1.pcm
pause