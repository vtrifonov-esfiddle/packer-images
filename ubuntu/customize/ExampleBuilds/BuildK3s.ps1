$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "../../ImagesOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "customize/k3s"
$env:PACKER_TEMPLATE_NAME = "k3s"

& ..\..\Build.ps1