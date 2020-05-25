
[string] $SSH_USERNAME = "$env:PACKER_USERNAME"
[string] $SSH_PASSWORD = "$env:PACKER_PASSWORD"
[string] $IMAGE_OUTPUT_DIRECTORY = "$env:IMAGE_OUTPUT_DIRECTORY"

function Set-Parameter($Parameter, $Prompt) {
    if ([string]::IsNullOrEmpty($Parameter)) {
        $Parameter = Read-Host -Prompt $Prompt        
    }
    return $Parameter
}

$SSH_USERNAME = Set-Parameter $SSH_USERNAME  "SSH_USERNAME: "
$SSH_PASSWORD = Set-Parameter $SSH_PASSWORD "SSH_PASSWORD: "
$IMAGE_OUTPUT_DIRECTORY = Set-Parameter $IMAGE_OUTPUT_DIRECTORY "IMAGE_OUTPUT_DIRECTORY: "

$CurrentPath = $PWD
cd $PSSCriptRoot

packer build `
     -var "ssh_username=$SSH_USERNAME" `
     -var "ssh_password=$SSH_PASSWORD" `
     -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
     -var "base_image_directory=$IMAGE_OUTPUT_DIRECTORY" `
     ubuntu-ansible-base.json
      
packer build `
     -var "ssh_username=$SSH_USERNAME" `
     -var "ssh_password=$SSH_PASSWORD" `
     -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
     -var "base_image_directory=$IMAGE_OUTPUT_DIRECTORY" `
     ubuntu-ansible-test.json 
cd $CurrentPath