$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "../../VMsOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "customize/k3s"
$env:PACKER_TEMPLATE_NAME = "k3s"

& ..\..\Build.ps1