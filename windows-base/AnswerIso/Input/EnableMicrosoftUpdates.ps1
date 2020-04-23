
. "$PSScriptRoot\Logger.ps1"
$Logger = [Logger]::new("EnableWindowsUpdates.log")

$Logger.Write("EnableWindowsUpdates started")

stop-service wuauserv
&reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v EnableFeaturedSoftware /t REG_DWORD /d 1 /f
&reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v IncludeRecommendedUpdates /t REG_DWORD /d 1 /f

$MicrosoftUpdate = New-Object -ComObject Microsoft.Update.ServiceManager -Strict 
$MicrosoftUpdate.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")

start-service wuauserv

$Logger.Write("EnableWindowsUpdates finished")