# Platform request: network address-space / subnet allocation

**Status: Alternative illustrative example.** NOT required by the primary Contoso
Orders scenario. Shows a vended workload subscription that needs one additional
purpose-specific subnet when the contract sets `workloadMayCreateSubnets: false` and
central IPAM/routing is platform-owned. Fictional values.

Follows
[`assets/platform-team-request.md`](../../skills/azure-landing-zone-workload-integration/assets/platform-team-request.md).

## Request identifier
REQ-orders-subnet-002

## Requested capability or change
Allocate one additional subnet in the platform-managed VNet `vnet-orders-prod` for a
newly approved workload component. The platform team allocates the address range and
creates the subnet; the workload does not modify the VNet.

- Required minimum subnet size: **/27** (accommodates the component plus growth headroom)
- Intended service / delegation: dedicated subnet for Azure Container Apps environment infrastructure (delegation per the platform's approved pattern, if applicable)
- Environment: prod
- Existing VNet: `vnet-orders-prod`

> Note: no exact CIDR is prescribed — only the platform team can allocate a
> non-overlapping range via central IPAM. The request states size and purpose.

## Business context
A newly approved Contoso Orders component (async processing) requires its own subnet;
the existing App Service integration and private-endpoint subnets are purpose-bound
and cannot host it.

## Technical justification
Existing subnets are already delegated/purposed (App Service integration; private
endpoints) and cannot be reused for a different service. The contract sets
`workloadMayCreateSubnets: false`, and address allocation must avoid overlap with the
hub and other spokes.

## Existing automated path checked
Confirmed the contract's `networking.workloadMayCreateSubnets` is `false` and address
space is platform-owned; the workload cannot self-allocate.

## Platform request channel / owner
platform-requests@contoso.example (Cloud Platform Team).

## Affected subscription and environment
- Subscription: `sub-contoso-orders-prod`
- Environment: prod
- Affected resources: `vnet-orders-prod`

## Relevant platform component
Central IPAM, VNet address space, routing, and non-overlap validation.

## Security and compliance implications
The new subnet must inherit the required route table (central firewall egress) and
NSG baseline, and must not create a bypass of central egress. Consider effects on
routing, firewalling, NSGs, and any private endpoints placed there.

## Why the workload pipeline must not modify the platform-owned VNet directly
The VNet and its address space are platform-managed; direct edits risk overlap,
route/NSG drift, and breaking central non-overlap guarantees.

## Alternatives considered
Reusing an existing subnet — rejected (delegated/purpose-bound). Creating a second
VNet in the workload subscription — rejected (would require new peering and IPAM
coordination for no benefit).

## Requested completion or dependency date
Before the async component enters integration testing.

## Request owner
T. Lead, Contoso Orders.

## Validation and acceptance criteria
- A new non-overlapping subnet of at least /27 exists in `vnet-orders-prod`.
- It has the required route-table association (central egress) and NSG baseline.
- The workload can deploy the component into it; private endpoints (if any) resolve.
- No overlap with hub or other spokes is introduced.

## Rollback or deallocation
If the component is cancelled, the platform team deallocates the subnet and returns
the range to central IPAM.
