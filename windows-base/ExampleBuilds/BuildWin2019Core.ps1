$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "VMsOutput"
$env:PACKER_TEMPLATE = "winserver2019-base.json"
$env:PACKER_WINDOWS_VERSION = "Win2019"
$env:PACKER_LOCALE = "en-GB"
$env:PACKER_INSTALLATION_IMAGE_INDEX = 1

& ..\Build.ps1