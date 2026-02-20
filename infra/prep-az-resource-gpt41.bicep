@description('リソースをデプロイするリージョン（通常リソース）')
param location string = 'eastus2'

@description('作成するリソースに付加するユニークな値')
param randomString  string = uniqueString(resourceGroup().id)

var uniqueSuffix = toLower(randomString)

// Azure Cognitive Search
resource searchService 'Microsoft.Search/searchServices@2023-11-01' = {
  name: 'aisearch-${uniqueSuffix}'
  location: location
  sku: {
    name: 'standard'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
  }
}

// Storage Account（小文字・ハイフンなし制限）
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'storage${uniqueSuffix}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

// Blob Service（既存参照）
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' existing = {
  name: 'default'
  parent: storageAccount
}

// Blob コンテナー disneyland-map
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: 'disneyland-map'
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}

// Azure OpenAI アカウント
resource aoai 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: 'aoai-${uniqueSuffix}'
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: 'aoai-${uniqueSuffix}'
  }
}

resource gpt41 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
  name: 'gpt-4.1'
  parent: aoai
  sku: {
    name: 'GlobalStandard'
    capacity: 150
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4.1'
      version: '2025-04-14'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
}

resource textEmbedding3Large 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
  name: 'text-embedding-3-large'
  parent: aoai
  sku: {
    name: 'Standard'
    capacity: 120
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-3-large'
      version: '1'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
  dependsOn: [
    gpt41
  ]
}

// Outputs
output searchServiceName string = searchService.name
output aoaiEndpoint string = aoai.properties.endpoint
output storageAccountName string = storageAccount.name
