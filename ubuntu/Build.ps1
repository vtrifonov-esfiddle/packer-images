
[string] $SSH_USERNAME = $env:PACKER_USERNAME
[string] $SSH_PASSWORD = $env:PACKER_PASSWORD
[string] $IMAGE_OUTPUT_DIRECTORY = $env:IMAGE_OUTPUT_DIRECTORY
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
$IMAGE_OUTPUT_DIRECTORY = Set-Parameter $IMAGE_OUTPUT_DIRECTORY "IMAGE_OUTPUT_DIRECTORY: "
$PACKER_TEMPLATE_DIRECTORY = Set-Parameter $PACKER_TEMPLATE_DIRECTORY "PACKER_TEMPLATE_DIRECTORY: "
$PACKER_TEMPLATE_NAME = Set-Parameter $PACKER_TEMPLATE_NAME "PACKER_TEMPLATE_NAME: "

$CurrentPath = $PWD
cd "$PSSCriptRoot\$PACKER_TEMPLATE_DIRECTORY"
Write-Host "Running Packer template: $PSSCriptRoot\$PACKER_TEMPLATE_DIRECTORY\$PACKER_TEMPLATE_NAME.json"
$sshPublicKeyPath = Resolve-Path "~/.ssh/id_rsa.pub"
packer validate `
    -var "ssh_username=$SSH_USERNAME" `
    -var "ssh_password=$SSH_PASSWORD" `
    -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
    -var "base_image_directory=$IMAGE_OUTPUT_DIRECTORY" `
    -var "ssh_public_key_path=$sshPublicKeyPath" `
    "$PACKER_TEMPLATE_NAME.json"
if ($LastExitCode -eq 0) {
    packer build `
     -var "ssh_username=$SSH_USERNAME" `
     -var "ssh_password=$SSH_PASSWORD" `
     -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
     -var "base_image_directory=$IMAGE_OUTPUT_DIRECTORY" `
     -var "ssh_public_key_path=$sshPublicKeyPath" `
     "$PACKER_TEMPLATE_NAME.json"
}
cd $CurrentPath