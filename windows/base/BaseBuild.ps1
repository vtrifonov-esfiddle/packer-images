
[string] $USERNAME = "$env:PACKER_USERNAME"
[string] $PASSWORD = "$env:PACKER_PASSWORD"
[string] $IMAGE_OUTPUT_DIRECTORY = "$env:IMAGE_OUTPUT_DIRECTORY"
[string] $PACKER_TEMPLATE = "$env:PACKER_TEMPLATE"
[string] $AnswerIsoDrive = "$env:PACKER_ANSWER_ISO_DRIVE"
[Nullable[int]] $InstallationImageIndex = $env:PACKER_INSTALLATION_IMAGE_INDEX
[string] $WindowsVersion = "$env:PACKER_WINDOWS_VERSION"
[string] $Locale = "$env:PACKER_LOCALE"

function Set-Parameter($Parameter, $Prompt) {
    if ([string]::IsNullOrEmpty($Parameter)) {
        $Parameter = Read-Host -Prompt $Prompt        
    }
    return $Parameter
}

$USERNAME = Set-Parameter $USERNAME  "USERNAME: "
$PASSWORD = Set-Parameter $PASSWORD "PASSWORD: "
$IMAGE_OUTPUT_DIRECTORY = Set-Parameter $IMAGE_OUTPUT_DIRECTORY "VM OUTPUT DIRECTORY: "
$PACKER_TEMPLATE = Set-Parameter $PACKER_TEMPLATE "PACKER TEMPLATE e.g. winserver2016-base.json: "
$Locale = Set-Parameter $Locale "Locale e.g. en-US: "
if ([string]::IsNullOrEmpty($AnswerIsoDrive)) {
    $AnswerIsoDrive = "E:"    
}
if ($null -eq $InstallationImageIndex) {
    $InstallationImageIndex = 1        
}

& $PSSCriptRoot\baseAnswerIso\GenerateBaseAnswerIso.ps1 -Username $USERNAME `
    -Password $PASSWORD `
    -AnswerIsoDrive $AnswerIsoDrive `
    -InstallationImageIndex $InstallationImageIndex `
    -WindowsVersion $WindowsVersion `
    -Locale $Locale

$CurrentPath = $PWD
cd $PSSCriptRoot

packer validate `
    -var "username=$USERNAME" `
    -var "password=$PASSWORD" `
    -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
    -var "ANSWER_ISO_DRIVE=$AnswerIsoDrive" `
    $PACKER_TEMPLATE
if ($LastExitCode -eq 0) {
    packer build `
    -var "username=$USERNAME" `
    -var "password=$PASSWORD" `
    -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
    -var "ANSWER_ISO_DRIVE=$AnswerIsoDrive" `
    $PACKER_TEMPLATE
}
 
cd $CurrentPath