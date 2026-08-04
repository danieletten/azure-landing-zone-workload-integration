#!/usr/bin/env python3
"""Lightweight validation for skills in this repository.

Checks:

1. Required repository files exist.
2. Each skill directory name is lowercase kebab-case.
3. Each skill has a SKILL.md with a valid frontmatter block.
4. The frontmatter `name` matches the skill directory name.
5. The frontmatter `description` is present and non-empty.
6. Relative Markdown links inside each skill resolve to existing files.
7. Token budgets (~4 chars = 1 token): SKILL.md < 5000 tokens (error if exceeded),
   references/*.md < 2000 tokens (warning if exceeded).

Standard library only. No external dependencies.
Exit code is non-zero if any error is found.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
SKILLS_DIR = REPO_ROOT / "skills"

REQUIRED_REPO_FILES = [
    "README.md",
    "CONTRIBUTING.md",
    "LICENSE",
    "SECURITY.md",
    ".github/workflows/validate.yml",
    ".github/pull_request_template.md",
]

KEBAB_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")

SKILL_TOKEN_LIMIT = 5000
REFERENCE_TOKEN_LIMIT = 2000

errors: list[str] = []
warnings: list[str] = []


def approx_tokens(text: str) -> int:
    return (len(text) + 3) // 4


def check_required_repo_files() -> None:
    for rel in REQUIRED_REPO_FILES:
        if not (REPO_ROOT / rel).exists():
            errors.append(f"Missing required repository file: {rel}")


def parse_frontmatter(text: str) -> dict[str, str] | None:
    if not text.startswith("---"):
        return None
    parts = text.split("---", 2)
    if len(parts) < 3:
        return None
    data: dict[str, str] = {}
    for line in parts[1].splitlines():
        m = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if m:
            value = m.group(2).strip().strip("'").strip('"')
            data[m.group(1)] = value
    return data


def is_external_or_anchor(target: str) -> bool:
    return (
        target.startswith("http://")
        or target.startswith("https://")
        or target.startswith("#")
        or target.startswith("mailto:")
    )


def check_links(md_file: Path) -> None:
    text = md_file.read_text(encoding="utf-8")
    for target in LINK_RE.findall(text):
        if is_external_or_anchor(target):
            continue
        link = target.split("#", 1)[0].strip()
        if not link:
            continue
        resolved = (md_file.parent / link).resolve()
        if not resolved.exists():
            errors.append(
                f"Broken relative link in {md_file.relative_to(REPO_ROOT)}: {target}"
            )


def check_skill(skill_dir: Path) -> None:
    name = skill_dir.name
    if not KEBAB_RE.match(name):
        errors.append(f"Skill directory is not lowercase kebab-case: {name}")

    skill_md = skill_dir / "SKILL.md"
    if not skill_md.exists():
        errors.append(f"Missing SKILL.md in skill: {name}")
        return

    text = skill_md.read_text(encoding="utf-8")
    fm = parse_frontmatter(text)
    if fm is None:
        errors.append(f"Invalid or missing frontmatter in {name}/SKILL.md")
    else:
        if fm.get("name", "") != name:
            errors.append(
                f"Frontmatter name '{fm.get('name', '')}' does not match directory '{name}'"
            )
        if not fm.get("description"):
            errors.append(f"Frontmatter description is missing or empty in {name}/SKILL.md")

    tokens = approx_tokens(text)
    if tokens >= SKILL_TOKEN_LIMIT:
        errors.append(
            f"{name}/SKILL.md exceeds hard token limit: ~{tokens} >= {SKILL_TOKEN_LIMIT}"
        )

    for md_file in skill_dir.rglob("*.md"):
        check_links(md_file)
        if md_file.name != "SKILL.md" and "references" in md_file.parts:
            rtokens = approx_tokens(md_file.read_text(encoding="utf-8"))
            if rtokens > REFERENCE_TOKEN_LIMIT:
                warnings.append(
                    f"Reference over token budget: {md_file.relative_to(REPO_ROOT)} "
                    f"~{rtokens} > {REFERENCE_TOKEN_LIMIT}"
                )


def main() -> int:
    check_required_repo_files()

    if not SKILLS_DIR.is_dir():
        errors.append("Missing skills/ directory")
    else:
        skill_dirs = [p for p in SKILLS_DIR.iterdir() if p.is_dir()]
        if not skill_dirs:
            errors.append("No skills found under skills/")
        for skill_dir in sorted(skill_dirs):
            check_skill(skill_dir)

    for warn in warnings:
        print(f"WARNING: {warn}")

    if errors:
        print("\nValidation FAILED:\n")
        for err in errors:
            print(f"  - {err}")
        return 1

    print("Validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
