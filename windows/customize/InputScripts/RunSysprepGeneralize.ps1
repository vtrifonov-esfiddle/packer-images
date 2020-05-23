Write-Host ">>>sysprep started generalizing"

function GetSysprepUnattendPath() {
    $SysprepUnattendPath = "${env:ANSWER_ISO_DRIVE}\SysprepUnattend.xml"
    if (-not ($SysprepUnattendPath | Test-Path)) {
        Write-Error "SysprepUnattend.xml path not found"
    }
    return $SysprepUnattendPath
}
$SysprepUnattendPath = GetSysprepUnattendPath
Write-Host ">>>sysprep using $SysprepUnattendPath"
& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm /unattend:$SysprepUnattendPath

while($true) { 
    $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; 
    if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { 
        Write-Output $imageState.ImageState; Start-Sleep -s 10  
    } else { 
        break 
    } 
}

Write-Host ">>>sysprep finished generalizing"