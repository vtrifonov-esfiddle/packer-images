Param(
	[Parameter(Mandatory=$true)]
	[string] $Username,
	[Parameter(Mandatory=$true)]
	[string] $Password,
	[Parameter(Mandatory=$true)]
	[string] $WindowsVersion, # Win10 Win2016 
	[string] $AnswerIsoDrive = "E:",
	[string] $Locale = "en-GB",
	# 1 ->  Windows Server 2016 Standard Evaluation/Windows 10 Enterprise Evaluation
	# 2 ->  Windows Server 2016 Standard Evaluation (Desktop Experience)
	# 3 ->  Windows Server 2016 Datacenter Evaluation
	# 4 ->  Windows Server 2016 Datacenter Evaluation (Desktop Experience)
	[int] $InstallationImageIndex = 1
)

. "$PSScriptRoot\..\..\answerIso\AnswerIso.ps1"

function GenerateAutountattend() {
	$AutounattendXml = New-Object XML
	$AutounattendXml.Load("$PSScriptRoot\Autounattend\$WindowsVersion.template.xml")
		
	$windowsPE = $AutounattendXml.unattend.settings[0]

	$MicrosoftWindowsInternationalCoreWinPE = $windowsPE.component[0]
	$MicrosoftWindowsInternationalCoreWinPE.InputLocale = $Locale
	$MicrosoftWindowsInternationalCoreWinPE.SystemLocale = $Locale
	$MicrosoftWindowsInternationalCoreWinPE.UserLocale = $Locale

	$InstallFromMetadata = $windowsPE.component.ImageInstall.OSImage.InstallFrom.Metadata
	$InstallFromMetadata.Value = "$InstallationImageIndex"

	$UserData = $windowsPE.component.UserData[2]
	$UserData.FullName = $Username
	$UserData.Organization = $Username
		
	$oobeSystem = $AutounattendXml.unattend.settings[2]

	if ($WindowsVersion -eq "Win10") {
		$MicrosoftWindowsInternationalCore = $oobeSystem.component[0]
		
		$MicrosoftWindowsInternationalCore.InputLocale = $Locale
		$MicrosoftWindowsInternationalCore.SystemLocale = $Locale
		$MicrosoftWindowsInternationalCore.UserLocale = $Locale
	}

	if ($WindowsVersion -eq "Win10") {
		$AutoLogon = $oobeSystem.component[1].AutoLogon
		$UserAccounts = $oobeSystem.component[1].UserAccounts
	}
	else {
		$AutoLogon = $oobeSystem.component.AutoLogon
		$UserAccounts = $oobeSystem.component.UserAccounts
	}
	
	$UserAccounts.AdministratorPassword.Value = $Password
	$UserAccounts.LocalAccounts.LocalAccount.DisplayName = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Name = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Description = $Username
	$UserAccounts.LocalAccounts.LocalAccount.Password.Value = $Password

	$AutoLogon.Password.Value = $Password
	$AutoLogon.Username = $Username
	
	function Get-SynchronousCommand([string] $CommandDescription) {
		$SynchronousCommand = $oobeSystem.component.FirstLogonCommands.SynchronousCommand | `
			Where-Object { $_.Description -eq $CommandDescription }
		return $SynchronousCommand
	}

	function Get-PowershellCommandFromAnswerIso($fileName) {
		return "cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -File $AnswerIsoDrive\$fileName -Username ""$Username"" -Password ""$Password"""
	}

	$SetupWinRM = Get-SynchronousCommand "Setup WinRM"
	$SetupWinRM.CommandLine = Get-PowershellCommandFromAnswerIso "SetupWinRM.ps1"

	$SetupWinRM = Get-SynchronousCommand "Setup Windows Settings"
	$SetupWinRM.CommandLine = Get-PowershellCommandFromAnswerIso "SetupWindowsSettings.ps1"

	$EnableMicrosoftUpdates = Get-SynchronousCommand "Enable Microsoft Updates"
	$EnableMicrosoftUpdates.CommandLine = Get-PowershellCommandFromAnswerIso "EnableMicrosoftUpdates.ps1"

	$InstallWindowsUpdates = Get-SynchronousCommand "Install Windows Updates"
	$InstallWindowsUpdates.CommandLine = Get-PowershellCommandFromAnswerIso "InstallWindowsUpdates.ps1"
	
	$AutounattendXml.Save("$IsoContentPath\Autounattend.xml")
}

function CopyInputScripts() {
	$InputScriptsPath = "$PSScriptRoot\InputScripts\*"
	Copy-Item -Path $InputScriptsPath -Destination $IsoContentPath 
}

CleanupIsoContentPath
GenerateAutountattend
GenerateSysprepUnattend $Username $Password $Locale
CopyInputScripts

GenerateIso "BaseAnswer"