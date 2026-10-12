# ADR 0038: NPC levels at low detail (M25.0)

Status: accepted (2026-10-12).

## Problem
DESIGN §4.5 says NPCs level and gain classes through the same System as the player, at low resolution. Until now a
canon NPC's classes were fixed data (`npcs.json` `"classes": [{"name", "level"}]`). 168 class entries exist on 144
NPCs; 140 of them have `"level": null` (not stated in the book). Only 57 of the names match a class id in
`classes.json`, so the player's tag-based class system cannot run on them as it is.

## Decision
`NpcLevels` (`game/core/npc_levels.gd`) grows canon NPC levels once a day. `Director.run` calls `NpcLevels.grow` after
each day's canon events, so it also runs for the days before the player arrives. No randomness.

- **Who:** a living canon NPC with at least one class. An NPC with no class never levels (Ryoka, Dragons, Erin until
  data gives her a class). An NPC of a later book starts on its book's first day (`CanonDb.book_start`: the earliest
  `window.earliest` of the book's events), so its canon level is right when it appears.
- **XP:** `rules.npc.levels.daily_xp` a day, plus `event_xp` on a day a canon event that happened (done, substituted,
  changed) cast the NPC by name (history roles; `*` fillers are nobody). The XP is split evenly between the NPC's
  classes: more classes, less XP each (the player's dilution, without tags).
- **Cost:** the player's curve. The next level of any class costs `Levels.xp_to_next(total level)` (M17.7). The total
  cap (`levels.total_cap`) holds. NPC total levels are never shown, like the player's.
- **Capstones** (10, 20, 30): a class waits under a capstone until it has a key. Being cast in a canon event while the
  class waits gives the key: the event is the test (the player's "hard moment", ADR 0035). XP keeps building while
  it waits.
- **Unknown levels:** a canon `null` level counts as `unknown_level`. The data keeps `null`; readers get
  `"known": false`, so a character sheet (M25.3) can show "?".
- **State:** `gs.world.npc_levels`: NPC id → {class name → {"gain", "xp", "key"?}}. Only the change from canon is
  saved; the base level comes from canon data. Save v21; the v20 → v21 migration adds an empty table, so an old save
  starts to grow from its next night.

First numbers (guesses, `rules.json` `npc.levels`): `unknown_level` 12, `daily_xp` 12, `event_xp` 50. A probe over
Books 1 – 6 (day 130) with 8 / 40 gave most NPCs 0 – 3 levels; with 20 / 60 about 70 % gained a level and the top
NPC 14. 12 / 50 sits between. Relc (total 57) never gains a level in that time; Pawn and Laken (low start, many
events) gain the most.

## Not done (later steps)
- NPCs do not gain new classes yet. A canon class gain needs an event effect (a schema change: ask first).
- NPC levels do not change NPC fight stats or skills yet.
- ~~Nothing shows NPC levels in play except the debug console.~~ M25.3 (2026-10-12): an NPC row "Appraise" opens the NPC's
  sheet (`core/npc_sheet.gd`, `NpcSheet.lines`) when the player holds the Skill named in `rules.npc.appraisal_skill`
  (`appraisal`, user pick). It lists the NPC's classes and levels; a canon `null` level shows `?`; the total is never shown.
  No time passes; no state is saved.

## Consequences
- Canon NPCs drift a little from their canon levels over time. That is emergent, not canon: no canon data changes.
- The director now writes `world.npc_levels` every day. Save files grow by about 140 small entries.
