$env:PACKER_USERNAME = "username"
$env:PACKER_PASSWORD = "password"
$env:PACKER_LOCALE = "en-GB"

& ..\AnswerIso\GenerateSysprepAnswerIso.ps1 -Username $env:PACKER_USERNAME `
    -Password $env:PACKER_PASSWORD `
    -Locale $env:PACKER_LOCALE