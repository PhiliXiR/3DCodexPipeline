"""Validate that foundation documentation remains complete and discoverable."""

from __future__ import annotations

from pathlib import Path


REQUIRED_REFERENCES = {
    "AGENTS.md": [
        "docs/PROJECT_VISION.md",
        "docs/ARCHITECTURE.md",
        "docs/FOLDER_STRUCTURE.md",
        "docs/CODING_STANDARDS.md",
        "docs/GLOSSARY.md",
        "docs/SKILL_LIFECYCLE.md",
        "docs/adr/",
    ],
    "docs/ARCHITECTURE.md": [
        "docs/GLOSSARY.md",
        "docs/adr/",
        "docs/runtime_systems/",
        "Dependency Direction",
        "Autoload Policy",
        "Architecture Change Policy",
    ],
    "docs/FOLDER_STRUCTURE.md": [
        "ASSET_PIPELINE.md",
        "PROJECT_VISION.md",
        "SKILL_LIFECYCLE.md",
        "ARCHITECTURE.md",
        "CODING_STANDARDS.md",
        "ROADMAP.md",
        "GLOSSARY.md",
        "docs/adr/",
    ],
    "docs/ROADMAP.md": [
        "Phase 1",
        "Current Status",
        "project structure validator",
        "Skill lifecycle",
    ],
    "docs/SKILL_LIFECYCLE.md": [
        "Definition Of Done For Reusable Systems",
        "Repo-Local Skills",
        "Shareable Skills",
        "promotion",
    ],
    "docs/ASSET_PIPELINE.md": [
        "Stage 1",
        "Blender is a required dependency",
        "game/assets/generated/pipeline_smoke/",
        "schema_version",
        "Stage 2",
        "Godot Import Validation",
    ],
    "docs/adr/README.md": [
        "0000-template.md",
        "0001-ai-first-godot-foundation-structure.md",
        "0002-first-runtime-system-contract-settings.md",
        "When To Write An ADR",
    ],
    "docs/runtime_systems/README.md": [
        "MMO Camera System Contract",
        "Settings System Contract",
        "Contracts are not implementations",
    ],
    "docs/runtime_systems/mmo_camera_system_contract.md": [
        "Purpose",
        "Responsibilities",
        "Non-Goals",
        "Camera Settings Resource",
        "Future Extension Seams",
        "Skill Requirement",
    ],
    "docs/runtime_systems/settings_system_contract.md": [
        "Purpose",
        "Responsibilities",
        "Non-Goals",
        "Public API Shape",
        "Testing Expectations",
        "Open Questions",
    ],
}

REQUIRED_GLOSSARY_TERMS = [
    "AI-First Foundation",
    "Foundation Phase",
    "Runtime System",
    "Runtime System Contract",
    "Asset Pipeline",
    "Import Report",
    "Validation",
    "ADR",
    "PRD",
    "Repo-Local Skill",
    "Shareable Skill",
    "Skill Lifecycle",
]

FOUNDATION_BOUNDARY_TERMS = [
    "create gameplay",
    "must not choose",
    "theme-neutral",
]


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _read(root: Path, relative_path: str) -> str:
    return (root / relative_path).read_text(encoding="utf-8")


def main() -> int:
    root = _repo_root()
    failures: list[str] = []

    for relative_path, required_snippets in REQUIRED_REFERENCES.items():
        path = root / relative_path
        if not path.is_file():
            failures.append(f"missing documentation file: {relative_path}")
            continue

        content = _read(root, relative_path)
        comparable_content = content.lower()
        for snippet in required_snippets:
            if snippet.lower() not in comparable_content:
                failures.append(f"{relative_path} does not reference '{snippet}'")

    glossary = root / "docs/GLOSSARY.md"
    if glossary.is_file():
        glossary_content = glossary.read_text(encoding="utf-8")
        comparable_glossary = glossary_content.lower()
        for term in REQUIRED_GLOSSARY_TERMS:
            if term.lower() not in comparable_glossary:
                failures.append(f"docs/GLOSSARY.md is missing term '{term}'")

    agents = root / "AGENTS.md"
    if agents.is_file():
        agents_content = agents.read_text(encoding="utf-8")
        comparable_agents = agents_content.lower()
        for term in FOUNDATION_BOUNDARY_TERMS:
            if term.lower() not in comparable_agents:
                failures.append(f"AGENTS.md is missing foundation boundary '{term}'")

    if failures:
        print("Documentation contract validation failed:")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print("Documentation contract validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
