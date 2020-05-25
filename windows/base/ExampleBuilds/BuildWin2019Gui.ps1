$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "ImagesOutput"
$env:PACKER_TEMPLATE = "winserver2019-base.json"
$env:PACKER_WINDOWS_VERSION = "Win2019"
$env:PACKER_LOCALE = "en-GB"
$env:PACKER_INSTALLATION_IMAGE_INDEX = 2

& ..\BaseBuild.ps1