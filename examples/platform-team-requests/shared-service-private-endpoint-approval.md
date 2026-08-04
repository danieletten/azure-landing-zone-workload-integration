# Platform request: shared-service private endpoint approval

**Status: Alternative illustrative example.** NOT required by the primary Contoso
Orders scenario. Shows a workload creating a private endpoint (in its own subnet)
to a **platform-owned shared service in another subscription**, where the platform
team must approve the private endpoint connection on the target resource. Fictional
values.

Follows
[`assets/platform-team-request.md`](../../skills/azure-landing-zone-workload-integration/assets/platform-team-request.md).

## Request identifier
REQ-orders-PE-shared-acr

## Requested capability or change
Approve the pending private endpoint connection from the workload to the shared
platform Azure Container Registry `acrsharedplatform` in subscription
`sub-platform-shared`. The workload pipeline creates the private endpoint in its own
`snet-private-endpoints` subnet; the platform team approves the connection on the
target registry.

- Target service: Azure Container Registry `acrsharedplatform`
- Target resource ID (fictional): `/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-platform-shared/providers/Microsoft.ContainerRegistry/registries/acrsharedplatform`
- Target subresource / group ID: `registry`
- Requester subscription / environment: `sub-contoso-orders-prod` / prod
- Private endpoint name: `pe-orders-acr`

## Business context
Contoso Orders pulls base images from the organization's shared container registry,
which is centrally managed by the platform team.

## Technical justification
The registry is in a different, platform-owned subscription. The workload can create
the private endpoint on its side, but a private endpoint connection to another
subscription's resource stays in `Pending` until the resource owner approves it.

## Existing automated path checked
Confirmed: **Private DNS integration is already automated** by Azure Policy
(`policy-dine`) for `privatelink.azurecr.io`, so no DNS request is needed. The only
gap is the connection approval on the platform-owned target.

## Platform request channel / owner
platform-requests@contoso.example (Cloud Platform Team).

## Affected subscription and environment
- Requester subscription: `sub-contoso-orders-prod`
- Environment: prod
- Affected resources: `pe-orders-acr` (workload side), `acrsharedplatform` (platform side)

## Relevant platform component
Shared platform Azure Container Registry + its private endpoint connection approval.

## Security and compliance implications
Least-exposure: a single approved private endpoint connection from one workload
subnet to one registry subresource; public network access on the registry stays
disabled; no new public exposure and no broad network path.

## Alternatives considered
Public registry access or a workload-local copy of images — rejected (public access
is denied by policy; a local copy defeats central image governance).

## Why workload-side remediation is insufficient
The connection must be approved on the target resource, which the workload team does
not own and cannot modify.

## Requested completion or dependency date
Before the first production image pull.

## Request owner
T. Lead, Contoso Orders.

## Validation and acceptance criteria
- The private endpoint connection state on `acrsharedplatform` is `Approved`.
- `acrsharedplatform.azurecr.io` resolves to the private IP from `snet-private-endpoints`.
- The workload can pull images privately.
- Public network access on the registry is not enabled.

## Rollback or expiry (where applicable)
When `pe-orders-acr` is removed, the platform team may reject/remove the
corresponding connection on the registry.
