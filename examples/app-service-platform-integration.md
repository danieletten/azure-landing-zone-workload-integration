# Example: App Service workload integration into an existing landing zone

A fully **fictional** demonstration of how this skill behaves. All names, values,
and identifiers are invented for illustration and are not real.

## User prompt

> "We run the *Contoso Orders* API. We've been given a vended subscription in our
> enterprise landing zone and need to integrate it. The app is Azure App Service
> (Linux), Azure SQL Database, Azure Storage (blob), and Azure Key Vault. Central
> policy denies public network access, private DNS and outbound egress are managed
> centrally, and we deploy with Bicep. What's ours to do, and what do we need from
> the platform team?"

## Supplied platform context (fictional)

- Subscription: `sub-contoso-orders-prod` under management group `mg-corp-online`.
- Workload team role: **Contributor** on the subscription (not Owner).
- Inherited policy (Deny): "public network access" denied for PaaS; "require
  diagnostic settings to central Log Analytics"; "require tags: `costCenter`,
  `owner`, `dataClassification`"; "allowed regions: `westeurope`, `northeurope`".
- Networking: workload VNet `vnet-orders` with delegated subnet
  `snet-orders-app`; egress forced through central Azure Firewall in the hub.
- Private DNS: central `privatelink.*` zones exist; records created by a platform
  DINE policy **only** for approved zones, otherwise by request.
- Monitoring: central Log Analytics workspace `law-corp-central` is mandated.
- Data classification: `Confidential`; EU data residency required.

## Reasoning boundaries (what the skill holds itself to)

Without exposing private chain of thought, the skill constrains itself to:

- Treat the platform context above as the contract; mark anything unstated as an
  assumption or `TODO` rather than inventing it.
- Keep workload-owned actions separate from platform-owned requests.
- Prefer compliant configuration over any exemption; never enable public access
  to work around DNS or policy.
- Never assume Owner rights or propose central-platform edits by the workload team.

## Representative final assessment

**Confirmed platform context:** Contributor scope; public access denied; central
Firewall egress; central private DNS with DINE for approved zones; central Log
Analytics mandated; allowed regions `westeurope`/`northeurope`; required tags.

**Assumptions / missing information:**

- Whether `privatelink.database.windows.net`, `privatelink.blob.core.windows.net`,
  and `privatelink.vaultcore.azure.net` are all in the DINE-approved set — `TODO`.
- Whether the app requires a specific external outbound FQDN — `TODO` (assumed one:
  `api.payments.example`).
- CMK requirement for SQL/Storage — `TODO` (assumed platform-managed keys accepted).

**Readiness status:** `Ready after platform dependency`.

### Workload-team actions (do these yourselves)

1. Deploy App Service, SQL, Storage, and Key Vault with `publicNetworkAccess`
   disabled; add private endpoints in `snet-orders-app`.
2. Use a **user-assigned managed identity**; grant least-privilege roles on your
   own resources (e.g. Key Vault Secrets User, Storage Blob Data Contributor) and
   configure SQL for Entra authentication.
3. Add the required tags (`costCenter`, `owner`, `dataClassification=Confidential`)
   and enable diagnostic settings to `law-corp-central`.
4. Pin all resources to `westeurope` (or `northeurope`) to satisfy residency.
5. Reference existing central `privatelink.*` zones via the platform DINE
   mechanism; do **not** create local private DNS zones.

### Platform-team requests (one per dependency)

1. **Private DNS records/links** for any of the three `privatelink` zones **not**
   covered by DINE, so the private endpoints resolve.
2. **Azure Firewall egress rule** allowing `snet-orders-app` → `api.payments.example`
   (443/TCP), with justification and acceptance criteria.
3. **Confirm subnet delegation / address space** for `snet-orders-app` if the
   current allocation is insufficient.

### Architecture decisions required

- CMK vs platform-managed keys for `Confidential` data (owner: security + platform).
- Single-region vs zone-redundant deployment for the stated availability target.

### Policy remediation options (no exemption needed)

- Public-access Deny → set `publicNetworkAccess = Disabled` + private endpoints
  (compliant; no exemption).
- Diagnostic-settings and tag policies → add the settings/tags (compliant).

### What the skill deliberately does NOT recommend

- Enabling public network access to fix DNS resolution.
- Creating `privatelink.*` zones inside the workload subscription.
- Deploying a standalone NAT gateway or firewall to bypass central egress.
- Requesting Owner rights or a policy exemption as a first step.
- Sending diagnostics only to a local workspace instead of `law-corp-central`.

---

*Sources for the underlying rules are listed in the skill's
[`references/official-source-map.md`](../skills/azure-landing-zone-workload-integration/references/official-source-map.md).*
