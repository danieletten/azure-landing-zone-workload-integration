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
  (firewall egress — required by the primary scenario; private DNS and shared-service
  role — illustrative alternatives).
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
