# Example: App Service workload integration after subscription vending

A fully **fictional** demonstration. All names, IDs, and addresses are invented.
It shows the three stages of the intended workflow: the workload **request**, the
platform **handoff** (a generated platform contract), and the workload
**integration assessment** the skill produces.

The fully filled platform contract and a completed assessment for this scenario
live under
[`subscription-vending-workflow/`](subscription-vending-workflow/README.md) and
[`completed-workload-integration-assessment.md`](completed-workload-integration-assessment.md).

## Realistic post-vending prompt

> "We received the production application landing zone subscription and generated
> repository for the *Contoso Orders* workload. The repository contains the
> platform contract. Our Bicep design uses Linux App Service, Azure SQL Database,
> Blob Storage, and Key Vault. The workload handles confidential data, must remain
> in the EU, and calls an external payment API. Review the design against the
> platform contract, identify what we can implement ourselves, and create only the
> platform requests that are actually required."

The workload team describes **its** requirements and architecture. It does not
restate platform facts — those come from the generated contract.

## Stage A — Workload subscription request (what the team submitted)

- **Workload / owners:** Contoso Orders API; business owner *A. Owner*; technical owner *T. Lead*.
- **Environments:** dev, test, prod (one subscription each).
- **Criticality:** business-critical (tier 2).
- **Data classification:** Confidential.
- **Residency:** EU only.
- **Intended services:** Linux App Service, Azure SQL Database, Blob Storage, Key Vault.
- **Inbound:** private only (internal consumers via private endpoint).
- **External outbound:** one external dependency — payment API `api.payments.example` (HTTPS/443).
- **Availability / RTO / RPO:** 99.9% target; RTO 4h; RPO 1h.
- **Deployment model:** Bicep via CI/CD; Azure Verified Modules where practical.

## Stage B — Platform handoff (generated platform contract, excerpt)

The vending process rendered `.azure-platform/platform-contract.yaml`. Key facts
(full file in the vending example):

- **Provenance:** `contractVersion: 1.4.0`, generated from the platform repo at a pinned revision, product line `corp-connected-online`.
- **Subscription:** `sub-contoso-orders-prod` (`00000000-0000-0000-0000-000000000000`), env `prod`, MG `mg-corp-online`, workload role **Contributor**.
- **Resource providers registered during vending:** `Microsoft.Web`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.KeyVault`, `Microsoft.Network`.
- **Governance:** allowed regions `westeurope`, `northeurope`; required tags `costCenter`, `owner`, `dataClassification`; inherited **Deny** on public network access for PaaS; diagnostic settings enforced by policy.
- **Networking (provisioned by vending):** VNet `vnet-orders-prod` peered to the regional hub, with two subnets —
  - `snet-appservice-integration` — delegated to `Microsoft.Web/serverFarms`, for App Service **outbound** regional VNet Integration (dedicated/empty).
  - `snet-private-endpoints` — **not** delegated, for **private endpoints**.
  - Egress: forced through the central Azure Firewall.
- **Private DNS:** `integrationMechanism: policy-dine` for `privatelink.azurewebsites.net`, `privatelink.database.windows.net`, `privatelink.blob.core.windows.net`, `privatelink.vaultcore.azure.net` — DNS zone groups are auto-associated by Azure Policy, so **no DNS request is needed**.
- **Monitoring:** central workspace `law-corp-central`, diagnostic settings via policy.
- **Security:** Defender on; public network access denied; Confidential data may require CMK (architecture decision).
- **Cost:** budget owner = Orders team; cost center `CC-1234`.
- **Support:** platform requests via `platform-requests@contoso.example` queue; request SLA 5 business days.

## Stage C — Workload integration assessment (what the skill produces)

**Confirmed platform context (from contract):** Contributor scope; public access
denied; five providers already registered; central firewall egress; two purpose-built
subnets already provisioned; private endpoint DNS automated via policy for all four
required zones; central Log Analytics; allowed EU regions; required tags.

**Assumptions / missing information:**

- CMK vs platform-managed keys for Confidential SQL/Storage — architecture decision (`TODO`).
- Zone-redundancy choice for the 99.9% target — architecture decision (`TODO`).

### Corrected App Service network design

- **Outbound:** enable App Service **regional VNet Integration** into
  `snet-appservice-integration` (delegated to `Microsoft.Web/serverFarms`), and route
  application traffic so egress follows the subnet route to the central firewall.
- **Inbound / data-plane private endpoints:** create private endpoints in
  `snet-private-endpoints` (non-delegated) for the App Service (inbound), SQL,
  Storage (blob), and Key Vault. Private endpoints **cannot** be placed in the
  delegated integration subnet.
- **DNS:** rely on the policy-based zone groups for all four `privatelink` zones —
  no workload zone creation, no DNS request.

### Workload-team actions (do these yourselves)

1. Deploy App Service, SQL, Storage, Key Vault with `publicNetworkAccess` disabled.
2. Enable regional VNet Integration (outbound) in `snet-appservice-integration` with app routing to central egress.
3. Create private endpoints in `snet-private-endpoints` for all four services.
4. Use a user-assigned managed identity; assign least-privilege roles on your own
   resources (e.g. Key Vault Secrets User, Storage Blob Data Contributor) and use
   Entra auth for SQL.
5. Apply required tags and let policy apply diagnostic settings to `law-corp-central`.
6. Pin all resources to `westeurope` (or `northeurope`).

### Platform-team requests (only genuine dependencies)

1. **Firewall egress rule** for `snet-appservice-integration` → `api.payments.example`
   (443/TCP). This is the **only** required request — external egress is centrally
   controlled and this FQDN is workload-specific. See
   [`platform-team-requests/firewall-egress-rule.md`](platform-team-requests/firewall-egress-rule.md).

_No DNS request_ (automated by policy). _No provider request_ (all registered).
_No subnet request_ (both subnets already provisioned by vending).

### Architecture decisions required

- CMK vs platform-managed keys for Confidential data (security + platform owners).
- Zone-redundant vs single-zone deployment for the availability target.

### Policy remediation (no exemption needed)

- Public-access Deny → `publicNetworkAccess = Disabled` + private endpoints (compliant).
- Diagnostic settings and tags → satisfied by policy + workload tags (compliant).

### Readiness status

`Ready after platform dependency` — proceed with all workload actions now; go-live
gated only on the single firewall egress request.

### What the skill deliberately does NOT do

- Does not create a DNS request (integration is automated by the contract).
- Does not request providers already registered by vending.
- Does not place private endpoints in the delegated integration subnet.
- Does not enable public access, assume Owner, or propose central-platform edits.
- Does not invent regions, tags, DNS zones, or policies — all come from the contract.

---

*Underlying rules and sources:
[`references/official-source-map.md`](../skills/azure-landing-zone-workload-integration/references/official-source-map.md).*
