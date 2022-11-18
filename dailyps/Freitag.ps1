# AZ-040
#
# Freitag
# =========================

Get-MyWeihnachten
gcm Get-MyIpAddress | % definition


# Ctrl-Space   --> IntelliSense (auch auf der einfachen Console)

# Ctrl-J   --> Snippets




[int]$x = 3
[int]$y = 5

if ($x -gt $y)
{
    Write-Output "$x > $y"
}
else 
{
    Write-Output "$x < $y"
}


Start-Job {Update-Help}

Get-Job
Receive-Job -Id 5 -Keep #   -Keep behält die Daten (Objects) in der Job Queue

Start-Job { dir C:\Windows }
get-job -Id 7 
Receive-Job -Id 7 -Keep

Get-Date ; Get-Service BITS

Get-Command -Noun Job

Start-Job {Get-Service BITS}
Receive-Job -id 9 -Keep | Get-Member

Get-Job -Id 9


# PowerShell Profiles
Get-ExecutionPolicy

$profile.CurrentUserAllHosts
dir $profile.CurrentUserAllHosts  # does not exist

New-Item -ItemType File -Path $profile.CurrentUserAllHosts -Force
psEdit $profile.CurrentUserAllHosts