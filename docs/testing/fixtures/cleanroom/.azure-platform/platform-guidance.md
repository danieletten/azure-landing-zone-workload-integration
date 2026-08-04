# Platform guidance (fictional)

Human-readable companion to `platform-contract.yaml` for the Contoso Orders
production workload. **Fictional** — for illustration only.

> This file and `platform-contract.yaml` are **platform-owned**. Do not edit them
> in the workload repository. The platform team updates them via pull request when
> the platform changes. To propose a change, open a request through the support
> channel below.

## How to use this with the skill

Ask the agent to assess your workload against the platform contract. The
`azure-landing-zone-workload-integration` skill reads `platform-contract.yaml`
first and merges it with your architecture and IaC. It will not re-ask questions
the contract already answers.

## What is already handled for you

- **Subnets:** `snet-appservice-integration` (App Service outbound VNet Integration,
  delegated to `Microsoft.Web/serverFarms`) and `snet-private-endpoints` (private
  endpoints) are already provisioned. Do not create your own subnets.
- **Private endpoint DNS:** automated by Azure Policy for the four `privatelink`
  zones listed in the contract. Do not create private DNS zones or raise a DNS
  request for these services.
- **Providers:** `Microsoft.Web`, `Microsoft.Sql`, `Microsoft.Storage`,
  `Microsoft.KeyVault`, `Microsoft.Network` are registered. `Microsoft.Insights`
  you may register yourself.
- **Diagnostics + tags:** applied by policy; set the required tag values.

## What you must do yourself

- Deploy resources with public network access disabled and private endpoints in
  `snet-private-endpoints`.
- Enable App Service regional VNet Integration into `snet-appservice-integration`
  and route outbound traffic to the central firewall.
- Use managed identities with least-privilege roles on your own resources.

## When to raise a platform request

Only for genuine dependencies you cannot satisfy yourself — for example, an
outbound firewall rule to an external endpoint. Use:

- **Support channel:** platform-requests@contoso.example
- **Request SLA:** 5 business days

## Provenance

- Contract version: `1.4.0`
- Generated: `2026-08-04T09:00:00Z`
- Source: `contoso-example/platform-landing-zone` @ `a1b2c3d4…`

If this contract looks stale or conflicts with the deployed platform, report a
possible drift to the platform team rather than guessing.
