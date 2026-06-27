"""Validate repo-local skill structure and required SKILL.md sections."""

from __future__ import annotations

from pathlib import Path


REQUIRED_SECTIONS = [
    "when_to_use",
    "required_context",
    "workflow",
    "validation",
    "handoff_output",
    "promotion_notes",
]

RESERVED_FILES = {
    "README.md",
    "TEMPLATE_SKILL.md",
}


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _skill_dirs(skills_root: Path) -> list[Path]:
    if not skills_root.is_dir():
        return []
    return [
        path
        for path in sorted(skills_root.iterdir())
        if path.is_dir() and not path.name.startswith(".")
    ]


def _validate_skill(skill_dir: Path, root: Path, failures: list[str]) -> None:
    skill_file = skill_dir / "SKILL.md"
    relative_skill = skill_file.relative_to(root).as_posix()

    if not skill_file.is_file():
        failures.append(f"missing {relative_skill}")
        return

    content = skill_file.read_text(encoding="utf-8")
    if not content.startswith("---"):
        failures.append(f"{relative_skill} must start with front matter")

    for key in ["name:", "description:"]:
        if key not in content:
            failures.append(f"{relative_skill} front matter missing '{key}'")

    comparable = content.lower()
    for section in REQUIRED_SECTIONS:
        heading = f"## {section}"
        if heading not in comparable:
            failures.append(f"{relative_skill} missing required section '{section}'")


def main() -> int:
    root = _repo_root()
    skills_root = root / "skills"
    failures: list[str] = []

    if not (skills_root / "TEMPLATE_SKILL.md").is_file():
        failures.append("missing skills/TEMPLATE_SKILL.md")

    for path in skills_root.iterdir():
        if path.is_file() and path.name not in RESERVED_FILES:
            failures.append(f"unexpected file in skills root: {path.relative_to(root).as_posix()}")

    skill_dirs = _skill_dirs(skills_root)
    if not skill_dirs:
        failures.append("no repo-local skills found")

    for skill_dir in skill_dirs:
        _validate_skill(skill_dir, root, failures)

    if failures:
        print("Repo-local skill validation failed:")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print("Repo-local skill validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
