$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "../VMsOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "microk8s"
$env:PACKER_TEMPLATE_NAME = "microk8s"

& ..\Build.ps1