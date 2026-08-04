// FICTIONAL workload IaC excerpt (C3). Conflicts with the platform contract:
// the contract mandates central Azure Firewall egress and forbids workload-owned
// standalone egress, but this deploys a NAT Gateway and associates it with the subnet.

resource natGateway 'Microsoft.Network/natGateways@2023-09-01' = {
  name: 'nat-orders-prod'
  location: 'westeurope'
  sku: { name: 'Standard' }
  properties: {
    publicIpAddresses: [ { id: pip.id } ]
    idleTimeoutInMinutes: 4
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-orders-nat'
  location: 'westeurope'
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

// Attempts to send outbound directly via NAT (bypassing the central firewall).
resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: 'vnet-orders-prod/snet-appservice-integration'
  properties: {
    natGateway: { id: natGateway.id }
  }
}
