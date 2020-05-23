Param(
	[Parameter(Mandatory=$true)]
	[string] $Username,
	[Parameter(Mandatory=$true)]
	[string] $Password,
	[Parameter(Mandatory=$true)]
	[string] $Locale
)

. "$PSScriptRoot\AnswerIso.ps1"

CleanupIsoContentPath
GenerateSysprepUnattend $Username $Password $Locale

GenerateIso "SysprepUnattend"