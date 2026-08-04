# Platform Team Request

> Produce one request per platform dependency. Keep each request explicit,
> least-privilege, and testable. Only request what the workload team cannot
> compliantly do itself — and not what the platform contract already reports as
> registered, automated, or workload-permitted.

## Request identifier
<Short ID for tracking, e.g. REQ-orders-001.>

## Requested capability or change
<Single, specific change. For firewall rules include source, destination, port,
and protocol. For role assignments include role and exact scope. For DNS include
zone and record.>

## Business context
<Why the workload needs this.>

## Technical justification
<What breaks without it; the technical detail.>

## Existing automated path checked
<Confirm the platform contract does not already cover this (e.g. DNS is not
`policy-dine` for this zone; provider is not already `registered`).>

## Platform request channel / owner
<From the contract: `supportChannel` / `platformOwner`.>

## Affected subscription and environment
- Subscription (name / ID):
- Environment (dev / test / prod):
- Affected resources:

## Relevant platform component
<Hub networking / central private DNS zone / Azure Firewall / central policy /
role on shared resource / subscription feature / other.>

## Security and compliance implications
<Exposure, blast radius, data paths, and any risk introduced or mitigated.>

## Alternatives considered
<Compliant workload-side options evaluated.>

## Why workload-side remediation is insufficient
<Explicit reason the workload team cannot resolve this itself. For an exemption,
confirm no compliant configuration exists.>

## Requested completion or dependency date
<Date and reason.>

## Request owner
<Name, email, on-call.>

## Validation and acceptance criteria
<How both teams confirm success, e.g. "private endpoint FQDN resolves to the
private IP from the workload subnet".>

## Rollback or expiry (where applicable)
<For time-bound changes or exemptions: expiry date, review owner, and rollback
plan.>
