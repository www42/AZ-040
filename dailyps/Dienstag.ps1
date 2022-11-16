Get-Date

Get-Command | Measure-Object

Get-Service -Name bits
Get-Service -Name bits | Get-Member

# Genau eine Property abfragen
(Get-Service -Name bits).DisplayName
(Get-Service -Name bits).Status
(Get-Service -Name bits).StartType

(Get-Service -Name bits,netlogon).status

(Get-Service -Name bits).foo

Get-Service -Name bits | Get-Member -Name StartType
Get-Service -Name bits | Get-Member -Name foo


Get-Service -Name bits | Get-Member

(Get-Service -Name BITS).Displayname | Get-Member
(Get-Service -Name BITS).Displayname.Length

(Get-Service -Name BITS).Displayname.ToUpper()
(Get-Service -Name BITS).Displayname.ToLower()
(Get-Service -Name BITS).Displayname.Replace("a","y")

"Hallo Wien" | Get-Member
"Hallo Wien".Replace("Wien","Kaffemaschine")


Get-Service | Sort-Object -Property Status
Get-Service | Sort-Object -Property DisplayName -Descending


Get-Service -Name B*
Get-Service -status running    # geht nicht

Get-Service | Where-Object {$_.Status -eq "running"}  # lang
Get-Service | Where-Object Status -eq "running"       # kurz
Get-Service | where status -eq "running"
Get-Service | ? status -eq "running"


# Select Properties
Get-Service | Select-Object -Property Name,StartType
Get-Service | Select-Object -Property Name,StartType | gm

# Select Objects
Get-Service | Select-Object -First 5

# Expand Property
Get-Service -Name BITS | Select-Object -ExpandProperty Displayname

Get-Service -Name BITS | % Displayname
Get-Service -Name BITS | ForEach-Object {$_.DisplayName}

Get-Command %

Get-Service | Select-Object -First 4 | ForEach-Object {$_.DisplayName}




Get-Service | Where-Object Name -EQ   "a*"
Get-Service | Where-Object Name -EQ   "A*"
Get-Service | Where-Object Name -like "a*"         # kurz
Get-Service | Where-Object {$_.Name -like "a*"}    # lang
Get-Service | Where-Object {$_.Name -like "a*" -and $_.status -eq "Running"}


# Out-
Get-Command -Verb out

Get-Service | Where-Object {$_.Name -like "a*" -and $_.status -eq "Running"} | Out-File C:\tmp\Services.txt
notepad C:\tmp\Services.txt

# Export-
Get-Command -Verb export

Get-Service | Where-Object {$_.Name -like "a*" -and $_.status -eq "Running"} | 
    Select-Object -Property Name,Status,StartType | 
    Export-Csv -Path C:\tmp\Services.csv -NoTypeInformation



notepad C:\tmp\Services.csv

gcm -noun printer
Get-Printer

Get-Service | Where-Object {$_.Name -like "a*" -and $_.status -eq "Running"} |
    Out-Printer -Name "Microsoft Print to PDF"

dir c:\tmp\services.*


gcm mkdir
mkdir C:\test
mkdir C:\test\dir1
mkdir C:\test\dir2 | Out-Null
dir C:\test


Get-Service -Name b* | Out-GridView -PassThru | Start-Service

Get-Service bits

gcm Tee-Object

# Parameter Binding
# -----------------

Get-Help Start-Service -Parameter Name
Get-Help Start-Service -Parameter DisplayName

# Calculated Properties
Get-Volume | Select-Object DriveLetter,Size,SizeRemaining

50 - 8 
# 1kB 1MB 1GB 1TB 1PB

Get-Volume | Select-Object DriveLetter,@{n="foo"; e={ '{0,6:N2}' -f ($_.Size/1GB)}},SizeRemaining | gm -MemberType Properties



# Firewall Rules
Get-NetFirewallRule | Select-Object -first 5 | Select-Object displayName,Direction
Get-NetFirewallRule | Get-Member -Name Direction


# Module (Learning Path) 4
Get-PSDrive
dir hkcu:
dir cert:
dir Cert:\LocalMachine
dir Cert:\LocalMachine\Root | Sort-Object -Property Subject
dir Cert:\LocalMachine\Root | Get-Member -Name notafter

$weihnachten = Get-Date -day 24 -Month 12 -Hour 20 -Minute 00 -Second 00
$heute = Get-Date
$weihnachten - $heute | gm

Get-Item -Path Cert:\LocalMachine\Root\D4DE20D05E66FC53FE1A50882C78DB2852CAE474 | Format-List *
(Get-Item -Path Cert:\LocalMachine\Root\D4DE20D05E66FC53FE1A50882C78DB2852CAE474).NotAfter

dir cert: -Recurse | Where-Object FriendlyName -Like "*Baltimore*" | ft Thumbprint,psparentpath

Get-PSProvider

dir wsman:
dir WSMan:\localhost\Listener\Listener_1084132640