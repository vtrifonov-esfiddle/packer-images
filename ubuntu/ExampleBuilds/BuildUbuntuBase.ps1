$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "../VMsOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "ubuntu-base"
$env:PACKER_TEMPLATE_NAME = "ubuntu1804-base"

& ..\Build.ps1