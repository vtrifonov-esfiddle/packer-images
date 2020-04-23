$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:VM_OUTPUT_DIRECTORY = "VMsOutput"
$env:PACKER_TEMPLATE = "winserver2019-iis.json"
$env:PACKER_LOCALE = "en-GB"

& ..\BuildIis.ps1