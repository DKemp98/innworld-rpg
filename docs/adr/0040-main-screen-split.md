# ADR 0040: Split the game screen script (M26.0)

Status: accepted (2026-10-13).

## Problem
`game/world/main.gd` had grown to 967 lines. It held key and mouse input, combat aiming, the long-road prompt,
the panels, the commands and the turn replay in one script. The audit (2026-10-08) asked for files under about
500 lines, with no behaviour change.

## Decision
`main.gd` gets `class_name MainScreen` and keeps the commands (step, use, block, throw, cast, sleep, ...) and the
turn replay. Four helpers, each a `RefCounted` that `MainScreen._ready` makes and owns, take the rest:

- `MainInput` (`world/main_input.gd`): key presses, held direction keys, the mouse in a fight.
- `MainAim` (`world/main_aim.gd`): the armed Skill or spell, a click's walk, the touch tap, the turn overlay and
  the plan under the mouse.
- `MainTravel` (`world/main_travel.gd`): the long-road prompt (`prompt` is the `TravelPrompt` node; `main.travel`
  still points to it).
- `MainPanels` (`world/main_panels.gd`): which panel has the keyboard (`is_busy`), the console, the use menu and
  the bag, the touch pad and UI scale, the message history, the night pages and the morning autosave.

Every member the tests and other scripts use stays on `MainScreen` (`step`, `click`, `tap`, `hover`, `cancel`,
`is_busy`, `armed_skill`, `_walking`, `toggle_console`, `open_use_menu`, `travel`, ...). These calls pass on to
the helper. Tests did not change.

The helpers hold the screen in an **untyped** `_m`. A typed `_m: MainScreen` makes a script cycle
(MainScreen → helper → MainScreen); Godot then keeps the scripts alive at exit ("resources still in use").
`MainScreen` does name the helper classes (one direction only).

## Why not child nodes
Helpers as nodes would need scene changes and `_process` order rules. `RefCounted` helpers need no scene change
and free with the screen.

## Consequences
- `main.gd` is 499 lines. New input or panel work goes in the helper that owns it.
- A helper reaches the screen's nodes through `_m` (dynamic access: no type check at parse time there).
