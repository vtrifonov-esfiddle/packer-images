$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "VMsOutput"
$env:PACKER_TEMPLATE = "windows10-base.json"
$env:PACKER_WINDOWS_VERSION = "Win10"
$env:PACKER_LOCALE = "en-GB"

& ..\Build.ps1