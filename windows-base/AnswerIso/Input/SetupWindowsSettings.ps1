
Param(
    [string] $Username,
    [string] $Password
)

. "$PSScriptRoot\Logger.ps1"
$Logger = [Logger]::new("SetupWindowsSettings.log")

function SetupPowerconfig() {
    #Set power configuration to High Performance
    &powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    #Monitor timeout
    &powercfg -Change -monitor-timeout-ac 0
    &powercfg -Change -monitor-timeout-dc 0
    &powercfg -hibernate OFF
}

function SetupRegistrySettings() {
  $CurrentPath = $PWD
  cd $env:SystemRoot\System32
     
  # Show file extensions in Explorer
  & reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f
  # Enable QuickEdit mode
  & reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f
  # Show Run command in Start Menu
  & reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f
  # Show Administrative Tools in Start Menu
  & reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f
  # Zero Hibernation File
  & reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
  # Disable Hibernation Mode
  & reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f
  # Turn off computer password
  & reg.exe ADD "HKLM\System\CurrentControlSet\Services\Netlogon\Parameters" /v DisablePasswordChange /t REG_DWORD /d 1 /f
  # Enable AutoAdminLogon
  & reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
  # Set AutoLoginPassword
  & reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d $Password /f

  cd $CurrentPath
}

$Logger.Write("Setup Windows Settings Started")

# Disable password expiration for default user
wmic useraccount where "name='$Username'" set PasswordExpires=FALSE
# ICMP open for ping
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
# Turn off all power saving and timeouts
SetupPowerconfig
SetupRegistrySettings

$Logger.Write("Setup Windows Settings Finished")