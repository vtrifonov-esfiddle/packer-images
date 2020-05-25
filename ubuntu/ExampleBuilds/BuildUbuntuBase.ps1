$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "../ImagesOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "ubuntu-base"
$env:PACKER_TEMPLATE_NAME = "ubuntu1804-base"

& ..\Build.ps1