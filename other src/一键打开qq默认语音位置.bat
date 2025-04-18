chcp 65001 >nul

start %USERPROFILE%\Documents\Tencent Files

powershell -command "[reflection.assembly]::loadwithpartialname('System.Windows.Forms') | Out-Null; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.BalloonTipTitle = '后续步骤'; $notify.BalloonTipText = '按顺序打开目录：\你的QQ号\nt_qq\nt_data\Ptt 里面选择月份即可找到语音文件'; $notify.Visible = $true; $notify.ShowBalloonTip(10);"
