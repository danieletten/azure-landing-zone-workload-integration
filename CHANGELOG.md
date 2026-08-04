# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project aims to
follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Platform contract overlay model: generic template
  `skills/azure-landing-zone-workload-integration/assets/platform-contract-template.yaml`
  and a new reference `references/platform-contract.md` (source precedence,
  provenance, drift handling, degraded mode).
- Subscription-vending workflow example under
  `examples/subscription-vending-workflow/` (central platform repository with
  defaults, a `corp-connected-online` product line, responsibility model, and repo
  template; plus a generated workload repository with a rendered
  `.azure-platform/platform-contract.yaml` and `platform-guidance.md`).
- Completed assessment example `examples/completed-workload-integration-assessment.md`.
- Platform-team request examples under `examples/platform-team-requests/`
  (firewall egress — required by the primary scenario; shared-service private
  endpoint approval and network address-space/subnet allocation — illustrative
  alternatives).
- Contract-aware evaluation scenarios and behavioral assertions in
  `docs/evaluation-scenarios.md`, with an honest execution log of the two genuinely
  run cases (contract present / absent).

### Changed
- Rewrote `examples/app-service-platform-integration.md` around a realistic
  post-vending prompt and three stages (request → platform handoff → assessment),
  with corrected App Service networking (dedicated `Microsoft.Web/serverFarms`
  integration subnet for outbound vs. a separate non-delegated subnet for private
  endpoints) and contract-driven (automated) private DNS.
- Updated `SKILL.md` and references to read `.azure-platform/platform-contract.yaml`
  first, apply source precedence and drift handling, operate in degraded mode when
  the contract is absent, make private DNS and resource-provider handling
  contract-driven, and avoid unnecessary platform requests.
- Extended the assessment and platform-request templates with platform-contract
  source/version/product-line, drift status, request identifier, existing-automated-path
  check, and request-channel fields.
- Added App Service networking and subscription-vending sources to
  `references/official-source-map.md`.
- Added a "Platform-team customization and subscription vending" section to the README.
- Marked `main` as development toward the next release: skill `metadata.version` is
  now `0.2.0-dev` (the `v0.1.0` tag and release remain at `0.1.0`).
- Validated the platform-contract workflow with genuine Copilot CLI runs: contract
  vs IaC conflict (C3), stale/unprovenanced contract (C4), provider request required
  (C6), private DNS request required (C8), forbidden central change (C10), and a
  clean-room end-to-end journey — all passed (6/6). Added a reproducible test harness
  and fictional fixtures under `docs/testing/` and results in
  `docs/evaluation-results-v0.2-dev.md`. No skill behavior changes were required.
- Pre-release example cleanup: replaced two atypical platform-request showcases —
  removed the manual private DNS integration example (central DNS is normally
  automated via the `Deploy-Private-DNS-Zones` policy or equivalent) and the
  shared-service UAMI role-assignment example — with a shared-service private
  endpoint approval example and a network address-space/subnet allocation example.
  `platform-request` / hybrid private DNS support, the C8 scenario and fixture, and
  shared-service access guidance are retained.
- Distinguished human vs deployment-identity permissions: added an optional
  `subscription.deploymentIdentityRole` field to the platform-contract template and
  a decision rule clarifying that when the CI/CD identity is Owner at
  workload-subscription scope, workload resources, UAMIs, and workload-scope role
  assignments are pipeline actions (not platform requests), while cross-subscription
  and central changes remain platform requests. Added targeted evaluation C11
  (executed 2026-08-04, **Pass**).

## [0.1.0] - 2026-08-04

First public community preview.

### Added
- Skill `azure-landing-zone-workload-integration` with concise `SKILL.md`,
  four references, and two assets.
- Routing boundaries against `azure-app-onboard` and `azure-enterprise-infra-planner`.
- Worked example: `examples/app-service-platform-integration.md`.
- Evaluation scenarios and a manual evaluation log (`docs/evaluation-scenarios.md`,
  `docs/evaluation-results-v0.1.md`).
- Community issue templates (routing, Azure guidance, new scenario, responsibility
  feedback, feature request) and a pull request template.
- Repository validation script and GitHub Actions workflow.
- Upstream design-compatibility notes under `docs/upstream/`.

### Notes
- Community project; not an official Microsoft or GitHub product.
- `gh skill` install commands documented against GitHub CLI preview (verified on
  v2.96.0) and GitHub Copilot CLI 1.0.78; syntax may change while the feature is
  in preview.
- Frontmatter `metadata.version` set to `0.1.0` (the upstream `0.0.0-placeholder`
  is only meaningful with the upstream build's automatic version stamping, which
  this standalone repository does not use).
- Routing/behavioral evaluation executed on 2026-08-04; see
  `docs/evaluation-results-v0.1.md` (6/6 positive triggers, 2/2 negative routing).

[Unreleased]: https://github.com/danieletten/azure-landing-zone-workload-integration/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/danieletten/azure-landing-zone-workload-integration/releases/tag/v0.1.0
