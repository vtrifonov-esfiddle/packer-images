$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "../ImagesOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "ubuntu-desktop"
$env:PACKER_TEMPLATE_NAME = "ubuntu-desktop"

& ..\Build.ps1