$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "../VMsOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "ubuntu-desktop"
$env:PACKER_TEMPLATE_NAME = "ubuntu-desktop"

& ..\Build.ps1