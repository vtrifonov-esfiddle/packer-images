Param(
    [Parameter(Mandatory=$true)]
    [string] $VmName,
    [string] $Username = "username",
    [string] $GithubRepoUrl,
    [Parameter(Mandatory=$true)]
    [string] $GithubPAT
)

ssh $Username@$VmName "cd /home/$Username/ && bash configureGithubAgent.sh $GithubRepoUrl $GithubPAT"