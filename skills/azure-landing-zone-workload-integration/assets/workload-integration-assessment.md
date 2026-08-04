# Workload Integration Assessment

> Capture the workload context and integration outcome. Use `TODO` for unknowns
> and flag them; do not invent organization-specific values. Do not design a
> concrete integration while criticality, data classification, region/residency,
> or connectivity are unknown.

## Platform contract
- Contract source and version (`sourceRepository` @ `sourceRevision`, `contractVersion`):
- Product line:
- Contract present / absent (degraded mode?):
- Drift or conflict status (none / describe conflicting values and sources):

## Ownership
- Workload name:
- Business owner:
- Technical owner:

## Business context
- Business criticality:
- Environments and subscriptions (existing/vended/required):

## Architecture and data
- Workload architecture (services, existing IaC):
- Data classification:
- Regions and residency requirements:

## Availability and recovery
- Availability target / RTO / RPO:

## Connectivity
- Inbound connectivity (public / private / internal-only):
- Outbound connectivity and egress path (central firewall / NAT / forced tunnel):
- Private endpoint and DNS dependencies:

## Identity and secrets
- Identity and RBAC model (managed identity type, roles, scopes):
- Secrets, keys, and certificate dependencies (Key Vault, CMK):

## Operations and cost
- Monitoring and incident ownership (central workspace? alert owner?):
- Budget, cost center, and mandatory tags:

## Governance and platform
- Policy conflicts (assignment / effect / property):
- Shared platform services consumed:

## Outcome
- Confirmed platform context:
- Assumptions and missing information:
- Workload team actions:
- Platform team dependencies (one row per dependency):
- Shared decisions:
- Unresolved architecture decisions:

## Readiness status

Select one:

- `Ready`
- `Ready with workload actions`
- `Ready after platform dependency`
- `Blocked by workload decision`
- `Blocked by platform dependency`
- `Architecture decision required`
