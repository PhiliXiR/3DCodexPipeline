# Glossary

This glossary defines the shared language for the AI-first game development foundation. Keep terms generic unless a future approved game direction requires more specific vocabulary.

## Architecture Terms

### AI-First Foundation

A reusable Godot 4 project base designed so AI agents and humans can safely extend it over time. It prioritizes documentation, clear boundaries, automation, validation, and modularity.

### Foundation Phase

The current project phase. It establishes structure, documentation, conventions, and project organization before gameplay, theme, assets, or vertical slices are created.

### Framework

The reusable engineering layer that future games can build on. Framework code should avoid game-specific themes, content, lore, or mechanics.

### Game-Specific Content

Anything tied to a particular future game direction, such as levels, characters, quests, enemies, items, story, theme, or genre-specific behavior.

### Runtime System

A reusable Godot system that runs in the game project, such as input, interaction, inventory, dialogue, saving, audio, settings, UI, camera, or NPC behavior.

### Runtime System Contract

A document that defines a reusable runtime system before implementation. It should describe responsibilities, non-goals, API shape, integration points, testing expectations, and open questions.

### Editor Tool

A Godot editor plugin or workflow helper used to make development faster and more reliable. Examples include scatter tools, scene validators, import helpers, road tools, and navigation helpers.

### Asset Pipeline

The repeatable process for taking source assets through processing, validation, import, and Godot-ready output.

### Validation

Automated checks that verify project structure, assets, scenes, data, or documentation conform to repository expectations.

### Import Report

A generated record describing what an import or processing tool did, including warnings, errors, transformed files, naming changes, and validation results.

## Godot Terms

### Scene

A Godot `.tscn` unit composed of nodes. Scenes should be small, focused, reusable, and free of genre-specific assumptions during the foundation phase.

### Node

The basic building block of Godot scene trees. Nodes should be composed into focused scenes rather than hidden behind broad manager objects.

### Resource

A Godot data object used for reusable configuration or content definitions. Resources are preferred when data should be editable in Godot and shared across systems.

### Autoload

A Godot script or scene registered as globally available. Autoloads should be rare and reserved for stable global services with small APIs.

### Signal

Godot's event mechanism for decoupled communication. Signals should carry minimal typed payloads and avoid forcing systems to know each other's internals.

### MMO Camera Mode

A camera integration mode where the camera orbits independently and a future character system rotates the character toward movement direction.

### Action Camera Mode

A camera integration mode where a future character system may rotate the character toward the camera's planar forward direction.

### Mode Output Adapter

A camera component that exposes read-only camera mode and direction data to future character systems without implementing character movement, animation, or physics.

### Character Movement System

A reusable movement runtime system built around neutral `CharacterBody3D` movement, camera-relative WASD input, gravity, floor collision, and configurable facing behavior.

### Neutral Character Proxy

A simple capsule or generic visual marker used to validate movement before final character assets, rigs, and animations are introduced.

### Playable Validation Scene

A neutral scene that combines reusable systems so a developer can manually verify behavior without introducing game-specific levels, mechanics, or theme.

## Tooling Terms

### Blender Automation

Scripts and workflows that use Blender to process assets before Godot import, such as transform normalization, object renaming, collision generation, GLB export, and report generation.

### Godot Helper Script

A script used to automate Godot project tasks from outside normal runtime gameplay, usually through command-line Godot execution.

### Importer

A tool that coordinates source assets, processing steps, output placement, import metadata, and reporting.

### Validator

A tool that checks whether files, folders, assets, scenes, or data meet project rules.

## Collaboration Terms

### Creative Director

The human role responsible for creative direction, feel, theme, game design, and approval of major project direction.

### Technical Lead

The human role responsible for architecture approval, feature approval, and final technical direction.

### AI Agent

An AI collaborator that may modify code, documentation, tests, tooling, and architecture within the project constraints.

### Repo-Local Skill

A reusable AI workflow stored in this repository under `skills/`. Repo-local skills may reference project-specific docs, ADRs, scripts, validators, and implementation details.

### Shareable Skill

A generalized reusable AI workflow promoted outside this repository after it has been used, refined, and stripped of unnecessary project-specific assumptions.

### Skill Lifecycle

The process for turning reusable system work into reusable AI guidance: contract, implementation, tests, docs, repo skill draft, reuse/refine, and promotion.

### ADR

An Architecture Decision Record. ADRs document important technical decisions, their context, the chosen approach, alternatives, and consequences.

### PRD

A Product Requirements Document. PRDs describe the user-facing or project-facing problem, solution, user stories, implementation decisions, testing decisions, and out-of-scope boundaries.
