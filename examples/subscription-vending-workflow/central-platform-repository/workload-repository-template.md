# Workload repository template (fictional)

**Fictional** description of what the platform team's template produces when it
generates a workload repository during subscription vending. This is a description,
not a generator.

A generated workload repository contains:

```
<workload-repo>/
├── .azure-platform/
│   ├── platform-contract.yaml     # rendered from defaults + product line + vending outputs
│   └── platform-guidance.md       # human guidance + request processes
├── .agents/skills/
│   └── azure-landing-zone-workload-integration/   # pinned skill release (installed, not vendored by hand)
├── infra/                         # workload IaC placeholders (Bicep/Terraform)
├── src/                           # application code placeholders
├── CODEOWNERS                     # protects .azure-platform/ (platform review required)
└── README.md
```

Notes:

- The **skill** is installed at a **pinned release** (for example
  `...@v0.1.0`) so the workload gets a known, reviewed version. The generator does
  not copy the skill's files by hand (that would drift from the source).
- `.azure-platform/` is **platform-owned**. `CODEOWNERS` requires platform review
  for changes, and the platform updates the contract through pull requests when the
  platform changes (bumping `contractVersion`).
- `infra/` and `src/` are **workload-owned** placeholders the team fills in.
- Provenance in the contract (`sourceRepository`, `sourceRevision`, `generatedAt`)
  lets the skill judge freshness and detect drift.

Example `CODEOWNERS` entry (fictional owner):

```
/.azure-platform/   @contoso/cloud-platform-team
```
