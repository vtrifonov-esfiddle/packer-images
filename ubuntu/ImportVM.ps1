Param(
    [Parameter(Mandatory=$true)]
    [string] $VmName,
    [string] $VmOutputPath = "VMsOutput"
)

$VmBasePath = "$VmOutputPath\$VmName"
$VmFullPath = Get-Childitem -Path $VmBasePath -Recurse -Include *.vmcx
Write-Host "VM Path: $VmFullPath"
Import-VM -Path $VmFullPath -Copy -GenerateNewId
Start-VM -Name $VmName