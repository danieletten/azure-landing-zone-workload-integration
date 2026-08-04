// FICTIONAL representative workload Bicep for the Contoso Orders workload (clean-room).
// Illustrative only — not a complete deployable template.

param location string = 'westeurope'
param tags object = {
  costCenter: 'CC-1234'
  owner: 'contoso-orders'
  dataClassification: 'Confidential'
}

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'plan-orders-prod'
  location: location
  sku: { name: 'P1v3', tier: 'PremiumV3' }
  tags: tags
}

resource app 'Microsoft.Web/sites@2023-12-01' = {
  name: 'app-orders-prod'
  location: location
  tags: tags
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    publicNetworkAccess: 'Disabled'
    virtualNetworkSubnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnet-orders-prod', 'snet-appservice-integration')
    siteConfig: { vnetRouteAllEnabled: true, minTlsVersion: '1.2' }
  }
  identity: { type: 'UserAssigned', userAssignedIdentities: { '${uami.id}': {} } }
}

resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-orders-app'
  location: location
  tags: tags
}

resource sql 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: 'sql-orders-prod'
  location: location
  tags: tags
  properties: { publicNetworkAccess: 'Disabled', minimalTlsVersion: '1.2' }
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'storderprod01'
  location: location
  tags: tags
  sku: { name: 'Standard_ZRS' }
  kind: 'StorageV2'
  properties: { publicNetworkAccess: 'Disabled', allowBlobPublicAccess: false, minimumTlsVersion: 'TLS1_2' }
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-orders-prod'
  location: location
  tags: tags
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    publicNetworkAccess: 'Disabled'
  }
}

// NOTE: private endpoints for app (inbound), sql, storage, kv are expected in
// snet-private-endpoints; the outbound integration subnet above is delegated to
// Microsoft.Web/serverFarms and must not host private endpoints.
