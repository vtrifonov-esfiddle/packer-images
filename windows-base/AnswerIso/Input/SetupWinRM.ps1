. "$PSScriptRoot\Logger.ps1"
$Logger = [Logger]::new("SetupWinRM.log")

function Fix-WorkgroupNetworkConnections() {
    if([environment]::OSVersion.version.Major -ge 6) {
        # You cannot change the network location if you are joined to a domain, so abort
        if(1,3,4,5 -contains (Get-WmiObject win32_computersystem).DomainRole) { return }
    
        # Get network connections
        $networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
        $connections = $networkListManager.GetNetworkConnections()
        $Logger.Write("Fixing Workgroup Network Connections")
        $connections |foreach {
            $PreviousNetwork = $_.GetNetwork().GetName()
            $PreviousCategory = $_.GetNetwork().GetCategory()
            $Logger.Write("Network: $PreviousNetwork Previous category: $PreviousCategory")

            $_.GetNetwork().SetCategory(1)
            
            $ChangedNetwork = $_.GetNetwork().GetName()
            $ChangedCategory = $_.GetNetwork().GetCategory()
            $Logger.Write("Network: $ChangedNetwork Changed category: $ChangedCategory")
        }
    }
}
$Logger.Write("WinRM Setup Started")

Fix-WorkgroupNetworkConnections

Enable-PSRemoting -Force
winrm quickconfig -q

winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'

Get-Service WinRM | Stop-Service
Get-Service WinRM | Set-Service -StartupType Disabled
$Logger.Write("WinRM Service Disabled and Stopped")

netsh advfirewall firewall add rule name="WinRM-HTTP 5985" dir=in localport=5985 protocol=TCP action=allow

$Logger.Write("WinRM Setup Complete")