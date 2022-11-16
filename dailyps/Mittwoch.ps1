# AZ-040 Mittwoch
# ===============

# Kalenderwoche
Get-Date -UFormat %V

Get-Help Get-Date -Parameter UFormat


# Module 5 WMI und CIM
# --------------------

# Beispiel
Get-CimInstance -ClassName Win32_OperatingSystem | fl *
Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty caption
Get-CimInstance -ClassName Win32_OperatingSystem | % caption

Get-CimInstance -ClassName Win32_BIOS | % SerialNumber
Get-WmiObject -Class Win32_BIOS | % SerialNumber

# CIM Methods
Get-CimClass -ClassName Win32_Service | Select-Object -ExpandProperty CimClassMethods

Get-Service bits
# Start-Service bits

#Invoke-CimMethod -ClassName Win32_Service -MethodName StartService -Arguments @{Name='Bits'}
Get-CimInstance -ClassName Win32_Service -Filter "Name='Bits'" | Invoke-CimMethod -MethodName StartService

# Module 6 Var etc
# ----------------
$Weihnachten = 42
$Weihnachten = "42"
$Weihnachten = [int]42
$Weihnachten = [string]42  # Type casting

$Weihnachten | Get-Member
$Weihnachten.GetType()

dir Variable:\Weihnachten
$Weihnachten = $null

Get-Command -Noun variable
Set-Variable -Name Weihnachten -Value 45 
Get-Variable -Name Weihnachten
Clear-Variable -Name Weihnachten
Remove-Variable -Name Weihnachten

# Built in var
dir variable:
$PSVersionTable


# Windows Evirontment
$env:Path
$env:PSModulePath

$env:PSModulePath.Split(";")
$env:PSModulePath.Split(";") | Get-Member  #  string
$env:PSModulePath.Split(";").gettype()     #  array

$env:PSModulePath.Split(";")[0]

$Weihnachten=42

Write-Output "Noch $Weihnachten Tage bis Weihnachten."
Write-Output 'Noch $Weihnachten Tage bis Weihnachten.'

[string]$a = 4
[int]$b = 2

$a + $b

# Tage bis Weihnachten
Get-Date -Day 24 -Month 12 -Hour 20 -Minute 00 -Second 00 -Year 2022 -OutVariable Weihnachten
# oder
$Weihnachten = Get-Date -Day 24 -Month 12 -Hour 20 -Minute 00 -Second 00 -Year 2022

$Heute = Get-Date
$TageBisWeihnachten = ($Weihnachten - $Heute).Days

Write-Output "Noch $TageBisWeihnachten Tage bis Weihnachten."

# Meine erste function

function Get-MyWeihnachten {
    $Weihnachten = Get-Date -Day 24 -Month 12 -Hour 20 -Minute 00 -Second 00 -Year 2022
    $Heute = Get-Date
    $TageBisWeihnachten = ($Weihnachten - $Heute).Days
    Write-Output "Noch $TageBisWeihnachten Tage bis Weihnachten."
}

# laden (= dot source)

Get-MyWeihnachten

Get-Command Get-MyWeihnachten


# Module "MyToolbox" anlegen

$ModuleRoot     = $env:PSModulePath.Split(";")[0]
$ModuleName     = "MyToolbox"
$ModuleFile     = "$ModuleRoot/$ModuleName/$ModuleName.psm1"
$ModuleManifest = "$ModuleRoot/$ModuleName/$ModuleName.psd1"

dir $ModuleManifest
Get-Command -Name *Manifest*

New-ModuleManifest -Path $ModuleManifest 

New-Item -ItemType File -Path $ModuleFile -Force

psEdit $ModuleFile
psEdit $ModuleManifest


# Execution Policy
Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy AllSigned -Force

Import-Module -Name MyToolbox -Force


# Code Signing

$Cert = New-SelfSignedCertificate `
    -CertStoreLocation Cert:\CurrentUser\My `
    -Subject "cn=Paul Drude,dc=Adatum,dc=com" `
    -TextExtension "2.5.29.37={text}1.3.6.1.5.5.7.3.3"

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Set-ExecutionPolicy -ExecutionPolicy AllSigned -Force
Set-ExecutionPolicy -ExecutionPolicy Restricted -Force
Get-ExecutionPolicy

C:\tmp\Hello.ps1
Set-AuthenticodeSignature -FilePath C:\tmp\Hello.ps1 -Certificate $Cert
Get-AuthenticodeSignature -FilePath C:\tmp\Hello.ps1

dir Cert:\CurrentUser\My  -CodeSigningCert




# User input
Get-Credential
$Cred = Get-Credential
$Cred

$Cred.GetNetworkCredential() | fl *

$secstring = ConvertTo-SecureString -String 'geheim123' -AsPlainText -Force
$secstring | ConvertFrom-SecureString