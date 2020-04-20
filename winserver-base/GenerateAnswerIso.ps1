Param(
	[Parameter(Mandatory=$true)]
	[string] $Username,
	[Parameter(Mandatory=$true)]
	[string] $Password,
	[string] $AnswerIsoDrive = "E:",
	[string] $Locale = "en-GB",
	# 1 ->  Windows Server 2016 Standard Evaluation
	# 2 ->  Windows Server 2016 Standard Evaluation (Desktop Experience)
	# 3 ->  Windows Server 2016 Datacenter Evaluation
	# 4 ->  Windows Server 2016 Datacenter Evaluation (Desktop Experience)
	[int] $InstallationImageIndex = 1
)
$RootPath = Resolve-Path ".\AnswerIso"
$OutputPath = "$RootPath\answer.iso"
$InputPath = "$RootPath\Input"

if (test-path $OutputPath){
	remove-item $OutputPath -Force
}

function GenerateAutountattend() {
	$AutounattendXml = New-Object XML
	$AutounattendXml.Load("$RootPath\Autounattend.template.xml")
		
	$windowsPE = $AutounattendXml.unattend.settings[0]

	$InstallFromMetadata = $windowsPE.component.ImageInstall.OSImage.InstallFrom.Metadata
	$InstallFromMetadata.Value = "$InstallationImageIndex"

	$UserData = $windowsPE.component.UserData[2]
	$UserData.FullName = $Username
	$UserData.Organization = $Username
	
	$oobeSystem = $AutounattendXml.unattend.settings[2]
	$UserAccounts = $oobeSystem.component.UserAccounts
	$UserAccounts.AdministratorPassword.Value = $Password
	$UserAccounts.LocalAccounts.LocalAccount.DisplayName = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Name = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Description = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Password.Value = $Password

	$AutoLogon = $oobeSystem.component.AutoLogon
	$AutoLogon.Password.Value = $Password
	$AutoLogon.Username = $Username
	
	function Get-SynchronousCommand([string] $CommandDescription) {
		$SynchronousCommand = $oobeSystem.component.FirstLogonCommands.SynchronousCommand | `
			Where-Object { $_.Description -eq $CommandDescription }
		return $SynchronousCommand
	}

	$disablePassword = Get-SynchronousCommand "Disable password expiration for default user"
	$disablePassword.CommandLine = "cmd.exe /c wmic useraccount where ""name='$Username'"" set PasswordExpires=FALSE"

	function Get-PowershellCommandFromAnswerIso($fileName) {
		return "cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File $AnswerIsoDrive\$fileName"
	}
	$SetPowersavingConfig = Get-SynchronousCommand "Turn off all power saving and timeouts"
	$SetPowersavingConfig.CommandLine = Get-PowershellCommandFromAnswerIso "SetPowerConfig.ps1"

	$EnableMicrosoftUpdates = Get-SynchronousCommand "Enable Microsoft Updates"
	$EnableMicrosoftUpdates.CommandLine = Get-PowershellCommandFromAnswerIso "EnableMicrosoftUpdates.ps1"

	$InstallWindowsUpdates = Get-SynchronousCommand "Install Windows Updates"
	$InstallWindowsUpdates.CommandLine = Get-PowershellCommandFromAnswerIso "InstallWindowsUpdates.ps1"

	$AutounattendXml.Save("$InputPath\Autounattend.xml")
}

function GenerateSysprepUnattend() {
	$sysprepXml = New-Object XML
	$sysprepXml.Load("$RootPath\SysprepUnattend.template.xml")
	
	$oobeSystem = $sysprepXml.unattend.settings[1]
	$MicrosoftWindowsInternationalCore = $oobeSystem.component[0]

	$MicrosoftWindowsInternationalCore.SystemLocale = $Locale
	$MicrosoftWindowsInternationalCore.UILanguage = $Locale
	$MicrosoftWindowsInternationalCore.UserLocale = $Locale

	$UserAccounts = $oobeSystem.component.UserAccounts
	$UserAccounts.AdministratorPassword.Value = $Password
	$UserAccounts.LocalAccounts.LocalAccount.DisplayName = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Name = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Description = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Password.Value = $Password
	
	$sysprepXml.Save("$InputPath\SysprepUnattend.xml")
}

GenerateAutountattend
GenerateSysprepUnattend

# downloaded mkisofts.exe from: http://sourceforge.net/projects/tumagcc/files/schily-cdrtools-3.02a05.7z/download
& $RootPath\mkisofs.exe -r -iso-level 4 -UDF -o $OutputPath $InputPath