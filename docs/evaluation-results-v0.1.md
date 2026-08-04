# Evaluation Results — v0.1 (manual)

Manual evaluation log for `azure-landing-zone-workload-integration`. Scenarios
derive from [evaluation-scenarios.md](evaluation-scenarios.md).

## Run environment

- **Host:** GitHub Copilot CLI `1.0.78` (non-interactive, `copilot -p ... --allow-all-tools`).
- **Model:** Copilot CLI default model (not explicitly pinned during the run).
- **Skill install:** `gh skill install danieletten/azure-landing-zone-workload-integration ... --scope project` (ref `main`, tree `4cf6c69`), installed to `.agents/skills/`.
- **Competing skills present:** Yes — the installed Azure plugin skill set (including
  `azure-app-onboard`, `azure-enterprise-infra-planner`, `azure-prepare`) was available,
  so routing was tested end-to-end against real alternatives.
- **Test date:** 2026-08-04.
- **Trigger signal:** the CLI prints `● skill(<name>)` when it loads a skill; this is
  the observable used for the `Result` column.

## Behavioral assertions (referenced by ID)

- **A1** Does not suggest a policy exemption as the first response.
- **A2** Does not assume subscription Owner permissions.
- **A3** Does not create or modify central platform resources.
- **A4** Does not invent organization-specific standards.
- **A5** Distinguishes confirmed facts from assumptions.
- **A6** Separates workload-team actions from platform-team requests.
- **A7** Routes out-of-scope requests to another skill (does not mis-trigger).

## Positive trigger scenarios (should load this skill)

| ID | Prompt (short) | Expected | Host | Model | Date | Result | Observations |
|----|----------------|----------|------|-------|------|--------|--------------|
| P1 | Integrate App Service workload into a vended landing zone (central egress + private DNS) | Load skill | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Loaded skill; full 9-category output; A2/A5/A6 met; readiness "Ready after platform dependency" |
| P2 | Bicep deployment denied by inherited Azure Policy | Load skill | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Read policy references; compliant remediation first, exemption explicitly last (A1); "do not modify inherited policy" (A3); A6 met |
| P3 | Private endpoint won't resolve through central private DNS | Load skill | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Loaded skill |
| P4 | Outbound access through central Azure Firewall | Load skill | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Loaded skill |
| P5 | Managed identity needs access to a shared platform service | Load skill | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Least-privilege at narrowest scope; cross-sub grant is a platform request, not self-granted (A2/A3/A6) |
| P6 | Workload with EU data residency / sovereignty in the landing zone | Load skill | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Loaded skill |

## Negative routing scenarios (must load another skill, not this one)

| ID | Prompt (short) | Expected | Host | Model | Date | Result | Observations |
|----|----------------|----------|------|-------|------|--------|--------------|
| N1 | Design our management group hierarchy from scratch | Route away (A7) | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Routed to `azure-enterprise-infra-planner`; this skill did not trigger |
| N2 | New app idea, which Azure services? | Route away (A7) | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Routed to `azure-prepare` (a non-landing-zone Azure skill); this skill did not trigger. Expected `azure-app-onboard`; alternative choice is outside this skill's control |

## Ambiguous routing scenarios

| ID | Prompt (short) | Expected | Host | Model | Date | Result | Observations |
|----|----------------|----------|------|-------|------|--------|--------------|
| AM1 | "Help me deploy my app to Azure" (no landing zone stated) | Should not over-trigger | Copilot CLI 1.0.78 | default | 2026-08-04 | Pass | Routed to `azure-prepare`; this skill did not trigger — correct given no landing-zone context |
| AM2 | "Set up private endpoints and DNS for my app" | Borderline | Copilot CLI 1.0.78 | default | 2026-08-04 | Partial | This skill triggered and produced a sound assessment that flagged missing context and returned "Blocked by platform dependency". Defensible (private endpoints + central DNS are in scope) but could arguably route to `azure-prepare` for greenfield apps |

## Summary

- Positive triggers: **6/6 Pass**.
- Negative routing: **2/2 Pass** (routed to appropriate alternative Azure skills).
- Ambiguous: 1 Pass, 1 Partial (AM2 over-triggers on a context-free private-endpoint prompt).
- Behavioral assertions A1–A6 observed as satisfied in the inspected positive
  responses; A7 satisfied across negative/ambiguous cases.

## Follow-ups

- Consider a small description tweak so a context-free "private endpoints and DNS
  for my app" (no landing zone mentioned) leans toward `azure-prepare` (AM2). Track
  before promoting past preview if it recurs.
- Re-run with an explicitly pinned model to record a fixed model identifier.

## How to reproduce

1. Install the skill at project scope in a clean directory (`gh skill install danieletten/azure-landing-zone-workload-integration azure-landing-zone-workload-integration --scope project`).
2. For each prompt, run `copilot -p "<prompt>" --allow-all-tools` from that directory.
3. Record whether the output begins with `● skill(azure-landing-zone-workload-integration)` and review the response against the behavioral assertions.
