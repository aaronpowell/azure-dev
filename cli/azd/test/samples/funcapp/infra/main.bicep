@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param name string

@description('Primary location for all resources')
param location string

@description('A time to mark on created resource groups, so they can be cleaned up via an automated process.')
param deleteAfterTime string = dateTimeAdd(utcNow('o'), 'PT1H')

targetScope = 'subscription'

var resourceToken = toLower(uniqueString(subscription().id, name, location))
var tags = { 'azd-env-name': name, DeleteAfter: deleteAfterTime }

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${name}'
  location: location
  tags: tags
}

module resources 'resources.bicep' = {
  name: 'resources'
  scope: rg
  params: {
    location: location
    resourceToken: resourceToken
    tags: tags
  }
}

output AZURE_FUNCTION_URI string = resources.outputs.AZURE_FUNCTION_URI
