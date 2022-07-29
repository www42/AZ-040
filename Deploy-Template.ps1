$Location       = 'westeurope'
$RgName         = 'Demo-RG'
$AdminPassword  = 'Pa55w.rd1234'

New-AzSubscriptionDeployment `
    -Name 'demoDeployment' `
    -TemplateFile 'main.bicep' `
    -Location $Location `
    -TemplateParameterObject @{location=$Location; rgName=$RgName; vmAdminPassword=$AdminPassword}


    
# Get-AzSubscriptionDeployment
# 
# Get-AzResourceGroupDeployment -ResourceGroupName $RgName | Format-Table DeploymentName,ProvisioningState, Mode, Timestamp
# New-AzResourceGroupDeployment -Name 'tabulaRasa' -ResourceGroupName $RgName -Mode Complete -TemplateUri "https://raw.githubusercontent.com/www42/arm/master/templates/empty.json" -Force -AsJob
# 
# Get-AzResource -ResourceGroupName $RgName | Sort-Object ResourceType | Format-Table Name,ResourceType