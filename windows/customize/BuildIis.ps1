
[string] $USERNAME = "$env:PACKER_USERNAME"
[string] $PASSWORD = "$env:PACKER_PASSWORD"
[string] $IMAGE_OUTPUT_DIRECTORY = "$env:IMAGE_OUTPUT_DIRECTORY"
[string] $PACKER_TEMPLATE = "$env:PACKER_TEMPLATE"
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

& $PSSCriptRoot\..\answerIso\GenerateSysprepAnswerIso.ps1 -Username $USERNAME `
    -Password $PASSWORD `
    -Locale $Locale

$CurrentPath = $PWD
cd $PSSCriptRoot

packer validate `
    -var "username=$USERNAME" `
    -var "password=$PASSWORD" `
    -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
    -var "base_image_directory=$IMAGE_OUTPUT_DIRECTORY" `
    $PACKER_TEMPLATE
if ($LastExitCode -eq 0) {
    packer build `
    -var "username=$USERNAME" `
    -var "password=$PASSWORD" `
    -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
    -var "base_image_directory=$IMAGE_OUTPUT_DIRECTORY" `
    $PACKER_TEMPLATE
}
cd $CurrentPath