
[string] $USERNAME = "$env:PACKER_USERNAME"
[string] $PASSWORD = "$env:PACKER_PASSWORD"
[string] $VM_OUTPUT_DIRECTORY = "$env:VM_OUTPUT_DIRECTORY"
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
$VM_OUTPUT_DIRECTORY = Set-Parameter $VM_OUTPUT_DIRECTORY "VM OUTPUT DIRECTORY: "
$PACKER_TEMPLATE = Set-Parameter $PACKER_TEMPLATE "PACKER TEMPLATE e.g. winserver2016-base.json: "
$Locale = Set-Parameter $Locale "Locale e.g. en-US: "

& $PSSCriptRoot\AnswerIso\GenerateSysprepAnswerIso.ps1 -Username $USERNAME `
    -Password $PASSWORD `
    -Locale $Locale

$CurrentPath = $PWD
cd $PSSCriptRoot
    
packer build `
     -var "username=$USERNAME" `
     -var "password=$PASSWORD" `
     -var "vm_output_directory=$VM_OUTPUT_DIRECTORY" `
     -var "base_image_directory=$VM_OUTPUT_DIRECTORY" `
     $PACKER_TEMPLATE
     
cd $CurrentPath