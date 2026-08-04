# Platform request: private DNS integration

**Status: Alternative illustrative example.** NOT required by the primary Contoso
Orders scenario, where private endpoint DNS is automated by Azure Policy
(`integrationMechanism: policy-dine`). Use this only when a contract's mechanism is
`platform-request` or `hybrid` for the zone in question. Fictional values.

Follows
[`assets/platform-team-request.md`](../../skills/azure-landing-zone-workload-integration/assets/platform-team-request.md).

## Request identifier
REQ-orders-DNS-illus

## Requested capability or change
Create the private DNS A record / zone group association for a private endpoint in
a `privatelink` zone that the platform does **not** auto-integrate.

## Business context
The workload's private endpoint cannot resolve to its private IP, so the
application cannot reach the service privately.

## Technical justification
The relevant `privatelink` zone is centrally managed and, per the contract, is not
covered by the policy-based DNS integration for this service; the record/zone-group
must be created by the platform.

## Existing automated path checked
Confirmed the contract's `privateDns.integrationMechanism` is **not** `policy-dine`
for this zone (otherwise no request is needed).

## Platform request channel / owner
platform-requests@contoso.example (Cloud Platform Team).

## Affected subscription and environment
- Subscription: `sub-contoso-orders-prod`
- Environment: prod
- Affected resources: the private endpoint and its target service

## Relevant platform component
Central private DNS zone / zone group.

## Security and compliance implications
DNS-only change; no new network exposure. Enables private resolution instead of
public access.

## Alternatives considered
Enabling public access or a local private DNS zone — rejected (violates policy and
would shadow the central zone).

## Why workload-side remediation is insufficient
The workload team cannot modify centrally managed private DNS zones.

## Requested completion or dependency date
Before the dependent service goes live.

## Request owner
T. Lead, Contoso Orders.

## Validation and acceptance criteria
The private endpoint FQDN resolves to its private IP from `snet-private-endpoints`;
public resolution is not required.

## Rollback or expiry (where applicable)
Record removed if the private endpoint is decommissioned.
