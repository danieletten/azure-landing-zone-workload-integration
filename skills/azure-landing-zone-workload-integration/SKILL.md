---
name: azure-landing-zone-workload-integration
description: "Integrate a new or existing Azure workload into an existing enterprise Azure Landing Zone: discover the platform contract and inherited guardrails, separate workload team from platform team responsibilities, assess integration dependencies, review workload infrastructure as code, and produce compliant workload actions plus precise platform team requests. WHEN: 'onboard my workload to our landing zone', 'application landing zone integration', 'deployment blocked by inherited Azure Policy', 'private endpoint will not resolve through central private DNS', 'outbound access through the central firewall', 'which tasks are ours vs the platform team', 'workload subscription integration'. DO NOT USE FOR: selecting Azure services for a new app idea (use azure-app-onboard); designing the platform, landing zone, or hub network itself (use azure-enterprise-infra-planner)."
license: MIT
metadata:
  author: Azure Landing Zone Workload Skills contributors
  version: "0.0.0-placeholder"
---

# Azure Landing Zone Workload Integration

Help a **workload team** integrate a workload into an **existing** enterprise
Azure Landing Zone. The platform already exists; fit the workload into it. Do not
design or deploy the platform.

Recommendations here are generic guidance. Always defer to the user's actual
platform contract and organization standards.

## When to Use This Skill

- An Azure Landing Zone or application landing zone already exists and a workload
  must integrate with its platform services, inherited policies, networking, DNS,
  identity, monitoring, security, cost controls, and sovereignty requirements.
- Investigating a deployment blocked by inherited Azure Policy or a platform
  dependency (central DNS, firewall, peering, shared service access).
- Clarifying workload team vs platform team responsibilities.

## When NOT to Use

| Scenario | Use Instead |
|---|---|
| Choosing Azure services from an app idea or codebase | `azure-app-onboard` |
| Designing the platform, landing zone, hub network, or governance | `azure-enterprise-infra-planner` |
| Generating IaC for a known architecture | `azure-prepare` |
| Preflight/infra validation | `azure-validate` |
| Executing a ready deployment | `azure-deploy` |

## Guardrails

Read [`references/integration-decision-rules.md`](references/integration-decision-rules.md)
before assessing. Never: assume subscription Owner or public network access;
assume the workload team owns management groups, central policy, hub networking,
central firewalls, or private DNS zones; recommend a policy exemption before
compliant alternatives; duplicate central services without reason; invent
organization standards; fabricate MCP tool names or documentation links; change
live Azure resources or deploy without explicit authorization.

## Workflow

1. **Establish workload context** — capture inputs with
   [`assets/workload-integration-assessment.md`](assets/workload-integration-assessment.md).
   If the user is still selecting Azure services from an app idea, hand off to
   `azure-app-onboard`.
2. **Discover the platform contract** and **separate responsibilities** — follow
   [`references/discovery-and-responsibilities.md`](references/discovery-and-responsibilities.md).
   Use read-only Azure discovery capabilities only with explicit permission.
3. **Assess integration domains** — apply
   [`references/integration-decision-rules.md`](references/integration-decision-rules.md)
   to only the relevant domains.
4. **Review workload IaC** — check for the anti-patterns listed in the decision
   rules; do not rewrite infrastructure unless implementation is requested.
5. **Handle policy and platform blockers** — follow
   [`references/policy-remediation-and-escalation.md`](references/policy-remediation-and-escalation.md).
   Prefer compliant remediation; treat exemptions as a last resort.
6. **Produce actionable outputs** — see the output contract below. Draft platform
   requests with [`assets/platform-team-request.md`](assets/platform-team-request.md).

Cite only verified Microsoft sources listed in
[`references/official-source-map.md`](references/official-source-map.md). Prefer
Azure Verified Modules and Bicep in new Azure-only examples; stay usable for
Terraform workloads.

## Output Contract

Report findings under these categories:

1. Confirmed platform context
2. Assumptions and missing information
3. Workload team actions
4. Platform team requests
5. Shared decisions
6. Architecture decisions required
7. Policy conflicts and compliant remediation options
8. Exception candidates (if any)
9. Readiness status — one of: `Ready`, `Ready with workload actions`,
   `Ready after platform dependency`, `Blocked by workload decision`,
   `Blocked by platform dependency`, `Architecture decision required`

Always distinguish confirmed facts from assumptions, and keep workload actions
separate from platform requests.
