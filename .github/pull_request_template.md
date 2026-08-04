<!-- Describe your change and confirm it stays within the workload-team integration scope. -->

## Summary

<!-- What does this PR add or change? -->

## Scope check

- [ ] Change stays within the **workload team** perspective (does not design or
      deploy the platform: management groups, connectivity/hub, identity
      platform, or centralized governance).
- [ ] No fabricated URLs, MCP tool names, product capabilities, policies, or
      supported configurations; unverifiable items are marked `TODO`.
- [ ] Microsoft guidance is distinguished from organization-specific decisions.
- [ ] No absolute security or compliance claims.
- [ ] No changes to live Azure resources are implied without explicit user
      authorization.

## Skill checklist (if adding/editing a skill)

- [ ] Folder name and frontmatter `name` match and are lowercase kebab-case.
- [ ] `description` clearly states activation triggers and avoids overlap with
      `azure-app-onboard` and `azure-enterprise-infra-planner`.
- [ ] `SKILL.md` stays concise (< 5000 tokens) and references supporting files;
      references stay within their token budget.

## Validation

- [ ] `python .github/scripts/validate_skills.py` passes locally.
