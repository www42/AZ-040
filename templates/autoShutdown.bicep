param location string = resourceGroup().location
param vmName string
param vmId string

resource schedule 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${vmName}'
  location: location
  properties: {
    status: 'Enabled'
    dailyRecurrence: {
      time: '2000'
    }
    timeZoneId: 'W. Europe Standard Time'
    taskType: 'ComputeVmShutdownTask'
    targetResourceId: vmId
  }
}
