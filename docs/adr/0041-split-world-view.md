# ADR 0041: Split the world view script (M26.1)

Status: accepted (2026-10-13).

## Problem
`game/world/world_view.gd` had grown to 1285 lines. It held the map drawing, the unit markers, the hit and
swing effects, the turn replay and the static art helpers in one script. The audit (2026-10-08) asked for
files under about 500 lines, with no behaviour change.

## Decision
`WorldView` keeps its scene nodes, its state (`area`, `atlas`, `enemies`, `monster_facing`, `_last`, ...),
`setup`, `refresh` and `_process`. Four helpers take the rest:

- `ViewArt` (`world/view_art.gd`): static only. Cell size, sheet files, tile sets, object art, and small node
  makers (`square`, `rect`, `poly`, `add_label`, `region_sprite`, `tile_prop`). It never names `WorldView`.
- `ViewMap` (`world/view_map.gd`): the ground and edge tiles, map objects, tile props, signs and arrows, the
  crowd and the animated objects.
- `ViewMarkers` (`world/view_markers.gd`): NPCs, inn patrons, monsters, Frost Fairies, found traps, HP bars
  and the label rules (`labelled`).
- `ViewEffects` (`world/view_effects.gd`): the AnimDiff effects (`play`) and the turn replay.

`ViewMap`, `ViewMarkers` and `ViewEffects` are `RefCounted`. `WorldView` makes one of each and owns it. Each
holds the view in an **untyped** `_v`, as in ADR 0040, so there is no script cycle. The helpers use
`ViewArt` for shared art, not `WorldView`. `GroundArt`, `SignArt` and `CombatOverlay` (which the helpers
use) now name `ViewArt` too: while they named `WorldView`, a helper closed a script cycle and Godot reported
"resources still in use at exit".

Every public name other scripts and tests use stays on `WorldView`: the constants (`TILE`, `HOSTILE_EDGE`,
...) are copies of the helper constants, and the static functions (`cell_center`, `sheet_path`,
`object_look`, `labelled`, `state_edge`, ...) and `play`, `replay`, `skip_replay`, `is_replaying` pass on.
Tests did not change.

## Consequences
- `world_view.gd` is 335 lines. The largest helper is 345 lines.
- New map art goes in `ViewMap`, new unit markers in `ViewMarkers`, new effects in `ViewEffects`.
- Fairies bob on their own clock in `ViewMarkers` (before, they shared the object animation clock). The
  bob looks the same.
