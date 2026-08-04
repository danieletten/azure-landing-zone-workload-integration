# Release Checklist — v0.1.0

Work through this before tagging a release. Items marked _(verified 2026-08-04)_
were confirmed during preparation; the rest are executed by the repository owner.

## Validation

- [x] Static skill validation passes: `python .github/scripts/validate_skills.py` _(verified 2026-08-04)_.
- [x] Relative Markdown links resolve across the repository (skill, `docs/`, `examples/`, root) _(verified 2026-08-04)_.
- [x] Token counts within budget: `SKILL.md` < 5000 (body ~900); each reference < 2000 _(verified 2026-08-04)_.
- [x] Installation commands verified with `gh skill --help` and against the public repo (`gh skill preview` / `gh skill install`) _(verified 2026-08-04, GitHub CLI 2.96.0)_.
- [x] Manual installation verified (`gh skill install . azure-landing-zone-workload-integration --from-local`) _(verified 2026-08-04)_.

## Routing and behavior

- [x] Positive routing scenarios executed and recorded in `docs/evaluation-results-v0.1.md` (P1–P6, all Pass) _(verified 2026-08-04, Copilot CLI 1.0.78)_.
- [x] Negative routing scenarios executed and recorded (N1–N2, routed to other Azure skills) _(verified 2026-08-04)_.
- [x] Ambiguous scenarios reviewed (AM1 Pass, AM2 Partial — see follow-ups) _(verified 2026-08-04)_.

## Content and compliance

- [x] Official source links in `references/official-source-map.md` reviewed and reachable _(verified 2026-08-04)_.
- [x] Reviewed for customer or Microsoft confidential information — example is fully fictional; none present _(verified 2026-08-04)_.
- [x] Community disclaimer present in README, SECURITY, and issue-template config _(verified 2026-08-04)_.
- [x] No references to the old skill name; frontmatter `name` matches the directory _(verified 2026-08-04)_.

## Repository settings

- [ ] GitHub repository visibility and security settings reviewed (public; secret scanning / Dependabot as desired).
- [ ] Repository topics set (see README completion notes).

## Release

- [ ] Update `CHANGELOG.md`: move `[0.1.0]` from Unreleased to a dated release.
- [x] Create the `v0.1.0` tag _(done 2026-08-04)_.
- [ ] Create release notes (GitHub Release).
- [x] Verify the install command against the public repository:
      `gh skill install danieletten/azure-landing-zone-workload-integration azure-landing-zone-workload-integration@v0.1.0` _(verified 2026-08-04)_.
