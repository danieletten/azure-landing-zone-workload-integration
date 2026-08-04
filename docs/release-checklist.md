# Release Checklist — v0.1.0

Work through this before tagging a release. **Do not** create the tag or GitHub
release as part of preparation; this checklist is executed by the repository owner
when ready.

## Validation

- [ ] Static skill validation passes: `python .github/scripts/validate_skills.py`.
- [ ] Relative Markdown links resolve across the repository (skill, `docs/`, `examples/`, root).
- [ ] Token counts within budget: `SKILL.md` < 5000 (target 700–900 body); each reference < 2000.
- [ ] Installation commands verified with `gh skill --help` on a supported GitHub CLI.
- [ ] Manual installation verified (`gh skill install . azure-landing-zone-workload-integration --from-local`, or folder copy).

## Routing and behavior

- [ ] Positive routing scenarios executed and recorded in `docs/evaluation-results-v0.1.md` (P1–P6).
- [ ] Negative routing scenarios executed and recorded (N1–N2).
- [ ] Ambiguous scenarios reviewed (AM1–AM2).

## Content and compliance

- [ ] All official source links in `references/official-source-map.md` reviewed and reachable.
- [ ] Reviewed for customer or Microsoft confidential information (none present).
- [ ] Community disclaimer present in README, SECURITY, and issue-template config.
- [ ] No references to the old skill name; frontmatter `name` matches the directory.

## Repository settings

- [ ] GitHub repository visibility and security settings reviewed (public; secret scanning / Dependabot as desired).
- [ ] Repository topics set (see README completion notes).

## Release

- [ ] Update `CHANGELOG.md`: move `[0.1.0]` from Unreleased to a dated release.
- [ ] Create the `v0.1.0` tag.
- [ ] Create release notes.
- [ ] Verify the install command against the public repository:
      `gh skill install danieletten/azure-landing-zone-workload-integration azure-landing-zone-workload-integration@v0.1.0`.
