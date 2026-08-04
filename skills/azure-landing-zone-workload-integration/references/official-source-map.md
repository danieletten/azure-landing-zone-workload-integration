# Official Source Map

Verified Microsoft sources for citation. Links checked against Microsoft Learn on
2026-08-04. Prefer these over memory; do not fabricate URLs. Add a `TODO` if a
needed source cannot be verified.

## Landing zones and responsibilities
- Azure landing zones (platform vs application): https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/
- Design principles (policy-driven governance, subscription democratization): https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-principles
- Design areas: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-areas
- Deploy landing zones (application landing zone architectures): https://learn.microsoft.com/azure/architecture/landing-zones/landing-zone-deploy
- Subscription vending: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending

## Networking and private DNS
- Private Link and DNS integration at scale (platform-team vs application-owner responsibilities): https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale
- Private endpoint DNS: https://learn.microsoft.com/azure/private-link/private-endpoint-dns
- Private endpoint DNS integration scenarios: https://learn.microsoft.com/azure/private-link/private-endpoint-dns-integration
- Azure Private DNS zones: https://learn.microsoft.com/azure/dns/private-dns-privatednszone

## Policy and governance
- Policy effects: https://learn.microsoft.com/azure/governance/policy/concepts/effect-basics
- Policy exemption structure: https://learn.microsoft.com/azure/governance/policy/concepts/exemption-structure
- Built-in policy definitions: https://learn.microsoft.com/azure/governance/policy/samples/built-in-policies

## Identity and access
- Managed identities overview: https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/overview
- Azure RBAC built-in roles: https://learn.microsoft.com/azure/role-based-access-control/built-in-roles

## Reliability and cost
- Availability zones overview: https://learn.microsoft.com/azure/reliability/availability-zones-overview
- Regions and availability zones (WAF): https://learn.microsoft.com/azure/well-architected/design-guides/regions-availability-zones
- Regions overview: https://learn.microsoft.com/azure/reliability/regions-overview

## Sovereignty and residency
- Reliability and sovereignty: https://learn.microsoft.com/azure/reliability/concept-reliability-sovereignty
- Sovereignty implementation: https://learn.microsoft.com/azure/azure-sovereign-clouds/sovereignty-implementation
- Sovereign landing zone overview: https://learn.microsoft.com/industry/sovereign-cloud/sovereign-public-cloud/sovereign-landing-zone/overview-slz

## Infrastructure as code
- Azure Verified Modules: https://azure.github.io/Azure-Verified-Modules/

## Organization-specific (not a Microsoft source)
The following must come from the user's platform team; never invent them:
allowed regions, mandatory tags, naming standards, central private DNS zone list,
policy initiative list and exemption process, request/change intake, RTO/RPO
targets. Mark each as `TODO` until supplied.
