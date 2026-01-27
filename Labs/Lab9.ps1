# Lab 9: Azure resource management with PowerShell

# --->LON-CL1

# Exercise 1: Activating the Azure subscription and installing the PowerShell Az module
# -------------------------------------------------------------------------------------
# Task 1: Activate your Azure subscription by using Azure pass voucher

# Task 2: Install the Azure Az module for PowerShell

$PSVersionTable.PSVersion
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Connect-AzAccount



# Exercise 2: Using Azure Cloud Shell
# -----------------------------------
# Task 1: Use Azure Cloud Shell to create a resource group
New-AzResourceGroup -Name "<yourname>M9" -Location westeurope



# Exercise 3: Managing Azure resources with Azure PowerShell
# ----------------------------------------------------------
# Task 1: Create an Azure VM by using PowerShell
$cred = Get-Credential -Message "Enter an admin username and password for the operating system"
$vmParams = @{
    ResourceGroupName = '<resource-group-name>'
    Name = 'TestVM1'
    Location = 'westeurope'
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
$VirtualMachine = Get-AzVM -ResourceGroupName "<yourname>M9" -Name "TestVM1"
Add-AzVMDataDisk -VM $VirtualMachine -Name "disk1" -LUN 0 -Caching ReadOnly -DiskSizeinGB 1 -CreateOption Empty
Update-AzVM -ResourceGroupName "<yourname>M9" -VM $VirtualMachine

# Task 3: Delete the Azure resources
Remove-AzResourceGroup -Name "<yourname>M9" -Force
