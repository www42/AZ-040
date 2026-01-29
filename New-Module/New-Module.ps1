$moduleName = 'MyToolbox'

$moduleBase = $env:PSModulePath.Split(';')[0]
$moduleFile = "$moduleBase\$moduleName\$moduleName.psm1"
dir $moduleFile

New-Item -ItemType file -Path $moduleFile -Force
psEdit $moduleFile

Get-Module -ListAvailable -Name $moduleName
Import-Module -Name $moduleName
Get-Command -Module $moduleName

Get-Weihnachten