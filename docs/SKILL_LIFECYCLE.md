# Skill Lifecycle

Reusable systems in this repository should produce reusable AI workflow knowledge.

Every reusable system is considered incomplete until it has at least a repo-local skill draft that captures how future agents should build, extend, validate, and adapt that system.

## Lifecycle

```text
contract -> implementation -> tests -> docs -> repo skill draft -> reuse/refine -> promote
```

## Repo-Local Skills

Repo-local skills live under `skills/`.

They are versioned with this repository and may reference local docs, ADRs, scripts, validators, and implementation details.

Repo-local skills are appropriate when:

- A reusable system or tool exists in this repository.
- The process for extending it is repeatable.
- Future agents need explicit context before modifying it.
- The skill still depends on project-specific docs or paths.

## Shareable Skills

Shareable skills live outside this repository in the user's global Codex skills folder or a separate distributable skill repository.

Promote a repo-local skill only after:

- The workflow has been used at least once.
- The skill has been refined from real use.
- Project-specific assumptions have been removed or clearly parameterized.
- Validation expectations are portable.
- Examples are safe to share.

## Required Repo-Local Skill Shape

```text
skills/<skill-name>/
  SKILL.md
  examples/
  references/
```

Only `SKILL.md` is required. The `examples/` and `references/` folders are reserved for supporting material when useful.

## Required `SKILL.md` Sections

Each repo-local skill must include:

- `name`
- `description`
- `when_to_use`
- `required_context`
- `workflow`
- `validation`
- `handoff_output`
- `promotion_notes`

## Definition Of Done For Reusable Systems

A reusable system is done only when:

- The system has an approved contract or ADR when appropriate.
- The implementation exists.
- Validation or tests prove the important behavior.
- Documentation explains the system.
- A repo-local skill draft exists.
- The skill explains when to use the workflow and how to validate changes.

## Promotion Notes

Repo-local skills should include notes about what must change before they are shared globally.

Examples:

- Replace repository-specific paths with placeholders.
- Remove project-specific issue links.
- Generalize validation commands.
- Add a portable example project.
- Confirm the workflow works in another repository.
