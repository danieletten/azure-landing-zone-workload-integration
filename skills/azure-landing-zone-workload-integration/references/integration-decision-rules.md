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
  it — do not assume every PaaS service must always use one.
- Do **not** create `privatelink.*` zones in the workload subscription when
  central zones exist; use the platform DNS integration mechanism. A private
  endpoint that will not resolve is usually a missing central A record or zone
  link, not a reason to enable public access.

### Workload identities and RBAC
- Prefer managed identities over keys/secrets. Prefer user-assigned identities
  when identity must be stable or shared.
- Grant the least-privilege built-in role at the narrowest scope. The workload
  team assigns roles on its **own** resources; access to shared platform services
  is requested, not self-granted. No management-group or tenant-scope grants.

### Secrets, keys, certificates
- Store secrets in Key Vault (platform or workload per contract). Note CMK
  requirements and who owns key rotation.

### Shared platform services
- Consume shared services rather than duplicating them; justify any duplication.

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

Flag assumptions such as:

1. Subscription Owner access.
2. Permission to create role assignments.
3. Permission to create/modify virtual networks.
4. Permission to modify centralized private DNS zones.
5. Permission to modify firewall rules or route tables.
6. Public network access being available.
7. Workload team owning management group or policy assignments.
8. Central services duplicated inside the workload subscription.
9. Required diagnostic settings or tags omitted.
10. Hard-coded enterprise configuration that should be an input or platform
    contract value.

Do not rewrite all infrastructure unless the user requests implementation.
Prefer Bicep and Azure Verified Modules in new Azure-only examples; stay usable
for Terraform.

## Expected output

Per relevant domain: current state, gap, and whether resolution is a workload
action, platform request, shared decision, or architecture decision.
Source links: [official-source-map.md](official-source-map.md).
