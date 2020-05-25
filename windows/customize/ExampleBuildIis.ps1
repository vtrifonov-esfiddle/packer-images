$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:IMAGE_OUTPUT_DIRECTORY = "../ImagesOutput"
$env:PACKER_TEMPLATE = "winserver2019-iis.json"
$env:PACKER_LOCALE = "en-GB"

& .\BuildIis.ps1