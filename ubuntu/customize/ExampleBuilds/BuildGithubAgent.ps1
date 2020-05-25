$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "../../ImagesOutput"
$env:PACKER_TEMPLATE_DIRECTORY = "customize/github-agent"
$env:PACKER_TEMPLATE_NAME = "github-agent"

& ..\..\Build.ps1