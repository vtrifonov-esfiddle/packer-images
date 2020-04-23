$RootPath = $PSScriptRoot
$IsoContentPath = "$RootPath\IsoContent"

function CleanupIsoContentPath() {
	if (Test-Path $IsoContentPath) {
		Remove-Item $IsoContentPath -Force -Recurse		
	}
	New-Item $IsoContentPath -ItemType Directory 
}

function GenerateSysprepUnattend([string] $Username, [string] $Password, [string] $Locale) {
	$sysprepXml = New-Object XML
	$sysprepXml.Load("$RootPath\SysprepUnattend\Windows.template.xml")
	
	$oobeSystem = $sysprepXml.unattend.settings[1]
	$MicrosoftWindowsInternationalCore = $oobeSystem.component[0]

	$MicrosoftWindowsInternationalCore.SystemLocale = $Locale
	$MicrosoftWindowsInternationalCore.UserLocale = $Locale

	$UserAccounts = $oobeSystem.component.UserAccounts
	$UserAccounts.AdministratorPassword.Value = $Password
	$UserAccounts.LocalAccounts.LocalAccount.DisplayName = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Name = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Description = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Password.Value = $Password
	
	$sysprepXml.Save("$IsoContentPath\SysprepUnattend.xml")
}

function GenerateIso($IsoFileName) {	
	$IsoOutputPath = "$RootPath\$IsoFileName.iso"
	if (test-path $IsoOutputPath){
		Remove-Item $IsoOutputPath -Force
	}
	# downloaded mkisofts.exe from: http://sourceforge.net/projects/tumagcc/files/schily-cdrtools-3.02a05.7z/download
	& $RootPath\mkisofs.exe -r -iso-level 4 -UDF -o $IsoOutputPath $IsoContentPath
}