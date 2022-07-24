param location string = resourceGroup().location

param vnet object
param vnetName string

var bastionName = '${vnetName}-Bastion'
var bastionPipName = '${vnetName}-Bastion-Pip'

resource bastionPip 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: bastionPipName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2021-08-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          publicIPAddress: {
            id: bastionPip.id
          }
          subnet: {
            id: vnet.properties.subnets[1].id
          }
        }
      }
    ]
  }
}
