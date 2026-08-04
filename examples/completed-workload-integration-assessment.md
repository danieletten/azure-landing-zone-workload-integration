# Completed workload integration assessment (fictional)

A filled-in instance of
[`assets/workload-integration-assessment.md`](../skills/azure-landing-zone-workload-integration/assets/workload-integration-assessment.md)
for the **fictional** Contoso Orders production workload, assessed against the
generated platform contract in
[`subscription-vending-workflow/generated-workload-repository/.azure-platform/platform-contract.yaml`](subscription-vending-workflow/generated-workload-repository/.azure-platform/platform-contract.yaml).

## Platform contract
- Contract source and version: `contoso-example/platform-landing-zone` @ `a1b2c3d4…`, `contractVersion 1.4.0`.
- Product line: `corp-connected-online`.
- Contract present / absent: **present** (not degraded mode).
- Drift or conflict status: **none detected** (IaC matches contract egress, subnets, and DNS mechanism).

## Ownership
- Workload name: Contoso Orders API
- Business owner: A. Owner
- Technical owner: T. Lead

## Business context
- Business criticality: business-critical (tier 2)
- Environments and subscriptions: dev / test / prod (this assessment: prod, `sub-contoso-orders-prod`)

## Architecture and data
- Workload architecture: Linux App Service, Azure SQL Database, Blob Storage, Key Vault; Bicep IaC.
- Data classification: Confidential (from workload team).
- Regions and residency: EU only → `westeurope` (allowed by contract).

## Availability and recovery
- Availability target / RTO / RPO: 99.9% / 4h / 1h.

## Connectivity
- Inbound: private only (App Service private endpoint).
- Outbound and egress path: central Azure Firewall (from contract); one external dependency `api.payments.example` (443).
- Private endpoint and DNS dependencies: private endpoints in `snet-private-endpoints`; DNS automated by policy (`policy-dine`).

## Identity and secrets
- Identity and RBAC model: user-assigned managed identity; least-privilege roles on own resources; Entra auth for SQL.
- Secrets/keys: Key Vault; CMK for Confidential data is an open architecture decision.

## Operations and cost
- Monitoring and incident ownership: central `law-corp-central` (policy diagnostics); alerts owned by Orders on-call.
- Budget, cost center, tags: budget = Orders team; `CC-1234`; tags `costCenter`, `owner`, `dataClassification`.

## Governance and platform
- Policy conflicts: public-access Deny → resolved compliantly by disabling public access + private endpoints (no exemption).
- Shared platform services consumed: central firewall egress, central private DNS, central Log Analytics.

## Outcome

**Confirmed platform context (from contract):** Contributor scope; 5 providers
registered; two purpose-built subnets provisioned; DNS automated for all four
zones; central egress; central workspace; allowed EU regions; required tags.

**Assumptions and missing information:**
- CMK vs platform-managed keys (architecture decision).
- Zone-redundancy choice for 99.9% target (architecture decision).

**Workload team actions:**
1. Disable public network access on App Service, SQL, Storage, Key Vault.
2. Enable App Service regional VNet Integration into `snet-appservice-integration`; route outbound to central egress.
3. Create private endpoints in `snet-private-endpoints` for all four services.
4. User-assigned managed identity + least-privilege roles; Entra auth for SQL.
5. Apply required tags; pin to `westeurope`.

**Platform team dependencies (one row per genuine dependency):**

| Dependency | Required? | Request |
|---|---|---|
| Firewall egress to `api.payments.example` (443/TCP) | Yes | [`platform-team-requests/firewall-egress-rule.md`](platform-team-requests/firewall-egress-rule.md) |
| Private DNS integration | No — automated by policy | (illustrative: [`platform-team-requests/private-dns-integration.md`](platform-team-requests/private-dns-integration.md)) |
| Cross-subscription shared-service role | No — not needed here | (illustrative: [`platform-team-requests/shared-service-role-assignment.md`](platform-team-requests/shared-service-role-assignment.md)) |

**Shared decisions:** deployment sequencing and connectivity testing with the platform team.

**Unresolved architecture decisions:** CMK; zone redundancy.

## Readiness status

`Ready after platform dependency` — all workload actions can proceed now; go-live
gated only on the single firewall egress request.
