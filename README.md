# Azure Landing Zone Workload Integration

Help workload teams integrate Azure workloads into an existing enterprise Azure
Landing Zone while respecting platform guardrails and clearly separating workload
and platform responsibilities.

> Community project — **not** an official Microsoft or GitHub product. All guidance
> is generic and must be validated against your organization's Azure platform
> standards. Public preview (`v0.1.0`, in development).

## The problem

In enterprise-scale Azure Landing Zones, the platform — management groups,
connectivity/hub, identity, and centralized governance — already exists and is
owned by a platform team. A workload team handed a vended subscription still has
to integrate correctly: consume central networking, DNS, identity, and
monitoring; comply with inherited Azure Policy and guardrails; and know which
changes it can make itself versus which need a platform team request. Deployments
stall on policy denials and platform dependencies, and responsibility boundaries
are unclear. This skill provides a repeatable integration workflow for that gap.

## Who it is for

Application developers, workload architects, DevOps and platform consumers,
workload owners, and security/governance contacts working **with** a workload
team. It is not written for the team that builds and owns the central landing
zone.

## What it produces

A structured integration assessment with clearly separated:

- Confirmed platform context and explicit assumptions.
- **Workload-team actions** (what you can do yourself, compliantly).
- **Platform-team requests** (precise, one per dependency).
- Shared decisions and architecture decisions required.
- Policy conflicts with compliant remediation options (exemptions last).
- A readiness status.

## A concise example

> "We have a vended subscription in our landing zone. I need to deploy an App
> Service + Azure SQL + Storage + Key Vault app. Central policy denies public
> access, DNS and egress are centralized. What's ours vs the platform team's?"

The skill discovers the platform contract, separates responsibilities, and
returns workload actions (private endpoints, `publicNetworkAccess` disabled,
managed identity, diagnostics/tags) alongside platform requests (private DNS
records, a firewall rule, subnet delegation) with a readiness status — without
assuming Owner rights or enabling public access. See the full worked example in
[`examples/app-service-platform-integration.md`](examples/app-service-platform-integration.md).

## Quick start

1. Install the GitHub CLI skills preview (see [Installation](#installation)).
2. Preview the skill:
   ```bash
   gh skill preview danieletten/azure-landing-zone-workload-integration azure-landing-zone-workload-integration
   ```
3. Install it, then ask your agent to integrate your workload into your landing
   zone (see [Example prompts](#example-prompts)).

## Installation

`gh skill` is in **public preview** and requires a recent GitHub CLI (the skills
commands were introduced around **v2.90.0**; verified working on **v2.96.0**). Run
`gh --version` to check, and `gh skill --help` to confirm the commands are
available.

**Install the latest version:**

```bash
gh skill install danieletten/azure-landing-zone-workload-integration azure-landing-zone-workload-integration
```

**Install a tagged release:**

```bash
gh skill install danieletten/azure-landing-zone-workload-integration azure-landing-zone-workload-integration@v0.1.0
```

By default `gh skill` installs at **project scope** for GitHub Copilot. Use
`--scope user` to install everywhere, or `--agent <name>` for another supported
agent (see `gh skill install --help`).

**Manual fallback (copy the folder):** clone this repository and either install
from local —

```bash
gh skill install . azure-landing-zone-workload-integration --from-local
```

— or copy the self-contained skill folder
`skills/azure-landing-zone-workload-integration/` into your agent's project skills
directory (the GitHub CLI uses `.agents/skills/` for project-scope installs). Use
`gh skill install --dir <path>` to target a custom directory.

Only use install commands you can verify with `gh skill --help` on your machine;
command syntax may change while the feature is in preview.

## Example prompts

- "Integrate my App Service + Key Vault + Azure SQL workload into our landing zone with private endpoints."
- "My deployment is blocked by an inherited Azure Policy `Deny` — what compliant change fixes it?"
- "My private endpoint won't resolve through central private DNS."
- "My workload needs outbound access through the central firewall — draft the request."
- "Which responsibilities are ours vs the platform team for this workload?"
- "Does this design meet EU data residency requirements inside the landing zone?"

## When to use the skill

- An Azure Landing Zone or application landing zone already exists and a workload
  must integrate with its inherited policy, central networking, DNS, identity,
  monitoring, security, cost controls, and sovereignty requirements.
- A deployment is blocked by inherited Azure Policy or a platform dependency.
- You need to separate workload-team and platform-team responsibilities.

## When not to use the skill

| Scenario | Use instead |
|---|---|
| Choosing Azure services from an app idea or codebase | `azure-app-onboard` |
| Designing the platform, landing zone, hub network, or governance | `azure-enterprise-infra-planner` |
| Generating IaC for a known architecture | `azure-prepare` |
| Preflight / infrastructure validation | `azure-validate` |
| Executing a ready deployment | `azure-deploy` |

## Supported operating modes

- **Assessment (default):** analyzes the workload and platform context and returns
  the structured output above. Makes no changes to any Azure resource.
- **Read-only discovery (opt-in):** only with your explicit permission, uses
  read-only Azure queries to discover platform context. Never writes.
- **Implementation (explicit request only):** may propose or edit workload IaC
  when you ask for implementation. It never modifies central platform resources
  and never deploys without explicit authorization.

## Current limitations

- Recommendations are generic; they cannot know your organization's private
  standards (allowed regions, tags, DNS zones, policy set) unless you supply them.
- It does not design or deploy the platform, and cannot make central-platform
  changes — it produces requests for the platform team instead.
- It relies on the platform context you provide or permit it to discover; gaps are
  reported as assumptions/`TODO`, not guessed.
- Not a legal or compliance authority; sovereignty output flags decisions for your
  platform and legal contacts.

## Evaluation status

Early. Routing and behavioral scenarios are defined in
[`docs/evaluation-scenarios.md`](docs/evaluation-scenarios.md), and a manual
evaluation log is in
[`docs/evaluation-results-v0.1.md`](docs/evaluation-results-v0.1.md). Only
scenarios genuinely executed are marked as run; the rest are pending.

## Contributing and feedback

Issues and pull requests are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) and
the issue templates (routing, Azure guidance, new scenario, responsibility
feedback, feature request). Please **exclude** confidential information,
subscription identifiers, internal IP ranges, and secrets from reports. Run
`python .github/scripts/validate_skills.py` before submitting.

## Roadmap

Focused, workload-team-oriented skills that may follow (not yet built):

- `azure-landing-zone-policy-remediation` — investigate and compliantly remediate inherited policy conflicts.
- `azure-landing-zone-workload-review` — review a workload for security, governance, reliability, cost, and sovereignty.
- `azure-landing-zone-platform-request` — generate precise, reviewable platform team requests.

## Platform-team customization and subscription vending

Organizations should keep the **generic public skill** and add a **platform-owned
contract overlay** in each workload repository, rather than forking the skill with
hard-coded platform values. The overlay lives at `.azure-platform/platform-contract.yaml`
(with an optional `platform-guidance.md`) and is typically generated by the
platform team's subscription-vending process.

```text
Workload requirements
        ↓
Subscription vending
        ↓
Subscription + workload repository
        ↓
Generated platform contract + pinned skill
        ↓
Workload architecture and IaC
        ↓
Integration assessment
        ↓
Workload actions + platform requests
```

The skill reads the contract first, merges it with your architecture and IaC, and
raises platform requests only for genuine dependencies. If no contract is present,
it says so and runs in a degraded discovery mode rather than inventing platform
values. The contract format is a project-specific template
(`skills/azure-landing-zone-workload-integration/assets/platform-contract-template.yaml`)
and is **not** an official Microsoft schema.

See:

- Subscription-vending workflow example: [`examples/subscription-vending-workflow/`](examples/subscription-vending-workflow/README.md)
- Completed assessment: [`examples/completed-workload-integration-assessment.md`](examples/completed-workload-integration-assessment.md)
- Completed platform requests: [`examples/platform-team-requests/`](examples/platform-team-requests/firewall-egress-rule.md)

## Design compatibility

The skill follows the Agent Skills specification and the current conventions of
the Microsoft Azure Skills development repository (frontmatter shape, token
budgets, references layout), so the `skills/azure-landing-zone-workload-integration/`
folder stays structurally suitable for possible future migration into the
Microsoft Azure Skills Plugin. That is a secondary design constraint, not a
commitment; acceptance is neither implied nor guaranteed. Details live under
[`docs/upstream/`](docs/upstream/).

## License and community disclaimer

Licensed under [MIT](LICENSE). This is an independent community project. It is not
affiliated with, endorsed by, or supported by Microsoft or GitHub. "Azure" and
related names are trademarks of their respective owners. Always align
recommendations with your own Azure platform standards before acting.
