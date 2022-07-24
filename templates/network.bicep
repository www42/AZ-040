param location                 string = resourceGroup().location
param vnetName                 string = 'Vnet'
param vnetAddressSpace         string = '172.16.0.0/16'
param vnetSubnet0Name          string = 'Subnet0'
param vnetSubnet0AddressPrefix string = '172.16.0.0/24'
param vnetSubnet1Name          string = 'AzureBastionSubnet'
param vnetSubnet1AddressPrefix string = '172.16.255.32/27'

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: vnetSubnet0Name
        properties: {
          addressPrefix: vnetSubnet0AddressPrefix
        }
      }
      {
        name: vnetSubnet1Name
        properties: {
          addressPrefix: vnetSubnet1AddressPrefix
        }
      }
    ]
  }
}

output network object = vnet
output networkName string = vnet.name
