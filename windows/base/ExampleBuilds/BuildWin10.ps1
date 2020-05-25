$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "ImagesOutput"
$env:PACKER_TEMPLATE = "win10-base.json"
$env:PACKER_WINDOWS_VERSION = "Win10"
$env:PACKER_LOCALE = "en-GB"

& ..\BaseBuild.ps1