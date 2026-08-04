# Evaluation Scenarios

Human-readable routing and behavioral scenarios. These are the **basis for future
upstream Vally suites** (routing + end-to-end), not a substitute for the upstream
eval format. See [upstream/contribution.md](upstream/contribution.md).

## Positive trigger scenarios (should load this skill)

1. Integrate an existing App Service workload into a vended application landing
   zone with central egress and private DNS.
2. A Bicep deployment denied by inherited Azure Policy.
3. A private endpoint that cannot resolve through centralized private DNS.
4. A workload that needs outbound access through a central Azure Firewall.
5. A managed identity that needs access to a shared platform service.
6. A workload with European data residency or sovereignty requirements.
7. A team asking which actions belong to them and which require the platform team.

For each: capture context, discover the platform contract, split responsibilities,
assess only relevant domains, and produce workload actions + platform requests.

## Negative / routing scenarios (must load another skill)

1. Designing the complete management group hierarchy → `azure-enterprise-infra-planner`.
2. Designing the enterprise hub network → `azure-enterprise-infra-planner`.
3. Choosing Azure services for a new application idea → `azure-app-onboard`.
4. Preparing a generic app for Azure with no existing landing zone context →
   `azure-app-onboard` / `azure-prepare`.
5. Running standard deployment validation → `azure-validate`.
6. Deploying infrastructure that is already ready → `azure-deploy`.

## Behavioral assertions (verify in e2e evals)

The skill must:

1. Not suggest a policy exemption as the first response to a denial.
2. Not assume subscription Owner permissions.
3. Not create or modify central platform resources.
4. Not invent organization-specific standards (regions, tags, DNS zones, policy).
5. Distinguish confirmed facts from assumptions.
6. Separate workload team actions from platform team requests.
7. Route out-of-scope requests to the correct existing skill.

## Platform-contract-aware scenarios

These exercise the `.azure-platform/platform-contract.yaml` overlay model. Use the
fictional `examples/subscription-vending-workflow/` contract as input.

1. **Valid contract supplies all facts** — a complete contract is present; the skill
   uses it and does not re-ask answered questions.
2. **Contract absent** — no `.azure-platform/platform-contract.yaml`; the skill says
   so, runs in degraded discovery mode, and marks missing facts as assumptions.
3. **Contract conflicts with IaC** — contract says central-firewall egress but IaC
   deploys a NAT gateway; the skill flags possible drift and names the conflicting
   values.
4. **Contract old / no provenance** — missing `contractVersion`/`generatedAt`; the
   skill proceeds but flags low confidence and recommends regeneration.
5. **Provider already registered** — a provider is in `resourceProviders.registered`;
   the skill does not raise a provider request.
6. **Provider requires a request** — a needed provider is in `requestRequired`; the
   skill raises exactly one provider request.
7. **Private DNS automated** — `integrationMechanism: policy-dine` for the needed
   zones; the skill raises no DNS request.
8. **Private DNS needs a request** — mechanism is `platform-request` for a zone; the
   skill raises a DNS request.
9. **Subnets already provisioned** — the contract lists the App Service integration
   and private-endpoint subnets; the skill uses them and requests no subnet change.
10. **Forbidden central change** — the workload asks for a central-platform change
    the contract forbids; the skill refuses to make it and routes it as a platform
    request instead.
11. **Human vs deployment identity** — the contract sets `workloadTeamRole:
    Contributor` and `deploymentIdentityRole: Owner` (workload-subscription scope).
    Deploying a UAMI and assigning least-privilege roles on workload-owned resources
    are pipeline actions (no platform request to create/configure the UAMI), while
    access to a platform-owned resource in another subscription remains a platform
    request. The skill must not infer central/cross-subscription permissions from
    workload-subscription Owner.

## Contract-aware behavioral assertions

The skill must:

1. Not repeat questions the contract already answers.
2. Not create unnecessary platform requests (already registered/automated/permitted).
3. Flag contract drift instead of silently choosing a value.
4. Distinguish workload requirements from platform facts.
5. Correctly separate App Service **integration** (delegated, outbound) and
   **private endpoint** (non-delegated, inbound) subnets.
6. Never treat central platform values as universal Microsoft defaults.

## Execution status (Unreleased changes)

Genuinely executed on 2026-08-04 with GitHub Copilot CLI `1.0.78` against the
current working-tree skill, using the fictional
`examples/subscription-vending-workflow/` contract as input:

- **Contract present** (covers C1, C5, C7, C9 + contract-aware assertions 1, 2, 4,
  5): the skill read `.azure-platform/platform-contract.yaml`, used the provisioned
  subnets, raised **only** the firewall egress request, and explicitly raised **no**
  request for providers, subnets, private DNS, diagnostics, or tags. **Pass.**
- **Contract absent** (covers C2 + assertions 5, 6): the skill searched for the
  contract, reported "no platform contract is present … degraded-mode review", did
  not invent regions/tags/DNS/policies (listed them as items to confirm), and kept
  the App Service integration subnet (delegated) separate from the private-endpoint
  subnet (non-delegated). **Pass.**

All ten contract-aware scenarios have now been executed. In addition to the
contract-present and contract-absent runs above (C1, C2, and the C5/C7/C9 behaviors
covered by the present-contract run), C3 (drift), C4 (stale/no provenance), C6
(provider request required), C8 (DNS request required), C10 (forbidden central
change) and a clean-room end-to-end journey were executed on 2026-08-04 with skill
`0.2.0-dev` and **all passed**. No contract-aware scenarios remain unexecuted. See
[evaluation-results-v0.2-dev.md](evaluation-results-v0.2-dev.md) and the reproducible
harness in [testing/README.md](testing/README.md).
