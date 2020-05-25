$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "../ImagesOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "ubuntu-server"
$env:PACKER_TEMPLATE_NAME = "ubuntu-server"

& ..\Build.ps1