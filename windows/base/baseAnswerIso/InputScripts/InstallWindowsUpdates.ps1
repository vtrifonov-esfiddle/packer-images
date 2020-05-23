param($global:RestartRequired=0,
        $global:MoreUpdates=0,
        $global:MaxCycles=5,
        $MaxUpdatesPerCycle=500,
        $BeginWithRestart=0)

. "$PSScriptRoot\Logger.ps1"
$Logger = [Logger]::new("InstallWindowsUpdates.log")


function Check-ContinueRestartOrEnd() {
    $RegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $RegistryEntry = "InstallWindowsUpdates"
    switch ($global:RestartRequired) {
        0 {
            $prop = (Get-ItemProperty $RegistryKey).$RegistryEntry
            if ($prop) {
                $Logger.Write("Restart Registry Entry Exists - Removing It")
                Remove-ItemProperty -Path $RegistryKey -Name $RegistryEntry -ErrorAction SilentlyContinue
            }

            $Logger.Write("No Restart Required")
            Check-WindowsUpdates

            if (($global:MoreUpdates -eq 1) -and ($script:Cycles -le $global:MaxCycles)) {
                Install-WindowsUpdates
            } elseif ($script:Cycles -gt $global:MaxCycles) {
                $Logger.Write("Exceeded Cycle Count - Stopping")
                & "$PSScriptRoot\EnableWinRM.ps1"
            } else {
                $Logger.Write("Done Installing Windows Updates")
                & "$PSScriptRoot\EnableWinRM.ps1"
            }
        }
        1 {
            $prop = (Get-ItemProperty $RegistryKey).$RegistryEntry
            if (-not $prop) {
                $Logger.Write("Restart Registry Entry Does Not Exist - Creating It")
                Set-ItemProperty -Path $RegistryKey -Name $RegistryEntry -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File $($script:ScriptPath) -MaxUpdatesPerCycle $($MaxUpdatesPerCycle)"
            } else {
                $Logger.Write("Restart Registry Entry Exists Already")
            }

            $Logger.Write("Restart Required - Restarting...")
            Restart-Computer
        }
        default {
            $Logger.Write("Unsure If A Restart Is Required")
            break
        }
    }
}

function Install-WindowsUpdates() {
    $script:Cycles++
    $Logger.Write("Evaluating Available Updates with limit of $($MaxUpdatesPerCycle):")
    $UpdatesToDownload = New-Object -ComObject 'Microsoft.Update.UpdateColl'
    $script:i = 0;
    $CurrentUpdates = $SearchResult.Updates
    while($script:i -lt $CurrentUpdates.Count -and $script:CycleUpdateCount -lt $MaxUpdatesPerCycle) {
        $Update = $CurrentUpdates.Item($script:i)
        if ($null -ne $Update) {
            [bool]$addThisUpdate = $false
            if ($Update.InstallationBehavior.CanRequestUserInput) {
                $Logger.Write("> Skipping: $($Update.Title) because it requires user input")
            } else {
                if (!($Update.EulaAccepted)) {
                    $Logger.Write("> Note: $($Update.Title) has a license agreement that must be accepted. Accepting the license.")
                    $Update.AcceptEula()
                    [bool]$addThisUpdate = $true
                    $script:CycleUpdateCount++
                } else {
                    [bool]$addThisUpdate = $true
                    $script:CycleUpdateCount++
                }
            }

            if ([bool]$addThisUpdate) {
                $Logger.Write("Adding: $($Update.Title)")
                $UpdatesToDownload.Add($Update) |Out-Null
            }
        }
        $script:i++
    }

    if ($UpdatesToDownload.Count -eq 0) {
        $Logger.Write("No Updates To Download...")
    } else {
        $Logger.Write('Downloading Updates...')
        $ok = 0;
        while (! $ok) {
            try {
                $Downloader = $UpdateSession.CreateUpdateDownloader()
                $Downloader.Updates = $UpdatesToDownload
                $Downloader.Download()
                $ok = 1;
            } catch {
                $ExceptionMessage = $_.Exception | Format-List -force
                $Logger.Write($ExceptionMessage)
                $Logger.Write("Error downloading updates. Retrying in 30s.")
                $script:attempts = $script:attempts + 1
                Start-Sleep -s 30
            }
        }
    }

    $UpdatesToInstall = New-Object -ComObject 'Microsoft.Update.UpdateColl'
    [bool]$rebootMayBeRequired = $false
    $Logger.Write('The following updates are downloaded and ready to be installed:')
    foreach ($Update in $SearchResult.Updates) {
        if (($Update.IsDownloaded)) {
            $Logger.Write("> $($Update.Title)")
            $UpdatesToInstall.Add($Update) |Out-Null

            if ($Update.InstallationBehavior.RebootBehavior -gt 0){
                [bool]$rebootMayBeRequired = $true
            }
        }
    }

    if ($UpdatesToInstall.Count -eq 0) {
        $Logger.Write('No updates available to install...')
        $global:MoreUpdates=0
        $global:RestartRequired=0
        & "$PSScriptRoot\EnableWinRM.ps1"
        break
    }

    if ($rebootMayBeRequired) {
        $Logger.Write('These updates may require a reboot')
        $global:RestartRequired=1
    }

    $Logger.Write('Installing updates...')

    $Installer = $script:UpdateSession.CreateUpdateInstaller()
    $Installer.Updates = $UpdatesToInstall
    $InstallationResult = $Installer.Install()

    $Logger.Write("Installation Result: $($InstallationResult.ResultCode)")
    $Logger.Write("Reboot Required: $($InstallationResult.RebootRequired)")
    $Logger.Write('Listing of updates installed and individual installation results:')
    if ($InstallationResult.RebootRequired) {
        $global:RestartRequired=1
    } else {
        $global:RestartRequired=0
    }

    for($i=0; $i -lt $UpdatesToInstall.Count; $i++) {
        New-Object -TypeName PSObject -Property @{
            Title = $UpdatesToInstall.Item($i).Title
            Result = $InstallationResult.GetUpdateResult($i).ResultCode
        }
        $Logger.Write("Item: $($UpdatesToInstall.Item($i).Title)")
        $Logger.Write("Result: $($InstallationResult.GetUpdateResult($i).ResultCode)")
    }

    Check-ContinueRestartOrEnd
}

function Check-WindowsUpdates() {
    $Logger.Write("Checking For Windows Updates")
    $Username = $env:USERDOMAIN + "\" + $env:USERNAME
    $Logger.Write("Script: " + $ScriptPath + "`nScript User: " + $Username + "`nStarted: " + (Get-Date).toString())

    $script:UpdateSearcher = $script:UpdateSession.CreateUpdateSearcher()
    $script:successful = $FALSE
    $script:attempts = 0
    $script:maxAttempts = 12
    while(-not $script:successful -and $script:attempts -lt $script:maxAttempts) {
        try {
            $script:SearchResult = $script:UpdateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")
            $script:successful = $TRUE
        } catch {
            $ExceptionMessage = $_.Exception | Format-List -force
            $Logger.Write($ExceptionMessage)
            $Logger.Write("Search call to UpdateSearcher was unsuccessful. Retrying in 10s.")
            $script:attempts = $script:attempts + 1
            Start-Sleep -s 10
        }
    }

    if ($SearchResult.Updates.Count -ne 0) {
        $Message = "There are " + $SearchResult.Updates.Count + " more updates."
        $Logger.Write($Message)
        try {
            for($i=0; $i -lt $script:SearchResult.Updates.Count; $i++) {
              $Logger.Write($script:SearchResult.Updates.Item($i).Title)
              $Logger.Write($script:SearchResult.Updates.Item($i).Description)
              $Logger.Write($script:SearchResult.Updates.Item($i).RebootRequired)
              $Logger.Write($script:SearchResult.Updates.Item($i).EulaAccepted)
          }
            $global:MoreUpdates=1
        } catch {
            $ExceptionMessage = $_.Exception | Format-List -force
            $Logger.Write($ExceptionMessage)
            $Logger.Write("Showing SearchResult was unsuccessful. Rebooting.")
            $global:RestartRequired=1
            $global:MoreUpdates=0
            Check-ContinueRestartOrEnd
            $Logger.Write("Show never happen to see this text!")
            Restart-Computer
        }
    } else {
        $Logger.Write('There are no applicable updates')
        $global:RestartRequired=0
        $global:MoreUpdates=0        
    }
}

$script:ScriptName = $MyInvocation.MyCommand.ToString()
$script:ScriptPath = $MyInvocation.MyCommand.Path
$script:UpdateSession = New-Object -ComObject 'Microsoft.Update.Session'
$script:UpdateSession.ClientApplicationID = 'Packer Windows Update Installer'
$script:UpdateSearcher = $script:UpdateSession.CreateUpdateSearcher()
$script:SearchResult = New-Object -ComObject 'Microsoft.Update.UpdateColl'
$script:Cycles = 0
$script:CycleUpdateCount = 0

if ($BeginWithRestart) {
  $global:RestartRequired = 1
  Check-ContinueRestartOrEnd
}

Check-WindowsUpdates
if ($global:MoreUpdates -eq 1) {
    Install-WindowsUpdates
} else {
    Check-ContinueRestartOrEnd
}