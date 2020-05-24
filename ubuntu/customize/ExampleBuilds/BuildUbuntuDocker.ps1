$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "../../VMsOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "customize/ubuntu-docker"
$env:PACKER_TEMPLATE_NAME = "ubuntu-docker"

& ..\..\Build.ps1