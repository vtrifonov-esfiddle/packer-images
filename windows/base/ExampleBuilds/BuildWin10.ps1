$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "VMsOutput"
$env:PACKER_TEMPLATE = "win10-base.json"
$env:PACKER_WINDOWS_VERSION = "Win10"
$env:PACKER_LOCALE = "en-GB"

& ..\BaseBuild.ps1