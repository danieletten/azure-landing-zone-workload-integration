# Subscription vending → workload integration (fictional example)

A **fictional, illustrative** model of how a platform team's subscription-vending
process produces a workload repository with a generated **platform contract**,
which this skill then consumes. All values are invented.

This is a **design illustration only** — not a subscription-vending engine or a
repository generator. It shows the contract model and the handoff, not an
implementation.

## Why an overlay, not a fork

Organizations should keep the **generic public skill** and add a **platform-owned
contract overlay** per workload repository, rather than forking the skill with
hard-coded platform values. The skill stays neutral and updatable; the contract
carries the organization specifics.

```
Generic public skill  +  generated platform contract  +  workload architecture/IaC
        =  workload integration assessment
```

## What's in this example

```
subscription-vending-workflow/
├── central-platform-repository/          # platform team's source of truth
│   ├── platform-contract-defaults.yaml   # org-wide defaults
│   ├── product-lines/
│   │   └── connected-online.yaml          # product-line overrides
│   ├── responsibility-model.md            # org RACI (platform vs workload)
│   └── workload-repository-template.md    # what generated repos contain
└── generated-workload-repository/         # output handed to the workload team
    └── .azure-platform/
        ├── platform-contract.yaml         # rendered contract (defaults + product line + vending outputs)
        └── platform-guidance.md           # human guidance + request processes
```

- **Central platform source of truth:** `central-platform-repository/` (defaults +
  product lines + responsibility model + repo template).
- **Product-line defaults:** `product-lines/connected-online.yaml`.
- **Generated workload-repository output:** `generated-workload-repository/.azure-platform/`.
- **Generic public skill:** installed into the workload repository (see bootstrap
  below); **not** duplicated here, to avoid drift.

## Repository bootstrap sequence (illustrative)

1. Select the subscription-vending **product line** (e.g. `connected-online`).
2. **Create and configure the subscription** (placement, RBAC, inherited governance,
   provider registration, networking, budgets/tags, monitoring, security baseline).
3. **Create the workload repository** from the organization template.
4. **Install a pinned release of the skill** into the repo, for example:
   ```bash
   gh skill install danieletten/azure-landing-zone-workload-integration \
     azure-landing-zone-workload-integration@v0.1.0 --scope project
   ```
   (Pin to a released tag so the workload gets a known, reviewed version.)
5. **Render `.azure-platform/platform-contract.yaml`** from vending outputs +
   product-line defaults, with provenance (`sourceRepository`, `sourceRevision`,
   `contractVersion`, `generatedAt`).
6. Add `platform-guidance.md` and provenance.
7. **Protect platform-owned files** (e.g. `CODEOWNERS` requiring platform review
   for `.azure-platform/`).
8. Hand the repository and subscription to the workload team.
9. **Update the contract later via platform-generated pull requests** when the
   platform changes (regenerate, bump `contractVersion`).

## How the workload team uses it

The workload team adds its architecture and IaC, then asks the agent to assess the
workload against the contract. The skill reads `.azure-platform/platform-contract.yaml`
first (see the skill's `references/platform-contract.md`), merges it with workload
facts and IaC, and produces the assessment — raising platform requests **only** for
genuine dependencies. See
[`../completed-workload-integration-assessment.md`](../completed-workload-integration-assessment.md).

> The generic template these files are based on is
> `skills/azure-landing-zone-workload-integration/assets/platform-contract-template.yaml`.
> The format is project-specific and **not** an official Microsoft schema.
