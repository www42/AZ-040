Get-Command | Measure-Object

Get-Module | Measure-Object

Get-Help Get-Module

Get-Module -ListAvailable | Measure-Object

Get-Module  #  Verb-Noun  Syntax

Get-Date

Get-Command -Verb Get
Get-Command -Verb Set
Get-Command -Verb New

Get-Verb

Get-Command | Group-Object -Property Verb | Sort-Object -Property Count -Descending | Select-Object -First 5 | Format-Table Name,Count,Group

Get-Command -name Add-AdlAnalyticsDataSource | Format-List -Property *


Get-Command | Group-Object -Property CommandType

Get-Help Get-Date -Online

Get-Date -Year 2026 -Month 12 -Day 24 -Hour 19 -Minute 00 -Second 00

Get-Date | Select-Object -Property Year
Get-Date | Select-Object           Year

Get-Command mkdir
Get-Command mkdir | % Definition

Get-Alias | Measure-Object

# OO Scripting
Get-Date
Get-Date | Get-Member
Get-Date | Get-Member -MemberType Properties
Get-Date | Get-Member -MemberType Methods

(Get-Date).AddDays(-7)
(Get-Date).DayOfYear

Get-Date.DayOfYear     # Jeff Snover, Bruce Payette
(Get-Date).DayOfYear

$null | Get-Member

(Get-Date).DayOfYear
Get-Date | Select-Object -ExpandProperty DayOfYear

Get-Process | Select-Object -Property ProcessName,Id,WS
Get-Process -Id 1432
Get-Process -Name winlogon | Select-Object -ExpandProperty Id
(Get-Process -Name winlogon).Id


Start-Sleep -Seconds 10
gcm sleep

Get-Service -Name a*
Get-Service -Status Running # NO
Get-Service | Where-Object {$_.Status -eq 'Running'}
Get-Service -Name a* | Where-Object {$_.Status -eq 'Running'}
Get-Service -Name a* | Where-Object     Status -eq 'Running'
Get-Service -Name a* | Where            Status -eq 'Running'
Get-Service -Name a* | ?                Status -eq 'Running'
Get-Service -Name a* | ? Status -eq 'Running'
Get-Service -Name a* | ? Status

Get-Service | Get-Member -MemberType Properties

Get-Service -Name A*
Get-Service -Name A* | Select-Object Name,userName,Status

Get-Service | Where-Object StartType -EQ 'Automatic' | Where-Object Status -EQ 'stopped' | Format-Table Name,DisplayName,Status,StartType


Get-Service | Where-Object {$_.Status -eq 'stopped' -and $_.StartType -eq 'Automatic'}


Get-Help about_Comparison_Operators -Online

Get-Command -Noun Help

Get-Disk | Get-Member -MemberType Properties

Get-Disk | Select-Object Model,SerialNumber,Size
Get-Disk | Select-Object Model,SerialNumber, @{n='Size in GB'  ;  e={$_.Size/1GB}   }
Get-Disk | Select-Object Model,SerialNumber, @{n='Size in GB'  ;  e={'foo'}   }


# String Zeichenkette
'Wer rastet der hat Kaffe'


Get-Service -Name b* | Format-Table -Property Name,DisplayName,Status,StartType
Get-Service -Name b* | Format-List -Property Name,DisplayName,Status,StartType | Out-File -FilePath ./services.txt
dir
Get-Content ./services.txt


Get-Command -Verb Out
Get-Command -Verb Format

"Hello World!" | Out-Host
"Hello World!" | Format-Hex

Get-Service a* | Get-Member
Get-Service a* | Format-Table | Get-Member

Get-Service BITS
Get-Service BITS | Start-Service


Get-Command -Noun Csv
Get-Command -Verb ConvertTo

Get-Service BITS | ConvertTo-Json
Get-Service BITS | Select-Object Name,DisplayName,Status | ConvertTo-Json

Get-Service -Name a* | Sort-Object -Property Status | gm

''  # Single quotes
""  # Double quotes

"Bald ist Weihnachten" | Get-Member
("Bald ist Weihnachten").Length
("Bald ist Weihnachten.").ToUpper()
("Bald ist Weihnachten.").Split(' ') | Format-Hex

$env:Path.Split(';')
$env:Path.Split(';') | Get-Member
($env:Path.Split(';')).gettype()
$env:Path.Split(';')[0]


( $env:Path.Split(';') ).gettype()

(Get-Service BITS).GetType()