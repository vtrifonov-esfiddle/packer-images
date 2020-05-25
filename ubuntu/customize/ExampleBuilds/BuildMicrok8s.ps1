$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "../../ImagesOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "customize/microk8s"
$env:PACKER_TEMPLATE_NAME = "microk8s"

& ..\..\Build.ps1