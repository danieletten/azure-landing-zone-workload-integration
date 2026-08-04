# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project aims to
follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
