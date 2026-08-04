# Evaluation Results — v0.2.0-dev (platform-contract hardening)

Genuine manual results for the contract-aware scenarios and the clean-room
end-to-end journey. See [evaluation-scenarios.md](evaluation-scenarios.md) for the
scenario definitions and [testing/README.md](testing/README.md) for the reproducible
harness and exact prompts.

## Test lineage (what was executed, when)

- **Original `v0.1.0` routing tests** — recorded in
  [evaluation-results-v0.1.md](evaluation-results-v0.1.md) (6 positive, 2 negative,
  2 ambiguous). Unchanged.
- **Previously executed platform-contract tests** — C1 (contract present) and C2
  (contract absent), recorded in `evaluation-scenarios.md`. Unchanged.
- **Executed in this task (below)** — C3, C4, C6, C8, C10, and a clean-room
  end-to-end journey.
- **Still not executed** — none of the ten contract-aware scenarios remain
  unexecuted after this task. (C5, C7, C9 were covered by the earlier C1 present-contract run.)

## Run environment

- **Host:** GitHub Copilot CLI `1.0.78` (non-interactive, `copilot -p ... --allow-all-tools`).
- **Model:** Copilot CLI default (not explicitly pinned).
- **Skill:** current working tree (`0.2.0-dev`), installed per-scenario with
  `gh skill install <repo> ... --from-local`.
- **Competing skills:** the installed Azure plugin skill set was available.
- **Date:** 2026-08-04.
- **Pass criterion:** the expected behavior is visible in the answer — not merely
  that the skill loaded.

## Results

| ID | Scenario | Skill loaded | Key assertions met | Result |
|----|----------|--------------|--------------------|--------|
| C3 | Contract vs IaC conflict (NAT vs central firewall) | Yes | Named the conflict; flagged noncompliant workload IaC; did not silently pick a value; remediation = workload action (remove NAT, use central egress); no central-resource change | **Pass** |
| C4 | Stale / no-provenance contract | Yes | Explicitly low-confidence (old date, no version/revision); used facts cautiously; recommended regeneration; invented no replacement values; did not block analysis | **Pass** |
| C6 | Provider needs a request (`Microsoft.ContainerService`) | Yes | Detected it is not registered; raised exactly one provider request; did not tell the team to self-register; no Owner rights | **Pass** |
| C8 | Private DNS `integrationMechanism: platform-request` | Yes | Raised one precise DNS integration request naming all four zones; stated why workload-side is insufficient; DNS-resolution acceptance criteria; no public-access workaround; no local zone | **Pass** |
| C10 | Forbidden central change (firewall/DNS/route table) | Yes | Refused direct central changes by the workload team; explained the boundary; converted to a precise platform request; did not imply Owner; continued workload-owned actions | **Pass** |
| E2E | Clean-room journey (natural prompt, no path hint) | Yes | Auto-located the contract; used its facts; read the Bicep; raised only the genuine firewall request; explicitly declined unnecessary subnet/DNS/provider/diagnostics requests; readiness assigned; no platform-file/live changes | **Pass** |

**Totals: 6 Pass, 0 Partial, 0 Fail.**

## Short sanitized evidence

- **C3:** "`main.bicep` conflicts directly with the contract by creating standalone
  NAT egress … The compliant remediation is to remove NAT-based egress and consume
  the platform-provided forced-tunnel path—not weaken policy or modify central
  networking."
- **C4:** "The contract is low-confidence: generated January 15, 2024, with no
  contract version or source revision." + "Refresh and reissue the platform contract
  with version and source revision."
- **C6:** "`Microsoft.ContainerService` requires a platform request." → platform
  request #1 "Registration of `Microsoft.ContainerService`".
- **C8:** "Private DNS integration requires a platform request; it is not automated."
  → a single request covering all four `privatelink.*` zones with resolution
  acceptance criteria.
- **C10:** "Do not modify the hub route table merely to provide workload internet
  access." + firewall/route changes routed to `platform-requests@…`.
- **E2E:** "No subnet, peering, DNS, provider-registration, diagnostics,
  policy-exemption, or shared-service RBAC request is currently justified." with the
  single `REQ-orders-001` firewall request.

## Behavioral fixes made

None. All six scenarios passed on the current `0.2.0-dev` skill, so no instruction,
decision-rule, or fixture changes were required. (Per the hardening plan, behavior
that already passed was left unchanged to avoid regressions.)

## Known limitations

- Results use the Copilot CLI default model (not pinned); a different model may
  vary in wording. The harness records this.
- The prior `v0.1.0` AM2 ambiguous-routing limitation is unrelated to the contract
  workflow and remains tracked in the v0.1 results.
- Raw transcripts are not committed; reproduce via `docs/testing/`.
