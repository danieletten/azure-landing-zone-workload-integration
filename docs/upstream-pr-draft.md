# Upstream PR Draft (do not submit yet)

Draft for a future pull request to `microsoft/GitHub-Copilot-for-Azure`. File and
triage an onboarding issue first. Prefix the PR title with `feature:` and link the
issue.

**Title:** `feature: add azure-landing-zone-workload-integration skill`

## Problem statement

Workload teams onboarded into an existing enterprise Azure Landing Zone must
integrate their workload with inherited policies, central networking/DNS,
identity, monitoring, security, cost controls, and sovereignty requirements. They
hit policy denials and platform dependencies and lack a consistent way to tell
workload-owned tasks from platform-owned ones. No current skill covers landing
zone **consumption** from the workload side.

## Target audience

Application developers, workload architects, DevOps/platform consumers, workload
owners, and security/governance contacts on a workload team — not the platform
team that owns the landing zone.

## Gap in existing skills

- `azure-app-onboard` starts from an app/codebase and auto-selects services and
  deploys; it does not discover an existing platform contract or produce platform
  requests.
- `azure-enterprise-infra-planner` **designs** the platform/landing zone; this
  skill consumes an existing one.
- `azure-prepare` / `azure-validate` / `azure-deploy` cover IaC generation,
  validation, and deployment, not landing zone integration reasoning.

## Why a separate skill

Distinct audience, golden path, and guardrails; merging would dilute routing and
risks exceeding tight description char budgets.

## Scope

Discover the platform contract and inherited guardrails; separate workload vs
platform responsibilities; assess relevant integration domains; review workload
IaC for platform-incompatible assumptions; prefer compliant remediation over
exemptions; produce workload actions and precise platform team requests.

## Non-goals

- Designing the platform, management groups, hub network, or governance.
- Assuming subscription Owner or public network access.
- Modifying central policy, DNS, firewalls, or identity platform.
- Recommending exemptions before compliant alternatives.
- Changing live Azure resources or deploying without authorization.

## Example trigger prompts

- "Integrate our App Service workload into the vended application landing zone."
- "My Bicep deployment is denied by an inherited Azure Policy."
- "My private endpoint won't resolve through central private DNS."
- "My workload needs outbound access through the central firewall."
- "Which tasks are ours vs the platform team?"

## Example non-trigger prompts

- "Design our management group hierarchy." (`azure-enterprise-infra-planner`)
- "Which services should my new app use?" (`azure-app-onboard`)
- "Run deployment validation." (`azure-validate`)
- "Deploy my ready infrastructure." (`azure-deploy`)

## Testing performed

- Community repository validation (link check, frontmatter name/dir match, token
  counts) passes.
- Routing and behavioral scenarios documented in
  [evaluation-scenarios.md](evaluation-scenarios.md), ready to be implemented as
  upstream Vally routing + e2e suites.
- **TODO:** author and run Vally suites in the upstream harness before opening the
  PR (not reproducible in this standalone repo).

## Microsoft documentation sources used

See [../skills/azure-landing-zone-workload-integration/references/official-source-map.md](../skills/azure-landing-zone-workload-integration/references/official-source-map.md).
Key pages: CAF Azure landing zones and design principles, Private Link & DNS
integration at scale, Azure Policy effects and exemptions, managed identities and
RBAC, reliability/availability zones, and reliability & sovereignty.
