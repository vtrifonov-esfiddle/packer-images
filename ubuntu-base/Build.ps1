
[string] $SSH_USERNAME = "$env:PACKER_USERNAME"
[string] $SSH_PASSWORD = "$env:PACKER_PASSWORD"
[string] $VM_OUTPUT_DIRECTORY = "$env:VM_OUTPUT_DIRECTORY"

function Set-Parameter($Parameter, $Prompt) {
    if ([string]::IsNullOrEmpty($Parameter)) {
        $Parameter = Read-Host -Prompt $Prompt        
    }
    return $Parameter
}

$SSH_USERNAME = Set-Parameter $SSH_USERNAME  "SSH_USERNAME: "
$SSH_PASSWORD = Set-Parameter $SSH_PASSWORD "SSH_PASSWORD: "
$VM_OUTPUT_DIRECTORY = Set-Parameter $VM_OUTPUT_DIRECTORY "VM_OUTPUT_DIRECTORY: "

$CurrentPath = $PWD
cd $PSSCriptRoot
packer build `
     -var "ssh_username=$SSH_USERNAME" `
     -var "ssh_password=$SSH_PASSWORD" `
     -var "vm_output_directory=$VM_OUTPUT_DIRECTORY" `
     ubuntu-base.json 
cd $CurrentPath