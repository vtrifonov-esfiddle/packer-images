
[string] $SSH_USERNAME = $env:PACKER_USERNAME
[string] $SSH_PASSWORD = $env:PACKER_PASSWORD
[string] $VM_OUTPUT_DIRECTORY = $env:VM_OUTPUT_DIRECTORY
[string] $PACKER_TEMPLATE_DIRECTORY = $env:PACKER_TEMPLATE_DIRECTORY
[string] $PACKER_TEMPLATE_NAME = $env:PACKER_TEMPLATE_NAME
function Set-Parameter($Parameter, $Prompt) {
    if ([string]::IsNullOrEmpty($Parameter)) {
        $Parameter = Read-Host -Prompt $Prompt        
    }
    return $Parameter
}

$SSH_USERNAME = Set-Parameter $SSH_USERNAME  "SSH_USERNAME: "
$SSH_PASSWORD = Set-Parameter $SSH_PASSWORD "SSH_PASSWORD: "
$VM_OUTPUT_DIRECTORY = Set-Parameter $VM_OUTPUT_DIRECTORY "VM_OUTPUT_DIRECTORY: "
$PACKER_TEMPLATE_DIRECTORY = Set-Parameter $PACKER_TEMPLATE_DIRECTORY "PACKER_TEMPLATE_DIRECTORY: "
$PACKER_TEMPLATE_NAME = Set-Parameter $PACKER_TEMPLATE_NAME "PACKER_TEMPLATE_NAME: "

$CurrentPath = $PWD
cd "$PSSCriptRoot\$PACKER_TEMPLATE_DIRECTORY"
Write-Host "Running Packer template: $PSSCriptRoot\$PACKER_TEMPLATE_DIRECTORY\$PACKER_TEMPLATE_NAME.json"
packer build `
     -var "ssh_username=$SSH_USERNAME" `
     -var "ssh_password=$SSH_PASSWORD" `
     -var "vm_output_directory=$VM_OUTPUT_DIRECTORY" `
     -var "base_image_directory=$VM_OUTPUT_DIRECTORY" `
     "$PACKER_TEMPLATE_NAME.json"
cd $CurrentPath