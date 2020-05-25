Param(
    [Parameter(Mandatory=$true)]
    [string] $OldHostname,
    [Parameter(Mandatory=$true)]
    [string] $NewHostname,
    [string] $Username = "username"
)
ssh $Username@$OldHostname "sudo hostnamectl set-hostname $NewHostname && sudo shutdown -r 0"