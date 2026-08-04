# Policy Remediation and Escalation

Purpose: investigate policy and platform blockers, prefer compliant remediation,
and escalate to precise platform requests only when necessary.

## Handling any blocker

For every blocker:

1. Identify the actual controlling policy, platform dependency, or missing
   permission when evidence is available.
2. Explain the intent of the guardrail.
3. Look for a compliant workload-side remediation first.
4. Determine whether an existing approved platform pattern already solves it.
5. Escalate to a platform request only when the workload cannot resolve it.
6. Treat a policy exemption as a last resort.

Never weaken or bypass a security control merely to make a deployment succeed.

## Investigating an Azure Policy denial

- Read the deployment error; capture the policy assignment ID and definition ID.
- Determine the effect: `Deny` blocks deployment; `Modify`/`Append`/
  `DeployIfNotExists` change or remediate after deployment.
- Identify the exact resource property that triggered the effect and whether it
  is configurable in the workload IaC. Illustrative read-only commands:
  - `az policy assignment list --scope <scope> -o table`
  - `az policy definition show --name <definitionName>`
- Prefer a compliant configuration: disable public network access, add required
  tags, choose an allowed SKU/region, enable diagnostic settings, etc.

The workload team never disables, reassigns, or edits a central policy.

## When to raise a platform team request

Raise a request when the workload needs any of: a new/resized workload
subscription or feature; VNet peering, address space, or subnet delegation;
a firewall rule or central egress allowance; private DNS zone linking or record
creation; a role assignment on a shared platform resource; or any change to
management groups, central policy, hub, DNS, or the identity platform (which the
workload team cannot perform).

Rules:

- Do not request a change the workload team could implement compliantly itself.
- Keep each requested change explicit, least-privilege, and testable.
- Draft one request per dependency with
  [../assets/platform-team-request.md](../assets/platform-team-request.md).

## Exemption as last resort

Only when no compliant configuration exists, propose a scoped, time-bound
exemption request. Require, before proposing it: scope, justification, risk,
duration, compensating controls, and an owner. Never present an exemption as a
permanent architectural solution.

## Common mistakes

- Requesting an exemption as the first response to a denial.
- Setting `publicNetworkAccess` to `Enabled` to "make it work".
- Removing diagnostic settings or required tags to pass validation.
- Vague firewall requests without source, destination, port, and protocol.

## Expected output

- The specific blocker (policy/effect/property or dependency).
- A compliant remediation, or a justified escalation/exemption if none exists,
  clearly labeled as workload-owned vs platform-owned.

Source links: [official-source-map.md](official-source-map.md).
