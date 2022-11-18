# AZ-040 Donnerstag
# =================

Get-MyWeihnachten

Get-Command Get-MyWeihnachten | Select-Object -ExpandProperty Definition

Get-Help Get-MyWeihnachten

Get-MyWeihnachten | Get-Member

(Get-MyWeihnachten).replace("Weihnachten","Heilig Abend")


# Module 08 PowerShell Remoting
# -----------------------------

$env:COMPUTERNAME

ping LON-DC1

Test-NetConnection -ComputerName LON-DC1
Test-NetConnection -ComputerName LON-DC1 -Port 5985
Test-NetConnection -ComputerName LON-DC1 -CommonTCPPort WINRM

$DC1 = New-PSSession -ComputerName LON-DC1
Get-PSSession
Enter-PSSession -Id 1

$DC1
Enter-PSSession $DC1
exit

$DC1
                              Get-CimInstance Win32_OperatingSystem | % Caption 
Invoke-Command -Session $DC1 {Get-CimInstance Win32_OperatingSystem | % Caption }

Get-Help Invoke-Command -Parameter Session

Get-Help Get-Service -Parameter computername
Get-Service -Name winrm -ComputerName LON-DC1,LON-CL1 | ft MachineName,Status,StartType

# TrustedHosts
dir WSMan:\localhost\Client
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value 10.0.0.3 -Concatenate -Force


# Variable Scopes
$a = "Hallo"
$b = "Wien"
Write-Output $a

Invoke-Command -Session $DC1 {Write-Output "$using:a $using:b"}
Invoke-Command -Session $DC1 {Write-Output '$using:a $using:b'}

Get-Module -ListAvailable smbshare
Get-SmbShare

Import-Module -Name SmbShare -PSSession $DC1 -Prefix DC1
Get-SmbShare
Get-DC1SmbShare

Remove-PSSession -Session $DC1

Get-PSSession

Remove-Module -Name smbshare 


$ModuleRoot = Get-Module -ListAvailable ActiveDirectory | % ModuleBase

Remove-Item -Path $ModuleRoot/en-us -Recurse -Force

ConvertTo-Miles -kilometer 10 

$DC1 = New-PSSession -ComputerName LON-DC1

Import-Module -Name ConversionModule -PSSession $DC1



# Hash tables
$Table = @{Name = "Paul"; Size = 42; Color = "pink"}
$Table | Get-Member

$Table.Keys
$Table.Values

# Hash table --> Custom Object
New-Object -TypeName psobject -Property $Table

Get-date -day 24 -month 12

# Param Splatting
$Param = @{day = 24; month = 12}
Get-Date @Param


# Basic Array
$Array = @()
$Array.GetType()
$Array.IsFixedSize
$Array += "Peter"
$Array += "Paul"
$Array.Add("Mary")  # Does not work
$Array += "Mary"
$Array.Count
$Array -= "Array"

# Besser: ArrayList
$ArrayList = [System.Collections.ArrayList]@()
$ArrayList.GetType()
$ArrayList.IsFixedSize
# $ArrayList += "Peter"   # Vorsicht!  Es wird wieder zu Array!
# $ArrayList += "Paul"

$ArrayList.Add("Peter")
$ArrayList.Add("Paul")
$ArrayList.Add("Mary")

$User = "Peter2","Paul2"
$user.GetType()

$ArrayList.Add($user)

$ArrayList.Reverse()
$ArrayList



$n = 0
$SaveLocationName = $env:PSModulePath.Split(";")
$SaveLocationAnzahl = $env:PSModulePath.Split(";").count

write-Host "-----------------------------------------------------------------"
    while ($n -ne $SaveLocationAnzahl) {
        Write-Host $n $SaveLocationName[$n]
        $n++
    }
write-Host "-----------------------------------------------------------------"

write-Output "-----------------------------------------------------------------"
    while ($n -ne $SaveLocationAnzahl) {
        Write-Output $n $SaveLocationName[$n] 
        $n++
    }
write-Output "-----------------------------------------------------------------"
