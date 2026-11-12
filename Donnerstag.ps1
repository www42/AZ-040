# Donnerstag
Get-PSDrive -Name Alias,Cert
Get-PSDrive Alias,Cert


Get-Command dir
Get-ChildItem cert:/currentuser/My
Get-ChildItem cert:/currentuser/My | Get-Member -MemberType Properties
Get-ChildItem cert:/currentuser/My | Select-Object FriendlyName,NotAfter

# Welche Zertifikate laufen in den nächsten 4 Wochen ab?
Get-ChildItem cert:/currentuser/My | Where-Object {$_.NotAfter -le (Get-Date).AddDays(28)} | Select-Object FriendlyName,Subject,NotAfter | Format-List

# Self signed Cert  for Codesigning
New-SelfSignedCertificate
get-help  New-SelfSignedCertificate -Online

# New file 
gcm pwd
Get-Location
gcm cd

New-Item -ItemType File -Name test.txt
New-Item -ItemType File -Name test2.txt | Out-Null

dir *.txt


# WMI (CIM) Datenbank
Get-CimInstance -ClassName Win32_BIOS | Select-Object                 SerialNumber,BIOSVersion
Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber

Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber | Get-Member
Get-CimInstance -ClassName Win32_BIOS | Select-Object                 SerialNumber | Get-Member


# Variable
$PSVersionTable
$true
$null

$a = Get-Date
$a
$a = $null
$a = $true
$a | Get-Member


$TageBisWeihnachten = 42

# Type Casting
$TageBisWeihnachten = [int]42
$TageBisWeihnachten = [string]42
$TageBisWeihnachten | Get-Member

$Heute = Get-Date
$Weihnachten = Get-Date -Day 24 -Month 12 -Year 2026 -Hour 19 -Minute 00

$Weihnachten - $Heute
$TageBisWeihnachten = ($Weihnachten - $Heute).Days

$TageBisWeihnachten.GetType()

Write-Output "Noch 42 Tage bis Weihnachten."
Write-Output "Noch $TageBisWeihnachten Tage bis Weihnachten."  # Double Quotes aka Gänsefüßchen  --> Var werden expandiert
Write-Output 'Noch $TageBisWeihnachten Tage bis Weihnachten.'  # Single Quotes                   --> Var werden *nicht* expandiert


Get-Weihnachten -year 2029

# Function Get-MyWeihnachten   (Prefix 'My' )    Get-ADUser  Get-MgUser (Prefix Mg  Microsoft Graph)  Get-AzVm (Prefix Az Azure)
# Module --> .psm1 Datei    MyTools


function Get-MyWeihnachten {

    param($year=(Get-Date).Year)

    Write-Host $year

    $Heute = Get-Date
    $Weihnachten = Get-Date -Day 24 -Month 12 -Year $year -Hour 19 -Minute 00

    $TageBisWeihnachten = ($Weihnachten - $Heute).Days

    Write-Output "Noch $TageBisWeihnachten Tage bis Weihnachten $Year."
}

Get-MyWeihnachten
Get-MyWeihnachten -year 2030

Get-Command Get-MyWeihnachten
Get-Command Get-MyWeihnachten | Select-Object -ExpandProperty Definition
Get-Help Get-MyWeihnachten

Get-Module -ListAvailable
$env:PSModulePath.Split(';')
$env:PSModulePath.Split(';')[0]

$ModuleRoot = $env:PSModulePath.Split(';')[0]
$ModuleName = 'MyTools'

# Module-Datei (Inhalt = Functions)
New-Item -ItemType File "$ModuleRoot/$ModuleName/$ModuleName.psm1" -Force
code "$ModuleRoot/$ModuleName/$ModuleName.psm1"

# Module-Manifest (Metadaten des Moduls)
New-ModuleManifest -Path "$ModuleRoot/$ModuleName/$ModuleName.psd1"
code "$ModuleRoot/$ModuleName/$ModuleName.psd1"