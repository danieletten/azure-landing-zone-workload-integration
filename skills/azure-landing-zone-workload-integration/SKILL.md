---
name: azure-landing-zone-workload-integration
description: "Integrate a workload into an existing enterprise Azure Landing Zone (application landing zone): discover the platform contract and inherited guardrails, split workload-team vs platform-team responsibilities, resolve inherited Azure Policy blocks and platform dependencies like central networking and private DNS, and produce compliant workload actions plus precise platform requests. Not for new-app service selection or designing the platform itself."
license: MIT
metadata:
  author: Azure Landing Zone Workload Skills contributors
  version: "0.1.0"
---

# Azure Landing Zone Workload Integration

Help a **workload team** integrate a workload into an **existing** enterprise
Azure Landing Zone. The platform already exists — fit the workload into it; do not
design or deploy it. Guidance is generic; defer to the user's actual platform
contract and organization standards.

## When to Use This Skill

- An Azure Landing Zone / application landing zone already exists and a workload
  must integrate with inherited policy, central networking, DNS, identity,
  monitoring, security, cost, and sovereignty controls.
- A deployment is blocked by inherited Azure Policy or a platform dependency
  (central DNS, firewall, peering, shared-service access).
- Clarifying workload-team vs platform-team responsibilities.

## When NOT to Use

| Scenario | Use Instead |
|---|---|
| Choosing Azure services from an app idea or codebase | `azure-app-onboard` |
| Designing the platform, landing zone, hub network, or governance | `azure-enterprise-infra-planner` |
| Generating IaC for a known architecture | `azure-prepare` |
| Preflight / infra validation | `azure-validate` |
| Executing a ready deployment | `azure-deploy` |

## Guardrails (non-negotiable)

Never assume subscription Owner rights or public network access. Never assume the
workload team owns management groups, central policy, hub networking, firewalls,
or private DNS zones. Never recommend a policy exemption before compliant
alternatives, duplicate central services without reason, invent organization
standards, fabricate MCP tool names or documentation links, or change live Azure
resources or deploy without explicit authorization.

## Workflow (golden path)

1. **Establish context** — capture inputs with
   [`assets/workload-integration-assessment.md`](assets/workload-integration-assessment.md).
   If the user is still selecting Azure services from an app idea, hand off to
   `azure-app-onboard`.
2. **Discover the platform contract and split responsibilities** — read the
   organization overlay `.azure-platform/platform-contract.yaml` first if present,
   following [`references/platform-contract.md`](references/platform-contract.md)
   for source precedence, provenance, and drift handling; then
   [`references/discovery-and-responsibilities.md`](references/discovery-and-responsibilities.md).
   If no contract is present, say so and operate in degraded discovery mode rather
   than inventing platform values. Use read-only Azure discovery only with explicit
   permission.
3. **Assess relevant integration domains** and **review workload IaC** — apply
   [`references/integration-decision-rules.md`](references/integration-decision-rules.md).
   Do not rewrite infrastructure unless implementation is requested.
4. **Handle policy and platform blockers** — follow
   [`references/policy-remediation-and-escalation.md`](references/policy-remediation-and-escalation.md);
   prefer compliant remediation, treat exemptions as a last resort.
5. **Produce outputs** (below), drafting requests with
   [`assets/platform-team-request.md`](assets/platform-team-request.md).

Cite only verified sources from
[`references/official-source-map.md`](references/official-source-map.md); prefer
Azure Verified Modules and Bicep in new Azure-only examples, staying usable for
Terraform.

## Output Contract

Report findings under: (1) confirmed platform context, (2) assumptions and missing
information, (3) workload-team actions, (4) platform-team requests, (5) shared
decisions, (6) architecture decisions required, (7) policy conflicts and compliant
remediation options, (8) exception candidates (if any), and (9) readiness status —
one of `Ready`, `Ready with workload actions`, `Ready after platform dependency`,
`Blocked by workload decision`, `Blocked by platform dependency`,
`Architecture decision required`.

Always distinguish confirmed facts from assumptions, and keep workload actions
separate from platform requests.
