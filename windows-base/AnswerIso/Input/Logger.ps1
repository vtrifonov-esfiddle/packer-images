class Logger {
    [string] $LogFilePath;

    Logger([string] $LogFileName){
        $LogsDir =  "$env:windir\Temp\Packer"
        if (-not (Test-Path $LogsDir)) {
            New-Item -Path $LogsDir -ItemType Directory
        }
        $this.LogFilePath = "$LogsDir\$LogFileName"
    }

    Write([string]$LogString) {
        $Timestamp = Get-Date -format s
        $LogMessage = "$Timestamp $LogString"
        Add-Content $this.LogFilePath  -value $LogMessage
     
        Write-Host $LogMessage
    }
}