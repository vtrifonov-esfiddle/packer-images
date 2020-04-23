function Start-WinRM() {
    Get-Service WinRM | Set-Service -StartupType Automatic
    Get-Service WinRM | Start-Service
}

. "$PSScriptRoot\Logger.ps1"
$Logger = [Logger]::new("EnableWinRM.log")

$Logger.Write("Autostart Win RM - So Packer Provisioners can access it")
Start-WinRM
$Logger.Write("Autostart Win RM - Completed")