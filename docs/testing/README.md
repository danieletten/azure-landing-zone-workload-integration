# Platform-contract scenario testing

Small, reproducible harness for exercising the contract-aware behavior of the
`azure-landing-zone-workload-integration` skill against genuine Copilot CLI runs.

- No secrets, no customer data, no live Azure access.
- Runs in a temporary directory and cleans up after each scenario.
- Uses only fictional fixtures under `fixtures/`.

## Requirements

- GitHub CLI with the `gh skill` preview.
- GitHub Copilot CLI (`copilot`).
- The competing Azure plugin skills installed (so routing is tested realistically).

## Fixtures

| Fixture | Purpose |
|---|---|
| `fixtures/C3` | Contract mandates central firewall egress; `main.bicep` deploys a conflicting NAT Gateway (drift / noncompliant IaC). |
| `fixtures/C4` | Contract missing `contractVersion`/`sourceRevision` and with an old `generatedAt` (stale / no provenance). |
| `fixtures/C6` | `resourceProviders.requestRequired` includes `Microsoft.ContainerService`; workload needs AKS. |
| `fixtures/C8` | `privateDns.integrationMechanism: platform-request` (DNS not automated). |
| `fixtures/C10` | Standard contract; prompt asks the workload team to change central firewall/DNS/route table directly. |
| `fixtures/cleanroom` | Full vended repo (contract + guidance + Bicep + README) for an end-to-end natural-prompt journey. |

## Run one scenario

```powershell
./run-scenario.ps1 -Id C3 `
  -FixtureDir ./fixtures/C3 `
  -SkillRepo <path-to-this-repo-root> `
  -OutDir <writable-output-dir> `
  -Prompt "Review our workload against the platform contract in .azure-platform/platform-contract.yaml and the Bicep in main.bicep. Tell us what to do."
```

The script copies the fixture to a temp dir, installs the working-tree skill with
`gh skill install <repo> ... --from-local`, runs `copilot -p`, saves the transcript
to `<OutDir>/<Id>.txt`, prints whether the skill loaded, and deletes the temp dir.

## Prompts used for the recorded results

- **C3:** "Review our workload against the platform contract in .azure-platform/platform-contract.yaml and the Bicep in main.bicep. Tell us what to do."
- **C4:** "Review our workload against the platform contract in .azure-platform/platform-contract.yaml. We plan Linux App Service and Azure SQL. What should our team do and what needs the platform team?"
- **C6:** "Our workload needs Azure Kubernetes Service (AKS) alongside App Service. Review against the platform contract in .azure-platform/platform-contract.yaml and tell us what we can implement ourselves and what needs the platform team."
- **C8:** "Review our App Service, Azure SQL, Blob Storage and Key Vault design against the platform contract in .azure-platform/platform-contract.yaml. We will use private endpoints. What do we implement and what do we need from the platform team?"
- **C10:** "Please update the central Azure Firewall and the central private DNS zone directly so our workload resolves and reaches the internet, and modify the hub route table. Walk us through making these central changes ourselves."
- **cleanroom (natural, no path hint):** "We received the production application landing zone subscription and repository for this workload. Review our Bicep design against the platform setup, identify what our team can implement, and create only the platform requests that are actually required."

Recorded outcomes are in
[`../evaluation-results-v0.2-dev.md`](../evaluation-results-v0.2-dev.md). Raw model
transcripts are intentionally **not** committed; re-run the harness to reproduce.
