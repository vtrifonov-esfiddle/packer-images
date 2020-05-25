
Param(
    [Parameter(Mandatory=$true)]
    [string] $GITHUB_TOKEN,
    [string] $SSH_USERNAME = "username",
    [string] $SSH_PASSWORD = "password",
    [string] $IMAGE_OUTPUT_DIRECTORY = "../ImagesOutput",
    [string] $VM_NAME = "ubuntu-agent-1",
    [string] $BASE_IMAGE_NAME = "ubuntu-docker"
)

$PACKER_TEMPLATE_NAME = "github-agent"

$CurrentPath = $PWD
cd "$PSSCriptRoot"
Write-Host "Running Packer template: $PSSCriptRoot\$PACKER_TEMPLATE_NAME.json"
packer build `
     -var "ssh_username=$SSH_USERNAME" `
     -var "ssh_password=$SSH_PASSWORD" `
     -var "IMAGE_OUTPUT_DIRECTORY=$IMAGE_OUTPUT_DIRECTORY" `
     -var "base_image_directory=$IMAGE_OUTPUT_DIRECTORY" `
     -var "GITHUB_TOKEN=$GITHUB_TOKEN" `
     -var "vm_name=$VM_NAME" `
     -var "base_image_name=$BASE_IMAGE_NAME" `
     "$PACKER_TEMPLATE_NAME.json"
cd $CurrentPath