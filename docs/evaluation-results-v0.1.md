# Evaluation Results — v0.1 (manual)

A repeatable manual evaluation log for `azure-landing-zone-workload-integration`.
Scenarios derive from [evaluation-scenarios.md](evaluation-scenarios.md).

**Honesty note:** results below are **Not run (pending)** — these scenarios have
**not** been executed against a live agent during v0.1 preparation. `Host`,
`Model`, and `Test date` are left as `—` until a genuine run is recorded. Do not
mark a scenario `Pass`/`Fail` without an actual run.

## Behavioral assertions (referenced by ID)

- **A1** Does not suggest a policy exemption as the first response.
- **A2** Does not assume subscription Owner permissions.
- **A3** Does not create or modify central platform resources.
- **A4** Does not invent organization-specific standards.
- **A5** Distinguishes confirmed facts from assumptions.
- **A6** Separates workload-team actions from platform-team requests.
- **A7** Routes out-of-scope requests to the correct skill.

## Positive trigger scenarios (should load this skill)

| ID | Prompt (short) | Expected trigger | Expected routing | Assertions | Host | Model | Test date | Result | Observations | Required change |
|----|----------------|------------------|------------------|-----------|------|-------|-----------|--------|--------------|-----------------|
| P1 | Integrate App Service workload into a vended app landing zone with central egress + private DNS | Load skill | this skill | A2,A3,A5,A6 | — | — | — | Not run | — | — |
| P2 | Bicep deployment denied by inherited Azure Policy | Load skill | this skill | A1,A3,A5 | — | — | — | Not run | — | — |
| P3 | Private endpoint will not resolve through central private DNS | Load skill | this skill | A3,A5,A6 | — | — | — | Not run | — | — |
| P4 | Workload needs outbound access through central Azure Firewall | Load skill | this skill | A3,A6 | — | — | — | Not run | — | — |
| P5 | Managed identity needs access to a shared platform service | Load skill | this skill | A2,A3,A6 | — | — | — | Not run | — | — |
| P6 | Workload with EU data residency / sovereignty in the landing zone | Load skill | this skill | A4,A5 | — | — | — | Not run | — | — |

## Negative routing scenarios (must load another skill)

| ID | Prompt (short) | Expected trigger | Expected routing | Assertions | Host | Model | Test date | Result | Observations | Required change |
|----|----------------|------------------|------------------|-----------|------|-------|-----------|--------|--------------|-----------------|
| N1 | Design our management group hierarchy | Do not load skill | `azure-enterprise-infra-planner` | A7 | — | — | — | Not run | — | — |
| N2 | Which Azure services should my new app idea use? | Do not load skill | `azure-app-onboard` | A7 | — | — | — | Not run | — | — |

## Ambiguous routing scenarios

| ID | Prompt (short) | Expected trigger | Expected routing | Assertions | Host | Model | Test date | Result | Observations | Required change |
|----|----------------|------------------|------------------|-----------|------|-------|-----------|--------|--------------|-----------------|
| AM1 | "Help me deploy my app to Azure" (no landing zone stated) | Clarify first | If an existing landing zone → this skill; if greenfield service selection → `azure-app-onboard` | A5,A7 | — | — | — | Not run | — | — |
| AM2 | "Set up private endpoints and DNS for my app" | Clarify first | If central DNS/landing zone exists → this skill; if designing platform DNS → `azure-enterprise-infra-planner` | A3,A5,A7 | — | — | — | Not run | — | — |

## How to record a run

For each executed scenario, fill `Host` (e.g. Copilot CLI), `Model`, `Test date`,
`Result` (`Pass`/`Fail`/`Partial`), `Observations`, and any `Required change`.
Keep pending rows as `Not run` until genuinely executed.
