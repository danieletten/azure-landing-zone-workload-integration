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
