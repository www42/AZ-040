# Lab 9: Azure resource management with PowerShell

# --->LON-CL1
# --->Powershell 7

# Exercise 1: Activating the Azure subscription and installing the PowerShell Az module
# -------------------------------------------------------------------------------------
# Task 1: Open the Azure portal
# https://portal.azure.com

# Task 2: Install the Azure Az module for PowerShell
# ---> LON-CL1 pwsh
$PSVersionTable.PSVersion
# Update PowerShell 7 to the latest version
iex "& { $(irm https://aka.ms/install-powershell.ps1 -UseBasicP) }"

# Open a new PowerShell 7 window as an administrator
Start-Process -FilePath "C:\Users\Administrator.ADATUM\AppData\Local\Microsoft\powershell\pwsh.exe" -Verb RunAs

# Close the current PowerShell window
Stop-Process -Id $PID 

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Connect-AzAccount



# Exercise 2: Using Azure Cloud Shell
# -----------------------------------
# Task 1: Use Azure Cloud Shell to create a resource group

# ---> Cloudshell Powershell
Get-AzSubscription
Get-AzResourceGroup

# ---> Cloudshell Bash
az account list
az resource list

# ---> Cloudshell Powershell
New-AzResourceGroup -Name ResourceGroup1 -Location eastus




# Exercise 3: Managing Azure resources with Azure PowerShell
# ----------------------------------------------------------

# ---> LON-CL1 pwsh

# Task 1: Create an Azure VM by using PowerShell
$cred = Get-Credential -Message "Enter an admin username and password for the operating system"
$vmParams = @{
    ResourceGroupName = 'ResourceGroup1'
    Name = 'TestVM1'
    Size = 'Standard_D2s_v3'
    Location = 'eastus'
    ImageName = 'Win2019Datacenter'
    PublicIpAddressName = 'TestPublicIp'
    Credential = $cred
    OpenPorts = 3389
}
$newVM1 = New-AzVM @vmParams
$newVM1
$newVM1.OSProfile | Select-Object ComputerName,AdminUserName
$newVM1 | Get-AzNetworkInterface | Select-Object -ExpandProperty IpConfigurations | Select-Object Name,PrivateIpAddress
$rgName = $NewVM1.ResourceGroupName
$publicIp = Get-AzPublicIpAddress -Name TestPublicIp -ResourceGroupName $rgName
$publicIp | Select-Object Name,IpAddress,@{label='FQDN';expression={$_.DnsSettings.Fqdn}}
mstsc.exe /v $publicIp.IpAddress

# Task 2: Add a disk to the Azure VM by using PowerShell
$VirtualMachine = Get-AzVM -ResourceGroupName "ResourceGroup1" -Name "TestVM1"
Add-AzVMDataDisk -VM $VirtualMachine -Name "disk1" -LUN 0 -Caching ReadOnly -DiskSizeinGB 1 -CreateOption Empty
Update-AzVM -ResourceGroupName "ResourceGroup1" -VM $VirtualMachine

# Task 3: Delete the Azure resources
Remove-AzResourceGroup -Name ""ResourceGroup1" -Force
