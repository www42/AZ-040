function Get-Lab {
    [CmdletBinding()]
    Param ( 
      [Parameter(Mandatory=$true, Position=0)]
      [ValidateSet("1","2","3","4","5","6","7","8","9","10","11")]
      [string]$Lab
    )
    $Url = "https://raw.githubusercontent.com/www42/AZ-040/master/Labs/Lab$Lab.ps1"
    $File = "$env:TEMP\Lab$Lab.ps1"
    Invoke-WebRequest -UseBasicParsing -Uri $Url | % Content > $File
    psEdit $File
}
Get-Lab

$Lab = '3'
$Url = "https://raw.githubusercontent.com/www42/AZ-040/master/Labs/Lab$Lab.ps1"
$Url = "https://raw.githubusercontent.com/www42/az-040/master/labs/Lab3.ps1"
Invoke-WebRequest -UseBasicParsing -Uri $Url | % Content