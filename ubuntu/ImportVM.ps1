Param(
    [Parameter(Mandatory=$true)]
    [string] $TemplateName,
    [string] $VmName = $TemplateName,
    [string] $TemplatesOutputPath = "ImagesOutput"
)

function Import() {
    $TemplateBasePath = "$TemplatesOutputPath\$TemplateName"
    $TemplateFullPath = Get-Childitem -Path $TemplateBasePath -Recurse -Include *.vmcx
    Write-Host "Template Path: $TemplateFullPath"
    Import-VM -Path $TemplateFullPath -Copy -GenerateNewId
}

function Rename() {
    Rename-VM $TemplateName -NewName $VmName
    $Drive = Get-VMHardDiskDrive -VMName $VmName
    $ParentDriveDir = Split-Path -Path $Drive.Path
    $RenamedVmPath = "$ParentDriveDir\$VmName.vhdx"
    Move-Item $Drive.Path $RenamedVmPath
    Get-VMHardDiskDrive -VMName $VmName -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0 | Set-VMHardDiskDrive -Path $RenamedVmPath
}

Import
if ($VmName -ne $TemplateName) {
  Rename
}
Start-VM -Name $VmName