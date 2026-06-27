# Settings System Contract

## Status

Approved foundation contract. Not implemented yet.

## Purpose

The Settings System provides a reusable, game-neutral way to define, load, validate, apply, and persist user-configurable settings.

It is the first runtime system contract because settings are broadly useful across future games and do not require choosing a genre, theme, player model, camera style, world structure, or gameplay loop.

## Responsibilities

The Settings System is responsible for:

- Defining supported settings through data.
- Loading saved settings.
- Validating setting values against definitions.
- Applying settings to approved engine or project targets.
- Saving changed settings.
- Emitting typed events when settings change.
- Providing reset-to-default behavior.
- Reporting invalid or unknown settings clearly.

## Non-Goals

The Settings System must not:

- Define game feel.
- Choose input bindings for a specific game.
- Implement graphics presets tied to a particular art direction.
- Create menus, HUDs, or UI screens.
- Own audio playback, rendering, input, save-game data, or localization systems.
- Become a generic global manager.

## Data Model

Settings should be defined through data, not hardcoded branches.

A future implementation should support a definition shape equivalent to:

```text
setting id
display category
value type
default value
allowed range or options
apply target
persistence behavior
restart requirement
```

Godot `Resource` classes are the preferred definition format when editor support matters. External data files may be considered later if bulk editing or external tooling becomes more important.

## Initial Setting Categories

Allowed generic categories:

- Display.
- Audio.
- Input.
- Accessibility.
- Gameplay-neutral preferences.

These categories are organizational only. They do not approve game-specific settings.

## Public API Shape

The future implementation should expose a small API equivalent to:

```text
load_settings()
save_settings()
get_value(setting_id)
set_value(setting_id, value)
reset_value(setting_id)
reset_all()
get_definition(setting_id)
get_all_definitions()
```

APIs should return clear success/failure information when setting IDs are unknown or values are invalid.

## Events

The system should emit typed signals equivalent to:

```text
setting_changed(setting_id, old_value, new_value)
setting_apply_failed(setting_id, reason)
settings_loaded()
settings_saved()
settings_reset()
```

Signal payloads should remain minimal and should not expose internal storage details.

## Integration Points

The Settings System may integrate with:

- Godot project settings.
- Audio buses.
- Display/window configuration.
- Input map configuration.
- Accessibility preferences.
- Future save or profile storage.

Each integration should be isolated behind a narrow adapter so the core settings model does not depend directly on unrelated systems.

## Persistence

Persistence should be explicit and replaceable.

The first implementation may use a simple local file, but storage should be wrapped so future profile, cloud, or save-slot behavior can be introduced without rewriting setting definitions.

## Autoload Decision

The Settings System is a candidate for autoload registration only after implementation proves the API is stable and narrow.

Before becoming an autoload, it should be usable through explicit scene composition or direct construction in tests.

## Testing Expectations

Tests should cover:

- Loading defaults.
- Rejecting unknown setting IDs.
- Rejecting invalid values.
- Applying valid changes.
- Emitting change events.
- Saving and loading persisted values.
- Resetting one setting.
- Resetting all settings.

Tests should focus on public behavior and data contracts, not private storage implementation.

## Documentation Expectations

When implemented, the Settings System should include:

- A system README.
- Setting definition examples.
- Persistence behavior notes.
- Adapter documentation for engine integration points.
- Tests or validators for setting definitions.

## Open Questions

- Which test framework should be used for GDScript runtime tests?
- Should the first implementation use Godot `Resource` definitions immediately, or start with a simpler script-local schema?
- Should settings storage live under user config, project-specific save data, or a replaceable storage adapter from the beginning?
