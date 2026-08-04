# Upstream Contribution Path

How to prepare `azure-landing-zone-workload-integration` for contribution to the
upstream development repository.

Inspection baseline: `microsoft/GitHub-Copilot-for-Azure` main tree SHA
`58cf519848f36ba525b51a46beb7824c054f99e3`, inspected 2026-08-04. Verify these
details are still current before acting — upstream conventions change.

## Repositories

- Upstream development repo (contribute here): `microsoft/GitHub-Copilot-for-Azure`
- Public distribution (auto-synced, do not PR here): `microsoft/azure-skills`

## Target skill path

Onboarding docs place pre-built skills under `plugins/<plugin>/skills/`. The
`azure` plugin lives at `plugins/azure-skills/`, so an existing-plugin placement
would be:

```
plugins/azure-skills/skills/azure-landing-zone-workload-integration/
```

> Note: the original task brief referenced `plugin/skills/`. The verified current
> layout is `plugins/azure-skills/skills/`. Upstream guidance also states that new
> skills should generally be contributed as **new plugins** unless they fit an
> existing plugin with capacity — confirm the preferred placement in the
> onboarding issue before finalizing.

This repository keeps the skill self-contained under `skills/<name>/` with
`SKILL.md`, `references/`, and `assets/`, using only relative links, so the folder
can be copied under the chosen upstream `skills/` path without rewrites.

## Process (per upstream Onboarding.md)

1. File a skill onboarding issue using the upstream
   `skill_onboarding_request.yml` template and wait for triage feedback before
   full implementation.
2. Develop in a fork; do not work directly in the upstream repo.
3. Scaffold with `npm run plugin:new` if contributing as a new plugin.
4. Prefix the PR title with `feature:` and link it to the onboarding issue.

## Build and validation commands (verify before use)

```bash
# Build the plugin into output/
npm install
npm run build

# Skill link + token validation (from the skill-authoring tooling)
cd scripts
npm run references
npm run tokens -- check

# Repo-level lint / budget checks referenced in Onboarding.md
npx --yes @microsoft/vally-cli@^0.7.0 lint plugins/ --eval-spec evals/ --strict --grader-plugin ./tests/vally/vally-graders.ts
# in tests/: npm run typecheck && npm run lint
# in scripts/: npm run lint && npm run checkCopilotCliCharBudget && npm run vally validate-stimulus
```

## Testing (Vally)

Upstream requires **routing tests** and **end-to-end integration tests** per skill,
authored with the `vally-eval` skill and hooked into the nightly integration
system. Manual testing uses `copilot --plugin-dir ./output/<plugin>` and
`/skills reload`. The routing/behavioral scenarios in
[evaluation-scenarios.md](evaluation-scenarios.md) are the basis for those Vally
suites; they are **not** a substitute for the upstream eval format.

## Token limits (verified 2026-08-04)

- `SKILL.md`: <500 tokens soft target, <5000 tokens hard limit.
- `references/*.md`: skill-authoring guide says <1000 tokens each; the Onboarding
  token table says <2000. Target <1000 to satisfy the stricter rule.
- Estimation: ~4 characters = 1 token.
- Description char budget is tight in Copilot CLI; keep the frontmatter
  description lean.

## Files/catalogs that must be updated upstream

- Plugin manifests: `.plugin/`, `.claude-plugin/`, `.cursor-plugin/` (if a new
  plugin), plus `version.json`, `LICENSE`, `README.md`, and `.mcp.json` as needed.
- Any generated skill catalog/table produced by `npm run build`.
- `evals/` suites for the new skill.
- **TODO:** confirm the exact manifest/catalog files to edit for the chosen
  placement (new plugin vs `azure-skills`) at contribution time.

## Versioning and CLA

- Versions are stamped automatically via Nerdbank.GitVersioning from
  `version.json`; do not hand-edit computed versions (see upstream `VERSIONING.md`).
- The project uses the Microsoft Open Source Code of Conduct; a Microsoft CLA is
  typically required for contributions. **TODO:** confirm current CLA requirement
  at PR time.

## Pre-PR checklist

- [ ] Onboarding issue filed and triaged.
- [ ] Skill placed under the agreed upstream `skills/` path.
- [ ] `SKILL.md` and references within token limits.
- [ ] No broken relative links; frontmatter `name` matches directory.
- [ ] Routing + e2e Vally suites authored and passing in nightly runs.
- [ ] Lint/char-budget/stimulus checks pass.
- [ ] PR title prefixed `feature:` and linked to the onboarding issue.
- [ ] No organization-specific standard presented as universal Microsoft guidance.
