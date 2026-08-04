# Platform request: firewall egress rule

**Status: Required by the primary Contoso Orders scenario.** Fictional values.

Follows
[`assets/platform-team-request.md`](../../skills/azure-landing-zone-workload-integration/assets/platform-team-request.md).

## Request identifier
REQ-orders-001

## Requested capability or change
Allow outbound HTTPS from `snet-appservice-integration` (VNet `vnet-orders-prod`,
`sub-contoso-orders-prod`) to `api.payments.example` on TCP/443 through the central
Azure Firewall.

## Business context
Contoso Orders must call the external payment provider to authorize orders. Without
egress, checkout fails in production.

## Technical justification
App Service outbound traffic is routed through the central firewall (forced tunnel).
The destination FQDN is workload-specific and not in any existing allow rule.

## Existing automated path checked
Confirmed: egress is centrally controlled (`networking.egress` = central firewall),
`workloadMayCreateSubnets: false`, and no existing rule covers this FQDN. The
workload cannot open central firewall rules itself.

## Platform request channel / owner
platform-requests@contoso.example (Cloud Platform Team).

## Affected subscription and environment
- Subscription: `sub-contoso-orders-prod` (`00000000-0000-0000-0000-000000000000`)
- Environment: prod
- Affected resources: App Service (via `snet-appservice-integration`)

## Relevant platform component
Central Azure Firewall (application rule collection).

## Security and compliance implications
Single destination FQDN over 443 only; least-privilege. No inbound exposure. Payment
data leaves via an approved, logged egress path.

## Alternatives considered
Direct internet egress from the workload — rejected (violates forced tunnel and
central egress policy).

## Why workload-side remediation is insufficient
The workload team cannot modify central firewall rules; egress is platform-owned.

## Requested completion or dependency date
Before production go-live (target: 2 weeks). Reason: blocks checkout.

## Request owner
T. Lead, Contoso Orders (on-call: orders-oncall@contoso.example).

## Validation and acceptance criteria
From an App Service instance, an HTTPS request to `https://api.payments.example`
succeeds; the firewall logs show the allowed flow; no other destinations are opened.

## Rollback or expiry (where applicable)
Rule may be removed if the payment integration is retired; review at next
architecture review.
