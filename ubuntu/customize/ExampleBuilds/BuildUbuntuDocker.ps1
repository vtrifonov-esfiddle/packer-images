$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "../../ImagesOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "customize/ubuntu-docker"
$env:PACKER_TEMPLATE_NAME = "ubuntu-docker"

& ..\..\Build.ps1