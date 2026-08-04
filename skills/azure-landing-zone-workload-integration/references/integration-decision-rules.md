# Integration Decision Rules

Purpose: decision rules for assessing only the integration domains relevant to
the workload, and for reviewing workload IaC. Keep the assessment focused — this
is not a full Well-Architected review.

## Domains and decision rules

### Subscription placement and environments
- Confirm placement under the correct management group and the environment
  isolation model (per the platform contract, not a default assumption).

### Azure Policy compatibility
- Prefer configurations that satisfy inherited policy. Detailed remediation and
  escalation logic: [policy-remediation-and-escalation.md](policy-remediation-and-escalation.md).

### Networking, routing, egress
- Reuse central connectivity and the platform egress path (Azure Firewall, NVA,
  NAT, or forced tunnel). Do **not** deploy standalone egress when central egress
  exists. Stay within allocated address space; request more rather than overlap.

### Private endpoints and private DNS
- Prefer private endpoints when the platform standard and threat model call for
  it — not every PaaS service must always use one.
- Do **not** create `privatelink.*` zones in the workload subscription when central
  zones exist. Private endpoint DNS is **contract-driven** — check
  `privateDns.integrationMechanism`: `policy-dine` (auto-associated via Azure Policy
  + zone groups), `workload-iac-zonegroup` (workload references a permitted zone
  group), `platform-request`, or `hybrid`. Only raise a DNS request when the
  mechanism requires one; do not invent one when integration is automated. Do not
  confuse VM private DNS autoregistration with private endpoint DNS zone integration.
- A private endpoint that will not resolve is usually a missing zone group/record or
  unlinked zone, not a reason to enable public access.

### App Service networking (when in scope)
- Keep inbound and outbound separate. **Regional VNet Integration (outbound)** needs
  a dedicated subnet delegated to `Microsoft.Web/serverFarms` used by no other
  service. **Private endpoints** (App Service inbound, SQL, Storage, Key Vault) go in
  a **separate, non-delegated** subnet — a private endpoint cannot be created in a
  subnet delegated to `Microsoft.Web/serverFarms`. Route outbound through central
  egress when the contract requires it.

### Workload identities and RBAC
- Prefer managed identities over keys/secrets. Prefer user-assigned identities
  when identity must be stable or shared.
- Grant the least-privilege built-in role at the narrowest scope. The workload
  team assigns roles on its **own** resources; access to shared platform services
  is requested, not self-granted. No management-group or tenant-scope grants.
- Distinguish the **human** team role (`subscription.workloadTeamRole`) from the
  **CI/CD deployment identity** (`subscription.deploymentIdentityRole`). When the
  contract states the deployment identity is Owner at **workload-subscription
  scope**, creating workload resources and UAMIs and assigning workload-scope roles
  are **pipeline actions, not platform requests**. Neither role grants access to
  platform-owned resources in another subscription — cross-subscription and central
  changes remain platform requests. Do not infer central or cross-subscription
  permissions from workload-subscription Owner, and do not universally assume Owner
  when the contract does not state it.

### Secrets, keys, certificates
- Store secrets in Key Vault (platform or workload per contract). Note CMK
  requirements and who owns key rotation.

### Shared platform services
- Consume shared services rather than duplicating them; justify any duplication.

### Resource providers
- Check the contract's `resourceProviders` before acting. Three states:
  `registered` (already done during vending — do **not** request or re-register),
  `workloadMayRegister` (the workload team registers it itself), and
  `requestRequired` (raise a platform request). Do not tell the workload team to
  request a provider the contract already reports as registered.

### Monitoring, logging, incident ownership
- Send platform-required logs/metrics to the mandated central workspace; confirm
  policy-enforced diagnostic settings. Define workload alerts and an incident
  owner before go-live.

### Availability, resilience, recovery
- Match resilience to criticality (availability zones, backup, DR). Verify
  dependencies (backups, DR copies) honor residency.

### Cost ownership, budgets, tags
- Confirm cost ownership, budget, cost center, and mandatory tags against policy.

### Data residency, sovereignty, operator access
- Pin resources to allowed regions that satisfy residency; confirm the allowed
  region list. Verify telemetry/backup/DR do not leave the required geography.
- Do not claim a configuration "guarantees" compliance; describe controls and
  mark legal/platform confirmation as a decision.

## Reviewing workload IaC

Flag platform-incompatible assumptions: subscription Owner access; creating role
assignments outside own resources; creating/modifying VNets; modifying central
private DNS zones, firewall rules, or route tables; relying on public network
access; owning management-group or policy assignments; duplicating central services
inside the workload subscription; omitting required diagnostic settings or tags; and
hard-coded enterprise configuration that should be an input or platform-contract
value.

Do not rewrite all infrastructure unless the user requests implementation. Prefer
Bicep and Azure Verified Modules in new Azure-only examples; stay usable for
Terraform.

## Expected output

Per relevant domain: current state, gap, and whether resolution is a workload
action, platform request, shared decision, or architecture decision.
Source links: [official-source-map.md](official-source-map.md).
