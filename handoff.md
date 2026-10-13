# Handoff

## Just done (2026-10-13, local): M26.0 split `main.gd` (branch `refactor/m26.0-split-main`)
- No behaviour change. `game/world/main.gd` 967 -> 499 lines, now `class_name MainScreen`: commands + turn replay.
- New RefCounted helpers (made in `MainScreen._ready`): `main_input.gd` `MainInput` (keys, held direction, mouse),
  `main_aim.gd` `MainAim` (armed Skill/spell, click walk, tap, turn overlay + plan), `main_travel.gd` `MainTravel`
  (long-road prompt; `main.travel` = `road.prompt`), `main_panels.gd` `MainPanels` (is_busy, console, use menu, bag,
  touch pad, UI scale, history, night pages, morning autosave). ADR 0040.
- Public members tests use stay on MainScreen as pass-on calls (`step`, `click`, `tap`, `hover`, `cancel`, `is_busy`,
  `armed_skill`, `_walking`, `toggle_console`, `open_use_menu`, ...). No test changed.
- Tests: the 20 scripts listed in `progress.md` M26 line, all pass. Full suite not run.
- Next: user merges the PR. Then M26.1 split `world_view.gd` (1285 lines) **[Opus · medium]**.
- Gotchas: helpers keep the screen in an UNTYPED `_m`. A typed `_m: MainScreen` makes a script cycle and Godot
  reports "N resources still in use at exit". Values read from `_m` need explicit types (`:=` cannot infer).
  "ObjectDB instances leaked" warnings at exit come and go between runs: audio streams still playing (not ours).
  New `class_name` needs `godot --headless --path game --import`.

## Just done (2026-10-12, local): M25.4 Magnolia's whereabouts (branch `feat/m25.4-magnolia-whereabouts`)
- Data only, existing behaviour schema (`when_flags` / `unless_flags`). No save change, no engine change, no ADR.
- `game/data/npc_behaviour.json`: Magnolia and Ressa get base-5 goals that beat the estate goals:
  `@celum` until `magnolia.gone_north` (1.63); `@north_izril` (the road) until `magnolia.watches_the_inn` (2.06);
  the estate after; `@north_izril` again (away) from `magnolia.gone_to_first_landing` (3.14) until
  `magnolia.sends_gold_to_esthelm` (4.38B). No map exists for her Celum house or First Landing, so those are off map.
- New behaviour for the Earthers Rose (hall 5,7), Imani (hall 14,7), Joseph (grounds 22,12): seen by day from
  `magnolia.hides_other_earthers` (2.23, day 49), else inside the estate (off map). Spots and hours are guesses.
  They use the generic human look (no own sprite).
- Tests: `unit_m25_whereabouts` (new, 5) + the list in `progress.md`. All pass. Full suite not run.
- M25 is all ticked: moved to Done in `docs/ROADMAP.md`. Next: user merges the PR. Then M26.0 split `main.gd` **[Opus · medium]**.
- Gotchas: on the road an NPC walking between off-map places shows up on a map along the way if the player is there
  (normal NpcSim). The user has not seen this in play. Own looks for the 3 Earthers would need `tools/build_sprites.py`.

## Just done (2026-10-12, local): M25.3 NPC sheets (branch `feat/m25.3-npc-sheets`)
- User pick: sheets need the Skill [Appraisal]. New `core/npc_sheet.gd` (`NpcSheet.can_read`, `NpcSheet.lines`): name, race,
  classes with level (`?` when canon level is null), never a total. Works for every canon NPC (Merec, Raisha, Ressa, Reynold, Magnolia, golems incl.).
- `Interact.options` NPC rows get `"appraise"`; `Interact.APPRAISE`; menu row "Appraise" (`ui/interact_menu.gd`);
  `main.use` opens `CharacterSheet.open_lines`. New rule `rules.npc.appraisal_skill: "appraisal"` (additive). No save change, no time cost.
- [Appraisal] is an uncommon merchant Skill (class pool level 4 - 15), so a player must be a merchant to get it.
- Tests: `unit_npc_sheet` (new, 6), plus the list in `progress.md`. Full suite not run.
- Next: user merges the PR. Then M25.4 Magnolia's whereabouts **[Opus · medium]**.
- Gotchas: `WorldState.is_alive(canon, npc)` takes the canon db. New `class_name` needs `--import`. The user has not tried the row in play (needs `skill appraisal` or a merchant).

## Just done (2026-10-12, local): M25.2 job boards (branch `feat/m25.2-job-boards`)
- Data only. Actions `take_guild_job` (120 min, pay 6-12), `tally_ledgers` (60 min, 4-8), `haul_goods` (60 min, 3-5) in
  `actions.json`, `economy.json` jobs, `audio.json` (sound `coins`). Pay and tags are guesses.
- Boards: `liscor_adventurers_guild/job_board` (take_guild_job), `invrisil_merchants_guild/contract_board` (new, tally_ledgers),
  `invrisil_square/invrisil_notice` and `celum_square/celum_job_board` (new, haul_goods). Celum has no Merchants' Guild map, so its board is on the square.
- New test `unit_m25_job_boards` (3). Other tests: see `progress.md` M25 line. Validator 0 errors. Full suite not run.
- Next: user merges the PR. Then M25.3 character sheets **[Sonnet · medium]**.
- Gotchas: patch CRLF data files with Python on bytes. The user has not walked to the new boards.

## Just done (2026-10-12, local): M25.1 talk topics (branch `feat/m25.1-talk-topics`)
- User picked "hints only": requests are hint lines, no state, no reward, no save change. ADR 0039.
- New `game/core/talk_topics.gd` (`TalkTopics`). `Interact.perform` adds one line after the greeting on the first
  talk of the day (`NpcSim.note_talk` true): `rules.talk.line` = `Name: "text"`.
- Pool: news of the last `news_days` (5) days: `own` (event cast the NPC), `town` (event location in the NPC's town,
  from canon `home`), T1 `rumor`; plus `game/data/talk.json` topics (`news`/`rumor` → "topic", `request`). Weighted
  pick with `gs.rng` (weights own 4, town 3, rumor 2, topic 2, request 1). Regard under `min_regard` (0) = no line.
- `talk.json` schema v1: id → {kind, text, confidence, who {npcs, tags, towns}?, flags?, not_flags?, days?,
  canon_ref?, note?}. 11 canon topics (Books 1 - 2; chapter refs from the event that sets the flag) and 6 request
  hints (`confidence: guess`). Loaded and validated in `DataDb.load_dir`; `db.talk`.
- `Standing.town_of_location(db, loc)` split out of `town_of`.
- `ToyData.db()` erases `rules.talk` (toy rules copy the real ones; otherwise toy talks would roll RNG).
- Tests (all pass): `unit_talk_topics` (new, 6), `unit_standing`, `unit_data_db`, `unit_npc_sim`, and the 27 sims
  that talk through Interact (sim_book3_* … sim_book7_*, sim_esthelm_siege, sim_npc_day, sim_balance_progress);
  validator book1 0 errors; Python 116 OK. Full suite not run.
- Next: user merges the PR. Then M25.2 job boards **[Sonnet · medium]** (real requests could join there).
- Gotchas: a talk with a canon NPC now uses one RNG roll when its pool is not empty. Topics can repeat on later
  days (no state). Books 3+ have event news but no talk.json topics yet. `rules.json`, `standing.gd`,
  `interact.gd`, `data_db.gd` are CRLF: patch with Python, keep CRLF.

## Just done (2026-10-12, local): roadmap tidy
- `docs/ROADMAP.md`: M24 (all ticked) moved from Next up to the top of Done; order line now M25 → M26;
  outside PR #164 noted under Later. Docs only, no tests run.

## Just done (2026-10-12, local): M25.0 NPC levels (branch `feat/m25.0-npc-levels`)
- ADR 0038. New `game/core/npc_levels.gd` (`NpcLevels`). `Director.run` calls `NpcLevels.grow(gs, db, day)` after each
  day's events (also the days before the player arrives).
- Each living canon NPC with classes gets `rules.npc.levels.daily_xp` (12) a day, plus `event_xp` (50) on a day a
  canon event that happened cast them by name. XP is split evenly between the NPC's classes. Cost = the player's
  curve on the NPC's total level (`Levels.xp_to_next`), total cap holds. Capstones need a key: being cast in an
  event one level under a capstone gives it. Canon `null` level = `unknown_level` (12), shown as `known: false`.
- NPCs with no class never grow (Ryoka, Dragon, Erin). A later-book NPC starts on its book's first day
  (`CanonDb.book_start` / `first_day_of`, from event rank + window).
- State: `gs.world.npc_levels` npc → {class name → {gain, xp, key?}}. Save v21; migration adds `{}`.
- Debug console: `npclevels <npc>`. No UI yet (M25.3 sheets read `NpcLevels.classes_of`).
- Probe over Books 1 - 6 (day 129): 119 NPCs tracked, 73 grew, top +12 (Pawn, Laken). Relc never grows (total 57).
- Tests run (all pass): `unit_npc_levels` (new, 12), `sim_npc_levels` (new, 6), `unit_game_state`, `unit_mana`
  (removed the `SAVE_VERSION == 20` pin), `unit_director`, `unit_canon_db`, `unit_console`, `unit_save_slots`,
  `sim_canon_book1`; validator book1 0 errors. Full suite not run.
- Next: user merges the PR. Then M25.1 talk topics **[Opus · medium]**.
- Gotchas: a new `class_name` needs `godot --headless --path game --import` before a `-s` script sees it. The import
  touches ~290 `.import` files (stat only): `git update-index -q --refresh` clears them. Not done: NPCs gain no new
  classes (needs an event effect = schema change, ask first); NPC levels do not change fight stats.

## Just done (2026-10-12, local): review of outside PR #164 (DKemp98, "Expanded Skills, Classes and Sundry")
- Review only. No code changed, nothing committed, no comment posted on the PR.
- Findings: PR is based on main before M23.5 (23 commits behind) and conflicts. `classes.json` and `skills.json`
  are rewritten flat (no `schema_version`, no `classes`/`skills` wrapper), so `DataDb` loads 0 classes and 0 skills.
  One-item lists became strings (`excludes` null, `neglect_tags`, `tags`, trial `action`/`outcome`). Number
  ranges (`heal` [8,15], yields [1,3], `base_stats` [2,4]) break `int()` reads in economy.gd, monster_sim.gd, spells.gd
  and have no RNG code. `grill_meat`/`make_pastry` have no recipe, so they make no food. It drops 4 skills
  (`steady_seat`, `keen_draw`, `forge_arms`, `patient_voice`) and would wipe the 63 M24.3 rare skills. 210 of 216 new
  skills have no effect. No tests.
- User picked option 1 (ask for changes). Reply text drafted in chat; the user posts it. Next: wait for the rebased, split PRs.

## Just done (2026-10-11, local): Google Play prep (branch `feat/play-store-prep`)
- User asked to prepare a Google Play release. User picks: build now, upload only after pirateaba says yes in
  writing; Gradle template gitignored. ADR 0037, guide `docs/PLAY_STORE.md`, `PRIVACY.md`.
- Preset `Android Play` (preset.4): Gradle, AAB, target SDK 36, arm64. `tools/release.ps1` builds
  `export/InnworldRPG-v<version>-play.aab` after the apk; `-PlayOnly` builds only the aab.
- `python tools/build_store_art.py` makes `export/play/` (feature graphic, 32-bit icon, 2x screenshots) from `export/itch/`.
- Checked: AAB 88 MB, jarsigner ok, release-key SHA256 1A:13:D3..., merged manifest versionCode 3, min 29,
  target 36, no permissions. Python tests 116 OK. No GUT run (no game code changed). Full suite not run.
- Next: user merges the PR; user asks pirateaba; user makes the Play account. Then internal test. Then M25.0.
- Gotchas:
  - Gradle needs `GRADLE_OPTS='-Xmx2g -Dorg.gradle.daemon=false -Dorg.gradle.jvmargs=-Xmx2g'` (set by release.ps1).
    The template's 4.5 GB daemon crashed (out of memory, 16 GB PC); a daemon also keeps Godot's output open, so
    the script never ends; with no daemon the build runs in the 64 MB client unless `-Xmx2g`.
  - PowerShell: `$x = if (...) { @('a') } else { @() }` unrolls to a string; splatting `@x` then drops it.
  - Godot's headless import crashes at random on `PixelOperator-Bold.ttf` (0xC0000005). Run `--import` again.
  - Godot 4.7 writes `screenOrientation="fullUser"` in the manifest (apk too) and sets landscape at run time.
  - API 36 ignores the landscape lock on screens 600 dp and up: tablet check is open.
  - An export rewrites `game/project.godot` and `game/icon.png.import` (order only): `git checkout --` them.

## Just done (2026-10-11, local): M24.3 skills (branch `feat/m24.3-skills`)
- Data only. 63 rare Skills appended to `game/data/skills.json`: every class in `classes.json` now has a rare Skill for its level 10 capstone (pool 10 - 30) and a second for level 20 (pool 20 - 30). Capstone levels always pick a rare Skill first (`SkillSystem.grant_random(..., prefer_rare)`), so no class falls back to a common one at 10 or 20. Four are combat actions: `crushing_blow` (veteran_warrior), `lance_strike` (knight), `backstab` (assassin), `trampling_charge` (dragoon, area). The rest are passive `stat_mod` / `xp_mult`. Names and numbers are guesses (`confidence: guess`).
- Level 30 is not covered for every class (only the 10 - 30 skill and the 20 - 30 skill exist; level 30 falls back to any Skill).
- Tests run (pass): `unit_m24_skills` (new, 3), `unit_data_db`, `unit_class_tree_step2`, `unit_skill_system`, `unit_combat_skills`, `unit_class_system`, `unit_levels`, `unit_stats`, `unit_night`, `unit_breakthrough`, `unit_mana`, `unit_journal`, `unit_class_tree_step3`; validator 0 errors. Full suite not run.
- M24 is done. Next: M25.0 NPC levels **[Opus · high]** (DESIGN section 4.5; save change + migration).
- Gotchas: the patch script (`scratchpad/gen_m243.py`) is gone next session. `skills.json` is CRLF with one-line sub-objects; new entries were appended on bytes before the final `}` `}`. Never `sed -i` a CRLF file (it did strip `docs/ROADMAP.md`; restored with Python).

## Just done (2026-10-11, local): M24.2 spells (branch `feat/m24.2-spells`)
- Data only. New spell `gust` (line, Pisces teaches after `b1.pisces_saves_erin_from_flies`). Spellbooks `spellbook_gust`, `_ice_spike`, `_flashfire`, `_frozen_wind` (each spell's `learn.book`), `spellbook_fireball` now costs 320. Shop `liscor_mages_guild` on object `spell_shelf` ([10,2], liscor_mages_guild). Pisces' NPC spell list: `frozen_wind` first, then `gust` (the NPC picks the first ready spell). Prices are guesses.
- Not added: [Ice Wall], [Barrier of Air], [Mend], [Light] are canon but the spell shapes are attack-only (`one`, `line`, `blast`, `around`). They need an engine step (utility / defence shapes).
- Tests run (pass): `unit_m24_spells` (new, 4), `unit_spell_learning`, `unit_spells`, `unit_spell_ui`, `unit_economy`, `unit_map_db`, `unit_ground_art`, `unit_data_db`, `unit_behaviour_db`, `unit_npc_sim`; validator 0 errors. Full suite not run.
- Next: M24.3 skills **[Sonnet · high]**.

## Just done (2026-10-11, local): M24.1 recipes and goods (branch `feat/m24.1-recipes-goods`)
- Data only. Recipes `pizza` (flour+vegetables+meat -> 2, stove, confidence likely: pizza is in 2.31), `roast_meat`, `vegetable_soup` (stove or campfire); actions `bake_pizza`, `roast_meat`, `cook_vegetable_soup` (sound `cook`); goods and items `wooden_club`, `iron_dagger`, `hand_axe`; shop `liscor_smith` on object `smith_counter` (liscor_market [3,8]). Inn stove and road camp campfire got the new actions; the three are in `rules.json` `inn_work_actions`. All numbers are guesses.
- Tests run (pass): `unit_m24_goods` (new, 3), `unit_cooking` (recipe count 7), `unit_world_view` (stove menu now 8 entries), and the list in `progress.md`. Full suite not run.
- Next: M24.2 spells **[Sonnet · medium]**.
- Gotchas: a new stove action lengthens the use menu; `unit_world_view` counts it. `GameState.new_game` needs `(seed, db, start)`.

## Just done (2026-10-11, local): M24.0 class actions (branch `feat/m24.0-class-actions`)
- Data only. Actions `hunt`, `shoot_bow`, `brew_potion`, `forge_tool`, `teach_lesson` in `game/data/actions.json` (tags copy each class's weights; `hunt` has cold duress). Sounds in `audio.json` reuse `pick_up`, `swing`, `water`, `hammer`, `book`.
- Map objects on existing art: `hunting_blind` (floodplains_south [9,23], kind reeds), `archery_target` (inn_hill [28,14], dead_tree), `brewing_cauldron` (liscor_mages_guild [3,6], brazier), `smiths_forge` (liscor_market [4,9], hearth), `lesson_slate` (inn_interior [2,8], papers). Positions and numbers are guesses.
- New test `unit_class_actions` (3). Tests run (pass): that, `unit_class_tree_step2`, `_step3`, `unit_actions`, `unit_tags`, `unit_audio_data`, `unit_sound_cues`, `unit_map_db`, `unit_ground_art`, `unit_world_view`, `unit_gated_exits`; validator 0 errors; Python 114 OK. Full suite not run.
- Roadmap: M23 moved to Done; At a glance now starts with M24.
- Next: M24.1 recipes and goods **[Sonnet · medium]**.
- Gotchas: a map object must not sit under a map overlay (the `flood` overlay on floodplains_south covers most free grass: the only free grass is (9,23), (8,23), (31,11), (31,12)). `map_db` logs "covers an exit or an object" for it. The user has not walked to the new objects yet.

## Just done (2026-10-11, local): M23.7 drift warning
- Journal drift line and one-time warning page already existed. Added `SystemMessages.DRIFT_REMINDER` on the Morning page every day while drift >= `unreliable_at`.
- Tests run (pass): `unit_system_messages` (18), `unit_journal`, `unit_director`. Full suite not run.
- Next: M24.0 **[Sonnet · medium]**. M23 is done.

## Just done (2026-10-11, local): M23.6 Book 7 canon bends (branch `feat/m23.6-book7-bends`)
- ADR 0036 "Book 7" lists every change. Data only (21 Book 7 chapter files), no engine change.
- Book 7 had almost no `depends_on` and no flag checks, so most scenes ran with their cause gone (Pallass soldiers
  crossed a door that was never set, Pisces saved Selys from a kidnap that never happened, Magnolia's letter came
  from a dead Magnolia, the Redfang five stayed at the inn after a Book 6 alt sent them north). They now wait on
  real-cause flags. The rain (`izril.rains`) and flood (`izril.flood`) no longer need Erin.
- Book 7 lost on a day-130 death: Erin 38 → 51, Selys 18 → 25 (more: real causes), Zevara 17 → 5 (3 stand-ins,
  optional in 8 scenes), Laken 26, Rags 14, Magnolia 0 → 12, Kerrig 5 → 3. Erin dead on day 114: Book 7 38 → 64.
  The user has not seen this trade yet: say it plainly in the PR.
- New `game/tests/sim_kill_book7.gd` (10): kills Erin, Laken, Selys, Zevara, Rags, Magnolia, Kerrig on day 130;
  hook-per-day (14 days); sweeping at the inn broom on day 136 changes the fire scene.
- Changed old tests: `sim_book7_goblin_road` (alt events left out of the 5.19G – 5.20G count), `sim_player_hooks` (128).
- Tests run (all pass): `sim_kill_book7`, `sim_kill_book2..6`, `sim_canon_book7`, `sim_book7_*` (8), `sim_player_hooks`,
  `unit_rains`, `unit_canon_db`, `unit_event_order`, `sim_divergence`; validator 0 / 0 on Books 1 – 7; Python 114 OK.
  Full suite not run. `docs/divergence/report.md` regenerated.
- Next: M23.7 drift warning **[Sonnet · medium]** (journal + morning page say canon knowledge is unreliable at high
  drift, DESIGN §4.1). Then M24.
- Gotchas: Book 7 chapter files round-trip exactly (`json.dumps(indent="	", ensure_ascii=False)` + "
", CRLF).
  The patch script was `scratchpad/patch_m236.py` (helpers `req_flags`, `optional`, `required`, `substitute`,
  `mutate`, `set_dep`, `add_sets`, `add_alt`, `add_hook`); gone next session. Probe: `game/_scratch/probe.gd`
  (`extends SceneTree`; env BOOK, KILL_DAY, END_DAY, VICTIMS comma list with `+`, LIST=1, FRESH=1 rebuilds the
  cached base in `user://probe_base_<day>.json`); deleted, rebuild it. A substitute never picks an NPC who is
  already cast in the same event (an optional role counts): Tekshia cannot stand in for Zevara at the funeral
  because she is already there, so there Zevara is optional instead. The older kill sims stop at their book's
  last day, so later-book losses do not show in their drift. Open: a Zel killed in Book 6 still gets the Book 7
  casket with the Heartflame on him.

## Just done (2026-10-11, local): M23.5 Book 6 canon bends (branch `feat/m23.5-book6-bends`)
- ADR 0036 "Book 6" lists every change. Data only (15 Book 6 chapter files + 3 object actions on `maps/riverfarm.json`),
  no engine change.
- Book 6 had scenes with no link to their cause: the Battle of Invrisil ran with Zel dead, the trap ran with no
  battle, the Redfang moved into the inn with Erin dead. They now wait on real-cause flags. So Zel / Magnolia /
  Goblin Lord / Erin deaths lose MORE events than before (25 → 35, 17 → 36, 16 → 27, 14 → 22); Olesm 13 → 7, Oom 9 → 1.
  The user has not seen this trade yet: say it plainly in the PR.
- New `game/tests/sim_kill_book6.gd` (9): kills Zel, Magnolia, the Goblin Lord, Erin, Olesm, Oom + Venitra on day 114;
  hook-per-day (15 days); chopping wood at the Riverfarm trebuchet frame on day 118 changes that day. Copy it for Book 7.
- Changed old tests: `sim_kill_book5` (Erin's drift ceiling 31 → 33.5: her Book 6 days 114 – 115 now need her),
  `sim_player_hooks` count 123, `sim_book6_world` (stale assert: Dasha has her own look since 4dce883; was red on main).
- Tests run (all pass): `sim_kill_book6`, `sim_kill_book5`, `sim_canon_book6`, `sim_canon_book7`, `sim_book6_*` (7),
  `sim_player_hooks`, `unit_canon_db`, `sim_divergence`, `unit_event_order`, `unit_map_db`, `unit_north_road`,
  `sim_book7_riverfarm`; validator 0 / 0 on Books 1 – 7; Python 114 OK. Full suite not run.
  `docs/divergence/report.md` regenerated.
- Next: M23.6 Book 7 **[Opus · high]**. Picks: Erin, Laken, Selys, Zevara, Rags; key events in `docs/divergence/picks.md`.
- Gotchas: Book 6 chapter files round-trip exactly through `json.load` / `json.dumps(indent="	", ensure_ascii=False)`
  + "
", written with CRLF, so a plain load-edit-dump patch is safe (check Book 7 the same way first). The patch
  script was `scratchpad/patch_m235.py` (helpers `req_flags`, `req_alive`, `required`, `optional`, `on_fail`,
  `set_dep`, `add_alt`, `add_hook`); gone next session. Probe: `game/_scratch/probe.gd` (`extends SceneTree`, env
  BOOK, KILL_DAY, END_DAY, VICTIMS comma list with `+`, LIST=1; `Director.run` to KILL_DAY - 1, `set_alive`, run to
  END_DAY, print lost / alts / substitutes); 10 victims in ~30 s; deleted, rebuild it. Look for the OPPOSITE problem
  too: scenes whose roles are all optional, or that never check a flag, run with their cause gone. Map objects with
  `"actions": []` mean only NPC talk works there: a hook there needs `talk_with_guest` / `comfort_someone` / `persuade`.
  `riverfarm.json` has one-line exits: edit the action lists by text, not by a JSON dump.

## Just done (2026-10-11): ROADMAP.md reorganised (branch `docs/roadmap-reorg`)
- Order now: At a glance → Next up (M23 – M26) → Waits on the user (M20 touch-screen PC, keystore backup, ask
  pirateaba) → Later → Releases (v0.1.0 – v0.1.4) → Done (M21 at the top, then M22, M19 … M0).
- M20 phone check ticked from the M21.6 play pass. Nothing lost (old file: 170 ticked / 15 open; new: 173 / 17).
- Next: M23.5 Book 6 **[Opus · high]**. Picks in `docs/divergence/picks.md`.

## Just done (2026-10-11, local): M23.4 Book 5 canon bends (branch `feat/m23.4-book5-bends`)
- ADR 0036 "Book 5" lists every change. Data only (13 Book 5 chapter files), no engine change.
- New `game/tests/sim_kill_book5.gd` (10): kills Ryoka, Erin, Laken, Venitra, Lyonette on day 97 and Ken, Quallet
  on day 78 (second base save for the Baleros thread); hook-per-day (16 days); washing up on day 103 changes the
  new staff's first day. Copy it for Book 6.
- Changed old tests: `sim_canon_book5` (no Ryoka: Erin pays for the build; no Venitra: the Word of Death still
  falls), `sim_book5_geneva` (alt events left out of the arc list; no Ken: the Red Cross is still founded),
  `sim_player_hooks` count 114.
- Tests run (all pass): `sim_kill_book5`, `sim_canon_book5..7`, `sim_book5_*` (7 scripts), `sim_player_hooks`,
  `unit_canon_db`, `sim_divergence`, `sim_kill_book4`; validator 0 / 0 on Books 1 – 7; Python 114 OK. Full suite
  not run. `docs/divergence/report.md` regenerated.
- Next: M23.5 Book 6 **[Opus · high]**. Picks in `docs/divergence/picks.md`.
- Gotchas: Book 5 chapter files are fully expanded JSON (tab indent, CRLF), but 4.06KM and 4.07 mix in one-line
  objects. The patch helper kept each untouched event's original text and dumped only changed events (split on
  `		"b5.<id>": {` ... `
		}`). The M23.0 report counts `depends_on` only; Book 5 chains run on flags, so
  measure with a director run: a scratch `extends SceneTree` script (`GameState.new_game`, `Director.run` to the
  day before, `gs.world.set_alive(npc, false)`, `Director.run` to the end, count `b<N>.` events that are not
  happened and not alt-only). A script error in a `-s` script hangs Godot (no quit): kill it by command line.
  An alt event that replaces a revival needs the `revive` effect too.

## Just done (2026-10-11): M21.6 closed, journal focus picker removed (branch `fix/journal-no-focus-picker`)
- The user played every open check: all fine. M21.6 and M21 are ticked.
- Journal: the Focus list, its hint line and the "Focus:" line are gone (`ui/journal.gd`, `journal.tscn`, `main.gd`). `focus_choices`, `focus_name`, `main_tags` stay (character sheet, console, tests). Focus still works through the console `focus` command.
- Tests run (pass): `unit_journal` (7), `unit_touch_controls` (18; the tap test now uses its own ItemList), `unit_character_sheet`. Full suite not run.
- Next: M23.4 Book 5 **[Opus · high]**. Optional: console `skip <days>` command (offered to the user, no answer yet).

## Just done (2026-10-10): ROADMAP.md reorganised
- `docs/ROADMAP.md`: added an "At a glance" table. Open work is first (M21, M23 – M26). M20 and Releases sit under "Waits on a user check". M22 (all ticked) moved to the top of Done. No content lost. Not committed yet.

## Just done (2026-10-10): release v0.1.4-alpha
- Built from branch `feat/m23.3-book4-bends` (version bump commit, tag `v0.1.4-alpha` pushed). Pre-release with 4 files (win, linux, web zips + signed apk): https://github.com/Daddy-Ousen/innworld-rpg/releases/tag/v0.1.4-alpha
- Not done: the M23.3 PR is not merged yet. The itch.io / GitHub Pages web build is not re-uploaded.

## Just done (2026-10-10, local): M23.3 Book 4 canon bends (branch `feat/m23.3-book4-bends`)
- ADR 0036 "Book 4" lists every change. Data only (15 Book 4 chapter files), no engine change.
- Patch scripts were in the session scratchpad (`patch_m233*.py`: text edits per event block, keep CRLF; helpers
  `set_field`, `requires`, `optional`, `on_fail`, `add_alt`, `add_hook`). Gone next session; rebuild if needed.
- New `game/tests/sim_kill_book4.gd` (10): kills Erin, Zel, Ceria, Teriarch, Klbkch, Lyonette, Pisces on day 85;
  hook-per-day (9 days); cooking at the inn stove on day 96 changes the solstice dawn. Copy it for Book 5.
- `sim_kill_book3`: the Ceria and Pisces tests now see Erin home on day 91 (Book 4 hand-off), not still on the wagon.
- Tests run (all pass): `sim_kill_book4`, `sim_kill_book3`, `sim_kill_book2`, `sim_player_hooks` (110), `unit_canon_db`,
  `sim_divergence`, `sim_canon_book3..7`, `sim_book4_christmas`, `_homecoming`, `_mrsha`, `_relief_home`, `_wistram`;
  validator 0 / 0; Python 114 OK. Full suite not run. `docs/divergence/report.md` regenerated.
- Next: M23.4 Book 5 **[Opus · high]**. Picks: Ryoka, Erin, Laken, Venitra, Lyonette; key events in `docs/divergence/picks.md`
  (small chains: 5 dependents at most). Book 5 days 97 – 115.
- Gotchas: `horns_of_hammerad.bound_for_liscor` is set in Book 1 (1.47R) and never cleared until Book 4: use
  `horns_of_hammerad.left_celum` to test that the Horns left Celum. Cutting links reorders a day: watch a flag that
  one event sets and another clears on the same day (`ryoka.heading_home_to_liscor` broke `sim_book4_christmas` until
  Laken's request waited for Ryoka's replies). Chapter files have more top-level keys after `events` (insert alts
  before the first `
	}` after `"events": {`). The probe (`game/_scratch/probe.gd`, `extends SceneTree`, env BOOK,
  KILL_DAY, END_DAY, VICTIMS (comma, `+` for several, `none`), LIST=1) runs `Director.run` only: 11 victims in ~20 s.
  It is deleted; rebuild from `GameState.new_game` + `Director.run` + `Director.player_kill`.

## Earlier (2026-10-10): M23.2 Book 3 (merged, PR #156)
- `Director._wait_until`: a dependent waits while a dependency is delayed. `sim_kill_book3` is the model for the kill sims.

## Earlier (2026-10-10): M23.0 divergence report
- `tools/divergence_report.py`; rerun `python tools/divergence_report.py game/data/canon --out docs/divergence/report.md`
  after data changes (done for M23.1). "Pinned" = fails if that one NPC dies; "Lost" adds the same-book cascade.

## Just done (2026-10-10, local): M22.4 probe sim (branch `feat/m22.4-probe-sim`)
- New `game/tests/sim_breakthrough_probe.gd` (2 tests, ~3 min of sim): busy inn worker, quiet inn worker, fighter, days 1 – 87,
  3 seeds. Busy inn passes level 10 on night 31 – 32; quiet inn waits for its key until night 73; fighter level 10 on
  night 17 – 22. Table and decision in ADR 0035 "Probe result". No bar number changed. No code or data changed.
- Tests run: `sim_breakthrough_probe` (2 pass). Full suite not run. M22.3's state-file notes are committed here too.
- M22 is complete. Next: the user picks M23 (canon bends, **[Opus · high]** per book) or M21.6 (play pass). Start M23.0
  (`tools/divergence_report.py`, **[Sonnet · medium]**) first; it needs the user to pick key NPCs.
- Gotchas: a GutTest method named `_summary` makes a parse error ("Member is not a function"): the probe uses `_describe`
  and `_log_lines`. `BALANCE_LOG=<file>` writes every night row. 11 merged local branches (M21 / M22) can be cleaned up.

## Just done (2026-10-10, local): M22.3 consolidation (branch `feat/m22.3-consolidation`)
- Cherry-picked 565bc9b onto main (code + tests + DESIGN). Fixed the `rules.json` conflict by hand (kept
  `levels.breakthrough`, added `offers.consolidation_min_level: 10`). Old state-file edits from 565bc9b dropped.
- `unit_class_tree_step3` now calls `make_offers(gs, db, budget)` (no `kind`). New test in `unit_class_tree_step2`:
  consolidation waits for the source class's level 10 breakthrough; keys do not carry over.
- ADR 0035 "Steps" has the M22.3 build note. ROADMAP ticked.
- Tests run (all pass): `unit_class_system`, `unit_class_tree_step2`, `unit_class_tree_step3`, `unit_night`,
  `unit_system_messages`, `unit_journal`, `unit_game_state`, `unit_data_db`, `unit_breakthrough`, `sim_decline`;
  Python 107 OK; validator 0 errors. Full suite not run.
- PR #152 merged. Local branches `feat/class-tree-wiki` and `feat/m22.3-consolidation` deleted (user OK).
  Remote `origin/feat/class-tree-wiki` still exists. This note and the `progress.md` line are NOT committed yet:
  commit them on the M22.4 branch.
- Next: M22.4 probe sim **[Sonnet · high]**. 11 merged local branches (M21 / M22) can be cleaned up later.
- Gotchas: a source class that gets its canon key in night step 5b reaches level 10 there, so it consolidates on
  the NEXT night (step 4 runs before 5b). The Python test run prints validator ERROR lines from its fixtures: read
  only the `Ran` / `OK` lines.

## Just done (2026-10-10, local): M22.2 breakthrough data (branch `feat/m22.2-breakthrough-data`)
- `game/data/classes.json`: `breakthrough` {hint, trials} on innkeeper, cook, warrior, runner, mage, scout, priest, carpenter.
- Six `boon` hooks (tags effect) in `1.21`, `1.29`, `1.60`, `2.26`, `2.31`, `3.20T`. `sim_player_hooks` count is 74 now.
- Tests run (all pass): `unit_breakthrough` (17), `unit_data_db`, `unit_canon_db`, `unit_director`, `unit_player_hooks`,
  `sim_player_hooks`, `sim_canon_book1..3`; Python 107 OK; validator 0 errors. Full suite not run.
- Next: M22.3 consolidation **[Opus · medium]** (start from `git show 565bc9b`), then M22.4 probe sim **[Sonnet · high]**
  (tunes the bar numbers; they are guesses).
- Gotchas: all these data files are CRLF in the working copy: patch on bytes (scratchpad script), not `sed -i`.

## Just done (2026-10-10, local): M22.1 breakthrough engine (branch `feat/m22.1-breakthrough-engine`)
- New `game/core/breakthrough.gd` (sources 1 – 3, hint, key line, `validate`). `Night.resolve_xp` checks a waiting
  class before `level_up`; new `Night.level_lines` and `Night.resolve_canon_keys` (step 5b). `Director._fire` runs
  `boon` hooks (outcome stays, history `"boons"`, no `"by"`); `_player_hook` skips them. `_record_matches` is now
  public `Director.record_matches` (trials use it). `_apply_effects` takes `db` now.
- `rules.json` `levels.breakthrough` added (ADR numbers). No class has a `breakthrough` block yet; no canon hook
  uses `boon` yet. That is M22.2.
- Tests run (all pass): `unit_breakthrough` (new, 16), `unit_levels`, `unit_class_system`, `unit_night`,
  `unit_director`, `unit_canon_db`, `unit_player_hooks`, `unit_data_db`, `sim_canon_book1`; Python 107 OK;
  validator 0 errors. Full suite not run.
- Next: M22.2 data **[Sonnet · medium]**: trials + hints in `game/data/classes.json` for inn, cook, warrior, runner,
  mage, scout, priest, crafter; a few `boon` hooks (Books 1 – 3). Run `unit_breakthrough` (real-data test),
  `unit_data_db`, the validator, Python tests and `sim_canon_book1..3`.
- Gotchas: the Python validator only checks the `breakthrough` shape; class and tag ids are checked by
  `Breakthrough.validate` (in `DataDb.load_dir`). Toy capstone is 3, so toy classes wait at level 2.
  A heredoc `\` + newline lost the backslash in a Python patch: use the Edit tool for GDScript line breaks.

## Just done (2026-10-09, local): M22.0 breakthrough design (branch `docs/m22.0-breakthrough-design`)
- ADR `docs/adr/0035-breakthroughs.md`. User picks: all three sources (hard moment, class trial, canon `boon` hook),
  a moment counts only at level 9 / 19 / 29 (key kept until XP fills), a vague hint line. Docs only, no tests run.
- Schema changes the user approved (build them in M22.1): `rules.json` `levels.breakthrough`; optional `classes.json`
  `breakthrough` {hint, default, trials}; hook `"then": "boon"` (event runs as canon, no drift, hook effects apply);
  hook effect `breakthrough` {tags | class}. No save change.
- Next: M22.1 engine **[Opus · medium]**. Files: new `core/breakthrough.gd`, `core/night.gd` (step 2 check, step 5b
  level again), `core/director.gd` + `core/canon_db.gd` (boon), `core/data_db.gd` + `tools/validate_data.py` (checks).
- Gotchas: the director runs AFTER `resolve_xp`, so a canon key needs the step-5b `level_up`. A `change` hook adds
  0.25 drift; that is why `boon` is a new hook result. Records already store `risk`, `duress`, `window`.

## Just done (2026-10-09, local): M21.4 NPC art (branch `feat/m21.4-npc-art`)
- 35 new looks at the end of `game/data/appearance.json` (all Book 6 – 7 NPCs with a schedule that had none) and their sheets in `game/assets/characters/`. Portraits are cut from the sheets. `unit_art` and `unit_portrait` pass. Most looks are guesses (noted per look). The LPC clone was in the scratchpad (gone later). CREDITS.md was rewritten by the builder.
- Next: M21.6 play pass (user), then M22.0 (user picks how a breakthrough is earned).

## Just done (2026-10-09, local): M21.4 full suite (branch `fix/m21.4-red-tests`)
- Full run: 166 scripts, 6 red. Fixed 4: `sim_player_hooks` (68), `unit_cover` (bones half cover; estate plaque not solid), `unit_sign_art` (plaque sign), `unit_portal` (links form). Still red: `unit_art`, `unit_portrait` (35 NPCs have no sheet, 10 or so no portrait; list in the test output). User chose to make the art (option 2).
- Next: build the missing character sheets and portraits (needs the LPC clone, about 240 MB: ask the user first).

## Just done (2026-10-09, local): M21.5 (branch `docs/m21.5-legal`)
- Read https://wanderinginn.com/fanworks-permissions/ . Result in `docs/DESIGN.md` §7 and `docs/ITCH.md` ("Policy check"). Docs only.
- Open for the user: the policy bans book titles in marketing material; ask pirateaba or reword the itch.io and README text.

## Just done (2026-10-09, local): M21.3 (branch `chore/m21.3-export-cleanup`)
- Deleted local v0.1.0 – v0.1.2 builds in `export/` (still on GitHub releases). v0.1.3 files, `android/` and `itch/` kept. Docs only.
- Next: M21.4 (full suite; user asks), M21.5 (legal), M21.6 (play pass).

## Just done (2026-10-09, local): M21.2 (branch `chore/m21.2-docs`)
- README counts fixed (1,089 events, 296 NPCs, 122 places, 50 maps, 166 GUT scripts, 105 Python tests). Old detail from `progress.md` and `handoff.md` moved to `docs/PROGRESS_ARCHIVE.md`. Gotchas were not deduped.
- Next: M21.3 (delete old builds in `export/`; user confirms), M21.4 (full suite; user asks), M21.5 (legal, user).

## Just done (2026-10-09, local): M21.1 (branch `chore/m21.1-consolidation-decision`)
- Decision: 565bc9b is not merged now. Redo it in M22.3. Branch `feat/class-tree-wiki` stays as the source. Docs only.
- Next: M21.2 (docs cleanup).

## Just done (2026-10-09, local): M21.0 (branch `chore/m21.0-housekeeping`)
- Committed the stray `.uid`; deleted 39 merged local branches. Only `main` and `feat/class-tree-wiki` (unmerged, M21.1) remain. No tests needed (no code).
- Next: M21.1 (user decides on 565bc9b), then M21.2 docs. M22.0 needs a user design pick.

## Just done (2026-10-08, local): full project audit (read-only, branch `feat/magnolia-npcs`, PR 137 already merged)
- Findings are in `progress.md` "Audit". No code or data changed. Memory `targeted-tests` updated to match CLAUDE.md.
- Biggest bug: capstone level 10 is unreachable in play (no breakthrough source except the debug console). Check: `grep -rn grant_breakthrough game --include=*.gd`.
- Biggest vision gap: Books 2–7 events only `cancel` on failure; few hooks. The director cannot patch the story after Book 1.
- 2026-10-09: on `main`, pulled (at 1a94073). Findings are now modules M21 – M26 in `docs/ROADMAP.md` "Audit work".
  These ROADMAP / progress / handoff edits are NOT committed yet: commit them on a branch (`docs/audit-modules`) with M21.0.
- Next: start M21.0 (stray .uid, merged branches), then M22.0 (user picks how a breakthrough is earned).
- 2026-10-09: PR 138 merged. Each roadmap step M21 – M26 now ends with `[Model · effort]` (branch `docs/roadmap-model-tags`).
  The user runs Sonnet · medium by default; tell them to switch when a step says Opus or another effort.
- 2026-10-09: `docs/ROADMAP.md` reordered (branch `docs/roadmap-open-first`): "Next up" (M21 – M26) first, then "Open: waits on a user
  check" (M20, Releases), Later, then "Done (newest first)" M19 … M0. No line text changed. When a milestone is fully ticked, move it to the top of Done.

## Waiting on the user
- Merge the M19.P PR.
- Play a busy inn day and a winter walk to feel the new pace.
- Play fights with Skills, spells and cover; look at M14.6 / M14.7 colours and M16 maps; play Book 6 (`godot --path game`).
- Play with touch controls and Menu size (PC with touch screen; phone with the v0.1.2 browser build).

## Gotchas (XP)
- Work duress (M17.9) is computed only when the caller passes no `opts.duress`. A test that wants plain XP from a
  crowd action passes `{"duress": 1.0}`. `sim_balance_*` tables: run with `BALANCE_LOG=<file>`.
- A stage unit on `inn_hill` must not stand on the snow wall rects (`sim_winter` checks every stage).

## Touch notes (M20)
- A touch button sends `InputEventAction` press/release with `Input.parse_input_event` (buffered: tests call
  `Input.flush_buffered_events()`). Use parse_input_event for both press and release, never `Input.action_release`
  for one side only: a buffered press after a direct release leaves the action stuck down.
- `TouchControls.sync` runs every frame from `main._process`. When the pad hides it calls `release_all()`.
- A tap is an emulated mouse click with `device == InputEvent.DEVICE_ID_EMULATION`; the fight cell comes from
  `event.position` through `view.get_canvas_transform()`, not from the mouse pointer.
- Headless test windows are tiny (64 px): layout asserts about screen fit fail there. Check layout on a render.
- Renders in the cloud work (Mesa + Xvfb): write a throwaway `extends SceneTree` script, `await process_frame` once
  before loading scenes (autoloads), then
  `xvfb-run -a -s "-screen 0 1280x720x24" godot --path game --audio-driver Dummy --rendering-driver opengl3 --resolution 1152x648 -s res://_shot.gd -- <out dir>`
  and save `root.get_texture().get_image()` after `RenderingServer.frame_post_draw`. Delete the script after.
- Phone renders: `-screen 0 2400x1080x24 --resolution 2400x1080`, and in the script set the web stretch by hand
  (`root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS`, aspect EXPAND, size 1152 × 648): `.web`
  overrides do not apply under Xvfb. Set the scale with `Session.set_ui_scale_mode`, not `content_scale_factor`
  (Session re-applies its own factor on a resize). Point `ui_scale_path` / `touch_settings_path` at the out dir.
- UI scale (M20.3): a faked screen touch in a test makes Auto pick 200 % (the headless window is tiny). Reset with
  `Session.apply_ui_scale()` after `touch_seen = false`.

## Web build notes (ADR 0031, merged)
- Branch `feat/web-build` (from `docs/readme-rewrite`, so it holds the README PR #99 commits too).
- All export templates 4.7.2 are now installed in `%APPDATA%\Godot\export_templates\4.7.2.stable` (all platforms).
- `tools/release.ps1` makes `export/InnworldRPG-v<version>-web.zip` (index.html at the zip root, 70 MB).
- `.github/workflows/pages.yml`: on a published release (or by hand with a tag) it downloads the `*-web.zip`
  from the release and publishes it to Pages. It does not build. Pages must be set to "GitHub Actions" once.
- itch.io steps for the user: itch.io → Upload new project → Kind of project "HTML" → upload the web zip →
  tick "This file will be played in the browser" → Viewport 1152 x 648, tick "Fullscreen button" →
  Classification "Games", pricing "No payments" (non-commercial) → Save → set Visibility "Public".
- Own subdomain later: DNS CNAME `play.<domain>` → `daddy-ousen.github.io`; Settings → Pages → Custom domain;
  Enforce HTTPS. Nothing in the repo changes.
- Gotchas: the web build only scales with the `.web` stretch settings in `project.godot`. Browser saves are per site.
  `git checkout -- game/assets` before an export makes Godot reimport and can crash the export (known segfault):
  run `--import` once (twice if it crashes) before `tools/release.ps1`. The in-app browser `type` action does not
  reach Godot's input; Playwright `keyboard.type` works (open the console with `Backquote`, `sleep *` sleeps anywhere).


## Gotchas (release)
- Every export and `--import` rewrites many `.import` files (line ends). Run `git checkout -- game/assets` after.
- A release template ignores `-s`. Smoke-test a build with the editor console exe: `--headless --main-pack <exe> -s <script>`.
- The local class cache can be stale after cloud merges ("Identifier X not declared"): run `--import` once.
- Two untracked test `.uid` files came from cloud merges (`sim_book6_silver_swords`, `sim_book6_zel_dies`); committed on this branch.

## Gotchas (cloud)
- Chapter ids for non-numbered chapters follow the raw `index.json` id (for example `interlude_the_antinium_wars_pt_3`); the file name must match.
- A dead NPC is removed from `gs.npcs.npcs`: tests that read an NPC after its death use `gs.world.is_alive`.
- Character sheets in the cloud: sparse-clone the LPC generator into the scratchpad (about 240 MB, 1 – 2 min):
  `git clone --depth 1 --filter=blob:none --sparse <ULPC url> ulpc`, then `git -C ulpc sparse-checkout set --no-cone
  /CREDITS.csv /LICENSE /palette_definitions/ /sheet_definitions/ '/spritesheets/**/walk.png' ... '/spritesheets/weapon/'
  '/spritesheets/shield/'` (the list in "How to rebuild art"). No `MSYS_NO_PATHCONV` on Linux.
- `unit_map_db.test_real_exits_lead_back` has a `ONE_WAY` list (the Ruins chute). A new one-way exit goes there.
- The SessionStart hook works in a real cloud VM, but it cannot clone the private book repo. Fix: attach
  `Daddy-Ousen/innworld-canon-raw` (add_repo), `git clone --depth 1` it to `/home/user/innworld-canon-raw`, then
  `mkdir -p canon/raw; ln -s /home/user/innworld-canon-raw/book6 canon/raw/book6` (same for book7). `canon/raw/` is gitignored.
- Tag pushes are refused (HTTP 403). Write "tag pending: <tag> on <commit>" in progress.md; the user pushes tags locally.
- A cloud session can push only its own working branch: one sub-milestone per session, one PR.
- No screen in the cloud: "the user plays" checks wait. Renders under Xvfb work (CLAUDE.md, "Touch notes"). Plans live in `docs/plans/`, not `~/.claude/plans/`.
- Books 1–5 text is not in the cloud.
- A fresh `--import` takes about 100 s. `setup.sh` reverts `.import` files the import rewrites.
- On Windows `python3` is the Store alias (fails); use `python` locally. Linux uses `python3`.

## Gotchas
- M17.2 combat mode: a fight wait (`Commands.wait`) is ONE round (6 s), whatever seconds you pass; use
  `FightBot.wait_seconds` for "N seconds later" waves. A command refused for AP / move cap / turn changes
  nothing: loops must end the turn (`FightBot`). Frozen tests: `ToyCombat.freeze` (monster AP 0).
- M17.2: monsters and NPC allies may act before the player's first turn (Agility order), so a count of
  foes right after a stage starts can be one short; count `gs.combat.fight["foes"]` instead.
- Commits and PRs: author Daddy-Ousen only. NO `Co-Authored-By: Claude` trailer, no Claude footer.
- **Never use `sed -i` in Git Bash on repo files** - it strips CRLF. All working-copy text files are CRLF (autocrlf=true). Patch with Python on bytes (keep CRLF) or with the Edit tool. Do NOT normalise whole folders.
- `Commands.wait(gs, db, seconds)` takes SECONDS. The clock does pass midnight while awake, but the director only runs on sleep (`Commands.sleep(gs, db, Rest.ANYWHERE)`). Wake time is 6:00, so a stage before 6 is only reachable by staying up.
- A GUT test helper named `_set` clashes with `Object._set` (parse error).
- A stage starts only while its event is pending, the player is on the stage area, inside its hours and its `when_flags` hold (`Stage.is_open`).
- Scene stages place NPCs even off their schedule, but every placed NPC needs an `npc_behaviour` entry.
- Clearing an old "away" flag can wake an old schedule: 3.24 clears `horns_of_hammerad.gone_to_albez`, which put Pisces back on the Floodplains at night; fixed with `unless_flags` in_celum / left_celum.
- Talking to an NPC next to you gives `talk_with_guest` / `persuade` / `comfort_someone` (rules.npc.talk_actions) with the map's location as context; talking adds +1 relationship.
- Screenshots: a throwaway scene in `game/_scratch/` that adds `world/main.tscn` as a child (`add_child.call_deferred`), run with `godot --path game res://_scratch/shot.tscn`. Delete `game/_scratch` before committing.
- New `class_name` scripts need `godot --headless --path game --import` once.
- `-gtest=` is ignored; use `-gselect=<script name> -gdir=res://tests`.
- GUT exits 0 even on a parse error - grep for `Parse Error` and check the script count (92 on the M13.1 branch).
- Validator: `python tools/validate_data.py game/data/canon --all` (the folder with book<N> in it, not a book folder).
- Toy dbs erase `rules.economy`; real-db tests have hunger on.
- Rhir is real; Calruz stays missing; never link two canon entities unless the text says so (Ylawes is Yvlon's brother: 3.24 says so).
- Book 3 "E" chapters are Laken, not Erin. Laken's days: game day = his journal day + 45 in every book (ADR 0028).
  Geneva, Niers (3.22L) and Venitra use placeholder days.
- Save is v14 (M13.T traps; v13 = M10.0 portal trips). `MapDb` holds maps in `areas`; use `objects_on(area)` or `objects_near`, not `areas[a]['objects']`, so flag-hidden objects stay hidden. Enemy `danger` must be 0.0–1.0.
- Same-day canon order: Book 6+ chapter files carry `"order"`; events then run in chapter order and file order
  (M18.0). Books 1 – 5 still run in id order. Use `depends_on` only for a real dependency (a cancel spreads).
  Siblings that share one dependency run in that order too, so a sibling can clear a flag another still `requires` (M10.1: the rescue cleared `mrsha.fell_into_the_dungeon` before Toren's event). Debug with a throwaway `extends SceneTree` script that prints `gs.world.history` reasons. Helper-only waves come at once when no foe is left; put helper waves before the last foe wave.

- Octavia matters to Book 3: killing her before day 87 cancels 3.25's goodbye and the wagon leaving, which cascades. Kill tests for her must run after day 87.
- Scene stages: `Stage.place_npc` skips an NPC who is already in the stage area, so that NPC stays at their own post (M10.3: Lyonette, Mrsha in the inn). Only NPCs brought in from elsewhere take the stage tile. Hooks that need an NPC next to the player must name NPCs that really are placed.
- Scene `when_flags` are read during the day, before the night's events run: use a flag that is set by an earlier night.
- Python patching: converting line ends twice (LF to CRLF on a string that already has CRLF) leaves a stray CR, and git then shows the file as `-text` and changed in full. Check `git ls-files --eol` after patching.
- Never write a bash `cat > "$UNSET_VAR/..."` line without a heredoc: it waits on stdin and hangs the shell.

- Director dependencies are hard: an event whose `depends_on` was cancelled is cancelled too. Chain events only to events that always happen, or one dead NPC cancels a whole day (M10.4 cut the chains this way). Siblings run in id order, so name ids to sort in story order.
- Effects and scene flags: a flag set by an event on day N is visible on day N+1. An event set and cleared in the same night never shows in a schedule (`erin.at_esthelm`).
- Fight-stage tests: a helper that walks to `Pathfind.around(at)` can stop on a diagonal square and never attack. Walk to the four side squares instead (`sim_book4_christmas._fight_turn`). Strong allies that arrive at once can kill weak foes before the player strikes; delay the ally wave.
- A throwaway `extends SceneTree` script that errors before `quit()` hangs Godot headless forever. Use `_initialize()`, and run with `timeout 300`.

## M13 notes
- `MapDb.exit_at` hides gated exits after `sync_flags`; before the first sync every exit shows. Validators must
  use `raw_exit_at`.
- New object kinds use existing sheets: `stairs`, `ladder`, `tombstone`, `grave_cross`, `papers`. Every map
  object needs a kind with art (`unit_ground_art`).
- A new enemy needs: a sheet (or `look`), a voice entry in `audio.json` "enemies" (`unit_sound_cues`), and the
  counts in `unit_combat_db` / `unit_monster_art`. A new creature look also bumps `tools/tests/test_build_creatures.py`.
- A new map needs a mood in `audio.json` and, with spawns, a knock-out wake spot (`sim_liscor_depths` guard).
- Skeletons and zombies now spawn in the dungeon; `sim_skinner_night` allows that only for dungeon maps.
- Traps (M13.T): walking helpers (`ToyMaps.walk_to`) do not avoid hidden traps. A walking test through the
  depths must disarm them first (`gs.combat.traps[Traps.key(area, id)] = {"disarmed": true}`), or a pit drops the
  player into the crypt mid-walk. Use `Traps.key`, never build the key by hand.
- Git Bash heredocs eat a `\` at the end of a line even with `<<'EOF'`. Write Python patch scripts to the
  scratchpad with the Write tool, then run them.
- Godot on this machine: `godot` (WinGet link) returns at once while the real process keeps writing; wait for
  the `Godot_v4` process to exit before reading a log. Better (M13.3): call the console exe directly, it blocks and
  exits cleanly: `/c/Users/rhasa/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.7.2-stable_win64_console.exe`.
  The link segfaulted once on `--import` in M13.3.

## Audio notes (M12)
- Downloads are in an old session scratchpad (may be gone): Kenney RPG Audio + Impact Sounds, swishes, rubberduck
  creature + water packs (the water pack has loops: rain, bubbles, water; useful for M12.4). Re-download from CREDITS.md links.
- M12.4 loop cutter: `scratchpad/amb/loopify.py` (ffmpeg + numpy; gone next session). It cuts a stretch and
  cross-fades the tail into the head, then writes OGG. ffmpeg is on PATH (WinGet). Not in the repo on purpose (no
  new tool dependency). Raw downloads (fire.wav 10 MB, crowd zip 20 MB) stay out of git.
- Music still unused (CC0): RandomMind "Minstrel Dance" (5.3 MB), "Harvest Season" (8.2 MB); Sir Gawain's
  "CC0 Fantasy Music & Sounds" collection (curator; authors differ per track) has "Forest Ambience", "New Sunrise",
  "Cave Theme" (licence unclear: CC0 or OGA-BY). Ask the user before each download (file, source, size).
- Music `.import` files need `loop=true` (a Python patch on bytes after the first import).
- After adding audio run `godot --headless --path game --import`, then set `loop=true` in a music `.import`
  and import again. Then `git checkout -- game/assets/characters game/assets/objects game/assets/tiles`
  (import noise).
- `Audio` hooks every button through `get_tree().node_added`: menus need no audio code.
- Godot `--import` also rewrites the audio `.import` files with LF: `git checkout -- game/assets/audio` too.
- Never `git commit -am` on a branch with work in progress: it sweeps every changed file into the commit.

## How to rebuild art
- Object edits: `python tools/build_objects.py` then `godot --headless --path game --import`. Append new edits at the END of `EDITS` (the order sets the regions in objects.json). Print regions with `--print`.
- Character sheets: the LPC generator part clone is in the session scratchpad (gone next session). Make a new one
  (the fastest: all parts, only the animations we use plus the oversize weapon slashes; about 200 MB, 1 min):
  `MSYS_NO_PATHCONV=1 git -C ulpc sparse-checkout add '/spritesheets/**/walk.png' '/spritesheets/**/slash.png' '/spritesheets/**/hurt.png' '/spritesheets/**/idle.png' '/spritesheets/**/thrust.png' '/spritesheets/**/walk/' '/spritesheets/**/slash/' '/spritesheets/**/hurt/' '/spritesheets/**/idle/' '/spritesheets/**/thrust/' '/spritesheets/weapon/sword/arming/' '/spritesheets/weapon/blunt/waraxe/'`
  (a new look with another oversize weapon needs that weapon's `attack_slash` folder too).
  Or part by part:
  `git clone --depth 1 --filter=blob:none --sparse https://github.com/LiberatedPixelCup/Universal-LPC-Spritesheet-Character-Generator.git ulpc`
  then in Git Bash use `MSYS_NO_PATHCONV=1 git -C ulpc sparse-checkout set --no-cone /CREDITS.csv /LICENSE /palette_definitions/ /sheet_definitions/` and `... sparse-checkout add /spritesheets/<part folder>/` for each part folder (the folder is `layer_1.<body>` in the part's sheet definition).
- `python tools/build_sprites.py --ulpc <clone>` then `godot --headless --path game --import`.
- Creatures: `python tools/build_creatures.py` (no clone needed; sources in `tools/art/creatures/`).
- The clone now also needs `/spritesheets/weapon/` and `/spritesheets/shield/` in full (halberd, mace, saber,
  scimitar, bows, shields): `MSYS_NO_PATHCONV=1 git -C ulpc sparse-checkout add '/spritesheets/weapon/' '/spritesheets/shield/'`.
- Without `MSYS_NO_PATHCONV=1`, Git Bash turns `/palette_definitions/` into `C:/Program Files/Git/...`.

## Screenshot recipe (M16.1)
- Scratch scene `game/_scratch/shot.tscn` + `shot.gd` (`extends Node`, `_ready` calls a deferred coroutine). For each map id in `db.maps.areas`:
  a `SubViewport` sized `MapDb.size * WorldView.TILE` (`UPDATE_ALWAYS`) holds a `WorldView` from `res://world/world_view.tscn`;
  `v.setup(db.maps, {}, db.combat.enemies, {}, "winter")`; `gs = GameState.new(1)`; `gs.flags["winter"] = true` for winter;
  `gs.player.place(id, Vector2i(0,0))`; `v.refresh(gs, db)`; hide `v.player` and `v.atmosphere`; camera zoom 1; wait 4 frames;
  `get_texture().get_image().save_png`. Run with the console exe (not `--headless`): `OUT=<dir> WINTER=1 ONLY=id1,id2 Godot..._console.exe --path game res://_scratch/shot.tscn`.
- `godot --headless --import` may segfault (known) but still imports; then `git checkout -- game/assets/audio game/assets/fonts`.

## Graphics notes (M11)
- Core must not change for art. The view compares old and new state after each command and plays tweens; tweens never block input.
- Missing art must fall back to today's squares, so headless tests and new data never break.
- `.import` and `.uid` files are kept in git (ADR 0001). Run `godot --headless --path game --import` after adding art or scripts.
- The player marker moves at once; only the `CharacterSprite` child glides (tests read `player.position`).
- Monster markers: toy enemy types (`goblin`, `crab`) have no sheet and stay squares; `unit_world_view` checks their
  child order (edge, ring, body, label, bar). A sprite monster is (Ring, CharacterSprite, label, bar back, fill).
- A test that needs a sprite monster copies the toy goblin def to a real look id (`unit_monster_art.ART_GOBLIN`).
- Screenshot scenes: monsters added by hand with `Combat.add_monster` (no spawn entry) are removed by the first
  command (`Commands.attack`), and the view plays a fall for each. Change state by hand instead
  (`gs.combat.monsters.erase(id)`, `Combat.set_hp`).
- Part colours: a variant-folder part takes the file name as its colour (`kite_gray`, not `kite gray`).
  `body_zombie` needs a colour it cannot get: use body `male` with skin `zombie` / `zombie_green` and `heads_zombie`.
  `torso_clothes_tunic` has no male body.
- LPC tile packs: `lpc_terrains` fills: grass (1,10) + tufts (0..2,12), light grass tufts (3..4,12), dirt (1,3)/(1,5), grey cobble (13,3), snow (22,10)/(21..22,12), water (1,17), frozen dirt (25,12). `lpc_atlas`: pine (30,0,2,5), round tree (29,28,3,4), grey rock (28,26,1,1), stone wall face (17,24).
- Screenshots: `godot --path game --write-movie <file>.png --fixed-fps 10 --quit-after 12 res://_scratch/shot.tscn` (window is 1152x648; `--resolution` is ignored).
- M11.5 shot scene: `_scratch/shot.gd` reads AREA, X, Y, MINUTE, ZOOM (0 = keep 2), WINTER=1 from env vars;
  use `--quit-after 30` so snow has fallen. Stitch frames with PIL.
- M11.1 shot scene: a `_scratch/shot.gd` that makes a WorldView, a `GameState.new(1)`, `gs.player.place(AREA, pos)`, `v.refresh(gs)`, and sets `v.camera.zoom` (0.8 shows a whole 32x24 map). Read AREA/X/Y/ZOOM/WINTER from env vars. Winter: pass "winter" as the winter flag to `setup` and set `gs.flags["winter"]`.
- Terrain block layout (`lpc_terrains`, 3x6): rows 0-1 inner corners (SE gap (1,0), SW (2,0), NE (1,1), NW (2,1)), rows 2-4 ring, row 5 fills. Blocks used: dirt (0,0), cave (15,0), chasm (24,0), grass (0,7), light grass (3,7), snow wall (18,7), snow (21,7), frozen dirt (24,7), shallows water (0,14), light sea (24,14).
- Object regions are PIXELS in objects.json (tile props in tiles.json are CELLS).
- Picking art: a scratch `zoom.py` (crop + 16 px grid + px labels) was the fastest way to read exact pixel rects.

- M11.3: a fight screenshot is a `--write-movie` run (`--fixed-fps 20 --quit-after 30`) of a `_scratch` scene whose
  `_process` sends commands at set times (attack at 0.25 s, then `Combat.set_hp` to hurt the player); stitch frames with
  PIL. Freeze monsters (`act_seconds` huge) and set `rules.combat.hit` min/max 1.0. A hand-made NPC entry needs every
  field of `NpcSim` (`carry`, `route_i`, ...) or the sim errors.
- AnimDiff guesses swings from state (core has no hit log): a monster miss shows nothing; NPCs never swing.
- Weapon parts keep one file per colour (walk/<colour>.png): they need a `color` (sword "steel", spear "iron", waraxe "waraxe", dagger "dagger", staff "simple"). The `muscular` body has almost no clothes: use `male`.
- A look preview is fastest with a scratch `preview.py` that imports `build_sprites` and pastes the standing frames of each look into one image.
- Screenshots of NPCs: `_scratch/shot.gd` must be the script of a `_scratch/shot.tscn` (running the .gd alone opens the title menu). Fill `gs.npcs.npcs[id] = {"area", "x", "y", "facing"}` by hand to line up many NPCs.
- Godot `--import` rewrites some old `.import` files with LF; they show as changed with no content diff. `git checkout -- game/assets/objects game/assets/tiles` before committing.

