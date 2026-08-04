# Azure Landing Zone Workload Integration

A reusable [Agent Skill](https://agentskills.io/specification) that helps an
**application or workload team** integrate a new or existing workload into an
**existing** enterprise Azure Landing Zone.

> **Status: early development. Community project.** This is **not** an official
> Microsoft or GitHub product. Always reconcile every recommendation with your
> own organization's Azure platform standards, which take precedence.
>
> The intended long-term destination is consideration for the official Microsoft
> Azure Skills Plugin (`microsoft/azure-skills`, developed in
> `microsoft/GitHub-Copilot-for-Azure`). Acceptance is not implied or guaranteed.

## The problem this repository solves

In enterprise-scale Azure Landing Zones the platform — management groups,
connectivity/hub, identity, and centralized governance — already exists and is
owned by a platform team. A workload team given a subscription still has to
integrate correctly: consume central networking, DNS, identity, and monitoring;
comply with inherited Azure Policy and guardrails; and know when to raise a
platform team request. This skill encodes that workload-team integration workflow.

## The workload team perspective

This skill deliberately takes the **workload team's** point of view. It helps you
fit a workload into an existing platform. It does **not** design or deploy the
platform itself.

## Two important distinctions

**Application onboarding vs landing zone integration.** Choosing Azure services
for an app idea or codebase and deploying it is *application onboarding*
(`azure-app-onboard`). Fitting a workload into an existing landing zone's
platform contract is *landing zone integration* (this skill).

**Platform design vs workload integration.** Designing the platform, management
groups, hub network, and governance is *platform design*
(`azure-enterprise-infra-planner`). Consuming that platform as a workload team,
compliantly, is *workload integration* (this skill).

| Owned centrally by the platform team | Owned by the workload team |
| --- | --- |
| Management groups and central Azure Policy | Application resources in the workload subscription |
| Hub networking, egress/firewall, central private DNS zones | Workload subnets, private endpoints, workload IaC |
| Identity platform (tenant, PIM, Conditional Access) | Workload managed identities and RBAC on workload resources |
| Central logging (Log Analytics, Defender, Sentinel) | Workload telemetry, alerts, incident ownership |
| Subscription vending | Workload cost ownership and tagging |

## Current skill

### `azure-landing-zone-workload-integration`

Establishes workload context, discovers the platform contract, splits
responsibilities, assesses relevant integration domains, reviews workload IaC,
investigates policy/platform blockers (preferring compliant remediation over
exemptions), and produces clear workload actions plus precise platform team
requests. See
[`skills/azure-landing-zone-workload-integration/SKILL.md`](skills/azure-landing-zone-workload-integration/SKILL.md).

## Installation and usage (standalone)

The skill is a self-contained folder. Make it available to your agent using your
current supported skill mechanism, for example:

- Copy `skills/azure-landing-zone-workload-integration/` into your local skills
  directory, or
- Reference the folder directly in your prompt/session.

> The exact `gh skills` / Copilot CLI command and minimum versions depend on your
> environment. **TODO:** confirm the supported install command for this repository
> against your tooling before documenting it as canonical.

Once distributed via the Azure Skills Plugin, the upstream install path would be
(illustrative, verify at that time):

```bash
# Copilot CLI
/plugin marketplace add microsoft/azure-skills
/plugin install azure@azure-skills
```

## Example prompts

- "Integrate my App Service + Key Vault + Azure SQL workload into our landing zone with private endpoints."
- "My deployment is blocked by an inherited Azure Policy `Deny` — what compliant change fixes it?"
- "My private endpoint won't resolve through central private DNS."
- "My workload needs outbound access through the central firewall — draft the request."
- "Which responsibilities are ours vs the platform team for this workload?"
- "Does this design meet EU data residency requirements inside the landing zone?"

## Testing this skill

Human-readable routing and behavioral scenarios are in
[`docs/evaluation-scenarios.md`](docs/evaluation-scenarios.md). Run repository
validation before contributing:

```bash
python .github/scripts/validate_skills.py
```

## Upstream contribution

This skill is structured to be copied into the upstream repository with only
relative links. See:

- [`docs/upstream-fit-gap.md`](docs/upstream-fit-gap.md) — problem, audience, and gap vs existing skills.
- [`docs/upstream-contribution.md`](docs/upstream-contribution.md) — verified contribution path, build/validation/token rules.
- [`docs/upstream-pr-draft.md`](docs/upstream-pr-draft.md) — draft PR narrative (not submitted).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Roadmap

Focused, workload-team-oriented skills that may follow (not yet built):

- `azure-landing-zone-policy-remediation` — investigate and compliantly remediate inherited policy conflicts.
- `azure-landing-zone-workload-review` — review a workload for security, governance, reliability, cost, and sovereignty.
- `azure-landing-zone-platform-request` — generate precise, reviewable platform team requests.

## Repository naming note

The skill and local branding use `azure-landing-zone-workload-integration`. If the
remote repository is still named for the earlier "onboarding" scope, renaming it
to `azure-landing-zone-workload-integration` is recommended for clarity. That
remote rename is a **manual** action and is intentionally not performed here.

## License

[MIT](LICENSE).
