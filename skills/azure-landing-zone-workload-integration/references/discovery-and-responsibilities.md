# Discovery and Responsibilities

Purpose: establish the workload context, discover the **organization-specific**
platform contract, and split responsibilities before assessing any domain.

## Establish workload context

Determine (record unknowns as assumptions or `TODO`, do not invent):

- Does an Azure Landing Zone / application landing zone already exist?
- Is a subscription already vended? Which environments are required?
- What workload architecture or IaC already exists?
- Business criticality, ownership, and operational requirements.
- Data classification, regions, and residency requirements.
- Availability and recovery targets (RTO/RPO).
- Known platform standards and dependencies.

If the user is still choosing Azure services from an app idea, hand off to
`azure-app-onboard`.

## Discover the platform contract

Search the repository and user-supplied documentation first. Use read-only Azure
discovery capabilities **only with explicit permission**. Discovery areas:

- Subscription and management group placement.
- Inherited Azure Policy assignments and existing exemptions.
- Resource provider registration.
- Virtual networks, delegated subnets, route tables, central egress.
- Private DNS integration and shared services.
- Existing RBAC assignments and managed identities.
- Diagnostic settings and monitoring destinations; Defender/compliance config.
- Required tags, budgets, and ownership metadata.

Rules:

- Do **not** treat the public Azure Landing Zone reference architecture as the
  organization's actual platform contract.
- When organization-specific information is unavailable, state the missing
  decision rather than assuming a value.

## Separate responsibilities

Classify each required capability as exactly one of:

1. Workload team responsibility
2. Platform team responsibility
3. Shared responsibility
4. Architecture decision required
5. Organization-specific and unresolved

Default classification (confirm against the real contract; do not present as
universal):

| Typically platform-owned | Typically workload-owned |
|---|---|
| Management groups, central Azure Policy | Resources inside the workload subscription |
| Hub networking, egress/firewall, route tables | Workload subnets, private endpoints, workload IaC |
| Central private DNS zones | Private endpoint config on workload resources |
| Identity platform (tenant, PIM, Conditional Access) | Workload managed identities, RBAC on workload resources |
| Central logging, Defender, Sentinel | Workload telemetry, alerts, incident ownership |
| Subscription vending | Workload cost ownership and tagging |

If ownership is ambiguous, treat it as platform-owned and raise a request.

## Common mistakes

- Assuming every organization uses the same responsibility model.
- Assuming subscription Owner rights.
- Treating reference architecture as the deployed platform.

## Expected output

- A populated (or gap-marked) assessment.
- A per-capability responsibility classification.
- A shortlist of items needing platform involvement.

See [official-source-map.md](official-source-map.md) for source links.
