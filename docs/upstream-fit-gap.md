# Upstream Fit and Gap

Supports a future contribution discussion for
`azure-landing-zone-workload-integration` in
`microsoft/GitHub-Copilot-for-Azure` (public distribution: `microsoft/azure-skills`).

Inspection baseline: `microsoft/GitHub-Copilot-for-Azure` main tree SHA
`58cf519848f36ba525b51a46beb7824c054f99e3`, inspected 2026-08-04.

## 1. User problem

A workload/application team has been given a subscription inside an **existing**
enterprise Azure Landing Zone and must integrate their workload with inherited
policies, central networking/DNS, identity, monitoring, security, cost controls,
and sovereignty requirements — without owning the platform. Deployments get
blocked by inherited policy or platform dependencies, and teams are unsure which
tasks are theirs versus the platform team's.

## 2. Target audience

Application developers, workload architects, DevOps/platform consumers, workload
owners, and security/governance contacts working with a workload team. **Not** the
team that builds and owns the central landing zone.

## 3. Why `azure-app-onboard` does not cover it

`azure-app-onboard` starts from an app idea or codebase and runs a self-contained
discover → architect → scaffold → deploy pipeline, auto-selecting Azure services.
It does not discover an organization's existing platform contract, reason about
inherited guardrails and responsibility boundaries, or produce platform team
requests. Its scope is service selection and deployment, not integration with a
pre-existing landing zone.

## 4. Why `azure-enterprise-infra-planner` does not cover it

`azure-enterprise-infra-planner` is for cloud architects and platform engineers
**designing/provisioning** the platform — landing zones, hub-spoke networks,
identity, governance, and multi-resource topologies. This skill is the inverse:
the platform already exists and is owned by someone else; the workload team must
consume it and stay compliant, not design it.

## 5. Why keep it separate

- Distinct audience (workload consumer vs platform builder).
- Distinct golden path (discover contract → split responsibilities → assess →
  remediate/escalate) that would dilute either broader skill's description and
  routing if merged.
- Distinct guardrails (never assume Owner, never modify central platform).
- Upstream guidance warns that skill description char budgets are tight; folding
  this into another skill risks routing regressions.

## 6. Intended handoffs

- App idea / service selection → `azure-app-onboard`
- Platform / landing zone / hub design → `azure-enterprise-infra-planner`
- Generate IaC for a known architecture → `azure-prepare`
- Preflight / validation → `azure-validate`
- Execute a ready deployment → `azure-deploy`

## 7. Prompts that should trigger this skill

- "Integrate our App Service workload into the vended application landing zone with central egress and private DNS."
- "My Bicep deployment is denied by an inherited Azure Policy — how do I comply?"
- "My private endpoint won't resolve through the central private DNS."
- "My workload needs outbound access through the central Azure Firewall."
- "My managed identity needs access to a shared platform service."
- "Which of these tasks are ours and which need the platform team?"
- "Does this workload meet our EU data residency requirements inside the landing zone?"

## 8. Prompts that must trigger another skill

- "Design our management group hierarchy." → `azure-enterprise-infra-planner`
- "Design the enterprise hub network." → `azure-enterprise-infra-planner`
- "Which Azure services should my new app idea use?" → `azure-app-onboard`
- "Prepare my app for Azure (no landing zone context)." → `azure-app-onboard` / `azure-prepare`
- "Run deployment validation." → `azure-validate`
- "Deploy my ready infrastructure." → `azure-deploy`
