# Contributing

Thank you for your interest in contributing. This is a community project focused
on helping **workload teams** integrate a workload into an **existing** Azure
Landing Zone. Contributions should stay within that scope and be prepared so the
skill remains copyable into the upstream Microsoft repository.

## Scope

- **In scope:** workload/application landing zone integration, consuming
  centralized platform services, workload IaC that complies with inherited
  guardrails, policy remediation before escalation, and precise platform team
  requests.
- **Out of scope:** building or redesigning the platform (management groups,
  connectivity/hub, identity platform, centralized governance). Those belong to
  `azure-enterprise-infra-planner`. Application/service selection belongs to
  `azure-app-onboard`.

## Quality guidelines

- Be specific and actionable; prefer checklists and decision rules over prose.
- Use precise Azure terminology; avoid marketing language.
- Do not make absolute security or compliance claims.
- Clearly distinguish Microsoft guidance from organization-specific decisions.
- Cite only verified Microsoft sources
  (`skills/azure-landing-zone-workload-integration/references/official-source-map.md`).
  Do not fabricate URLs, MCP tool names, product capabilities, or supported
  configurations. When something cannot be verified, add a visible `TODO`.
- Prefer Azure Verified Modules and Bicep in new Azure-only examples, while
  keeping Terraform workloads usable.

## Skill format and token discipline

Follow the upstream `microsoft/GitHub-Copilot-for-Azure` conventions so the skill
stays contribution-ready:

- Frontmatter: `name` (lowercase-hyphens, matches directory), `description`
  (WHAT + WHEN with quoted triggers, ≤1024 chars), `license`, `metadata`.
- Token budgets (~4 chars = 1 token): `SKILL.md` < 500 tokens soft / < 5000 hard;
  `references/*.md` target < 1000 tokens (hard ceiling 2000). Move detail from
  `SKILL.md` into `references/`.
- Keep a small number of focused references; link to files, not folders.
- Do not add a `README.md` inside the skill directory (upstream skills do not).

See [`docs/upstream-contribution.md`](docs/upstream-contribution.md) for the full
upstream path, including Vally evaluation requirements.

## Validate before opening a pull request

```bash
python .github/scripts/validate_skills.py
```

The validation checks required files, kebab-case skill names, valid `SKILL.md`
frontmatter, `name`↔directory match, non-empty `description`, relative link
resolution, and approximate token budgets.

## License

By contributing, you agree that your contributions are licensed under the
[MIT License](LICENSE).
